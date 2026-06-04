create schema if not exists mcr;

create table if not exists mcr.case_record (
    id uuid primary key,
    old_case_id text not null unique,
    patient_name text not null,
    patient_sex text null,
    patient_age text null,
    id_number text null,
    patient_number text null,
    disease_id text null,
    hospital_id text null,
    department_id text null,
    operator_id text null,
    admission_time timestamp null,
    discharge_time timestamp null,
    operation_time timestamp null,
    status integer not null,
    sub_status integer not null,
    sort integer not null default 0,
    created_at timestamp not null,
    created_by text null,
    updated_at timestamp null,
    updated_by text null
);

create table if not exists mcr.case_form_data (
    id uuid primary key,
    case_id uuid not null,
    form_code text not null,
    section_code text not null,
    field_code text not null,
    field_name text not null,
    field_value text null,
    field_text text null,
    sort integer not null default 0,
    created_at timestamp not null,
    created_by text null
);

create table if not exists mcr.quality_report (
    id uuid primary key,
    old_quality_id text not null unique,
    name text not null,
    quality_date timestamp not null,
    template_id text null,
    hospital_id text null,
    status integer not null,
    quality_user_id text null,
    created_at timestamp not null,
    created_by text null,
    updated_at timestamp null
);

create table if not exists mcr.quality_reject (
    id uuid primary key,
    quality_report_id uuid not null,
    content text not null,
    created_at timestamp not null,
    created_by text null
);

create table if not exists mcr.review_meeting (
    id uuid primary key,
    old_meeting_id text not null unique,
    title text not null,
    description text null,
    group_info text null,
    place text null,
    meeting_time timestamp not null,
    end_time timestamp null,
    status integer not null,
    created_at timestamp not null,
    created_by text null
);

create table if not exists mcr.meeting_expert (
    id uuid primary key,
    meeting_id uuid not null,
    expert_id text not null,
    level integer not null default 0
);

create table if not exists mcr.case_appraise (
    id uuid primary key,
    meeting_id uuid not null,
    case_id uuid not null,
    expert_id text not null,
    status integer not null,
    created_at timestamp not null,
    updated_at timestamp null
);

create table if not exists mcr.case_summary (
    id uuid primary key,
    meeting_id uuid not null,
    case_id uuid not null,
    content text not null,
    status integer not null,
    expert_name text null,
    created_at timestamp not null,
    created_by text null
);

create table if not exists mcr.case_vote (
    id uuid primary key,
    meeting_id uuid not null,
    case_id uuid not null,
    summary_id uuid not null,
    agreed boolean not null,
    content text null,
    expert_name text null,
    created_at timestamp not null,
    created_by text null
);

create table if not exists mcr.registry_file (
    id uuid primary key,
    owner_type text not null,
    owner_id uuid not null,
    file_name text not null,
    file_path text not null,
    content_type text null,
    file_size bigint null,
    created_at timestamp not null,
    created_by text null
);

create table if not exists mcr.migration_map (
    id uuid primary key,
    source_table text not null,
    source_id text not null,
    target_table text not null,
    target_id uuid not null,
    created_at timestamp not null
);

create unique index if not exists ux_migration_map_source on mcr.migration_map(source_table, source_id);
create index if not exists ix_case_record_hospital_status on mcr.case_record(hospital_id, status);
create index if not exists ix_case_form_data_case on mcr.case_form_data(case_id, form_code, section_code);
create index if not exists ix_quality_report_hospital_status on mcr.quality_report(hospital_id, status);
create index if not exists ix_meeting_expert_meeting on mcr.meeting_expert(meeting_id);
create index if not exists ix_case_appraise_meeting_case on mcr.case_appraise(meeting_id, case_id);
create index if not exists ix_registry_file_owner on mcr.registry_file(owner_type, owner_id);
