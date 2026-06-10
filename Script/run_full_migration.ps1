param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$TargetConnection = $env:MCR_TARGET_POSTGRES,
    [string]$TargetConfigPath = (Join-Path $PSScriptRoot "..\MultiCenterRegistry\appsettings.json"),
    [string]$OutputDirectory = (Join-Path $PSScriptRoot "output\all_migration"),
    [string]$TemporaryPasswordHash = $env:MCR_TEMP_PASSWORD_HASH,
    [switch]$CleanupOnly,
    [switch]$MigrateOnly,
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

function Invoke-MigrationPsqlFile {
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

function Find-PowerShell {
    $candidates = @("pwsh", "powershell.exe", "powershell")
    foreach ($candidate in $candidates) {
        $command = Get-Command $candidate -ErrorAction SilentlyContinue
        if ($null -ne $command) {
            return $command.Source
        }
    }

    throw "未找到 PowerShell，无法继续迁移。"
}

if ($PlanOnly) {
    Write-Host "完整迁移计划："
    Write-Host "1. 双击 run_full_migration.bat。"
    Write-Host "2. 输入 YES 确认后，脚本会清理目标库、全量迁移数据、按本次 file_manifest.csv 复制实体文件。"
    return
}

if ($CleanupOnly -and $MigrateOnly) {
    throw "CleanupOnly 和 MigrateOnly 不能同时指定。"
}

$shouldCleanup = -not $MigrateOnly
$shouldMigrate = -not $CleanupOnly

if ($shouldMigrate -and [string]::IsNullOrWhiteSpace($SourceConnection)) {
    throw "请提供旧 SQL Server 连接字符串。"
}

if ($shouldMigrate -and [string]::IsNullOrWhiteSpace($TemporaryPasswordHash)) {
    throw "请提供 Bio.Core 生成的临时密码 Hash。"
}

$cleanupSql = Join-Path $PSScriptRoot "03_cleanup_mcr_data.sql"
$migrationScript = Join-Path $PSScriptRoot "01_migrate_all.ps1"

if (-not (Test-Path $cleanupSql)) {
    throw "清理脚本不存在：$cleanupSql"
}

if (-not (Test-Path $migrationScript)) {
    throw "迁移脚本不存在：$migrationScript"
}

if ($shouldCleanup) {
    Write-Host "清理目标库 MCR 数据..."
    Invoke-MigrationPsqlFile -ConfigPath $TargetConfigPath -ConnectionString $TargetConnection -SqlPath $cleanupSql
    Write-Host "清理完成。"
}

if ($shouldMigrate) {
    Write-Host "执行全量数据迁移..."
    $powerShell = Find-PowerShell
    $migrationArguments = @(
        "-NoProfile",
        "-ExecutionPolicy",
        "Bypass",
        "-File",
        $migrationScript,
        "-Export",
        "-Execute",
        "-SourceConnection",
        $SourceConnection,
        "-TargetConfigPath",
        $TargetConfigPath,
        "-OutputDirectory",
        $OutputDirectory,
        "-TemporaryPasswordHash",
        $TemporaryPasswordHash
    )
    if (-not [string]::IsNullOrWhiteSpace($TargetConnection)) {
        $migrationArguments += @("-TargetConnection", $TargetConnection)
    }

    & $powerShell @migrationArguments

    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }

    Write-Host "全量迁移完成。"
    Write-Host "请查看：$OutputDirectory\migration_report.json"
    Write-Host "文件归位清单：$OutputDirectory\05_files\file_manifest.csv"
}
