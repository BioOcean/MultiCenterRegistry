namespace MultiCenterRegistry.Data.Entities;

public sealed class RegistryCase
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string OldCaseId { get; set; } = "";
    public string PatientName { get; set; } = "";
    public string? PatientSex { get; set; }
    public string? PatientAge { get; set; }
    public string? IdNumber { get; set; }
    public string? PatientNumber { get; set; }
    public string? DiseaseId { get; set; }
    public string? HospitalId { get; set; }
    public string? DepartmentId { get; set; }
    public string? OperatorId { get; set; }
    public DateTime? AdmissionTime { get; set; }
    public DateTime? DischargeTime { get; set; }
    public DateTime? OperationTime { get; set; }
    public int Status { get; set; }
    public int SubStatus { get; set; }
    public int Sort { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
}

public sealed class CaseFormData
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid CaseId { get; set; }
    public string FormCode { get; set; } = "";
    public string SectionCode { get; set; } = "";
    public string FieldCode { get; set; } = "";
    public string FieldName { get; set; } = "";
    public string? FieldValue { get; set; }
    public string? FieldText { get; set; }
    public int Sort { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
}

public sealed class QualityReport
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string OldQualityId { get; set; } = "";
    public string Name { get; set; } = "";
    public DateTime QualityDate { get; set; }
    public string? TemplateId { get; set; }
    public string? HospitalId { get; set; }
    public int Status { get; set; }
    public string? QualityUserId { get; set; }
    public DateTime CreatedAt { get; set; }
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

public sealed class RegistryFormTemplate
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string SourceCustomFormId { get; set; } = "";
    public string FormName { get; set; } = "";
    public string BusinessType { get; set; } = "";
    public int FieldCount { get; set; }
    public long AnswerCount { get; set; }
    public long CardCount { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }
}

public sealed class RegistryFormTemplateMap
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid FormTemplateId { get; set; }
    public string BusinessType { get; set; } = "";
    public string SourceFollowTemplateId { get; set; } = "";
    public string SourceCustomFormId { get; set; } = "";
    public string TemplateName { get; set; } = "";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public sealed class RegistryFormFieldDefinition
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid FormTemplateId { get; set; }
    public string StorageKey { get; set; } = "";
    public string SourceSubjectId { get; set; } = "";
    public string? SourceParentSubjectId { get; set; }
    public string? SourceTopSubjectId { get; set; }
    public string? SourceSubjectListId { get; set; }
    public string? SourceSubjectConfigId { get; set; }
    public string FieldCode { get; set; } = "";
    public string FieldName { get; set; } = "";
    public int? ControlType { get; set; }
    public bool? IsRequired { get; set; }
    public string? DefaultOptions { get; set; }
    public string? FixedValue { get; set; }
    public string? Format { get; set; }
    public int Sort { get; set; }
    public int Level { get; set; }
    public int Status { get; set; }
    public long AnswerCount { get; set; }
    public long NonEmptyAnswerCount { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public sealed class RegistryFormInstance
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string OwnerType { get; set; } = "";
    public Guid OwnerId { get; set; }
    public Guid FormTemplateId { get; set; }
    public Guid? FormTemplateMapId { get; set; }
    public string? SourceCardId { get; set; }
    public string? SourceCustomFormId { get; set; }
    public string? SourceFollowTemplateId { get; set; }
    public int Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
}

public sealed class RegistryFormFieldValue
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid FormInstanceId { get; set; }
    public Guid? FormFieldDefinitionId { get; set; }
    public string StorageKey { get; set; } = "";
    public string? SourceAnswerId { get; set; }
    public string? SourceSubjectId { get; set; }
    public string FieldCode { get; set; } = "";
    public string FieldName { get; set; } = "";
    public string? FieldValue { get; set; }
    public string? FieldText { get; set; }
    public int Sort { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? CreatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
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
