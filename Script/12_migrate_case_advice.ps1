param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$TargetConfigPath = "./MultiCenterRegistry/appsettings.json",
    [string]$OutputDirectory = "./Script/output/case_advice_migration",
    [switch]$Export,
    [switch]$Execute,
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

if ($PlanOnly -or (-not $Export -and -not $Execute)) {
    Write-Host "病例历史意见迁移脚本计划："
    Write-Host "1. 探测旧库 MCR_Advice 或 MCRAdvice 表。"
    Write-Host "2. 导出旧意见为 case_advice.csv。"
    Write-Host "3. 生成 12_import_case_advice.sql。"
    Write-Host "4. 指定 -Execute 时才调用 psql 写入 mcr.case_advice 和 mcr.migration_map。"
    return
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

function Format-SqlName {
    param([string]$Name)

    return "[" + $Name.Replace("]", "]]") + "]"
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

function Write-ImportSql {
    param(
        [string]$Path,
        [string]$AdviceCsv
    )

    $advicePath = ConvertTo-SqlText (ConvertTo-ImportPath $AdviceCsv)

    $sql = @"
begin;

create temp table tmp_case_advice (
    id text,
    map_id text,
    source_table text,
    old_advice_id text,
    old_case_id text,
    advice_type text,
    content text,
    created_at text,
    created_by text
);
\copy tmp_case_advice from $advicePath with (format csv, header true);

insert into mcr.case_advice (id, case_id, advice_type, content, created_at, created_by)
select
    a.id::uuid,
    m.target_id,
    coalesce(nullif(a.advice_type, '')::integer, 0),
    coalesce(nullif(a.content, ''), ''),
    coalesce(nullif(a.created_at, '')::timestamp, now()),
    nullif(a.created_by, '')
from tmp_case_advice a
join mcr.migration_map m
    on m.source_table = 'MCR_Case'
    and lower(m.source_id) = lower(a.old_case_id)
on conflict (id) do update set
    case_id = excluded.case_id,
    advice_type = excluded.advice_type,
    content = excluded.content,
    created_at = excluded.created_at,
    created_by = excluded.created_by;

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select
    map_id::uuid,
    source_table,
    old_advice_id,
    'mcr.case_advice',
    id::uuid,
    now()
from tmp_case_advice
on conflict (source_table, source_id) do update set
    target_table = excluded.target_table,
    target_id = excluded.target_id;

select 'case_advice_source' as item, count(*)::bigint as value from tmp_case_advice
union all
select 'case_advice_imported', count(*) from mcr.case_advice ca join tmp_case_advice t on t.id::uuid = ca.id
union all
select 'case_advice_unmapped_case', count(*) from tmp_case_advice a left join mcr.migration_map m on m.source_table = 'MCR_Case' and lower(m.source_id) = lower(a.old_case_id) where m.id is null;

commit;
"@

    [System.IO.File]::WriteAllText($Path, $sql, [System.Text.UTF8Encoding]::new($true))
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

$adviceCsv = Join-Path $OutputDirectory "case_advice.csv"
$importSql = Join-Path $OutputDirectory "12_import_case_advice.sql"
$reportPath = Join-Path $OutputDirectory "case_advice_migration_report.json"

if ($Export) {
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

    $connection = New-Object $connectionType $SourceConnection
    $connection.Open()
    try {
        $tableInfo = Invoke-SourceQuery $connection @"
select top 1 s.name as schema_name, t.name as table_name
from sys.tables t
join sys.schemas s on s.schema_id = t.schema_id
where t.name in ('MCR_Advice', 'MCRAdvice')
order by case when t.name = 'MCR_Advice' then 0 else 1 end;
"@

        if ($tableInfo.Rows.Count -eq 0) {
            throw "旧库未找到 MCR_Advice 或 MCRAdvice 表。"
        }

        $schemaName = [string]$tableInfo.Rows[0]["schema_name"]
        $tableName = [string]$tableInfo.Rows[0]["table_name"]
        $fullSourceTable = "$schemaName.$tableName"
        $tableRef = (Format-SqlName $schemaName) + "." + (Format-SqlName $tableName)

        $columns = Invoke-SourceQuery $connection @"
select c.name
from sys.columns c
join sys.tables t on t.object_id = c.object_id
join sys.schemas s on s.schema_id = t.schema_id
where s.name = '$($schemaName.Replace("'", "''"))'
and t.name = '$($tableName.Replace("'", "''"))';
"@

        $columnSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        foreach ($column in $columns.Rows) {
            [void]$columnSet.Add([string]$column["name"])
        }

        foreach ($requiredColumn in @("ID", "CaseID", "Content")) {
            if (-not $columnSet.Contains($requiredColumn)) {
                throw "旧表 $fullSourceTable 缺少字段 $requiredColumn。"
            }
        }

        $createUserExpr = if ($columnSet.Contains("CreateUserID")) { "cast([CreateUserID] as nvarchar(100)) as CreateUserID" } else { "cast(null as nvarchar(100)) as CreateUserID" }
        $createTimeExpr = if ($columnSet.Contains("CreateTime")) { "[CreateTime] as CreateTime" } else { "getdate() as CreateTime" }
        $adviceTypeExpr = if ($columnSet.Contains("AdviceType")) {
            "cast([AdviceType] as int) as AdviceType"
        } elseif ($columnSet.Contains("Type")) {
            "cast([Type] as int) as AdviceType"
        } else {
            "cast(0 as int) as AdviceType"
        }

        $sourceAdvices = Invoke-SourceQuery $connection @"
select
    cast([ID] as nvarchar(100)) as ID,
    cast([CaseID] as nvarchar(100)) as CaseID,
    cast(coalesce([Content], '') as nvarchar(max)) as Content,
    $createUserExpr,
    $createTimeExpr,
    $adviceTypeExpr
from $tableRef
where [CaseID] is not null;
"@
    } finally {
        $connection.Close()
    }

    $adviceRows = foreach ($row in $sourceAdvices.Rows) {
        $oldAdviceId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldAdviceId)) {
            continue
        }

        [pscustomobject]@{
            id = ConvertTo-StableGuid "case-advice:$oldAdviceId"
            map_id = ConvertTo-StableGuid "migration-map:case-advice:$oldAdviceId"
            source_table = $tableName
            old_advice_id = $oldAdviceId
            old_case_id = Get-DbValue $row "CaseID"
            advice_type = Get-DbValue $row "AdviceType"
            content = Get-DbValue $row "Content"
            created_at = Get-DateValue $row "CreateTime"
            created_by = Get-DbValue $row "CreateUserID"
        }
    }

    $adviceRows | Export-Csv -Path $adviceCsv -NoTypeInformation -Encoding utf8BOM

    $report = [ordered]@{
        source_table = $fullSourceTable
        source_advice_count = $sourceAdvices.Rows.Count
        export_advice_count = @($adviceRows).Count
        output_directory = (Resolve-Path $OutputDirectory).Path
    }
    [System.IO.File]::WriteAllText($reportPath, ($report | ConvertTo-Json -Depth 5), [System.Text.UTF8Encoding]::new($true))
}

Write-ImportSql -Path $importSql -AdviceCsv $adviceCsv

if ($Execute) {
    if (-not (Test-Path $adviceCsv)) {
        throw "未找到 $adviceCsv，请先执行 -Export。"
    }

    Invoke-PsqlFile -ConfigPath $TargetConfigPath -SqlPath $importSql
}

Write-Host "病例历史意见迁移文件已生成：$OutputDirectory"
