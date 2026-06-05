namespace MultiCenterRegistry.Constants;

public static class RouteConstants
{
    public const string Home = "/";
    public const string Portal = "/portal";
    public const string Login = "/login";
    public const string Error = "/error";
    public const string NotFound = "/not-found";
    public const string CaseList = "/cases";
    public const string QualityList = "/quality";
    public const string MeetingList = "/meetings";
    public const string Statistics = "/statistics";
    public const string Followups = "/followups";
    public const string Admin = "/admin";
    public const string AdminUsers = "/admin/users";
    public const string AdminArticles = "/admin/articles";
    public const string AdminMessages = "/admin/messages";
    public const string AdminPortal = "/admin/portal";

    public static string CaseDetail(Guid id) => $"{CaseList}/{id}";

    public static string QualityDetail(Guid id) => $"{QualityList}/{id}";

    public static string MeetingDetail(Guid id) => $"{MeetingList}/{id}";

    public static string AppraiseDetail(Guid meetingId, Guid caseId) => $"{MeetingDetail(meetingId)}/cases/{caseId}/appraise";
}
