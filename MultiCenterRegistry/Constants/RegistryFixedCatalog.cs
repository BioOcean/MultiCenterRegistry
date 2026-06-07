namespace MultiCenterRegistry.Constants;

public sealed record FixedOption(string Value, string Text);

public sealed record QualityMetricTemplate(string Code, string Name, string? CategoryName, int Sort);

public static class RegistryFixedCatalog
{
    public static readonly IReadOnlyList<FixedOption> Diseases =
    [
        new("6237dd62-15b9-4676-972d-bf32476b3546", "冠心病介入"),
        new("c1174c60-2ef2-45f6-85dd-5269b567f996", "结构性心脏病介入"),
        new("f827ae4a-f24f-4df9-b92f-7601025a1864", "起搏器及CIED植入/置换"),
        new("ae92e4fa-5e02-4d4c-a773-3dc79c4935bc", "导管消融")
    ];

    public static readonly IReadOnlyList<FixedOption> SexOptions =
    [
        new("1", "男"),
        new("2", "女")
    ];

    public static readonly IReadOnlyList<FixedOption> YesNoOptions =
    [
        new("1", "是"),
        new("2", "否")
    ];

    public static readonly IReadOnlyList<FixedOption> CoronaryOptions =
    [
        new("1", "急诊PCI"),
        new("2", "择期PCI"),
        new("3", "单纯CAG")
    ];

    public static readonly IReadOnlyList<FixedOption> DischargeModes =
    [
        new("死亡", "死亡"),
        new("自动出院", "自动出院"),
        new("非医嘱离院", "非医嘱离院"),
        new("救护车", "救护车")
    ];

    public static readonly IReadOnlyList<FixedOption> SituationReasons =
    [
        new("1", "非心内科患者"),
        new("2", "患者自行离院"),
        new("3", "首页填写错误"),
        new("4", "其他")
    ];

    public static readonly IReadOnlyList<QualityMetricTemplate> QualityMetrics =
    [
        new("total", "总例数", "总体", 10),
        new("death", "死亡例数", "总体", 20),
        new("complication", "并发症例数", "总体", 30),
        new("rescue", "并发症救治例数", "总体", 40),
        new("discussion", "组织并发症讨论例数", "总体", 50),
        new("improvement", "制定改进措施例数", "总体", 60)
    ];

    public static string GetDiseaseName(string? value) => GetText(Diseases, value);

    public static string GetSexName(string? value) => GetText(SexOptions, value);

    public static string GetYesNoName(string? value) => GetText(YesNoOptions, value);

    public static string GetSituationReasonName(string? value) => GetText(SituationReasons, value);

    public static string GetText(IEnumerable<FixedOption> options, string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return "";
        }

        return options.FirstOrDefault(x => x.Value.Equals(value, StringComparison.OrdinalIgnoreCase))?.Text ?? value;
    }
}
