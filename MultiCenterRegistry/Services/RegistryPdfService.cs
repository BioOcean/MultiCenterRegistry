using Microsoft.EntityFrameworkCore;
using MultiCenterRegistry.Constants;
using MultiCenterRegistry.Data;
using MultiCenterRegistry.Data.Entities;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

namespace MultiCenterRegistry.Services;

public sealed class RegistryPdfService(IDbContextFactory<RegistryDbContext> contextFactory)
{
    public async Task<RegistryPdfFileResult?> GenerateQualityPdfAsync(Guid qualityId)
    {
        await using var dbContext = await contextFactory.CreateDbContextAsync();
        var quality = await dbContext.QualityReports.AsNoTracking().FirstOrDefaultAsync(x => x.Id == qualityId);
        if (quality == null)
        {
            return null;
        }

        var hospitalName = quality.HospitalName ?? await LoadHospitalNameAsync(dbContext, quality.HospitalId);
        var userName = quality.QualityUserName ?? await LoadUserNameAsync(dbContext, quality.QualityUserId);
        var rejects = await dbContext.QualityRejects.AsNoTracking()
            .Where(x => x.QualityReportId == qualityId)
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();
        var items = await dbContext.QualityReportItems.AsNoTracking()
            .Where(x => x.QualityReportId == qualityId)
            .OrderBy(x => x.Sort)
            .ThenBy(x => x.MetricName)
            .ToListAsync();

        var bytes = BuildPdf(quality.Name, $"质控月份：{quality.QualityDate:yyyy-MM}", column =>
        {
            AddSectionTitle(column, "基本信息");
            column.Item().Element(container => ComposeKeyValues(container,
            [
                new("报表名称", quality.Name),
                new("质控月份", quality.QualityDate.ToString("yyyy-MM")),
                new("疾病类型", quality.TemplateName ?? RegistryFixedCatalog.GetDiseaseName(quality.TemplateId)),
                new("医院", hospitalName ?? quality.HospitalId),
                new("质控员", userName ?? quality.QualityUserId),
                new("状态", GetQualityStatusText(quality.Status)),
                new("提交时间", FormatDateTime(quality.SubmittedAt)),
                new("创建时间", FormatDateTime(quality.CreatedAt)),
                new("更新时间", FormatDateTime(quality.UpdatedAt))
            ]));

            AddSectionTitle(column, "驳回记录");
            if (rejects.Count == 0)
            {
                AddEmptyLine(column, "暂无驳回记录");
            }
            else
            {
                column.Item().Element(container => ComposeRejects(container, rejects));
            }

            AddSectionTitle(column, "质控指标");
            column.Item().Element(container => ComposeFields(container, items.Select(x =>
                new PdfFieldItem(x.MetricName, x.CaseCount?.ToString() ?? "-", 2, x.Sort)).ToList()));
        });

        return new RegistryPdfFileResult(BuildFileName($"质控_{quality.Name}_{DateTime.Now:yyyyMMddHHmmss}.pdf"), bytes);
    }

    public async Task<RegistryPdfFileResult?> GenerateAppraisePdfAsync(Guid meetingId, Guid caseId)
    {
        await using var dbContext = await contextFactory.CreateDbContextAsync();
        var meeting = await dbContext.ReviewMeetings.AsNoTracking().FirstOrDefaultAsync(x => x.Id == meetingId);
        var registryCase = await dbContext.Cases.AsNoTracking().FirstOrDefaultAsync(x => x.Id == caseId);
        if (meeting == null || registryCase == null)
        {
            return null;
        }

        var hospitalName = registryCase.HospitalName ?? await LoadHospitalNameAsync(dbContext, registryCase.HospitalId);
        var departmentName = registryCase.DepartmentName ?? await LoadDepartmentNameAsync(dbContext, registryCase.DepartmentId);
        var appraises = await dbContext.CaseAppraises.AsNoTracking()
            .Where(x => x.MeetingId == meetingId && x.CaseId == caseId)
            .OrderBy(x => x.Status)
            .ThenBy(x => x.CreatedAt)
            .ToListAsync();
        var userNames = await LoadUserNamesAsync(dbContext, appraises.Select(x => x.ExpertId));
        var summaries = await dbContext.CaseSummaries.AsNoTracking()
            .Where(x => x.MeetingId == meetingId && x.CaseId == caseId)
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();
        var statistics = BuildStatistics(appraises);

        var bytes = BuildPdf(registryCase.PatientName, meeting.Title, column =>
        {
            AddSectionTitle(column, "会议信息");
            column.Item().Element(container => ComposeKeyValues(container,
            [
                new("会议名称", meeting.Title),
                new("开始时间", FormatDateTime(meeting.MeetingTime)),
                new("结束时间", FormatDateTime(meeting.EndTime)),
                new("地点", meeting.Place),
                new("分组", meeting.GroupInfo),
                new("会议状态", GetMeetingStatusText(meeting.Status))
            ]));

            AddSectionTitle(column, "病例信息");
            column.Item().Element(container => ComposeKeyValues(container,
            [
                new("姓名", registryCase.PatientName),
                new("性别", registryCase.PatientSexText ?? RegistryFixedCatalog.GetSexName(registryCase.PatientSex)),
                new("年龄", registryCase.PatientAge),
                new("病案号", registryCase.PatientNumber),
                new("疾病类型", registryCase.DiseaseName ?? RegistryFixedCatalog.GetDiseaseName(registryCase.DiseaseId ?? registryCase.SurgeryTypeValue)),
                new("医院", hospitalName ?? registryCase.HospitalId),
                new("科室", departmentName ?? registryCase.DepartmentId),
                new("入院时间", FormatDate(registryCase.AdmissionTime)),
                new("出院时间", FormatDate(registryCase.DischargeTime)),
                new("手术时间", FormatDate(registryCase.OperationTime)),
                new("评审状态", GetSubStatusText(registryCase.SubStatus))
            ]));

            AddSectionTitle(column, "病例对照");
            ComposeForms(column, BuildCaseForms(registryCase, hospitalName, departmentName));

            AddSectionTitle(column, "评审汇总");
            ComposeSummaries(column, summaries);

            AddSectionTitle(column, "答案统计");
            ComposeStatistics(column, statistics);

            AddSectionTitle(column, "专家评审");
            if (appraises.Count == 0)
            {
                AddEmptyLine(column, "暂无专家评审");
            }
            else
            {
                foreach (var appraise in appraises)
                {
                    column.Item().PaddingTop(8).Text($"{GetUserName(appraise.ExpertId, userNames)}（{GetAppraiseStatusText(appraise.Status)}）")
                        .FontSize(11)
                        .SemiBold()
                        .FontColor("#0B6F5D");
                    column.Item().Element(container => ComposeFields(container, BuildAppraiseFields(appraise)));
                }
            }

        });

        return new RegistryPdfFileResult(BuildFileName($"评审_{registryCase.PatientName}_{DateTime.Now:yyyyMMddHHmmss}.pdf"), bytes);
    }

    private static byte[] BuildPdf(string title, string? subtitle, Action<ColumnDescriptor> compose)
    {
        return Document.Create(document =>
        {
            document.Page(page =>
            {
                page.Size(PageSizes.A4);
                page.Margin(32);
                page.DefaultTextStyle(x => x.FontFamily("Microsoft YaHei").FontSize(9).FontColor(Colors.Grey.Darken3));
                page.Header().Column(header =>
                {
                    header.Item().Text(title).FontSize(18).SemiBold().FontColor("#0B6F5D");
                    if (!string.IsNullOrWhiteSpace(subtitle))
                    {
                        header.Item().PaddingTop(3).Text(subtitle).FontSize(10).FontColor(Colors.Grey.Darken1);
                    }

                    header.Item().PaddingTop(8).LineHorizontal(1).LineColor("#D5E4DE");
                });
                page.Content().PaddingTop(12).Column(column =>
                {
                    column.Spacing(6);
                    compose(column);
                });
                page.Footer().AlignCenter().Text(text =>
                {
                    text.Span("第 ");
                    text.CurrentPageNumber();
                    text.Span(" / ");
                    text.TotalPages();
                    text.Span(" 页");
                });
            });
        }).GeneratePdf();
    }

    private static List<PdfFormBlock> BuildCaseForms(RegistryCase item, string? hospitalName, string? departmentName)
    {
        var basicFields = new List<PdfFieldItem>
        {
            new("病案号", item.PatientNumber, 2, 10),
            new("患者姓名", item.PatientName, 2, 20),
            new("性别", item.PatientSexText ?? RegistryFixedCatalog.GetSexName(item.PatientSex), 2, 30),
            new("年龄", item.PatientAge, 2, 40),
            new("身份证号码", item.IdNumber, 2, 50),
            new("住院科室", departmentName ?? item.DepartmentName ?? item.DepartmentId, 2, 60),
            new("入院时间", FormatDate(item.AdmissionTime), 2, 70),
            new("出院时间", FormatDate(item.DischargeTime), 2, 80),
            new("住院天数", item.HospitalStayDays?.ToString() ?? "-", 2, 90),
            new("手术类型", item.DiseaseName ?? RegistryFixedCatalog.GetDiseaseName(item.DiseaseId ?? item.SurgeryTypeValue), 2, 100),
            new("术者", item.OperatorName ?? item.OperatorId, 2, 110),
            new("是否急诊介入", RegistryFixedCatalog.GetYesNoName(item.IsEmergencyIntervention), 2, 120),
            new("死亡时间", FormatDate(item.DeathTime), 2, 130),
            new("情况说明/原因说明", RegistryFixedCatalog.GetSituationReasonName(item.SituationReason), 2, 140),
            new("补充说明", item.SituationSupplement, 2, 150),
            new("离院方式", item.DischargeMode, 2, 160)
        };

        if (BuildDiseaseSpecificField(item) is { } diseaseSpecificField)
        {
            basicFields.Add(diseaseSpecificField);
        }

        return
        [
            new("患者基本信息", 10, basicFields),
            new("病历摘要", 20, [new("摘要内容", item.CaseSummary, 2, 10)]),
            new("出院诊断", 30, [new("出院诊断", item.DischargeDiagnosis, 2, 10)]),
            new("相关实验室检查", 40, [new("化验单图片上传", "暂无附件", 2, 10)]),
            new("主要辅助检查", 50,
            [
                new("心电图图片上传", "暂无附件", 2, 10),
                new("心脏彩超", "暂无附件", 2, 20),
                new("其他检查", item.OtherExam, 2, 30)
            ]),
            new("介入诊疗情况", 60,
            [
                new("造影检查结果", item.AngiographyResult, 2, 10),
                new("介入经过", item.InterventionProcess, 2, 20)
            ]),
            new("并发症救治情况", 70, [new("救治经过", item.RescueProcess, 2, 10)]),
            new("并发症讨论结论", 80,
            [
                new("是否组织医院或科室并发症讨论", RegistryFixedCatalog.GetYesNoName(item.ComplicationDiscussion), 2, 10),
                new("发生原因", item.OccurrenceReason, 2, 20),
                new("死亡原因", item.DeathReason, 2, 30),
                new("经验教训", item.LessonsLearned, 2, 40),
                new("改进措施", item.ImprovementMeasures, 2, 50)
            ])
        ];
    }

    private static PdfFieldItem? BuildDiseaseSpecificField(RegistryCase item)
    {
        var diseaseId = item.DiseaseId ?? item.SurgeryTypeValue;
        if (IsSameValue(diseaseId, "6237dd62-15b9-4676-972d-bf32476b3546"))
        {
            return new("冠心病介入", RegistryFixedCatalog.GetText(RegistryFixedCatalog.CoronaryOptions, item.CoronaryIntervention), 2, 170);
        }

        if (IsSameValue(diseaseId, "ae92e4fa-5e02-4d4c-a773-3dc79c4935bc"))
        {
            return new("导管消融", item.AblationIntervention, 2, 170);
        }

        if (IsSameValue(diseaseId, "c1174c60-2ef2-45f6-85dd-5269b567f996"))
        {
            return new("结构性心脏病介入", item.StructuralIntervention, 2, 170);
        }

        return null;
    }

    private static List<PdfFieldItem> BuildAppraiseFields(CaseAppraise appraise)
        =>
        [
            new("介入适应症", DisplayOption(IndicationOptions, appraise.Indication), 2, 10),
            new("介入操作", DisplayOption(OperationOptions, appraise.Operation), 2, 20),
            new("设备器械配套是否齐全", DisplayOption(CompleteOptions, appraise.DeviceComplete), 2, 30),
            new("介入分级手术管理是否落实到位", RegistryFixedCatalog.GetYesNoName(appraise.SurgeryLevelImplemented), 2, 40),
            new("是否存在管理问题", RegistryFixedCatalog.GetYesNoName(appraise.HasManagementProblem), 2, 50),
            new("其他管理问题描述", appraise.ManagementProblemDescription, 2, 60),
            new("救治是否及时", RegistryFixedCatalog.GetYesNoName(appraise.RescueTimely), 2, 70),
            new("救治措施是否得当", RegistryFixedCatalog.GetYesNoName(appraise.RescueMeasureProper), 2, 80),
            new("救治药品设备是否齐全", DisplayOption(CompleteOptions, appraise.RescueDeviceComplete), 2, 90),
            new("死亡原因", DisplayOption(DeathReasonOptions, appraise.DeathReason), 2, 100),
            new("其他死亡原因", appraise.OtherDeathReason, 2, 110),
            new("是否需要提交进一步改进措施", RegistryFixedCatalog.GetYesNoName(appraise.NeedImprovement), 2, 120),
            new("改进措施内容", appraise.ImprovementContent, 2, 130)
        ];

    private static void AddSectionTitle(ColumnDescriptor column, string title)
    {
        column.Item().PaddingTop(10).Text(title)
            .FontSize(13)
            .SemiBold()
            .FontColor("#0B6F5D");
    }

    private static void AddEmptyLine(ColumnDescriptor column, string text)
    {
        column.Item().PaddingVertical(6).Text(text).FontColor(Colors.Grey.Darken1);
    }

    private static void ComposeForms(ColumnDescriptor column, IReadOnlyList<PdfFormBlock> forms)
    {
        if (forms.Count == 0)
        {
            AddEmptyLine(column, "暂无表单数据");
            return;
        }

        foreach (var form in forms)
        {
            column.Item().PaddingTop(8).Text(form.Name)
                .FontSize(11)
                .SemiBold()
                .FontColor("#173B33");
            column.Item().Element(container => ComposeFields(container, form.Fields));
        }
    }

    private static void ComposeKeyValues(IContainer container, IReadOnlyList<PdfKeyValue> items)
    {
        container.Table(table =>
        {
            table.ColumnsDefinition(columns =>
            {
                columns.ConstantColumn(90);
                columns.RelativeColumn();
            });

            foreach (var item in items)
            {
                table.Cell().Element(LabelCell).Text(item.Label);
                table.Cell().Element(ValueCell).Text(ShowValue(item.Value));
            }
        });
    }

    private static void ComposeFields(IContainer container, IReadOnlyList<PdfFieldItem> fields)
    {
        if (fields.Count == 0)
        {
            container.Padding(6).Text("暂无字段数据").FontColor(Colors.Grey.Darken1);
            return;
        }

        container.Table(table =>
        {
            table.ColumnsDefinition(columns =>
            {
                columns.ConstantColumn(150);
                columns.RelativeColumn();
            });

            foreach (var field in fields.OrderBy(x => x.Sort))
            {
                table.Cell().Element(LabelCell).Text(field.FieldName);
                table.Cell().Element(ValueCell).Text(ShowValue(field.DisplayValue));
            }
        });
    }

    private static void ComposeRejects(IContainer container, IReadOnlyList<QualityReject> rejects)
    {
        container.Table(table =>
        {
            table.ColumnsDefinition(columns =>
            {
                columns.ConstantColumn(120);
                columns.RelativeColumn();
            });

            foreach (var reject in rejects)
            {
                table.Cell().Element(LabelCell).Text(FormatDateTime(reject.CreatedAt));
                table.Cell().Element(ValueCell).Text(ShowValue(reject.Content));
            }
        });
    }

    private static void ComposeSummaries(ColumnDescriptor column, IReadOnlyList<CaseSummary> summaries)
    {
        if (summaries.Count == 0)
        {
            AddEmptyLine(column, "暂无汇总");
            return;
        }

        column.Item().Element(container =>
        {
            container.Table(table =>
            {
                table.ColumnsDefinition(columns =>
                {
                    columns.ConstantColumn(100);
                    columns.ConstantColumn(70);
                    columns.RelativeColumn();
                    columns.ConstantColumn(100);
                });

                foreach (var summary in summaries)
                {
                    table.Cell().Element(LabelCell).Text(ShowValue(summary.ExpertName));
                    table.Cell().Element(LabelCell).Text(GetSummaryStatusText(summary.Status));
                    table.Cell().Element(ValueCell).Text(ShowValue(summary.Content));
                    table.Cell().Element(LabelCell).Text(FormatDateTime(summary.CreatedAt));
                }
            });
        });
    }

    private static void ComposeStatistics(ColumnDescriptor column, IReadOnlyList<PdfStatistic> statistics)
    {
        if (statistics.Count == 0)
        {
            AddEmptyLine(column, "暂无可统计答案");
            return;
        }

        foreach (var item in statistics)
        {
            column.Item().PaddingTop(4).Text(item.FieldName).SemiBold().FontColor("#173B33");
            column.Item().Element(container =>
            {
                container.Table(table =>
                {
                    table.ColumnsDefinition(columns =>
                    {
                        columns.RelativeColumn();
                        columns.ConstantColumn(70);
                    });

                    foreach (var option in item.Options)
                    {
                        table.Cell().Element(ValueCell).Text(option.Text);
                        table.Cell().Element(LabelCell).Text($"{option.Count} 人");
                    }
                });
            });
        }
    }

    private static List<PdfStatistic> BuildStatistics(IReadOnlyList<CaseAppraise> appraises)
    {
        var rows = new List<(string FieldName, string Value)>();
        rows.AddRange(appraises.Select(x => ("介入适应症", DisplayOption(IndicationOptions, x.Indication))));
        rows.AddRange(appraises.Select(x => ("介入操作", DisplayOption(OperationOptions, x.Operation))));
        rows.AddRange(appraises.Select(x => ("设备器械配套是否齐全", DisplayOption(CompleteOptions, x.DeviceComplete))));
        rows.AddRange(appraises.Select(x => ("介入分级手术管理是否落实到位", RegistryFixedCatalog.GetYesNoName(x.SurgeryLevelImplemented))));
        rows.AddRange(appraises.Select(x => ("是否存在其他管理问题", RegistryFixedCatalog.GetYesNoName(x.HasManagementProblem))));
        rows.AddRange(appraises.Select(x => ("救治是否及时", RegistryFixedCatalog.GetYesNoName(x.RescueTimely))));
        rows.AddRange(appraises.Select(x => ("救治措施是否得当", RegistryFixedCatalog.GetYesNoName(x.RescueMeasureProper))));
        rows.AddRange(appraises.Select(x => ("救治药品设备是否齐全", DisplayOption(CompleteOptions, x.RescueDeviceComplete))));
        rows.AddRange(appraises.Select(x => ("死亡原因", DisplayOption(DeathReasonOptions, x.DeathReason))));
        rows.AddRange(appraises.Select(x => ("是否需要提交进一步改进措施", RegistryFixedCatalog.GetYesNoName(x.NeedImprovement))));

        return rows
            .Where(x => !string.IsNullOrWhiteSpace(x.Value))
            .GroupBy(x => x.FieldName)
            .Select(group => new PdfStatistic(
                group.Key,
                group.GroupBy(x => x.Value)
                    .Select(x => new PdfStatisticOption(x.Key, x.Count()))
                    .OrderByDescending(x => x.Count)
                    .ThenBy(x => x.Text)
                    .ToList()))
            .Where(x => x.Options.Count > 0)
            .ToList();
    }

    private static async Task<string?> LoadHospitalNameAsync(RegistryDbContext dbContext, string? id)
    {
        if (!Guid.TryParse(id, out var guid))
        {
            return id;
        }

        return await dbContext.SystemHospitals.AsNoTracking()
            .Where(x => x.Id == guid)
            .Select(x => x.Name)
            .FirstOrDefaultAsync();
    }

    private static async Task<string?> LoadDepartmentNameAsync(RegistryDbContext dbContext, string? id)
    {
        if (!Guid.TryParse(id, out var guid))
        {
            return id;
        }

        return await dbContext.SystemDepartments.AsNoTracking()
            .Where(x => x.Id == guid)
            .Select(x => string.IsNullOrWhiteSpace(x.DisplayName) ? x.Name : x.DisplayName)
            .FirstOrDefaultAsync();
    }

    private static async Task<string?> LoadUserNameAsync(RegistryDbContext dbContext, string? id)
    {
        if (!Guid.TryParse(id, out var guid))
        {
            return id;
        }

        return await dbContext.SystemUsers.AsNoTracking()
            .Where(x => x.Id == guid)
            .Select(x => string.IsNullOrWhiteSpace(x.DisplayName) ? x.Account : x.DisplayName)
            .FirstOrDefaultAsync();
    }

    private static async Task<Dictionary<Guid, string>> LoadUserNamesAsync(RegistryDbContext dbContext, IEnumerable<string?> ids)
    {
        var userIds = ids
            .Select(x => Guid.TryParse(x, out var id) ? id : (Guid?)null)
            .Where(x => x.HasValue)
            .Select(x => x!.Value)
            .Distinct()
            .ToList();
        return userIds.Count == 0
            ? new Dictionary<Guid, string>()
            : await dbContext.SystemUsers.AsNoTracking()
                .Where(x => userIds.Contains(x.Id))
                .ToDictionaryAsync(x => x.Id, x => string.IsNullOrWhiteSpace(x.DisplayName) ? x.Account : x.DisplayName);
    }

    private static string GetUserName(string? id, IReadOnlyDictionary<Guid, string> users)
        => Guid.TryParse(id, out var guid) && users.TryGetValue(guid, out var name) ? name : ShowValue(id);

    private static string DisplayOption(IReadOnlyList<FixedOption> options, string? value)
        => RegistryFixedCatalog.GetText(options, value);

    private static bool IsSameValue(string? left, string? right)
        => string.Equals(left?.Trim(), right?.Trim(), StringComparison.OrdinalIgnoreCase);

    private static IContainer LabelCell(IContainer container)
        => container.Border(1).BorderColor("#DDE8E3").Background("#F5F9F7").Padding(5);

    private static IContainer ValueCell(IContainer container)
        => container.Border(1).BorderColor("#DDE8E3").Padding(5);

    private static string FormatDate(DateTime? value) => value?.ToString("yyyy-MM-dd") ?? "-";

    private static string FormatDateTime(DateTime? value) => value?.ToString("yyyy-MM-dd HH:mm") ?? "-";

    private static string ShowValue(string? value) => string.IsNullOrWhiteSpace(value) ? "-" : value;

    private static string GetMeetingStatusText(int status)
        => status switch
        {
            0 => "未开始",
            1 => "已开始",
            2 => "已发布",
            3 => "已结束",
            _ => $"状态 {status}"
        };

    private static string GetQualityStatusText(int status)
        => status switch
        {
            0 => "未填报",
            1 => "已上报",
            2 => "已驳回",
            _ => $"状态 {status}"
        };

    private static string GetSubStatusText(int status)
        => status switch
        {
            0 => "待分配",
            1 => "待评审",
            2 => "已评审",
            _ => $"子状态 {status}"
        };

    private static string GetAppraiseStatusText(int status)
        => status switch
        {
            0 => "待评审",
            1 => "已评审",
            _ => $"状态 {status}"
        };

    private static string GetSummaryStatusText(int status)
        => status switch
        {
            0 => "未提交",
            1 => "已提交",
            _ => $"状态 {status}"
        };

    private static string BuildFileName(string value)
    {
        const string invalidChars = "\\/:*?\"<>|";
        var chars = value.Select(x => invalidChars.Contains(x) || char.IsControl(x) ? '_' : x).ToArray();
        return new string(chars);
    }

    private static readonly IReadOnlyList<FixedOption> IndicationOptions =
    [
        new("1", "合理"),
        new("2", "欠合理"),
        new("3", "不合理")
    ];

    private static readonly IReadOnlyList<FixedOption> OperationOptions =
    [
        new("1", "规范"),
        new("2", "欠规范"),
        new("3", "不规范"),
        new("4", "极不规范")
    ];

    private static readonly IReadOnlyList<FixedOption> CompleteOptions =
    [
        new("1", "齐全"),
        new("2", "不齐全")
    ];

    private static readonly IReadOnlyList<FixedOption> DeathReasonOptions =
    [
        new("1", "疾病相关"),
        new("2", "药物相关"),
        new("3", "操作相关"),
        new("4", "器械相关"),
        new("5", "其他")
    ];

    private sealed record PdfKeyValue(string Label, string? Value);

    private sealed record PdfFormBlock(string Name, int Sort, List<PdfFieldItem> Fields);

    private sealed record PdfFieldItem(string FieldName, string? DisplayValue, int Level, int Sort);

    private sealed record PdfStatistic(string FieldName, List<PdfStatisticOption> Options);

    private sealed record PdfStatisticOption(string Text, int Count);
}

public sealed record RegistryPdfFileResult(string FileName, byte[] Content);
