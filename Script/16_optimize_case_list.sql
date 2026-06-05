begin;

alter table mcr.case_record
    add column if not exists hospital_name text null,
    add column if not exists operator_name text null,
    add column if not exists patient_sex_text text null,
    add column if not exists surgery_type_value text null,
    add column if not exists surgery_type_text text null;

update mcr.case_record c
set hospital_name = h.name
from system.sys_hospital h
where c.hospital_id = h.id::text
  and (c.hospital_name is distinct from h.name);

update mcr.case_record c
set operator_name = coalesce(nullif(u.display_name, ''), u.account)
from system.sys_user u
where c.operator_id = u.id::text
  and (c.operator_name is distinct from coalesce(nullif(u.display_name, ''), u.account));

update mcr.case_record
set patient_sex_text = case lower(trim(patient_sex))
    when '1' then '男'
    when '2' then '女'
    when 'm' then '男'
    when 'male' then '男'
    when 'f' then '女'
    when 'female' then '女'
    when 'bf8d205c-55d7-7e00-a834-f51e79bbfd7f' then '男'
    when '5df1f0b4-61ca-56a5-4163-8dd441b09534' then '女'
    else nullif(trim(patient_sex), '')
end
where patient_sex is not null
  and patient_sex <> '';

with raw_sex as (
    select distinct on (i.owner_id)
        i.owner_id,
        nullif(trim(coalesce(v.field_text, v.field_value, '')), '') as raw_value
    from mcr.form_instance i
    join mcr.form_field_value v on v.form_instance_id = i.id
    where i.owner_type = 'case'
      and v.field_name = '性别'
      and nullif(trim(coalesce(v.field_text, v.field_value, '')), '') is not null
    order by i.owner_id, v.sort, v.created_at
),
sex_values as (
    select
        owner_id,
        case lower(raw_value)
            when '1' then '男'
            when '2' then '女'
            when 'm' then '男'
            when 'male' then '男'
            when 'f' then '女'
            when 'female' then '女'
            when 'bf8d205c-55d7-7e00-a834-f51e79bbfd7f' then '男'
            when '5df1f0b4-61ca-56a5-4163-8dd441b09534' then '女'
            else raw_value
        end as display_value
    from raw_sex
)
update mcr.case_record c
set patient_sex_text = s.display_value
from sex_values s
where c.id = s.owner_id
  and c.patient_sex_text is distinct from s.display_value;

with raw_surgery as (
    select distinct on (i.owner_id)
        i.owner_id,
        nullif(trim(coalesce(v.field_text, v.field_value, '')), '') as raw_value
    from mcr.form_instance i
    join mcr.form_field_value v on v.form_instance_id = i.id
    where i.owner_type = 'case'
      and v.field_name in ('手术类别', '手术类型')
      and nullif(trim(coalesce(v.field_text, v.field_value, '')), '') is not null
    order by i.owner_id, v.sort, v.created_at
),
surgery_values as (
    select
        owner_id,
        raw_value,
        case upper(raw_value)
            when '6237DD62-15B9-4676-972D-BF32476B3546' then '冠心病介入'
            when 'C1174C60-2EF2-45F6-85DD-5269B567F996' then '结构性心脏病介入'
            when 'F827AE4A-F24F-4DF9-B92F-7601025A1864' then '起搏器及CIED植入/置换'
            when 'AE92E4FA-5E02-4D4C-A773-3DC79C4935BC' then '导管消融'
            when '8F3DB288-175D-DCE1-590F-AD49C0BC4041' then '急诊PCI'
            when '166FE6ED-40FA-0ED3-8F67-AB985B95575F' then '择期PCI'
            when 'AA4D47B6-7852-4A5F-AB95-50D7568DB9C4' then '单纯CAG'
            else raw_value
        end as display_value
    from raw_surgery
)
update mcr.case_record c
set surgery_type_value = s.raw_value,
    surgery_type_text = s.display_value
from surgery_values s
where c.id = s.owner_id
  and (c.surgery_type_value is distinct from s.raw_value
       or c.surgery_type_text is distinct from s.display_value);

create extension if not exists pg_trgm;

create index if not exists ix_case_record_status_created on mcr.case_record(status, created_at desc);
create index if not exists ix_case_record_hospital_status_sort on mcr.case_record(hospital_id, status, sort desc, created_at desc);
create index if not exists ix_case_record_operator_created on mcr.case_record(operator_id, created_at desc);
create index if not exists ix_case_record_discharge_time on mcr.case_record(discharge_time);
create index if not exists ix_case_record_patient_number on mcr.case_record(patient_number);
create index if not exists ix_case_record_patient_name on mcr.case_record(patient_name);
create index if not exists ix_case_record_hospital_name on mcr.case_record(hospital_name);
create index if not exists ix_case_record_operator_name on mcr.case_record(operator_name);
create index if not exists ix_case_record_patient_sex_text on mcr.case_record(patient_sex_text);
create index if not exists ix_case_record_surgery_type_value on mcr.case_record(surgery_type_value);
create index if not exists ix_case_record_surgery_type_text on mcr.case_record(surgery_type_text);
create index if not exists ix_case_record_patient_name_trgm on mcr.case_record using gin (patient_name gin_trgm_ops);
create index if not exists ix_case_record_patient_number_trgm on mcr.case_record using gin (patient_number gin_trgm_ops);

commit;
