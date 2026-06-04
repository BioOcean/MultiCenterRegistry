param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$TargetConfigPath = "./MultiCenterRegistry/appsettings.json",
    [string]$OutputDirectory = "./Script/output/article_migration",
    [switch]$Export,
    [switch]$Execute,
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

if ($PlanOnly -or (-not $Export -and -not $Execute)) {
    Write-Host "文章和系统消息迁移脚本计划："
    Write-Host "1. 读取旧库 MCR_Article 文献、门户介绍和系统消息。"
    Write-Host "2. 生成 article.csv 和 14_import_articles.sql。"
    Write-Host "3. 指定 -Execute 时才调用 psql 写入 mcr.article。"
    Write-Host "4. 执行前请先执行 13_extend_admin_content.sql。"
    return
}

if ([string]::IsNullOrWhiteSpace($SourceConnection)) {
    throw "请先通过环境变量 MCR_SOURCE_SQLSERVER 或参数 SourceConnection 提供旧库连接字符串。"
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
        [string]$ArticleCsv
    )

    $articlePath = ConvertTo-SqlText (ConvertTo-ImportPath $ArticleCsv)
    $sql = @"
begin;

create temp table tmp_article (
    id text,
    old_article_id text,
    topic_id text,
    type text,
    status text,
    title text,
    content text,
    cover text,
    created_at text,
    created_by text
);
\copy tmp_article from $articlePath with (format csv, header true);

insert into mcr.article (
    id, old_article_id, topic_id, type, status, title, content, cover, created_at, created_by, updated_at, updated_by
)
select
    article.id::uuid,
    nullif(article.old_article_id, ''),
    nullif(article.topic_id, ''),
    coalesce(nullif(article.type, '')::integer, 1),
    coalesce(nullif(article.status, '')::integer, 0),
    coalesce(article.title, ''),
    coalesce(article.content, ''),
    nullif(article.cover, ''),
    coalesce(nullif(article.created_at, '')::timestamp, now()),
    coalesce(user_map.target_id::text, nullif(article.created_by, '')),
    null,
    null
from tmp_article article
left join mcr.migration_map user_map
    on user_map.source_table = 'MCR_User'
   and lower(user_map.source_id) = lower(article.created_by)
on conflict (id) do update set
    old_article_id = coalesce(excluded.old_article_id, mcr.article.old_article_id),
    topic_id = excluded.topic_id,
    type = excluded.type,
    status = excluded.status,
    title = excluded.title,
    content = excluded.content,
    cover = excluded.cover,
    created_at = excluded.created_at,
    created_by = excluded.created_by;

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select
    (
        substr(md5('MCRArticle:' || article.old_article_id), 1, 8) || '-' ||
        substr(md5('MCRArticle:' || article.old_article_id), 9, 4) || '-' ||
        substr(md5('MCRArticle:' || article.old_article_id), 13, 4) || '-' ||
        substr(md5('MCRArticle:' || article.old_article_id), 17, 4) || '-' ||
        substr(md5('MCRArticle:' || article.old_article_id), 21, 12)
    )::uuid,
    'MCRArticle',
    article.old_article_id,
    'mcr.article',
    article.id::uuid,
    now()
from tmp_article article
where nullif(article.old_article_id, '') is not null
on conflict (source_table, source_id) do update set
    target_table = excluded.target_table,
    target_id = excluded.target_id;

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

$connection = New-Object $connectionType $SourceConnection
$articleRows = [System.Collections.Generic.List[object]]::new()

try {
    $connection.Open()
    $articles = Invoke-SourceQuery $connection @"
select
    cast(ID as nvarchar(100)) as ID,
    cast(TopicID as nvarchar(100)) as TopicID,
    isnull(Type, 1) as Type,
    isnull(Status, 0) as Status,
    isnull(Title, '') as Title,
    isnull(Content, '') as Content,
    Cover,
    CreateTime,
    cast(CreateUserID as nvarchar(100)) as CreateUserID
from dbo.MCR_Article
"@

    foreach ($row in $articles.Rows) {
        $oldId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldId)) {
            continue
        }

        $targetId = $oldId
        $parsedGuid = [Guid]::Empty
        if (-not [Guid]::TryParse($targetId, [ref]$parsedGuid)) {
            $targetId = ConvertTo-StableGuid "MCRArticle:$oldId"
        }

        $articleRows.Add([pscustomobject]@{
            id = $targetId
            old_article_id = $oldId
            topic_id = Get-DbValue $row "TopicID"
            type = Get-DbValue $row "Type"
            status = Get-DbValue $row "Status"
            title = Get-DbValue $row "Title"
            content = Get-DbValue $row "Content"
            cover = Get-DbValue $row "Cover"
            created_at = Get-DbValue $row "CreateTime"
            created_by = Get-DbValue $row "CreateUserID"
        })
    }
} finally {
    $connection.Dispose()
}

$articleCsv = Join-Path $OutputDirectory "article.csv"
$importSql = Join-Path $OutputDirectory "14_import_articles.sql"

$articleRows | Export-Csv -Path $articleCsv -NoTypeInformation -Encoding UTF8
Write-ImportSql -Path $importSql -ArticleCsv $articleCsv

Write-Host "已生成文章迁移文件："
Write-Host " - $articleCsv"
Write-Host " - $importSql"

if ($Execute) {
    Invoke-PsqlFile -ConfigPath $TargetConfigPath -SqlPath $importSql
}
