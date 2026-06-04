param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$TargetConfigPath = "./MultiCenterRegistry/appsettings.json",
    [string]$CatalogPath = "./Script/output/form_inventory/form_field_catalog.json",
    [string]$OutputDirectory = "./Script/output/meeting_migration",
    [switch]$Export,
    [switch]$Execute,
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

if ($PlanOnly -or (-not $Export -and -not $Execute)) {
    Write-Host "会议评审迁移脚本计划："
    Write-Host "1. 读取旧库会议、专家、评价、总结、投票和评价答案。"
    Write-Host "2. 生成会议评审相关 CSV 和 08_import_meetings.sql。"
    Write-Host "3. 指定 -Execute 时才调用 psql 写入 mcr 模式。"
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
        [string]$MeetingCsv,
        [string]$ExpertCsv,
        [string]$AppraiseCsv,
        [string]$SummaryCsv,
        [string]$VoteCsv,
        [string]$MapCsv,
        [string]$InstanceCsv,
        [string]$ValueCsv
    )

    $meetingPath = ConvertTo-SqlText (ConvertTo-ImportPath $MeetingCsv)
    $expertPath = ConvertTo-SqlText (ConvertTo-ImportPath $ExpertCsv)
    $appraisePath = ConvertTo-SqlText (ConvertTo-ImportPath $AppraiseCsv)
    $summaryPath = ConvertTo-SqlText (ConvertTo-ImportPath $SummaryCsv)
    $votePath = ConvertTo-SqlText (ConvertTo-ImportPath $VoteCsv)
    $mapPath = ConvertTo-SqlText (ConvertTo-ImportPath $MapCsv)
    $instancePath = ConvertTo-SqlText (ConvertTo-ImportPath $InstanceCsv)
    $valuePath = ConvertTo-SqlText (ConvertTo-ImportPath $ValueCsv)

    $sql = @"
set temp_buffers = '512MB';
begin;

create temp table tmp_review_meeting (
    id text, old_meeting_id text, title text, description text, group_info text,
    place text, meeting_time text, end_time text, status text, created_at text, created_by text
);
\copy tmp_review_meeting from $meetingPath with (format csv, header true);

insert into mcr.review_meeting (
    id, old_meeting_id, title, description, group_info, place, meeting_time,
    end_time, status, created_at, created_by
)
select
    id::uuid,
    old_meeting_id,
    coalesce(nullif(title, ''), '未命名会议'),
    nullif(description, ''),
    nullif(group_info, ''),
    nullif(place, ''),
    coalesce(nullif(meeting_time, '')::timestamp, now()),
    nullif(end_time, '')::timestamp,
    coalesce(nullif(status, '')::integer, 0),
    coalesce(nullif(created_at, '')::timestamp, now()),
    nullif(created_by, '')
from tmp_review_meeting
on conflict (old_meeting_id) do update set
    title = excluded.title,
    description = excluded.description,
    group_info = excluded.group_info,
    place = excluded.place,
    meeting_time = excluded.meeting_time,
    end_time = excluded.end_time,
    status = excluded.status,
    created_at = excluded.created_at,
    created_by = excluded.created_by;

create temp table tmp_meeting_expert (
    id text, meeting_id text, expert_id text, level text
);
\copy tmp_meeting_expert from $expertPath with (format csv, header true);

insert into mcr.meeting_expert (id, meeting_id, expert_id, level)
select id::uuid, meeting_id::uuid, expert_id, coalesce(nullif(level, '')::integer, 0)
from tmp_meeting_expert
on conflict (id) do update set
    meeting_id = excluded.meeting_id,
    expert_id = excluded.expert_id,
    level = excluded.level;

create temp table tmp_case_appraise (
    id text, meeting_id text, case_id text, expert_id text, status text, created_at text, updated_at text
);
\copy tmp_case_appraise from $appraisePath with (format csv, header true);

insert into mcr.case_appraise (id, meeting_id, case_id, expert_id, status, created_at, updated_at)
select
    id::uuid,
    meeting_id::uuid,
    case_id::uuid,
    expert_id,
    coalesce(nullif(status, '')::integer, 0),
    coalesce(nullif(created_at, '')::timestamp, now()),
    nullif(updated_at, '')::timestamp
from tmp_case_appraise
on conflict (id) do update set
    meeting_id = excluded.meeting_id,
    case_id = excluded.case_id,
    expert_id = excluded.expert_id,
    status = excluded.status,
    created_at = excluded.created_at,
    updated_at = excluded.updated_at;

create temp table tmp_case_summary (
    id text, meeting_id text, case_id text, content text, status text, expert_name text, created_at text, created_by text
);
\copy tmp_case_summary from $summaryPath with (format csv, header true);

insert into mcr.case_summary (id, meeting_id, case_id, content, status, expert_name, created_at, created_by)
select
    id::uuid,
    meeting_id::uuid,
    case_id::uuid,
    coalesce(nullif(content, ''), ''),
    coalesce(nullif(status, '')::integer, 0),
    nullif(expert_name, ''),
    coalesce(nullif(created_at, '')::timestamp, now()),
    nullif(created_by, '')
from tmp_case_summary
on conflict (id) do update set
    meeting_id = excluded.meeting_id,
    case_id = excluded.case_id,
    content = excluded.content,
    status = excluded.status,
    expert_name = excluded.expert_name,
    created_at = excluded.created_at,
    created_by = excluded.created_by;

create temp table tmp_case_vote (
    id text, meeting_id text, case_id text, summary_id text, agreed text, content text, expert_name text, created_at text, created_by text
);
\copy tmp_case_vote from $votePath with (format csv, header true);

insert into mcr.case_vote (id, meeting_id, case_id, summary_id, agreed, content, expert_name, created_at, created_by)
select
    id::uuid,
    meeting_id::uuid,
    case_id::uuid,
    summary_id::uuid,
    coalesce(nullif(agreed, '')::boolean, false),
    nullif(content, ''),
    nullif(expert_name, ''),
    coalesce(nullif(created_at, '')::timestamp, now()),
    nullif(created_by, '')
from tmp_case_vote
on conflict (id) do update set
    meeting_id = excluded.meeting_id,
    case_id = excluded.case_id,
    summary_id = excluded.summary_id,
    agreed = excluded.agreed,
    content = excluded.content,
    expert_name = excluded.expert_name,
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
$appraiseFormByCustomForm = @{}
$appraiseFormByDisease = @{}
$fieldByFormSubject = @{}

foreach ($form in $catalog) {
    $formTemplateId = ConvertTo-StableGuid "form-template:$($form.custom_form_id)"

    foreach ($map in @($form.templates)) {
        if ($map.type_name -eq "专家评审") {
            $mapId = ConvertTo-StableGuid "form-template-map:appraise:$($map.follow_template_id):$($form.custom_form_id)"
            $formMap = [pscustomobject]@{
                CustomFormId = [string]$form.custom_form_id
                FormTemplateId = $formTemplateId
                FormTemplateMapId = $mapId
                FollowTemplateId = [string]$map.follow_template_id
            }
            $appraiseFormByDisease[[string]$map.follow_template_id] = $formMap
            $appraiseFormByCustomForm[[string]$form.custom_form_id] = $formMap
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
$meetingRows = [System.Collections.Generic.List[object]]::new()
$expertRows = [System.Collections.Generic.List[object]]::new()
$appraiseRows = [System.Collections.Generic.List[object]]::new()
$summaryRows = [System.Collections.Generic.List[object]]::new()
$voteRows = [System.Collections.Generic.List[object]]::new()
$mapRows = [System.Collections.Generic.List[object]]::new()
$instanceRows = [System.Collections.Generic.List[object]]::new()
$valueRows = [System.Collections.Generic.List[object]]::new()
$instanceKeys = [System.Collections.Generic.HashSet[string]]::new()
$skippedAnswers = 0
$missingCaseAppraiseRows = 0

try {
    $connection.Open()

    $meetings = Invoke-SourceQuery -Connection $connection -Sql @"
select ID, Title, Description, GroupInfo, Place, MeettingTime, EndTime, Status, CreateUserID, CreateTime
from MCR_Meeting
order by MeettingTime, ID
"@

    foreach ($row in $meetings.Rows) {
        $oldMeetingId = Get-DbValue $row "ID"
        $meetingId = ConvertTo-StableGuid "meeting:$oldMeetingId"
        $createdAt = Get-DateValue $row "CreateTime"

        $meetingRows.Add([pscustomobject]@{
            id = $meetingId
            old_meeting_id = $oldMeetingId
            title = Get-DbValue $row "Title"
            description = Get-DbValue $row "Description"
            group_info = Get-DbValue $row "GroupInfo"
            place = Get-DbValue $row "Place"
            meeting_time = Get-DateValue $row "MeettingTime"
            end_time = Get-DateValue $row "EndTime"
            status = Get-DbValue $row "Status"
            created_at = $createdAt
            created_by = Get-DbValue $row "CreateUserID"
        })

        $mapRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "migration-map:MCR_Meeting:$oldMeetingId"
            source_table = "MCR_Meeting"
            source_id = $oldMeetingId
            target_table = "mcr.review_meeting"
            target_id = $meetingId
            created_at = $createdAt
        })
    }

    $experts = Invoke-SourceQuery -Connection $connection -Sql @"
select ID, MeetingID, ExpertID, Level
from MCR_MeetingExpertMap
order by MeetingID, Level, ID
"@

    foreach ($row in $experts.Rows) {
        $oldId = Get-DbValue $row "ID"
        $expertId = ConvertTo-StableGuid "meeting-expert:$oldId"
        $meetingId = ConvertTo-StableGuid "meeting:$(Get-DbValue $row "MeetingID")"

        $expertRows.Add([pscustomobject]@{
            id = $expertId
            meeting_id = $meetingId
            expert_id = Get-DbValue $row "ExpertID"
            level = Get-DbValue $row "Level"
        })

        $mapRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "migration-map:MCR_MeetingExpertMap:$oldId"
            source_table = "MCR_MeetingExpertMap"
            source_id = $oldId
            target_table = "mcr.meeting_expert"
            target_id = $expertId
            created_at = ""
        })
    }

    $appraises = Invoke-SourceQuery -Connection $connection -Sql @"
select ID, MeetingID, CaseID, ExpertID, DiseaseID, CustomFormID, Status, CreateTime, UpdateTime
from MCR_Appraise
order by MeetingID, CaseID, ExpertID, ID
"@

    foreach ($row in $appraises.Rows) {
        $oldAppraiseId = Get-DbValue $row "ID"
        $appraiseId = ConvertTo-StableGuid "appraise:$oldAppraiseId"
        $oldMeetingId = Get-DbValue $row "MeetingID"
        $oldCaseId = Get-DbValue $row "CaseID"
        $createdAt = Get-DateValue $row "CreateTime"

        if ([string]::IsNullOrWhiteSpace($oldMeetingId) -or [string]::IsNullOrWhiteSpace($oldCaseId)) {
            $missingCaseAppraiseRows++
            continue
        }

        $appraiseRows.Add([pscustomobject]@{
            id = $appraiseId
            meeting_id = ConvertTo-StableGuid "meeting:$oldMeetingId"
            case_id = ConvertTo-StableGuid "case:$oldCaseId"
            expert_id = Get-DbValue $row "ExpertID"
            status = Get-DbValue $row "Status"
            created_at = $createdAt
            updated_at = Get-DateValue $row "UpdateTime"
        })

        $mapRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "migration-map:MCR_Appraise:$oldAppraiseId"
            source_table = "MCR_Appraise"
            source_id = $oldAppraiseId
            target_table = "mcr.case_appraise"
            target_id = $appraiseId
            created_at = $createdAt
        })

        $customFormId = Get-DbValue $row "CustomFormID"
        $diseaseId = Get-DbValue $row "DiseaseID"
        $formMap = $null
        if (-not [string]::IsNullOrWhiteSpace($diseaseId) -and $appraiseFormByDisease.ContainsKey($diseaseId)) {
            $formMap = $appraiseFormByDisease[$diseaseId]
        } elseif (-not [string]::IsNullOrWhiteSpace($customFormId) -and $appraiseFormByCustomForm.ContainsKey($customFormId)) {
            $formMap = $appraiseFormByCustomForm[$customFormId]
        }

        if ($null -ne $formMap) {
            $instanceKey = "$oldAppraiseId|$($formMap.CustomFormId)"
            if ($instanceKeys.Add($instanceKey)) {
                $instanceRows.Add([pscustomobject]@{
                    id = ConvertTo-StableGuid "form-instance:appraise:$instanceKey"
                    owner_type = "appraise"
                    owner_id = $appraiseId
                    form_template_id = $formMap.FormTemplateId
                    form_template_map_id = $formMap.FormTemplateMapId
                    source_card_id = $oldAppraiseId
                    source_custom_form_id = $formMap.CustomFormId
                    source_follow_template_id = $formMap.FollowTemplateId
                    status = Get-DbValue $row "Status"
                    created_at = $createdAt
                    created_by = ""
                    updated_at = Get-DateValue $row "UpdateTime"
                    updated_by = ""
                })
            }
        }
    }

    $summaries = Invoke-SourceQuery -Connection $connection -Sql @"
select ID, MeetingID, CaseID, Content, Status, ExpertName, CreateUserID, CreateTime
from MCR_Summary
order by MeetingID, CaseID, ID
"@

    foreach ($row in $summaries.Rows) {
        $oldSummaryId = Get-DbValue $row "ID"
        $summaryId = ConvertTo-StableGuid "summary:$oldSummaryId"
        $createdAt = Get-DateValue $row "CreateTime"

        $summaryRows.Add([pscustomobject]@{
            id = $summaryId
            meeting_id = ConvertTo-StableGuid "meeting:$(Get-DbValue $row "MeetingID")"
            case_id = ConvertTo-StableGuid "case:$(Get-DbValue $row "CaseID")"
            content = Get-DbValue $row "Content"
            status = Get-DbValue $row "Status"
            expert_name = Get-DbValue $row "ExpertName"
            created_at = $createdAt
            created_by = Get-DbValue $row "CreateUserID"
        })

        $mapRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "migration-map:MCR_Summary:$oldSummaryId"
            source_table = "MCR_Summary"
            source_id = $oldSummaryId
            target_table = "mcr.case_summary"
            target_id = $summaryId
            created_at = $createdAt
        })
    }

    $votes = Invoke-SourceQuery -Connection $connection -Sql @"
select ID, MeetingID, CaseID, SummaryID, Content, Agreed, ExpertName, CreateUserID, CreateTime
from MCR_Vote
order by MeetingID, CaseID, ID
"@

    foreach ($row in $votes.Rows) {
        $oldVoteId = Get-DbValue $row "ID"
        $voteId = ConvertTo-StableGuid "vote:$oldVoteId"
        $createdAt = Get-DateValue $row "CreateTime"

        $voteRows.Add([pscustomobject]@{
            id = $voteId
            meeting_id = ConvertTo-StableGuid "meeting:$(Get-DbValue $row "MeetingID")"
            case_id = ConvertTo-StableGuid "case:$(Get-DbValue $row "CaseID")"
            summary_id = ConvertTo-StableGuid "summary:$(Get-DbValue $row "SummaryID")"
            agreed = Get-DbValue $row "Agreed"
            content = Get-DbValue $row "Content"
            expert_name = Get-DbValue $row "ExpertName"
            created_at = $createdAt
            created_by = Get-DbValue $row "CreateUserID"
        })

        $mapRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "migration-map:MCR_Vote:$oldVoteId"
            source_table = "MCR_Vote"
            source_id = $oldVoteId
            target_table = "mcr.case_vote"
            target_id = $voteId
            created_at = $createdAt
        })
    }

    $answers = Invoke-SourceQuery -Connection $connection -Sql @"
select a.ID, a.CardID, a.SubjectID, a.Sort, cast(a.Answer as nvarchar(max)) as Answer,
       cast(a.HisAnswer as nvarchar(max)) as HisAnswer, a.CreateUserID, a.CreateTime,
       a.UpdateTime, a.CustomFormID, ap.DiseaseID, ap.Status
from CM_CAHD_Care_CustomFormAnswer a
inner join MCR_Appraise ap on ap.ID = a.CardID
where a.CustomFormID is not null
order by a.CardID, a.Sort, a.ID
"@

    foreach ($row in $answers.Rows) {
        $oldAppraiseId = Get-DbValue $row "CardID"
        $customFormId = Get-DbValue $row "CustomFormID"
        $subjectId = Get-DbValue $row "SubjectID"
        $fieldKey = "$customFormId|$subjectId"

        if (-not $fieldByFormSubject.ContainsKey($fieldKey)) {
            $skippedAnswers++
            continue
        }

        $diseaseId = Get-DbValue $row "DiseaseID"
        $appraiseId = ConvertTo-StableGuid "appraise:$oldAppraiseId"
        $formTemplateId = ConvertTo-StableGuid "form-template:$customFormId"
        $formTemplateMapId = ""
        $followTemplateId = $diseaseId
        if ($appraiseFormByDisease.ContainsKey($diseaseId)) {
            $formTemplateMapId = $appraiseFormByDisease[$diseaseId].FormTemplateMapId
            $followTemplateId = $appraiseFormByDisease[$diseaseId].FollowTemplateId
        }

        $instanceKey = "$oldAppraiseId|$customFormId"
        $instanceId = ConvertTo-StableGuid "form-instance:appraise:$instanceKey"
        if ($instanceKeys.Add($instanceKey)) {
            $instanceRows.Add([pscustomobject]@{
                id = $instanceId
                owner_type = "appraise"
                owner_id = $appraiseId
                form_template_id = $formTemplateId
                form_template_map_id = $formTemplateMapId
                source_card_id = $oldAppraiseId
                source_custom_form_id = $customFormId
                source_follow_template_id = $followTemplateId
                status = Get-DbValue $row "Status"
                created_at = Get-DateValue $row "CreateTime"
                created_by = Get-DbValue $row "CreateUserID"
                updated_at = Get-DateValue $row "UpdateTime"
                updated_by = ""
            })
        }

        $field = $fieldByFormSubject[$fieldKey]
        $answerId = Get-DbValue $row "ID"
        $valueRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "form-field-value:appraise:$answerId"
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

$meetingCsv = Join-Path $OutputDirectory "review_meeting.csv"
$expertCsv = Join-Path $OutputDirectory "meeting_expert.csv"
$appraiseCsv = Join-Path $OutputDirectory "case_appraise.csv"
$summaryCsv = Join-Path $OutputDirectory "case_summary.csv"
$voteCsv = Join-Path $OutputDirectory "case_vote.csv"
$mapCsv = Join-Path $OutputDirectory "migration_map_meeting.csv"
$instanceCsv = Join-Path $OutputDirectory "form_instance_appraise.csv"
$valueCsv = Join-Path $OutputDirectory "form_field_value_appraise.csv"
$importSql = Join-Path $OutputDirectory "08_import_meetings.sql"

$meetingRows | Export-Csv -Path $meetingCsv -NoTypeInformation -Encoding utf8BOM
$expertRows | Export-Csv -Path $expertCsv -NoTypeInformation -Encoding utf8BOM
$appraiseRows | Export-Csv -Path $appraiseCsv -NoTypeInformation -Encoding utf8BOM
$summaryRows | Export-Csv -Path $summaryCsv -NoTypeInformation -Encoding utf8BOM
$voteRows | Export-Csv -Path $voteCsv -NoTypeInformation -Encoding utf8BOM
$mapRows | Export-Csv -Path $mapCsv -NoTypeInformation -Encoding utf8BOM
$instanceRows | Export-Csv -Path $instanceCsv -NoTypeInformation -Encoding utf8BOM
$valueRows | Export-Csv -Path $valueCsv -NoTypeInformation -Encoding utf8BOM
Write-ImportSql -Path $importSql -MeetingCsv $meetingCsv -ExpertCsv $expertCsv -AppraiseCsv $appraiseCsv -SummaryCsv $summaryCsv -VoteCsv $voteCsv -MapCsv $mapCsv -InstanceCsv $instanceCsv -ValueCsv $valueCsv

$report = [pscustomobject]@{
    meeting_count = $meetingRows.Count
    meeting_expert_count = $expertRows.Count
    appraise_count = $appraiseRows.Count
    summary_count = $summaryRows.Count
    vote_count = $voteRows.Count
    migration_map_count = $mapRows.Count
    form_instance_count = $instanceRows.Count
    form_field_value_count = $valueRows.Count
    skipped_answer_count = $skippedAnswers
    missing_case_appraise_count = $missingCaseAppraiseRows
    output_directory = (Resolve-Path $OutputDirectory).Path
}

$report | ConvertTo-Json -Depth 4 | Set-Content -Path (Join-Path $OutputDirectory "meeting_migration_report.json") -Encoding utf8BOM
$report | ConvertTo-Json -Depth 4

if ($Execute) {
    Invoke-PsqlFile -ConfigPath $TargetConfigPath -SqlPath $importSql
}
