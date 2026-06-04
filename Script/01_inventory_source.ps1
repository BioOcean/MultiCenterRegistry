param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$OutputPath = ".\Script\output\source_inventory.json"
)

if ([string]::IsNullOrWhiteSpace($SourceConnection)) {
    throw "请先通过环境变量 MCR_SOURCE_SQLSERVER 或参数 SourceConnection 提供旧库连接字符串。"
}

$tables = @(
    "MCR_Case",
    "MCR_Quality",
    "MCR_QualityReject",
    "MCR_Meeting",
    "MCR_MeetingExpertMap",
    "MCR_Appraise",
    "MCR_Advice",
    "MCR_Summary",
    "MCR_Vote",
    "CM_CAHD_Care_CustomForm",
    "CM_CAHD_Care_CustomFormSubject",
    "CM_CAHD_Care_SubjectConfig",
    "CM_CAHD_Care_CustomFormAnswer",
    "Hospital",
    "DoctorInfo",
    "Users"
)

try {
    Add-Type -AssemblyName "Microsoft.Data.SqlClient"
    $connectionType = "Microsoft.Data.SqlClient.SqlConnection"
} catch {
    Add-Type -AssemblyName "System.Data"
    $connectionType = "System.Data.SqlClient.SqlConnection"
}

$connection = New-Object $connectionType $SourceConnection
$result = [ordered]@{}

try {
    $connection.Open()

    foreach ($table in $tables) {
        $command = $connection.CreateCommand()
        $command.CommandText = "select count(1) from [$table]"
        $result[$table] = [int64]$command.ExecuteScalar()
    }
} finally {
    $connection.Dispose()
}

$directory = Split-Path -Parent $OutputPath
if (-not [string]::IsNullOrWhiteSpace($directory)) {
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
}

$result | ConvertTo-Json -Depth 4 | Set-Content -Path $OutputPath -Encoding utf8BOM
Write-Host "只读盘点完成：$OutputPath"
