namespace MultiCenterRegistry.Data.Entities;

public sealed class RegistryCase
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string OldCaseId { get; set; } = "";
    public string PatientName { get; set; } = "";
    public string? PatientSex { get; set; }
    public string? PatientSexText { get; set; }
    public string? PatientAge { get; set; }
    public string? IdNumber { get; set; }
    public string? PatientNumber { get; set; }
    public string? DiseaseId { get; set; }
    public string? DiseaseName { get; set; }
    public string? HospitalId { get; set; }
    public string? HospitalName { get; set; }
    public string? DepartmentId { get; set; }
    public string? DepartmentName { get; set; }
    public string? OperatorId { get; set; }
    public string? OperatorName { get; set; }
    public DateTime? AdmissionTime { get; set; }
    public DateTime? DischargeTime { get; set; }
    public DateTime? OperationTime { get; set; }
    public int? HospitalStayDays { get; set; }
    public string? SurgeryTypeValue { get; set; }
    public string? SurgeryTypeText { get; set; }
    public string? CoronaryIntervention { get; set; }
    public string? AblationIntervention { get; set; }
    public string? StructuralIntervention { get; set; }
    public string? IsEmergencyIntervention { get; set; }
    public string? DischargeMode { get; set; }
    public string? SituationReason { get; set; }
    public string? SituationSupplement { get; set; }
    public DateTime? DeathTime { get; set; }
    public string? CaseSummary { get; set; }
    public string? DischargeDiagnosis { get; set; }
    public string? OtherExam { get; set; }
    public string? AngiographyResult { get; set; }
    public string? InterventionProcess { get; set; }
    public string? RescueProcess { get; set; }
    public string? ComplicationDiscussion { get; set; }
    public string? OccurrenceReason { get; set; }
    public string? DeathReason { get; set; }
    public string? LessonsLearned { get; set; }
    public string? ImprovementMeasures { get; set; }
    public int Status { get; set; }
    public int SubStatus { get; set; }
    public int Sort { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
}

public sealed class QualityReport
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string OldQualityId { get; set; } = "";
    public string Name { get; set; } = "";
    public DateTime QualityDate { get; set; }
    public string? TemplateId { get; set; }
    public string? TemplateName { get; set; }
    public string? HospitalId { get; set; }
    public string? HospitalName { get; set; }
    public int Status { get; set; }
    public string? QualityUserId { get; set; }
    public string? QualityUserName { get; set; }
    public DateTime? SubmittedAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
}

public sealed class QualityReportItem
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid QualityReportId { get; set; }
    public string MetricCode { get; set; } = "";
    public string MetricName { get; set; } = "";
    public string? CategoryName { get; set; }
    public int? CaseCount { get; set; }
    public int Sort { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.Now;
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
}

public sealed class QualityReject
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid QualityReportId { get; set; }
    public string Content { get; set; } = "";
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
}

public sealed class ReviewMeeting
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string OldMeetingId { get; set; } = "";
    public string Title { get; set; } = "";
    public string? Description { get; set; }
    public string? GroupInfo { get; set; }
    public string? Place { get; set; }
    public DateTime MeetingTime { get; set; }
    public DateTime? EndTime { get; set; }
    public int Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
}

public sealed class MeetingExpert
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid MeetingId { get; set; }
    public string ExpertId { get; set; } = "";
    public int Level { get; set; }
}

public sealed class CaseAppraise
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid MeetingId { get; set; }
    public Guid CaseId { get; set; }
    public string ExpertId { get; set; } = "";
    public int Status { get; set; }
    public string? Indication { get; set; }
    public string? Operation { get; set; }
    public string? DeviceComplete { get; set; }
    public string? SurgeryLevelImplemented { get; set; }
    public string? HasManagementProblem { get; set; }
    public string? ManagementProblemDescription { get; set; }
    public string? RescueTimely { get; set; }
    public string? RescueMeasureProper { get; set; }
    public string? RescueDeviceComplete { get; set; }
    public string? DeathReason { get; set; }
    public string? OtherDeathReason { get; set; }
    public string? NeedImprovement { get; set; }
    public string? ImprovementContent { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
}

public sealed class CaseSummary
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid MeetingId { get; set; }
    public Guid CaseId { get; set; }
    public string Content { get; set; } = "";
    public int Status { get; set; }
    public string? ExpertName { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
}

public sealed class CaseVote
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid MeetingId { get; set; }
    public Guid CaseId { get; set; }
    public Guid SummaryId { get; set; }
    public bool Agreed { get; set; }
    public string? Content { get; set; }
    public string? ExpertName { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
}

public sealed class CaseAdvice
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid CaseId { get; set; }
    public int AdviceType { get; set; }
    public string Content { get; set; } = "";
    public DateTime CreatedAt { get; set; } = DateTime.Now;
    public string? CreatedBy { get; set; }
}

public sealed class OperationLog
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string Module { get; set; } = "";
    public string Action { get; set; } = "";
    public string OwnerType { get; set; } = "";
    public Guid OwnerId { get; set; }
    public string? Content { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.Now;
    public string? CreatedBy { get; set; }
}

public sealed class RegistryFile
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string OwnerType { get; set; } = "";
    public Guid OwnerId { get; set; }
    public string FileName { get; set; } = "";
    public string FilePath { get; set; } = "";
    public string? ContentType { get; set; }
    public long? FileSize { get; set; }
    public string? Remark { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
}

public sealed class RegistryArticle
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string? OldArticleId { get; set; }
    public string? TopicId { get; set; }
    public int Type { get; set; }
    public int Status { get; set; }
    public string Title { get; set; } = "";
    public string Content { get; set; } = "";
    public string? Cover { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.Now;
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
}

public sealed class PortalConfig
{
    public string Code { get; set; } = "";
    public string? Title { get; set; }
    public string Value { get; set; } = "";
    public DateTime UpdatedAt { get; set; } = DateTime.Now;
    public string? UpdatedBy { get; set; }
}

public sealed class MigrationMap
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string SourceTable { get; set; } = "";
    public string SourceId { get; set; } = "";
    public string TargetTable { get; set; } = "";
    public Guid TargetId { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public sealed class SystemUser
{
    public Guid Id { get; set; }
    public string Account { get; set; } = "";
    public string Password { get; set; } = "";
    public string DisplayName { get; set; } = "";
    public string? Email { get; set; }
    public bool CanGrantToOther { get; set; }
    public bool IsValid { get; set; }
    public bool MustChangePassword { get; set; }
    public string? SourceType { get; set; }
}

public sealed class SystemPermission
{
    public Guid Id { get; set; }
    public string? Code { get; set; }
    public string Name { get; set; } = "";
    public string? Describe { get; set; }
    public string? Type { get; set; }
}

public sealed class SystemRole
{
    public Guid Id { get; set; }
    public string Name { get; set; } = "";
    public string? Describe { get; set; }
    public string? Type { get; set; }
    public bool IsValid { get; set; }
    public Guid? OwnerUserId { get; set; }
}

public sealed class SystemMapUserRole
{
    public Guid UserId { get; set; }
    public Guid RoleId { get; set; }
}

public sealed class SystemMapRolePermission
{
    public Guid RoleId { get; set; }
    public Guid PermissionId { get; set; }
}

public sealed class SystemUserRoleScope
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid UserId { get; set; }
    public Guid RoleId { get; set; }
    public Guid HospitalId { get; set; }
    public string HospitalName { get; set; } = "";
    public Guid? DepartmentId { get; set; }
    public string? DepartmentName { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public sealed class SystemHospital
{
    public Guid Id { get; set; }
    public string Name { get; set; } = "";
}

public sealed class SystemDepartment
{
    public Guid Id { get; set; }
    public Guid HospitalId { get; set; }
    public string Name { get; set; } = "";
    public string? DisplayName { get; set; }
}
