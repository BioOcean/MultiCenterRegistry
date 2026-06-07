using MudBlazor;

namespace MultiCenterRegistry.Constants;

public sealed record FeatureItem(
    string Key,
    string Title,
    string Href,
    string Icon,
    string[] PermissionCodes,
    string Group);

public static class FeatureCatalog
{
    private const string ClinicalGroup = "clinical";
    private const string ReviewGroup = "review";
    private const string AdminGroup = "admin";

    public static readonly IReadOnlyList<FeatureItem> Items =
    [
        new(
            "cases",
            "病例管理",
            RouteConstants.CaseList,
            Icons.Material.Filled.Assignment,
            [
                PermissionConstants.CaseSubmit,
                PermissionConstants.CaseApprove,
                PermissionConstants.QualityManage,
                PermissionConstants.CaseCreate,
                PermissionConstants.CaseEdit,
                PermissionConstants.CaseDelete,
                PermissionConstants.ImportCase
            ],
            ClinicalGroup),
        new(
            "quality",
            "数据报表",
            RouteConstants.QualityList,
            Icons.Material.Filled.FactCheck,
            [PermissionConstants.QualityCreate, PermissionConstants.QualityView, PermissionConstants.QualityManage],
            ClinicalGroup),
        new(
            "meetings",
            "评审会议",
            RouteConstants.MeetingList,
            Icons.Material.Filled.RateReview,
            [PermissionConstants.QualityManage, PermissionConstants.AppraiseEdit, PermissionConstants.AppraiseView],
            ReviewGroup),
        new(
            "admin-users",
            "账号管理",
            RouteConstants.AdminUsers,
            Icons.Material.Filled.People,
            [PermissionConstants.AccountManager],
            AdminGroup),
        new(
            "admin-articles",
            "文献介绍",
            RouteConstants.AdminArticles,
            Icons.Material.Filled.Article,
            [PermissionConstants.MessageManager],
            AdminGroup),
        new(
            "admin-messages",
            "系统消息",
            RouteConstants.AdminMessages,
            Icons.Material.Filled.Campaign,
            [PermissionConstants.MessageManager],
            AdminGroup),
        new(
            "admin-portal",
            "门户介绍",
            RouteConstants.AdminPortal,
            Icons.Material.Filled.Web,
            [PermissionConstants.MessageManager],
            AdminGroup)
    ];

    public static string GetDefaultPath(IReadOnlyCollection<string> permissionCodes)
    {
        if (IsQualityCenterRole(permissionCodes))
        {
            return RouteConstants.QualityList;
        }

        if (IsHospitalQualityRole(permissionCodes) || IsOperatorRole(permissionCodes))
        {
            return RouteConstants.CaseList;
        }

        if (IsAppraiseRole(permissionCodes))
        {
            return RouteConstants.MeetingList;
        }

        if (HasAny(permissionCodes, PermissionConstants.CaseSubmit, PermissionConstants.CaseApprove))
        {
            return RouteConstants.CaseList;
        }

        if (HasAny(permissionCodes, PermissionConstants.MessageManager))
        {
            return RouteConstants.AdminArticles;
        }

        if (HasAny(permissionCodes, PermissionConstants.AccountManager))
        {
            return RouteConstants.AdminUsers;
        }

        return "";
    }

    public static List<FeatureItem> GetMenus(string path, IReadOnlyCollection<string> permissionCodes)
    {
        var isAdminPath = path.Equals(RouteConstants.Admin, StringComparison.OrdinalIgnoreCase)
            || path.StartsWith($"{RouteConstants.Admin}/", StringComparison.OrdinalIgnoreCase);

        if (!isAdminPath && IsQualityCenterRole(permissionCodes))
        {
            return
            [
                new(
                    "quality-report",
                    "数据报表",
                    RouteConstants.QualityList,
                    Icons.Material.Filled.FactCheck,
                    [PermissionConstants.QualityManage],
                    ClinicalGroup),
                new(
                    "case-report",
                    "病例报表",
                    RouteConstants.CaseList,
                    Icons.Material.Filled.Assignment,
                    [PermissionConstants.QualityManage],
                    ClinicalGroup),
                new(
                    "review-meetings",
                    "评审会议",
                    RouteConstants.MeetingList,
                    Icons.Material.Filled.RateReview,
                    [PermissionConstants.QualityManage],
                    ReviewGroup)
            ];
        }

        if (!isAdminPath && IsHospitalQualityRole(permissionCodes))
        {
            return
            [
                new(
                    "cases",
                    "病例管理",
                    RouteConstants.CaseList,
                    Icons.Material.Filled.Assignment,
                    [
                        PermissionConstants.CaseApprove,
                        PermissionConstants.CaseCreate,
                        PermissionConstants.CaseEdit,
                        PermissionConstants.CaseDelete
                    ],
                    ClinicalGroup),
                new(
                    "quality",
                    "数据报表",
                    RouteConstants.QualityList,
                    Icons.Material.Filled.FactCheck,
                    [PermissionConstants.QualityCreate],
                    ClinicalGroup)
            ];
        }

        if (!isAdminPath && IsOperatorRole(permissionCodes))
        {
            return
            [
                new(
                    "cases",
                    "病例管理",
                    RouteConstants.CaseList,
                    Icons.Material.Filled.Assignment,
                    [PermissionConstants.CaseSubmit, PermissionConstants.CaseEdit],
                    ClinicalGroup)
            ];
        }

        if (!isAdminPath && IsAppraiseRole(permissionCodes))
        {
            return
            [
                new(
                    "review-meetings",
                    "评审会议",
                    RouteConstants.MeetingList,
                    Icons.Material.Filled.RateReview,
                    [PermissionConstants.AppraiseEdit, PermissionConstants.AppraiseView],
                    ReviewGroup)
            ];
        }

        var group = GetMenuGroup(path, permissionCodes);
        return Items
            .Where(item => item.Group == group)
            .Where(item => item.PermissionCodes.Any(code => permissionCodes.Contains(code, StringComparer.OrdinalIgnoreCase)))
            .ToList();
    }

    public static bool CanAccessPath(string path, IReadOnlyCollection<string> permissionCodes)
    {
        if (path.Equals(RouteConstants.Home, StringComparison.OrdinalIgnoreCase)
            || path.Equals(RouteConstants.Portal, StringComparison.OrdinalIgnoreCase)
            || path.Equals(RouteConstants.Login, StringComparison.OrdinalIgnoreCase)
            || path.Equals(RouteConstants.Error, StringComparison.OrdinalIgnoreCase)
            || path.Equals(RouteConstants.NotFound, StringComparison.OrdinalIgnoreCase))
        {
            return true;
        }

        if (path.Equals(RouteConstants.Admin, StringComparison.OrdinalIgnoreCase))
        {
            return HasAny(permissionCodes, PermissionConstants.AccountManager, PermissionConstants.MessageManager);
        }

        if (path.Equals(RouteConstants.AdminUsers, StringComparison.OrdinalIgnoreCase))
        {
            return HasAny(permissionCodes, PermissionConstants.AccountManager);
        }

        if (path.Equals(RouteConstants.AdminArticles, StringComparison.OrdinalIgnoreCase)
            || path.Equals(RouteConstants.AdminMessages, StringComparison.OrdinalIgnoreCase)
            || path.Equals(RouteConstants.AdminPortal, StringComparison.OrdinalIgnoreCase))
        {
            return HasAny(permissionCodes, PermissionConstants.MessageManager);
        }

        if (path.Equals(RouteConstants.CaseList, StringComparison.OrdinalIgnoreCase))
        {
            return HasAny(permissionCodes, PermissionConstants.CaseSubmit, PermissionConstants.CaseApprove, PermissionConstants.QualityManage, PermissionConstants.CaseCreate, PermissionConstants.CaseEdit, PermissionConstants.CaseDelete, PermissionConstants.ImportCase);
        }

        if (path.StartsWith($"{RouteConstants.CaseList}/", StringComparison.OrdinalIgnoreCase))
        {
            return HasAny(permissionCodes, PermissionConstants.CaseSubmit, PermissionConstants.CaseApprove, PermissionConstants.QualityManage, PermissionConstants.CaseEdit, PermissionConstants.CaseDelete, PermissionConstants.AppraiseEdit, PermissionConstants.AppraiseView);
        }

        if (path.Equals(RouteConstants.QualityList, StringComparison.OrdinalIgnoreCase))
        {
            return HasAny(permissionCodes, PermissionConstants.QualityCreate, PermissionConstants.QualityView, PermissionConstants.QualityManage);
        }

        if (path.StartsWith($"{RouteConstants.QualityList}/", StringComparison.OrdinalIgnoreCase))
        {
            return HasAny(permissionCodes, PermissionConstants.QualityCreate, PermissionConstants.QualityView, PermissionConstants.QualityManage);
        }

        if (path.Equals(RouteConstants.MeetingList, StringComparison.OrdinalIgnoreCase))
        {
            return HasAny(permissionCodes, PermissionConstants.QualityManage, PermissionConstants.AppraiseEdit, PermissionConstants.AppraiseView);
        }

        if (path.StartsWith($"{RouteConstants.MeetingList}/", StringComparison.OrdinalIgnoreCase))
        {
            return HasAny(permissionCodes, PermissionConstants.QualityManage, PermissionConstants.AppraiseEdit, PermissionConstants.AppraiseView);
        }

        return false;
    }

    private static string GetMenuGroup(string path, IReadOnlyCollection<string> permissionCodes)
    {
        if (path.Equals(RouteConstants.Admin, StringComparison.OrdinalIgnoreCase)
            || path.StartsWith($"{RouteConstants.Admin}/", StringComparison.OrdinalIgnoreCase))
        {
            return AdminGroup;
        }

        if (path.Equals(RouteConstants.MeetingList, StringComparison.OrdinalIgnoreCase)
            || path.StartsWith($"{RouteConstants.MeetingList}/", StringComparison.OrdinalIgnoreCase)
            || IsAppraiseOnlyCasePath(path, permissionCodes))
        {
            return ReviewGroup;
        }

        return ClinicalGroup;
    }

    private static bool IsAppraiseOnlyCasePath(string path, IReadOnlyCollection<string> permissionCodes)
        => path.StartsWith($"{RouteConstants.CaseList}/", StringComparison.OrdinalIgnoreCase)
           && !HasAny(permissionCodes, PermissionConstants.CaseSubmit, PermissionConstants.CaseApprove, PermissionConstants.QualityManage, PermissionConstants.CaseEdit)
           && HasAny(permissionCodes, PermissionConstants.AppraiseEdit, PermissionConstants.AppraiseView);

    private static bool HasAny(IReadOnlyCollection<string> permissionCodes, params string[] codes)
        => codes.Any(code => permissionCodes.Contains(code, StringComparer.OrdinalIgnoreCase));

    private static bool IsQualityCenterRole(IReadOnlyCollection<string> permissionCodes)
        => HasAny(permissionCodes, PermissionConstants.QualityManage)
           && !HasAny(permissionCodes, PermissionConstants.CaseSubmit, PermissionConstants.CaseApprove);

    private static bool IsHospitalQualityRole(IReadOnlyCollection<string> permissionCodes)
        => HasAny(permissionCodes, PermissionConstants.QualityCreate)
           && HasAny(permissionCodes, PermissionConstants.CaseApprove)
           && !HasAny(permissionCodes, PermissionConstants.QualityManage);

    private static bool IsOperatorRole(IReadOnlyCollection<string> permissionCodes)
        => HasAny(permissionCodes, PermissionConstants.CaseSubmit)
           && !HasAny(permissionCodes, PermissionConstants.CaseApprove, PermissionConstants.QualityManage);

    private static bool IsAppraiseRole(IReadOnlyCollection<string> permissionCodes)
        => HasAny(permissionCodes, PermissionConstants.AppraiseEdit, PermissionConstants.AppraiseView)
           && !HasAny(permissionCodes, PermissionConstants.QualityManage);
}
