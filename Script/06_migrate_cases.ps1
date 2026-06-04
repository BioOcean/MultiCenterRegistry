param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$TargetConfigPath = "./MultiCenterRegistry/appsettings.json",
    [string]$CatalogPath = "./Script/output/form_inventory/form_field_catalog.json",
    [string]$OutputDirectory = "./Script/output/case_migration",
    [switch]$Export,
    [switch]$Execute,
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

if ($PlanOnly -or (-not $Export -and -not $Execute)) {
    Write-Host "病例迁移脚本计划："
    Write-Host "1. 读取旧库 MCR_Case 和病例答案。"
    Write-Host "2. 生成 case_record、migration_map、form_instance、form_field_value 四个 CSV。"
    Write-Host "3. 生成 06_import_cases.sql。"
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
    $command.CommandTimeout = 300
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
        [string]$CaseCsv,
        [string]$MapCsv,
        [string]$InstanceCsv,
        [string]$ValueCsv
    )

    $casePath = ConvertTo-SqlText (ConvertTo-ImportPath $CaseCsv)
    $mapPath = ConvertTo-SqlText (ConvertTo-ImportPath $MapCsv)
    $instancePath = ConvertTo-SqlText (ConvertTo-ImportPath $InstanceCsv)
    $valuePath = ConvertTo-SqlText (ConvertTo-ImportPath $ValueCsv)

    $sql = @"
set temp_buffers = '512MB';
begin;

create temp table tmp_case_record (
    id text, old_case_id text, patient_name text, patient_sex text, patient_age text,
    id_number text, patient_number text, disease_id text, hospital_id text, department_id text,
    operator_id text, admission_time text, discharge_time text, operation_time text,
    status text, sub_status text, sort text, created_at text, created_by text,
    updated_at text, updated_by text
);
\copy tmp_case_record from $casePath with (format csv, header true);

insert into mcr.case_record (
    id, old_case_id, patient_name, patient_sex, patient_age, id_number, patient_number,
    disease_id, hospital_id, department_id, operator_id, admission_time, discharge_time,
    operation_time, status, sub_status, sort, created_at, created_by, updated_at, updated_by
)
select
    id::uuid,
    old_case_id,
    coalesce(nullif(patient_name, ''), '未命名'),
    nullif(patient_sex, ''),
    nullif(patient_age, ''),
    nullif(id_number, ''),
    nullif(patient_number, ''),
    nullif(disease_id, ''),
    nullif(hospital_id, ''),
    nullif(department_id, ''),
    nullif(operator_id, ''),
    nullif(admission_time, '')::timestamp,
    nullif(discharge_time, '')::timestamp,
    nullif(operation_time, '')::timestamp,
    coalesce(nullif(status, '')::integer, 0),
    coalesce(nullif(sub_status, '')::integer, 0),
    coalesce(nullif(sort, '')::integer, 0),
    coalesce(nullif(created_at, '')::timestamp, now()),
    nullif(created_by, ''),
    nullif(updated_at, '')::timestamp,
    nullif(updated_by, '')
from tmp_case_record
on conflict (old_case_id) do update set
    patient_name = excluded.patient_name,
    patient_sex = excluded.patient_sex,
    patient_age = excluded.patient_age,
    id_number = excluded.id_number,
    patient_number = excluded.patient_number,
    disease_id = excluded.disease_id,
    hospital_id = excluded.hospital_id,
    department_id = excluded.department_id,
    operator_id = excluded.operator_id,
    admission_time = excluded.admission_time,
    discharge_time = excluded.discharge_time,
    operation_time = excluded.operation_time,
    status = excluded.status,
    sub_status = excluded.sub_status,
    sort = excluded.sort,
    created_at = excluded.created_at,
    created_by = excluded.created_by,
    updated_at = excluded.updated_at,
    updated_by = excluded.updated_by;

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
$caseFormByTemplate = @{}
$fieldByFormSubject = @{}

foreach ($form in $catalog) {
    $formTemplateId = ConvertTo-StableGuid "form-template:$($form.custom_form_id)"

    foreach ($map in @($form.templates)) {
        if ($map.type_name -eq "病例") {
            $mapId = ConvertTo-StableGuid "form-template-map:case:$($map.follow_template_id):$($form.custom_form_id)"
            $caseFormByTemplate[[string]$map.follow_template_id] = [pscustomobject]@{
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
$caseRows = [System.Collections.Generic.List[object]]::new()
$mapRows = [System.Collections.Generic.List[object]]::new()
$instanceRows = [System.Collections.Generic.List[object]]::new()
$valueRows = [System.Collections.Generic.List[object]]::new()
$instanceKeys = [System.Collections.Generic.HashSet[string]]::new()
$skippedAnswers = 0

try {
    $connection.Open()

    $cases = Invoke-SourceQuery -Connection $connection -Sql @"
select ID, PTSex, PTName, PTAge, DiseaseID, Status, SubStatus, IDNumber, PatNum,
       Operator, GetInTime, GetOutTime, OperationTime, DepartmentID, HospitalID,
       CreateUserID, UpdateUserID, CreateTime, UpdateTime, Sort
from MCR_Case
order by CreateTime, ID
"@

    foreach ($row in $cases.Rows) {
        $oldCaseId = Get-DbValue $row "ID"
        $caseId = ConvertTo-StableGuid "case:$oldCaseId"
        $createdAt = Get-DateValue $row "CreateTime"
        $updatedAt = Get-DateValue $row "UpdateTime"
        $diseaseId = Get-DbValue $row "DiseaseID"

        $caseRows.Add([pscustomobject]@{
            id = $caseId
            old_case_id = $oldCaseId
            patient_name = Get-DbValue $row "PTName"
            patient_sex = Get-DbValue $row "PTSex"
            patient_age = Get-DbValue $row "PTAge"
            id_number = Get-DbValue $row "IDNumber"
            patient_number = Get-DbValue $row "PatNum"
            disease_id = $diseaseId
            hospital_id = Get-DbValue $row "HospitalID"
            department_id = Get-DbValue $row "DepartmentID"
            operator_id = Get-DbValue $row "Operator"
            admission_time = Get-DateValue $row "GetInTime"
            discharge_time = Get-DateValue $row "GetOutTime"
            operation_time = Get-DateValue $row "OperationTime"
            status = Get-DbValue $row "Status"
            sub_status = Get-DbValue $row "SubStatus"
            sort = Get-DbValue $row "Sort"
            created_at = $createdAt
            created_by = Get-DbValue $row "CreateUserID"
            updated_at = $updatedAt
            updated_by = Get-DbValue $row "UpdateUserID"
        })

        $mapRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "migration-map:MCR_Case:$oldCaseId"
            source_table = "MCR_Case"
            source_id = $oldCaseId
            target_table = "mcr.case_record"
            target_id = $caseId
            created_at = $createdAt
        })

        if ($caseFormByTemplate.ContainsKey($diseaseId)) {
            $formMap = $caseFormByTemplate[$diseaseId]
            $instanceKey = "$oldCaseId|$($formMap.CustomFormId)"
            if ($instanceKeys.Add($instanceKey)) {
                $instanceRows.Add([pscustomobject]@{
                    id = ConvertTo-StableGuid "form-instance:case:$instanceKey"
                    owner_type = "case"
                    owner_id = $caseId
                    form_template_id = $formMap.FormTemplateId
                    form_template_map_id = $formMap.FormTemplateMapId
                    source_card_id = $oldCaseId
                    source_custom_form_id = $formMap.CustomFormId
                    source_follow_template_id = $formMap.FollowTemplateId
                    status = "0"
                    created_at = $createdAt
                    created_by = Get-DbValue $row "CreateUserID"
                    updated_at = $updatedAt
                    updated_by = Get-DbValue $row "UpdateUserID"
                })
            }
        }
    }

    $answers = Invoke-SourceQuery -Connection $connection -Sql @"
select a.ID, a.CardID, a.SubjectID, a.Sort, cast(a.Answer as nvarchar(max)) as Answer,
       cast(a.HisAnswer as nvarchar(max)) as HisAnswer, a.CreateUserID, a.CreateTime,
       a.UpdateTime, a.CustomFormID, c.DiseaseID
from CM_CAHD_Care_CustomFormAnswer a
inner join MCR_Case c on c.ID = a.CardID
where a.CustomFormID is not null
order by a.CardID, a.Sort, a.ID
"@

    foreach ($row in $answers.Rows) {
        $oldCaseId = Get-DbValue $row "CardID"
        $customFormId = Get-DbValue $row "CustomFormID"
        $subjectId = Get-DbValue $row "SubjectID"
        $fieldKey = "$customFormId|$subjectId"

        if (-not $fieldByFormSubject.ContainsKey($fieldKey)) {
            $skippedAnswers++
            continue
        }

        $diseaseId = Get-DbValue $row "DiseaseID"
        $caseId = ConvertTo-StableGuid "case:$oldCaseId"
        $formTemplateId = ConvertTo-StableGuid "form-template:$customFormId"
        $formTemplateMapId = ""
        $followTemplateId = $diseaseId
        if ($caseFormByTemplate.ContainsKey($diseaseId)) {
            $formTemplateMapId = $caseFormByTemplate[$diseaseId].FormTemplateMapId
        }

        $instanceKey = "$oldCaseId|$customFormId"
        $instanceId = ConvertTo-StableGuid "form-instance:case:$instanceKey"
        if ($instanceKeys.Add($instanceKey)) {
            $instanceRows.Add([pscustomobject]@{
                id = $instanceId
                owner_type = "case"
                owner_id = $caseId
                form_template_id = $formTemplateId
                form_template_map_id = $formTemplateMapId
                source_card_id = $oldCaseId
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
            id = ConvertTo-StableGuid "form-field-value:case:$answerId"
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

$caseCsv = Join-Path $OutputDirectory "case_record.csv"
$mapCsv = Join-Path $OutputDirectory "migration_map_case.csv"
$instanceCsv = Join-Path $OutputDirectory "form_instance_case.csv"
$valueCsv = Join-Path $OutputDirectory "form_field_value_case.csv"
$importSql = Join-Path $OutputDirectory "06_import_cases.sql"

$caseRows | Export-Csv -Path $caseCsv -NoTypeInformation -Encoding utf8BOM
$mapRows | Export-Csv -Path $mapCsv -NoTypeInformation -Encoding utf8BOM
$instanceRows | Export-Csv -Path $instanceCsv -NoTypeInformation -Encoding utf8BOM
$valueRows | Export-Csv -Path $valueCsv -NoTypeInformation -Encoding utf8BOM
Write-ImportSql -Path $importSql -CaseCsv $caseCsv -MapCsv $mapCsv -InstanceCsv $instanceCsv -ValueCsv $valueCsv

$report = [pscustomobject]@{
    case_count = $caseRows.Count
    migration_map_count = $mapRows.Count
    form_instance_count = $instanceRows.Count
    form_field_value_count = $valueRows.Count
    skipped_answer_count = $skippedAnswers
    output_directory = (Resolve-Path $OutputDirectory).Path
}

$report | ConvertTo-Json -Depth 4 | Set-Content -Path (Join-Path $OutputDirectory "case_migration_report.json") -Encoding utf8BOM
$report | ConvertTo-Json -Depth 4

if ($Execute) {
    Invoke-PsqlFile -ConfigPath $TargetConfigPath -SqlPath $importSql
}
