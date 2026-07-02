param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$TargetConnection = $env:MCR_TARGET_POSTGRES,
    [string]$TargetConfigPath = "./MultiCenterRegistry/appsettings.json",
    [string]$OutputDirectory = "./Script/output/all_migration",
    [string]$TemporaryPasswordHash = $env:MCR_TEMP_PASSWORD_HASH,
    [string]$SourceUploadRoot = $env:MCR_SOURCE_UPLOAD_ROOT,
    [string]$SourceDicomRoot = $env:MCR_SOURCE_DICOM_ROOT,
    [string]$TargetUploadRoot = $env:MCR_TARGET_UPLOAD_ROOT,
    [string]$TargetDicomRoot = $env:MCR_TARGET_DICOM_ROOT,
    [switch]$Export,
    [switch]$Execute,
    [switch]$CopyFiles,
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

function Get-Utf8BomEncoding {
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        return "utf8BOM"
    }

    return "UTF8"
}

if ($PlanOnly -or (-not $Export -and -not $Execute)) {
    Write-Host "总迁移脚本计划："
    Write-Host "1. 读取旧 SQL Server 身份、病例、数据报表、会议评审、附件、文章数据。"
    Write-Host "2. 生成 CSV 和 01_import_all.sql。"
    Write-Host "3. 生成附件清单 05_files/file_manifest.csv；指定 -CopyFiles 且提供文件根目录时复制实体文件。"
    Write-Host "4. 导入 SQL 会按 mcr.migration_map 定点清理 system 中的 MCR 数据，删除并重建 mcr schema。"
    Write-Host "5. 指定 -Execute 时才调用 psql 写入目标库。"
    return
}

if ([string]::IsNullOrWhiteSpace($SourceConnection)) {
    throw "请先通过环境变量 MCR_SOURCE_SQLSERVER 或参数 SourceConnection 提供旧库连接字符串。"
}

if ([string]::IsNullOrWhiteSpace($TemporaryPasswordHash)) {
    throw "请通过参数 TemporaryPasswordHash 或环境变量 MCR_TEMP_PASSWORD_HASH 提供 Bio.Core 生成的临时密码哈希。"
}

function Get-MigrationSqlConnectionType {
    try {
        Add-Type -AssemblyName "Microsoft.Data.SqlClient"
        return "Microsoft.Data.SqlClient.SqlConnection"
    } catch {
        Add-Type -AssemblyName "System.Data"
        return "System.Data.SqlClient.SqlConnection"
    }
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

function Get-TargetGuid {
    param(
        [string]$Prefix,
        [string]$OldId
    )

    $guid = [Guid]::Empty
    if ([Guid]::TryParse($OldId, [ref]$guid)) {
        return $guid.ToString()
    }

    return ConvertTo-StableGuid "${Prefix}:$OldId"
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

function Get-IntegerText {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return ""
    }

    $match = [regex]::Match($Value, "-?\d+")
    if (-not $match.Success) {
        return ""
    }

    return $match.Value
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

function Test-SourceTable {
    param(
        [object]$Connection,
        [string]$TableName
    )

    $safeName = $TableName.Replace("'", "''")
    $result = Invoke-SourceQuery $Connection "select case when object_id(N'$safeName') is null then 0 else 1 end as ExistsFlag"
    return (Get-DbValue $result.Rows[0] "ExistsFlag") -eq "1"
}

function ConvertTo-SqlText {
    param([string]$Value)

    return "'" + $Value.Replace("'", "''") + "'"
}

function ConvertTo-ImportPath {
    param([string]$Path)

    return (Resolve-Path $Path).Path.Replace("\", "/")
}

function Write-Utf8BomFile {
    param(
        [string]$Path,
        [string]$Content
    )

    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($true))
}

function Invoke-PsqlFile {
    param(
        [string]$ConfigPath,
        [string]$ConnectionString,
        [string]$SqlPath
    )

    if ([string]::IsNullOrWhiteSpace($ConnectionString)) {
        if ([string]::IsNullOrWhiteSpace($ConfigPath) -or -not (Test-Path $ConfigPath)) {
            throw "请通过 TargetConnection、环境变量 MCR_TARGET_POSTGRES 或 TargetConfigPath 提供目标 PostgreSQL 连接。"
        }

        $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
        $ConnectionString = $config.ConnectionStrings.DefaultConnection
    }

    $parts = @{}
    $ConnectionString -split ";" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
        $kv = $_.Split("=", 2)
        $parts[$kv[0].Trim()] = $kv[1].Trim()
    }

    $hostValue = if ($parts.ContainsKey("Host")) { $parts.Host } elseif ($parts.ContainsKey("Server")) { $parts.Server } else { "" }
    $database = if ($parts.ContainsKey("Database")) { $parts.Database } elseif ($parts.ContainsKey("Db")) { $parts.Db } else { "" }
    $user = if ($parts.ContainsKey("Username")) { $parts.Username } elseif ($parts.ContainsKey("User ID")) { $parts["User ID"] } elseif ($parts.ContainsKey("User")) { $parts.User } elseif ($parts.ContainsKey("Uid")) { $parts.Uid } else { "" }
    $password = if ($parts.ContainsKey("Password")) { $parts.Password } elseif ($parts.ContainsKey("Pwd")) { $parts.Pwd } else { "" }

    if ([string]::IsNullOrWhiteSpace($hostValue) -or [string]::IsNullOrWhiteSpace($database) -or [string]::IsNullOrWhiteSpace($user)) {
        throw "目标 PostgreSQL 连接串必须包含 Host/Server、Database、Username/User ID。"
    }

    $hostParts = $hostValue.Split(":", 2)
    $port = if ($parts.ContainsKey("Port")) { $parts.Port } elseif ($hostParts.Count -gt 1) { $hostParts[1] } else { "5432" }

    $env:PGPASSWORD = $password
    & psql -v ON_ERROR_STOP=1 -h $hostParts[0] -p $port -U $user -d $database -f $SqlPath
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

function Get-NormalizedFieldKey {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return ""
    }

    $text = $Value.ToLowerInvariant()
    return [regex]::Replace($text, "[\s　:：,，;；、/\\()（）\[\]【】<>《》？?。\.·•_\-]", "")
}

function Add-FieldAlias {
    param(
        [hashtable]$Lookup,
        [string]$Target,
        [string[]]$Labels
    )

    foreach ($label in @($Target) + $Labels) {
        $key = Get-NormalizedFieldKey $label
        if (-not [string]::IsNullOrWhiteSpace($key) -and -not $Lookup.ContainsKey($key)) {
            $Lookup[$key] = $Target
        }
    }
}

function New-FixedFieldLookup {
    param([string]$BusinessType)

    $lookup = @{}
    if ($BusinessType -eq "case") {
        Add-FieldAlias $lookup "patient_name" @("患者姓名", "姓名")
        Add-FieldAlias $lookup "patient_sex" @("性别", "患者性别")
        Add-FieldAlias $lookup "patient_age" @("年龄", "患者年龄")
        Add-FieldAlias $lookup "id_number" @("身份证号码", "身份证号", "证件号码")
        Add-FieldAlias $lookup "patient_number" @("病案号", "住院号", "住院病案号")
        Add-FieldAlias $lookup "department_name" @("住院科室")
        Add-FieldAlias $lookup "operator_id" @("术者")
        Add-FieldAlias $lookup "admission_time" @("入院时间", "入院日期")
        Add-FieldAlias $lookup "discharge_time" @("出院时间", "出院日期")
        Add-FieldAlias $lookup "operation_time" @("手术时间", "手术日期", "介入时间")
        Add-FieldAlias $lookup "hospital_stay_days" @("住院天数", "住院日")
        Add-FieldAlias $lookup "surgery_type_value" @("手术类型")
        Add-FieldAlias $lookup "coronary_intervention" @("冠心病介入", "冠脉介入", "冠心病介入类型")
        Add-FieldAlias $lookup "ablation_intervention" @("导管消融", "消融介入", "导管消融类型")
        Add-FieldAlias $lookup "structural_intervention" @("结构性心脏病介入", "结构性心脏病", "结构性介入")
        Add-FieldAlias $lookup "is_emergency_intervention" @("是否急诊介入", "急诊介入")
        Add-FieldAlias $lookup "discharge_mode" @("离院方式", "出院方式", "转归")
        Add-FieldAlias $lookup "situation_reason" @("情况/原因说明", "情况说明/原因说明", "原因说明", "特殊情况说明")
        Add-FieldAlias $lookup "situation_supplement" @("补充说明", "其他说明")
        Add-FieldAlias $lookup "death_time" @("死亡时间", "死亡日期")
        Add-FieldAlias $lookup "case_summary" @("病例简介", "病例摘要", "摘要内容", "简要病史", "病情简介")
        Add-FieldAlias $lookup "discharge_diagnosis" @("出院诊断", "诊断")
        Add-FieldAlias $lookup "other_exam" @("其他检查", "相关检查", "辅助检查")
        Add-FieldAlias $lookup "angiography_result" @("造影结果", "造影检查结果", "造影所见")
        Add-FieldAlias $lookup "intervention_process" @("介入过程", "介入经过", "手术过程", "操作过程")
        Add-FieldAlias $lookup "rescue_process" @("抢救过程", "救治过程", "救治经过")
        Add-FieldAlias $lookup "lab_file" @("化验单图片上传", "化验单上传", "化验单", "HYCTPSC")
        Add-FieldAlias $lookup "ecg_file" @("心电图图片上传", "心电图上传", "心电图", "XDTTPSC")
        Add-FieldAlias $lookup "echo_file" @("心脏彩超", "心脏彩超图片上传", "彩超", "XZCC")
        Add-FieldAlias $lookup "complication_discussion" @("并发症讨论", "是否组织医院或科室并发症讨论", "并发症病例讨论", "讨论记录")
        Add-FieldAlias $lookup "occurrence_reason" @("发生原因", "并发症发生原因")
        Add-FieldAlias $lookup "death_reason" @("死亡原因", "死因")
        Add-FieldAlias $lookup "lessons_learned" @("经验教训", "教训")
        Add-FieldAlias $lookup "improvement_measures" @("改进措施", "整改措施")
        return $lookup
    }

    if ($BusinessType -eq "quality") {
        Add-FieldAlias $lookup "total" @("总例数", "病例总例数")
        Add-FieldAlias $lookup "death" @("死亡例数", "死亡病例数")
        Add-FieldAlias $lookup "complication" @("并发症例数", "并发症病例数")
        Add-FieldAlias $lookup "rescue" @("并发症救治例数", "救治例数")
        Add-FieldAlias $lookup "discussion" @("组织并发症讨论例数", "讨论例数")
        Add-FieldAlias $lookup "improvement" @("制定改进措施例数", "改进措施例数")
        return $lookup
    }

    Add-FieldAlias $lookup "indication" @("手术适应证", "介入适应症", "适应证")
    Add-FieldAlias $lookup "operation" @("介入操作", "操作规范性")
    Add-FieldAlias $lookup "device_complete" @("器械准备", "设备器械配套是否齐全", "器械是否齐全")
    Add-FieldAlias $lookup "surgery_level_implemented" @("手术级别落实", "介入分级手术管理是否落实到位", "是否落实手术级别")
    Add-FieldAlias $lookup "has_management_problem" @("是否存在管理问题", "是否存在其他管理问题", "存在管理问题")
    Add-FieldAlias $lookup "management_problem_description" @("管理问题说明", "管理问题描述", "其他管理问题描述")
    Add-FieldAlias $lookup "rescue_timely" @("抢救是否及时", "救治是否及时")
    Add-FieldAlias $lookup "rescue_measure_proper" @("抢救措施是否得当", "救治措施是否得当")
    Add-FieldAlias $lookup "rescue_device_complete" @("抢救器械是否齐全", "救治器械是否齐全", "救治药品设备是否齐全")
    Add-FieldAlias $lookup "death_reason" @("死亡原因", "死因")
    Add-FieldAlias $lookup "other_death_reason" @("其他死亡原因", "其他死因")
    Add-FieldAlias $lookup "need_improvement" @("是否需要改进", "是否需要提交进一步改进措施", "需要改进")
    Add-FieldAlias $lookup "improvement_content" @("改进内容", "改进措施内容", "改进措施", "整改内容")
    return $lookup
}

function Get-AnswerText {
    param([System.Data.DataRow]$Row)

    $text = Get-DbValue $Row "HisAnswer"
    if ([string]::IsNullOrWhiteSpace($text)) {
        $text = Get-DbValue $Row "Answer"
    }

    return $text.Trim()
}

function ConvertTo-SexValue {
    param([string]$Value)

    switch (Get-NormalizedFieldKey $Value) {
        "男" { return "1" }
        "女" { return "2" }
        default { return $Value }
    }
}

function ConvertTo-YesNoValue {
    param([string]$Value)

    switch (Get-NormalizedFieldKey $Value) {
        { $_ -in @("是", "1", "true", "有") } { return "1" }
        { $_ -in @("否", "2", "false", "无") } { return "2" }
        default { return $Value }
    }
}

function ConvertTo-DateText {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return ""
    }

    $date = [datetime]::MinValue
    if ([datetime]::TryParse($Value, [ref]$date)) {
        return $date.ToString("yyyy-MM-dd HH:mm:ss")
    }

    return ""
}

function Get-DiseaseName {
    param([string]$Value)

    switch ($Value) {
        "6237dd62-15b9-4676-972d-bf32476b3546" { return "冠心病介入" }
        "c1174c60-2ef2-45f6-85dd-5269b567f996" { return "结构性心脏病介入" }
        "f827ae4a-f24f-4df9-b92f-7601025a1864" { return "起搏器及CIED植入/置换" }
        "ae92e4fa-5e02-4d4c-a773-3dc79c4935bc" { return "导管消融" }
        default { return $Value }
    }
}

function Get-BoolText {
    param([bool]$Value)

    if ($Value) {
        return "true"
    }

    return "false"
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

function Get-ObjectText {
    param(
        [object]$Object,
        [string[]]$Names
    )

    if ($null -eq $Object) {
        return ""
    }

    foreach ($property in $Object.PSObject.Properties) {
        foreach ($name in $Names) {
            if ($property.Name.Equals($name, [System.StringComparison]::OrdinalIgnoreCase)) {
                $value = [string]$property.Value
                if (-not [string]::IsNullOrWhiteSpace($value)) {
                    return $value
                }
            }
        }
    }

    return ""
}

function Get-FileRemark {
    param(
        [object]$File,
        [object]$ResponseFile
    )

    $names = @("remark", "remarks", "fileRemark", "fileRemarks", "description", "describe", "comment", "note", "memo", "bz", "beizhu", "备注")
    $remark = Get-ObjectText -Object $ResponseFile -Names $names
    if ([string]::IsNullOrWhiteSpace($remark)) {
        $remark = Get-ObjectText -Object $File -Names $names
    }

    return $remark
}

function ConvertTo-RelativeFilePath {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return ""
    }

    return $Path.TrimStart([char[]]@('\', '/')).Replace("\", "/")
}

function Resolve-MigrationFilePath {
    param(
        [string]$Root,
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return ""
    }

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }

    if ([string]::IsNullOrWhiteSpace($Root)) {
        return ""
    }

    $normalized = $Path.Replace("/", [System.IO.Path]::DirectorySeparatorChar).Replace("\", [System.IO.Path]::DirectorySeparatorChar)
    return [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($Root, $normalized))
}

function Copy-MigrationFile {
    param(
        [string]$SourcePath,
        [string]$TargetPath
    )

    if (-not $CopyFiles -or [string]::IsNullOrWhiteSpace($SourcePath) -or [string]::IsNullOrWhiteSpace($TargetPath) -or -not (Test-Path $SourcePath)) {
        return $false
    }

    $targetDirectory = [System.IO.Path]::GetDirectoryName($TargetPath)
    if (-not [string]::IsNullOrWhiteSpace($targetDirectory)) {
        New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
    }

    Copy-Item -LiteralPath $SourcePath -Destination $TargetPath -Force
    return $true
}

function Add-FileManifestRow {
    param(
        [System.Collections.Generic.List[object]]$Rows,
        [string]$TargetFileId,
        [string]$OwnerType,
        [string]$OwnerId,
        [string]$SourceArea,
        [string]$SourceRoot,
        [string]$SourceRelativePath,
        [string]$TargetArea,
        [string]$TargetRoot,
        [string]$TargetRelativePath
    )

    $sourcePath = Resolve-MigrationFilePath -Root $SourceRoot -Path $SourceRelativePath
    $targetPath = Resolve-MigrationFilePath -Root $TargetRoot -Path $TargetRelativePath
    $existsInSource = (-not [string]::IsNullOrWhiteSpace($sourcePath)) -and (Test-Path $sourcePath)
    $copied = Copy-MigrationFile -SourcePath $sourcePath -TargetPath $targetPath

    $Rows.Add([pscustomobject]@{
        target_file_id = $TargetFileId
        owner_type = $OwnerType
        owner_id = $OwnerId
        source_area = $SourceArea
        source_relative_path = $SourceRelativePath
        target_area = $TargetArea
        target_relative_path = $TargetRelativePath
        source_path = $sourcePath
        target_path = $targetPath
        exists_in_source = Get-BoolText $existsInSource
        copied = Get-BoolText $copied
    })
}

function Split-FileCode {
    param(
        [string]$FileCode,
        [string]$FallbackName,
        [string]$FallbackSize,
        [string]$Remark
    )

    $items = [System.Collections.Generic.List[object]]::new()
    if ([string]::IsNullOrWhiteSpace($FileCode)) {
        return $items
    }

    foreach ($part in ($FileCode -split [regex]::Escape("#!#"))) {
        $clean = ($part -replace "###.*$", "").Trim()
        if ([string]::IsNullOrWhiteSpace($clean)) {
            continue
        }

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
            Remark = $Remark
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
                $remark = Get-FileRemark -File $file -ResponseFile $responseFile
                foreach ($item in (Split-FileCode -FileCode ([string]$responseFile.fileCode) -FallbackName $name -FallbackSize $size -Remark $remark)) {
                    if ($seen.Add($item.RelativePath)) {
                        $items.Add($item)
                    }
                }
            }
            continue
        }

        $url = [string]$file.url
        if (-not [string]::IsNullOrWhiteSpace($url)) {
            $remark = Get-FileRemark -File $file -ResponseFile $null
            foreach ($item in (Split-FileCode -FileCode $url -FallbackName $name -FallbackSize $size -Remark $remark)) {
                if ($seen.Add($item.RelativePath)) {
                    $items.Add($item)
                }
            }
        }
    }

    return $items
}

function Get-CaseFileFieldKey {
    param(
        [System.Data.DataRow]$Row,
        [hashtable]$Lookup
    )

    foreach ($value in @((Get-DbValue $Row "FieldName"), (Get-DbValue $Row "FieldCode"))) {
        $key = Get-NormalizedFieldKey $value
        if (-not [string]::IsNullOrWhiteSpace($key) -and $Lookup.ContainsKey($key)) {
            return $Lookup[$key]
        }
    }

    return ""
}

function Get-MigratedCaseFileRelativePath {
    param(
        [string]$OwnerId,
        [string]$FieldKey,
        [string]$StoredName
    )

    $casePathId = $OwnerId.Replace("-", "")
    return "cases/$casePathId/$FieldKey/$StoredName"
}

function Set-FixedAnswer {
    param(
        [System.Collections.Specialized.OrderedDictionary]$Row,
        [string]$Target,
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value) -or -not $Row.Contains($Target)) {
        return
    }

    switch ($Target) {
        "patient_sex" {
            $Row[$Target] = ConvertTo-SexValue $Value
            $Row["patient_sex_text"] = $Value
        }
        "is_emergency_intervention" {
            $Row[$Target] = ConvertTo-YesNoValue $Value
        }
        { $_ -in @("admission_time", "discharge_time", "operation_time", "death_time") } {
            $dateValue = ConvertTo-DateText $Value
            if (-not [string]::IsNullOrWhiteSpace($dateValue)) {
                $Row[$Target] = $dateValue
            }
        }
        "hospital_stay_days" {
            $Row[$Target] = Get-IntegerText $Value
        }
        "surgery_type_value" {
            $Row[$Target] = $Value
            if ($Row.Contains("surgery_type_text")) {
                $Row["surgery_type_text"] = Get-DiseaseName $Value
            }
        }
        default {
            $Row[$Target] = $Value
        }
    }
}

function Write-AllImportSql {
    param(
        [string]$Path,
        [hashtable]$Files,
        [string]$SchemaPath
    )

    $sql = @'
begin;

create schema if not exists system;
create table if not exists system.sys_user (
    id uuid primary key, account text not null, password text not null, display_name text not null,
    email text, can_grant_to_other boolean not null, is_valid boolean not null,
    must_change_password boolean not null, source_type text
);
create table if not exists system.sys_permission (
    id uuid primary key, code text, name text not null, describe text, type text
);
create table if not exists system.sys_role (
    id uuid primary key, name text not null, describe text, type text, is_valid boolean not null, owner_user_id uuid
);
create table if not exists system.sys_map_user_role (
    user_id uuid not null, role_id uuid not null, primary key (user_id, role_id)
);
create table if not exists system.sys_map_role_permission (
    role_id uuid not null, permission_id uuid not null, primary key (role_id, permission_id)
);
create table if not exists system.sys_user_role_scope (
    id uuid primary key, user_id uuid not null, role_id uuid not null, hospital_id uuid not null,
    hospital_name text not null, department_id uuid, department_name text, created_at timestamp without time zone not null
);
create table if not exists system.sys_hospital (
    id uuid primary key, name text not null
);
create table if not exists system.sys_department (
    id uuid primary key, hospital_id uuid not null, name text not null, display_name text
);

create temp table tmp_hospital (id text, old_id text, name text);
\copy tmp_hospital from __HOSPITAL_CSV__ with (format csv, header true);
create temp table tmp_department (id text, old_id text, old_hospital_id text, name text, display_name text);
\copy tmp_department from __DEPARTMENT_CSV__ with (format csv, header true);
create temp table tmp_user (
    id text, old_id text, account text, password_hash text, display_name text,
    email text, is_valid text, must_change_password text, source_type text,
    old_hospital_id text, old_department_id text
);
\copy tmp_user from __USER_CSV__ with (format csv, header true);
create temp table tmp_role (id text, old_id text, name text, describe text, type text, is_valid text);
\copy tmp_role from __ROLE_CSV__ with (format csv, header true);
create temp table tmp_permission (id text, old_id text, name text, describe text, type text, code text);
\copy tmp_permission from __PERMISSION_CSV__ with (format csv, header true);
create temp table tmp_role_permission (role_old_id text, permission_old_id text);
\copy tmp_role_permission from __ROLE_PERMISSION_CSV__ with (format csv, header true);
create temp table tmp_user_role (user_old_id text, role_old_id text, old_hospital_id text, old_department_id text, scope_id text);
\copy tmp_user_role from __USER_ROLE_CSV__ with (format csv, header true);
create temp table tmp_quality_user_map (old_quality_id text, user_old_id text);
\copy tmp_quality_user_map from __QUALITY_USER_MAP_CSV__ with (format csv, header true);

create temp table tmp_preserved_system_user as
select id as target_id
from system.sys_user;

create temp table tmp_existing_user as
select distinct u.old_id, u.account, su.id as target_id
from tmp_user u
join system.sys_user su on lower(su.account) = lower(u.account);

do $$
begin
    if to_regclass('mcr.migration_map') is not null then
        execute $sql$
            delete from system.sys_user_role_scope scope
            using mcr.migration_map map
            where (
                    (map.source_table = 'MCR_User' and scope.user_id = map.target_id)
                 or (map.source_table = 'MCR_Role' and scope.role_id = map.target_id)
                 or (
                     map.source_table = 'MCR_Hospital'
                     and scope.hospital_id = map.target_id
                     and exists (
                         select 1 from tmp_hospital source
                         where source.old_id = map.source_id and source.id::uuid = map.target_id
                     )
                 )
                 or (
                     map.source_table = 'MCR_Department'
                     and scope.department_id = map.target_id
                     and exists (
                         select 1 from tmp_department source
                         where source.old_id = map.source_id and source.id::uuid = map.target_id
                     )
                 )
              )
              and not exists (
                  select 1 from tmp_preserved_system_user preserved_user
                  where preserved_user.target_id = scope.user_id
              )
        $sql$;
        execute $sql$
            delete from system.sys_map_user_role user_role
            using mcr.migration_map map
            where (
                    (map.source_table = 'MCR_User' and user_role.user_id = map.target_id)
                 or (map.source_table = 'MCR_Role' and user_role.role_id = map.target_id)
              )
              and not exists (
                  select 1 from tmp_preserved_system_user preserved_user
                  where preserved_user.target_id = user_role.user_id
              )
        $sql$;
        execute $sql$
            delete from system.sys_map_role_permission role_permission
            using mcr.migration_map map
            where (map.source_table = 'MCR_Role' and role_permission.role_id = map.target_id)
               or (map.source_table = 'MCR_FunctionPower' and role_permission.permission_id = map.target_id)
        $sql$;
        execute $sql$
            delete from system.sys_department department
            using mcr.migration_map map
            where map.source_table = 'MCR_Department' and department.id = map.target_id
              and exists (
                  select 1 from tmp_department source
                  where source.old_id = map.source_id and source.id::uuid = map.target_id
              )
              and not exists (
                  select 1 from system.sys_user_role_scope scope
                  where scope.department_id = department.id
              )
        $sql$;
        execute $sql$
            delete from system.sys_hospital hospital
            using mcr.migration_map map
            where map.source_table = 'MCR_Hospital' and hospital.id = map.target_id
              and exists (
                  select 1 from tmp_hospital source
                  where source.old_id = map.source_id and source.id::uuid = map.target_id
              )
              and not exists (
                  select 1 from system.sys_user_role_scope scope
                  where scope.hospital_id = hospital.id
              )
              and not exists (
                  select 1 from system.sys_department department
                  where department.hospital_id = hospital.id
              )
        $sql$;
        execute $sql$
            delete from system.sys_permission permission
            using mcr.migration_map map
            where map.source_table = 'MCR_FunctionPower'
              and permission.id = map.target_id
              and permission.code like 'Power-MCR-%'
        $sql$;
        execute $sql$
            delete from system.sys_role role_row
            using mcr.migration_map map
            where map.source_table = 'MCR_Role'
              and role_row.id = map.target_id
              and role_row.type = 'MCR'
              and not exists (
                  select 1 from system.sys_map_user_role user_role
                  where user_role.role_id = role_row.id
              )
              and not exists (
                  select 1 from system.sys_user_role_scope scope
                  where scope.role_id = role_row.id
              )
        $sql$;
        execute $sql$
            delete from system.sys_user user_row
            using mcr.migration_map map
            where map.source_table = 'MCR_User'
              and user_row.id = map.target_id
              and user_row.source_type = 'mcr'
              and not exists (
                  select 1 from tmp_preserved_system_user preserved_user
                  where preserved_user.target_id = user_row.id
              )
        $sql$;
    end if;
end
$$;

delete from system.sys_user_role_scope scope
using tmp_user_role ur
where scope.id = ur.scope_id::uuid
  and not exists (
      select 1 from tmp_preserved_system_user preserved_user
      where preserved_user.target_id = scope.user_id
  );
delete from system.sys_map_role_permission rp
using tmp_role r
where rp.role_id = r.id::uuid;
delete from system.sys_map_role_permission rp
using tmp_permission p
where rp.permission_id = p.id::uuid;
delete from system.sys_map_user_role ur
using tmp_user u
where ur.user_id = u.id::uuid
  and not exists (
      select 1 from tmp_preserved_system_user preserved_user
      where preserved_user.target_id = ur.user_id
  );
delete from system.sys_map_user_role ur
using tmp_role r
where ur.role_id = r.id::uuid
  and not exists (
      select 1 from tmp_preserved_system_user preserved_user
      where preserved_user.target_id = ur.user_id
  );
delete from system.sys_department d
using tmp_department source
where d.id = source.id::uuid
  and not exists (
      select 1 from system.sys_user_role_scope scope
      where scope.department_id = d.id
  );
delete from system.sys_hospital h
using tmp_hospital source
where h.id = source.id::uuid
  and not exists (
      select 1 from system.sys_user_role_scope scope
      where scope.hospital_id = h.id
  )
  and not exists (
      select 1 from system.sys_department department
      where department.hospital_id = h.id
  );
delete from system.sys_permission p
using tmp_permission source
where p.id = source.id::uuid
   or (p.code = source.code and p.code like 'Power-MCR-%');
delete from system.sys_role r
using tmp_role source
where r.id = source.id::uuid
  and r.type = 'MCR'
  and not exists (
      select 1 from system.sys_map_user_role user_role
      where user_role.role_id = r.id
  )
  and not exists (
      select 1 from system.sys_user_role_scope scope
      where scope.role_id = r.id
  );
delete from system.sys_user u
using tmp_user source
where u.id = source.id::uuid
  and u.source_type = 'mcr'
  and not exists (
      select 1 from tmp_preserved_system_user preserved_user
      where preserved_user.target_id = u.id
  );

drop schema if exists mcr cascade;
\i __SCHEMA_SQL__

create or replace function pg_temp.tmp_stable_uuid(value text)
returns uuid
language sql
immutable
as $func$
select (
    substr(md5(value), 1, 8) || '-' ||
    substr(md5(value), 9, 4) || '-' ||
    substr(md5(value), 13, 4) || '-' ||
    substr(md5(value), 17, 4) || '-' ||
    substr(md5(value), 21, 12)
)::uuid;
$func$;

create or replace function pg_temp.tmp_hospital_match_key(value text)
returns text
language sql
immutable
as $func$
select regexp_replace(
    regexp_replace(
        regexp_replace(coalesce(nullif(btrim(value), ''), ''), '[[:space:]　]+', '', 'g'),
        '^(首都医科大学附属|首都医科大学|中国医学科学院|北京市|北京|天津市|天津)',
        '',
        'g'
    ),
    '(总医院|医院)$',
    '',
    'g'
);
$func$;

create temp table tmp_hospital_alias (source_name text primary key, target_name text not null);
insert into tmp_hospital_alias (source_name, target_name) values
('首都医科大学附属北京安贞医院', '北京安贞医院'),
('首都医科大学宣武医院', '宣武医院'),
('北京大学人民医院', '北京大学人民医院'),
('首都医科大学附属北京友谊医院', '北京友谊医院'),
('首都医科大学附属北京世纪坛医院（北京铁路总医院）', '北京世纪坛医院'),
('首都医科大学附属北京儿童医院', '首都医科大学附属北京儿童医院'),
('首都医科大学附属北京潞河医院', '北京潞河医院'),
('中国医学科学院北京协和医院', '北京协和医院'),
('首都医科大学附属北京朝阳医院', '北京朝阳医院'),
('首都医科大学附属北京地坛医院', '北京地坛医院'),
('北京清华长庚医院', '北京清华长庚医院'),
('天津市胸科医院', '天津胸科医院'),
('首都儿科研究所附属儿童医院', '北京儿研所'),
('首都医科大学附属复兴医院', '北京复兴医院');

create temp table tmp_hospital_resolved as
select h.*,
       coalesce(alias_hospital.id, existing_hospital.id, h.id::uuid) as target_id
from tmp_hospital h
left join tmp_hospital_alias alias on alias.source_name = coalesce(nullif(btrim(h.name), ''), '未命名医院')
left join system.sys_hospital alias_hospital on alias_hospital.name = alias.target_name
left join lateral (
    select sys_hospital.id
    from system.sys_hospital
    where alias_hospital.id is null
      and (
          sys_hospital.name = coalesce(nullif(h.name, ''), '未命名医院')
          or (
              pg_temp.tmp_hospital_match_key(sys_hospital.name) = pg_temp.tmp_hospital_match_key(h.name)
              and pg_temp.tmp_hospital_match_key(h.name) <> ''
          )
      )
    order by
        case when sys_hospital.name = coalesce(nullif(h.name, ''), '未命名医院') then 0 else 1 end,
        sys_hospital.id::text
    limit 1
) existing_hospital on true;

insert into system.sys_hospital (id, name)
select target_id, coalesce(nullif(name, ''), '未命名医院')
from tmp_hospital_resolved
where target_id = id::uuid
on conflict (id) do update set name = excluded.name;

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select pg_temp.tmp_stable_uuid('MCR_Hospital:' || old_id), 'MCR_Hospital', old_id, 'system.sys_hospital', target_id, now()
from tmp_hospital_resolved
where nullif(old_id, '') is not null
on conflict (source_table, source_id) do update set target_table = excluded.target_table, target_id = excluded.target_id;

create temp table tmp_department_resolved as
select d.*,
       hr.target_id as hospital_target_id,
       coalesce(existing_department.id, d.id::uuid) as target_id
from tmp_department d
join tmp_hospital_resolved hr on hr.old_id = d.old_hospital_id
left join lateral (
    select department.id
    from system.sys_department department
    where department.hospital_id = hr.target_id
      and btrim(department.name) = btrim(coalesce(nullif(d.name, ''), '未命名科室'))
    order by department.id::text
    limit 1
) existing_department on true;

insert into system.sys_department (id, hospital_id, name, display_name)
select target_id, hospital_target_id, coalesce(nullif(name, ''), '未命名科室'), nullif(display_name, '')
from tmp_department_resolved
where target_id = id::uuid
on conflict (id) do update set hospital_id = excluded.hospital_id, name = excluded.name, display_name = excluded.display_name;

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select pg_temp.tmp_stable_uuid('MCR_Department:' || old_id), 'MCR_Department', old_id, 'system.sys_department', target_id, now()
from tmp_department_resolved
where nullif(old_id, '') is not null
on conflict (source_table, source_id) do update set target_table = excluded.target_table, target_id = excluded.target_id;

create temp table tmp_user_resolved as
select u.*, coalesce(existing_user.id, u.id::uuid) as target_id
from tmp_user u
left join lateral (
    select su.id
    from system.sys_user su
    where lower(su.account) = lower(u.account)
    order by case when su.source_type = 'mcr' then 0 else 1 end, su.id::text
    limit 1
) existing_user on true;

insert into system.sys_user (id, account, password, display_name, email, can_grant_to_other, is_valid, must_change_password, source_type)
select target_id, account, password_hash, coalesce(nullif(display_name, ''), account), nullif(email, ''),
       false, coalesce(nullif(is_valid, '')::boolean, false), coalesce(nullif(must_change_password, '')::boolean, true), 'mcr'
from tmp_user_resolved u
where not exists (select 1 from system.sys_user su where su.id = u.target_id)
  and not exists (select 1 from system.sys_user su where lower(su.account) = lower(u.account))
on conflict (id) do nothing;

update system.sys_user su
set display_name = coalesce(nullif(u.display_name, ''), u.account),
    email = nullif(u.email, ''),
    is_valid = coalesce(nullif(u.is_valid, '')::boolean, false),
    must_change_password = true,
    source_type = 'mcr'
from tmp_user_resolved u
where su.id = u.target_id and su.source_type = 'mcr'
  and not exists (
      select 1 from tmp_existing_user existing_user
      where existing_user.target_id = su.id
  );

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select pg_temp.tmp_stable_uuid('MCR_User:' || old_id), 'MCR_User', old_id, 'system.sys_user', target_id, now()
from tmp_user_resolved
where nullif(old_id, '') is not null
on conflict (source_table, source_id) do update set target_table = excluded.target_table, target_id = excluded.target_id;

insert into system.sys_role (id, name, describe, type, is_valid, owner_user_id)
select id::uuid, coalesce(nullif(name, ''), '未命名角色'), coalesce(nullif(describe, ''), ''), 'MCR', coalesce(nullif(is_valid, '')::boolean, true), null
from tmp_role
on conflict (id) do update set name = excluded.name, describe = excluded.describe, type = excluded.type, is_valid = excluded.is_valid;

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select pg_temp.tmp_stable_uuid('MCR_Role:' || old_id), 'MCR_Role', old_id, 'system.sys_role', id::uuid, now()
from tmp_role
where nullif(old_id, '') is not null
on conflict (source_table, source_id) do update set target_table = excluded.target_table, target_id = excluded.target_id;

create temp table tmp_permission_resolved as
select p.*, coalesce(existing_permission.id, p.id::uuid) as target_id
from tmp_permission p
left join lateral (
    select sp.id
    from system.sys_permission sp
    where sp.code = p.code
    order by case when sp.type = 'MCR' then 0 else 1 end, sp.id::text
    limit 1
) existing_permission on true;

insert into system.sys_permission (id, code, name, describe, type)
select target_id, nullif(code, ''), coalesce(nullif(name, ''), code), nullif(describe, ''), 'MCR'
from tmp_permission_resolved
where not exists (select 1 from system.sys_permission sp where sp.id = target_id)
on conflict (id) do update set code = excluded.code, name = excluded.name, describe = excluded.describe, type = excluded.type;

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select pg_temp.tmp_stable_uuid('MCR_FunctionPower:' || old_id), 'MCR_FunctionPower', old_id, 'system.sys_permission', target_id, now()
from tmp_permission_resolved
where nullif(old_id, '') is not null
on conflict (source_table, source_id) do update set target_table = excluded.target_table, target_id = excluded.target_id;

insert into system.sys_map_role_permission (role_id, permission_id)
select distinct rm.target_id, pm.target_id
from tmp_role_permission rp
join mcr.migration_map rm on rm.source_table = 'MCR_Role' and rm.source_id = rp.role_old_id
join mcr.migration_map pm on pm.source_table = 'MCR_FunctionPower' and pm.source_id = rp.permission_old_id
on conflict (role_id, permission_id) do nothing;

insert into system.sys_map_user_role (user_id, role_id)
select distinct um.target_id, rm.target_id
from tmp_user_role ur
join mcr.migration_map um on um.source_table = 'MCR_User' and um.source_id = ur.user_old_id
join mcr.migration_map rm on rm.source_table = 'MCR_Role' and rm.source_id = ur.role_old_id
where not exists (
    select 1 from tmp_existing_user existing_user
    where existing_user.target_id = um.target_id
)
on conflict (user_id, role_id) do nothing;

insert into system.sys_user_role_scope (id, user_id, role_id, hospital_id, hospital_name, department_id, department_name, created_at)
select distinct ur.scope_id::uuid, um.target_id, rm.target_id, hm.target_id, h.name, dm.target_id, d.name, now()
from tmp_user_role ur
join mcr.migration_map um on um.source_table = 'MCR_User' and um.source_id = ur.user_old_id
join mcr.migration_map rm on rm.source_table = 'MCR_Role' and rm.source_id = ur.role_old_id
join mcr.migration_map hm on hm.source_table = 'MCR_Hospital' and hm.source_id = ur.old_hospital_id
join system.sys_hospital h on h.id = hm.target_id
left join mcr.migration_map dm on dm.source_table = 'MCR_Department' and dm.source_id = nullif(ur.old_department_id, '')
left join system.sys_department d on d.id = dm.target_id
where nullif(ur.old_hospital_id, '') is not null
  and not exists (
      select 1 from tmp_existing_user existing_user
      where existing_user.target_id = um.target_id
  )
on conflict (id) do update set user_id = excluded.user_id, role_id = excluded.role_id, hospital_id = excluded.hospital_id,
    hospital_name = excluded.hospital_name, department_id = excluded.department_id, department_name = excluded.department_name;

create temp table tmp_case_record (
    id text, old_case_id text, patient_name text, patient_sex text, patient_sex_text text,
    patient_age text, id_number text, patient_number text, disease_id text, disease_name text,
    hospital_id text, hospital_name text, department_id text, department_name text,
    operator_id text, operator_name text, admission_time text, discharge_time text,
    operation_time text, hospital_stay_days text, surgery_type_value text, surgery_type_text text,
    coronary_intervention text, ablation_intervention text, structural_intervention text,
    is_emergency_intervention text, discharge_mode text, situation_reason text,
    situation_supplement text, death_time text, case_summary text, discharge_diagnosis text,
    other_exam text, angiography_result text, intervention_process text, rescue_process text,
    complication_discussion text, occurrence_reason text, death_reason text, lessons_learned text,
    improvement_measures text, status text, sub_status text, sort text, created_at text,
    created_by text, updated_at text, updated_by text
);
\copy tmp_case_record from __CASE_CSV__ with (format csv, header true);

insert into mcr.case_record (
    id, old_case_id, patient_name, patient_sex, patient_sex_text, patient_age, id_number,
    patient_number, disease_id, disease_name, hospital_id, hospital_name, department_id,
    department_name, operator_id, operator_name, admission_time, discharge_time, operation_time,
    hospital_stay_days, surgery_type_value, surgery_type_text, coronary_intervention,
    ablation_intervention, structural_intervention, is_emergency_intervention, discharge_mode,
    situation_reason, situation_supplement, death_time, case_summary, discharge_diagnosis,
    other_exam, angiography_result, intervention_process, rescue_process, complication_discussion,
    occurrence_reason, death_reason, lessons_learned, improvement_measures, status, sub_status,
    sort, created_at, created_by, updated_at, updated_by
)
select id::uuid, old_case_id, coalesce(nullif(patient_name, ''), '未命名'), nullif(patient_sex, ''),
       nullif(patient_sex_text, ''), nullif(patient_age, ''), nullif(id_number, ''), nullif(patient_number, ''),
       nullif(disease_id, ''), nullif(disease_name, ''), nullif(hospital_id, ''), nullif(hospital_name, ''),
       nullif(department_id, ''), nullif(department_name, ''), nullif(operator_id, ''), nullif(operator_name, ''),
       nullif(admission_time, '')::timestamp, nullif(discharge_time, '')::timestamp, nullif(operation_time, '')::timestamp,
       nullif(hospital_stay_days, '')::integer, nullif(surgery_type_value, ''), nullif(surgery_type_text, ''),
       nullif(coronary_intervention, ''), nullif(ablation_intervention, ''), nullif(structural_intervention, ''),
       nullif(is_emergency_intervention, ''), nullif(discharge_mode, ''), nullif(situation_reason, ''),
       nullif(situation_supplement, ''), nullif(death_time, '')::timestamp, nullif(case_summary, ''),
       nullif(discharge_diagnosis, ''), nullif(other_exam, ''), nullif(angiography_result, ''),
       nullif(intervention_process, ''), nullif(rescue_process, ''), nullif(complication_discussion, ''),
       nullif(occurrence_reason, ''), nullif(death_reason, ''), nullif(lessons_learned, ''),
       nullif(improvement_measures, ''), coalesce(nullif(status, '')::integer, 0),
       coalesce(nullif(sub_status, '')::integer, 0), coalesce(nullif(sort, '')::integer, 0),
       coalesce(nullif(created_at, '')::timestamp, now()), nullif(created_by, ''),
       nullif(updated_at, '')::timestamp, nullif(updated_by, '')
from tmp_case_record;

create temp table tmp_quality_report (
    id text, old_quality_id text, name text, quality_date text, template_id text,
    template_name text, hospital_id text, hospital_name text, status text,
    quality_user_id text, quality_user_name text, submitted_at text, created_at text,
    created_by text, updated_at text, updated_by text
);
\copy tmp_quality_report from __QUALITY_CSV__ with (format csv, header true);
create temp table tmp_quality_report_item (
    id text, quality_report_id text, metric_code text, metric_name text,
    category_name text, case_count text, sort text, created_at text,
    created_by text, updated_at text, updated_by text
);
\copy tmp_quality_report_item from __QUALITY_ITEM_CSV__ with (format csv, header true);
create temp table tmp_quality_reject (id text, quality_report_id text, content text, created_at text, created_by text);
\copy tmp_quality_reject from __QUALITY_REJECT_CSV__ with (format csv, header true);

insert into mcr.quality_report (
    id, old_quality_id, name, quality_date, template_id, template_name, hospital_id,
    hospital_name, status, quality_user_id, quality_user_name, submitted_at,
    created_at, created_by, updated_at, updated_by
)
select id::uuid, old_quality_id, coalesce(nullif(name, ''), '数据报表'), coalesce(nullif(quality_date, '')::timestamp, now()),
       nullif(template_id, ''), nullif(template_name, ''), nullif(hospital_id, ''), nullif(hospital_name, ''),
       coalesce(nullif(status, '')::integer, 0), nullif(quality_user_id, ''), nullif(quality_user_name, ''),
       nullif(submitted_at, '')::timestamp, coalesce(nullif(created_at, '')::timestamp, now()), nullif(created_by, ''),
       nullif(updated_at, '')::timestamp, nullif(updated_by, '')
from tmp_quality_report;

insert into mcr.quality_report_item (
    id, quality_report_id, metric_code, metric_name, category_name, case_count,
    sort, created_at, created_by, updated_at, updated_by
)
select id::uuid, quality_report_id::uuid, metric_code, metric_name, nullif(category_name, ''),
       nullif(case_count, '')::integer, coalesce(nullif(sort, '')::integer, 0),
       coalesce(nullif(created_at, '')::timestamp, now()), nullif(created_by, ''),
       nullif(updated_at, '')::timestamp, nullif(updated_by, '')
from tmp_quality_report_item;

insert into mcr.quality_reject (id, quality_report_id, content, created_at, created_by)
select id::uuid, quality_report_id::uuid, coalesce(nullif(content, ''), ''),
       coalesce(nullif(created_at, '')::timestamp, now()), nullif(created_by, '')
from tmp_quality_reject;

create temp table tmp_review_meeting (
    id text, old_meeting_id text, title text, description text, group_info text,
    place text, meeting_time text, end_time text, status text, created_at text,
    created_by text, updated_at text, updated_by text
);
\copy tmp_review_meeting from __MEETING_CSV__ with (format csv, header true);
create temp table tmp_meeting_expert (id text, meeting_id text, expert_id text, level text);
\copy tmp_meeting_expert from __MEETING_EXPERT_CSV__ with (format csv, header true);
create temp table tmp_case_appraise (
    id text, meeting_id text, case_id text, expert_id text, status text,
    indication text, operation text, device_complete text, surgery_level_implemented text,
    has_management_problem text, management_problem_description text, rescue_timely text,
    rescue_measure_proper text, rescue_device_complete text, death_reason text,
    other_death_reason text, need_improvement text, improvement_content text,
    created_at text, updated_at text, updated_by text
);
\copy tmp_case_appraise from __APPRAISE_CSV__ with (format csv, header true);
create temp table tmp_case_summary (
    id text, meeting_id text, case_id text, content text, status text,
    expert_name text, created_at text, created_by text, updated_at text, updated_by text
);
\copy tmp_case_summary from __SUMMARY_CSV__ with (format csv, header true);
create temp table tmp_case_vote (
    id text, meeting_id text, case_id text, summary_id text, agreed text,
    content text, expert_name text, created_at text, created_by text, updated_at text, updated_by text
);
\copy tmp_case_vote from __VOTE_CSV__ with (format csv, header true);

insert into mcr.review_meeting (
    id, old_meeting_id, title, description, group_info, place, meeting_time,
    end_time, status, created_at, created_by, updated_at, updated_by
)
select id::uuid, old_meeting_id, coalesce(nullif(title, ''), '未命名会议'), nullif(description, ''),
       nullif(group_info, ''), nullif(place, ''), coalesce(nullif(meeting_time, '')::timestamp, now()),
       nullif(end_time, '')::timestamp, coalesce(nullif(status, '')::integer, 0),
       coalesce(nullif(created_at, '')::timestamp, now()), nullif(created_by, ''),
       nullif(updated_at, '')::timestamp, nullif(updated_by, '')
from tmp_review_meeting;

insert into mcr.meeting_expert (id, meeting_id, expert_id, level)
select id::uuid, meeting_id::uuid, expert_id, coalesce(nullif(level, '')::integer, 0)
from tmp_meeting_expert;

insert into mcr.case_appraise (
    id, meeting_id, case_id, expert_id, status, indication, operation, device_complete,
    surgery_level_implemented, has_management_problem, management_problem_description,
    rescue_timely, rescue_measure_proper, rescue_device_complete, death_reason,
    other_death_reason, need_improvement, improvement_content, created_at, updated_at, updated_by
)
select id::uuid, meeting_id::uuid, case_id::uuid, expert_id, coalesce(nullif(status, '')::integer, 0),
       nullif(indication, ''), nullif(operation, ''), nullif(device_complete, ''), nullif(surgery_level_implemented, ''),
       nullif(has_management_problem, ''), nullif(management_problem_description, ''), nullif(rescue_timely, ''),
       nullif(rescue_measure_proper, ''), nullif(rescue_device_complete, ''), nullif(death_reason, ''),
       nullif(other_death_reason, ''), nullif(need_improvement, ''), nullif(improvement_content, ''),
       coalesce(nullif(created_at, '')::timestamp, now()), nullif(updated_at, '')::timestamp, nullif(updated_by, '')
from tmp_case_appraise;

insert into mcr.case_summary (id, meeting_id, case_id, content, status, expert_name, created_at, created_by, updated_at, updated_by)
select id::uuid, meeting_id::uuid, case_id::uuid, coalesce(nullif(content, ''), ''),
       coalesce(nullif(status, '')::integer, 0), nullif(expert_name, ''),
       coalesce(nullif(created_at, '')::timestamp, now()), nullif(created_by, ''),
       nullif(updated_at, '')::timestamp, nullif(updated_by, '')
from tmp_case_summary;

insert into mcr.case_vote (id, meeting_id, case_id, summary_id, agreed, content, expert_name, created_at, created_by, updated_at, updated_by)
select id::uuid, meeting_id::uuid, case_id::uuid, summary_id::uuid, coalesce(nullif(agreed, '')::boolean, false),
       nullif(content, ''), nullif(expert_name, ''), coalesce(nullif(created_at, '')::timestamp, now()),
       nullif(created_by, ''), nullif(updated_at, '')::timestamp, nullif(updated_by, '')
from tmp_case_vote;

create temp table tmp_registry_file (
    id text, owner_type text, owner_id text, file_name text, file_path text,
    content_type text, file_size text, remark text, created_at text, created_by text
);
\copy tmp_registry_file from __FILE_CSV__ with (format csv, header true);

insert into mcr.registry_file (id, owner_type, owner_id, file_name, file_path, content_type, file_size, remark, created_at, created_by)
select id::uuid, owner_type, owner_id::uuid, coalesce(nullif(file_name, ''), file_path), file_path,
       nullif(content_type, ''), nullif(file_size, '')::bigint, nullif(remark, ''),
       coalesce(nullif(created_at, '')::timestamp, now()), nullif(created_by, '')
from tmp_registry_file;

create temp table tmp_article (
    id text, old_article_id text, topic_id text, type text, status text, title text,
    content text, cover text, created_at text, created_by text, updated_at text, updated_by text
);
\copy tmp_article from __ARTICLE_CSV__ with (format csv, header true);

insert into mcr.article (id, old_article_id, topic_id, type, status, title, content, cover, created_at, created_by, updated_at, updated_by)
select id::uuid, nullif(old_article_id, ''), nullif(topic_id, ''), coalesce(nullif(type, '')::integer, 1),
       coalesce(nullif(status, '')::integer, 0), coalesce(title, ''), coalesce(content, ''), nullif(cover, ''),
       coalesce(nullif(created_at, '')::timestamp, now()), nullif(created_by, ''),
       nullif(updated_at, '')::timestamp, nullif(updated_by, '')
from tmp_article;

create temp table tmp_migration_map (
    id text, source_table text, source_id text, target_table text, target_id text, created_at text
);
\copy tmp_migration_map from __MAP_CSV__ with (format csv, header true);

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select id::uuid, source_table, source_id, target_table, target_id::uuid, coalesce(nullif(created_at, '')::timestamp, now())
from tmp_migration_map
on conflict (source_table, source_id) do update set target_table = excluded.target_table, target_id = excluded.target_id;

update mcr.quality_report q set quality_user_id = um.target_id::text
from tmp_quality_user_map qum
join mcr.migration_map um on um.source_table = 'MCR_User' and lower(um.source_id) = lower(qum.user_old_id)
where lower(q.old_quality_id) = lower(qum.old_quality_id);

update mcr.case_record c set hospital_id = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_Hospital' and lower(c.hospital_id) = lower(m.source_id);
update mcr.case_record c set department_id = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_Department' and lower(c.department_id) = lower(m.source_id);
update mcr.case_record c set operator_id = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(c.operator_id) = lower(m.source_id);
update mcr.case_record c set created_by = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(c.created_by) = lower(m.source_id);
update mcr.case_record c set updated_by = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(c.updated_by) = lower(m.source_id);
update mcr.quality_report q set hospital_id = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_Hospital' and lower(q.hospital_id) = lower(m.source_id);
update mcr.quality_report q set quality_user_id = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(q.quality_user_id) = lower(m.source_id);
update mcr.quality_report q set created_by = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(q.created_by) = lower(m.source_id);
update mcr.review_meeting r set created_by = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(r.created_by) = lower(m.source_id);
update mcr.meeting_expert e set expert_id = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(e.expert_id) = lower(m.source_id);
update mcr.case_appraise a set expert_id = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(a.expert_id) = lower(m.source_id);
update mcr.case_summary s set created_by = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(s.created_by) = lower(m.source_id);
update mcr.case_vote v set created_by = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(v.created_by) = lower(m.source_id);
update mcr.registry_file f set created_by = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(f.created_by) = lower(m.source_id);
update mcr.article a set created_by = m.target_id::text from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(a.created_by) = lower(m.source_id);

commit;
'@

    $replacements = @{
        "__SCHEMA_SQL__" = ConvertTo-SqlText (ConvertTo-ImportPath $SchemaPath)
        "__HOSPITAL_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Hospital)
        "__DEPARTMENT_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Department)
        "__USER_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.User)
        "__ROLE_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Role)
        "__PERMISSION_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Permission)
        "__ROLE_PERMISSION_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.RolePermission)
        "__USER_ROLE_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.UserRole)
        "__QUALITY_USER_MAP_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.QualityUserMap)
        "__CASE_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Case)
        "__QUALITY_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Quality)
        "__QUALITY_ITEM_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.QualityItem)
        "__QUALITY_REJECT_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.QualityReject)
        "__MEETING_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Meeting)
        "__MEETING_EXPERT_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.MeetingExpert)
        "__APPRAISE_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Appraise)
        "__SUMMARY_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Summary)
        "__VOTE_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Vote)
        "__FILE_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.File)
        "__ARTICLE_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Article)
        "__MAP_CSV__" = ConvertTo-SqlText (ConvertTo-ImportPath $Files.Map)
    }

    foreach ($key in $replacements.Keys) {
        $sql = $sql.Replace($key, $replacements[$key])
    }

    Write-Utf8BomFile -Path $Path -Content $sql
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

$identityDirectory = Join-Path $OutputDirectory "01_identity"
$caseDirectory = Join-Path $OutputDirectory "02_cases"
$qualityDirectory = Join-Path $OutputDirectory "03_quality"
$meetingDirectory = Join-Path $OutputDirectory "04_meetings"
$fileDirectory = Join-Path $OutputDirectory "05_files"
$articleDirectory = Join-Path $OutputDirectory "06_articles"
foreach ($directory in @($identityDirectory, $caseDirectory, $qualityDirectory, $meetingDirectory, $fileDirectory, $articleDirectory)) {
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
}

if (([string]::IsNullOrWhiteSpace($TargetUploadRoot) -or [string]::IsNullOrWhiteSpace($TargetDicomRoot)) -and (Test-Path $TargetConfigPath)) {
    $targetConfigFile = (Resolve-Path $TargetConfigPath).Path
    $targetConfigRoot = Split-Path -Parent $targetConfigFile
    $targetConfig = Get-Content $targetConfigFile -Raw | ConvertFrom-Json
    if ([string]::IsNullOrWhiteSpace($TargetUploadRoot) -and $targetConfig.FileStorage.UploadRoot) {
        $TargetUploadRoot = if ([System.IO.Path]::IsPathRooted([string]$targetConfig.FileStorage.UploadRoot)) { [string]$targetConfig.FileStorage.UploadRoot } else { Join-Path $targetConfigRoot ([string]$targetConfig.FileStorage.UploadRoot) }
    }
    if ([string]::IsNullOrWhiteSpace($TargetDicomRoot) -and $targetConfig.FileStorage.DicomRoot) {
        $TargetDicomRoot = if ([System.IO.Path]::IsPathRooted([string]$targetConfig.FileStorage.DicomRoot)) { [string]$targetConfig.FileStorage.DicomRoot } else { Join-Path $targetConfigRoot ([string]$targetConfig.FileStorage.DicomRoot) }
    }
}

$connectionType = Get-MigrationSqlConnectionType
$connection = New-Object $connectionType $SourceConnection

$hospitalRows = [System.Collections.Generic.List[object]]::new()
$departmentRows = [System.Collections.Generic.List[object]]::new()
$userRows = [System.Collections.Generic.List[object]]::new()
$roleRows = [System.Collections.Generic.List[object]]::new()
$permissionRows = [System.Collections.Generic.List[object]]::new()
$rolePermissionRows = [System.Collections.Generic.List[object]]::new()
$userRoleRows = [System.Collections.Generic.List[object]]::new()
$qualityUserMapRows = [System.Collections.Generic.List[object]]::new()
$caseRowsByOldId = @{}
$qualityRowsByOldId = @{}
$qualityMetricValuesByOldId = @{}
$qualityItemRows = [System.Collections.Generic.List[object]]::new()
$qualityRejectRows = [System.Collections.Generic.List[object]]::new()
$meetingRows = [System.Collections.Generic.List[object]]::new()
$meetingExpertRows = [System.Collections.Generic.List[object]]::new()
$appraiseRowsByOldId = @{}
$summaryRows = [System.Collections.Generic.List[object]]::new()
$voteRows = [System.Collections.Generic.List[object]]::new()
$fileRows = [System.Collections.Generic.List[object]]::new()
$fileManifestRows = [System.Collections.Generic.List[object]]::new()
$articleRows = [System.Collections.Generic.List[object]]::new()
$mapRows = [System.Collections.Generic.List[object]]::new()
$unmappedRows = [System.Collections.Generic.List[object]]::new()

$caseFieldLookup = New-FixedFieldLookup "case"
$qualityFieldLookup = New-FixedFieldLookup "quality"
$appraiseFieldLookup = New-FixedFieldLookup "appraise"
$qualityMetrics = @(
    [pscustomobject]@{ code = "total"; name = "总例数"; category = "总体"; sort = 10 },
    [pscustomobject]@{ code = "death"; name = "死亡例数"; category = "总体"; sort = 20 },
    [pscustomobject]@{ code = "complication"; name = "并发症例数"; category = "总体"; sort = 30 },
    [pscustomobject]@{ code = "rescue"; name = "并发症救治例数"; category = "总体"; sort = 40 },
    [pscustomobject]@{ code = "discussion"; name = "组织并发症讨论例数"; category = "总体"; sort = 50 },
    [pscustomobject]@{ code = "improvement"; name = "制定改进措施例数"; category = "总体"; sort = 60 }
)

try {
    $connection.Open()

    $hospitals = Invoke-SourceQuery $connection "select cast(ID as nvarchar(100)) as ID, Name from Hospital"
    $hospitalIdSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($row in $hospitals.Rows) {
        $oldId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldId)) { continue }
        $null = $hospitalIdSet.Add($oldId)
        $hospitalRows.Add([pscustomobject]@{ id = Get-TargetGuid "MCR_Hospital" $oldId; old_id = $oldId; name = Get-DbValue $row "Name" })
    }

    $missingQualityHospitals = Invoke-SourceQuery $connection @"
select distinct cast(q.HospitalID as nvarchar(100)) as ID
from MCR_Quality q
left join Hospital h on h.ID = q.HospitalID
where q.HospitalID is not null and h.ID is null
"@
    foreach ($row in $missingQualityHospitals.Rows) {
        $oldId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldId) -or -not $hospitalIdSet.Add($oldId)) { continue }
        $hospitalRows.Add([pscustomobject]@{ id = Get-TargetGuid "MCR_Hospital" $oldId; old_id = $oldId; name = "旧库未知医院" })
    }

    $departments = Invoke-SourceQuery $connection "select cast(ID as nvarchar(100)) as ID, cast(HospitalID as nvarchar(100)) as HospitalID, Name from Department"
    foreach ($row in $departments.Rows) {
        $oldId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldId)) { continue }
        $name = Get-DbValue $row "Name"
        $departmentRows.Add([pscustomobject]@{ id = Get-TargetGuid "MCR_Department" $oldId; old_id = $oldId; old_hospital_id = Get-DbValue $row "HospitalID"; name = $name; display_name = $name })
    }

    $userHasEmail = (Get-DbValue (Invoke-SourceQuery $connection "select case when col_length('Users', 'Email') is null then 0 else 1 end as HasEmail").Rows[0] "HasEmail") -eq "1"
    $emailSelect = if ($userHasEmail) { "u.Email" } else { "cast(null as nvarchar(256)) as Email" }
    $users = Invoke-SourceQuery $connection @"
select cast(u.ID as nvarchar(100)) as ID, u.UserName, $emailSelect, u.UKName, u.Status,
       cast(u.HospitalID as nvarchar(100)) as HospitalID, d.Name as DoctorName,
       cast(d.DepartmentID as nvarchar(100)) as DepartmentID, d.Status as DoctorStatus
from Users u
left join DoctorInfo d on d.UserID = u.ID
"@
    foreach ($row in $users.Rows) {
        $oldId = Get-DbValue $row "ID"
        $account = (Get-DbValue $row "UserName").Trim()
        if ([string]::IsNullOrWhiteSpace($oldId) -or [string]::IsNullOrWhiteSpace($account)) { continue }
        if ([string]::Equals($account, "admin", [System.StringComparison]::OrdinalIgnoreCase)) { continue }
        $displayName = Get-DbValue $row "DoctorName"
        if ([string]::IsNullOrWhiteSpace($displayName)) { $displayName = Get-DbValue $row "UKName" }
        if ([string]::IsNullOrWhiteSpace($displayName)) { $displayName = $account }
        $isValid = (Get-DbValue $row "Status") -eq "1"
        $doctorStatus = Get-DbValue $row "DoctorStatus"
        if (-not [string]::IsNullOrWhiteSpace($doctorStatus)) { $isValid = $isValid -and ($doctorStatus -eq "1") }
        $userRows.Add([pscustomobject]@{
            id = Get-TargetGuid "MCR_User" $oldId
            old_id = $oldId
            account = $account
            password_hash = $TemporaryPasswordHash
            display_name = $displayName
            email = Get-DbValue $row "Email"
            is_valid = Get-BoolText $isValid
            must_change_password = "true"
            source_type = "mcr"
            old_hospital_id = Get-DbValue $row "HospitalID"
            old_department_id = Get-DbValue $row "DepartmentID"
        })
    }

    $roles = Invoke-SourceQuery $connection @"
select distinct cast(r.ID as nvarchar(100)) as ID, r.Name, r.Description, r.Describe, r.Status
from [Role] r
where exists (
    select 1 from RoleFunctionPowerMap rpm
    join FunctionPower fp on fp.ID = rpm.FunctionPowerID
    where rpm.RoleID = r.ID and fp.Code like 'Power-MCR-%'
)
or exists (select 1 from UserRoleMap urm where urm.RoleID = r.ID and urm.Status = 1)
"@
    $roleIdSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($row in $roles.Rows) {
        $oldId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldId)) { continue }
        $null = $roleIdSet.Add($oldId)
        $describe = Get-DbValue $row "Describe"
        if ([string]::IsNullOrWhiteSpace($describe)) { $describe = Get-DbValue $row "Description" }
        $roleRows.Add([pscustomobject]@{ id = Get-TargetGuid "MCR_Role" $oldId; old_id = $oldId; name = Get-DbValue $row "Name"; describe = $describe; type = "MCR"; is_valid = Get-BoolText ((Get-DbValue $row "Status") -ne "2") })
    }

    $permissions = Invoke-SourceQuery $connection "select cast(ID as nvarchar(100)) as ID, Name, Code from FunctionPower where Code like 'Power-MCR-%' order by Code"
    foreach ($row in $permissions.Rows) {
        $oldId = Get-DbValue $row "ID"
        $code = Get-DbValue $row "Code"
        if ([string]::IsNullOrWhiteSpace($oldId) -or [string]::IsNullOrWhiteSpace($code)) { continue }
        $permissionRows.Add([pscustomobject]@{ id = Get-TargetGuid "MCR_FunctionPower" $oldId; old_id = $oldId; name = $code; describe = Get-DbValue $row "Name"; type = "MCR"; code = $code })
    }

    $rolePermissions = Invoke-SourceQuery $connection @"
select distinct cast(rpm.RoleID as nvarchar(100)) as RoleID, cast(rpm.FunctionPowerID as nvarchar(100)) as FunctionPowerID
from RoleFunctionPowerMap rpm
join FunctionPower fp on fp.ID = rpm.FunctionPowerID
where fp.Code like 'Power-MCR-%'
"@
    foreach ($row in $rolePermissions.Rows) {
        $rolePermissionRows.Add([pscustomobject]@{ role_old_id = Get-DbValue $row "RoleID"; permission_old_id = Get-DbValue $row "FunctionPowerID" })
    }

    $userRoles = Invoke-SourceQuery $connection @"
select distinct cast(urm.UserID as nvarchar(100)) as UserID, cast(urm.RoleID as nvarchar(100)) as RoleID,
       cast(u.HospitalID as nvarchar(100)) as HospitalID, cast(d.DepartmentID as nvarchar(100)) as DepartmentID
from UserRoleMap urm
join Users u on u.ID = urm.UserID
left join DoctorInfo d on d.UserID = u.ID
where urm.Status = 1
  and lower(u.UserName) <> 'admin'
"@
    foreach ($row in $userRoles.Rows) {
        $roleOldId = Get-DbValue $row "RoleID"
        if (-not $roleIdSet.Contains($roleOldId)) { continue }
        $userOldId = Get-DbValue $row "UserID"
        $oldHospitalId = Get-DbValue $row "HospitalID"
        $oldDepartmentId = Get-DbValue $row "DepartmentID"
        $scopeId = ConvertTo-StableGuid ("MCR_UserRoleScope:{0}:{1}:{2}:{3}" -f $userOldId, $roleOldId, $oldHospitalId, $oldDepartmentId)
        $userRoleRows.Add([pscustomobject]@{ user_old_id = $userOldId; role_old_id = $roleOldId; old_hospital_id = $oldHospitalId; old_department_id = $oldDepartmentId; scope_id = $scopeId })
    }

    $qualityUserMaps = Invoke-SourceQuery $connection @"
with quality_source as (
    select ID, ltrim(rtrim(QualityUser)) as QualityUser, HospitalID
    from MCR_Quality
    where QualityUser is not null and ltrim(rtrim(QualityUser)) <> ''
),
same_hospital as (
    select q.ID, min(d.UserID) as UserID, count(distinct d.UserID) as MatchCount
    from quality_source q
    join DoctorInfo d on d.Name = q.QualityUser
    join Users u on u.ID = d.UserID and u.HospitalID = q.HospitalID
    group by q.ID
),
same_name as (
    select q.ID, min(d.UserID) as UserID, count(distinct d.UserID) as MatchCount
    from quality_source q
    join DoctorInfo d on d.Name = q.QualityUser
    group by q.ID
)
select cast(q.ID as nvarchar(100)) as QualityID,
       cast(case when sh.MatchCount = 1 then sh.UserID when isnull(sh.MatchCount, 0) = 0 and sn.MatchCount = 1 then sn.UserID else null end as nvarchar(100)) as UserID
from quality_source q
left join same_hospital sh on sh.ID = q.ID
left join same_name sn on sn.ID = q.ID
where sh.MatchCount = 1 or (isnull(sh.MatchCount, 0) = 0 and sn.MatchCount = 1)
"@
    foreach ($row in $qualityUserMaps.Rows) {
        $userOldId = Get-DbValue $row "UserID"
        if ([string]::IsNullOrWhiteSpace($userOldId)) { continue }
        $qualityUserMapRows.Add([pscustomobject]@{ old_quality_id = Get-DbValue $row "QualityID"; user_old_id = $userOldId })
    }

    $cases = Invoke-SourceQuery $connection @"
select ID, PTSex, PTName, PTAge, DiseaseID, Status, SubStatus, IDNumber, PatNum,
       Operator, GetInTime, GetOutTime, OperationTime, DepartmentID, HospitalID,
       CreateUserID, UpdateUserID, CreateTime, UpdateTime, Sort
from MCR_Case
order by CreateTime, ID
"@
    foreach ($row in $cases.Rows) {
        $oldCaseId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldCaseId)) { continue }
        $caseId = ConvertTo-StableGuid "case:$oldCaseId"
        $diseaseId = Get-DbValue $row "DiseaseID"
        $diseaseName = Get-DiseaseName $diseaseId
        $patientSex = ConvertTo-SexValue (Get-DbValue $row "PTSex")
        $caseRowsByOldId[$oldCaseId] = [ordered]@{
            id = $caseId; old_case_id = $oldCaseId; patient_name = Get-DbValue $row "PTName"; patient_sex = $patientSex
            patient_sex_text = if ($patientSex -eq "1") { "男" } elseif ($patientSex -eq "2") { "女" } else { Get-DbValue $row "PTSex" }
            patient_age = Get-DbValue $row "PTAge"; id_number = Get-DbValue $row "IDNumber"; patient_number = Get-DbValue $row "PatNum"
            disease_id = $diseaseId; disease_name = $diseaseName; hospital_id = Get-DbValue $row "HospitalID"; hospital_name = ""
            department_id = Get-DbValue $row "DepartmentID"; department_name = ""; operator_id = Get-DbValue $row "Operator"; operator_name = ""
            admission_time = Get-DateValue $row "GetInTime"; discharge_time = Get-DateValue $row "GetOutTime"; operation_time = Get-DateValue $row "OperationTime"; hospital_stay_days = ""
            surgery_type_value = $diseaseId; surgery_type_text = $diseaseName; coronary_intervention = ""; ablation_intervention = ""; structural_intervention = ""; is_emergency_intervention = ""
            discharge_mode = ""; situation_reason = ""; situation_supplement = ""; death_time = ""; case_summary = ""; discharge_diagnosis = ""; other_exam = ""; angiography_result = ""
            intervention_process = ""; rescue_process = ""; complication_discussion = ""; occurrence_reason = ""; death_reason = ""; lessons_learned = ""; improvement_measures = ""
            status = Get-DbValue $row "Status"; sub_status = Get-DbValue $row "SubStatus"; sort = Get-DbValue $row "Sort"
            created_at = Get-DateValue $row "CreateTime"; created_by = Get-DbValue $row "CreateUserID"; updated_at = Get-DateValue $row "UpdateTime"; updated_by = Get-DbValue $row "UpdateUserID"
        }
        $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:MCR_Case:$oldCaseId"; source_table = "MCR_Case"; source_id = $oldCaseId; target_table = "mcr.case_record"; target_id = $caseId; created_at = $caseRowsByOldId[$oldCaseId].created_at })
    }

    $caseAnswers = Invoke-SourceQuery $connection @"
select a.ID, a.CardID, a.SubjectID, cast(a.Answer as nvarchar(max)) as Answer, cast(a.HisAnswer as nvarchar(max)) as HisAnswer,
       a.CustomFormID,
       coalesce(nullif(s.Rename, ''), nullif(sc.ReName, ''), nullif(sl.Name, ''), nullif(sc.TableColumnDef, ''), nullif(sl.Code, ''), nullif(sc.cubeColumn, ''), nullif(s.SubjectMark, ''), cast(s.ID as nvarchar(100))) as FieldName,
       coalesce(nullif(sc.TableColumnDef, ''), nullif(sl.Code, ''), nullif(sc.cubeColumn, ''), nullif(s.SubjectMark, ''), cast(s.ID as nvarchar(100))) as FieldCode
from CM_CAHD_Care_CustomFormAnswer a
inner join MCR_Case c on c.ID = a.CardID
left join CM_CAHD_Care_CustomFormSubject s on s.ID = a.SubjectID
left join CM_CAHD_Care_SubjectConfig sc on sc.ID = s.SubjectConfigID
left join CM_CAHD_Care_SubjectList sl on sl.ID = s.SubjectListID
where a.CustomFormID is not null
order by a.CardID, a.Sort, a.ID
"@
    foreach ($row in $caseAnswers.Rows) {
        $oldCaseId = Get-DbValue $row "CardID"
        if (-not $caseRowsByOldId.ContainsKey($oldCaseId)) { continue }
        $answerText = Get-AnswerText $row
        if ([string]::IsNullOrWhiteSpace($answerText)) { continue }
        $target = $null
        foreach ($candidate in @((Get-DbValue $row "FieldName"), (Get-DbValue $row "FieldCode"))) {
            $key = Get-NormalizedFieldKey $candidate
            if ($caseFieldLookup.ContainsKey($key)) { $target = $caseFieldLookup[$key]; break }
        }
        if ([string]::IsNullOrWhiteSpace($target)) {
            $unmappedRows.Add([pscustomobject]@{ owner_type = "case"; owner_id = $oldCaseId; answer_id = Get-DbValue $row "ID"; custom_form_id = Get-DbValue $row "CustomFormID"; subject_id = Get-DbValue $row "SubjectID"; field_name = Get-DbValue $row "FieldName"; field_code = Get-DbValue $row "FieldCode"; answer = $answerText })
            continue
        }
        Set-FixedAnswer -Row $caseRowsByOldId[$oldCaseId] -Target $target -Value $answerText
    }

    $qualities = Invoke-SourceQuery $connection "select ID, Name, QualityDate, TemplateID, CustomFormID, HospitalID, Status, QualityUser, CreateUserID, CreateTime, UpdateTime from MCR_Quality order by QualityDate, ID"
    foreach ($row in $qualities.Rows) {
        $oldQualityId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldQualityId)) { continue }
        $qualityId = ConvertTo-StableGuid "quality:$oldQualityId"
        $templateId = Get-DbValue $row "TemplateID"
        $qualityDate = Get-DateValue $row "QualityDate"
        $qualityUser = Get-DbValue $row "QualityUser"
        $qualityRowsByOldId[$oldQualityId] = [ordered]@{
            id = $qualityId; old_quality_id = $oldQualityId; name = Get-DbValue $row "Name"; quality_date = $qualityDate
            template_id = $templateId; template_name = Get-DiseaseName $templateId; hospital_id = Get-DbValue $row "HospitalID"; hospital_name = ""
            status = Get-DbValue $row "Status"; quality_user_id = $qualityUser; quality_user_name = $qualityUser
            submitted_at = if ((Get-DbValue $row "Status") -eq "1") { $qualityDate } else { "" }
            created_at = Get-DateValue $row "CreateTime"; created_by = Get-DbValue $row "CreateUserID"; updated_at = Get-DateValue $row "UpdateTime"; updated_by = ""
        }
        $qualityMetricValuesByOldId[$oldQualityId] = @{}
        $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:MCR_Quality:$oldQualityId"; source_table = "MCR_Quality"; source_id = $oldQualityId; target_table = "mcr.quality_report"; target_id = $qualityId; created_at = $qualityRowsByOldId[$oldQualityId].created_at })
    }

    $qualityRejects = Invoke-SourceQuery $connection "select ID, QualityID, Content, CreateUserID, CreateTime from MCR_QualityReject order by CreateTime, ID"
    foreach ($row in $qualityRejects.Rows) {
        $oldRejectId = Get-DbValue $row "ID"
        $oldQualityId = Get-DbValue $row "QualityID"
        if ([string]::IsNullOrWhiteSpace($oldRejectId) -or -not $qualityRowsByOldId.ContainsKey($oldQualityId)) { continue }
        $rejectId = ConvertTo-StableGuid "quality-reject:$oldRejectId"
        $createdAt = Get-DateValue $row "CreateTime"
        $qualityRejectRows.Add([pscustomobject]@{ id = $rejectId; quality_report_id = $qualityRowsByOldId[$oldQualityId].id; content = Get-DbValue $row "Content"; created_at = $createdAt; created_by = Get-DbValue $row "CreateUserID" })
        $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:MCR_QualityReject:$oldRejectId"; source_table = "MCR_QualityReject"; source_id = $oldRejectId; target_table = "mcr.quality_reject"; target_id = $rejectId; created_at = $createdAt })
    }

    $qualityAnswers = Invoke-SourceQuery $connection @"
select a.ID, a.CardID, a.SubjectID, cast(a.Answer as nvarchar(max)) as Answer, cast(a.HisAnswer as nvarchar(max)) as HisAnswer,
       a.CustomFormID,
       coalesce(nullif(s.Rename, ''), nullif(sc.ReName, ''), nullif(sl.Name, ''), nullif(sc.TableColumnDef, ''), nullif(sl.Code, ''), nullif(sc.cubeColumn, ''), nullif(s.SubjectMark, ''), cast(s.ID as nvarchar(100))) as FieldName,
       coalesce(nullif(sc.TableColumnDef, ''), nullif(sl.Code, ''), nullif(sc.cubeColumn, ''), nullif(s.SubjectMark, ''), cast(s.ID as nvarchar(100))) as FieldCode
from CM_CAHD_Care_CustomFormAnswer a
inner join MCR_Quality q on q.ID = a.CardID
left join CM_CAHD_Care_CustomFormSubject s on s.ID = a.SubjectID
left join CM_CAHD_Care_SubjectConfig sc on sc.ID = s.SubjectConfigID
left join CM_CAHD_Care_SubjectList sl on sl.ID = s.SubjectListID
where a.CustomFormID is not null
order by a.CardID, a.Sort, a.ID
"@
    foreach ($row in $qualityAnswers.Rows) {
        $oldQualityId = Get-DbValue $row "CardID"
        if (-not $qualityRowsByOldId.ContainsKey($oldQualityId)) { continue }
        $answerText = Get-AnswerText $row
        if ([string]::IsNullOrWhiteSpace($answerText)) { continue }
        $target = $null
        foreach ($candidate in @((Get-DbValue $row "FieldName"), (Get-DbValue $row "FieldCode"))) {
            $key = Get-NormalizedFieldKey $candidate
            if ($qualityFieldLookup.ContainsKey($key)) { $target = $qualityFieldLookup[$key]; break }
        }
        if ([string]::IsNullOrWhiteSpace($target)) {
            $fieldNameKey = Get-NormalizedFieldKey (Get-DbValue $row "FieldName")
            $fieldCodeKey = Get-NormalizedFieldKey (Get-DbValue $row "FieldCode")
            if ($fieldNameKey -eq "例数" -or $fieldCodeKey -eq "ls6") {
                $valueText = Get-IntegerText $answerText
                if (-not [string]::IsNullOrWhiteSpace($valueText)) {
                    $current = 0
                    if ($qualityMetricValuesByOldId[$oldQualityId].ContainsKey("total") -and -not [string]::IsNullOrWhiteSpace($qualityMetricValuesByOldId[$oldQualityId]["total"])) {
                        $current = [int]$qualityMetricValuesByOldId[$oldQualityId]["total"]
                    }

                    $qualityMetricValuesByOldId[$oldQualityId]["total"] = ($current + [int]$valueText).ToString()
                }

                continue
            }

            $unmappedRows.Add([pscustomobject]@{ owner_type = "quality"; owner_id = $oldQualityId; answer_id = Get-DbValue $row "ID"; custom_form_id = Get-DbValue $row "CustomFormID"; subject_id = Get-DbValue $row "SubjectID"; field_name = Get-DbValue $row "FieldName"; field_code = Get-DbValue $row "FieldCode"; answer = $answerText })
            continue
        }
        $qualityMetricValuesByOldId[$oldQualityId][$target] = Get-IntegerText $answerText
    }

    foreach ($oldQualityId in $qualityRowsByOldId.Keys) {
        $quality = $qualityRowsByOldId[$oldQualityId]
        foreach ($metric in $qualityMetrics) {
            $caseCount = if ($qualityMetricValuesByOldId[$oldQualityId].ContainsKey($metric.code)) { $qualityMetricValuesByOldId[$oldQualityId][$metric.code] } else { "" }
            $qualityItemRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "quality-item:${oldQualityId}:$($metric.code)"; quality_report_id = $quality.id; metric_code = $metric.code; metric_name = $metric.name; category_name = $metric.category; case_count = $caseCount; sort = $metric.sort; created_at = $quality.created_at; created_by = $quality.created_by; updated_at = $quality.updated_at; updated_by = $quality.updated_by })
        }
    }

    $meetings = Invoke-SourceQuery $connection "select ID, Title, Description, GroupInfo, Place, MeettingTime, EndTime, Status, CreateUserID, CreateTime from MCR_Meeting order by MeettingTime, ID"
    foreach ($row in $meetings.Rows) {
        $oldMeetingId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldMeetingId)) { continue }
        $meetingId = ConvertTo-StableGuid "meeting:$oldMeetingId"
        $createdAt = Get-DateValue $row "CreateTime"
        $meetingRows.Add([pscustomobject]@{ id = $meetingId; old_meeting_id = $oldMeetingId; title = Get-DbValue $row "Title"; description = Get-DbValue $row "Description"; group_info = Get-DbValue $row "GroupInfo"; place = Get-DbValue $row "Place"; meeting_time = Get-DateValue $row "MeettingTime"; end_time = Get-DateValue $row "EndTime"; status = Get-DbValue $row "Status"; created_at = $createdAt; created_by = Get-DbValue $row "CreateUserID"; updated_at = ""; updated_by = "" })
        $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:MCR_Meeting:$oldMeetingId"; source_table = "MCR_Meeting"; source_id = $oldMeetingId; target_table = "mcr.review_meeting"; target_id = $meetingId; created_at = $createdAt })
    }

    $experts = Invoke-SourceQuery $connection "select ID, MeetingID, ExpertID, Level from MCR_MeetingExpertMap order by MeetingID, Level, ID"
    foreach ($row in $experts.Rows) {
        $oldId = Get-DbValue $row "ID"
        $oldMeetingId = Get-DbValue $row "MeetingID"
        if ([string]::IsNullOrWhiteSpace($oldId) -or [string]::IsNullOrWhiteSpace($oldMeetingId)) { continue }
        $targetId = ConvertTo-StableGuid "meeting-expert:$oldId"
        $meetingExpertRows.Add([pscustomobject]@{ id = $targetId; meeting_id = ConvertTo-StableGuid "meeting:$oldMeetingId"; expert_id = Get-DbValue $row "ExpertID"; level = Get-DbValue $row "Level" })
        $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:MCR_MeetingExpertMap:$oldId"; source_table = "MCR_MeetingExpertMap"; source_id = $oldId; target_table = "mcr.meeting_expert"; target_id = $targetId; created_at = "" })
    }

    $appraises = Invoke-SourceQuery $connection "select ID, MeetingID, CaseID, ExpertID, Status, CreateTime, UpdateTime from MCR_Appraise order by MeetingID, CaseID, ExpertID, ID"
    foreach ($row in $appraises.Rows) {
        $oldAppraiseId = Get-DbValue $row "ID"
        $oldMeetingId = Get-DbValue $row "MeetingID"
        $oldCaseId = Get-DbValue $row "CaseID"
        if ([string]::IsNullOrWhiteSpace($oldAppraiseId) -or [string]::IsNullOrWhiteSpace($oldMeetingId) -or [string]::IsNullOrWhiteSpace($oldCaseId)) { continue }
        $appraiseId = ConvertTo-StableGuid "appraise:$oldAppraiseId"
        $createdAt = Get-DateValue $row "CreateTime"
        $appraiseRowsByOldId[$oldAppraiseId] = [ordered]@{
            id = $appraiseId; meeting_id = ConvertTo-StableGuid "meeting:$oldMeetingId"; case_id = ConvertTo-StableGuid "case:$oldCaseId"; expert_id = Get-DbValue $row "ExpertID"; status = Get-DbValue $row "Status"
            indication = ""; operation = ""; device_complete = ""; surgery_level_implemented = ""; has_management_problem = ""; management_problem_description = ""; rescue_timely = ""; rescue_measure_proper = ""; rescue_device_complete = ""; death_reason = ""; other_death_reason = ""; need_improvement = ""; improvement_content = ""
            created_at = $createdAt; updated_at = Get-DateValue $row "UpdateTime"; updated_by = ""
        }
        $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:MCR_Appraise:$oldAppraiseId"; source_table = "MCR_Appraise"; source_id = $oldAppraiseId; target_table = "mcr.case_appraise"; target_id = $appraiseId; created_at = $createdAt })
    }

    $summaries = Invoke-SourceQuery $connection "select ID, MeetingID, CaseID, Content, Status, ExpertName, CreateUserID, CreateTime from MCR_Summary order by MeetingID, CaseID, ID"
    foreach ($row in $summaries.Rows) {
        $oldSummaryId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldSummaryId)) { continue }
        $targetId = ConvertTo-StableGuid "summary:$oldSummaryId"
        $createdAt = Get-DateValue $row "CreateTime"
        $summaryRows.Add([pscustomobject]@{ id = $targetId; meeting_id = ConvertTo-StableGuid "meeting:$(Get-DbValue $row "MeetingID")"; case_id = ConvertTo-StableGuid "case:$(Get-DbValue $row "CaseID")"; content = Get-DbValue $row "Content"; status = Get-DbValue $row "Status"; expert_name = Get-DbValue $row "ExpertName"; created_at = $createdAt; created_by = Get-DbValue $row "CreateUserID"; updated_at = ""; updated_by = "" })
        $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:MCR_Summary:$oldSummaryId"; source_table = "MCR_Summary"; source_id = $oldSummaryId; target_table = "mcr.case_summary"; target_id = $targetId; created_at = $createdAt })
    }

    $votes = Invoke-SourceQuery $connection "select ID, MeetingID, CaseID, SummaryID, Content, Agreed, ExpertName, CreateUserID, CreateTime from MCR_Vote order by MeetingID, CaseID, ID"
    foreach ($row in $votes.Rows) {
        $oldVoteId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldVoteId)) { continue }
        $targetId = ConvertTo-StableGuid "vote:$oldVoteId"
        $createdAt = Get-DateValue $row "CreateTime"
        $voteRows.Add([pscustomobject]@{ id = $targetId; meeting_id = ConvertTo-StableGuid "meeting:$(Get-DbValue $row "MeetingID")"; case_id = ConvertTo-StableGuid "case:$(Get-DbValue $row "CaseID")"; summary_id = ConvertTo-StableGuid "summary:$(Get-DbValue $row "SummaryID")"; agreed = Get-DbValue $row "Agreed"; content = Get-DbValue $row "Content"; expert_name = Get-DbValue $row "ExpertName"; created_at = $createdAt; created_by = Get-DbValue $row "CreateUserID"; updated_at = ""; updated_by = "" })
        $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:MCR_Vote:$oldVoteId"; source_table = "MCR_Vote"; source_id = $oldVoteId; target_table = "mcr.case_vote"; target_id = $targetId; created_at = $createdAt })
    }

    $appraiseAnswers = Invoke-SourceQuery $connection @"
select a.ID, a.CardID, a.SubjectID, cast(a.Answer as nvarchar(max)) as Answer, cast(a.HisAnswer as nvarchar(max)) as HisAnswer,
       a.CustomFormID,
       coalesce(nullif(s.Rename, ''), nullif(sc.ReName, ''), nullif(sl.Name, ''), nullif(sc.TableColumnDef, ''), nullif(sl.Code, ''), nullif(sc.cubeColumn, ''), nullif(s.SubjectMark, ''), cast(s.ID as nvarchar(100))) as FieldName,
       coalesce(nullif(sc.TableColumnDef, ''), nullif(sl.Code, ''), nullif(sc.cubeColumn, ''), nullif(s.SubjectMark, ''), cast(s.ID as nvarchar(100))) as FieldCode
from CM_CAHD_Care_CustomFormAnswer a
inner join MCR_Appraise ap on ap.ID = a.CardID
left join CM_CAHD_Care_CustomFormSubject s on s.ID = a.SubjectID
left join CM_CAHD_Care_SubjectConfig sc on sc.ID = s.SubjectConfigID
left join CM_CAHD_Care_SubjectList sl on sl.ID = s.SubjectListID
where a.CustomFormID is not null
order by a.CardID, a.Sort, a.ID
"@
    foreach ($row in $appraiseAnswers.Rows) {
        $oldAppraiseId = Get-DbValue $row "CardID"
        if (-not $appraiseRowsByOldId.ContainsKey($oldAppraiseId)) { continue }
        $answerText = Get-AnswerText $row
        if ([string]::IsNullOrWhiteSpace($answerText)) { continue }
        $target = $null
        foreach ($candidate in @((Get-DbValue $row "FieldName"), (Get-DbValue $row "FieldCode"))) {
            $key = Get-NormalizedFieldKey $candidate
            if ($appraiseFieldLookup.ContainsKey($key)) { $target = $appraiseFieldLookup[$key]; break }
        }
        if ([string]::IsNullOrWhiteSpace($target)) {
            $unmappedRows.Add([pscustomobject]@{ owner_type = "appraise"; owner_id = $oldAppraiseId; answer_id = Get-DbValue $row "ID"; custom_form_id = Get-DbValue $row "CustomFormID"; subject_id = Get-DbValue $row "SubjectID"; field_name = Get-DbValue $row "FieldName"; field_code = Get-DbValue $row "FieldCode"; answer = $answerText })
            continue
        }
        Set-FixedAnswer -Row $appraiseRowsByOldId[$oldAppraiseId] -Target $target -Value $answerText
    }

    if (Test-SourceTable $connection "FileInfo") {
        $fileInfoRows = Invoke-SourceQuery $connection "select cast(ID as nvarchar(100)) as ID, VID, Path, Size, CreateTime from FileInfo order by CreateTime, ID"
        $fileInfoByKey = @{}
        foreach ($row in $fileInfoRows.Rows) {
            $oldFileId = Get-DbValue $row "ID"
            if ([string]::IsNullOrWhiteSpace($oldFileId)) { continue }
            $fileInfoByKey[$oldFileId.ToLowerInvariant()] = [pscustomobject]@{ Id = $oldFileId; Path = Get-DbValue $row "Path"; Size = Get-DbValue $row "Size"; CreateTime = Get-DateValue $row "CreateTime"; CreatedBy = Get-DbValue $row "VID" }
        }

        $referencedFileKeys = [System.Collections.Generic.HashSet[string]]::new()
        $answerRows = Invoke-SourceQuery $connection @"
select a.ID, a.CardID, cast(a.Answer as nvarchar(max)) as Answer, a.CreateUserID, a.CreateTime,
       coalesce(nullif(ltrim(rtrim(s.Rename)), ''), nullif(ltrim(rtrim(sc.ReName)), ''), nullif(ltrim(rtrim(sl.Name)), ''), nullif(ltrim(rtrim(sc.TableColumnDef)), ''), nullif(ltrim(rtrim(sl.Code)), ''), nullif(ltrim(rtrim(sc.cubeColumn)), ''), nullif(ltrim(rtrim(s.SubjectMark)), '')) as FieldName,
       coalesce(nullif(ltrim(rtrim(sl.Code)), ''), nullif(ltrim(rtrim(sc.TableColumnDef)), ''), nullif(ltrim(rtrim(sc.cubeColumn)), ''), nullif(ltrim(rtrim(s.SubjectMark)), '')) as FieldCode
from CM_CAHD_Care_CustomFormAnswer a
inner join CM_CAHD_Care_CustomFormSubject s on s.ID = a.SubjectID
inner join CM_CAHD_Care_SubjectConfig sc on sc.ID = s.SubjectConfigID
left join CM_CAHD_Care_SubjectList sl on sl.ID = s.SubjectListID
inner join MCR_Case c on c.ID = a.CardID
where sc.Type = 7 and a.Answer is not null and ltrim(rtrim(cast(a.Answer as nvarchar(max)))) <> ''
order by a.CreateTime, a.ID
"@
        foreach ($row in $answerRows.Rows) {
            $answerId = Get-DbValue $row "ID"
            $oldCaseId = Get-DbValue $row "CardID"
            $createdAt = Get-DateValue $row "CreateTime"
            $createdBy = Get-DbValue $row "CreateUserID"
            $ownerId = ConvertTo-StableGuid "case:$oldCaseId"
            $fileFieldKey = Get-CaseFileFieldKey -Row $row -Lookup $caseFieldLookup
            if ([string]::IsNullOrWhiteSpace($fileFieldKey)) {
                $unmappedRows.Add([pscustomobject]@{ owner_type = "case_file"; owner_id = $oldCaseId; answer_id = $answerId; custom_form_id = ""; subject_id = ""; field_name = Get-DbValue $row "FieldName"; field_code = Get-DbValue $row "FieldCode"; answer = Get-DbValue $row "Answer" })
                continue
            }
            $files = Get-AnswerFiles (Get-DbValue $row "Answer")
            $fileIndex = 0
            foreach ($file in $files) {
                $fileIndex++
                $fileInfo = $null
                if ($fileInfoByKey.ContainsKey($file.FileKey)) {
                    $fileInfo = $fileInfoByKey[$file.FileKey]
                    $null = $referencedFileKeys.Add($file.FileKey)
                }
                $size = $file.FileSize
                $fileCreatedAt = $createdAt
                if ($null -ne $fileInfo) {
                    if (-not [string]::IsNullOrWhiteSpace($fileInfo.Size)) { $size = $fileInfo.Size }
                    if (-not [string]::IsNullOrWhiteSpace($fileInfo.CreateTime)) { $fileCreatedAt = $fileInfo.CreateTime }
                }
                $targetId = ConvertTo-StableGuid "registry-file:case:${ownerId}:$($file.RelativePath):$fileIndex"
                $sourceId = "$answerId`:$($file.FileKey)`:$fileIndex"
                $targetRelativePath = Get-MigratedCaseFileRelativePath -OwnerId $ownerId -FieldKey $fileFieldKey -StoredName $file.StoredName
                $fileRows.Add([pscustomobject]@{ id = $targetId; owner_type = "case"; owner_id = $ownerId; file_name = $file.OriginalName; file_path = "upload/$targetRelativePath"; content_type = Get-ContentType $file.StoredName; file_size = $size; remark = $file.Remark; created_at = $fileCreatedAt; created_by = $createdBy })
                Add-FileManifestRow -Rows $fileManifestRows -TargetFileId $targetId -OwnerType "case" -OwnerId $ownerId -SourceArea "upload" -SourceRoot $SourceUploadRoot -SourceRelativePath $file.RelativePath -TargetArea "upload" -TargetRoot $TargetUploadRoot -TargetRelativePath $targetRelativePath
                $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:CM_CAHD_Care_CustomFormAnswer_File:$sourceId"; source_table = "CM_CAHD_Care_CustomFormAnswer_File"; source_id = $sourceId; target_table = "mcr.registry_file"; target_id = $targetId; created_at = $fileCreatedAt })
            }
        }

        foreach ($row in $fileInfoRows.Rows) {
            $oldFileId = Get-DbValue $row "ID"
            $key = $oldFileId.ToLowerInvariant()
            if ([string]::IsNullOrWhiteSpace($oldFileId) -or $referencedFileKeys.Contains($key)) { continue }
            $path = Get-DbValue $row "Path"
            if ([string]::IsNullOrWhiteSpace($path)) { continue }
            $createdAt = Get-DateValue $row "CreateTime"
            $dateFolder = if ([string]::IsNullOrWhiteSpace($createdAt)) { "" } else { ([datetime]$createdAt).ToString("yyyyMMdd") }
            $fileName = ($path.Replace("\", "/") -split "/")[-1]
            $relativePath = if ([string]::IsNullOrWhiteSpace($dateFolder)) { $fileName } else { "$dateFolder/$fileName" }
            $targetId = ConvertTo-StableGuid "registry-file:legacy-file:$oldFileId"
            $sourceRelativePath = ConvertTo-RelativeFilePath $path
            $fileRows.Add([pscustomobject]@{ id = $targetId; owner_type = "legacy_file"; owner_id = $targetId; file_name = $fileName; file_path = "upload/$relativePath"; content_type = Get-ContentType $fileName; file_size = Get-DbValue $row "Size"; remark = ""; created_at = $createdAt; created_by = Get-DbValue $row "VID" })
            Add-FileManifestRow -Rows $fileManifestRows -TargetFileId $targetId -OwnerType "legacy_file" -OwnerId $targetId -SourceArea "upload" -SourceRoot $SourceUploadRoot -SourceRelativePath $sourceRelativePath -TargetArea "upload" -TargetRoot $TargetUploadRoot -TargetRelativePath $relativePath
            $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:FileInfo:$oldFileId"; source_table = "FileInfo"; source_id = $oldFileId; target_table = "mcr.registry_file"; target_id = $targetId; created_at = $createdAt })
        }
    }

    if (Test-SourceTable $connection "DicomFile") {
        $dicomRows = Invoke-SourceQuery $connection "select cast(ID as nvarchar(100)) as ID, StudyUid, ChildFolderPath, CreateTime, cast(CreateUserID as nvarchar(100)) as CreateUserID from DicomFile order by CreateTime, ID"
        foreach ($row in $dicomRows.Rows) {
            $oldId = Get-DbValue $row "ID"
            $path = (Get-DbValue $row "ChildFolderPath").TrimStart([char[]]@('\', '/')).Replace("\", "/")
            if ([string]::IsNullOrWhiteSpace($oldId) -or [string]::IsNullOrWhiteSpace($path)) { continue }
            $targetId = ConvertTo-StableGuid "registry-file:DicomFile:$oldId"
            $studyUid = Get-DbValue $row "StudyUid"
            $ownerId = ConvertTo-StableGuid "dicom-study:$studyUid"
            $createdAt = Get-DateValue $row "CreateTime"
            $fileRows.Add([pscustomobject]@{ id = $targetId; owner_type = "dicom"; owner_id = $ownerId; file_name = ($path -split "/")[-1]; file_path = "dicom/$path"; content_type = "application/dicom"; file_size = ""; remark = ""; created_at = $createdAt; created_by = Get-DbValue $row "CreateUserID" })
            Add-FileManifestRow -Rows $fileManifestRows -TargetFileId $targetId -OwnerType "dicom" -OwnerId $ownerId -SourceArea "dicom" -SourceRoot $SourceDicomRoot -SourceRelativePath $path -TargetArea "dicom" -TargetRoot $TargetDicomRoot -TargetRelativePath $path
            $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:DicomFile:$oldId"; source_table = "DicomFile"; source_id = $oldId; target_table = "mcr.registry_file"; target_id = $targetId; created_at = $createdAt })
        }
    }

    if (Test-SourceTable $connection "MCR_Article") {
        $articles = Invoke-SourceQuery $connection @"
select cast(ID as nvarchar(100)) as ID, cast(TopicID as nvarchar(100)) as TopicID, isnull(Type, 1) as Type,
       isnull(Status, 0) as Status, isnull(Title, '') as Title, isnull(Content, '') as Content,
       Cover, CreateTime, cast(CreateUserID as nvarchar(100)) as CreateUserID
from dbo.MCR_Article
"@
        foreach ($row in $articles.Rows) {
            $oldId = Get-DbValue $row "ID"
            if ([string]::IsNullOrWhiteSpace($oldId)) { continue }
            $targetId = Get-TargetGuid "MCRArticle" $oldId
            $createdAt = Get-DateValue $row "CreateTime"
            $articleRows.Add([pscustomobject]@{ id = $targetId; old_article_id = $oldId; topic_id = Get-DbValue $row "TopicID"; type = Get-DbValue $row "Type"; status = Get-DbValue $row "Status"; title = Get-DbValue $row "Title"; content = Get-DbValue $row "Content"; cover = Get-DbValue $row "Cover"; created_at = $createdAt; created_by = Get-DbValue $row "CreateUserID"; updated_at = ""; updated_by = "" })
            $mapRows.Add([pscustomobject]@{ id = ConvertTo-StableGuid "migration-map:MCRArticle:$oldId"; source_table = "MCRArticle"; source_id = $oldId; target_table = "mcr.article"; target_id = $targetId; created_at = $createdAt })
        }
    }
} finally {
    $connection.Dispose()
}

$files = @{
    Hospital = Join-Path $identityDirectory "hospital.csv"
    Department = Join-Path $identityDirectory "department.csv"
    User = Join-Path $identityDirectory "user.csv"
    Role = Join-Path $identityDirectory "role.csv"
    Permission = Join-Path $identityDirectory "permission.csv"
    RolePermission = Join-Path $identityDirectory "role_permission.csv"
    UserRole = Join-Path $identityDirectory "user_role.csv"
    QualityUserMap = Join-Path $identityDirectory "quality_user_map.csv"
    Case = Join-Path $caseDirectory "case_record.csv"
    Quality = Join-Path $qualityDirectory "quality_report.csv"
    QualityItem = Join-Path $qualityDirectory "quality_report_item.csv"
    QualityReject = Join-Path $qualityDirectory "quality_reject.csv"
    Meeting = Join-Path $meetingDirectory "review_meeting.csv"
    MeetingExpert = Join-Path $meetingDirectory "meeting_expert.csv"
    Appraise = Join-Path $meetingDirectory "case_appraise.csv"
    Summary = Join-Path $meetingDirectory "case_summary.csv"
    Vote = Join-Path $meetingDirectory "case_vote.csv"
    File = Join-Path $fileDirectory "registry_file.csv"
    FileManifest = Join-Path $fileDirectory "file_manifest.csv"
    Article = Join-Path $articleDirectory "article.csv"
    Map = Join-Path $OutputDirectory "migration_map.csv"
}

$hospitalRows | Export-Csv -Path $files.Hospital -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$departmentRows | Export-Csv -Path $files.Department -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$userRows | Export-Csv -Path $files.User -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$roleRows | Export-Csv -Path $files.Role -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$permissionRows | Export-Csv -Path $files.Permission -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$rolePermissionRows | Export-Csv -Path $files.RolePermission -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$userRoleRows | Export-Csv -Path $files.UserRole -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$qualityUserMapRows | Export-Csv -Path $files.QualityUserMap -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$caseRowsByOldId.Values | ForEach-Object { [pscustomobject]$_ } | Export-Csv -Path $files.Case -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$qualityRowsByOldId.Values | ForEach-Object { [pscustomobject]$_ } | Export-Csv -Path $files.Quality -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$qualityItemRows | Export-Csv -Path $files.QualityItem -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$qualityRejectRows | Export-Csv -Path $files.QualityReject -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$meetingRows | Export-Csv -Path $files.Meeting -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$meetingExpertRows | Export-Csv -Path $files.MeetingExpert -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$appraiseRowsByOldId.Values | ForEach-Object { [pscustomobject]$_ } | Export-Csv -Path $files.Appraise -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$summaryRows | Export-Csv -Path $files.Summary -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$voteRows | Export-Csv -Path $files.Vote -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$fileRows | Export-Csv -Path $files.File -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$fileManifestRows | Export-Csv -Path $files.FileManifest -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$articleRows | Export-Csv -Path $files.Article -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$mapRows | Export-Csv -Path $files.Map -NoTypeInformation -Encoding (Get-Utf8BomEncoding)
$unmappedRows | Export-Csv -Path (Join-Path $OutputDirectory "unmapped_answers.csv") -NoTypeInformation -Encoding (Get-Utf8BomEncoding)

$importSql = Join-Path $OutputDirectory "01_import_all.sql"
$schemaPath = Join-Path $PSScriptRoot "00_create_schema.sql"
Write-AllImportSql -Path $importSql -Files $files -SchemaPath $schemaPath

$report = [pscustomobject]@{
    hospital_count = $hospitalRows.Count
    department_count = $departmentRows.Count
    user_count = $userRows.Count
    role_count = $roleRows.Count
    permission_count = $permissionRows.Count
    case_count = $caseRowsByOldId.Count
    quality_count = $qualityRowsByOldId.Count
    quality_item_count = $qualityItemRows.Count
    meeting_count = $meetingRows.Count
    case_appraise_count = $appraiseRowsByOldId.Count
    file_count = $fileRows.Count
    file_manifest_count = $fileManifestRows.Count
    file_manifest_path = (Resolve-Path $files.FileManifest).Path
    copied_file_count = @($fileManifestRows | Where-Object { $_.copied -eq "true" }).Count
    missing_source_file_count = @($fileManifestRows | Where-Object { $_.exists_in_source -ne "true" }).Count
    article_count = $articleRows.Count
    migration_map_count = $mapRows.Count
    unmapped_answer_count = $unmappedRows.Count
    import_sql = (Resolve-Path $importSql).Path
    output_directory = (Resolve-Path $OutputDirectory).Path
}

$report | ConvertTo-Json -Depth 4 | Set-Content -Path (Join-Path $OutputDirectory "migration_report.json") -Encoding (Get-Utf8BomEncoding)
$report | ConvertTo-Json -Depth 4

if ($Execute) {
    Invoke-PsqlFile -ConfigPath $TargetConfigPath -ConnectionString $TargetConnection -SqlPath $importSql
}
