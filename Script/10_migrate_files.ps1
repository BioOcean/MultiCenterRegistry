param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$TargetConfigPath = "./MultiCenterRegistry/appsettings.json",
    [string]$OutputDirectory = "./Script/output/file_migration",
    [switch]$Export,
    [switch]$Execute,
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

if ($PlanOnly -or (-not $Export -and -not $Execute)) {
    Write-Host "历史文件迁移脚本计划："
    Write-Host "1. 读取旧库 FileInfo、DicomFile 和图片上传题答案。"
    Write-Host "2. 解析表单答案中的文件码，关联到已迁移的 form_field_value。"
    Write-Host "3. 未被表单答案引用的 FileInfo 作为 legacy_file 保留。"
    Write-Host "4. 生成 registry_file、migration_map 两个 CSV 和 10_import_files.sql。"
    Write-Host "5. 指定 -Execute 时才调用 psql 写入 mcr 模式。"
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

function Get-ContentType {
    param([string]$FileName)

    $extension = [System.IO.Path]::GetExtension($FileName).ToLowerInvariant()
    switch ($extension) {
        ".jpg" { return "image/jpeg" }
        ".jpeg" { return "image/jpeg" }
        ".png" { return "image/png" }
        ".gif" { return "image/gif" }
        ".bmp" { return "image/bmp" }
        ".webp" { return "image/webp" }
        ".pdf" { return "application/pdf" }
        ".xls" { return "application/vnd.ms-excel" }
        ".xlsx" { return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
        ".mp4" { return "video/mp4" }
        ".avi" { return "video/x-msvideo" }
        ".mov" { return "video/quicktime" }
        ".webm" { return "video/webm" }
        ".dcm" { return "application/dicom" }
        default { return "" }
    }
}

function Split-FileCode {
    param(
        [string]$FileCode,
        [string]$FallbackName,
        [string]$FallbackSize
    )

    $items = [System.Collections.Generic.List[object]]::new()
    if ([string]::IsNullOrWhiteSpace($FileCode)) {
        return $items
    }

    foreach ($part in ($FileCode -split [regex]::Escape("#!#"))) {
        if ([string]::IsNullOrWhiteSpace($part)) {
            continue
        }

        $clean = ($part -replace "###.*$", "").Trim()
        $originalName = $FallbackName
        $relativePath = $clean
        $colonIndex = $clean.IndexOf(":")
        if ($colonIndex -ge 0) {
            $originalName = $clean.Substring(0, $colonIndex)
            $relativePath = $clean.Substring($colonIndex + 1)
        }

        $relativePath = $relativePath.TrimStart([char[]]@('\', '/')).Replace("\", "/")
        if ([string]::IsNullOrWhiteSpace($relativePath)) {
            continue
        }

        $fileName = ($relativePath -split "/")[-1]
        if ([string]::IsNullOrWhiteSpace($originalName)) {
            $originalName = $fileName
        }

        $items.Add([pscustomobject]@{
            OriginalName = $originalName
            RelativePath = $relativePath
            StoredName = $fileName
            FileKey = [System.IO.Path]::GetFileNameWithoutExtension($fileName).ToLowerInvariant()
            FileSize = $FallbackSize
        })
    }

    return $items
}

function Get-AnswerFiles {
    param([string]$Answer)

    $items = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new()
    if ([string]::IsNullOrWhiteSpace($Answer)) {
        return $items
    }

    foreach ($part in ($Answer -split [regex]::Escape("&!&"))) {
        $text = $part.Trim()
        if ([string]::IsNullOrWhiteSpace($text)) {
            continue
        }

        try {
            $file = $text | ConvertFrom-Json
        } catch {
            continue
        }

        $name = [string]$file.name
        $size = [string]$file.size
        $responseFiles = @($file.response.data.fileList)
        if ($responseFiles.Count -gt 0) {
            foreach ($responseFile in $responseFiles) {
                foreach ($item in (Split-FileCode -FileCode ([string]$responseFile.fileCode) -FallbackName $name -FallbackSize $size)) {
                    if ($seen.Add($item.RelativePath)) {
                        $items.Add($item)
                    }
                }
            }
            continue
        }

        $url = [string]$file.url
        if (-not [string]::IsNullOrWhiteSpace($url)) {
            foreach ($item in (Split-FileCode -FileCode $url -FallbackName $name -FallbackSize $size)) {
                if ($seen.Add($item.RelativePath)) {
                    $items.Add($item)
                }
            }
        }
    }

    return $items
}

function Write-ImportSql {
    param(
        [string]$Path,
        [string]$RegistryFileCsv,
        [string]$MapCsv
    )

    $registryFilePath = ConvertTo-SqlText (ConvertTo-ImportPath $RegistryFileCsv)
    $mapPath = ConvertTo-SqlText (ConvertTo-ImportPath $MapCsv)

    $sql = @"
begin;

create temp table tmp_registry_file (
    id text,
    owner_type text,
    owner_id text,
    file_name text,
    file_path text,
    content_type text,
    file_size text,
    created_at text,
    created_by text
);
\copy tmp_registry_file from $registryFilePath with (format csv, header true);

create temp table tmp_file_map (
    id text,
    source_table text,
    source_id text,
    target_table text,
    target_id text,
    created_at text
);
\copy tmp_file_map from $mapPath with (format csv, header true);

delete from mcr.registry_file rf
using mcr.migration_map mm
where mm.target_table = 'mcr.registry_file'
  and mm.source_table in ('CM_CAHD_Care_CustomFormAnswer_File', 'FileInfo', 'DicomFile')
  and mm.target_id = rf.id
  and not exists (
      select 1 from tmp_registry_file t where t.id::uuid = rf.id
  );

delete from mcr.migration_map mm
where mm.target_table = 'mcr.registry_file'
  and mm.source_table in ('CM_CAHD_Care_CustomFormAnswer_File', 'FileInfo', 'DicomFile')
  and not exists (
      select 1 from tmp_file_map t where t.id::uuid = mm.id
  );

insert into mcr.registry_file (
    id, owner_type, owner_id, file_name, file_path, content_type, file_size, created_at, created_by
)
select
    id::uuid,
    owner_type,
    owner_id::uuid,
    coalesce(nullif(file_name, ''), file_path),
    file_path,
    nullif(content_type, ''),
    nullif(file_size, '')::bigint,
    coalesce(nullif(created_at, '')::timestamp, now()),
    nullif(created_by, '')
from tmp_registry_file
on conflict (id) do update set
    owner_type = excluded.owner_type,
    owner_id = excluded.owner_id,
    file_name = excluded.file_name,
    file_path = excluded.file_path,
    content_type = excluded.content_type,
    file_size = excluded.file_size,
    created_at = excluded.created_at,
    created_by = excluded.created_by;

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select
    id::uuid,
    source_table,
    source_id,
    target_table,
    target_id::uuid,
    coalesce(nullif(created_at, '')::timestamp, now())
from tmp_file_map
on conflict (id) do update set
    source_table = excluded.source_table,
    source_id = excluded.source_id,
    target_table = excluded.target_table,
    target_id = excluded.target_id,
    created_at = excluded.created_at;

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

$registryFileRows = [System.Collections.Generic.List[object]]::new()
$mapRows = [System.Collections.Generic.List[object]]::new()
$referencedFileKeys = [System.Collections.Generic.HashSet[string]]::new()
$parseErrorCount = 0
$missingFileInfoCount = 0

$connection = New-Object $connectionType $SourceConnection
try {
    $connection.Open()

    $fileInfoRows = Invoke-SourceQuery -Connection $connection -Sql @"
select cast(ID as nvarchar(50)) as ID, VID, UserName, Path, FileType, PathType, Size, Memo, CreateTime
from FileInfo
order by CreateTime, ID
"@

    $fileInfoByKey = @{}
    foreach ($row in $fileInfoRows.Rows) {
        $oldFileId = Get-DbValue $row "ID"
        $key = $oldFileId.ToLowerInvariant()
        $fileInfoByKey[$key] = [pscustomobject]@{
            Id = $oldFileId
            Path = Get-DbValue $row "Path"
            FileType = Get-DbValue $row "FileType"
            PathType = Get-DbValue $row "PathType"
            Size = Get-DbValue $row "Size"
            CreateTime = Get-DateValue $row "CreateTime"
            CreatedBy = Get-DbValue $row "VID"
            UserName = Get-DbValue $row "UserName"
        }
    }

    $answerRows = Invoke-SourceQuery -Connection $connection -Sql @"
select a.ID, a.CardID, a.CustomFormID, a.SubjectID, cast(a.Answer as nvarchar(max)) as Answer,
       a.CreateUserID, a.CreateTime
from CM_CAHD_Care_CustomFormAnswer a
inner join CM_CAHD_Care_CustomFormSubject s on s.ID = a.SubjectID
inner join CM_CAHD_Care_SubjectConfig sc on sc.ID = s.SubjectConfigID
inner join MCR_Case c on c.ID = a.CardID
where sc.Type = 7
  and a.Answer is not null
  and ltrim(rtrim(cast(a.Answer as nvarchar(max)))) <> ''
order by a.CreateTime, a.ID
"@

    foreach ($row in $answerRows.Rows) {
        $answerId = Get-DbValue $row "ID"
        $createdAt = Get-DateValue $row "CreateTime"
        $createdBy = Get-DbValue $row "CreateUserID"
        $ownerId = ConvertTo-StableGuid "form-field-value:case:$answerId"
        $files = Get-AnswerFiles (Get-DbValue $row "Answer")

        if ($files.Count -eq 0) {
            $parseErrorCount++
            continue
        }

        $fileIndex = 0
        foreach ($file in $files) {
            $fileIndex++
            $fileInfo = $null
            if ($fileInfoByKey.ContainsKey($file.FileKey)) {
                $fileInfo = $fileInfoByKey[$file.FileKey]
                [void]$referencedFileKeys.Add($file.FileKey)
            } else {
                $missingFileInfoCount++
            }

            $size = $file.FileSize
            $fileCreatedAt = $createdAt
            if ($null -ne $fileInfo) {
                if (-not [string]::IsNullOrWhiteSpace($fileInfo.Size)) {
                    $size = $fileInfo.Size
                }
                if (-not [string]::IsNullOrWhiteSpace($fileInfo.CreateTime)) {
                    $fileCreatedAt = $fileInfo.CreateTime
                }
            }

            $targetId = ConvertTo-StableGuid "registry-file:form-field-value:${ownerId}:$($file.RelativePath):$fileIndex"
            $sourceId = "$answerId`:$($file.FileKey)`:$fileIndex"
            $filePath = "upload/$($file.RelativePath)"

            $registryFileRows.Add([pscustomobject]@{
                id = $targetId
                owner_type = "form_field_value"
                owner_id = $ownerId
                file_name = $file.OriginalName
                file_path = $filePath
                content_type = Get-ContentType $file.StoredName
                file_size = $size
                created_at = $fileCreatedAt
                created_by = $createdBy
            })

            $mapRows.Add([pscustomobject]@{
                id = ConvertTo-StableGuid "migration-map:CM_CAHD_Care_CustomFormAnswer_File:$sourceId"
                source_table = "CM_CAHD_Care_CustomFormAnswer_File"
                source_id = $sourceId
                target_table = "mcr.registry_file"
                target_id = $targetId
                created_at = $fileCreatedAt
            })
        }
    }

    foreach ($row in $fileInfoRows.Rows) {
        $oldFileId = Get-DbValue $row "ID"
        $key = $oldFileId.ToLowerInvariant()
        if ($referencedFileKeys.Contains($key)) {
            continue
        }

        $path = Get-DbValue $row "Path"
        if ([string]::IsNullOrWhiteSpace($path)) {
            continue
        }

        $createdAt = Get-DateValue $row "CreateTime"
        $dateFolder = ""
        if (-not [string]::IsNullOrWhiteSpace($createdAt)) {
            $dateFolder = ([datetime]$createdAt).ToString("yyyyMMdd")
        }

        $fileName = ($path.Replace("\", "/") -split "/")[-1]
        $relativePath = if ([string]::IsNullOrWhiteSpace($dateFolder)) { $fileName } else { "$dateFolder/$fileName" }
        $targetId = ConvertTo-StableGuid "registry-file:legacy-file:$oldFileId"

        $registryFileRows.Add([pscustomobject]@{
            id = $targetId
            owner_type = "legacy_file"
            owner_id = $targetId
            file_name = $fileName
            file_path = "upload/$relativePath"
            content_type = Get-ContentType $fileName
            file_size = Get-DbValue $row "Size"
            created_at = $createdAt
            created_by = Get-DbValue $row "VID"
        })

        $mapRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "migration-map:FileInfo:$oldFileId"
            source_table = "FileInfo"
            source_id = $oldFileId
            target_table = "mcr.registry_file"
            target_id = $targetId
            created_at = $createdAt
        })
    }

    $dicomRows = Invoke-SourceQuery -Connection $connection -Sql @"
select cast(ID as nvarchar(50)) as ID, StudyUid, ChildFolderPath, FileCount, Status,
       CreateTime, cast(CreateUserID as nvarchar(50)) as CreateUserID
from DicomFile
order by CreateTime, ID
"@

    foreach ($row in $dicomRows.Rows) {
        $oldId = Get-DbValue $row "ID"
        $path = (Get-DbValue $row "ChildFolderPath").TrimStart([char[]]@('\', '/')).Replace("\", "/")
        if ([string]::IsNullOrWhiteSpace($path)) {
            continue
        }

        $fileName = ($path -split "/")[-1]
        $targetId = ConvertTo-StableGuid "registry-file:DicomFile:$oldId"
        $studyUid = Get-DbValue $row "StudyUid"
        $ownerId = ConvertTo-StableGuid "dicom-study:$studyUid"
        $createdAt = Get-DateValue $row "CreateTime"

        $registryFileRows.Add([pscustomobject]@{
            id = $targetId
            owner_type = "dicom"
            owner_id = $ownerId
            file_name = $fileName
            file_path = "dicom/$path"
            content_type = "application/dicom"
            file_size = ""
            created_at = $createdAt
            created_by = Get-DbValue $row "CreateUserID"
        })

        $mapRows.Add([pscustomobject]@{
            id = ConvertTo-StableGuid "migration-map:DicomFile:$oldId"
            source_table = "DicomFile"
            source_id = $oldId
            target_table = "mcr.registry_file"
            target_id = $targetId
            created_at = $createdAt
        })
    }
} finally {
    $connection.Dispose()
}

$registryFileCsv = Join-Path $OutputDirectory "registry_file.csv"
$mapCsv = Join-Path $OutputDirectory "migration_map_file.csv"
$importSql = Join-Path $OutputDirectory "10_import_files.sql"

$registryFileRows | Export-Csv -Path $registryFileCsv -NoTypeInformation -Encoding utf8BOM
$mapRows | Export-Csv -Path $mapCsv -NoTypeInformation -Encoding utf8BOM
Write-ImportSql -Path $importSql -RegistryFileCsv $registryFileCsv -MapCsv $mapCsv

$report = [pscustomobject]@{
    registry_file_count = $registryFileRows.Count
    migration_map_count = $mapRows.Count
    referenced_fileinfo_count = $referencedFileKeys.Count
    missing_fileinfo_count = $missingFileInfoCount
    parse_error_answer_count = $parseErrorCount
    output_directory = (Resolve-Path $OutputDirectory).Path
}

$report | ConvertTo-Json -Depth 4 | Set-Content -Path (Join-Path $OutputDirectory "file_migration_report.json") -Encoding utf8BOM
$report | ConvertTo-Json -Depth 4

if ($Execute) {
    Invoke-PsqlFile -ConfigPath $TargetConfigPath -SqlPath $importSql
}
