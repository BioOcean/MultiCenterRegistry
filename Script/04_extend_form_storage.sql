create table if not exists mcr.form_template (
    id uuid primary key,
    source_custom_form_id text not null unique,
    form_name text not null,
    business_type text not null,
    field_count integer not null default 0,
    answer_count bigint not null default 0,
    card_count bigint not null default 0,
    is_active boolean not null default true,
    created_at timestamp not null default now(),
    updated_at timestamp null
);

create table if not exists mcr.form_template_map (
    id uuid primary key,
    form_template_id uuid not null references mcr.form_template(id),
    business_type text not null,
    source_follow_template_id text not null,
    source_custom_form_id text not null,
    template_name text not null,
    created_at timestamp not null default now()
);

create table if not exists mcr.form_field_definition (
    id uuid primary key,
    form_template_id uuid not null references mcr.form_template(id),
    storage_key text not null,
    source_subject_id text not null,
    source_parent_subject_id text null,
    source_top_subject_id text null,
    source_subject_list_id text null,
    source_subject_config_id text null,
    field_code text not null,
    field_name text not null,
    control_type integer null,
    is_required boolean null,
    default_options text null,
    fixed_value text null,
    format text null,
    sort integer not null default 0,
    level integer not null default 0,
    status integer not null default 0,
    answer_count bigint not null default 0,
    non_empty_answer_count bigint not null default 0,
    created_at timestamp not null default now()
);

create table if not exists mcr.form_instance (
    id uuid primary key,
    owner_type text not null,
    owner_id uuid not null,
    form_template_id uuid not null references mcr.form_template(id),
    form_template_map_id uuid null references mcr.form_template_map(id),
    source_card_id text null,
    source_custom_form_id text null,
    source_follow_template_id text null,
    status integer not null default 0,
    created_at timestamp not null,
    created_by text null,
    updated_at timestamp null,
    updated_by text null
);

create table if not exists mcr.form_field_value (
    id uuid primary key,
    form_instance_id uuid not null references mcr.form_instance(id),
    form_field_definition_id uuid null references mcr.form_field_definition(id),
    storage_key text not null,
    source_answer_id text null,
    source_subject_id text null,
    field_code text not null,
    field_name text not null,
    field_value text null,
    field_text text null,
    sort integer not null default 0,
    created_at timestamp not null,
    created_by text null,
    updated_at timestamp null,
    updated_by text null
);

create unique index if not exists ux_form_template_source_custom_form
    on mcr.form_template(source_custom_form_id);

create unique index if not exists ux_form_template_map_source
    on mcr.form_template_map(business_type, source_follow_template_id, source_custom_form_id);

create unique index if not exists ux_form_field_definition_storage
    on mcr.form_field_definition(form_template_id, storage_key);

create index if not exists ix_form_field_definition_source_subject
    on mcr.form_field_definition(source_subject_id);

create index if not exists ix_form_instance_owner
    on mcr.form_instance(owner_type, owner_id);

create index if not exists ix_form_instance_source_card
    on mcr.form_instance(source_card_id);

create index if not exists ix_form_field_value_instance_storage
    on mcr.form_field_value(form_instance_id, storage_key);

create unique index if not exists ux_form_field_value_source_answer
    on mcr.form_field_value(source_answer_id)
    where source_answer_id is not null;
