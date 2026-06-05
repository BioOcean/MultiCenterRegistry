namespace MultiCenterRegistry.Services;

public static class FormValueDisplayMapper
{
    private static readonly Dictionary<string, string> LegacyOptionNames = new(StringComparer.OrdinalIgnoreCase)
    {
        ["6237DD62-15B9-4676-972D-BF32476B3546"] = "冠心病介入",
        ["C1174C60-2EF2-45F6-85DD-5269B567F996"] = "结构性心脏病介入",
        ["F827AE4A-F24F-4DF9-B92F-7601025A1864"] = "起搏器及CIED植入/置换",
        ["AE92E4FA-5E02-4D4C-A773-3DC79C4935BC"] = "导管消融",
        ["8F3DB288-175D-DCE1-590F-AD49C0BC4041"] = "急诊PCI",
        ["166FE6ED-40FA-0ED3-8F67-AB985B95575F"] = "择期PCI",
        ["AA4D47B6-7852-4A5F-AB95-50D7568DB9C4"] = "单纯CAG"
    };

    private static readonly Dictionary<string, string> CoronaryInterventionOptionNames = new(StringComparer.OrdinalIgnoreCase)
    {
        ["1"] = "急诊PCI",
        ["2"] = "择期PCI",
        ["3"] = "单纯CAG"
    };

    private static readonly Dictionary<string, string> DischargeOptionNames = new(StringComparer.OrdinalIgnoreCase)
    {
        ["1"] = "非心内科患者",
        ["2"] = "患者自行离院",
        ["3"] = "首页填写错误",
        ["4"] = "其他"
    };

    public static string GetDisplayText(string? fieldName, string? fieldText, string? fieldValue)
    {
        var text = string.IsNullOrWhiteSpace(fieldText) ? fieldValue?.Trim() ?? "" : fieldText.Trim();
        return Normalize(fieldName, text);
    }

    public static string Normalize(string? fieldName, string? value)
    {
        var text = value?.Trim() ?? "";
        if (string.IsNullOrWhiteSpace(text))
        {
            return "";
        }

        var name = fieldName?.Trim() ?? "";
        if ((name.Equals("手术类别", StringComparison.OrdinalIgnoreCase) || name.Equals("手术类型", StringComparison.OrdinalIgnoreCase))
            && LegacyOptionNames.TryGetValue(text, out var optionName))
        {
            return optionName;
        }

        if (name.Equals("性别", StringComparison.OrdinalIgnoreCase))
        {
            return text.ToLowerInvariant() switch
            {
                "1" => "男",
                "2" => "女",
                "m" => "男",
                "male" => "男",
                "f" => "女",
                "female" => "女",
                "bf8d205c-55d7-7e00-a834-f51e79bbfd7f" => "男",
                "5df1f0b4-61ca-56a5-4163-8dd441b09534" => "女",
                _ => text
            };
        }

        if (name.Equals("冠心病介入", StringComparison.OrdinalIgnoreCase) && text.All(char.IsDigit))
        {
            return CoronaryInterventionOptionNames.TryGetValue(text, out var coronaryName) ? coronaryName : $"选项 {text}";
        }

        if (name.StartsWith("是否", StringComparison.OrdinalIgnoreCase))
        {
            return text switch
            {
                "1" => "是",
                "2" => "否",
                _ => text
            };
        }

        if ((name.Equals("离院方式", StringComparison.OrdinalIgnoreCase)
             || name.Equals("情况说明/原因说明", StringComparison.OrdinalIgnoreCase)
             || name.Equals("情况/原因说明", StringComparison.OrdinalIgnoreCase))
            && text.All(char.IsDigit))
        {
            return DischargeOptionNames.TryGetValue(text, out var dischargeName) ? dischargeName : $"选项 {text}";
        }

        return text;
    }
}
