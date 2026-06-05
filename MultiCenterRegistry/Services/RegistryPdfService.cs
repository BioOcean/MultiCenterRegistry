using Microsoft.EntityFrameworkCore;
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

        var templateName = await dbContext.FormTemplateMaps.AsNoTracking()
            .Where(x => x.BusinessType == "quality" && x.SourceFollowTemplateId == quality.TemplateId)
            .OrderBy(x => x.TemplateName)
            .Select(x => x.TemplateName)
            .FirstOrDefaultAsync();
        var hospitalName = await LoadHospitalNameAsync(dbContext, quality.HospitalId);
        var userName = await LoadUserNameAsync(dbContext, quality.QualityUserId);
        var rejects = await dbContext.QualityRejects.AsNoTracking()
            .Where(x => x.QualityReportId == qualityId)
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();
        var forms = await LoadFormsAsync(dbContext, "quality", [qualityId]);

        var bytes = BuildPdf(quality.Name, $"质控月份：{quality.QualityDate:yyyy-MM}", column =>
        {
            AddSectionTitle(column, "基本信息");
            column.Item().Element(container => ComposeKeyValues(container,
            [
                new("报表名称", quality.Name),
                new("质控月份", quality.QualityDate.ToString("yyyy-MM")),
                new("疾病类型", templateName ?? quality.TemplateId),
                new("医院", hospitalName ?? quality.HospitalId),
                new("质控员", userName ?? quality.QualityUserId),
                new("状态", GetQualityStatusText(quality.Status)),
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

            AddSectionTitle(column, "质控表单");
            ComposeForms(column, forms);
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

        var hospitalName = await LoadHospitalNameAsync(dbContext, registryCase.HospitalId);
        var departmentName = await LoadDepartmentNameAsync(dbContext, registryCase.DepartmentId);
        var diseaseName = await dbContext.FormTemplateMaps.AsNoTracking()
            .Where(x => x.BusinessType == "case" && x.SourceFollowTemplateId == registryCase.DiseaseId)
            .OrderBy(x => x.TemplateName)
            .Select(x => x.TemplateName)
            .FirstOrDefaultAsync();

        var appraises = await dbContext.CaseAppraises.AsNoTracking()
            .Where(x => x.MeetingId == meetingId && x.CaseId == caseId)
            .OrderBy(x => x.Status)
            .ThenBy(x => x.CreatedAt)
            .ToListAsync();
        var appraiseIds = appraises.Select(x => x.Id).ToList();
        var userNames = await LoadUserNamesAsync(dbContext, appraises.Select(x => x.ExpertId));
        var caseForms = await LoadFormsAsync(dbContext, "case", [caseId]);
        var appraiseForms = appraiseIds.Count == 0
            ? new List<PdfFormBlock>()
            : await LoadFormsAsync(dbContext, "appraise", appraiseIds);
        var appraiseFormsByOwner = appraiseForms
            .GroupBy(x => x.OwnerId)
            .ToDictionary(x => x.Key, x => x.ToList());
        var summaries = await dbContext.CaseSummaries.AsNoTracking()
            .Where(x => x.MeetingId == meetingId && x.CaseId == caseId)
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();
        var votes = await dbContext.CaseVotes.AsNoTracking()
            .Where(x => x.MeetingId == meetingId && x.CaseId == caseId)
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();
        var statistics = BuildStatistics(appraiseForms);

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
                new("会议状态", meeting.Status.ToString())
            ]));

            AddSectionTitle(column, "病例信息");
            column.Item().Element(container => ComposeKeyValues(container,
            [
                new("姓名", registryCase.PatientName),
                new("性别", registryCase.PatientSex),
                new("年龄", registryCase.PatientAge),
                new("病案号", registryCase.PatientNumber),
                new("疾病类型", diseaseName ?? registryCase.DiseaseId),
                new("医院", hospitalName ?? registryCase.HospitalId),
                new("科室", departmentName ?? registryCase.DepartmentId),
                new("入院时间", FormatDate(registryCase.AdmissionTime)),
                new("出院时间", FormatDate(registryCase.DischargeTime)),
                new("手术时间", FormatDate(registryCase.OperationTime)),
                new("评审状态", GetSubStatusText(registryCase.SubStatus))
            ]));

            AddSectionTitle(column, "病例对照");
            ComposeForms(column, caseForms);

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
                    if (appraiseFormsByOwner.TryGetValue(appraise.Id, out var forms))
                    {
                        ComposeForms(column, forms);
                    }
                    else
                    {
                        AddEmptyLine(column, "该专家暂无评审表单数据");
                    }
                }
            }

            if (votes.Count > 0)
            {
                AddSectionTitle(column, "投票记录");
                column.Item().Element(container => ComposeVotes(container, votes));
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

    private static async Task<List<PdfFormBlock>> LoadFormsAsync(RegistryDbContext dbContext, string ownerType, IReadOnlyCollection<Guid> ownerIds)
    {
        if (ownerIds.Count == 0)
        {
            return [];
        }

        var instances = await dbContext.FormInstances.AsNoTracking()
            .Where(x => x.OwnerType == ownerType && ownerIds.Contains(x.OwnerId))
            .OrderBy(x => x.CreatedAt)
            .ToListAsync();
        var instanceIds = instances.Select(x => x.Id).ToList();
        if (instanceIds.Count == 0)
        {
            return [];
        }

        var templateIds = instances.Select(x => x.FormTemplateId).Distinct().ToList();
        var templates = await dbContext.FormTemplates.AsNoTracking()
            .Where(x => templateIds.Contains(x.Id))
            .ToDictionaryAsync(x => x.Id);
        var values = await dbContext.FormFieldValues.AsNoTracking()
            .Where(x => instanceIds.Contains(x.FormInstanceId))
            .OrderBy(x => x.Sort)
            .ThenBy(x => x.StorageKey)
            .ToListAsync();
        var definitionIds = values
            .Where(x => x.FormFieldDefinitionId.HasValue)
            .Select(x => x.FormFieldDefinitionId!.Value)
            .Distinct()
            .ToList();
        var definitions = definitionIds.Count == 0
            ? new Dictionary<Guid, RegistryFormFieldDefinition>()
            : await dbContext.FormFieldDefinitions.AsNoTracking()
                .Where(x => definitionIds.Contains(x.Id))
                .ToDictionaryAsync(x => x.Id);
        var valueIds = values.Select(x => x.Id).ToList();
        var files = valueIds.Count == 0
            ? new List<RegistryFile>()
            : await dbContext.Files.AsNoTracking()
                .Where(x => x.OwnerType == "form_field_value" && valueIds.Contains(x.OwnerId))
                .OrderBy(x => x.CreatedAt)
                .ThenBy(x => x.FileName)
                .ToListAsync();
        var filesByValue = files
            .GroupBy(x => x.OwnerId)
            .ToDictionary(x => x.Key, x => x.ToList());

        return instances.Select(instance =>
        {
            var fields = values
                .Where(x => x.FormInstanceId == instance.Id)
                .Select(value => CreateField(value, definitions, filesByValue))
                .ToList();
            var name = templates.TryGetValue(instance.FormTemplateId, out var template) ? template.FormName : "表单";
            return new PdfFormBlock(instance.OwnerId, name, instance.CreatedAt, fields);
        }).ToList();
    }

    private static PdfFieldItem CreateField(
        RegistryFormFieldValue value,
        IReadOnlyDictionary<Guid, RegistryFormFieldDefinition> definitions,
        IReadOnlyDictionary<Guid, List<RegistryFile>> filesByValue)
    {
        RegistryFormFieldDefinition? definition = null;
        if (value.FormFieldDefinitionId.HasValue)
        {
            definitions.TryGetValue(value.FormFieldDefinitionId.Value, out definition);
        }

        filesByValue.TryGetValue(value.Id, out var files);
        var fileNames = files?.Select(x => x.FileName).Where(x => !string.IsNullOrWhiteSpace(x)).ToList() ?? new List<string>();
        var displayValue = FormValueDisplayMapper.GetDisplayText(value.FieldName, value.FieldText, value.FieldValue);
        if (fileNames.Count > 0)
        {
            var fileText = $"附件：{string.Join("；", fileNames)}";
            displayValue = string.IsNullOrWhiteSpace(displayValue) ? fileText : $"{displayValue}\n{fileText}";
        }

        return new PdfFieldItem(
            value.FieldName,
            ShowValue(displayValue),
            definition?.Level ?? 2,
            value.Sort);
    }

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
            column.Item().PaddingTop(8).Text($"{form.Name}（创建时间 {FormatDateTime(form.CreatedAt)}）")
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
                if (field.IsSection)
                {
                    table.Cell().ColumnSpan(2).Element(SectionCell).Text(field.FieldName).SemiBold();
                    continue;
                }

                table.Cell().Element(LabelCell).Text(field.FieldName);
                table.Cell().Element(ValueCell).Text(field.DisplayValue);
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

    private static void ComposeVotes(IContainer container, IReadOnlyList<CaseVote> votes)
    {
        container.Table(table =>
        {
            table.ColumnsDefinition(columns =>
            {
                columns.ConstantColumn(100);
                columns.ConstantColumn(60);
                columns.RelativeColumn();
            });

            foreach (var vote in votes)
            {
                table.Cell().Element(LabelCell).Text(ShowValue(vote.ExpertName));
                table.Cell().Element(LabelCell).Text(vote.Agreed ? "同意" : "不同意");
                table.Cell().Element(ValueCell).Text(ShowValue(vote.Content));
            }
        });
    }

    private static List<PdfStatistic> BuildStatistics(IEnumerable<PdfFormBlock> forms)
        => forms
            .SelectMany(x => x.Fields)
            .Where(x => !x.IsSection && !string.IsNullOrWhiteSpace(x.DisplayValue) && x.DisplayValue != "-")
            .GroupBy(x => x.FieldName)
            .Select(group => new
            {
                FieldName = group.Key,
                Sort = group.Min(x => x.Sort),
                Options = group
                    .GroupBy(x => x.DisplayValue.Trim())
                    .Select(x => new PdfStatisticOption(x.Key, x.Count()))
                    .OrderByDescending(x => x.Count)
                    .ThenBy(x => x.Text)
                    .Take(8)
                    .ToList()
            })
            .Where(x => x.Options.Count > 0)
            .OrderBy(x => x.Sort)
            .ThenBy(x => x.FieldName)
            .Take(80)
            .Select(x => new PdfStatistic(x.FieldName, x.Options))
            .ToList();

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

    private static IContainer LabelCell(IContainer container)
        => container.Border(1).BorderColor("#DDE8E3").Background("#F5F9F7").Padding(5);

    private static IContainer ValueCell(IContainer container)
        => container.Border(1).BorderColor("#DDE8E3").Padding(5);

    private static IContainer SectionCell(IContainer container)
        => container.Border(1).BorderColor("#DDE8E3").Background("#EAF4F0").Padding(6);

    private static string FormatDate(DateTime? value) => value?.ToString("yyyy-MM-dd") ?? "-";

    private static string FormatDateTime(DateTime? value) => value?.ToString("yyyy-MM-dd HH:mm") ?? "-";

    private static string ShowValue(string? value) => string.IsNullOrWhiteSpace(value) ? "-" : value;

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

    private sealed record PdfKeyValue(string Label, string? Value);

    private sealed record PdfFormBlock(Guid OwnerId, string Name, DateTime CreatedAt, List<PdfFieldItem> Fields);

    private sealed record PdfFieldItem(string FieldName, string DisplayValue, int Level, int Sort)
    {
        public bool IsSection => Level <= 1;
    }

    private sealed record PdfStatistic(string FieldName, List<PdfStatisticOption> Options);

    private sealed record PdfStatisticOption(string Text, int Count);
}

public sealed record RegistryPdfFileResult(string FileName, byte[] Content);
