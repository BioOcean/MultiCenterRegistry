using Microsoft.EntityFrameworkCore;
using MultiCenterRegistry.Data.Entities;

namespace MultiCenterRegistry.Data;

public sealed class RegistryDbContext(DbContextOptions<RegistryDbContext> options) : DbContext(options)
{
    public const string SchemaName = "mcr";

    public DbSet<RegistryCase> Cases => Set<RegistryCase>();
    public DbSet<QualityReport> QualityReports => Set<QualityReport>();
    public DbSet<QualityReportItem> QualityReportItems => Set<QualityReportItem>();
    public DbSet<QualityReject> QualityRejects => Set<QualityReject>();
    public DbSet<ReviewMeeting> ReviewMeetings => Set<ReviewMeeting>();
    public DbSet<MeetingExpert> MeetingExperts => Set<MeetingExpert>();
    public DbSet<CaseAppraise> CaseAppraises => Set<CaseAppraise>();
    public DbSet<CaseSummary> CaseSummaries => Set<CaseSummary>();
    public DbSet<CaseVote> CaseVotes => Set<CaseVote>();
    public DbSet<CaseAdvice> CaseAdvices => Set<CaseAdvice>();
    public DbSet<OperationLog> OperationLogs => Set<OperationLog>();
    public DbSet<RegistryFile> Files => Set<RegistryFile>();
    public DbSet<RegistryArticle> Articles => Set<RegistryArticle>();
    public DbSet<PortalConfig> PortalConfigs => Set<PortalConfig>();
    public DbSet<MigrationMap> MigrationMaps => Set<MigrationMap>();
    public DbSet<SystemUser> SystemUsers => Set<SystemUser>();
    public DbSet<SystemRole> SystemRoles => Set<SystemRole>();
    public DbSet<SystemPermission> SystemPermissions => Set<SystemPermission>();
    public DbSet<SystemMapUserRole> SystemMapUserRoles => Set<SystemMapUserRole>();
    public DbSet<SystemMapRolePermission> SystemMapRolePermissions => Set<SystemMapRolePermission>();
    public DbSet<SystemUserRoleScope> SystemUserRoleScopes => Set<SystemUserRoleScope>();
    public DbSet<SystemHospital> SystemHospitals => Set<SystemHospital>();
    public DbSet<SystemDepartment> SystemDepartments => Set<SystemDepartment>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(SchemaName);

        modelBuilder.Entity<RegistryCase>().ToTable("case_record").HasKey(x => x.Id);
        modelBuilder.Entity<QualityReport>().ToTable("quality_report").HasKey(x => x.Id);
        modelBuilder.Entity<QualityReportItem>().ToTable("quality_report_item").HasKey(x => x.Id);
        modelBuilder.Entity<QualityReject>().ToTable("quality_reject").HasKey(x => x.Id);
        modelBuilder.Entity<ReviewMeeting>().ToTable("review_meeting").HasKey(x => x.Id);
        modelBuilder.Entity<MeetingExpert>().ToTable("meeting_expert").HasKey(x => x.Id);
        modelBuilder.Entity<CaseAppraise>().ToTable("case_appraise").HasKey(x => x.Id);
        modelBuilder.Entity<CaseSummary>().ToTable("case_summary").HasKey(x => x.Id);
        modelBuilder.Entity<CaseVote>().ToTable("case_vote").HasKey(x => x.Id);
        modelBuilder.Entity<CaseAdvice>().ToTable("case_advice").HasKey(x => x.Id);
        modelBuilder.Entity<OperationLog>().ToTable("operation_log").HasKey(x => x.Id);
        modelBuilder.Entity<RegistryFile>().ToTable("registry_file").HasKey(x => x.Id);
        modelBuilder.Entity<RegistryArticle>().ToTable("article").HasKey(x => x.Id);
        modelBuilder.Entity<PortalConfig>().ToTable("portal_config").HasKey(x => x.Code);
        modelBuilder.Entity<MigrationMap>().ToTable("migration_map").HasKey(x => x.Id);
        modelBuilder.Entity<SystemUser>().ToTable("sys_user", "system").HasKey(x => x.Id);
        modelBuilder.Entity<SystemRole>().ToTable("sys_role", "system").HasKey(x => x.Id);
        modelBuilder.Entity<SystemPermission>().ToTable("sys_permission", "system").HasKey(x => x.Id);
        modelBuilder.Entity<SystemMapUserRole>().ToTable("sys_map_user_role", "system").HasKey(x => new { x.UserId, x.RoleId });
        modelBuilder.Entity<SystemMapRolePermission>().ToTable("sys_map_role_permission", "system").HasKey(x => new { x.RoleId, x.PermissionId });
        modelBuilder.Entity<SystemUserRoleScope>().ToTable("sys_user_role_scope", "system").HasKey(x => x.Id);
        modelBuilder.Entity<SystemHospital>().ToTable("sys_hospital", "system").HasKey(x => x.Id);
        modelBuilder.Entity<SystemDepartment>().ToTable("sys_department", "system").HasKey(x => x.Id);

        modelBuilder.Entity<RegistryCase>().HasIndex(x => x.OldCaseId).IsUnique();
        modelBuilder.Entity<RegistryCase>().HasIndex(x => new { x.HospitalId, x.Status });
        modelBuilder.Entity<RegistryCase>().HasIndex(x => new { x.Status, x.CreatedAt });
        modelBuilder.Entity<RegistryCase>().HasIndex(x => x.DischargeTime);
        modelBuilder.Entity<RegistryCase>().HasIndex(x => x.PatientNumber);
        modelBuilder.Entity<RegistryCase>().HasIndex(x => x.PatientName);
        modelBuilder.Entity<RegistryCase>().HasIndex(x => x.OperatorId);
        modelBuilder.Entity<RegistryCase>().HasIndex(x => x.SurgeryTypeValue);
        modelBuilder.Entity<QualityReport>().HasIndex(x => x.OldQualityId).IsUnique();
        modelBuilder.Entity<QualityReport>().HasIndex(x => new { x.QualityDate, x.HospitalId, x.TemplateId });
        modelBuilder.Entity<QualityReportItem>().HasIndex(x => new { x.QualityReportId, x.Sort });
        modelBuilder.Entity<ReviewMeeting>().HasIndex(x => x.OldMeetingId).IsUnique();
        modelBuilder.Entity<MigrationMap>().HasIndex(x => new { x.SourceTable, x.SourceId }).IsUnique();
        modelBuilder.Entity<RegistryArticle>().HasIndex(x => x.OldArticleId).IsUnique().HasFilter("old_article_id is not null");
        modelBuilder.Entity<RegistryArticle>().HasIndex(x => new { x.Type, x.Status, x.CreatedAt });
        modelBuilder.Entity<MeetingExpert>().HasIndex(x => x.MeetingId);
        modelBuilder.Entity<CaseAppraise>().HasIndex(x => new { x.MeetingId, x.CaseId });
        modelBuilder.Entity<CaseSummary>().HasIndex(x => new { x.MeetingId, x.CaseId });
        modelBuilder.Entity<CaseVote>().HasIndex(x => x.SummaryId);
        modelBuilder.Entity<CaseAdvice>().HasIndex(x => new { x.CaseId, x.CreatedAt });
        modelBuilder.Entity<RegistryFile>().HasIndex(x => new { x.OwnerType, x.OwnerId });

        foreach (var entityType in modelBuilder.Model.GetEntityTypes())
        {
            foreach (var property in entityType.GetProperties())
            {
                property.SetColumnName(ToSnakeCase(property.Name));
                if (property.ClrType == typeof(DateTime) || property.ClrType == typeof(DateTime?))
                {
                    property.SetColumnType("timestamp without time zone");
                }
            }
        }
    }

    private static string ToSnakeCase(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return value;
        }

        var builder = new System.Text.StringBuilder(value.Length + 8);
        for (var i = 0; i < value.Length; i++)
        {
            var current = value[i];
            if (char.IsUpper(current))
            {
                if (i > 0)
                {
                    builder.Append('_');
                }

                builder.Append(char.ToLowerInvariant(current));
                continue;
            }

            builder.Append(current);
        }

        return builder.ToString();
    }
}
