create schema if not exists system;

do $$
begin
    if to_regclass('mcr.migration_map') is not null then
        execute $sql$
            delete from system.sys_user_role_scope scope
            using mcr.migration_map map
            where (map.source_table = 'MCR_User' and scope.user_id = map.target_id)
               or (map.source_table = 'MCR_Role' and scope.role_id = map.target_id)
               or (map.source_table = 'MCR_Hospital' and scope.hospital_id = map.target_id)
               or (map.source_table = 'MCR_Department' and scope.department_id = map.target_id)
        $sql$;

        execute $sql$
            delete from system.sys_map_user_role user_role
            using mcr.migration_map map
            where (map.source_table = 'MCR_User' and user_role.user_id = map.target_id)
               or (map.source_table = 'MCR_Role' and user_role.role_id = map.target_id)
        $sql$;

        execute $sql$
            delete from system.sys_map_role_permission role_permission
            using mcr.migration_map map
            where (map.source_table = 'MCR_Role' and role_permission.role_id = map.target_id)
               or (map.source_table = 'MCR_FunctionPower' and role_permission.permission_id = map.target_id)
        $sql$;

        execute $sql$
            delete from system.sys_department department
            using mcr.migration_map map
            where map.source_table = 'MCR_Department'
              and department.id = map.target_id
        $sql$;

        execute $sql$
            delete from system.sys_hospital hospital
            using mcr.migration_map map
            where map.source_table = 'MCR_Hospital'
              and hospital.id = map.target_id
        $sql$;

        execute $sql$
            delete from system.sys_permission permission
            using mcr.migration_map map
            where map.source_table = 'MCR_FunctionPower'
              and permission.id = map.target_id
              and permission.code like 'Power-MCR-%'
        $sql$;

        execute $sql$
            delete from system.sys_role role_row
            using mcr.migration_map map
            where map.source_table = 'MCR_Role'
              and role_row.id = map.target_id
              and role_row.type = 'MCR'
        $sql$;

        execute $sql$
            delete from system.sys_user user_row
            using mcr.migration_map map
            where map.source_table = 'MCR_User'
              and user_row.id = map.target_id
              and user_row.source_type = 'mcr'
        $sql$;
    end if;
end
$$;

drop schema if exists mcr cascade;
create schema mcr;

create table if not exists mcr.case_record (
    id uuid primary key,
    old_case_id text not null unique,
    patient_name text not null,
    patient_sex text,
    patient_sex_text text,
    patient_age text,
    id_number text,
    patient_number text,
    disease_id text,
    disease_name text,
    hospital_id text,
    hospital_name text,
    department_id text,
    department_name text,
    operator_id text,
    operator_name text,
    admission_time timestamp without time zone,
    discharge_time timestamp without time zone,
    operation_time timestamp without time zone,
    hospital_stay_days integer,
    surgery_type_value text,
    surgery_type_text text,
    coronary_intervention text,
    ablation_intervention text,
    structural_intervention text,
    is_emergency_intervention text,
    discharge_mode text,
    situation_reason text,
    situation_supplement text,
    death_time timestamp without time zone,
    case_summary text,
    discharge_diagnosis text,
    other_exam text,
    angiography_result text,
    intervention_process text,
    rescue_process text,
    complication_discussion text,
    occurrence_reason text,
    death_reason text,
    lessons_learned text,
    improvement_measures text,
    status integer not null,
    sub_status integer not null,
    sort integer not null default 0,
    created_at timestamp without time zone not null,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text
);

create table if not exists mcr.quality_report (
    id uuid primary key,
    old_quality_id text not null unique,
    name text not null,
    quality_date timestamp without time zone not null,
    template_id text,
    template_name text,
    hospital_id text,
    hospital_name text,
    status integer not null,
    quality_user_id text,
    quality_user_name text,
    submitted_at timestamp without time zone,
    created_at timestamp without time zone not null,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text
);

create table if not exists mcr.quality_report_item (
    id uuid primary key,
    quality_report_id uuid not null,
    metric_code text not null,
    metric_name text not null,
    category_name text,
    case_count integer,
    sort integer not null default 0,
    created_at timestamp without time zone not null,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text
);

create table if not exists mcr.quality_reject (
    id uuid primary key,
    quality_report_id uuid not null,
    content text not null,
    created_at timestamp without time zone not null,
    created_by text
);

create table if not exists mcr.review_meeting (
    id uuid primary key,
    old_meeting_id text not null unique,
    title text not null,
    description text,
    group_info text,
    place text,
    meeting_time timestamp without time zone not null,
    end_time timestamp without time zone,
    status integer not null,
    created_at timestamp without time zone not null,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text
);

create table if not exists mcr.meeting_expert (
    id uuid primary key,
    meeting_id uuid not null,
    expert_id text not null,
    level integer not null
);

create table if not exists mcr.case_appraise (
    id uuid primary key,
    meeting_id uuid not null,
    case_id uuid not null,
    expert_id text not null,
    status integer not null,
    indication text,
    operation text,
    device_complete text,
    surgery_level_implemented text,
    has_management_problem text,
    management_problem_description text,
    rescue_timely text,
    rescue_measure_proper text,
    rescue_device_complete text,
    death_reason text,
    other_death_reason text,
    need_improvement text,
    improvement_content text,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone,
    updated_by text
);

create table if not exists mcr.case_summary (
    id uuid primary key,
    meeting_id uuid not null,
    case_id uuid not null,
    content text not null,
    status integer not null,
    expert_name text,
    created_at timestamp without time zone not null,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text
);

create table if not exists mcr.case_vote (
    id uuid primary key,
    meeting_id uuid not null,
    case_id uuid not null,
    summary_id uuid not null,
    agreed boolean not null,
    content text,
    expert_name text,
    created_at timestamp without time zone not null,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text
);

create table if not exists mcr.case_advice (
    id uuid primary key,
    case_id uuid not null,
    advice_type integer not null,
    content text not null,
    created_at timestamp without time zone not null,
    created_by text
);

create table if not exists mcr.operation_log (
    id uuid primary key,
    module text not null,
    action text not null,
    owner_type text not null,
    owner_id uuid not null,
    content text,
    created_at timestamp without time zone not null,
    created_by text
);

create table if not exists mcr.registry_file (
    id uuid primary key,
    owner_type text not null,
    owner_id uuid not null,
    file_name text not null,
    file_path text not null,
    content_type text,
    file_size bigint,
    created_at timestamp without time zone not null,
    created_by text
);

create table if not exists mcr.article (
    id uuid primary key,
    old_article_id text,
    topic_id text,
    type integer not null,
    status integer not null,
    title text not null,
    content text not null,
    cover text,
    created_at timestamp without time zone not null,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text
);

create table if not exists mcr.portal_config (
    code text primary key,
    title text,
    value text not null,
    updated_at timestamp without time zone not null,
    updated_by text
);

create table if not exists mcr.migration_map (
    id uuid primary key,
    source_table text not null,
    source_id text not null,
    target_table text not null,
    target_id uuid not null,
    created_at timestamp without time zone not null,
    unique (source_table, source_id)
);

create table if not exists system.sys_user (
    id uuid primary key,
    account text not null,
    password text not null,
    display_name text not null,
    email text,
    can_grant_to_other boolean not null,
    is_valid boolean not null,
    must_change_password boolean not null,
    source_type text
);

create table if not exists system.sys_permission (
    id uuid primary key,
    code text,
    name text not null,
    describe text,
    type text
);

create table if not exists system.sys_role (
    id uuid primary key,
    name text not null,
    describe text,
    type text,
    is_valid boolean not null,
    owner_user_id uuid
);

create table if not exists system.sys_map_user_role (
    user_id uuid not null,
    role_id uuid not null,
    primary key (user_id, role_id)
);

create table if not exists system.sys_map_role_permission (
    role_id uuid not null,
    permission_id uuid not null,
    primary key (role_id, permission_id)
);

create table if not exists system.sys_user_role_scope (
    id uuid primary key,
    user_id uuid not null,
    role_id uuid not null,
    hospital_id uuid not null,
    hospital_name text not null,
    department_id uuid,
    department_name text,
    created_at timestamp without time zone not null
);

create table if not exists system.sys_hospital (
    id uuid primary key,
    name text not null
);

create table if not exists system.sys_department (
    id uuid primary key,
    hospital_id uuid not null,
    name text not null,
    display_name text
);

create index if not exists ix_case_record_hospital_status on mcr.case_record (hospital_id, status);
create index if not exists ix_case_record_status_created_at on mcr.case_record (status, created_at);
create index if not exists ix_case_record_discharge_time on mcr.case_record (discharge_time);
create index if not exists ix_case_record_patient_number on mcr.case_record (patient_number);
create index if not exists ix_case_record_patient_name on mcr.case_record (patient_name);
create index if not exists ix_case_record_operator_id on mcr.case_record (operator_id);
create index if not exists ix_case_record_surgery_type_value on mcr.case_record (surgery_type_value);
create index if not exists ix_quality_report_quality_date_hospital_template on mcr.quality_report (quality_date, hospital_id, template_id);
create index if not exists ix_quality_report_item_report_sort on mcr.quality_report_item (quality_report_id, sort);
create index if not exists ix_meeting_expert_meeting_id on mcr.meeting_expert (meeting_id);
create index if not exists ix_case_appraise_meeting_case on mcr.case_appraise (meeting_id, case_id);
create index if not exists ix_case_summary_meeting_case on mcr.case_summary (meeting_id, case_id);
create index if not exists ix_case_vote_summary_id on mcr.case_vote (summary_id);
create index if not exists ix_case_advice_case_created on mcr.case_advice (case_id, created_at);
create index if not exists ix_registry_file_owner on mcr.registry_file (owner_type, owner_id);
create unique index if not exists ix_article_old_article_id on mcr.article (old_article_id) where old_article_id is not null;
create index if not exists ix_article_type_status_created on mcr.article (type, status, created_at);
