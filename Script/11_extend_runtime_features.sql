create table if not exists mcr.case_advice (
    id uuid primary key,
    case_id uuid not null,
    advice_type integer not null default 0,
    content text not null,
    created_at timestamp not null default now(),
    created_by text null
);

comment on table mcr.case_advice is '病例审核和驳回意见';
comment on column mcr.case_advice.advice_type is '0 医务处审核不通过，1 质控中心退回，2 其他';

create index if not exists ix_case_advice_case on mcr.case_advice(case_id, created_at desc);

create table if not exists mcr.operation_log (
    id uuid primary key,
    module text not null,
    action text not null,
    owner_type text not null,
    owner_id uuid not null,
    content text null,
    created_at timestamp not null default now(),
    created_by text null
);

comment on table mcr.operation_log is '多中心登记运行期操作日志';

create index if not exists ix_operation_log_owner on mcr.operation_log(owner_type, owner_id, created_at desc);
create index if not exists ix_operation_log_module_action on mcr.operation_log(module, action, created_at desc);

alter table mcr.quality_report
    add column if not exists updated_by text null;

alter table mcr.review_meeting
    add column if not exists updated_at timestamp null,
    add column if not exists updated_by text null;

alter table mcr.case_appraise
    add column if not exists updated_by text null;

alter table mcr.case_summary
    add column if not exists updated_at timestamp null,
    add column if not exists updated_by text null;

alter table mcr.case_vote
    add column if not exists updated_at timestamp null,
    add column if not exists updated_by text null;

create index if not exists ix_case_summary_meeting_case on mcr.case_summary(meeting_id, case_id);
create index if not exists ix_case_vote_summary on mcr.case_vote(summary_id);
