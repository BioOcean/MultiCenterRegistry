namespace MultiCenterRegistry.Services;

public static class FormValueDisplayMapper
{
    private static readonly Dictionary<string, string> LegacyOptionNames = new(StringComparer.OrdinalIgnoreCase)
    {
        ["8F3DB288-175D-DCE1-590F-AD49C0BC4041"] = "急诊PCI",
        ["166FE6ED-40FA-0ED3-8F67-AB985B95575F"] = "择期PCI",
        ["AA4D47B6-7852-4A5F-AB95-50D7568DB9C4"] = "单纯CAG"
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

        if (LegacyOptionNames.TryGetValue(text, out var optionName))
        {
            return optionName;
        }

        var name = fieldName?.Trim() ?? "";
        if (name.Equals("性别", StringComparison.OrdinalIgnoreCase))
        {
            return text switch
            {
                "1" => "男",
                "2" => "女",
                _ => text
            };
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

        if (name.Equals("离院方式", StringComparison.OrdinalIgnoreCase) && text.All(char.IsDigit))
        {
            return DischargeOptionNames.TryGetValue(text, out var dischargeName) ? dischargeName : $"选项 {text}";
        }

        return text;
    }
}
