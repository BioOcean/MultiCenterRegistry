param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$OutputDirectory = ".\Script\output\form_inventory"
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($SourceConnection)) {
    throw "请先通过环境变量 MCR_SOURCE_SQLSERVER 或参数 SourceConnection 提供旧库连接字符串。"
}

try {
    Add-Type -AssemblyName "Microsoft.Data.SqlClient"
    $connectionType = "Microsoft.Data.SqlClient.SqlConnection"
} catch {
    Add-Type -AssemblyName "System.Data"
    $connectionType = "System.Data.SqlClient.SqlConnection"
}

function Invoke-SourceQuery {
    param(
        [object]$Connection,
        [string]$Sql
    )

    $command = $Connection.CreateCommand()
    $command.CommandText = $Sql
    $command.CommandTimeout = 180
    $reader = $command.ExecuteReader()
    $table = New-Object System.Data.DataTable
    $table.Load($reader)
    return ,$table
}

function Save-Json {
    param(
        [System.Data.DataTable]$Table,
        [string]$Path
    )

    $rows = @($Table | ForEach-Object {
        $item = [ordered]@{}
        foreach ($column in $Table.Columns) {
            $value = $_.($column.ColumnName)
            if ($value -is [System.DBNull]) {
                $value = $null
            }
            $item[$column.ColumnName] = $value
        }
        [pscustomobject]$item
    })

    $rows | ConvertTo-Json -Depth 8 | Set-Content -Path $Path -Encoding utf8BOM
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

$tables = @(
    "MCR_Case",
    "MCR_Quality",
    "MCR_Appraise",
    "CM_CAHD_Care_CustomForm",
    "CM_CAHD_Care_CustomFormSubject",
    "CM_CAHD_Care_SubjectConfig",
    "CM_CAHD_Care_SubjectList",
    "CM_CAHD_Care_CustomFormAnswer",
    "CM_CAHD_Care_DataDictionary",
    "FollowTemplate",
    "FollowTemplate_CustomForm_Map",
    "FollowTemplateList",
    "FollowPackgeConfig",
    "Hospital",
    "DoctorInfo",
    "Users"
)

$tableNameList = ($tables | ForEach-Object { "N'$($_.Replace("'", "''"))'" }) -join ","

$queries = [ordered]@{
    "table_columns" = @"
select TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH, ORDINAL_POSITION
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME in ($tableNameList)
order by TABLE_NAME, ORDINAL_POSITION
"@
    "custom_forms" = @"
select *
from CM_CAHD_Care_CustomForm
order by ID
"@
    "custom_form_subjects" = @"
select *
from CM_CAHD_Care_CustomFormSubject
order by CustomFormID, Sort, ID
"@
    "subject_config" = @"
select *
from CM_CAHD_Care_SubjectConfig
order by SubjectListID, ID
"@
    "subject_list" = @"
select *
from CM_CAHD_Care_SubjectList
order by Sort, ID
"@
    "data_dictionary" = @"
select *
from CM_CAHD_Care_DataDictionary
order by ID
"@
    "follow_template" = @"
select *
from FollowTemplate
order by ID
"@
    "follow_template_form_map" = @"
select *
from FollowTemplate_CustomForm_Map
order by Type, FollowTemplateID, CustomFormID
"@
    "answer_summary" = @"
select
    CustomFormID,
    SubjectID,
    count(1) as AnswerCount,
    sum(case when Answer is not null and ltrim(rtrim(cast(Answer as nvarchar(max)))) <> '' then 1 else 0 end) as NonEmptyAnswerCount
from CM_CAHD_Care_CustomFormAnswer
group by CustomFormID, SubjectID
order by CustomFormID, SubjectID
"@
    "answer_owner_summary" = @"
select
    a.CustomFormID,
    count(1) as AnswerCount,
    sum(case when c.ID is not null then 1 else 0 end) as CaseAnswerCount,
    sum(case when q.ID is not null then 1 else 0 end) as QualityAnswerCount,
    sum(case when ap.ID is not null then 1 else 0 end) as AppraiseAnswerCount,
    count(distinct a.CardID) as CardCount
from CM_CAHD_Care_CustomFormAnswer a
left join MCR_Case c on c.ID = a.CardID
left join MCR_Quality q on q.ID = a.CardID
left join MCR_Appraise ap on ap.ID = a.CardID
group by a.CustomFormID
order by a.CustomFormID
"@
}

$connection = New-Object $connectionType $SourceConnection
try {
    $connection.Open()

    foreach ($name in $queries.Keys) {
        $table = Invoke-SourceQuery -Connection $connection -Sql $queries[$name]
        Save-Json -Table $table -Path (Join-Path $OutputDirectory "$name.json")
    }
} finally {
    $connection.Dispose()
}

Write-Host "表单字段只读盘点完成：$OutputDirectory"
