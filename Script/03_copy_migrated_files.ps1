param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot,
    [string]$TargetConfigPath = (Join-Path $PSScriptRoot "..\MultiCenterRegistry\appsettings.json"),
    [string]$ManifestPath = (Join-Path $PSScriptRoot "output\all_migration\05_files\file_manifest.csv"),
    [string]$TargetUploadRoot = "",
    [string]$TargetDicomRoot = "",
    [string]$ReportDirectory = (Join-Path $PSScriptRoot "output\all_migration\05_files\file_copy_report"),
    [switch]$UseFileNameFallback,
    [switch]$CleanupCopiedSourceFiles,
    [switch]$Overwrite,
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

function Get-Utf8BomEncoding {
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        return "utf8BOM"
    }

    return "UTF8"
}

function Export-CsvBom {
    param(
        [object]$InputObject,
        [string]$Path
    )

    $InputObject | Export-Csv -LiteralPath $Path -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
}

function Set-ContentBom {
    param(
        [string]$Path,
        [string]$Value
    )

    Set-Content -LiteralPath $Path -Value $Value -Encoding (Get-Utf8BomEncoding)
}

function Resolve-ConfiguredPath {
    param(
        [string]$ConfigPath,
        [string]$ConfiguredPath
    )

    if ([System.IO.Path]::IsPathRooted($ConfiguredPath)) {
        return $ConfiguredPath
    }

    return Join-Path (Split-Path -Parent $ConfigPath) $ConfiguredPath
}

function Get-NormalizedRelativePath {
    param([string]$Path)
    return ($Path -replace "\\", "/").TrimStart("/")
}

function Add-FileToIndex {
    param(
        [hashtable]$Index,
        [string]$Key,
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Key)) {
        return
    }

    $normalizedKey = $Key.ToLowerInvariant()
    if (-not $Index.ContainsKey($normalizedKey)) {
        $Index[$normalizedKey] = [System.Collections.Generic.List[string]]::new()
    }

    $Index[$normalizedKey].Add($Path)
}

function Get-RelativePath {
    param(
        [string]$Root,
        [string]$Path
    )

    if ([System.IO.Path].GetMethod("GetRelativePath", [type[]]@([string], [string]))) {
        return Get-NormalizedRelativePath ([System.IO.Path]::GetRelativePath($Root, $Path))
    }

    $rootPath = [System.IO.Path]::GetFullPath($Root).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
    $filePath = [System.IO.Path]::GetFullPath($Path)
    $rootUri = [Uri]$rootPath
    $fileUri = [Uri]$filePath
    $relative = [Uri]::UnescapeDataString($rootUri.MakeRelativeUri($fileUri).ToString())
    return Get-NormalizedRelativePath $relative
}

function Test-SamePath {
    param(
        [string]$Left,
        [string]$Right
    )

    return [string]::Equals(
        [System.IO.Path]::GetFullPath($Left).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar),
        [System.IO.Path]::GetFullPath($Right).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar),
        [StringComparison]::OrdinalIgnoreCase)
}

function Test-IsUnderDirectory {
    param(
        [string]$Path,
        [string]$Directory
    )

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $fullDirectory = [System.IO.Path]::GetFullPath($Directory).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
    return $fullPath.StartsWith($fullDirectory, [StringComparison]::OrdinalIgnoreCase)
}

function Remove-CopiedSourceFile {
    param(
        [string]$SourcePath,
        [string]$TargetPath,
        [string]$SourceRoot,
        [string[]]$ExcludedRoots
    )

    if ([string]::IsNullOrWhiteSpace($SourcePath) -or -not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
        return [pscustomobject]@{ Status = "skipped"; Reason = "source-not-exists" }
    }

    if (Test-SamePath -Left $SourcePath -Right $TargetPath) {
        return [pscustomobject]@{ Status = "skipped"; Reason = "same-path" }
    }

    if (-not (Test-IsUnderDirectory -Path $SourcePath -Directory $SourceRoot)) {
        return [pscustomobject]@{ Status = "skipped"; Reason = "outside-source-root" }
    }

    foreach ($excludeRoot in $ExcludedRoots) {
        if (Test-IsUnderDirectory -Path $SourcePath -Directory $excludeRoot) {
            return [pscustomobject]@{ Status = "skipped"; Reason = "inside-target-root" }
        }
    }

    if (-not (Test-Path -LiteralPath $TargetPath -PathType Leaf)) {
        return [pscustomobject]@{ Status = "skipped"; Reason = "target-not-exists" }
    }

    $sourceLength = (Get-Item -LiteralPath $SourcePath).Length
    $targetLength = (Get-Item -LiteralPath $TargetPath).Length
    if ($sourceLength -ne $targetLength) {
        return [pscustomobject]@{ Status = "skipped"; Reason = "size-mismatch" }
    }

    try {
        Remove-Item -LiteralPath $SourcePath -Force -ErrorAction Stop
        return [pscustomobject]@{ Status = "deleted"; Reason = "" }
    }
    catch {
        return [pscustomobject]@{ Status = "failed"; Reason = $_.Exception.Message }
    }
}

function Get-SourceRelativeCandidates {
    param([pscustomobject]$Row)

    $fileName = [System.IO.Path]::GetFileName([string]$Row.target_relative_path)
    return @(
        $Row.source_relative_path,
        $Row.target_relative_path,
        $fileName,
        "$($Row.source_area)/$($Row.source_relative_path)",
        "$($Row.target_area)/$($Row.target_relative_path)"
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique
}

function Resolve-SourceFile {
    param(
        [pscustomobject]$Row,
        [string]$Root,
        [hashtable]$RelativeIndex,
        [hashtable]$NameIndex,
        [bool]$UseNameFallback
    )

    $relativeCandidates = Get-SourceRelativeCandidates -Row $Row

    foreach ($relativePath in $relativeCandidates) {
        $candidate = Join-Path $Root ($relativePath -replace "/", [System.IO.Path]::DirectorySeparatorChar)
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return [pscustomobject]@{ Status = "found"; Path = $candidate; Reason = "relative" }
        }

        $relativeKey = (Get-NormalizedRelativePath $relativePath).ToLowerInvariant()
        if ($RelativeIndex.ContainsKey($relativeKey) -and $RelativeIndex[$relativeKey].Count -eq 1) {
            return [pscustomobject]@{ Status = "found"; Path = $RelativeIndex[$relativeKey][0]; Reason = "relative-index" }
        }
    }

    if (-not $UseNameFallback) {
        return [pscustomobject]@{ Status = "missing"; Path = ""; Reason = "not-found" }
    }

    $fileName = [System.IO.Path]::GetFileName([string]$Row.target_relative_path)
    if ([string]::IsNullOrWhiteSpace($fileName)) {
        return [pscustomobject]@{ Status = "missing"; Path = ""; Reason = "empty-file-name" }
    }

    $nameKey = $fileName.ToLowerInvariant()
    if (-not $NameIndex.ContainsKey($nameKey)) {
        return [pscustomobject]@{ Status = "missing"; Path = ""; Reason = "name-not-found" }
    }

    $matches = @($NameIndex[$nameKey])
    if ($matches.Count -eq 1) {
        return [pscustomobject]@{ Status = "found"; Path = $matches[0]; Reason = "file-name" }
    }

    return [pscustomobject]@{ Status = "ambiguous"; Path = ""; Reason = "file-name-duplicated"; Count = $matches.Count }
}

if (-not (Test-Path -LiteralPath $SourceRoot -PathType Container)) {
    throw "旧系统文件总目录不存在：$SourceRoot"
}

if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
    throw "文件迁移清单不存在：$ManifestPath"
}

if (([string]::IsNullOrWhiteSpace($TargetUploadRoot) -or [string]::IsNullOrWhiteSpace($TargetDicomRoot)) -and (Test-Path -LiteralPath $TargetConfigPath -PathType Leaf)) {
    $config = Get-Content $TargetConfigPath -Raw | ConvertFrom-Json
    if ([string]::IsNullOrWhiteSpace($TargetUploadRoot) -and $config.FileStorage.UploadRoot) {
        $TargetUploadRoot = Resolve-ConfiguredPath -ConfigPath $TargetConfigPath -ConfiguredPath ([string]$config.FileStorage.UploadRoot)
    }

    if ([string]::IsNullOrWhiteSpace($TargetDicomRoot) -and $config.FileStorage.DicomRoot) {
        $TargetDicomRoot = Resolve-ConfiguredPath -ConfigPath $TargetConfigPath -ConfiguredPath ([string]$config.FileStorage.DicomRoot)
    }
}

if ([string]::IsNullOrWhiteSpace($TargetUploadRoot) -or [string]::IsNullOrWhiteSpace($TargetDicomRoot)) {
    throw "请提供 TargetUploadRoot 和 TargetDicomRoot，或在 appsettings.json 中配置 FileStorage。"
}

New-Item -ItemType Directory -Force -Path $ReportDirectory | Out-Null

$rows = @(Import-Csv -LiteralPath $ManifestPath)
$sourceFullRoot = (Resolve-Path -LiteralPath $SourceRoot).Path
$targetUploadFullRoot = [System.IO.Path]::GetFullPath($TargetUploadRoot)
$targetDicomFullRoot = [System.IO.Path]::GetFullPath($TargetDicomRoot)
$excludeRoots = @()
if ((Test-IsUnderDirectory -Path $targetUploadFullRoot -Directory $sourceFullRoot) -and -not (Test-SamePath -Left $sourceFullRoot -Right $targetUploadFullRoot)) {
    $excludeRoots += $targetUploadFullRoot
}

if ((Test-IsUnderDirectory -Path $targetDicomFullRoot -Directory $sourceFullRoot) -and -not (Test-SamePath -Left $sourceFullRoot -Right $targetDicomFullRoot)) {
    $excludeRoots += $targetDicomFullRoot
}

Write-Host "正在读取旧文件根目录索引..."
$rootNameIndex = @{}
$rootFileCount = 0
Get-ChildItem -LiteralPath $sourceFullRoot -File | ForEach-Object {
    Add-FileToIndex -Index $rootNameIndex -Key $_.Name -Path $_.FullName
    $rootFileCount++
}
Write-Host "旧文件根目录索引完成：$rootFileCount 个文件。"

Write-Host "正在按迁移清单快速匹配源文件..."
$directSourceMap = @{}
$unresolvedRows = [System.Collections.Generic.List[object]]::new()
$directFound = 0
foreach ($row in $rows) {
    $fileName = [System.IO.Path]::GetFileName([string]$row.target_relative_path)
    $nameKey = if ([string]::IsNullOrWhiteSpace($fileName)) { "" } else { $fileName.ToLowerInvariant() }
    if (-not [string]::IsNullOrWhiteSpace($nameKey) -and $rootNameIndex.ContainsKey($nameKey) -and $rootNameIndex[$nameKey].Count -eq 1) {
        $directSourceMap[$row.target_file_id] = [pscustomobject]@{ Status = "found"; Path = $rootNameIndex[$nameKey][0]; Reason = "root-file-name" }
        $directFound++
    }
    else {
        $unresolvedRows.Add($row)
    }
}

Write-Host "快速匹配完成：$directFound / $($rows.Count)。"

$relativeIndex = @{}
$nameIndex = @{}
if ($unresolvedRows.Count -gt 0) {
    Write-Host "仍有 $($unresolvedRows.Count) 个文件需要递归扫描匹配。"
    $neededRelativeKeys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $neededNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($row in $unresolvedRows) {
        foreach ($relativePath in (Get-SourceRelativeCandidates -Row $row)) {
            $null = $neededRelativeKeys.Add((Get-NormalizedRelativePath $relativePath).ToLowerInvariant())
        }

        $fileName = [System.IO.Path]::GetFileName([string]$row.target_relative_path)
        if (-not [string]::IsNullOrWhiteSpace($fileName)) {
            $null = $neededNames.Add($fileName.ToLowerInvariant())
        }
    }

    $scanned = 0
    $indexed = 0
    Get-ChildItem -LiteralPath $sourceFullRoot -File -Recurse | ForEach-Object {
        foreach ($excludeRoot in $excludeRoots) {
            if (Test-IsUnderDirectory -Path $_.FullName -Directory $excludeRoot) {
                return
            }
        }

        $scanned++
        $relativePath = Get-RelativePath -Root $sourceFullRoot -Path $_.FullName
        $relativeKey = (Get-NormalizedRelativePath $relativePath).ToLowerInvariant()
        $nameKey = $_.Name.ToLowerInvariant()
        if ($neededRelativeKeys.Contains($relativeKey)) {
            Add-FileToIndex -Index $relativeIndex -Key $relativePath -Path $_.FullName
            $indexed++
        }

        if ($UseFileNameFallback -and $neededNames.Contains($nameKey)) {
            Add-FileToIndex -Index $nameIndex -Key $_.Name -Path $_.FullName
            $indexed++
        }

        if (($scanned % 2000) -eq 0) {
            Write-Host "已扫描源文件：$scanned，命中索引：$indexed。"
        }
    }

    Write-Host "递归扫描完成：已扫描 $scanned 个源文件，命中索引 $indexed 条。"
}

$resultRows = [System.Collections.Generic.List[object]]::new()
$copied = 0
$skipped = 0
$missing = 0
$ambiguous = 0
$planned = 0
$processed = 0
$cleanupDeleted = 0
$cleanupSkipped = 0
$cleanupFailed = 0
$cleanupCandidates = [System.Collections.Generic.List[object]]::new()

foreach ($row in $rows) {
    $processed++
    $targetRoot = if ($row.target_area -eq "dicom") { $TargetDicomRoot } else { $TargetUploadRoot }
    $targetRelativePath = Get-NormalizedRelativePath ([string]$row.target_relative_path)
    $targetPath = Join-Path $targetRoot ($targetRelativePath -replace "/", [System.IO.Path]::DirectorySeparatorChar)
    $source = if ($directSourceMap.ContainsKey($row.target_file_id)) {
        $directSourceMap[$row.target_file_id]
    }
    elseif (Test-Path -LiteralPath $targetPath -PathType Leaf) {
        [pscustomobject]@{ Status = "found"; Path = $targetPath; Reason = "target-existing" }
    }
    else {
        Resolve-SourceFile -Row $row -Root $sourceFullRoot -RelativeIndex $relativeIndex -NameIndex $nameIndex -UseNameFallback:$UseFileNameFallback
    }
    $status = $source.Status
    $shouldCleanup = $false

    if ($status -eq "found") {
        if (Test-SamePath -Left $source.Path -Right $targetPath) {
            $status = "skipped"
            $skipped++
        }
        elseif ((Test-Path -LiteralPath $targetPath -PathType Leaf) -and -not $Overwrite) {
            $status = "skipped"
            $skipped++
        }
        elseif ($PlanOnly) {
            $status = "planned"
            $planned++
        }
        else {
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $targetPath) | Out-Null
            Copy-Item -LiteralPath $source.Path -Destination $targetPath -Force:$Overwrite
            $status = "copied"
            $copied++
            $shouldCleanup = $CleanupCopiedSourceFiles
        }
    }
    elseif ($status -eq "ambiguous") {
        $ambiguous++
    }
    else {
        $missing++
    }

    $resultRow = [pscustomobject]@{
        target_file_id = $row.target_file_id
        target_area = $row.target_area
        target_relative_path = $targetRelativePath
        source_path = $source.Path
        target_path = $targetPath
        status = $status
        reason = $source.Reason
        cleanup_status = ""
        cleanup_reason = ""
    }
    $resultRows.Add($resultRow)

    if ($shouldCleanup) {
        $cleanupCandidates.Add([pscustomobject]@{
            source_path = $source.Path
            target_path = $targetPath
            result = $resultRow
        })
    }

    if (($processed % 500) -eq 0) {
        Write-Host "文件归位进度：$processed / $($rows.Count)，复制 $copied，跳过 $skipped，缺失 $missing，重名 $ambiguous，清理 $cleanupDeleted。"
    }
}

if ($CleanupCopiedSourceFiles -and -not $PlanOnly -and $cleanupCandidates.Count -gt 0) {
    Write-Host "正在清理已成功归位的源文件..."
    $cleanupBySource = @{}
    foreach ($candidate in $cleanupCandidates) {
        $sourceKey = [System.IO.Path]::GetFullPath([string]$candidate.source_path).ToLowerInvariant()
        if (-not $cleanupBySource.ContainsKey($sourceKey)) {
            $cleanupBySource[$sourceKey] = [System.Collections.Generic.List[object]]::new()
        }

        $cleanupBySource[$sourceKey].Add($candidate)
    }

    $cleanupProcessed = 0
    foreach ($sourceKey in $cleanupBySource.Keys) {
        $items = $cleanupBySource[$sourceKey]
        $first = $items[0]
        $cleanup = Remove-CopiedSourceFile -SourcePath $first.source_path -TargetPath $first.target_path -SourceRoot $sourceFullRoot -ExcludedRoots $excludeRoots
        if ($cleanup.Status -eq "deleted") {
            $cleanupDeleted++
        }
        elseif ($cleanup.Status -eq "failed") {
            $cleanupFailed++
        }
        else {
            $cleanupSkipped++
        }

        foreach ($item in $items) {
            $item.result.cleanup_status = $cleanup.Status
            $item.result.cleanup_reason = $cleanup.Reason
        }

        $cleanupProcessed++
        if (($cleanupProcessed % 500) -eq 0) {
            Write-Host "源文件清理进度：$cleanupProcessed / $($cleanupBySource.Count)，已删除 $cleanupDeleted，跳过 $cleanupSkipped，失败 $cleanupFailed。"
        }
    }

    Write-Host "源文件清理完成：已删除 $cleanupDeleted，跳过 $cleanupSkipped，失败 $cleanupFailed。"
}

$reportCsv = Join-Path $ReportDirectory "file_copy_result.csv"
$reportJson = Join-Path $ReportDirectory "file_copy_summary.json"
Export-CsvBom -InputObject $resultRows -Path $reportCsv

$summary = [ordered]@{
    total = $rows.Count
    copied = $copied
    skipped = $skipped
    planned = $planned
    missing = $missing
    ambiguous = $ambiguous
    cleanup_deleted = $cleanupDeleted
    cleanup_skipped = $cleanupSkipped
    cleanup_failed = $cleanupFailed
    source_root = $sourceFullRoot
    target_upload_root = $TargetUploadRoot
    target_dicom_root = $TargetDicomRoot
    result_csv = $reportCsv
}

Set-ContentBom -Path $reportJson -Value ($summary | ConvertTo-Json -Depth 4)
$summary | ConvertTo-Json -Depth 4
