begin;

with redundant_template as (
    select id
    from mcr.form_template
    where business_type = 'case'
      and form_name = '创建病例信息'
),
redundant_instance as (
    select id
    from mcr.form_instance
    where form_template_id in (select id from redundant_template)
),
redundant_value as (
    select id
    from mcr.form_field_value
    where form_instance_id in (select id from redundant_instance)
)
delete from mcr.registry_file
where owner_type = 'form_field_value'
  and owner_id in (select id from redundant_value);

with redundant_template as (
    select id
    from mcr.form_template
    where business_type = 'case'
      and form_name = '创建病例信息'
),
redundant_instance as (
    select id
    from mcr.form_instance
    where form_template_id in (select id from redundant_template)
)
delete from mcr.form_field_value
where form_instance_id in (select id from redundant_instance);

with redundant_template as (
    select id
    from mcr.form_template
    where business_type = 'case'
      and form_name = '创建病例信息'
)
delete from mcr.form_instance
where form_template_id in (select id from redundant_template);

with redundant_template as (
    select id
    from mcr.form_template
    where business_type = 'case'
      and form_name = '创建病例信息'
)
delete from mcr.form_field_definition
where form_template_id in (select id from redundant_template);

with redundant_template as (
    select id
    from mcr.form_template
    where business_type = 'case'
      and form_name = '创建病例信息'
)
delete from mcr.form_template_map
where form_template_id in (select id from redundant_template);

delete from mcr.form_template
where business_type = 'case'
  and form_name = '创建病例信息';

commit;
