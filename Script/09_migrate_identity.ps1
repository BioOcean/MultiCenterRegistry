param(
    [string]$SourceConnection = $env:MCR_SOURCE_SQLSERVER,
    [string]$TargetConfigPath = "./MultiCenterRegistry/appsettings.json",
    [string]$OutputDirectory = "./Script/output/identity_migration",
    [string]$TemporaryPassword = "123456",
    [switch]$Export,
    [switch]$Execute,
    [switch]$PlanOnly
)

$ErrorActionPreference = "Stop"

if ($PlanOnly -or (-not $Export -and -not $Execute)) {
    Write-Host "身份数据迁移脚本计划："
    Write-Host "1. 读取旧库医院、科室、用户、角色、MCR 功能权限和映射。"
    Write-Host "2. 使用 Bio.Core PasswordHasher 生成统一临时密码哈希，用户首次登录必须修改。"
    Write-Host "3. 生成 CSV 和 09_import_identity.sql。"
    Write-Host "4. 指定 -Execute 时才调用 psql 写入 system 和 mcr.migration_map。"
    return
}

if ([string]::IsNullOrWhiteSpace($SourceConnection)) {
    throw "请先通过环境变量 MCR_SOURCE_SQLSERVER 或参数 SourceConnection 提供旧库连接字符串。"
}

function ConvertTo-StableGuid {
    param([string]$Value)

    $md5 = [System.Security.Cryptography.MD5]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
        $hash = $md5.ComputeHash($bytes)
        return [Guid]::new($hash).ToString()
    } finally {
        $md5.Dispose()
    }
}

function Get-DbValue {
    param(
        [System.Data.DataRow]$Row,
        [string]$Name
    )

    $value = $Row[$Name]
    if ($value -is [System.DBNull]) {
        return ""
    }

    return [string]$value
}

function Get-BoolText {
    param([bool]$Value)

    if ($Value) {
        return "true"
    }

    return "false"
}

function Invoke-SourceQuery {
    param(
        [object]$Connection,
        [string]$Sql
    )

    $command = $Connection.CreateCommand()
    $command.CommandText = $Sql
    $command.CommandTimeout = 300
    $reader = $command.ExecuteReader()
    $table = New-Object System.Data.DataTable
    $table.Load($reader)
    return ,$table
}

function ConvertTo-SqlText {
    param([string]$Value)

    return "'" + $Value.Replace("'", "''") + "'"
}

function ConvertTo-ImportPath {
    param([string]$Path)

    return (Resolve-Path $Path).Path.Replace("\", "/")
}

function Get-TemporaryPasswordHash {
    param([string]$Password)

    $toolProject = Resolve-Path "./Script/tools/PasswordHashTool/PasswordHashTool.csproj"
    $toolDirectory = Split-Path -Parent $toolProject.Path
    $toolDll = Join-Path $toolDirectory "bin/Debug/net10.0/PasswordHashTool.dll"

    if (-not (Test-Path $toolDll)) {
        & dotnet build $toolProject.Path | Out-Host
        if ($LASTEXITCODE -ne 0) {
            throw "PasswordHashTool 编译失败。"
        }
    }

    $hash = (& dotnet $toolDll $Password | Select-Object -First 1)
    if (($null -ne $LASTEXITCODE -and $LASTEXITCODE -ne 0) -or [string]::IsNullOrWhiteSpace($hash)) {
        throw "临时密码哈希生成失败。"
    }

    return $hash.Trim()
}

function Write-ImportSql {
    param(
        [string]$Path,
        [string]$HospitalCsv,
        [string]$DepartmentCsv,
        [string]$UserCsv,
        [string]$RoleCsv,
        [string]$PermissionCsv,
        [string]$RolePermissionCsv,
        [string]$UserRoleCsv,
        [string]$QualityUserMapCsv
    )

    $hospitalPath = ConvertTo-SqlText (ConvertTo-ImportPath $HospitalCsv)
    $departmentPath = ConvertTo-SqlText (ConvertTo-ImportPath $DepartmentCsv)
    $userPath = ConvertTo-SqlText (ConvertTo-ImportPath $UserCsv)
    $rolePath = ConvertTo-SqlText (ConvertTo-ImportPath $RoleCsv)
    $permissionPath = ConvertTo-SqlText (ConvertTo-ImportPath $PermissionCsv)
    $rolePermissionPath = ConvertTo-SqlText (ConvertTo-ImportPath $RolePermissionCsv)
    $userRolePath = ConvertTo-SqlText (ConvertTo-ImportPath $UserRoleCsv)
    $qualityUserMapPath = ConvertTo-SqlText (ConvertTo-ImportPath $QualityUserMapCsv)

    $sql = @"
set temp_buffers = '512MB';
begin;

create or replace function pg_temp.tmp_stable_uuid(value text)
returns uuid
language sql
immutable
as `$func`$
select (
    substr(md5(value), 1, 8) || '-' ||
    substr(md5(value), 9, 4) || '-' ||
    substr(md5(value), 13, 4) || '-' ||
    substr(md5(value), 17, 4) || '-' ||
    substr(md5(value), 21, 12)
)::uuid;
`$func`$;

create temp table tmp_hospital (
    id text, old_id text, name text, scan_code_msg text
);
\copy tmp_hospital from $hospitalPath with (format csv, header true);

insert into system.sys_hospital as target (id, name, "oldHistoryID", scan_code_msg)
select old_id::uuid, coalesce(nullif(name, ''), '未命名医院'), old_id, nullif(scan_code_msg, '')
from tmp_hospital h
where not exists (
    select 1 from system.sys_hospital sh where sh."oldHistoryID" = h.old_id
)
on conflict (id) do update set
    name = excluded.name,
    "oldHistoryID" = coalesce(target."oldHistoryID", excluded."oldHistoryID"),
    scan_code_msg = coalesce(excluded.scan_code_msg, target.scan_code_msg);

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select
    pg_temp.tmp_stable_uuid('MCR_Hospital:' || h.old_id),
    'MCR_Hospital',
    h.old_id,
    'system.sys_hospital',
    sh.id,
    now()
from tmp_hospital h
join system.sys_hospital sh on sh."oldHistoryID" = h.old_id or sh.id::text = h.old_id
on conflict (source_table, source_id) do update set
    target_table = excluded.target_table,
    target_id = excluded.target_id;

create temp table tmp_department (
    id text, old_id text, old_hospital_id text, name text, display_name text, scan_code_msg text
);
\copy tmp_department from $departmentPath with (format csv, header true);

insert into system.sys_department as target (id, hospital_id, name, display_name, "oldDepartmentID", scan_code_msg)
select
    d.old_id::uuid,
    hm.target_id,
    coalesce(nullif(d.name, ''), '未命名科室'),
    coalesce(nullif(d.display_name, ''), nullif(d.name, ''), '未命名科室'),
    d.old_id,
    nullif(d.scan_code_msg, '')
from tmp_department d
join mcr.migration_map hm on hm.source_table = 'MCR_Hospital' and hm.source_id = d.old_hospital_id
where not exists (
    select 1 from system.sys_department sd where sd."oldDepartmentID" = d.old_id
)
on conflict (id) do update set
    hospital_id = excluded.hospital_id,
    name = excluded.name,
    display_name = excluded.display_name,
    "oldDepartmentID" = coalesce(target."oldDepartmentID", excluded."oldDepartmentID"),
    scan_code_msg = coalesce(excluded.scan_code_msg, target.scan_code_msg);

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select
    pg_temp.tmp_stable_uuid('MCR_Department:' || d.old_id),
    'MCR_Department',
    d.old_id,
    'system.sys_department',
    sd.id,
    now()
from tmp_department d
join system.sys_department sd on sd."oldDepartmentID" = d.old_id or sd.id::text = d.old_id
on conflict (source_table, source_id) do update set
    target_table = excluded.target_table,
    target_id = excluded.target_id;

create temp table tmp_user (
    id text, old_id text, account text, password_hash text, display_name text,
    email text, is_valid text, must_change_password text, source_type text, old_hospital_id text, old_department_id text
);
\copy tmp_user from $userPath with (format csv, header true);

create temp table tmp_user_resolved as
select
    u.*,
    coalesce(mapped.target_id, existing_user.id, u.old_id::uuid) as target_id
from tmp_user u
left join mcr.migration_map mapped
    on mapped.source_table = 'MCR_User' and mapped.source_id = u.old_id
left join lateral (
    select su.id
    from system.sys_user su
    where lower(su.account) = lower(u.account)
    order by case when su.source_type = 'mcr' then 0 else 1 end, su.id::text
    limit 1
) existing_user on true;

insert into system.sys_user (
    id, account, password, display_name, email, can_grant_to_other, is_valid, must_change_password, source_type
)
select
    target_id,
    account,
    password_hash,
    coalesce(nullif(display_name, ''), account),
    nullif(email, ''),
    false,
    coalesce(nullif(is_valid, '')::boolean, false),
    coalesce(nullif(must_change_password, '')::boolean, true),
    'mcr'
from tmp_user_resolved u
where not exists (select 1 from system.sys_user su where su.id = u.target_id)
  and not exists (select 1 from system.sys_user su where lower(su.account) = lower(u.account))
on conflict (id) do nothing;

update system.sys_user su
set display_name = coalesce(nullif(u.display_name, ''), u.account),
    email = nullif(u.email, ''),
    is_valid = coalesce(nullif(u.is_valid, '')::boolean, false),
    must_change_password = true,
    source_type = 'mcr'
from tmp_user_resolved u
where su.id = u.target_id
  and su.source_type = 'mcr';

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select
    pg_temp.tmp_stable_uuid('MCR_User:' || old_id),
    'MCR_User',
    old_id,
    'system.sys_user',
    target_id,
    now()
from tmp_user_resolved
on conflict (source_table, source_id) do update set
    target_table = excluded.target_table,
    target_id = excluded.target_id;

create temp table tmp_role (
    id text, old_id text, name text, describe text, type text, is_valid text
);
\copy tmp_role from $rolePath with (format csv, header true);

insert into system.sys_role (id, name, describe, type, is_valid)
select
    old_id::uuid,
    coalesce(nullif(name, ''), '未命名角色'),
    coalesce(nullif(describe, ''), nullif(name, ''), '未命名角色'),
    'MCR',
    coalesce(nullif(is_valid, '')::boolean, true)
from tmp_role
on conflict (id) do update set
    name = excluded.name,
    describe = excluded.describe,
    type = excluded.type,
    is_valid = excluded.is_valid;

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select
    pg_temp.tmp_stable_uuid('MCR_Role:' || old_id),
    'MCR_Role',
    old_id,
    'system.sys_role',
    old_id::uuid,
    now()
from tmp_role
on conflict (source_table, source_id) do update set
    target_table = excluded.target_table,
    target_id = excluded.target_id;

create temp table tmp_permission (
    id text, old_id text, name text, describe text, type text, code text
);
\copy tmp_permission from $permissionPath with (format csv, header true);

create temp table tmp_permission_resolved as
select
    p.*,
    coalesce(mapped.target_id, existing_permission.id, p.old_id::uuid) as target_id
from tmp_permission p
left join mcr.migration_map mapped
    on mapped.source_table = 'MCR_FunctionPower' and mapped.source_id = p.old_id
left join lateral (
    select sp.id
    from system.sys_permission sp
    where sp.code = p.code
    order by case when sp.type = 'MCR' then 0 else 1 end, sp.id::text
    limit 1
) existing_permission on true;

insert into system.sys_permission (id, name, describe, type, code)
select
    target_id,
    coalesce(nullif(name, ''), code),
    coalesce(nullif(describe, ''), nullif(name, ''), code),
    'MCR',
    code
from tmp_permission_resolved
where not exists (select 1 from system.sys_permission sp where sp.id = target_id)
on conflict (id) do update set
    name = excluded.name,
    describe = excluded.describe,
    type = excluded.type,
    code = excluded.code;

insert into mcr.migration_map (id, source_table, source_id, target_table, target_id, created_at)
select
    pg_temp.tmp_stable_uuid('MCR_FunctionPower:' || old_id),
    'MCR_FunctionPower',
    old_id,
    'system.sys_permission',
    target_id,
    now()
from tmp_permission_resolved
on conflict (source_table, source_id) do update set
    target_table = excluded.target_table,
    target_id = excluded.target_id;

create temp table tmp_role_permission (
    role_old_id text, permission_old_id text
);
\copy tmp_role_permission from $rolePermissionPath with (format csv, header true);

insert into system.sys_map_role_permission (role_id, permission_id)
select distinct rm.target_id, pm.target_id
from tmp_role_permission rp
join mcr.migration_map rm on rm.source_table = 'MCR_Role' and rm.source_id = rp.role_old_id
join mcr.migration_map pm on pm.source_table = 'MCR_FunctionPower' and pm.source_id = rp.permission_old_id
on conflict (role_id, permission_id) do nothing;

create temp table tmp_user_role (
    user_old_id text, role_old_id text, old_hospital_id text, old_department_id text, scope_id text
);
\copy tmp_user_role from $userRolePath with (format csv, header true);

insert into system.sys_map_user_role (user_id, role_id)
select distinct um.target_id, rm.target_id
from tmp_user_role ur
join mcr.migration_map um on um.source_table = 'MCR_User' and um.source_id = ur.user_old_id
join mcr.migration_map rm on rm.source_table = 'MCR_Role' and rm.source_id = ur.role_old_id
on conflict (user_id, role_id) do nothing;

insert into system.sys_user_role_scope (
    id, user_id, role_id, hospital_id, hospital_name, department_id, department_name, created_at
)
select distinct
    ur.scope_id::uuid,
    um.target_id,
    rm.target_id,
    hm.target_id,
    h.name,
    dm.target_id,
    d.name,
    now()
from tmp_user_role ur
join mcr.migration_map um on um.source_table = 'MCR_User' and um.source_id = ur.user_old_id
join mcr.migration_map rm on rm.source_table = 'MCR_Role' and rm.source_id = ur.role_old_id
join mcr.migration_map hm on hm.source_table = 'MCR_Hospital' and hm.source_id = ur.old_hospital_id
join system.sys_hospital h on h.id = hm.target_id
left join mcr.migration_map dm on dm.source_table = 'MCR_Department' and dm.source_id = nullif(ur.old_department_id, '')
left join system.sys_department d on d.id = dm.target_id
where nullif(ur.old_hospital_id, '') is not null
on conflict do nothing;

create temp table tmp_quality_user_map (
    old_quality_id text, user_old_id text
);
\copy tmp_quality_user_map from $qualityUserMapPath with (format csv, header true);

update mcr.quality_report q set quality_user_id = um.target_id::text
from tmp_quality_user_map qum
join mcr.migration_map um on um.source_table = 'MCR_User' and lower(um.source_id) = lower(qum.user_old_id)
where lower(q.old_quality_id) = lower(qum.old_quality_id);

update mcr.case_record c set hospital_id = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_Hospital' and lower(c.hospital_id) = lower(m.source_id);

update mcr.case_record c set department_id = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_Department' and lower(c.department_id) = lower(m.source_id);

update mcr.case_record c set operator_id = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(c.operator_id) = lower(m.source_id);

update mcr.case_record c set created_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(c.created_by) = lower(m.source_id);

update mcr.case_record c set updated_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(c.updated_by) = lower(m.source_id);

update mcr.quality_report q set hospital_id = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_Hospital' and lower(q.hospital_id) = lower(m.source_id);

update mcr.quality_report q set quality_user_id = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(q.quality_user_id) = lower(m.source_id);

update mcr.quality_report q set created_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(q.created_by) = lower(m.source_id);

update mcr.quality_reject q set created_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(q.created_by) = lower(m.source_id);

update mcr.review_meeting r set created_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(r.created_by) = lower(m.source_id);

update mcr.meeting_expert e set expert_id = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(e.expert_id) = lower(m.source_id);

update mcr.case_appraise a set expert_id = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(a.expert_id) = lower(m.source_id);

update mcr.case_summary s set created_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(s.created_by) = lower(m.source_id);

update mcr.case_vote v set created_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(v.created_by) = lower(m.source_id);

update mcr.form_instance f set created_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(f.created_by) = lower(m.source_id);

update mcr.form_instance f set updated_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(f.updated_by) = lower(m.source_id);

update mcr.form_field_value f set created_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(f.created_by) = lower(m.source_id);

update mcr.form_field_value f set updated_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(f.updated_by) = lower(m.source_id);

update mcr.case_form_data f set created_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(f.created_by) = lower(m.source_id);

update mcr.registry_file f set created_by = m.target_id::text
from mcr.migration_map m
where m.source_table = 'MCR_User' and lower(f.created_by) = lower(m.source_id);

commit;
"@

    [System.IO.File]::WriteAllText($Path, $sql, [System.Text.UTF8Encoding]::new($true))
}

function Invoke-PsqlFile {
    param(
        [string]$ConfigPath,
        [string]$SqlPath
    )

    $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    $connectionString = $config.ConnectionStrings.DefaultConnection
    $parts = @{}
    $connectionString -split ";" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
        $kv = $_.Split("=", 2)
        $parts[$kv[0].Trim()] = $kv[1].Trim()
    }

    $hostParts = $parts.Host.Split(":", 2)
    $env:PGPASSWORD = $parts.Password
    & psql -v ON_ERROR_STOP=1 -h $hostParts[0] -p $hostParts[1] -U $parts.Username -d $parts.Database -f $SqlPath
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

try {
    Add-Type -AssemblyName "Microsoft.Data.SqlClient"
    $connectionType = "Microsoft.Data.SqlClient.SqlConnection"
} catch {
    Add-Type -AssemblyName "System.Data"
    $connectionType = "System.Data.SqlClient.SqlConnection"
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$passwordHash = Get-TemporaryPasswordHash -Password $TemporaryPassword

$connection = New-Object $connectionType $SourceConnection
$hospitalRows = [System.Collections.Generic.List[object]]::new()
$departmentRows = [System.Collections.Generic.List[object]]::new()
$userRows = [System.Collections.Generic.List[object]]::new()
$roleRows = [System.Collections.Generic.List[object]]::new()
$permissionRows = [System.Collections.Generic.List[object]]::new()
$rolePermissionRows = [System.Collections.Generic.List[object]]::new()
$userRoleRows = [System.Collections.Generic.List[object]]::new()
$qualityUserMapRows = [System.Collections.Generic.List[object]]::new()

try {
    $connection.Open()

    $hospitals = Invoke-SourceQuery $connection @"
select
    cast(ID as nvarchar(36)) as ID,
    Name,
    QRCode,
    InsuranceMessage
from Hospital
"@

    $hospitalIdSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($row in $hospitals.Rows) {
        $oldId = Get-DbValue $row "ID"
        $null = $hospitalIdSet.Add($oldId)
        $hospitalRows.Add([pscustomobject]@{
            id = $oldId
            old_id = $oldId
            name = Get-DbValue $row "Name"
            scan_code_msg = Get-DbValue $row "InsuranceMessage"
        })
    }

    $missingQualityHospitals = Invoke-SourceQuery $connection @"
select distinct cast(q.HospitalID as nvarchar(36)) as ID
from MCR_Quality q
left join Hospital h on h.ID = q.HospitalID
where q.HospitalID is not null
  and h.ID is null
"@

    foreach ($row in $missingQualityHospitals.Rows) {
        $oldId = Get-DbValue $row "ID"
        if ([string]::IsNullOrWhiteSpace($oldId) -or -not $hospitalIdSet.Add($oldId)) {
            continue
        }

        $hospitalRows.Add([pscustomobject]@{
            id = $oldId
            old_id = $oldId
            name = "旧库未知医院"
            scan_code_msg = "旧库质控记录引用该医院 ID，但 Hospital 表无对应记录。"
        })
    }

    $departments = Invoke-SourceQuery $connection @"
select
    cast(ID as nvarchar(36)) as ID,
    cast(HospitalID as nvarchar(36)) as HospitalID,
    Name,
    Message
from Department
"@

    foreach ($row in $departments.Rows) {
        $oldId = Get-DbValue $row "ID"
        $departmentRows.Add([pscustomobject]@{
            id = $oldId
            old_id = $oldId
            old_hospital_id = Get-DbValue $row "HospitalID"
            name = Get-DbValue $row "Name"
            display_name = Get-DbValue $row "Name"
            scan_code_msg = Get-DbValue $row "Message"
        })
    }

    $userHasEmail = (Get-DbValue (Invoke-SourceQuery $connection "select case when col_length('Users', 'Email') is null then 0 else 1 end as HasEmail").Rows[0] "HasEmail") -eq "1"
    $emailSelect = if ($userHasEmail) { "u.Email" } else { "cast(null as nvarchar(256)) as Email" }

    $users = Invoke-SourceQuery $connection @"
select
    cast(u.ID as nvarchar(36)) as ID,
    u.UserName,
    $emailSelect,
    u.UKName,
    u.Status,
    cast(u.HospitalID as nvarchar(36)) as HospitalID,
    d.Name as DoctorName,
    cast(d.DepartmentID as nvarchar(36)) as DepartmentID,
    d.Status as DoctorStatus
from Users u
left join DoctorInfo d on d.UserID = u.ID
"@

    foreach ($row in $users.Rows) {
        $oldId = Get-DbValue $row "ID"
        $account = (Get-DbValue $row "UserName").Trim()
        if ([string]::IsNullOrWhiteSpace($account)) {
            continue
        }

        $displayName = Get-DbValue $row "DoctorName"
        if ([string]::IsNullOrWhiteSpace($displayName)) {
            $displayName = Get-DbValue $row "UKName"
        }

        if ([string]::IsNullOrWhiteSpace($displayName)) {
            $displayName = $account
        }

        $isValid = (Get-DbValue $row "Status") -eq "1"
        $doctorStatus = Get-DbValue $row "DoctorStatus"
        if (-not [string]::IsNullOrWhiteSpace($doctorStatus)) {
            $isValid = $isValid -and ($doctorStatus -eq "1")
        }

        $userRows.Add([pscustomobject]@{
            id = $oldId
            old_id = $oldId
            account = $account
            password_hash = $passwordHash
            display_name = $displayName
            email = Get-DbValue $row "Email"
            is_valid = Get-BoolText $isValid
            must_change_password = "true"
            source_type = "mcr"
            old_hospital_id = Get-DbValue $row "HospitalID"
            old_department_id = Get-DbValue $row "DepartmentID"
        })
    }

    $roles = Invoke-SourceQuery $connection @"
select distinct
    cast(r.ID as nvarchar(36)) as ID,
    r.Name,
    r.Description,
    r.Describe,
    r.Status
from [Role] r
where exists (
    select 1
    from RoleFunctionPowerMap rpm
    join FunctionPower fp on fp.ID = rpm.FunctionPowerID
    where rpm.RoleID = r.ID and fp.Code like 'Power-MCR-%'
)
or exists (
    select 1
    from UserRoleMap urm
    where urm.RoleID = r.ID and urm.Status = 1
)
"@

    $roleIdSet = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($row in $roles.Rows) {
        $oldId = Get-DbValue $row "ID"
        $null = $roleIdSet.Add($oldId)
        $describe = Get-DbValue $row "Describe"
        if ([string]::IsNullOrWhiteSpace($describe)) {
            $describe = Get-DbValue $row "Description"
        }

        $roleRows.Add([pscustomobject]@{
            id = $oldId
            old_id = $oldId
            name = Get-DbValue $row "Name"
            describe = $describe
            type = "MCR"
            is_valid = Get-BoolText ((Get-DbValue $row "Status") -ne "2")
        })
    }

    $permissions = Invoke-SourceQuery $connection @"
select
    cast(ID as nvarchar(36)) as ID,
    Name,
    Code
from FunctionPower
where Code like 'Power-MCR-%'
order by Code
"@

    foreach ($row in $permissions.Rows) {
        $oldId = Get-DbValue $row "ID"
        $name = Get-DbValue $row "Name"
        $code = Get-DbValue $row "Code"
        $permissionRows.Add([pscustomobject]@{
            id = $oldId
            old_id = $oldId
            name = $code
            describe = $name
            type = "MCR"
            code = $code
        })
    }

    $rolePermissions = Invoke-SourceQuery $connection @"
select distinct
    cast(rpm.RoleID as nvarchar(36)) as RoleID,
    cast(rpm.FunctionPowerID as nvarchar(36)) as FunctionPowerID
from RoleFunctionPowerMap rpm
join FunctionPower fp on fp.ID = rpm.FunctionPowerID
where fp.Code like 'Power-MCR-%'
"@

    foreach ($row in $rolePermissions.Rows) {
        $rolePermissionRows.Add([pscustomobject]@{
            role_old_id = Get-DbValue $row "RoleID"
            permission_old_id = Get-DbValue $row "FunctionPowerID"
        })
    }

    $userRoles = Invoke-SourceQuery $connection @"
select distinct
    cast(urm.UserID as nvarchar(36)) as UserID,
    cast(urm.RoleID as nvarchar(36)) as RoleID,
    cast(u.HospitalID as nvarchar(36)) as HospitalID,
    cast(d.DepartmentID as nvarchar(36)) as DepartmentID
from UserRoleMap urm
join Users u on u.ID = urm.UserID
left join DoctorInfo d on d.UserID = u.ID
where urm.Status = 1
"@

    foreach ($row in $userRoles.Rows) {
        $roleOldId = Get-DbValue $row "RoleID"
        if (-not $roleIdSet.Contains($roleOldId)) {
            continue
        }

        $userOldId = Get-DbValue $row "UserID"
        $oldHospitalId = Get-DbValue $row "HospitalID"
        $oldDepartmentId = Get-DbValue $row "DepartmentID"
        $scopeId = ConvertTo-StableGuid ("MCR_UserRoleScope:{0}:{1}:{2}:{3}" -f $userOldId, $roleOldId, $oldHospitalId, $oldDepartmentId)
        $userRoleRows.Add([pscustomobject]@{
            user_old_id = $userOldId
            role_old_id = $roleOldId
            old_hospital_id = $oldHospitalId
            old_department_id = $oldDepartmentId
            scope_id = $scopeId
        })
    }

    $qualityUserMaps = Invoke-SourceQuery $connection @"
with quality_source as (
    select ID, ltrim(rtrim(QualityUser)) as QualityUser, HospitalID
    from MCR_Quality
    where QualityUser is not null and ltrim(rtrim(QualityUser)) <> ''
),
same_hospital as (
    select q.ID, min(d.UserID) as UserID, count(distinct d.UserID) as MatchCount
    from quality_source q
    join DoctorInfo d on d.Name = q.QualityUser
    join Users u on u.ID = d.UserID and u.HospitalID = q.HospitalID
    group by q.ID
),
same_name as (
    select q.ID, min(d.UserID) as UserID, count(distinct d.UserID) as MatchCount
    from quality_source q
    join DoctorInfo d on d.Name = q.QualityUser
    group by q.ID
)
select
    cast(q.ID as nvarchar(36)) as QualityID,
    cast(case
        when sh.MatchCount = 1 then sh.UserID
        when isnull(sh.MatchCount, 0) = 0 and sn.MatchCount = 1 then sn.UserID
        else null
    end as nvarchar(36)) as UserID
from quality_source q
left join same_hospital sh on sh.ID = q.ID
left join same_name sn on sn.ID = q.ID
where sh.MatchCount = 1
   or (isnull(sh.MatchCount, 0) = 0 and sn.MatchCount = 1)
"@

    foreach ($row in $qualityUserMaps.Rows) {
        $userOldId = Get-DbValue $row "UserID"
        if ([string]::IsNullOrWhiteSpace($userOldId)) {
            continue
        }

        $qualityUserMapRows.Add([pscustomobject]@{
            old_quality_id = Get-DbValue $row "QualityID"
            user_old_id = $userOldId
        })
    }
} finally {
    $connection.Dispose()
}

$hospitalCsv = Join-Path $OutputDirectory "hospital.csv"
$departmentCsv = Join-Path $OutputDirectory "department.csv"
$userCsv = Join-Path $OutputDirectory "user.csv"
$roleCsv = Join-Path $OutputDirectory "role.csv"
$permissionCsv = Join-Path $OutputDirectory "permission.csv"
$rolePermissionCsv = Join-Path $OutputDirectory "role_permission.csv"
$userRoleCsv = Join-Path $OutputDirectory "user_role.csv"
$qualityUserMapCsv = Join-Path $OutputDirectory "quality_user_map.csv"
$importSql = Join-Path $OutputDirectory "09_import_identity.sql"

$hospitalRows | Export-Csv -Path $hospitalCsv -NoTypeInformation -Encoding utf8BOM
$departmentRows | Export-Csv -Path $departmentCsv -NoTypeInformation -Encoding utf8BOM
$userRows | Export-Csv -Path $userCsv -NoTypeInformation -Encoding utf8BOM
$roleRows | Export-Csv -Path $roleCsv -NoTypeInformation -Encoding utf8BOM
$permissionRows | Export-Csv -Path $permissionCsv -NoTypeInformation -Encoding utf8BOM
$rolePermissionRows | Export-Csv -Path $rolePermissionCsv -NoTypeInformation -Encoding utf8BOM
$userRoleRows | Export-Csv -Path $userRoleCsv -NoTypeInformation -Encoding utf8BOM
$qualityUserMapRows | Export-Csv -Path $qualityUserMapCsv -NoTypeInformation -Encoding utf8BOM
Write-ImportSql -Path $importSql -HospitalCsv $hospitalCsv -DepartmentCsv $departmentCsv -UserCsv $userCsv -RoleCsv $roleCsv -PermissionCsv $permissionCsv -RolePermissionCsv $rolePermissionCsv -UserRoleCsv $userRoleCsv -QualityUserMapCsv $qualityUserMapCsv

$scopeMissingHospitalCount = ($userRoleRows | Where-Object { [string]::IsNullOrWhiteSpace($_.old_hospital_id) }).Count
$report = [pscustomobject]@{
    hospital_count = $hospitalRows.Count
    department_count = $departmentRows.Count
    user_count = $userRows.Count
    role_count = $roleRows.Count
    permission_count = $permissionRows.Count
    role_permission_count = $rolePermissionRows.Count
    user_role_count = $userRoleRows.Count
    user_role_scope_without_hospital_count = $scopeMissingHospitalCount
    quality_user_map_count = $qualityUserMapRows.Count
    temporary_password_hash_length = $passwordHash.Length
    output_directory = (Resolve-Path $OutputDirectory).Path
}

$report | ConvertTo-Json -Depth 4 | Set-Content -Path (Join-Path $OutputDirectory "identity_migration_report.json") -Encoding utf8BOM
$report | ConvertTo-Json -Depth 4

if ($Execute) {
    Invoke-PsqlFile -ConfigPath $TargetConfigPath -SqlPath $importSql
}
