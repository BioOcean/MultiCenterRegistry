using Microsoft.EntityFrameworkCore;
using MultiCenterRegistry.Constants;
using MultiCenterRegistry.Data;
using MultiCenterRegistry.Data.Entities;

namespace MultiCenterRegistry.Services;

public sealed class RegistryBackgroundJobService(
    IDbContextFactory<RegistryDbContext> contextFactory,
    ILogger<RegistryBackgroundJobService> logger) : BackgroundService
{
    private static readonly TimeSpan Interval = TimeSpan.FromMinutes(1);
    private DateOnly? _lastQualityRunDate;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        await RunJobsAsync(stoppingToken);
        using var timer = new PeriodicTimer(Interval);
        while (await timer.WaitForNextTickAsync(stoppingToken))
        {
            await RunJobsAsync(stoppingToken);
        }
    }

    private async Task RunJobsAsync(CancellationToken stoppingToken)
    {
        try
        {
            await StartDueMeetingsAsync(stoppingToken);
            await EnsureCurrentMonthQualityReportsAsync(stoppingToken);
        }
        catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
        {
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "MCR后台任务执行失败。");
        }
    }

    private async Task StartDueMeetingsAsync(CancellationToken stoppingToken)
    {
        var now = ToDbTimestamp(DateTime.Now);
        DateTime? updatedAt = now;
        await using var dbContext = await contextFactory.CreateDbContextAsync(stoppingToken);
        await dbContext.ReviewMeetings
            .Where(x => x.Status == 0 && x.MeetingTime <= now)
            .ExecuteUpdateAsync(setters => setters
                .SetProperty(x => x.Status, 1)
                .SetProperty(x => x.UpdatedAt, updatedAt)
                .SetProperty(x => x.UpdatedBy, "system"), stoppingToken);
    }

    private async Task EnsureCurrentMonthQualityReportsAsync(CancellationToken stoppingToken)
    {
        var today = DateOnly.FromDateTime(DateTime.Now);
        if (_lastQualityRunDate == today)
        {
            return;
        }

        await using var dbContext = await contextFactory.CreateDbContextAsync(stoppingToken);
        var monthStart = ToDbTimestamp(new DateTime(today.Year, today.Month, 1));
        var nextMonth = monthStart.AddMonths(1);
        var existingRows = await dbContext.QualityReports.AsNoTracking()
            .Where(x => x.QualityDate >= monthStart && x.QualityDate < nextMonth && x.HospitalId != null && x.TemplateId != null)
            .Select(x => new { x.HospitalId, x.TemplateId })
            .ToListAsync(stoppingToken);
        var existingKeys = existingRows
            .Select(x => BuildQualityKey(x.HospitalId, x.TemplateId))
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        var hospitals = await dbContext.SystemHospitals.AsNoTracking()
            .OrderBy(x => x.Name)
            .ToListAsync(stoppingToken);
        if (hospitals.Count == 0)
        {
            _lastQualityRunDate = today;
            return;
        }

        var now = ToDbTimestamp(DateTime.Now);
        foreach (var hospital in hospitals)
        {
            foreach (var disease in RegistryFixedCatalog.Diseases)
            {
                var key = BuildQualityKey(hospital.Id.ToString(), disease.Value);
                if (existingKeys.Contains(key))
                {
                    continue;
                }

                var qualityId = Guid.NewGuid();
                dbContext.QualityReports.Add(new QualityReport
                {
                    Id = qualityId,
                    OldQualityId = $"auto-{monthStart:yyyyMM}-{hospital.Id:N}-{disease.Value}",
                    Name = $"{monthStart:yyyy年MM月}{disease.Text}质控报表",
                    QualityDate = monthStart,
                    TemplateId = disease.Value,
                    TemplateName = disease.Text,
                    HospitalId = hospital.Id.ToString(),
                    HospitalName = hospital.Name,
                    Status = 0,
                    CreatedAt = now,
                    CreatedBy = "system"
                });

                foreach (var metric in RegistryFixedCatalog.QualityMetrics)
                {
                    dbContext.QualityReportItems.Add(new QualityReportItem
                    {
                        Id = Guid.NewGuid(),
                        QualityReportId = qualityId,
                        MetricCode = metric.Code,
                        MetricName = metric.Name,
                        CategoryName = metric.CategoryName,
                        Sort = metric.Sort,
                        CreatedAt = now,
                        CreatedBy = "system"
                    });
                }

                existingKeys.Add(key);
            }
        }

        await dbContext.SaveChangesAsync(stoppingToken);
        _lastQualityRunDate = today;
    }

    private static string BuildQualityKey(string? hospitalId, string? templateId)
        => $"{hospitalId}|{templateId}";

    private static DateTime ToDbTimestamp(DateTime value)
        => DateTime.SpecifyKind(value, DateTimeKind.Unspecified);
}
