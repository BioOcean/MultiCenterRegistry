param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$TargetConfigPath = "./MultiCenterRegistry/appsettings.json",
    [string]$CatalogPath = "./Script/output/form_inventory/form_field_catalog.json",
    [string]$OutputDirectory = "./Script/output/quality_migration",
    [switch]$Export,
    [switch]$Execute,
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

if ($PlanOnly -or (-not $Export -and -not $Execute)) {
    Write-Host "质控迁移脚本计划："
    Write-Host "1. 读取旧库 MCR_Quality、MCR_QualityReject 和质控答案。"
    Write-Host "2. 生成 quality_report、quality_reject、migration_map、form_instance、form_field_value CSV。"
    Write-Host "3. 生成 07_import_quality.sql。"
    Write-Host "4. 指定 -Execute 时才调用 psql 写入 mcr 模式。"
    return
}

if ([string]::IsNullOrWhiteSpace($SourceConnection)) {
    throw "请先通过环境变量 MCR_SOURCE_SQLSERVER 或参数 SourceConnection 提供旧库连接字符串。"
}

function Read-JsonArray {
    param([string]$Path)

    $data = Get-Content -Path $Path -Raw | ConvertFrom-Json
    if ($data -is [array]) {
        return $data
    }

    return @($data)
}

function ConvertTo-StableGuid {
    param([string]$Value)

    $md5 = [System.Security.Cryptography.MD5]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
        $hash = $md5.ComputeHash($bytes)
        return [Guid]::new($hash).ToString()
    } finally {
        $md5.Dispose()
    }
}

function Get-DbValue {
    param(
        [System.Data.DataRow]$Row,
        [string]$Name
    )

    $value = $Row[$Name]
    if ($value -is [System.DBNull]) {
        return ""
    }

    return [string]$value
}

function Get-DateValue {
    param(
        [System.Data.DataRow]$Row,
        [string]$Name
    )

    $value = $Row[$Name]
    if ($value -is [System.DBNull]) {
        return ""
    }

    return ([datetime]$value).ToString("yyyy-MM-dd HH:mm:ss")
}

function Invoke-SourceQuery {
    param(
        [object]$Connection,
        [string]$Sql
    )

    $command = $Connection.CreateCommand()
    $command.CommandText = $Sql
    $command.CommandTimeout = 600
    $reader = $command.ExecuteReader()
    $table = New-Object System.Data.DataTable
    $table.Load($reader)
    return ,$table
}

function ConvertTo-SqlText {
    param([string]$Value)

    return "'" + $Value.Replace("'", "''") + "'"
}

function ConvertTo-ImportPath {
    param([string]$Path)

    return (Resolve-Path $Path).Path.Replace("\", "/")
}

function Write-ImportSql {
    param(
        [string]$Path,
        [string]$QualityCsv,
        [string]$RejectCsv,
        [string]$MapCsv,
        [string]$InstanceCsv,
        [string]$ValueCsv
    )

    $qualityPath = ConvertTo-SqlText (ConvertTo-ImportPath $QualityCsv)
    $rejectPath = ConvertTo-SqlText (ConvertTo-ImportPath $RejectCsv)
    $mapPath = ConvertTo-SqlText (ConvertTo-ImportPath $MapCsv)
    $instancePath = ConvertTo-SqlText (ConvertTo-ImportPath $InstanceCsv)
    $valuePath = ConvertTo-SqlText (ConvertTo-ImportPath $ValueCsv)

    $sql = @"
set temp_buffers = '512MB';
begin;

create temp table tmp_quality_report (
    id text, old_quality_id text, name text, quality_date text, template_id text,
    hospital_id text, status text, quality_user_id text, created_at text,
    created_by text, updated_at text
);
\copy tmp_quality_report from $qualityPath with (format csv, header true);

insert into mcr.quality_report (
    id, old_quality_id, name, quality_date, template_id, hospital_id, status,
    quality_user_id, created_at, created_by, updated_at
)
select
    id::uuid,
    old_quality_id,
    coalesce(nullif(name, ''), '质控上报'),
    coalesce(nullif(quality_date, '')::timestamp, now()),
    nullif(template_id, ''),
    nullif(hospital_id, ''),
    coalesce(nullif(status, '')::integer, 0),
    nullif(quality_user_id, ''),
    coalesce(nullif(created_at, '')::timestamp, now()),
    nullif(created_by, ''),
    nullif(updated_at, '')::timestamp
from tmp_quality_report
on conflict (old_quality_id) do update set
    name = excluded.name,
    quality_date = excluded.quality_date,
    template_id = excluded.template_id,
    hospital_id = excluded.hospital_id,
    status = excluded.status,
    quality_user_id = excluded.quality_user_id,
    created_at = excluded.created_at,
    created_by = excluded.created_by,
    updated_at = excluded.updated_at;

create temp table tmp_quality_reject (
    id text, quality_report_id text, content text, created_at text, created_by text
);
\copy tmp_quality_reject from $rejectPath with (format csv, header true);

insert into mcr.quality_reject (id, quality_report_id, content, created_at, created_by)
select
    id::uuid,
    quality_report_id::uuid,
    coalesce(nullif(content, ''), ''),
    coalesce(nullif(created_at, '')::timestamp, now()),
    nullif(created_by, '')
from tmp_quality_reject
on conflict (id) do update set
    quality_report_id = excluded.quality_report_id,
    content = excluded.content,
    created_at = excluded.created_at,
    created_by = excluded.created_by;

create temp table tmp_migration_map (
    id text, source_table text, source_id text, target_table text, target_id text, created_at text
);
\copy tmp_migration_map from $mapPath with (format csv, header true);

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select id::uuid, source_table, source_id, target_table, target_id::uuid, coalesce(nullif(created_at, '')::timestamp, now())
from tmp_migration_map
on conflict (source_table, source_id) do update set
    target_table = excluded.target_table,
    target_id = excluded.target_id;

create temp table tmp_form_instance (
    id text, owner_type text, owner_id text, form_template_id text, form_template_map_id text,
    source_card_id text, source_custom_form_id text, source_follow_template_id text,
    status text, created_at text, created_by text, updated_at text, updated_by text
);
\copy tmp_form_instance from $instancePath with (format csv, header true);

insert into mcr.form_instance (
    id, owner_type, owner_id, form_template_id, form_template_map_id, source_card_id,
    source_custom_form_id, source_follow_template_id, status, created_at, created_by,
    updated_at, updated_by
)
select
    id::uuid,
    owner_type,
    owner_id::uuid,
    form_template_id::uuid,
    nullif(form_template_map_id, '')::uuid,
    nullif(source_card_id, ''),
    nullif(source_custom_form_id, ''),
    nullif(source_follow_template_id, ''),
    coalesce(nullif(status, '')::integer, 0),
    coalesce(nullif(created_at, '')::timestamp, now()),
    nullif(created_by, ''),
    nullif(updated_at, '')::timestamp,
    nullif(updated_by, '')
from tmp_form_instance
on conflict (id) do update set
    owner_type = excluded.owner_type,
    owner_id = excluded.owner_id,
    form_template_id = excluded.form_template_id,
    form_template_map_id = excluded.form_template_map_id,
    source_card_id = excluded.source_card_id,
    source_custom_form_id = excluded.source_custom_form_id,
    source_follow_template_id = excluded.source_follow_template_id,
    status = excluded.status,
    updated_at = excluded.updated_at,
    updated_by = excluded.updated_by;

create temp table tmp_form_field_value (
    id text, form_instance_id text, form_field_definition_id text, storage_key text,
    source_answer_id text, source_subject_id text, field_code text, field_name text,
    field_value text, field_text text, sort text, created_at text, created_by text,
    updated_at text, updated_by text
);
\copy tmp_form_field_value from $valuePath with (format csv, header true);

insert into mcr.form_field_value (
    id, form_instance_id, form_field_definition_id, storage_key, source_answer_id,
    source_subject_id, field_code, field_name, field_value, field_text, sort,
    created_at, created_by, updated_at, updated_by
)
select
    id::uuid,
    form_instance_id::uuid,
    nullif(form_field_definition_id, '')::uuid,
    storage_key,
    nullif(source_answer_id, ''),
    nullif(source_subject_id, ''),
    field_code,
    field_name,
    nullif(field_value, ''),
    nullif(field_text, ''),
    coalesce(nullif(sort, '')::integer, 0),
    coalesce(nullif(created_at, '')::timestamp, now()),
    nullif(created_by, ''),
    nullif(updated_at, '')::timestamp,
    nullif(updated_by, '')
from tmp_form_field_value
on conflict (id) do update set
    form_instance_id = excluded.form_instance_id,
    form_field_definition_id = excluded.form_field_definition_id,
    storage_key = excluded.storage_key,
    source_answer_id = excluded.source_answer_id,
    source_subject_id = excluded.source_subject_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    field_value = excluded.field_value,
    field_text = excluded.field_text,
    sort = excluded.sort,
    updated_at = excluded.updated_at,
    updated_by = excluded.updated_by;

commit;
"@

    [System.IO.File]::WriteAllText($Path, $sql, [System.Text.UTF8Encoding]::new($true))
}

function Invoke-PsqlFile {
    param(
        [string]$ConfigPath,
        [string]$SqlPath
    )

    $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    $connectionString = $config.ConnectionStrings.DefaultConnection
    $parts = @{}
    $connectionString -split ";" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
        $kv = $_.Split("=", 2)
        $parts[$kv[0].Trim()] = $kv[1].Trim()
    }
    $hostParts = $parts.Host.Split(":", 2)
    $env:PGPASSWORD = $parts.Password
    & psql -v ON_ERROR_STOP=1 -h $hostParts[0] -p $hostParts[1] -U $parts.Username -d $parts.Database -f $SqlPath
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

try {
    Add-Type -AssemblyName "Microsoft.Data.SqlClient"
    $connectionType = "Microsoft.Data.SqlClient.SqlConnection"
} catch {
    Add-Type -AssemblyName "System.Data"
    $connectionType = "System.Data.SqlClient.SqlConnection"
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

$catalog = Read-JsonArray $CatalogPath
$qualityFormByTemplate = @{}
$qualityFormByCustomForm = @{}
$fieldByFormSubject = @{}

foreach ($form in $catalog) {
    $formTemplateId = ConvertTo-StableGuid "form-template:$($form.custom_form_id)"

    foreach ($map in @($form.templates)) {
        if ($map.type_name -eq "质控") {
            $mapId = ConvertTo-StableGuid "form-template-map:quality:$($map.follow_template_id):$($form.custom_form_id)"
            $qualityFormByTemplate[[string]$map.follow_template_id] = [pscustomobject]@{
                CustomFormId = [string]$form.custom_form_id
                FormTemplateId = $formTemplateId
                FormTemplateMapId = $mapId
                FollowTemplateId = [string]$map.follow_template_id
            }
            $qualityFormByCustomForm[[string]$form.custom_form_id] = [pscustomobject]@{
                CustomFormId = [string]$form.custom_form_id
                FormTemplateId = $formTemplateId
                FormTemplateMapId = $mapId
                FollowTemplateId = [string]$map.follow_template_id
            }
        }
    }

    foreach ($field in @($form.fields)) {
        $fieldId = ConvertTo-StableGuid "form-field:$($form.custom_form_id):$($field.storage_key)"
        $fieldByFormSubject["$($form.custom_form_id)|$($field.subject_id)"] = [pscustomobject]@{
            Id = $fieldId
            StorageKey = [string]$field.storage_key
            FieldCode = [string]$field.field_code
            FieldName = [string]$field.field_name
            Sort = [int]$field.sort
        }
    }
}

$connection = New-Object $connectionType $SourceConnection
$qualityRows = [System.Collections.Generic.List[object]]::new()
$rejectRows = [System.Collections.Generic.List[object]]::new()
$mapRows = [System.Collections.Generic.List[object]]::new()
$instanceRows = [System.Collections.Generic.List[object]]::new()
$valueRows = [System.Collections.Generic.List[object]]::new()
$instanceKeys = [System.Collections.Generic.HashSet[string]]::new()
$skippedAnswers = 0
$missingTemplateRows = 0

try {
    $connection.Open()

    $qualities = Invoke-SourceQuery -Connection $connection -Sql @"
select ID, Name, QualityDate, TemplateID, CustomFormID, HospitalID, Status,
       QualityUser, CreateUserID, CreateTime, UpdateTime
from MCR_Quality
order by QualityDate, ID
"@

    foreach ($row in $qualities.Rows) {
        $oldQualityId = Get-DbValue $row "ID"
        $qualityId = ConvertTo-StableGuid "quality:$oldQualityId"
        $createdAt = Get-DateValue $row "CreateTime"
        $updatedAt = Get-DateValue $row "UpdateTime"
        $templateId = Get-DbValue $row "TemplateID"
        $customFormId = Get-DbValue $row "CustomFormID"

        $qualityRows.Add([pscustomobject]@{
            id = $qualityId
            old_quality_id = $oldQualityId
            name = Get-DbValue $row "Name"
            quality_date = Get-DateValue $row "QualityDate"
            template_id = $templateId
            hospital_id = Get-DbValue $row "HospitalID"
            status = Get-DbValue $row "Status"
            quality_user_id = Get-DbValue $row "QualityUser"
            created_at = $createdAt
            created_by = Get-DbValue $row "CreateUserID"
            updated_at = $updatedAt
        })

        $mapRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "migration-map:MCR_Quality:$oldQualityId"
            source_table = "MCR_Quality"
            source_id = $oldQualityId
            target_table = "mcr.quality_report"
            target_id = $qualityId
            created_at = $createdAt
        })

        $formMap = $null
        if (-not [string]::IsNullOrWhiteSpace($customFormId) -and $qualityFormByCustomForm.ContainsKey($customFormId)) {
            $formMap = $qualityFormByCustomForm[$customFormId]
        } elseif (-not [string]::IsNullOrWhiteSpace($templateId) -and $qualityFormByTemplate.ContainsKey($templateId)) {
            $formMap = $qualityFormByTemplate[$templateId]
        }

        if ($null -ne $formMap) {
            $instanceKey = "$oldQualityId|$($formMap.CustomFormId)"
            if ($instanceKeys.Add($instanceKey)) {
                $instanceRows.Add([pscustomobject]@{
                    id = ConvertTo-StableGuid "form-instance:quality:$instanceKey"
                    owner_type = "quality"
                    owner_id = $qualityId
                    form_template_id = $formMap.FormTemplateId
                    form_template_map_id = $formMap.FormTemplateMapId
                    source_card_id = $oldQualityId
                    source_custom_form_id = $formMap.CustomFormId
                    source_follow_template_id = $formMap.FollowTemplateId
                    status = Get-DbValue $row "Status"
                    created_at = $createdAt
                    created_by = Get-DbValue $row "CreateUserID"
                    updated_at = $updatedAt
                    updated_by = ""
                })
            }
        } else {
            $missingTemplateRows++
        }
    }

    $rejects = Invoke-SourceQuery -Connection $connection -Sql @"
select ID, QualityID, Content, CreateUserID, CreateTime, UpadteTime
from MCR_QualityReject
order by CreateTime, ID
"@

    foreach ($row in $rejects.Rows) {
        $oldRejectId = Get-DbValue $row "ID"
        $oldQualityId = Get-DbValue $row "QualityID"
        $rejectId = ConvertTo-StableGuid "quality-reject:$oldRejectId"
        $qualityId = ConvertTo-StableGuid "quality:$oldQualityId"
        $createdAt = Get-DateValue $row "CreateTime"

        $rejectRows.Add([pscustomobject]@{
            id = $rejectId
            quality_report_id = $qualityId
            content = Get-DbValue $row "Content"
            created_at = $createdAt
            created_by = Get-DbValue $row "CreateUserID"
        })

        $mapRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "migration-map:MCR_QualityReject:$oldRejectId"
            source_table = "MCR_QualityReject"
            source_id = $oldRejectId
            target_table = "mcr.quality_reject"
            target_id = $rejectId
            created_at = $createdAt
        })
    }

    $answers = Invoke-SourceQuery -Connection $connection -Sql @"
select a.ID, a.CardID, a.SubjectID, a.Sort, cast(a.Answer as nvarchar(max)) as Answer,
       cast(a.HisAnswer as nvarchar(max)) as HisAnswer, a.CreateUserID, a.CreateTime,
       a.UpdateTime, a.CustomFormID, q.TemplateID
from CM_CAHD_Care_CustomFormAnswer a
inner join MCR_Quality q on q.ID = a.CardID
where a.CustomFormID is not null
order by a.CardID, a.Sort, a.ID
"@

    foreach ($row in $answers.Rows) {
        $oldQualityId = Get-DbValue $row "CardID"
        $customFormId = Get-DbValue $row "CustomFormID"
        $subjectId = Get-DbValue $row "SubjectID"
        $fieldKey = "$customFormId|$subjectId"

        if (-not $fieldByFormSubject.ContainsKey($fieldKey)) {
            $skippedAnswers++
            continue
        }

        $templateId = Get-DbValue $row "TemplateID"
        $qualityId = ConvertTo-StableGuid "quality:$oldQualityId"
        $formTemplateId = ConvertTo-StableGuid "form-template:$customFormId"
        $formTemplateMapId = ""
        $followTemplateId = $templateId
        if ($qualityFormByCustomForm.ContainsKey($customFormId)) {
            $formTemplateMapId = $qualityFormByCustomForm[$customFormId].FormTemplateMapId
            $followTemplateId = $qualityFormByCustomForm[$customFormId].FollowTemplateId
        }

        $instanceKey = "$oldQualityId|$customFormId"
        $instanceId = ConvertTo-StableGuid "form-instance:quality:$instanceKey"
        if ($instanceKeys.Add($instanceKey)) {
            $instanceRows.Add([pscustomobject]@{
                id = $instanceId
                owner_type = "quality"
                owner_id = $qualityId
                form_template_id = $formTemplateId
                form_template_map_id = $formTemplateMapId
                source_card_id = $oldQualityId
                source_custom_form_id = $customFormId
                source_follow_template_id = $followTemplateId
                status = "0"
                created_at = Get-DateValue $row "CreateTime"
                created_by = Get-DbValue $row "CreateUserID"
                updated_at = Get-DateValue $row "UpdateTime"
                updated_by = ""
            })
        }

        $field = $fieldByFormSubject[$fieldKey]
        $answerId = Get-DbValue $row "ID"
        $valueRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "form-field-value:quality:$answerId"
            form_instance_id = $instanceId
            form_field_definition_id = $field.Id
            storage_key = $field.StorageKey
            source_answer_id = $answerId
            source_subject_id = $subjectId
            field_code = $field.FieldCode
            field_name = $field.FieldName
            field_value = Get-DbValue $row "Answer"
            field_text = Get-DbValue $row "HisAnswer"
            sort = if ([string]::IsNullOrWhiteSpace((Get-DbValue $row "Sort"))) { $field.Sort } else { Get-DbValue $row "Sort" }
            created_at = Get-DateValue $row "CreateTime"
            created_by = Get-DbValue $row "CreateUserID"
            updated_at = Get-DateValue $row "UpdateTime"
            updated_by = ""
        })
    }
} finally {
    $connection.Dispose()
}

$qualityCsv = Join-Path $OutputDirectory "quality_report.csv"
$rejectCsv = Join-Path $OutputDirectory "quality_reject.csv"
$mapCsv = Join-Path $OutputDirectory "migration_map_quality.csv"
$instanceCsv = Join-Path $OutputDirectory "form_instance_quality.csv"
$valueCsv = Join-Path $OutputDirectory "form_field_value_quality.csv"
$importSql = Join-Path $OutputDirectory "07_import_quality.sql"

$qualityRows | Export-Csv -Path $qualityCsv -NoTypeInformation -Encoding utf8BOM
$rejectRows | Export-Csv -Path $rejectCsv -NoTypeInformation -Encoding utf8BOM
$mapRows | Export-Csv -Path $mapCsv -NoTypeInformation -Encoding utf8BOM
$instanceRows | Export-Csv -Path $instanceCsv -NoTypeInformation -Encoding utf8BOM
$valueRows | Export-Csv -Path $valueCsv -NoTypeInformation -Encoding utf8BOM
Write-ImportSql -Path $importSql -QualityCsv $qualityCsv -RejectCsv $rejectCsv -MapCsv $mapCsv -InstanceCsv $instanceCsv -ValueCsv $valueCsv

$report = [pscustomobject]@{
    quality_count = $qualityRows.Count
    quality_reject_count = $rejectRows.Count
    migration_map_count = $mapRows.Count
    form_instance_count = $instanceRows.Count
    form_field_value_count = $valueRows.Count
    skipped_answer_count = $skippedAnswers
    missing_template_quality_count = $missingTemplateRows
    output_directory = (Resolve-Path $OutputDirectory).Path
}

$report | ConvertTo-Json -Depth 4 | Set-Content -Path (Join-Path $OutputDirectory "quality_migration_report.json") -Encoding utf8BOM
$report | ConvertTo-Json -Depth 4

if ($Execute) {
    Invoke-PsqlFile -ConfigPath $TargetConfigPath -SqlPath $importSql
}
