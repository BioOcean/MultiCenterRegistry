using System.Globalization;
using System.Security.Claims;
using Bio.Core.Authentication;
using Bio.Core.Authentication.Extension;
using Bio.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using MultiCenterRegistry.Components;
using MultiCenterRegistry.Constants;
using MultiCenterRegistry.Data;
using MultiCenterRegistry.Data.Entities;
using MultiCenterRegistry.Services;
using MudBlazor.Services;
using NLog;
using NLog.Web;
using QuestPDF.Drawing;
using QuestPDF.Infrastructure;

var logger = LogManager.Setup().LoadConfigurationFromFile("nlog.config", optional: true).GetCurrentClassLogger();

try
{
    var builder = WebApplication.CreateBuilder(args);

    builder.Logging.ClearProviders();
    builder.Host.UseNLog();

    var cultureInfo = new CultureInfo("zh-CN");
    CultureInfo.DefaultThreadCurrentCulture = cultureInfo;
    CultureInfo.DefaultThreadCurrentUICulture = cultureInfo;
    ConfigureQuestPdfFonts();

    builder.Services.AddRazorComponents()
        .AddInteractiveServerComponents();
    builder.Services.AddCascadingAuthenticationState();
    builder.Services.AddAuthorization();
    builder.Services.AddHttpContextAccessor();
    builder.Services.AddMudServices();
    builder.Services.AddScoped<RegistryPdfService>();

    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection")
        ?? throw new InvalidOperationException("缺少数据库连接配置 DefaultConnection。");

    builder.Services.AddDbContextFactory<CubeDbContext>(options =>
        options.UseNpgsql(connectionString, npgsql =>
            {
                npgsql.UseQuerySplittingBehavior(QuerySplittingBehavior.SplitQuery);
                npgsql.CommandTimeout(60);
            })
            .ConfigureWarnings(warnings => warnings
                .Ignore(RelationalEventId.MultipleCollectionIncludeWarning)
                .Ignore(CoreEventId.FirstWithoutOrderByAndFilterWarning)));

    builder.Services.AddDbContextFactory<RegistryDbContext>(options =>
        options.UseNpgsql(connectionString, npgsql =>
        {
            npgsql.MigrationsHistoryTable("__ef_migrations_history", RegistryDbContext.SchemaName);
            npgsql.CommandTimeout(60);
        }));

    builder.Services.AddBioAuthentication(builder.Configuration);

    var app = builder.Build();

    if (!app.Environment.IsDevelopment())
    {
        app.UseExceptionHandler("/error", createScopeForErrors: true);
        app.UseHsts();
    }

    app.UseHttpsRedirection();
    app.UseStaticFiles();
    app.MapStaticAssets();

    app.UseBioAuthentication();
    app.UseAuthentication();
    app.UseAuthorization();
    app.UseAntiforgery();

    app.MapBioAuthEndpoints();
    app.MapPost("/api/mcr/auth/roles", async Task<IResult> (
        McrRoleListRequest request,
        IDbContextFactory<RegistryDbContext> dbContextFactory) =>
    {
        var account = request.Account.Trim();
        if (string.IsNullOrWhiteSpace(account) || string.IsNullOrWhiteSpace(request.Password))
        {
            return Results.Json(new McrRoleListResponse(false, "请输入用户名和密码", []), statusCode: StatusCodes.Status400BadRequest);
        }

        await using var dbContext = await dbContextFactory.CreateDbContextAsync();
        var user = await dbContext.SystemUsers.AsNoTracking()
            .Where(x => x.IsValid && EF.Functions.ILike(x.Account, account))
            .Select(x => new { x.Id, x.Password })
            .FirstOrDefaultAsync();
        if (user == null || !VerifyPassword(new PasswordHasher(), user.Password, request.Password))
        {
            return Results.Json(new McrRoleListResponse(false, "用户名或密码错误", []), statusCode: StatusCodes.Status401Unauthorized);
        }

        var mcrRoleIds = await dbContext.SystemMapRolePermissions.AsNoTracking()
            .Join(
                dbContext.SystemPermissions.AsNoTracking(),
                rolePermission => rolePermission.PermissionId,
                permission => permission.Id,
                (rolePermission, permission) => new { rolePermission.RoleId, permission.Code })
            .Where(x => x.Code != null && x.Code.StartsWith("Power-MCR-"))
            .Select(x => x.RoleId)
            .Distinct()
            .ToListAsync();
        if (mcrRoleIds.Count == 0)
        {
            return Results.Json(new McrRoleListResponse(true, null, []));
        }

        var userRoleIds = await dbContext.SystemMapUserRoles.AsNoTracking()
            .Where(x => x.UserId == user.Id)
            .Select(x => x.RoleId)
            .Distinct()
            .ToListAsync();
        var roleIdSet = mcrRoleIds.Intersect(userRoleIds).ToHashSet();
        if (roleIdSet.Count == 0)
        {
            return Results.Json(new McrRoleListResponse(true, null, []));
        }

        var roleRows = await dbContext.SystemRoles.AsNoTracking()
            .Where(x => x.IsValid)
            .OrderBy(x => x.Name)
            .Select(x => new { x.Id, x.Name, x.Describe })
            .ToListAsync();

        var roles = roleRows
            .Where(x => roleIdSet.Contains(x.Id))
            .Select(x => new McrRoleItem(x.Id, x.Name, x.Describe))
            .ToList();

        return Results.Json(new McrRoleListResponse(true, null, roles));
    }).AllowAnonymous();

    app.MapPost("/api/mcr/auth/selected-role", async Task<IResult> (
        McrSetRoleRequest request,
        HttpContext httpContext,
        IDbContextFactory<RegistryDbContext> dbContextFactory,
        IWebHostEnvironment environment) =>
    {
        var userIdText = GetCurrentUserId(httpContext);
        if (!Guid.TryParse(userIdText, out var userId))
        {
            return Results.Unauthorized();
        }

        await using var dbContext = await dbContextFactory.CreateDbContextAsync();
        var hasRole = await dbContext.SystemMapUserRoles.AsNoTracking()
            .Where(x => x.UserId == userId && x.RoleId == request.RoleId)
            .Join(
                dbContext.SystemRoles.AsNoTracking().Where(x => x.IsValid),
                userRole => userRole.RoleId,
                role => role.Id,
                (userRole, roleId) => roleId)
            .AnyAsync();
        if (!hasRole)
        {
            return Results.Forbid();
        }

        httpContext.Response.Cookies.Append(
            "mcr_selected_role_id",
            request.RoleId.ToString("D"),
            CreateSelectedRoleCookieOptions(environment));
        return Results.Json(new McrAuthResponse(true, null));
    }).RequireAuthorization();

    app.MapDelete("/api/mcr/auth/selected-role", (HttpContext httpContext, IWebHostEnvironment environment) =>
    {
        httpContext.Response.Cookies.Delete("mcr_selected_role_id", CreateSelectedRoleCookieOptions(environment));
        return Results.Json(new McrAuthResponse(true, null));
    }).AllowAnonymous();

    app.MapGet("/exports/cases.xlsx", async Task<IResult> (
        string? start,
        string? end,
        string? hospitalId,
        IDbContextFactory<RegistryDbContext> dbContextFactory,
        HttpContext httpContext) =>
    {
        await using var dbContext = await dbContextFactory.CreateDbContextAsync();
        if (!await HasPermissionAsync(httpContext, dbContext, PermissionConstants.CaseEdit, PermissionConstants.CaseApprove, PermissionConstants.QualityManage))
        {
            return Results.Forbid();
        }

        if (!DateTime.TryParse(start, out var startDate) || !DateTime.TryParse(end, out var endDate) || startDate.Date > endDate.Date)
        {
            return Results.BadRequest("请选择正确的导出开始时间和结束时间。");
        }

        var query = await ApplyCaseScopeAsync(httpContext, dbContext, dbContext.Cases.AsNoTracking());
        if (!string.IsNullOrWhiteSpace(hospitalId))
        {
            query = query.Where(x => x.HospitalId == hospitalId);
        }

        var endExclusive = endDate.Date.AddDays(1);
        var data = await query
            .Where(x => x.AdmissionTime.HasValue && x.AdmissionTime.Value >= startDate.Date && x.AdmissionTime.Value < endExclusive)
            .OrderBy(x => x.AdmissionTime)
            .ThenBy(x => x.PatientName)
            .ToListAsync();

        var hospitalNames = await LoadHospitalNamesAsync(dbContext, data.Select(x => x.HospitalId));
        var departmentNames = await LoadDepartmentNamesAsync(dbContext, data.Select(x => x.DepartmentId));
        var userNames = await LoadUserNamesAsync(dbContext, data.Select(x => x.OperatorId));
        var headers = new[]
        {
            "医院",
            "住院号",
            "姓名",
            "性别",
            "年龄",
            "身份证号",
            "疾病类型",
            "科室名称",
            "术者",
            "入院日期",
            "出院日期",
            "手术日期",
            "住院天数",
            "是否急诊介入",
            "冠心病介入",
            "导管消融",
            "结构性心脏病介入",
            "离院方式",
            "情况/原因说明",
            "补充说明",
            "死亡时间",
            "病例简介",
            "出院诊断",
            "其他检查",
            "造影结果",
            "介入过程",
            "抢救过程",
            "并发症讨论",
            "发生原因",
            "死亡原因",
            "经验教训",
            "改进措施",
            "数据状态",
            "创建时间"
        };

        var rows = data.Select(item => (IReadOnlyList<string?>)new List<string?>
            {
                GetName(item.HospitalId, hospitalNames),
                item.PatientNumber,
                item.PatientName,
                item.PatientSexText ?? RegistryFixedCatalog.GetSexName(item.PatientSex),
                item.PatientAge,
                item.IdNumber,
                item.DiseaseName ?? RegistryFixedCatalog.GetDiseaseName(item.DiseaseId ?? item.SurgeryTypeValue),
                GetName(item.DepartmentId, departmentNames),
                GetName(item.OperatorId, userNames),
                item.AdmissionTime?.ToString("yyyy-MM-dd") ?? "",
                item.DischargeTime?.ToString("yyyy-MM-dd") ?? "",
                item.OperationTime?.ToString("yyyy-MM-dd") ?? "",
                item.HospitalStayDays?.ToString(CultureInfo.InvariantCulture) ?? "",
                RegistryFixedCatalog.GetYesNoName(item.IsEmergencyIntervention),
                RegistryFixedCatalog.GetText(RegistryFixedCatalog.CoronaryOptions, item.CoronaryIntervention),
                item.AblationIntervention,
                item.StructuralIntervention,
                item.DischargeMode,
                RegistryFixedCatalog.GetSituationReasonName(item.SituationReason),
                item.SituationSupplement,
                item.DeathTime?.ToString("yyyy-MM-dd") ?? "",
                item.CaseSummary,
                item.DischargeDiagnosis,
                item.OtherExam,
                item.AngiographyResult,
                item.InterventionProcess,
                item.RescueProcess,
                item.ComplicationDiscussion,
                item.OccurrenceReason,
                item.DeathReason,
                item.LessonsLearned,
                item.ImprovementMeasures,
                GetCaseStatusText(item.Status),
                item.CreatedAt.ToString("yyyy-MM-dd HH:mm")
            }).ToList();

        var bytes = SimpleXlsx.Build("病例", headers, rows);
        return Results.File(bytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", $"病例_{startDate:yyyyMMdd}-{endDate:yyyyMMdd}_{DateTime.Now:yyyyMMddHHmmss}.xlsx");
    }).RequireAuthorization();

    app.MapGet("/exports/quality.xlsx", async Task<IResult> (
        string? start,
        string? end,
        string? hospitalId,
        string? templateId,
        string? status,
        string? keyword,
        IDbContextFactory<RegistryDbContext> dbContextFactory,
        HttpContext httpContext) =>
    {
        await using var dbContext = await dbContextFactory.CreateDbContextAsync();
        if (!await HasPermissionAsync(httpContext, dbContext, PermissionConstants.QualityView, PermissionConstants.QualityManage))
        {
            return Results.Forbid();
        }

        var query = await ApplyQualityScopeAsync(httpContext, dbContext, dbContext.QualityReports.AsNoTracking());
        if (!string.IsNullOrWhiteSpace(start) || !string.IsNullOrWhiteSpace(end))
        {
            if (!DateTime.TryParse($"{start}-01", out var startMonth) || !DateTime.TryParse($"{end}-01", out var endMonth) || startMonth.Date > endMonth.Date)
            {
                return Results.BadRequest("请选择正确的导出开始月份和结束月份。");
            }

            var endExclusive = endMonth.Date.AddMonths(1);
            query = query.Where(x => x.QualityDate >= startMonth.Date && x.QualityDate < endExclusive);
        }

        if (!string.IsNullOrWhiteSpace(hospitalId))
        {
            query = query.Where(x => x.HospitalId == hospitalId);
        }

        if (!string.IsNullOrWhiteSpace(templateId))
        {
            query = query.Where(x => x.TemplateId == templateId);
        }

        if (int.TryParse(status, out var parsedStatus))
        {
            query = query.Where(x => x.Status == parsedStatus);
        }

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            var pattern = $"%{keyword.Trim()}%";
            query = query.Where(x =>
                EF.Functions.ILike(x.Name, pattern)
                || EF.Functions.ILike(x.OldQualityId, pattern)
                || (x.TemplateId != null && EF.Functions.ILike(x.TemplateId, pattern))
                || (x.HospitalId != null && EF.Functions.ILike(x.HospitalId, pattern))
                || (x.QualityUserId != null && EF.Functions.ILike(x.QualityUserId, pattern)));
        }

        var data = await query
            .OrderByDescending(x => x.QualityDate)
            .ToListAsync();

        var hospitalNames = await LoadHospitalNamesAsync(dbContext, data.Select(x => x.HospitalId));
        var userNames = await LoadUserNamesAsync(dbContext, data.Select(x => x.QualityUserId));

        var qualityIds = data.Select(x => x.Id).ToList();
        var metricCodes = RegistryFixedCatalog.QualityMetrics.Select(x => x.Code).ToList();
        var qualityItems = qualityIds.Count == 0
            ? new List<QualityReportItem>()
            : await dbContext.QualityReportItems.AsNoTracking()
                .Where(x => qualityIds.Contains(x.QualityReportId) && metricCodes.Contains(x.MetricCode))
                .ToListAsync();
        var valuesByQuality = qualityItems
            .GroupBy(x => x.QualityReportId)
            .ToDictionary(
                x => x.Key,
                x => x.GroupBy(item => item.MetricCode).ToDictionary(
                    item => item.Key,
                    item => item.OrderByDescending(row => row.UpdatedAt ?? row.CreatedAt).First().CaseCount));

        var headers = new List<string> { "报表", "中心", "疾病类型", "质控月份", "质控员", "状态", "创建时间", "更新时间" };
        headers.AddRange(RegistryFixedCatalog.QualityMetrics.Select(x => x.Name));

        var rows = data.Select(item =>
        {
            valuesByQuality.TryGetValue(item.Id, out var fieldValues);
            var row = new List<string?>
            {
                item.Name,
                item.HospitalName ?? GetName(item.HospitalId, hospitalNames),
                item.TemplateName ?? RegistryFixedCatalog.GetDiseaseName(item.TemplateId),
                item.QualityDate.ToString("yyyy-MM"),
                item.QualityUserName ?? GetName(item.QualityUserId, userNames),
                GetQualityStatusText(item.Status),
                item.CreatedAt.ToString("yyyy-MM-dd HH:mm"),
                item.UpdatedAt?.ToString("yyyy-MM-dd HH:mm") ?? ""
            };
            row.AddRange(RegistryFixedCatalog.QualityMetrics.Select(metric => fieldValues != null && fieldValues.TryGetValue(metric.Code, out var value) ? value?.ToString(CultureInfo.InvariantCulture) : ""));
            return (IReadOnlyList<string?>)row;
        }).ToList();

        var bytes = SimpleXlsx.Build("质控", headers, rows);
        return Results.File(bytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", $"质控_{DateTime.Now:yyyyMMddHHmmss}.xlsx");
    }).RequireAuthorization();

    app.MapGet("/exports/quality/{id:guid}.pdf", async Task<IResult> (
        Guid id,
        RegistryPdfService pdfService,
        IDbContextFactory<RegistryDbContext> dbContextFactory,
        HttpContext httpContext) =>
    {
        await using var dbContext = await dbContextFactory.CreateDbContextAsync();
        if (!await HasPermissionAsync(httpContext, dbContext, PermissionConstants.QualityCreate, PermissionConstants.QualityView, PermissionConstants.QualityManage))
        {
            return Results.Forbid();
        }

        var result = await pdfService.GenerateQualityPdfAsync(id);
        return result == null
            ? Results.NotFound("质控报表不存在。")
            : Results.File(result.Content, "application/pdf", result.FileName);
    }).RequireAuthorization();

    app.MapGet("/exports/appraise/{meetingId:guid}/{caseId:guid}.pdf", async Task<IResult> (
        Guid meetingId,
        Guid caseId,
        RegistryPdfService pdfService,
        IDbContextFactory<RegistryDbContext> dbContextFactory,
        HttpContext httpContext) =>
    {
        await using var dbContext = await dbContextFactory.CreateDbContextAsync();
        if (!await HasPermissionAsync(httpContext, dbContext, PermissionConstants.QualityManage, PermissionConstants.AppraiseEdit, PermissionConstants.AppraiseView))
        {
            return Results.Forbid();
        }

        var result = await pdfService.GenerateAppraisePdfAsync(meetingId, caseId);
        return result == null
            ? Results.NotFound("会议或病例不存在。")
            : Results.File(result.Content, "application/pdf", result.FileName);
    }).RequireAuthorization();

    app.MapGet("/imports/case-template.xlsx", async Task<IResult> (IDbContextFactory<RegistryDbContext> dbContextFactory, HttpContext httpContext) =>
    {
        await using var dbContext = await dbContextFactory.CreateDbContextAsync();
        if (!await HasPermissionAsync(httpContext, dbContext, PermissionConstants.ImportCase, PermissionConstants.QualityManage))
        {
            return Results.Forbid();
        }

        var headers = new[]
        {
            "患者姓名",
            "性别",
            "年龄",
            "病案号",
            "身份证号",
            "疾病类型ID",
            "疾病类型名称",
            "医院ID",
            "科室ID",
            "住院科室",
            "经办人ID",
            "入院时间",
            "出院时间",
            "手术时间",
            "住院天数",
            "是否急诊介入",
            "冠心病介入",
            "导管消融",
            "结构性心脏病介入",
            "离院方式",
            "情况/原因说明",
            "补充说明",
            "死亡时间",
            "病例简介",
            "出院诊断",
            "其他检查",
            "造影结果",
            "介入过程",
            "抢救过程",
            "并发症讨论",
            "发生原因",
            "死亡原因",
            "经验教训",
            "改进措施"
        };
        var rows = RegistryFixedCatalog.Diseases.Select(x =>
        {
            var row = headers.Select(_ => (string?)"").ToList();
            row[5] = x.Value;
            row[6] = x.Text;
            return (IReadOnlyList<string?>)row;
        }).ToList();
        var bytes = SimpleXlsx.Build("病例导入", headers, rows);
        return Results.File(bytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "病例导入模板.xlsx");
    }).RequireAuthorization();

    app.MapGet("/files/{id:guid}", async Task<IResult> (
        Guid id,
        bool download,
        IDbContextFactory<RegistryDbContext> dbContextFactory,
        IConfiguration configuration,
        IWebHostEnvironment environment) =>
    {
        await using var dbContext = await dbContextFactory.CreateDbContextAsync();
        var file = await dbContext.Files.AsNoTracking().FirstOrDefaultAsync(x => x.Id == id);
        if (file == null)
        {
            return Results.NotFound("文件不存在。");
        }

        var isDicom = file.FilePath.StartsWith("dicom/", StringComparison.OrdinalIgnoreCase);
        var root = isDicom
            ? configuration["FileStorage:DicomRoot"]
            : configuration["FileStorage:UploadRoot"];

        if (string.IsNullOrWhiteSpace(root))
        {
            return Results.NotFound("未配置文件根目录。");
        }

        var prefix = isDicom ? "dicom/" : "upload/";
        var relativePath = file.FilePath.StartsWith(prefix, StringComparison.OrdinalIgnoreCase)
            ? file.FilePath[prefix.Length..]
            : file.FilePath;
        relativePath = relativePath
            .Replace('/', Path.DirectorySeparatorChar)
            .Replace('\\', Path.DirectorySeparatorChar)
            .TrimStart(Path.DirectorySeparatorChar);

        var rootPath = ResolveStorageRoot(root, environment);
        var fullPath = Path.GetFullPath(Path.Combine(rootPath, relativePath));
        var rootPrefix = rootPath.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar)
            + Path.DirectorySeparatorChar;
        if (!fullPath.StartsWith(rootPrefix, StringComparison.OrdinalIgnoreCase))
        {
            return Results.BadRequest("文件路径非法。");
        }

        if (!File.Exists(fullPath))
        {
            return Results.NotFound("文件不存在或尚未迁移到文件目录。");
        }

        return Results.File(
            fullPath,
            file.ContentType ?? "application/octet-stream",
            download ? file.FileName : null,
            enableRangeProcessing: true);
    }).RequireAuthorization();

    app.MapRazorComponents<App>()
        .AddInteractiveServerRenderMode();

    app.Run();
}
catch (Exception ex)
{
    logger.Error(ex, "应用程序启动失败");
    throw;
}
finally
{
    LogManager.Shutdown();
}

static void ConfigureQuestPdfFonts()
{
    QuestPDF.Settings.License = LicenseType.Community;
    QuestPDF.Settings.CheckIfAllTextGlyphsAreAvailable = false;

    const string linuxFontPath = "/usr/share/fonts";
    if (!QuestPDF.Settings.FontDiscoveryPaths.Contains(linuxFontPath))
    {
        QuestPDF.Settings.FontDiscoveryPaths.Add(linuxFontPath);
    }

    const string notoCjkFontPath = "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc";
    if (File.Exists(notoCjkFontPath))
    {
        using var fontStream = File.OpenRead(notoCjkFontPath);
        FontManager.RegisterFontWithCustomName("Microsoft YaHei", fontStream);
    }
}

static async Task<bool> HasPermissionAsync(HttpContext httpContext, RegistryDbContext dbContext, params string[] codes)
{
    var userIdText = GetCurrentUserId(httpContext);
    if (!Guid.TryParse(userIdText, out var userId))
    {
        return false;
    }

    if (!TryGetSelectedRoleId(httpContext, out var selectedRoleId))
    {
        return false;
    }

    return await dbContext.SystemMapUserRoles.AsNoTracking()
        .Where(x => x.UserId == userId && x.RoleId == selectedRoleId)
        .Join(
            dbContext.SystemRoles.AsNoTracking().Where(x => x.IsValid),
            userRole => userRole.RoleId,
            role => role.Id,
            (userRole, role) => role.Id)
        .Join(
            dbContext.SystemMapRolePermissions.AsNoTracking(),
            roleId => roleId,
            rolePermission => rolePermission.RoleId,
            (userRole, rolePermission) => rolePermission.PermissionId)
        .Join(
            dbContext.SystemPermissions.AsNoTracking(),
            permissionId => permissionId,
            permission => permission.Id,
            (permissionId, permission) => permission.Code)
        .AnyAsync(x => x != null && codes.Contains(x));
}

static string? GetCurrentUserId(HttpContext httpContext)
    => httpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value
       ?? httpContext.User.FindFirst("userId")?.Value
       ?? httpContext.User.FindFirst("id")?.Value
       ?? httpContext.User.Identity?.Name;

static bool TryGetSelectedRoleId(HttpContext httpContext, out Guid roleId)
{
    roleId = Guid.Empty;
    return Guid.TryParse(httpContext.Request.Cookies["mcr_selected_role_id"], out roleId);
}

static async Task<IQueryable<RegistryCase>> ApplyCaseScopeAsync(HttpContext httpContext, RegistryDbContext dbContext, IQueryable<RegistryCase> query)
{
    if (await HasPermissionAsync(httpContext, dbContext, PermissionConstants.QualityManage))
    {
        return query;
    }

    if (await HasPermissionAsync(httpContext, dbContext, PermissionConstants.CaseApprove))
    {
        var userIdText = GetCurrentUserId(httpContext);
        if (!Guid.TryParse(userIdText, out var userId) || !TryGetSelectedRoleId(httpContext, out var roleId))
        {
            return query.Where(x => false);
        }

        var scopes = await dbContext.SystemUserRoleScopes.AsNoTracking()
            .Where(x => x.UserId == userId && x.RoleId == roleId)
            .Select(x => new { x.HospitalId, x.DepartmentId })
            .ToListAsync();
        if (scopes.Count == 0)
        {
            return query;
        }

        var hospitalIds = scopes.Select(x => x.HospitalId.ToString()).Distinct().ToList();
        var departmentIds = scopes.Where(x => x.DepartmentId.HasValue).Select(x => x.DepartmentId!.Value.ToString()).Distinct().ToList();
        var hasHospitalWideScope = scopes.Any(x => !x.DepartmentId.HasValue);

        query = query.Where(x => x.HospitalId != null && hospitalIds.Contains(x.HospitalId));
        if (departmentIds.Count > 0 && !hasHospitalWideScope)
        {
            query = query.Where(x => x.DepartmentId != null && departmentIds.Contains(x.DepartmentId));
        }

        return query;
    }

    if (await HasPermissionAsync(httpContext, dbContext, PermissionConstants.CaseSubmit))
    {
        var userIdText = GetCurrentUserId(httpContext);
        query = query.Where(x => x.OperatorId == userIdText);
    }

    return query;
}

static async Task<IQueryable<QualityReport>> ApplyQualityScopeAsync(HttpContext httpContext, RegistryDbContext dbContext, IQueryable<QualityReport> query)
{
    if (await HasPermissionAsync(httpContext, dbContext, PermissionConstants.QualityManage))
    {
        return query;
    }

    var userIdText = GetCurrentUserId(httpContext);
    if (!Guid.TryParse(userIdText, out var userId) || !TryGetSelectedRoleId(httpContext, out var roleId))
    {
        return query.Where(x => false);
    }

    var hospitalIds = await dbContext.SystemUserRoleScopes.AsNoTracking()
        .Where(x => x.UserId == userId && x.RoleId == roleId)
        .Select(x => x.HospitalId.ToString())
        .Distinct()
        .ToListAsync();
    if (hospitalIds.Count > 0)
    {
        query = query.Where(x => x.HospitalId != null && hospitalIds.Contains(x.HospitalId));
    }

    return query;
}

static async Task<Dictionary<Guid, string>> LoadHospitalNamesAsync(RegistryDbContext dbContext, IEnumerable<string?> ids)
{
    var guidIds = ParseGuidIds(ids);
    return guidIds.Count == 0
        ? new Dictionary<Guid, string>()
        : await dbContext.SystemHospitals.AsNoTracking()
            .Where(x => guidIds.Contains(x.Id))
            .ToDictionaryAsync(x => x.Id, x => x.Name);
}

static async Task<Dictionary<Guid, string>> LoadDepartmentNamesAsync(RegistryDbContext dbContext, IEnumerable<string?> ids)
{
    var guidIds = ParseGuidIds(ids);
    return guidIds.Count == 0
        ? new Dictionary<Guid, string>()
        : await dbContext.SystemDepartments.AsNoTracking()
            .Where(x => guidIds.Contains(x.Id))
            .ToDictionaryAsync(x => x.Id, x => string.IsNullOrWhiteSpace(x.DisplayName) ? x.Name : x.DisplayName!);
}

static async Task<Dictionary<Guid, string>> LoadUserNamesAsync(RegistryDbContext dbContext, IEnumerable<string?> ids)
{
    var guidIds = ParseGuidIds(ids);
    return guidIds.Count == 0
        ? new Dictionary<Guid, string>()
        : await dbContext.SystemUsers.AsNoTracking()
            .Where(x => guidIds.Contains(x.Id))
            .ToDictionaryAsync(x => x.Id, x => string.IsNullOrWhiteSpace(x.DisplayName) ? x.Account : x.DisplayName);
}

static List<Guid> ParseGuidIds(IEnumerable<string?> ids)
    => ids
        .Select(x => Guid.TryParse(x, out var id) ? id : (Guid?)null)
        .Where(x => x.HasValue)
        .Select(x => x!.Value)
        .Distinct()
        .ToList();

static string? GetName(string? id, IReadOnlyDictionary<Guid, string> names)
{
    if (Guid.TryParse(id, out var guid) && names.TryGetValue(guid, out var name))
    {
        return name;
    }

    return id;
}

static CookieOptions CreateSelectedRoleCookieOptions(IWebHostEnvironment environment)
    => new()
    {
        HttpOnly = true,
        SameSite = SameSiteMode.Lax,
        Secure = environment.IsProduction(),
        Path = "/",
        Expires = DateTimeOffset.UtcNow.AddDays(30)
    };

static bool VerifyPassword(PasswordHasher passwordHasher, string passwordHash, string password)
{
    try
    {
        if (passwordHasher.Verify(passwordHash, password))
        {
            return true;
        }
    }
    catch
    {
    }

    try
    {
        return passwordHasher.Verify(password, passwordHash);
    }
    catch
    {
        return false;
    }
}

static string GetCaseStatusText(int status)
    => status switch
    {
        0 => "待审核",
        1 => "已回退",
        2 => "已上报",
        3 => "待填写",
        4 => "审核失败",
        _ => $"状态 {status.ToString(CultureInfo.InvariantCulture)}"
    };

static string GetQualityStatusText(int status)
    => status switch
    {
        0 => "未填报",
        1 => "已上报",
        2 => "已驳回",
        _ => $"状态 {status.ToString(CultureInfo.InvariantCulture)}"
    };

static string ResolveStorageRoot(string root, IWebHostEnvironment environment)
    => Path.GetFullPath(Path.IsPathRooted(root) ? root : Path.Combine(environment.ContentRootPath, root));

internal sealed record McrRoleListRequest(string Account, string Password);

internal sealed record McrSetRoleRequest(Guid RoleId);

internal sealed record McrRoleItem(Guid Id, string Name, string? Describe);

internal sealed record McrRoleListResponse(bool Success, string? Message, List<McrRoleItem> Roles);

internal sealed record McrAuthResponse(bool Success, string? Message);
