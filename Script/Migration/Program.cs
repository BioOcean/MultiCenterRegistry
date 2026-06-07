using System.Diagnostics;
using Bio.Core.Authentication.Extension;

Console.OutputEncoding = System.Text.Encoding.UTF8;
Console.InputEncoding = System.Text.Encoding.UTF8;

Console.WriteLine("多中心注册旧版到新版迁移工具");
Console.WriteLine();

var sourceConnection = ReadRequired("旧版 SQL Server 连接串");
var targetConnection = ReadRequired("新版 PostgreSQL 连接串");
var defaultPassword = ReadOptional("新建账号默认密码", "123456");
var outputDirectory = ReadOptional("导出目录", ResolveFromScriptDirectory("output/all_migration"));

Console.WriteLine();
Console.WriteLine("该操作会清理目标库 system 中的 MCR 数据，删除并重建 mcr schema，然后导入旧库数据。");
Console.Write("确认执行请输入 YES：");
if (!string.Equals(Console.ReadLine(), "YES", StringComparison.Ordinal))
{
    Console.WriteLine("已取消。");
    return 1;
}

var scriptPath = FindMigrationScript();
var passwordHash = new PasswordHasher().Hash(defaultPassword);
var shell = FindPowerShell();

var startInfo = new ProcessStartInfo
{
    FileName = shell,
    WorkingDirectory = Path.GetDirectoryName(scriptPath)!,
    UseShellExecute = false
};

startInfo.ArgumentList.Add("-NoProfile");
if (Path.GetFileName(shell).Equals("powershell.exe", StringComparison.OrdinalIgnoreCase))
{
    startInfo.ArgumentList.Add("-ExecutionPolicy");
    startInfo.ArgumentList.Add("Bypass");
}

startInfo.ArgumentList.Add("-File");
startInfo.ArgumentList.Add(scriptPath);
startInfo.ArgumentList.Add("-SourceConnection");
startInfo.ArgumentList.Add(sourceConnection);
startInfo.ArgumentList.Add("-TargetConnection");
startInfo.ArgumentList.Add(targetConnection);
startInfo.ArgumentList.Add("-TemporaryPasswordHash");
startInfo.ArgumentList.Add(passwordHash);
startInfo.ArgumentList.Add("-OutputDirectory");
startInfo.ArgumentList.Add(outputDirectory);
startInfo.ArgumentList.Add("-Export");
startInfo.ArgumentList.Add("-Execute");

using var process = Process.Start(startInfo) ?? throw new InvalidOperationException("迁移进程启动失败。");
process.WaitForExit();
return process.ExitCode;

static string ReadRequired(string name)
{
    while (true)
    {
        Console.Write($"{name}：");
        var value = Console.ReadLine();
        if (!string.IsNullOrWhiteSpace(value))
        {
            return value.Trim();
        }

        Console.WriteLine($"{name}不能为空。");
    }
}

static string ReadOptional(string name, string defaultValue)
{
    Console.Write($"{name} [{defaultValue}]：");
    var value = Console.ReadLine();
    return string.IsNullOrWhiteSpace(value) ? defaultValue : value.Trim();
}

static string FindPowerShell()
{
    foreach (var name in new[] { "pwsh", "powershell.exe", "powershell" })
    {
        try
        {
            var startInfo = new ProcessStartInfo
            {
                FileName = name,
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true
            };
            startInfo.ArgumentList.Add("-NoProfile");
            startInfo.ArgumentList.Add("-Command");
            startInfo.ArgumentList.Add("$PSVersionTable.PSVersion.ToString()");
            using var process = Process.Start(startInfo);
            process?.WaitForExit(3000);
            if (process?.ExitCode == 0)
            {
                return name;
            }
        }
        catch
        {
        }
    }

    throw new InvalidOperationException("未找到 PowerShell。");
}

static string FindMigrationScript()
{
    foreach (var path in GetCandidateScriptPaths())
    {
        if (File.Exists(path))
        {
            return Path.GetFullPath(path);
        }
    }

    throw new FileNotFoundException("未找到 01_migrate_all.ps1，请从仓库根目录或 Script/Migration 输出目录启动。");
}

static IEnumerable<string> GetCandidateScriptPaths()
{
    var baseDirectory = AppContext.BaseDirectory;
    var currentDirectory = Directory.GetCurrentDirectory();

    yield return Path.Combine(currentDirectory, "Script", "01_migrate_all.ps1");
    yield return Path.Combine(currentDirectory, "01_migrate_all.ps1");
    yield return Path.Combine(currentDirectory, "..", "01_migrate_all.ps1");
    yield return Path.Combine(baseDirectory, "01_migrate_all.ps1");
    yield return Path.Combine(baseDirectory, "..", "01_migrate_all.ps1");
    yield return Path.Combine(baseDirectory, "..", "..", "..", "..", "01_migrate_all.ps1");
}

static string ResolveFromScriptDirectory(string relativePath)
{
    foreach (var path in GetCandidateScriptPaths())
    {
        if (File.Exists(path))
        {
            return Path.GetFullPath(Path.Combine(Path.GetDirectoryName(path)!, relativePath));
        }
    }

    return relativePath;
}
