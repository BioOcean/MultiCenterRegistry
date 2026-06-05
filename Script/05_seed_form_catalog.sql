begin;

insert into mcr.form_template (id, source_custom_form_id, form_name, business_type, field_count, answer_count, card_count)
values ('7579ea16-2b72-0ad7-c088-67067a694de4', '71138903-a3a8-4f38-80d9-91015f27c7f1', '病例填写', 'case', 39, 232, 6)
on conflict (source_custom_form_id) do update set
    form_name = excluded.form_name,
    business_type = excluded.business_type,
    field_count = excluded.field_count,
    answer_count = excluded.answer_count,
    card_count = excluded.card_count,
    updated_at = now();

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('75632a53-5035-ca57-1aa5-1ecb0ec9089f', '7579ea16-2b72-0ad7-c088-67067a694de4', 'case', 'ae92e4fa-5e02-4d4c-a773-3dc79c4935bc', '71138903-a3a8-4f38-80d9-91015f27c7f1', '导管消融')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f08f0991-c880-d721-abc5-18003c4292cc', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f001', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, null, '5bbaec13-2c09-42af-830b-3f1badbbc34d', '62a8ee3d-793f-495d-bf28-53902463adff', 'HZJBXX4', '患者基本信息', 1, null, null, null, null, 1, 1, 0, 6, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('388d0056-0a31-7eb8-5688-239837fa2091', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f002', '0511d13d-8971-4b36-9a99-ca88c064fef7', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '3687a502-f3e2-4349-97a8-741a5318ca39', '4bf1ee4c-4d96-448a-b860-23b24e5f590a', 'BAH', '病案号', 6, null, null, null, null, 2, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('49b3c9b5-d5bc-c970-b129-3dbeb96f6e91', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f003', '30738e3e-e3b7-4e0b-af8a-bc85077fd564', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '843c4dc1-aaef-4b0d-a1cc-28ca0bd1fdf6', '68474850-9e3c-424d-b4ae-033cf9d9f1b1', 'HZXM', '患者姓名', 6, null, null, null, null, 3, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('88dd4933-c75d-1225-7bff-a3a9773edf2d', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f004', 'e72e0f57-9b5e-4fed-96a3-a653f11726bd', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '1511d2e2-791e-4bff-ad88-a4f28c3e234f', '8205535c-ba9c-4a9b-a648-973d50e8f91f', 'XBSEX', '性别', 2, null, '11', null, null, 4, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('cba424c5-8cd1-2af5-0200-6bcc0c0afa6d', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f005', '48448b1e-c179-4446-b11e-0f1088361d72', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '33700706-f08b-47da-bd9d-1ce9e5948840', '158fa29f-7e08-4368-b53d-ec3faacc522a', 'NL3', '年龄', 5, null, null, null, '3', 5, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('0536c967-470c-60fd-ff1b-19b53462c94a', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f006', '3c129b2f-bf21-4cee-91fa-812c1efc08b9', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '4fa876ab-b781-4f3d-8198-98ab803b99dc', 'a3568a18-1cf3-47df-af71-1a6baa386c1a', 'PTPaperNumber', '身份证号码', 6, null, null, null, null, 6, 2, 0, 6, 4)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('57cde592-2088-4504-8e3f-3222ac60afa7', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f007', '0d96cc65-e726-48d3-8ad9-0209253a6e4d', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '61d166b7-c245-467a-8bb1-ec8b0635a0d7', '752e51dd-7cd4-40f9-a484-22ab694948d7', 'ZYKS', '住院科室', 6, null, null, null, null, 7, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('228f0c00-1a35-401f-95f7-2bebc889823f', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f008', '949b63ad-8c3d-4edc-ba6f-41e93ae8dbf5', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, 'a68c720d-ba73-47e5-858f-e15a49666acc', '775f7da7-db45-4c45-b27b-ddf4f8ae84f4', 'RYSJ1', '入院时间', 4, null, null, null, 'YYYY-MM-DD', 8, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('83def814-9f45-0d56-946e-91e00065765d', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f009', 'e3795948-85ed-43d1-a612-7563acc645af', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '181f7b87-e941-4b6a-af5e-258259211910', '69ba3eda-26fa-418b-bd09-e8ed9fcc6198', 'BIDisTime', '出院时间', 4, null, null, null, 'YYYY-MM-DD', 9, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f2b7b0da-4f75-6a0c-451b-5a8098e41ce1', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f010', '24a56c9e-d6b7-4295-b2ce-88f11362caf1', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, 'ef255835-8e19-4ded-92ea-f39f5ea91601', 'b693945d-f234-43a8-a2f8-048d91208460', '2281', '住院天数', 5, null, null, null, '1', 10, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('03b7d8ee-fbf7-9bd5-0aa0-954aee006c90', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f011', '152a3656-4dd7-4461-b29d-0fa8e2ac773d', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '39ec7612-6e63-49cd-94a4-505ea42557c9', 'eb8ea722-6007-4dae-8c0e-e76d467dc14b', 'SSLX2', '手术类型', 2, null, '1111', null, null, 11, 2, 0, 4, 4)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7ae2c96d-9aed-6905-9045-150b80056f59', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f012', '377035f7-934b-4b1b-ab6a-40790cf6a058', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, 'f40a4ab5-094c-416c-9c6e-f9627d0ec86d', '9eaa1372-7aab-4338-907a-bdeda703ebd6', 'SZ16', '术者', 2, null, '11', null, null, 12, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f366ad51-0628-2dc6-1851-5e27fe05e830', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f013', 'cf50bc8d-9e48-4e58-91b9-a35794990827', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, 'c208d2f7-869a-43c1-a009-3d835121f6b3', '997cf821-ada7-4c9d-89d1-e1ee9d3962b5', 'SFJZJR', '是否急诊介入', 2, false, '11', null, null, 13, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('48e40e7b-d600-b963-dc9f-976912dd0e24', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f014', '450bbbba-a5f3-4c60-a678-2797337e1ecc', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, 'a8f2a006-9421-4b89-915f-ab8e5ac400a6', '106ce6cf-8150-43ec-a2ed-556556ba6376', 'PatPFOutCarEveLiveDeaTim', '死亡时间', 4, null, null, null, 'YYYY-MM-DD', 14, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('08587d8b-97b4-b54a-4231-6c43b198c616', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f015', '3bac1985-b561-4b74-bb5b-80bfac17acc9', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '174c1157-b51c-4107-9839-b07c67b9ee8d', 'e7b2e2fa-8092-4568-8a31-fbb39d8d8ee4', 'QKSMYYSM', '情况说明/原因说明', 2, null, '1111', null, null, 15, 2, 0, 6, 4)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('71c5e792-58fe-288e-30b6-59e44fe10573', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f016', 'c213e5d4-5e19-4d47-b874-b3259a068a19', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '6f4debc8-dd17-4948-b61d-5ed088ddeeb6', 'c4c1994a-1bb3-418e-8ca4-c53422e084d2', 'BCSM', '补充说明', 10, null, null, null, null, 16, 2, 0, 6, 3)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e1c97120-fda8-f059-a63c-b325b9d12b57', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f017', '94af2343-1d2c-4614-a1d3-4c97c8698add', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, 'cf9b5f6b-2979-4516-94b8-1072c8c91dbe', 'c796f54a-27b7-43cc-bc71-3b66fe581b7d', 'LYFS', '离院方式', 6, null, null, null, null, 17, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('37d2e69e-550e-81d3-24b9-8ea7a6ca4cc6', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f018', '89612a2b-30bd-4346-bec0-fa5182b5e110', 'b9738620-c5a5-4ae0-a594-0b7a1c3188a9', null, '49d31760-2eb2-4f15-add2-5feda0a600e4', 'fc201821-4a4d-43f3-a90b-ddd40f1192d7', 'DGXR', '导管消融', 2, null, '111', null, null, 18, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('87b9c8ed-7d3c-81cc-8e71-294fa123580b', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f019', '5d51fa46-bce8-4b1f-8ff3-a598c63f869b', null, null, '46d495f7-7f90-4f5c-8e67-59bcf1f7368b', '786ba3b5-46db-42ea-b474-cb4a53564610', 'BLZY', '病历摘要', 1, null, null, null, null, 19, 1, 0, 6, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b1acd18e-4dc7-db1f-3868-4b335d013cf7', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f020', 'd5baf9de-e47f-42e9-b804-836f33e7ccb2', '5d51fa46-bce8-4b1f-8ff3-a598c63f869b', null, '617f967c-50f2-453b-9982-2910b22fa9f0', 'bb5b2f19-2c55-48f6-8efb-1f2fd9ee240e', 'ZYNR', '摘要内容', 10, null, null, null, null, 20, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('024891e2-cbb2-2766-b296-77f6d43f9cc9', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f021', '4b5ebb70-2ae5-410d-b8a8-0b3f2f198352', null, null, '431ca933-9fbb-4350-b644-31aa020c4f22', '80ef018d-8da2-4397-a2f6-b6ae3e7ee59d', 'CYZD11', '出院诊断', 1, null, null, null, null, 21, 1, 0, 6, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a274f770-9b66-348a-5b1a-109a1cdacdee', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f022', 'f8452fbc-ab9a-482d-8300-e133b816ffaa', '4b5ebb70-2ae5-410d-b8a8-0b3f2f198352', null, '28807860-8482-4047-97ba-83c6c52a98c2', 'cedc94d3-9af9-4eae-83c9-dde7a0400f40', 'CYZD6', '出院诊断', 10, null, null, null, null, 22, 2, 0, 6, 5)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b8cefc13-bf7d-bbc6-7af2-b9fe08521b48', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f023', '03611660-062c-49ba-b0c7-f77b87dcd99b', null, null, '652df5c2-6ba5-4dac-bb68-e87ebcbcad16', 'ff03924c-8243-43f7-b45b-55bdc2db951a', 'XGSYSJC', '相关实验室检查', 1, null, null, null, null, 23, 1, 0, 6, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f8753df1-2155-35b9-6b1d-5f4dee35edaf', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f024', '61026ef4-1294-4cab-9ba2-a2ad210b9ec9', '03611660-062c-49ba-b0c7-f77b87dcd99b', null, '0f6d5e12-d381-4c71-9ba7-1dcdb4608562', '22132deb-b587-4515-ac57-59f0251111c7', 'HYCTPSC', '化验单图片上传', 7, null, null, null, '2', 24, 2, 0, 6, 5)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('593f41f9-e738-e29e-a44b-43fe423d6f7a', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f025', 'bfed422f-7524-40bd-ae11-5635d73daa11', null, null, 'c455d8c7-c3a6-442b-ac59-4236d5f71c79', 'c05b1fd0-d646-4115-be9d-c4da36ad9ac4', 'ZYFZJC', '主要辅助检查', 1, null, null, null, null, 25, 1, 0, 6, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('dbdaac7c-9862-f492-c861-c6ea1e000992', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f026', '39b85e8e-2670-4cc1-8d92-0f1d3968bdd4', 'bfed422f-7524-40bd-ae11-5635d73daa11', null, 'c56134f2-a96b-4bfe-995d-99dc08feeb61', 'ef0a8404-695e-4ffa-b8bd-d4d01284fd26', 'XDTTPSC', '心电图图片上传', 7, null, null, null, '2', 26, 2, 0, 6, 5)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('05b0f75e-a770-d717-2749-0bae0fd1f43b', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f027', '432d2ff6-36a3-44ff-9fc0-275986b96a75', 'bfed422f-7524-40bd-ae11-5635d73daa11', null, '03321f6b-9f99-4184-8a7e-26b6e4c81d52', '2afb6190-941b-4860-af77-396213e28f71', 'XZCC', '心脏彩超', 7, null, null, null, '2', 27, 2, 0, 6, 4)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('92eaf8ec-c682-c935-b76f-d85ed17503a7', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f028', 'dd9a7fe7-5f39-4c8d-815c-c0699daf078b', 'bfed422f-7524-40bd-ae11-5635d73daa11', null, '8adc2563-9f51-4b10-af5d-9f5f62155388', '45723d81-a588-4bd4-b9c2-dd8fb1c2ae45', 'JTJC5', '其他检查', 10, null, null, null, null, 28, 2, 0, 6, 3)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b254f6ca-de3f-b1c4-d976-9d2ee13ec411', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f029', 'bdbf0a44-5022-49b8-a4d6-819d406e20a3', null, null, '2d8cc761-d73f-420b-a209-bbbd4198768a', 'a61c96aa-9708-4a2e-b8f5-2de514ef51d5', 'JRZLQK', '介入诊疗情况', 1, null, null, null, null, 29, 1, 0, 6, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6be65a49-1aca-38fa-ebed-0f0afe6cd1f5', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f030', '32b5b1ac-9efc-4053-9989-f3e515396431', 'bdbf0a44-5022-49b8-a4d6-819d406e20a3', null, '79f64129-3546-42bb-82bb-27bc31d6b800', '685a9f32-993a-4c28-b02b-231d1cfeaf69', 'ZYJCJG', '造影检查结果', 10, null, null, null, null, 30, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3720fd49-6da9-f87a-c786-6da10b9cce0e', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f031', '94076358-b4fb-4513-b0f5-94f35773aeff', 'bdbf0a44-5022-49b8-a4d6-819d406e20a3', null, 'e6fc9b3f-fcef-4628-b389-e1ba0f6dff9c', 'f382d154-a94c-44bc-a495-103c56e856ed', 'JRJG', '介入经过', 10, null, null, null, null, 31, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d62e140e-558e-8e22-45c1-8fd38cc9a816', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f032', '104e8293-5ec3-4f89-9978-7b094ed845cb', null, null, 'bf93e126-76fb-4f04-8838-0cfde818dc20', '9e5103aa-7175-4ae4-96e7-bcf590262a18', 'BFZJZQK', '并发症救治情况', 1, null, null, null, null, 32, 1, 0, 6, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f33721d0-ef62-9d4e-e311-d6eb9d27814d', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f033', 'a0fdd992-ad6b-45e4-8562-70ffcf415965', '104e8293-5ec3-4f89-9978-7b094ed845cb', null, '06174b64-189b-4830-935a-c6855128e41f', '1b0aa4a5-b9c4-4a66-b43e-596db76345f6', 'JZJG', '救治经过', 10, null, null, null, null, 33, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a60a2eb0-2fe6-ad99-ca7e-dd12e3afe50c', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f034', 'ba2b6ca1-9b52-49ba-abca-9b8c89590471', null, null, '61c06ea1-9679-46f6-9273-b7572f33a26a', '9420382b-efe0-482f-b27d-ab221d344b26', 'BFZTLJL', '并发症讨论结论', 1, null, null, null, null, 34, 1, 0, 6, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('197ae483-6023-ac2f-c6f2-928264eef56b', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f035', 'f8d7ffd6-36a3-484f-8c28-87890ebb35f4', 'ba2b6ca1-9b52-49ba-abca-9b8c89590471', null, '68215436-63a1-467c-b024-49e44572b2cc', 'fb307ad0-1d38-45e3-b4eb-09ee78ff288a', 'SFZZYYHKSBFZTL', '是否组织医院或科室并发症讨论', 2, null, '11', null, null, 35, 2, 0, 6, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('5c9b5622-0c23-d955-759a-0f7b6baeb347', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f036', '07fda52e-5b20-4354-867c-88c8ca18e81f', 'ba2b6ca1-9b52-49ba-abca-9b8c89590471', null, 'ffac7d1a-3e11-4b68-9bb6-e782f926c07b', '5c455df1-6127-44d2-8aa3-69e6b4354054', 'FSYY', '发生原因', 10, null, null, null, null, 36, 2, 0, 6, 5)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('812edeef-ff91-783d-8dce-0afb400aabc2', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f037', '9fc5ffbc-806a-4096-99c5-e5d62ae3cc83', 'ba2b6ca1-9b52-49ba-abca-9b8c89590471', null, '16441837-37c1-4299-a7a8-d3db1e6d6a0b', '619161e4-b922-447d-a415-c9b56ba5b032', 'SWYY1', '死亡原因', 10, null, null, null, null, 37, 2, 0, 6, 5)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c770450f-eb56-8e85-9883-847293d6d173', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f038', '443d84d1-427a-43b5-a1f6-7c07a82d34fb', 'ba2b6ca1-9b52-49ba-abca-9b8c89590471', null, '23eafdcd-25aa-4c90-99d1-6c7f7966a550', 'b50feb19-d251-411b-83d2-9d3de11c663c', 'JYJX', '经验教训', 10, null, null, null, null, 38, 2, 0, 6, 5)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('827d97a3-b1a6-4a40-f510-c7d6ecbf4752', '7579ea16-2b72-0ad7-c088-67067a694de4', 'f039', '1dfb3429-0c0e-443b-a5b9-bc7fcb421098', 'ba2b6ca1-9b52-49ba-abca-9b8c89590471', null, '686d8f1c-ed5c-47cc-aff9-64d4ec5819a2', 'ba8ee5c9-05a7-4075-9106-addae201c905', 'GJCS', '改进措施', 10, null, null, null, null, 39, 2, 0, 6, 5)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_template (id, source_custom_form_id, form_name, business_type, field_count, answer_count, card_count)
values ('e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', '56989666-06ef-423d-8644-3afc3e5d323f', '病例填写', 'case', 39, 780, 20)
on conflict (source_custom_form_id) do update set
    form_name = excluded.form_name,
    business_type = excluded.business_type,
    field_count = excluded.field_count,
    answer_count = excluded.answer_count,
    card_count = excluded.card_count,
    updated_at = now();

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('6df6f71f-a6b2-5327-d9e9-54d8cdc97729', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'case', 'c1174c60-2ef2-45f6-85dd-5269b567f996', '56989666-06ef-423d-8644-3afc3e5d323f', '结构性心脏病介入')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c60c89df-7fea-c755-1737-a67fd4cb5e22', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f001', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, null, '5bbaec13-2c09-42af-830b-3f1badbbc34d', 'e70dc6e2-e296-4382-b674-bcde17d322ed', 'HZJBXX4', '患者基本信息', 1, null, null, null, null, 1, 1, 0, 20, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('0778b12c-f2d6-ef80-6d30-10edca20dbe5', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f002', '1e2fa405-59d4-45da-bc39-32ccb89d56b0', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, '3687a502-f3e2-4349-97a8-741a5318ca39', 'fb956c36-a5e3-4f4b-808f-600f562cdb85', 'BAH', '病案号', 6, null, null, null, null, 2, 2, 0, 20, 20)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e27bdaf6-cd45-d08b-2f1e-433bf40a78c1', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f003', 'a66bd34d-42a1-49d5-a1b7-da99be1217d2', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, '843c4dc1-aaef-4b0d-a1cc-28ca0bd1fdf6', '90b40450-c53d-4270-8ca1-acfbbc7be6a0', 'HZXM', '患者姓名', 6, null, null, null, null, 3, 2, 0, 20, 20)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b5c9f3b9-f135-199e-60e2-51c890107fe4', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f004', '707a32bb-1b6d-41c2-b9ea-d48cdf391a7d', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, '1511d2e2-791e-4bff-ad88-a4f28c3e234f', 'fdabb926-e008-43c5-a4c9-a357c29d2e61', 'XBSEX', '性别', 2, null, '11', null, null, 4, 2, 0, 20, 16)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('5dfd3911-1cd2-6470-6134-be1dcc3af3e1', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f005', 'c158ddc8-e919-4661-93b1-2e545fda952e', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, '33700706-f08b-47da-bd9d-1ce9e5948840', 'ee48aa0a-bdff-43e8-a5f5-1f4ce604ae97', 'NL3', '年龄', 5, null, null, null, '3', 5, 2, 0, 20, 15)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9f62c09e-507d-ddbb-fe28-c58908c25a6e', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f006', '9977e4dd-e88a-4ca0-ba36-fddbeec42d16', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, '4fa876ab-b781-4f3d-8198-98ab803b99dc', 'c92ce23e-5853-4f04-893f-d4dd8a2f59a7', 'PTPaperNumber', '身份证号码', 6, null, null, null, null, 6, 2, 0, 20, 12)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d948812b-88f5-bd58-ae5e-eefb85d69528', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f007', '1f52acec-4bb5-4261-8faf-9710e6bd9cf0', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, '61d166b7-c245-467a-8bb1-ec8b0635a0d7', '4df94be8-dce6-428b-b08d-a17ef3d60883', 'ZYKS', '住院科室', 6, null, null, null, null, 7, 2, 0, 20, 14)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('858e9927-2521-6baf-2f02-74679fd29576', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f008', '12f91291-eed6-434f-b728-e939126d8cab', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, 'a68c720d-ba73-47e5-858f-e15a49666acc', 'debe7a07-b4e0-4d2d-babb-989a9a095f21', 'RYSJ1', '入院时间', 4, null, null, null, 'YYYY-MM-DD', 8, 2, 0, 20, 14)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('de415681-36fe-e019-b133-c03ae4b43434', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f009', 'ed1d8011-f795-42ce-9d26-6e7a5173bd4b', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, '181f7b87-e941-4b6a-af5e-258259211910', 'ce904049-8138-47f0-9533-25f722447142', 'BIDisTime', '出院时间', 4, null, null, null, 'YYYY-MM-DD', 9, 2, 0, 20, 20)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c5daab7b-bd92-b709-badd-a76fa86e242f', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f010', '0f17da69-bc30-49ca-9ccb-1beb3007aa13', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, 'ef255835-8e19-4ded-92ea-f39f5ea91601', 'ff5d81c5-2bd6-434d-b773-85da4cbe0146', '2281', '住院天数', 5, null, null, null, '1', 10, 2, 0, 20, 14)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('fd2cde33-6e66-6d1e-4bdb-8fdce4fbd080', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f011', '732e6a32-af0e-48c9-ab8f-5a0999092a75', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, '44766f7d-a96a-46b1-9493-85d67140404c', '6cd7a897-d08d-4885-8044-4e661f0f6c76', 'SSLX', '手术类型', 2, null, null, null, null, 11, 2, 0, 20, 20)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('dd2271bc-4123-3f14-df21-ab3dcc7a4714', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f012', '1aa81376-b64b-4691-9d15-fbc265371b44', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, 'f40a4ab5-094c-416c-9c6e-f9627d0ec86d', '12a436fe-1484-45c9-8a62-bebc600d933c', 'SZ16', '术者', 2, null, '11', null, null, 12, 2, 0, 20, 20)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e73f32aa-ce27-89ad-9214-a7fb4244a4e5', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f013', '38bdd33b-0962-40ac-9d63-545b3dae1cf4', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, 'c208d2f7-869a-43c1-a009-3d835121f6b3', 'e2f41c2d-2585-4e88-9881-1b0e3520c0ff', 'SFJZJR', '是否急诊介入', 2, false, '11', null, null, 13, 2, 0, 20, 15)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a272fafe-3d46-3f37-29ee-d46185506163', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f014', '6d0e43e7-33c7-4755-955d-89e86b8ed4a0', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, 'a8f2a006-9421-4b89-915f-ab8e5ac400a6', '4231476c-7398-4c1f-aefd-f05409b00f07', 'PatPFOutCarEveLiveDeaTim', '死亡时间', 4, null, null, null, 'YYYY-MM-DD', 14, 2, 0, 20, 20)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('724c658f-a6fd-1827-63f0-b94c1a481468', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f015', '37dd54a9-b056-4913-b091-ab30fce7c1aa', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, '174c1157-b51c-4107-9839-b07c67b9ee8d', '5d068805-5f25-45f0-a1f5-e9d899c524e1', 'QKSMYYSM', '情况说明/原因说明', 2, null, '1111', null, null, 15, 2, 0, 20, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('625644d4-688f-7d22-b06a-d77b4975232d', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f016', 'b76468ae-3738-4825-ac1d-aa7ade970d6e', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, '6f4debc8-dd17-4948-b61d-5ed088ddeeb6', 'ecafe079-178d-4100-a23b-a14d5d223e7f', 'BCSM', '补充说明', 10, null, null, null, null, 16, 2, 0, 20, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1442df07-61de-62cd-8a12-fe9bbb22f179', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f017', '650896e2-fbf0-402f-aa71-441228f40c9c', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, 'cf9b5f6b-2979-4516-94b8-1072c8c91dbe', '15cb99eb-ad41-45f8-99b8-953ff96edabd', 'LYFS', '离院方式', 6, null, null, null, null, 17, 2, 0, 20, 9)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('fcd47722-d4f0-49c9-c72d-8a23f79b86fc', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f018', '9d7600b3-e340-4806-82fe-f744e4357dad', '4a3514a2-47e4-4e53-97fc-dc856887dff1', null, 'b52d08be-eedb-4a7c-8fef-12b4d9791f0c', '03644ac1-6477-4607-885b-752e80efb43a', 'JGXXZBJR', '结构性心脏病介入', 2, null, '11111', null, null, 18, 2, 0, 20, 18)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e403fc31-448e-0993-219d-928985f739a2', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f019', 'a76b5775-b57f-4131-88ff-53eec2555db1', null, null, '46d495f7-7f90-4f5c-8e67-59bcf1f7368b', 'e3066365-96c4-4092-be4e-9d005ea4967a', 'BLZY', '病历摘要', 1, null, null, null, null, 19, 1, 0, 20, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f0058ed8-a357-448d-9f9f-066c0086b3f0', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f020', 'f56befbe-1396-4197-80d4-7e960f075b5c', 'a76b5775-b57f-4131-88ff-53eec2555db1', null, '617f967c-50f2-453b-9982-2910b22fa9f0', '657df21e-89df-47b3-b913-a8395b67593d', 'ZYNR', '摘要内容', 10, null, null, null, null, 20, 2, 0, 20, 20)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('fd5d9766-8bee-4c72-eff7-7175f0dd1752', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f021', '023cf518-1ca9-4a94-bc5c-c88182f3b5cb', null, null, '431ca933-9fbb-4350-b644-31aa020c4f22', '80b2da1c-6185-48e0-a6ba-e0632bd3143f', 'CYZD11', '出院诊断', 1, null, null, null, null, 21, 1, 0, 20, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('cde5be8f-5d17-9a5d-2a28-480feb33655e', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f022', '464d86a3-e905-466b-bccd-13657b25add5', '023cf518-1ca9-4a94-bc5c-c88182f3b5cb', null, '28807860-8482-4047-97ba-83c6c52a98c2', '2825345a-7e21-4b31-a5c5-fd52455d6acc', 'CYZD6', '出院诊断', 10, null, null, null, null, 22, 2, 0, 20, 18)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ed8af6ac-4afa-4557-4366-869396bc01db', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f023', '2f130693-37cd-46b7-bda3-6a55bb56ef8e', null, null, '652df5c2-6ba5-4dac-bb68-e87ebcbcad16', '362c2875-21f8-4ea7-8d3a-c9c56027c105', 'XGSYSJC', '相关实验室检查', 1, null, null, null, null, 23, 1, 0, 20, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f7f524cd-f4eb-a800-57e8-00286abe42a6', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f024', '6d35cdcd-c69a-451f-a20a-f30b5bfb70d0', '2f130693-37cd-46b7-bda3-6a55bb56ef8e', null, '0f6d5e12-d381-4c71-9ba7-1dcdb4608562', 'ad8bd783-1581-4873-af87-e0f1a4d28bc3', 'HYCTPSC', '化验单图片上传', 7, null, null, null, '2', 24, 2, 0, 20, 9)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('725e5a9e-b0c4-67aa-9ea4-efa8a615dd9f', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f025', 'cececc46-0bc6-40c3-9284-6e5162ab32b2', null, null, 'c455d8c7-c3a6-442b-ac59-4236d5f71c79', '50d771ff-5275-4eda-8e3b-f623b31a6d43', 'ZYFZJC', '主要辅助检查', 1, null, null, null, null, 25, 1, 0, 20, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9e2752ba-ad55-bc2d-404c-e1c5c2ec1215', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f026', 'ac7baa15-00b5-4fd1-9791-c37a74792004', 'cececc46-0bc6-40c3-9284-6e5162ab32b2', null, 'c56134f2-a96b-4bfe-995d-99dc08feeb61', '67a54b7e-ee51-497b-812b-f15bead071ba', 'XDTTPSC', '心电图图片上传', 7, null, null, null, '2', 26, 2, 0, 20, 10)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('310caa37-508a-19ef-e87d-40f4341c2920', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f027', '7161945c-d3cf-457c-a140-96b10548effb', 'cececc46-0bc6-40c3-9284-6e5162ab32b2', null, '03321f6b-9f99-4184-8a7e-26b6e4c81d52', 'e45bc10c-731d-4385-914e-e2e879667476', 'XZCC', '心脏彩超', 7, null, null, null, '2', 27, 2, 0, 20, 12)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('46e60199-f398-d582-e05d-4500a1d7080e', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f028', '7b052c19-17da-43c2-8934-ceee93ee582d', 'cececc46-0bc6-40c3-9284-6e5162ab32b2', null, '8adc2563-9f51-4b10-af5d-9f5f62155388', '78e1e71f-4710-4468-8aec-b4b6d423db0f', 'JTJC5', '其他检查', 10, null, null, null, null, 28, 2, 0, 20, 5)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('dae0712f-a385-44fd-f653-0ab7a184f53e', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f029', '1639eb6f-928a-4349-a800-67874adef1cf', null, null, '2d8cc761-d73f-420b-a209-bbbd4198768a', '6dbb0198-09a2-4319-80b7-57a256eda3db', 'JRZLQK', '介入诊疗情况', 1, null, null, null, null, 29, 1, 0, 20, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2c26c071-e270-ae5f-0efe-f019d2efb1b8', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f030', '5d6e57ed-f221-41fd-bcea-6901463f0251', '1639eb6f-928a-4349-a800-67874adef1cf', null, '79f64129-3546-42bb-82bb-27bc31d6b800', 'a26514f5-d54a-4f4d-ab31-8adbc20a1ab0', 'ZYJCJG', '造影检查结果', 10, null, null, null, null, 30, 2, 0, 20, 15)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('5d343b86-dc15-3cbe-a852-1f68d82c27c4', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f031', '5970210c-6cfd-4c54-a8ee-3ab21193a00f', '1639eb6f-928a-4349-a800-67874adef1cf', null, 'e6fc9b3f-fcef-4628-b389-e1ba0f6dff9c', 'dc123a9f-28a9-4c75-924f-0d12a45caf32', 'JRJG', '介入经过', 10, null, null, null, null, 31, 2, 0, 20, 18)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('669aac5d-59be-c58f-b2b6-4c9b48e4fcec', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f032', 'e5ad54a1-f5af-4cde-a0e6-5b74fa2036e7', null, null, 'bf93e126-76fb-4f04-8838-0cfde818dc20', '189f5677-1b27-4a54-9230-50420997a66e', 'BFZJZQK', '并发症救治情况', 1, null, null, null, null, 32, 1, 0, 20, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('836629de-5eda-4e77-65d8-7fd0908297bd', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f033', '015317b0-abbb-4842-92e6-3a33216b43a1', 'e5ad54a1-f5af-4cde-a0e6-5b74fa2036e7', null, '06174b64-189b-4830-935a-c6855128e41f', '380a1de6-b897-4fbe-a135-8791f522552f', 'JZJG', '救治经过', 10, null, null, null, null, 33, 2, 0, 20, 19)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c31ac454-6d6a-2854-1af6-319b0881e284', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f034', '705b282b-f6e4-4250-b578-9ec669d50614', null, null, '61c06ea1-9679-46f6-9273-b7572f33a26a', '16221b8d-a020-4c15-9291-9eafc8117261', 'BFZTLJL', '并发症讨论结论', 1, null, null, null, null, 34, 1, 0, 20, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('436bc4e5-d9f8-1a15-0aad-ecb38432e190', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f035', 'b6c4e39d-91e6-428a-9aee-1b58dc9c49a7', '705b282b-f6e4-4250-b578-9ec669d50614', null, '68215436-63a1-467c-b024-49e44572b2cc', 'f33e9038-eb44-40ff-8b57-5877ea64ef80', 'SFZZYYHKSBFZTL', '是否组织医院或科室并发症讨论', 2, null, '11', null, null, 35, 2, 0, 20, 19)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('512b4f31-aa63-6143-d743-205e2f3f8f25', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f036', 'db57d0c2-fc07-47d2-b059-333a1a267e9e', '705b282b-f6e4-4250-b578-9ec669d50614', null, 'ffac7d1a-3e11-4b68-9bb6-e782f926c07b', 'cd06d4c2-ebb7-492e-be04-887ff78bf74a', 'FSYY', '发生原因', 10, null, null, null, null, 36, 2, 0, 20, 14)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('22c299b7-d951-b443-3ddc-706c398e863e', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f037', '7c677e8c-b6a4-4978-bee9-8ee5c365264b', '705b282b-f6e4-4250-b578-9ec669d50614', null, '16441837-37c1-4299-a7a8-d3db1e6d6a0b', '1f1a93a1-c3bc-4bc0-b626-75641f60ad13', 'SWYY1', '死亡原因', 10, null, null, null, null, 37, 2, 0, 20, 14)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('70a24286-d6b9-a9a6-ebd6-4cd7eadd641d', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f038', '3f58a9c5-064a-400f-8a1e-1af39bd0d499', '705b282b-f6e4-4250-b578-9ec669d50614', null, '23eafdcd-25aa-4c90-99d1-6c7f7966a550', '990ec479-066d-4302-bdd1-0bfee636ba5b', 'JYJX', '经验教训', 10, null, null, null, null, 38, 2, 0, 20, 14)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('18cb30a8-b2d3-0194-53a5-b3ddc9e7cee5', 'e6532e5d-0e96-4d18-e9f5-ad2f42c12ffa', 'f039', 'c539a357-c604-470d-82d0-2a6c653009ee', '705b282b-f6e4-4250-b578-9ec669d50614', null, '686d8f1c-ed5c-47cc-aff9-64d4ec5819a2', '4ebaf09e-a562-4015-80d2-576adaba65b3', 'GJCS', '改进措施', 10, null, null, null, null, 39, 2, 0, 20, 14)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_template (id, source_custom_form_id, form_name, business_type, field_count, answer_count, card_count)
values ('580821ed-cb81-5c1a-8934-f21e67b02091', '736806dd-5df7-48a6-916b-56095f71edfd', '病例填写', 'case', 38, 900, 24)
on conflict (source_custom_form_id) do update set
    form_name = excluded.form_name,
    business_type = excluded.business_type,
    field_count = excluded.field_count,
    answer_count = excluded.answer_count,
    card_count = excluded.card_count,
    updated_at = now();

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('4ea2d7ef-0b9f-3fd8-e985-07d5d80f07ae', '580821ed-cb81-5c1a-8934-f21e67b02091', 'case', 'f827ae4a-f24f-4df9-b92f-7601025a1864', '736806dd-5df7-48a6-916b-56095f71edfd', '起搏器及CIED植入/置换')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c057f980-ce42-ef2c-14bf-b8520d69ed1c', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f001', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, null, '5bbaec13-2c09-42af-830b-3f1badbbc34d', '6da504ad-9469-42c1-afc8-825d78f1a87d', 'HZJBXX4', '患者基本信息', 1, null, null, null, null, 1, 1, 0, 24, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c4c42d62-62ec-d35d-78f5-d660beae3c44', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f002', '00aabb5f-495e-40d6-a28b-ef1c85e9bbfe', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, '3687a502-f3e2-4349-97a8-741a5318ca39', '60505580-bdb6-42a5-af02-4058e34dc495', 'BAH', '病案号', 6, null, null, null, null, 2, 2, 0, 24, 24)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b5ef428d-ef23-1790-4102-fc2eddb2903a', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f003', '0aae1b49-ec73-43cb-8198-bc08bdf3fbd8', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, '843c4dc1-aaef-4b0d-a1cc-28ca0bd1fdf6', '8327f857-6000-4ff7-9664-dee26e2580f0', 'HZXM', '患者姓名', 6, null, null, null, null, 3, 2, 0, 24, 24)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6e2d6d63-ee25-3609-9c00-a7a86944e520', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f004', 'f741493b-54f4-4460-93e9-55facc8caa2f', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, '1511d2e2-791e-4bff-ad88-a4f28c3e234f', 'ba3287e7-2403-4c08-b521-a52cc1ba3d71', 'XBSEX', '性别', 2, null, '11', null, null, 4, 2, 0, 24, 23)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('177247f1-9c4c-90b0-1142-f6658797f40b', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f005', '222aaf93-4f83-4ed1-b947-7e3157a97d85', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, '33700706-f08b-47da-bd9d-1ce9e5948840', '0a97c8a0-d3f3-4694-9652-f574ac44cade', 'NL3', '年龄', 5, null, null, null, '3', 5, 2, 0, 24, 23)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7b508037-5399-837d-6401-6b28563e17a6', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f006', '781ab6f4-aae1-4f1d-bce3-e33837d66b92', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, '4fa876ab-b781-4f3d-8198-98ab803b99dc', '9e5e8fdf-05c8-4165-84cd-ba203cfb1f0f', 'PTPaperNumber', '身份证号码', 6, null, null, null, null, 6, 2, 0, 24, 18)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7b1be47d-8445-3715-2b4f-802e0fa60402', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f007', '413ebff1-3f08-44d0-a0c9-9159cdd7b55a', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, '61d166b7-c245-467a-8bb1-ec8b0635a0d7', '744b864b-355e-40ed-a4d9-56ce2023c1d5', 'ZYKS', '住院科室', 6, null, null, null, null, 7, 2, 0, 24, 21)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f4fef099-f799-e3bf-de21-95af7f548f94', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f008', 'd1a5392c-7a7c-440a-b69c-0d82e998cbef', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, 'a68c720d-ba73-47e5-858f-e15a49666acc', 'f28a54bc-14f1-4047-a432-ab04c822b9dc', 'RYSJ1', '入院时间', 4, null, null, null, 'YYYY-MM-DD', 8, 2, 0, 24, 23)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d2c6903e-6bce-d186-10d2-412a85225f88', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f009', '2d9a1278-c197-4f16-9671-48d90b74d779', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, '181f7b87-e941-4b6a-af5e-258259211910', '10e4d588-fe98-40b6-bcb2-eecea0939470', 'BIDisTime', '出院时间', 4, null, null, null, 'YYYY-MM-DD', 9, 2, 0, 24, 24)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1a8b7687-46d0-7072-0fe2-d51736c1766f', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f010', '2d2dc2bd-f94d-4d97-aa60-27b6c3f4f341', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, 'ef255835-8e19-4ded-92ea-f39f5ea91601', '48a45203-813c-4524-8336-38791b6d4be7', '2281', '住院天数', 5, null, null, null, '1', 10, 2, 0, 24, 23)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f4448e0b-8b1e-51b1-1ff8-311928507224', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f011', '1515c02b-7fe8-4da9-a1f9-ac785c4ae697', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, '44766f7d-a96a-46b1-9493-85d67140404c', 'f89890fd-5c0c-4951-863b-01478b35facb', 'SSLX', '手术类型', 2, null, '1111', null, null, 11, 2, 0, 12, 12)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('12d644b1-82ea-6c3a-2921-68cc83443f9d', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f012', '0b6f73cf-adff-4f8b-b46f-1fbc98128476', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, 'f40a4ab5-094c-416c-9c6e-f9627d0ec86d', 'a9970413-8ddf-40d9-a7c7-91ccafbe8cf2', 'SZ16', '术者', 2, null, '11', null, null, 12, 2, 0, 24, 24)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('60c31e61-6f75-67db-9560-5b4221f96356', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f013', 'e7fd9780-ef2a-419d-a81d-23a5e2ac7b4c', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, 'c208d2f7-869a-43c1-a009-3d835121f6b3', '5902a075-ae6c-49e6-b951-0736ed3041f2', 'SFJZJR', '是否急诊介入', 2, false, '11', null, null, 13, 2, 0, 24, 23)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('04b32c61-ea5c-df04-0be3-93857684eefe', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f014', '51bcf335-5a43-4514-85e8-3cfb00124f7a', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, 'a8f2a006-9421-4b89-915f-ab8e5ac400a6', '2704a45d-5851-4b45-9025-17ac6bb370fc', 'PatPFOutCarEveLiveDeaTim', '死亡时间', 4, null, null, null, 'YYYY-MM-DD', 14, 2, 0, 24, 24)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('499dc6a2-5f21-33d7-401e-283b7fcb39e8', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f015', '51932eea-d211-49d9-924b-e672bb666839', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, '174c1157-b51c-4107-9839-b07c67b9ee8d', '37c382a4-53f1-4f4d-93e3-c05aa8fcb86b', 'QKSMYYSM', '情况说明/原因说明', 2, null, '1111', null, null, 15, 2, 0, 24, 13)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e5c73120-dd23-c8e9-aaa2-b65a9e10ba32', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f016', 'b48b9842-a2ad-49ce-a422-aa1bf44c7489', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, '6f4debc8-dd17-4948-b61d-5ed088ddeeb6', '707577cd-d294-4fb0-a26a-d2a450343a9f', 'BCSM', '补充说明', 10, null, null, null, null, 16, 2, 0, 24, 11)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('689559e6-2e86-2d1c-093a-26baecd06eef', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f017', 'c7ec19be-fa06-4803-a597-05a4d18b06ca', '7825658c-b1d1-4ffa-af02-c742db87a2e9', null, 'cf9b5f6b-2979-4516-94b8-1072c8c91dbe', '45543bb6-a81e-415f-9997-378d378cf2d1', 'LYFS', '离院方式', 6, null, null, null, null, 17, 2, 0, 24, 23)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6ecb960f-3c9f-c4e1-0f27-874d6a538f3b', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f018', 'e482d6c7-b00e-492e-b593-b7f84be29905', null, null, '46d495f7-7f90-4f5c-8e67-59bcf1f7368b', '81455333-7567-4676-bfca-8c3724e24430', 'BLZY', '病历摘要', 1, null, null, null, null, 18, 1, 0, 24, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('fe1d636e-d8e7-5260-2784-91289e211956', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f019', '4e2bd8d3-9948-4995-87e9-dcfde58c98b4', 'e482d6c7-b00e-492e-b593-b7f84be29905', null, '617f967c-50f2-453b-9982-2910b22fa9f0', 'e8c9aa56-af55-4a19-ada1-d8fce62369e1', 'ZYNR', '摘要内容', 10, null, null, null, null, 19, 2, 0, 24, 23)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('438c1612-0fb6-25c9-d2fe-b522ef11e094', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f020', 'e40ded1c-b393-4c71-b289-294f041850d8', null, null, '431ca933-9fbb-4350-b644-31aa020c4f22', '2fe46dcd-abbc-40f2-8335-5b063f53cd5f', 'CYZD11', '出院诊断', 1, null, null, null, null, 20, 1, 0, 24, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ad568a77-aeb0-0cd9-7540-522aa4b40426', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f021', '9d016945-d884-4784-820b-43790fbb8d7f', 'e40ded1c-b393-4c71-b289-294f041850d8', null, '28807860-8482-4047-97ba-83c6c52a98c2', '5b48d0ac-bf65-43d3-aaf6-1f24efb09fc5', 'CYZD6', '出院诊断', 10, null, null, null, null, 21, 2, 0, 24, 21)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2f187c53-4f4a-1980-ddfc-594c8142b068', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f022', 'd0e11acb-cee8-4cdd-a420-d6c012e2573a', null, null, '652df5c2-6ba5-4dac-bb68-e87ebcbcad16', '62563172-5ff7-4b50-89a5-2cff2906b9c9', 'XGSYSJC', '相关实验室检查', 1, null, null, null, null, 22, 1, 0, 24, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('976a1967-f25b-6156-c468-fae1802654b6', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f023', 'dd12a09e-d29e-498e-b927-5a62e78bf8d3', 'd0e11acb-cee8-4cdd-a420-d6c012e2573a', null, '0f6d5e12-d381-4c71-9ba7-1dcdb4608562', '908affb0-b04f-4f05-b63d-965fea416ae8', 'HYCTPSC', '化验单图片上传', 7, null, null, null, '2', 23, 2, 0, 24, 17)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9ff59a8f-ebbb-6767-d39d-3069e8fa2a28', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f024', '24c2b582-369a-4400-a119-dd02954b6f9f', null, null, 'c455d8c7-c3a6-442b-ac59-4236d5f71c79', '68bc6322-574b-478d-85c4-b429f1b80be8', 'ZYFZJC', '主要辅助检查', 1, null, null, null, null, 24, 1, 0, 24, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('bce07b1a-b558-847a-f84b-8055356a656e', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f025', '726e22a7-7925-4145-8e22-9ab95f959f9a', '24c2b582-369a-4400-a119-dd02954b6f9f', null, 'c56134f2-a96b-4bfe-995d-99dc08feeb61', '153ad941-5f2f-4ea6-acd3-504a6f9e8474', 'XDTTPSC', '心电图图片上传', 7, null, null, null, '2', 25, 2, 0, 24, 20)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('84323169-0e1d-b5af-189d-f7d8427df430', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f026', '42c10c20-c6fa-4696-8c7e-2213d78fae91', '24c2b582-369a-4400-a119-dd02954b6f9f', null, '03321f6b-9f99-4184-8a7e-26b6e4c81d52', '24cf6f42-ff6d-4988-9f60-ce2fea35be50', 'XZCC', '心脏彩超', 7, null, null, null, '2', 26, 2, 0, 24, 19)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9bbd93e5-11fc-73e2-3bef-737bb39f1a86', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f027', '5c220eb8-3856-4f4f-807b-a2f8b82c995d', '24c2b582-369a-4400-a119-dd02954b6f9f', null, '8adc2563-9f51-4b10-af5d-9f5f62155388', '934ead41-07cb-42cc-9346-b7ae4a7b1e72', 'JTJC5', '其他检查', 10, null, null, null, null, 27, 2, 0, 24, 6)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d36cf5d6-6930-2d6f-b8d9-13b13881f615', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f028', '0badb28b-9042-432c-98e3-2f4eb04b81fb', null, null, '2d8cc761-d73f-420b-a209-bbbd4198768a', '6f17f9ed-227e-4b92-a47a-b05c184d587b', 'JRZLQK', '介入诊疗情况', 1, null, null, null, null, 28, 1, 0, 24, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d59eb6e4-6bc5-1c1b-f2d9-c664021618d0', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f029', 'deeec696-406a-4871-be00-193d1ecb001f', '0badb28b-9042-432c-98e3-2f4eb04b81fb', null, '79f64129-3546-42bb-82bb-27bc31d6b800', 'b44cf360-7e84-4495-b113-26c28efd2ca8', 'ZYJCJG', '造影检查结果', 10, null, null, null, null, 29, 2, 0, 24, 10)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1f23b75b-03a7-63f1-72f3-7fa3eb27b967', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f030', '05e47e4a-a38b-473a-9dc0-6b740d66b3fb', '0badb28b-9042-432c-98e3-2f4eb04b81fb', null, 'e6fc9b3f-fcef-4628-b389-e1ba0f6dff9c', 'b8c40537-5dc5-407e-91d9-4f9b472246a9', 'JRJG', '介入经过', 10, null, null, null, null, 30, 2, 0, 24, 18)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b5015f94-d506-0699-9398-274c59ddd324', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f031', '233583be-1c21-42e3-89b4-16f57bf2af77', null, null, 'bf93e126-76fb-4f04-8838-0cfde818dc20', '428995d1-00c3-4af1-8bd7-fe189b6a2729', 'BFZJZQK', '并发症救治情况', 1, null, null, null, null, 31, 1, 0, 24, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('728e4fb1-57c7-8cc7-dee4-7a93f012f868', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f032', 'a8030500-1656-4589-bfeb-ee955adc074a', '233583be-1c21-42e3-89b4-16f57bf2af77', null, '06174b64-189b-4830-935a-c6855128e41f', '45c15ebb-34b5-4ef2-90c2-88b97c1dcefc', 'JZJG', '救治经过', 10, null, null, null, null, 32, 2, 0, 24, 22)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('32c26b75-14e4-4c8d-147b-d714ac26ce56', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f033', '6b909b5b-ea09-488b-93b0-0f668326e2f2', null, null, '61c06ea1-9679-46f6-9273-b7572f33a26a', 'f2af06d2-3f26-488a-9794-91a34c06e4ab', 'BFZTLJL', '并发症讨论结论', 1, null, null, null, null, 33, 1, 0, 24, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a3f2b1b0-2b8c-e937-379c-ff05b394a2ce', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f034', '19bd09b9-b021-44a6-84ee-f2db842d7d6c', '6b909b5b-ea09-488b-93b0-0f668326e2f2', null, '68215436-63a1-467c-b024-49e44572b2cc', 'c793fe69-a921-4256-aabd-051465cc650c', 'SFZZYYHKSBFZTL', '是否组织医院或科室并发症讨论', 2, null, '11', null, null, 34, 2, 0, 24, 22)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('5158f19b-091c-83d2-50f6-46ff049f852a', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f035', '6ea93457-2730-45b1-a495-a5535a86eb07', '6b909b5b-ea09-488b-93b0-0f668326e2f2', null, 'ffac7d1a-3e11-4b68-9bb6-e782f926c07b', 'aca23ded-8428-48e1-837a-e75071484533', 'FSYY', '发生原因', 10, null, null, null, null, 35, 2, 0, 24, 19)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('5de3bd73-a274-b6b7-ebf9-1f7ed5177d87', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f036', '713a1981-5848-4b0c-948e-196d8c366d4e', '6b909b5b-ea09-488b-93b0-0f668326e2f2', null, '16441837-37c1-4299-a7a8-d3db1e6d6a0b', '1ea8427c-1da6-4f38-a8cc-6685d3d68632', 'SWYY1', '死亡原因', 10, null, null, null, null, 36, 2, 0, 24, 19)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7f5414e5-da6f-fd0c-12bc-d1388e55ccaf', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f037', '53eb4fed-3e0f-40cf-ad17-185e2a3a5827', '6b909b5b-ea09-488b-93b0-0f668326e2f2', null, '23eafdcd-25aa-4c90-99d1-6c7f7966a550', 'ab44f78f-0a3b-42d3-a734-31bca4ff97bc', 'JYJX', '经验教训', 10, null, null, null, null, 37, 2, 0, 24, 18)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('4f4a243a-0fba-1321-b7a3-898c7710c0c4', '580821ed-cb81-5c1a-8934-f21e67b02091', 'f038', '483b3362-a966-4b95-886a-3fc2be5bb913', '6b909b5b-ea09-488b-93b0-0f668326e2f2', null, '686d8f1c-ed5c-47cc-aff9-64d4ec5819a2', 'fd503f15-88b9-40c6-b6eb-1a51623e892d', 'GJCS', '改进措施', 10, null, null, null, null, 38, 2, 0, 24, 18)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_template (id, source_custom_form_id, form_name, business_type, field_count, answer_count, card_count)
values ('2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'bccfcbc5-67b2-4520-aa49-184d07c3346a', '病例填写', 'case', 39, 50823, 1307)
on conflict (source_custom_form_id) do update set
    form_name = excluded.form_name,
    business_type = excluded.business_type,
    field_count = excluded.field_count,
    answer_count = excluded.answer_count,
    card_count = excluded.card_count,
    updated_at = now();

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('8192107a-2881-2153-962a-8fefea17ecab', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'case', '6237dd62-15b9-4676-972d-bf32476b3546', 'bccfcbc5-67b2-4520-aa49-184d07c3346a', '冠心病介入')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2f93a36e-6f9b-87d2-3618-89b0ef6e1ab9', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f001', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, null, '5bbaec13-2c09-42af-830b-3f1badbbc34d', '4a2499cc-07f9-4cd8-9ab0-2ffdf96e060f', 'HZJBXX4', '患者基本信息', 1, null, null, null, null, 1, 1, 0, 1307, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('0f6002d4-bcfa-817e-7063-edbe779cec37', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f002', '59cf2202-731f-408f-a44f-27af03bdff31', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, '3687a502-f3e2-4349-97a8-741a5318ca39', '2a1b52fd-67e3-489e-94b2-668b992564c3', 'BAH', '病案号', 6, null, null, null, null, 2, 2, 0, 1307, 1307)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1ad8c26e-e8ab-09de-c20b-676ef310fae6', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f003', '563cbde4-4fa2-4e94-afca-5817e0ca57d9', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, '843c4dc1-aaef-4b0d-a1cc-28ca0bd1fdf6', 'e2563203-fe78-415e-9bf5-3e820d264866', 'HZXM', '患者姓名', 6, null, null, null, null, 3, 2, 0, 1307, 1307)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2f1cccd9-53f1-f9b0-90ab-0849fefbe778', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f004', '4ee3d753-d389-47a8-b758-0777216b43a9', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, '1511d2e2-791e-4bff-ad88-a4f28c3e234f', '07ec50e4-cc5b-42f5-93cf-9dcfb0d8afe2', 'XBSEX', '性别', 2, null, '11', null, null, 4, 2, 0, 1307, 1240)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1313f790-d62d-738e-239c-363eb8f21976', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f005', '6ae469ae-5aa5-4a35-8f29-d7bb2de9d219', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, '33700706-f08b-47da-bd9d-1ce9e5948840', '3a2c15f1-7acc-4a42-b61b-985fa7495000', 'NL3', '年龄', 5, null, null, null, '3', 5, 2, 0, 1307, 1205)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6b26dc25-37eb-81f3-3ccc-dbd7884d7169', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f006', '72cfcef9-6a01-40d1-bcea-88373004a60a', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, '4fa876ab-b781-4f3d-8198-98ab803b99dc', '673ad025-21ee-45fb-a057-143d1ae18633', 'PTPaperNumber', '身份证号码', 6, null, null, null, null, 6, 2, 0, 1307, 927)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('edb9f0c1-90a7-1dba-e2c4-3337e9847db3', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f007', '363523d6-d339-417d-9d80-6ab51d02f8bd', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, '61d166b7-c245-467a-8bb1-ec8b0635a0d7', '70e3a596-f88b-42ec-b8f3-91c0e2e1a501', 'ZYKS', '住院科室', 6, null, null, null, null, 7, 2, 0, 1307, 1054)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d62dab87-b4ce-e5c8-4286-4b11805a5c55', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f008', 'acb7708b-a564-4920-a874-19c619b4eb39', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, 'a68c720d-ba73-47e5-858f-e15a49666acc', '1105cdb4-5dff-446d-aeff-3c12a42b38e3', 'RYSJ1', '入院时间', 4, null, null, null, 'YYYY-MM-DD', 8, 2, 0, 1307, 1186)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f53cdecd-3f31-aaba-6171-401fdb8c892f', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f009', '0bf88467-8b36-4c54-87e9-f00bcf19a349', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, '181f7b87-e941-4b6a-af5e-258259211910', '38e93590-f7cc-4619-a726-7360cde4c2f7', 'BIDisTime', '出院时间', 4, null, null, null, 'YYYY-MM-DD', 9, 2, 0, 1307, 1307)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e0719384-1351-2193-3f4c-7d5bcf4e448d', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f010', '2bcdc107-db3a-46d3-9ac5-c96bdeb8a438', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, 'ef255835-8e19-4ded-92ea-f39f5ea91601', '9b918c3f-d6ec-4c8a-a219-1cca5e27cdcb', '2281', '住院天数', 5, null, null, null, '1', 10, 2, 0, 1307, 1186)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('389aa525-0a10-6c37-c288-6c6441f90403', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f011', '05fc97e0-e1bf-4f70-bf3b-9eff987688f4', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, '44766f7d-a96a-46b1-9493-85d67140404c', 'd084e0b1-82cb-4212-bb54-a03f4698b660', 'SSLX', '手术类型', 2, null, '1111', null, null, 11, 2, 0, 1157, 1157)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('8573a85e-3a6a-c2b3-7d2a-892db44bc89c', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f012', '4425006b-2641-4418-84c7-6b956d3cb42d', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, 'f40a4ab5-094c-416c-9c6e-f9627d0ec86d', '722e6f60-7ee8-46fc-be5d-1db439b7ffc7', 'SZ16', '术者', 2, null, '11', null, null, 12, 2, 0, 1307, 1307)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('09e9f661-e8a1-479f-80ab-f7da48d5352b', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f013', 'e7e387da-b5db-4b5a-b5ca-bdcd8c042c82', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, 'c208d2f7-869a-43c1-a009-3d835121f6b3', '7210e4dc-8a64-470f-8f6b-fc1845538642', 'SFJZJR', '是否急诊介入', 2, false, '11', null, null, 13, 2, 0, 1307, 1212)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1de72a02-a54e-f26a-97b9-ae3201c2d030', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f014', '51118766-3f00-4ed0-9a08-02303d34c423', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, 'a8f2a006-9421-4b89-915f-ab8e5ac400a6', 'd6ef1ef4-d572-44ce-8a0f-bfc8e64747bc', 'PatPFOutCarEveLiveDeaTim', '死亡时间', 4, null, null, null, 'YYYY-MM-DD', 14, 2, 0, 1307, 1307)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ec04cfc6-1858-d347-034e-58bf47dd92bc', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f015', '35b7e028-a080-44f9-b8ed-bfda42c70719', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, '174c1157-b51c-4107-9839-b07c67b9ee8d', '309162f3-7693-4b66-acdf-b29c6a6ab63d', 'QKSMYYSM', '情况说明/原因说明', 2, null, '1111', null, null, 15, 2, 0, 1307, 337)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('129a4413-408d-870f-3fea-617fc0db2e1e', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f016', '4b6662d3-660a-4177-8a8a-65884b7a377f', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, '6f4debc8-dd17-4948-b61d-5ed088ddeeb6', '7d4858a3-3cab-45ed-b531-918aaa4a3512', 'BCSM', '补充说明', 10, null, null, null, null, 16, 2, 0, 1307, 216)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3422b2e5-d868-f057-a5e8-63192c75ab01', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f017', '7ced22be-e327-4327-a5d9-f8b8de49be52', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, 'cf9b5f6b-2979-4516-94b8-1072c8c91dbe', 'dd5931fe-3b45-47c5-be32-a40fe49d2f9f', 'LYFS', '离院方式', 6, null, null, null, null, 17, 2, 0, 1307, 1300)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e37bf771-0e89-38bd-c1fb-7ba64a8338fd', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f018', '61173bdb-742c-4cf4-a005-ed8e4b229138', 'b0a55185-0296-4ec7-bfef-685d5a049933', null, 'dacc9197-1fc3-46a3-baa9-72749234fbe0', 'f64e4d78-8072-4110-ad7a-3f8c83581a2a', 'GXBJR', '冠心病介入', 2, null, '111', null, null, 18, 2, 0, 1307, 1179)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('5a27fe8c-d4f7-2fa2-2506-d56c79172042', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f019', 'a910dc35-b639-4961-b89a-03aaf7e389f0', null, null, '46d495f7-7f90-4f5c-8e67-59bcf1f7368b', '4890de52-1732-46f9-a4dd-ad08d668f920', 'BLZY', '病历摘要', 1, null, null, null, null, 19, 1, 0, 1307, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('234186a3-ba33-b2c4-7df1-a32405564bc6', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f020', '868b6c27-b2dc-4a20-8207-dfda7d309cda', 'a910dc35-b639-4961-b89a-03aaf7e389f0', null, '617f967c-50f2-453b-9982-2910b22fa9f0', '49a00910-1e89-40e6-8b40-5fa48bf9c04d', 'ZYNR', '摘要内容', 10, null, null, null, null, 20, 2, 0, 1307, 1283)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('48e54f44-cdda-7540-48f0-603100b2bb03', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f021', '057f9c83-32f0-4081-b2e0-d5877650afd6', null, null, '431ca933-9fbb-4350-b644-31aa020c4f22', '70581b0d-4bec-4555-bad5-1b5109a000fe', 'CYZD11', '出院诊断', 1, null, null, null, null, 21, 1, 0, 1307, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('cd128d2f-1138-98a6-d61a-2b3de7890ccd', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f022', '2424f668-a9b2-479c-8e16-76ac60c8a973', '057f9c83-32f0-4081-b2e0-d5877650afd6', null, '28807860-8482-4047-97ba-83c6c52a98c2', '4f93d592-7994-4def-805f-53ba4a7070b5', 'CYZD6', '出院诊断', 10, null, null, null, null, 22, 2, 0, 1307, 1247)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('62a37bf5-06de-77b6-59f7-5b9e912f4912', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f023', '57ee2a0c-f64e-416c-a931-20f831c8b5e5', null, null, '652df5c2-6ba5-4dac-bb68-e87ebcbcad16', '3c9281df-0e1e-4587-8826-9a8a2bcd799d', 'XGSYSJC', '相关实验室检查', 1, null, null, null, null, 23, 1, 0, 1307, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('50fe8e15-0e74-7d27-5e6b-2c715513ac8a', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f024', '05596389-c7a2-433d-b9e9-6cda47788acc', '57ee2a0c-f64e-416c-a931-20f831c8b5e5', null, '0f6d5e12-d381-4c71-9ba7-1dcdb4608562', '56fd665a-c653-497f-bffa-94a41cd1c927', 'HYCTPSC', '化验单图片上传', 7, null, null, null, '2', 24, 2, 0, 1307, 734)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('357e338b-3197-c6b8-3ea3-da190be48195', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f025', 'a683176f-de95-4913-9174-9868f920d6be', null, null, 'c455d8c7-c3a6-442b-ac59-4236d5f71c79', 'e1b28c97-8858-463c-af34-0eb8e831331e', 'ZYFZJC', '主要辅助检查', 1, null, null, null, null, 25, 1, 0, 1307, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ac08294a-65f1-e657-60e2-8768e6faebe8', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f026', '68d76348-ce75-4b55-b477-28fb2a55c013', 'a683176f-de95-4913-9174-9868f920d6be', null, 'c56134f2-a96b-4bfe-995d-99dc08feeb61', '08989cd8-5187-4e10-a10b-6913e5cdffbf', 'XDTTPSC', '心电图图片上传', 7, null, null, null, '2', 26, 2, 0, 1307, 964)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ba85cae2-728a-557f-7b82-1241dc8048d9', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f027', 'b622c34a-e7da-420f-a6ab-37ecd04f5bd5', 'a683176f-de95-4913-9174-9868f920d6be', null, '03321f6b-9f99-4184-8a7e-26b6e4c81d52', '6b62b0d1-8a12-46e0-b4ef-395a3ea2b512', 'XZCC', '心脏彩超', 7, null, null, null, '2', 27, 2, 0, 1307, 735)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b1c0f903-6622-fc31-bdd0-e79c192b5ee7', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f028', '5e83f7d8-5145-4a7e-829c-c197cb836e9e', 'a683176f-de95-4913-9174-9868f920d6be', null, '8adc2563-9f51-4b10-af5d-9f5f62155388', '7902a182-46c5-4d99-92a9-18ece61b89e1', 'JTJC5', '其他检查', 10, null, null, null, null, 28, 2, 0, 1307, 179)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3b6fdeef-779f-1e25-6d98-9cb33ee99575', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f029', '5f91dcd1-c796-4c57-9e7a-663a44df5deb', null, null, '2d8cc761-d73f-420b-a209-bbbd4198768a', 'f4ab8f6c-b8fd-4689-9060-9dceaaa22171', 'JRZLQK', '介入诊疗情况', 1, null, null, null, null, 29, 1, 0, 1307, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6cf6c512-fa23-1857-62b5-52e20ea2993a', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f030', '96039d83-8878-4d3e-85f7-88eb3efd8458', '5f91dcd1-c796-4c57-9e7a-663a44df5deb', null, '79f64129-3546-42bb-82bb-27bc31d6b800', '8e54f43a-0a33-4494-9294-e03abf81d695', 'ZYJCJG', '造影检查结果', 10, null, null, null, null, 30, 2, 0, 1307, 1199)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b40cce5b-53ef-3da4-056d-a5b0e49cc787', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f031', 'f6a1fc58-175a-48bb-b283-93c984b947a7', '5f91dcd1-c796-4c57-9e7a-663a44df5deb', null, 'e6fc9b3f-fcef-4628-b389-e1ba0f6dff9c', 'ddb6874a-e29b-4420-b7c5-357c49b954b2', 'JRJG', '介入经过', 10, null, null, null, null, 31, 2, 0, 1307, 1174)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e71a0d85-19fb-a1af-d9f0-ac130f4bc1d9', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f032', '993d053f-4fc5-4ab0-aebc-87f29cdbb3b9', null, null, 'bf93e126-76fb-4f04-8838-0cfde818dc20', '711d408a-acb3-472a-8a04-9a5d4970738e', 'BFZJZQK', '并发症救治情况', 1, null, null, null, null, 32, 1, 0, 1307, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('60c5e5f8-198d-7806-3389-02260907baa8', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f033', 'dff6dc51-149f-48c5-aa3b-3789a3532b11', '993d053f-4fc5-4ab0-aebc-87f29cdbb3b9', null, '06174b64-189b-4830-935a-c6855128e41f', '8da0d309-0b5e-49b9-988e-6487c8fa3453', 'JZJG', '救治经过', 10, null, null, null, null, 33, 2, 0, 1307, 1250)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('63a394a2-5882-d21c-51ec-0d76711271f0', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f034', '03ecd7c5-f6f2-4318-a8b2-0272543e47a1', null, null, '61c06ea1-9679-46f6-9273-b7572f33a26a', '69fc9004-5653-4870-9674-7e6703fe832c', 'BFZTLJL', '并发症讨论结论', 1, null, null, null, null, 34, 1, 0, 1307, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('20a99178-e130-1ae5-8986-20a244801ed6', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f035', '621fc4fc-4123-4d92-99c3-a899f4aa65ca', '03ecd7c5-f6f2-4318-a8b2-0272543e47a1', null, '68215436-63a1-467c-b024-49e44572b2cc', 'ee86f4ff-3cdb-475d-becf-bef683fe603c', 'SFZZYYHKSBFZTL', '是否组织医院或科室并发症讨论', 2, null, '11', null, null, 35, 2, 0, 1307, 1225)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('025d9c1b-19d4-c042-a6ce-1e6ee4838ed8', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f036', 'a4847243-aa43-4ede-9aec-c282cb0a60a5', '03ecd7c5-f6f2-4318-a8b2-0272543e47a1', null, 'ffac7d1a-3e11-4b68-9bb6-e782f926c07b', 'f0978ca6-9bbb-409b-9968-281a7ee7cf3c', 'FSYY', '发生原因', 10, null, null, null, null, 36, 2, 0, 1307, 831)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e18358a4-8841-f028-97be-a0379f05f28d', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f037', 'bfc1776f-4a79-40c3-aa78-534ce3801bf9', '03ecd7c5-f6f2-4318-a8b2-0272543e47a1', null, '16441837-37c1-4299-a7a8-d3db1e6d6a0b', '6ed67a57-b218-4e14-8f88-9bddb7df0df1', 'SWYY1', '死亡原因', 10, null, null, null, null, 37, 2, 0, 1307, 881)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('365167a8-dc99-3897-961d-dedddb3a881a', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f038', '3860d321-e344-4a7f-8fe3-80e6754ad19d', '03ecd7c5-f6f2-4318-a8b2-0272543e47a1', null, '23eafdcd-25aa-4c90-99d1-6c7f7966a550', '01606bbc-931c-48ce-b933-da565342e7bb', 'JYJX', '经验教训', 10, null, null, null, null, 38, 2, 0, 1307, 871)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3695831d-57a2-7724-763f-3cea35b4a473', '2c62b063-79e8-d51b-95d4-6ee54a7682fc', 'f039', '90e8418a-911b-482d-a968-dbf04c4773cf', '03ecd7c5-f6f2-4318-a8b2-0272543e47a1', null, '686d8f1c-ed5c-47cc-aff9-64d4ec5819a2', '17a470df-575e-46d3-83fa-849cf45c1105', 'GJCS', '改进措施', 10, null, null, null, null, 39, 2, 0, 1307, 864)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_template (id, source_custom_form_id, form_name, business_type, field_count, answer_count, card_count)
values ('f1305547-4181-6c3d-36e3-44a2e22304f6', 'b9212f75-f188-4c3c-bb60-1f6b9dc5d86a', '导管消融报表', 'quality', 34, 32844, 966)
on conflict (source_custom_form_id) do update set
    form_name = excluded.form_name,
    business_type = excluded.business_type,
    field_count = excluded.field_count,
    answer_count = excluded.answer_count,
    card_count = excluded.card_count,
    updated_at = now();

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('e371d9d2-5a38-97e6-f194-5649ac9ac5fc', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'quality', 'ae92e4fa-5e02-4d4c-a773-3dc79c4935bc', 'b9212f75-f188-4c3c-bb60-1f6b9dc5d86a', '导管消融')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c3c5c8af-b562-f4e6-bed3-319e95733e08', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f001', 'f7c09624-9505-4671-b558-91fe4790e2d3', null, null, '1143dabf-982d-4d42-93ef-a25fbc13f20f', '6e22c22b-396f-41c9-ac11-33e9e3a5a031', 'GXBJRZL2', '导管消融报表', 1, null, null, null, null, 1, 1, 0, 966, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('8ee80143-b8cb-be3d-e4b6-fdcf9532150e', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f002', '399b22e9-5726-41ca-8493-1f99b663f555', 'f7c09624-9505-4671-b558-91fe4790e2d3', null, 'f2fc2386-7713-4da6-968e-589b1f0f498f', '472548e6-6cd7-4c61-a151-13156977a075', 'HZCYSZYF', '患者出院所在月份', 4, null, null, null, 'YYYY-MM', 2, 3, 0, 966, 715)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3f19e6b5-b94f-8227-9506-1c131b885cf2', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f003', '1bcf67d9-327d-4f35-b823-062f240769ac', 'f7c09624-9505-4671-b558-91fe4790e2d3', null, '43437603-8a66-43fc-bf05-f5e3b969b8b1', '3a77ec83-f197-4838-950c-5ff8b2bf18ac', 'CWSZOX2', '单位名称', 10, null, null, null, null, 3, 2, 0, 966, 700)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('74935d03-13ed-ed50-87c4-b6c1d360d425', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f004', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', 'f7c09624-9505-4671-b558-91fe4790e2d3', null, 'b9568d81-cfd8-490f-92c4-74855349dc84', '12bba719-c079-471b-8d84-5be65221365b', '0-_-房颤/房扑消融-_-2###0-_-房早/房速消融-_-2###0-_-完成例数-_-1###0-_-死亡例数-_-1###0-_-心包压塞例数-_-1###0-_-房室传导阻滞例数-_-1###0-_-室上速消融-_-2###0-_-室早消融-_-2###0-_-室速消融-_-2###0-_-其他并发症-_-1###0-_-左心耳封堵-_-2', '导管消融报表', 13, null, null, null, null, 4, 3, 0, 966, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('072eb615-11cc-d841-d66b-f4aa28e33d2b', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f005', 'b561d7ed-06e6-4171-ab6b-e7014770198f', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '72d1f815-d0c2-41a2-ba1a-6d95ca9bce5f', 'LS6', '例数', 5, null, null, null, '0', 5, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d9504b90-90d9-4bfe-af44-562593e527c5', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f006', '7fdd0d75-3401-4e6c-be45-fc15bc0348db', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '449ce1c2-03fe-4989-9923-469ee8342095', 'LS6', '例数', 5, null, null, null, '0', 6, 5, 0, 966, 965)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c705c2ef-6825-cd59-0504-a667ef6637ba', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f007', '6870f04a-6420-4d33-97bd-74b532235094', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '50e3c5a7-94e8-4111-86fc-e36d2bd4098b', 'LS6', '例数', 5, null, null, null, '0', 7, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('4c5cd75c-3dfa-afea-ab15-2aa611891a79', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f008', 'c0ec2c08-6a25-4d44-b3a4-890d71aa91e4', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '866f490b-76a9-4667-8fd7-b362c26a743f', 'LS6', '例数', 5, null, null, null, '0', 8, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6bf85df6-38dd-86f2-adc8-055f56420f19', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f009', 'b6eed69e-8824-4860-b7e4-d25fa15fcbee', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '7950f80c-1a87-4344-b2ed-63b91559d96e', 'LS6', '例数', 5, null, null, null, '0', 9, 5, 0, 966, 965)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('0b3980d4-edc1-7f24-ce87-64e99d46fdc4', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f010', '1021ee18-0f29-4eee-951b-43d1db1c4af2', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c8044c5f-291c-4a88-97ab-d45181282ac0', 'LS6', '例数', 5, null, null, null, '0', 10, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e1945e55-8889-d273-7d14-ef559d9d396a', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f011', '51851aaa-71af-420e-ae41-8e62b86fa022', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'b065a913-6c6a-4022-ad51-5981245724d0', 'LS6', '例数', 5, null, null, null, '0', 11, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7aa94c20-4844-5b3e-2d70-ad4383b1bfe5', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f012', '276c4776-d3ad-4a9c-9447-80279b0a6a4d', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '7e0da9c2-d659-45c1-8726-96aba6202f9e', 'LS6', '例数', 5, null, null, null, '0', 12, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1df90f2b-062f-5ea7-7f29-82e3e7094e7b', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f013', 'fdaabb49-0bdf-45fd-b3f8-2667262d27d6', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'bea053dd-ce69-4030-b7a7-6458a5b4f228', 'LS6', '例数', 5, null, null, null, '0', 13, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('25726eb0-1c20-4dec-9e2c-c9d7238dda3b', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f014', '3851411c-a8ad-4c9f-a737-bf9c294c0a95', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '2a45aae7-0fa1-4837-a9b3-066d443cd0b5', 'LS6', '例数', 5, null, null, null, '0', 14, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f4db5da5-5559-0ec3-6d42-245cec5d09cb', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f015', 'e8c45d5b-6746-42d0-a78e-2a8bc55d0a98', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '6c4fad72-47b8-4512-bf48-685c2264705b', 'LS6', '例数', 5, null, null, null, '0', 15, 5, 0, 966, 963)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('8ab1ff05-f1b1-7f74-0ba8-28aaf822c0fb', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f016', '54a1199c-1ee5-417e-97e0-82636d3cb2b5', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'b2b1d62a-97cf-429f-99b0-f87c45f1f21b', 'LS6', '例数', 5, null, null, null, '0', 16, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f1694b7e-2a15-8707-2e06-a66c198e0460', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f017', 'c9936c0d-c67f-46c9-98a8-dcdeea495fe2', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'e443842f-627e-4b8d-9da6-8fe0c3d5748d', 'LS6', '例数', 5, null, null, null, '0', 17, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('aba9c02d-abf5-7b95-1c7e-c83b581c8392', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f018', '8ed2dda6-9191-4ea3-a04c-3bc97d98dc9a', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a63bb3b0-c418-47ea-836a-b4af626b6e11', 'LS6', '例数', 5, null, null, null, '0', 18, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d9bddcc4-d17c-41e6-d2d8-1e30b8cd8620', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f019', 'c6029816-ceb3-41b0-9ad6-8b81874a3974', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'e10ee198-45fb-4591-9a6f-16e9348c0d51', 'LS6', '例数', 5, null, null, null, '0', 19, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f1a41a84-b4de-ffeb-c85d-a03a26967082', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f020', 'e12cacff-fd38-4290-bf7e-cc8981bec308', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c4d9a807-a20d-4db5-9cba-9177a801e8ea', 'LS6', '例数', 5, null, null, null, '0', 20, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('08b77e36-c096-a299-0c50-ee769e845ae5', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f021', '1de57574-8068-4224-8cce-1f7b78991cc2', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'df8b5d01-8b4c-48ea-bcac-87e5979063d3', 'LS6', '例数', 5, null, null, null, '0', 21, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('91b6be5d-e8e6-71f9-cbba-0323123cb176', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f022', '0cc8d4ba-10d3-460c-b589-bf9423802d8f', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '7a62bc1d-d462-4f6f-96f2-00c7afb96388', 'LS6', '例数', 5, null, null, null, '0', 22, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d0301890-464a-b731-0063-21ccad2a8eaf', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f023', '884fed9d-9be9-43c9-bdf6-68d30e91c7b3', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '459ade08-746c-4c02-bfd2-6444a8fef941', 'LS6', '例数', 5, null, null, null, '0', 23, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9aba46b2-dc00-1fdd-1863-0ce729e08a30', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f024', '78ce1c84-9ef0-48a1-8241-78439d4568d9', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'aabd5333-347d-41bc-af2d-a197dc3989b4', 'LS6', '例数', 5, null, null, null, '0', 24, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1d6a3d8e-1ea2-89c0-5872-05290eed8b5c', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f025', '23da1dac-1c2c-4678-8a32-f7b04d284d0a', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '70e7df35-2368-4193-9052-2f27741cfd1a', 'LS6', '例数', 5, null, null, null, '0', 25, 5, 0, 966, 965)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6760b267-ec9c-0814-67d8-0916c4997c7e', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f026', '3a92704f-f24e-44bb-bc20-62610c8aa8ae', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '59f4da1f-cd07-40fa-838c-2f5e2a449de1', 'LS6', '例数', 5, null, null, null, '0', 26, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('5a33683a-c467-538b-bbf5-2f7154ee7095', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f027', 'edca8883-b7a8-4187-a04d-87583c0cd682', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '937fceb6-c32b-43f4-b397-a91654a5422d', 'LS6', '例数', 5, null, null, null, '0', 27, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('296bb38c-880c-ce05-5402-324a98101ddd', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f028', '8e4b3320-2bfb-43e4-9f9c-190a28b6c6cf', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'ffe3234c-f83c-47cc-9764-f208e47225ae', 'LS6', '例数', 5, null, null, null, '0', 28, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('58a62b26-25e9-cbec-979f-5d0e7fd87ca5', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f029', 'f1d82041-8774-4880-a763-b3c73f2fbe1a', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c3689d25-d16c-4931-a921-33fc400f5fbb', 'LS6', '例数', 5, null, null, null, '0', 29, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('47cf2989-99fb-90ad-176d-9b0c9d1b4794', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f030', '986fb4de-15cf-4c00-a34f-3fb10c42d920', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c4610f37-943b-4f63-875d-1364b035cc5b', 'LS6', '例数', 5, null, null, null, '0', 30, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b3f4c436-bc47-1638-a5ce-7f57dc625863', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f031', '1a7b9809-0421-4e55-b682-05e99cd388ac', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '258be848-7094-4927-b596-c00736f57990', 'LS6', '例数', 5, null, null, null, '0', 31, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7173d6e1-ad8d-bfc9-4b61-4f0764092379', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f032', '873c401b-962e-448c-98ce-64271f446ad5', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '4c8eeb9c-5755-4312-a70c-35dee5dd85e4', 'LS6', '例数', 5, null, null, null, '0', 32, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('dc113ad0-1fc4-446d-028b-13346f21ceb3', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f033', 'c8c10840-5c1e-468e-b258-4e66e336ac16', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '12c838b9-bf15-4278-8d33-aa3746471642', 'LS6', '例数', 5, null, null, null, '0', 33, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('695a2570-e3bb-2b45-9e2e-c59c803fdaf8', 'f1305547-4181-6c3d-36e3-44a2e22304f6', 'f034', '7d848ab8-4922-4610-922b-4c236c3fce17', '00b27ae3-cd49-4bff-95ba-c1f019a9262d', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '1c5132d4-961e-45ae-91b1-2e09c21566ea', 'LS6', '例数', 5, null, null, null, '0', 34, 5, 0, 966, 966)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_template (id, source_custom_form_id, form_name, business_type, field_count, answer_count, card_count)
values ('bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', '67ae9bd1-b82f-4d65-a78d-a0fa9f5eb10b', '结构性心脏病介入报表', 'quality', 157, 130781, 833)
on conflict (source_custom_form_id) do update set
    form_name = excluded.form_name,
    business_type = excluded.business_type,
    field_count = excluded.field_count,
    answer_count = excluded.answer_count,
    card_count = excluded.card_count,
    updated_at = now();

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('a3b3b40c-f1bd-238d-ca4b-be1c2aed3fff', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'quality', 'c1174c60-2ef2-45f6-85dd-5269b567f996', '67ae9bd1-b82f-4d65-a78d-a0fa9f5eb10b', '结构性心脏病介入')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('18756d87-f42e-15f0-6e21-eae84b93506c', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f001', '82182deb-c8be-4007-b83b-0550ee418870', null, null, '1143dabf-982d-4d42-93ef-a25fbc13f20f', '15818896-34c1-4e98-aa2a-7852e26a3447', 'GXBJRZL2', '结构性心脏病介入报表', 1, null, null, null, null, 1, 1, 0, 833, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('26718424-6a7f-b7f1-0c04-f86e1a3b06ac', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f002', '02b16613-1998-44e9-a3eb-1589fe762383', '82182deb-c8be-4007-b83b-0550ee418870', null, 'f2fc2386-7713-4da6-968e-589b1f0f498f', '457e5434-8b09-4a17-90aa-2216c7e52ec9', 'HZCYSZYF', '患者出院所在月份', 4, null, null, null, 'YYYY-MM', 2, 3, 0, 833, 590)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6bb87b39-814e-06ed-6c1a-59c9de265781', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f003', 'c176ebc3-01b9-4652-98cb-59a6b61ea18f', '82182deb-c8be-4007-b83b-0550ee418870', null, '43437603-8a66-43fc-bf05-f5e3b969b8b1', 'a2fe7c8c-47fb-4367-8a50-67dca42c4c89', 'CWSZOX2', '单位名称', 10, null, null, null, null, 3, 2, 0, 833, 580)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('25c0b383-c5e7-5b92-b255-cc86ed74a994', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f004', '92bb730e-374e-42a0-b952-de1c1bbb01b6', '82182deb-c8be-4007-b83b-0550ee418870', null, 'b9568d81-cfd8-490f-92c4-74855349dc84', '8563ba32-d37c-4d55-9703-ea1c593b6a2e', '0-_-完成例数-_-1###0-_-房间隔缺损封堵术（ASD封堵术）-_-2###0-_-死亡例数-_-1###0-_-心脏压塞发生例数-_-1###0-_-术中转外科开胸例数-_-1###0-_-介入相关脑卒中发生例数-_-1###0-_-房室传导阻滞发生例数-_-1###0-_-血管入路并发症需要外科治疗-_-1###0-_-器械脱落发生例数-_-1###0-_-其他并发症例数-_-1###0-_-室间隔缺损封堵术（VSD封堵术）-_-2###0-_-PDA动脉导管未闭封堵术（PDA封堵术）-_-2###0-_-肺动脉瓣球囊成形术（PBPV术）-_-2###0-_-卵圆孔未闭封堵术-_-2###0-_-主动脉窦瘤破裂封堵术-_-2###0-_-冠状动脉瘘栓塞术-_-2###0-_-先天性主动脉缩窄支架植入术-_-2###0-_-先天性主动脉缩窄球囊成型术-_-2###0-_-经皮先天性主动脉瓣狭窄球囊成型术-_-2###0-_-肺动脉支架植入术-_-2###0-_-肺动脉球囊扩张术-_-2###0-_-经皮肺动脉带瓣支架植入术-_-2###0-_-体肺侧支栓塞术-_-2###0-_-经导管主动脉瓣植入/置换术（TAVI/TAVR）-_-2###0-_-经导管二尖瓣介入-_-2###0-_-左心耳封堵-_-2', '结构性心脏病介入报表', 13, null, null, null, null, 4, 3, 0, 833, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7a53f440-4346-7e54-3fae-3f560953190e', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f005', 'acebe695-0549-41a3-baae-daa8805f7b3d', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '23143af3-74b3-41ad-896c-4c2410f125cc', 'LS6', '例数', 5, null, null, null, '0', 5, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d850dd46-37ee-e2cf-ba96-b7b2e6a31859', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f006', '9ff95699-de64-4ccf-b884-5f67b994d3da', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3cba2439-b0d8-44ad-a008-166f06a97da3', 'LS6', '例数', 5, null, null, null, '0', 6, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1e72117a-05fe-9454-8880-285585672612', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f007', '37818758-10ee-4c44-995f-511b71467ce0', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '89bdf4e4-a7a0-4735-be6e-b50a0e26381c', 'LS6', '例数', 5, null, null, null, '0', 7, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d0fa151b-056e-a1c5-8f89-cf7d1859cfdf', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f008', 'c65ac5f3-fbbc-4b6d-a578-5f580f693ba7', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '2dfafc41-4087-4632-bb54-d4a928cb99f8', 'LS6', '例数', 5, null, null, null, '0', 8, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3c81f8bc-305d-913c-297a-cbd625fb7336', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f009', 'f857eaed-c63e-4f52-ba48-8b5c365f9cd5', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '03037948-2a20-424a-8ef2-6da329858130', 'LS6', '例数', 5, null, null, null, '0', 9, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3b0bb16d-61f9-5848-3aa5-8eedcba394e9', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f010', '80db71ca-b436-4517-84d4-ffbf84b90fb4', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '061d8818-e6b0-459f-95dc-291c51eb2ce2', 'LS6', '例数', 5, null, null, null, '0', 10, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6f5cc877-9cf0-4db8-3074-88d3b20ea6e0', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f011', 'ad4df5ec-6a49-46dd-ae52-c40774c6bcd3', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '0faecaca-e22a-46db-812e-89ac6725bb9d', 'LS6', '例数', 5, null, null, null, '0', 11, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('074dbf36-ea08-6adb-0d1f-a5313e34885a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f012', '402de7e5-8a40-4eec-84c8-7b4b903bafac', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '687477cf-f8e1-485c-adc5-6aaaec642673', 'LS6', '例数', 5, null, null, null, '0', 12, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('95c8b2df-bf94-b52c-8f65-b021e55a8c4e', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f013', 'c95943ac-a4f9-4865-9700-40a47b8ac5bc', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '9e3bd745-f138-4cdc-b96c-396b836140c0', 'LS6', '例数', 5, null, null, null, '0', 13, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ec0f3671-20aa-dfa8-869e-cdc8379205f6', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f014', 'e39aa04a-ddf7-4549-8e7e-ecd8a4f31c1b', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'de968650-b194-4d70-99e2-55d8e6d6f23f', 'LS6', '例数', 5, null, null, null, '0', 14, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('97e0aeb2-4069-f1a8-26c8-2d9930d8fddc', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f015', '3825a351-a5e9-4f5d-a43e-e54b2a9badbc', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'f5ec7771-f490-4c39-a99b-5659a18b6542', 'LS6', '例数', 5, null, null, null, '0', 15, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('84280dbe-600e-00a8-f2f0-1244c32f35f0', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f016', '124327d3-c08d-49a0-a526-60f08defdb85', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '606eea20-46f4-46ec-bff2-60b8bf054242', 'LS6', '例数', 5, null, null, null, '0', 16, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('5bdae81f-f7f3-dee3-663b-9ad3d3e19b72', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f017', 'e483b148-b2b9-4b59-b810-21b7bbae44cc', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '0a80cd52-8585-4354-ba45-cc2b0c4b63c8', 'LS6', '例数', 5, null, null, null, '0', 17, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('34e0748f-1bbc-f097-9999-a3abb95a22d9', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f018', 'a177b51b-572d-4f17-a069-189f7505281c', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '6944c5b2-b6cc-46bd-9da2-6a088b239b6b', 'LS6', '例数', 5, null, null, null, '0', 18, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('27ac277a-b07f-693f-b419-ed71c3ba45d3', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f019', 'aa5d07c5-6c6e-4fcf-91aa-723f3af5b1e1', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '06949265-64ee-46fc-981b-a9e6d6d2ee9b', 'LS6', '例数', 5, null, null, null, '0', 19, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('122d443f-15a6-728c-8548-70498abb3aaf', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f020', '1f63c0ea-6522-49c0-88b2-5ca3cffb3d1b', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c31c1c31-08ae-494c-b527-dbbae69cf1a6', 'LS6', '例数', 5, null, null, null, '0', 20, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9a70b41d-8181-c000-4fe9-5b11eb615949', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f021', '4db662d0-127a-4257-a282-ab7421320761', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '1116198e-b278-4b15-a376-397a900323b3', 'LS6', '例数', 5, null, null, null, '0', 21, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c553c3ee-a027-f480-24b1-df2371b11750', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f022', 'b60f9547-b3ef-44d9-8f2e-76f99fd318da', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '9e2648fd-1a27-4150-a1b7-ed3c468be91b', 'LS6', '例数', 5, null, null, null, '0', 22, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6a790686-93b3-fab7-4d32-1f59ec9c0206', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f023', '1a2d9d12-70a0-4249-aadc-d13696744391', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '23b642ea-5e38-43ae-a303-aaa26e61655d', 'LS6', '例数', 5, null, null, null, '0', 23, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('bfaacb0c-d817-e977-c1e3-8e6b7eb751cc', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f024', '3906b4c7-5f00-4fe4-bc35-c6ccae93e2ab', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3613b317-5698-4350-a33d-7cf42a4e4c6c', 'LS6', '例数', 5, null, null, null, '0', 24, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7dbd6b18-ccee-4348-3367-6a2f59e410ff', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f025', '2f8b0bbc-e09a-4ccc-be6a-ca27540a8c33', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '5786d949-dcc2-4767-a60c-b70ab6035b23', 'LS6', '例数', 5, null, null, null, '0', 25, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('06ec2b43-7eb1-7467-98aa-602458608d6b', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f026', '08bd742e-8c71-4a39-aba8-e76c5e99d5be', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'e341c90d-e1c2-47d8-b348-d804b295bfff', 'LS6', '例数', 5, null, null, null, '0', 26, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d9a82aa1-cd6d-395b-1249-1d0555fee39c', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f027', '64944eaf-709e-4ba9-81d6-87d74aa85b74', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '0f43d02d-c80a-4fc7-a31d-eded5d50d838', 'LS6', '例数', 5, null, null, null, '0', 27, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f7b6f405-d069-f579-e9df-fbe5934050bb', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f028', '47212bd2-79f4-4cd2-9eaa-cfa6aeb49cfa', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '43dcccd3-092b-45ba-a919-32b961dfe5bf', 'LS6', '例数', 5, null, null, null, '0', 28, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3d866400-f805-df1a-ae49-cc6ebb2f1cc3', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f029', '826aa4b7-347a-418b-b6fd-09766845ae1f', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a5ef6d7c-61d0-4f30-b9fd-be96abcb0f0d', 'LS6', '例数', 5, null, null, null, '0', 29, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b4152114-c316-275d-2d2b-f30129aa7912', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f030', 'f333004d-aa69-45b3-aa89-2907fca37633', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3abe86d1-0cc2-4ace-a6a5-a3aa4e40ec1a', 'LS6', '例数', 5, null, null, null, '0', 30, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('655f163c-802e-d99a-b4ae-aff770a2ff6e', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f031', '6b8c1ee2-c9ac-4492-8401-9cf2017feeb9', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '2b8ce644-a07d-4b0b-a81d-59261166d0f1', 'LS6', '例数', 5, null, null, null, '0', 31, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3d2067b3-ed93-9a04-eb60-c03307b686ca', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f032', 'd7adf4ab-d07b-4a3c-9fe2-89976a9adfde', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'cb2cb08a-25f6-4fea-9b0f-0c9643d68446', 'LS6', '例数', 5, null, null, null, '0', 32, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7a65ada2-0afd-0d2b-249c-a9e8c1c0e7d0', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f033', '029b5321-f42c-4341-9463-5e791086e566', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '1b16ac7a-5c53-41e6-b978-4ca5e377b88f', 'LS6', '例数', 5, null, null, null, '0', 33, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('85fbf3d4-513d-6963-f5da-0b6708e64720', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f034', 'e811512b-3787-483b-8923-7f134cc0cbb6', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a7a3beb9-a475-44e1-ad8a-705765aba0a1', 'LS6', '例数', 5, null, null, null, '0', 34, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a3d00a7c-d860-6d10-0bc7-fc1b3b1e9475', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f035', '89afe478-0e9d-4585-afe5-0a585c2bf3af', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '06548384-1a91-4505-b082-0775e2308942', 'LS6', '例数', 5, null, null, null, '0', 35, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f509e527-934d-4d67-16c9-a94c6d3de88a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f036', '3b980470-123a-4f7e-bad7-bf77f852250a', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '9c5b6704-a5d1-49d8-996e-e08b71b6ac48', 'LS6', '例数', 5, null, null, null, '0', 36, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('250c1ac6-8b99-b88e-adda-d493e0cd3d4c', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f037', 'bfa50eef-3148-42ba-a2a9-3e251e9cfa3f', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '61ff44ab-81b7-432b-a2b2-540b9be9025b', 'LS6', '例数', 5, null, null, null, '0', 37, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b88dc635-e415-61c6-6c1d-0b847b98dce7', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f038', 'e2c76a38-38be-4c9c-969b-2a9ecbb3e7a4', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '4dc5b8e6-e0f1-4f9c-8eeb-5d4e6a1ea63c', 'LS6', '例数', 5, null, null, null, '0', 38, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b62161e5-d466-01bc-012f-8669e9fc9235', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f039', '6c24f2e9-502b-4d69-80a0-dad275a20257', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '15b010df-e656-45f7-9ec6-ae7279a55366', 'LS6', '例数', 5, null, null, null, '0', 39, 5, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a1194a7c-c89c-909d-3273-ea6fc36c5e8d', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f040', 'ddc7fbef-010c-4985-ab6f-678679f39fcf', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '838b6d94-56b4-481c-a6fb-16ba16df4388', 'LS6', '例数', 5, null, null, null, '0', 40, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('0aec84b8-c569-7f50-8a73-bddb50a79f9d', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f041', '851f18d2-8e6f-4382-9748-05a9ad4690e9', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '61de444e-31bc-46f7-9e4e-d3ed87fb6a60', 'LS6', '例数', 5, null, null, null, '0', 41, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('32acbab1-5bd2-1862-5631-e699edbb6c02', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f042', '7ea144b2-2932-4006-86a9-12913022f471', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '678f17fa-8cf0-4cf0-9a96-9e1ed5eb9b9f', 'LS6', '例数', 5, null, null, null, '0', 42, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('83fcb093-de9c-1332-fdd9-f0cefdf1a692', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f043', '4ade614d-f26a-4475-a0f5-79e929a72e65', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '6c056b64-6132-4cd3-a3a1-0d4a86aafbaf', 'LS6', '例数', 5, null, null, null, '0', 43, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('668e9fe2-25c7-c36f-d721-dbf9b6974a9e', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f044', '9aa2a230-af29-4dfb-8f64-462b43b82e87', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3f8f8347-24b8-4f01-86db-cdaba1e8d69c', 'LS6', '例数', 5, null, null, null, '0', 44, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6fc2d580-bce1-80ad-3174-3a1a601c73e9', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f045', '66248de4-0db5-4ba4-86fa-ea2dc22bdcf6', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '57ffff8e-6e92-48b0-9784-7991395de6b4', 'LS6', '例数', 5, null, null, null, '0', 45, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('006937b8-4fea-7c0d-9194-a84eed3a7701', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f046', 'b8aa757c-beac-491d-8fd2-3087d9ccbf95', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'bdd92a7b-d6f6-4bed-85ba-90bc6e2eaf47', 'LS6', '例数', 5, null, null, null, '0', 46, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1f627c9d-ee23-a289-622d-1c40229d5894', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f047', 'ccbd1e85-7e7d-4fee-a3c8-8ddb1a502068', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '301a0421-0bc5-4be4-80ad-3c564ff774dd', 'LS6', '例数', 5, null, null, null, '0', 47, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1e91564b-704c-b32c-205f-c86575ad2de7', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f048', '50108f52-61e3-4fcd-84b6-7e1f9f42250f', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '60ea8350-a2ea-4936-8b03-0ecca586a281', 'LS6', '例数', 5, null, null, null, '0', 48, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b768197b-9d25-a849-79e3-8ff2985a68fb', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f049', '792546ec-1730-41f6-a1ac-d6fabb3e15c6', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '874fd87f-1c14-4118-8b9e-0c5a4a1af48f', 'LS6', '例数', 5, null, null, null, '0', 49, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('4a3bc20b-d5b7-2afc-3a25-8d0de13ec45a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f050', 'cb914f73-5be2-448e-9918-0ba855436968', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '482e3460-b870-4daf-b434-4022eb195cb8', 'LS6', '例数', 5, null, null, null, '0', 50, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1b2dd851-fb7a-eaea-d83a-37d1d62d47ea', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f051', '7cda2212-d001-4047-ab41-e4b206814023', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '480b05df-b577-45ea-987d-5ca8dc1b5834', 'LS6', '例数', 5, null, null, null, '0', 51, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a7e4ed9e-cc0f-9d59-2987-74ea4f581de5', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f052', 'd45a0a69-1114-4c95-b849-0c7a6f51c3f1', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '8f45a4b1-3237-49e6-9a07-b886d5656dd9', 'LS6', '例数', 5, null, null, null, '0', 52, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ec3d5087-1d11-5090-5a64-55a2987165b1', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f053', '04ca2473-5ed8-4e74-b1ae-115eb243f7e4', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '724b9a10-f33e-420a-8d08-ce09063e9b3f', 'LS6', '例数', 5, null, null, null, '0', 53, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('101ec6b7-094b-8205-3e99-91d291088448', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f054', 'b5cec953-eedc-48c7-b12a-3d84fc380ed5', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '74552739-204b-4a88-b459-39c381acfa73', 'LS6', '例数', 5, null, null, null, '0', 54, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('93a74a96-c3b0-edba-5e1e-c94713fe36ff', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f055', 'be51a46e-d577-4ca2-99b3-ba8557152317', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'e59b0bf5-b33c-4372-abf8-abbe3ab003aa', 'LS6', '例数', 5, null, null, null, '0', 55, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('15517da0-44d2-0643-6381-edab7b03fd75', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f056', 'e8f59761-ad7c-47dd-8084-3aca07eafc0e', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c4444ff3-5cd0-4ebc-9d8c-12fb8ed5db6f', 'LS6', '例数', 5, null, null, null, '0', 56, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ff3c5e81-cef4-6369-2bde-7c3d17d8d409', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f057', 'b13b0445-7ec6-4c89-a8ce-327e1870d060', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a8a07d4c-1e0d-4432-b900-abfecce8f78d', 'LS6', '例数', 5, null, null, null, '0', 57, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('773f768d-a868-2085-6d38-0c71669fe682', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f058', '41442bf6-6344-4f7f-8fb2-06a8bef257cc', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3741ded7-c617-4f07-a22c-d4f271881b7a', 'LS6', '例数', 5, null, null, null, '0', 58, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('41ddd079-493a-c4f2-e1c8-3b1f78a2b345', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f059', '064974c2-1b5f-4dee-879a-aacd07a1df6b', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'da117f02-2d05-46a0-bc21-c5e613fa4a78', 'LS6', '例数', 5, null, null, null, '0', 59, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('62833f75-0904-aeca-78d3-fa6a97d16470', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f060', '53b30671-4455-4aa7-aef8-3e9629f35c66', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'bed2e713-f98d-4a8c-a1f5-135ebd21b28d', 'LS6', '例数', 5, null, null, null, '0', 60, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f9919544-91f7-54ba-97f5-83e8d7b238b2', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f061', 'd4a332c7-b9f5-4cd9-916e-2b4689f86452', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3ecf9c87-9b1c-4bca-a5e3-8bed3377131e', 'LS6', '例数', 5, null, null, null, '0', 61, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c67da8d3-8f2f-7aea-3ade-8671430d87a4', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f062', '08ba6c8e-eb8a-47c4-a022-1773877418a5', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c1943314-0e3d-49e3-98d0-0d2833f9ab71', 'LS6', '例数', 5, null, null, null, '0', 62, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f4cc9dba-2ffd-fbf4-19e3-b56013b35b1e', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f063', 'f69294a9-d680-4e69-a3c3-b686c4b269cb', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '41ef7f8b-e1f2-4bce-887c-1ca3c2b506a7', 'LS6', '例数', 5, null, null, null, '0', 63, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('bdedc427-ae27-5e40-d7a7-abf8074f41c1', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f064', '09038c92-26ef-4470-950a-f369a431adc8', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '2ea8880a-bdab-4f74-aa32-5bd7536b11ed', 'LS6', '例数', 5, null, null, null, '0', 64, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('169f48bd-1a13-840f-7614-f7af9fcd62c1', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f065', '0ada3673-bf2a-4683-82d9-cfe5159ba535', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '057be3b8-312c-4100-94fc-13dc98973f06', 'LS6', '例数', 5, null, null, null, '0', 65, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9587471b-bb79-0531-ddd9-8e8f9f081517', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f066', 'b8472cc2-2edf-4fea-9814-1796df3d4112', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '1bddee82-b47b-4e27-aae1-80fce4495dbe', 'LS6', '例数', 5, null, null, null, '0', 66, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('897c1e6a-c692-676b-b928-9d31a6df4634', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f067', 'b89f1b50-e88c-4375-a4ae-6e5641f66004', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '01316056-52eb-4b00-ada8-2764fa643139', 'LS6', '例数', 5, null, null, null, '0', 67, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('19f60737-fe35-9011-b651-39022e3c297b', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f068', '9242033e-2bd6-47c0-8586-0e1cbbf1856b', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '28ddb405-35ee-4e31-8995-a0ded3c747de', 'LS6', '例数', 5, null, null, null, '0', 68, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9319c247-512d-71ee-a38c-896d650f38bd', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f069', '539d9bee-3f72-4146-84fe-82a6d78c65f7', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'ed1897ef-9961-4cb3-a8b4-b0c103dec343', 'LS6', '例数', 5, null, null, null, '0', 69, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2c3018c9-841d-11f3-e203-71ea37b1ac1c', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f070', '44d52085-7ac1-41a5-b220-2c4b36e5492a', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '27222af6-e18e-4b67-819b-9a5f8f01e818', 'LS6', '例数', 5, null, null, null, '0', 70, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('77fe419d-f461-36ed-860b-37c781ea7398', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f071', 'da94aaac-1881-40c6-abda-fad90aa8aa1a', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'afe4e6b6-c288-4176-bfca-544fe62787d9', 'LS6', '例数', 5, null, null, null, '0', 71, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7fc6fb56-98a1-34f0-1091-546ab8679305', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f072', '213f9c04-5820-492c-925d-a0e0dc9d70dd', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a798f261-25cb-466d-985c-5caacd9ccd28', 'LS6', '例数', 5, null, null, null, '0', 72, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('5e558e19-a17b-7993-3d5e-c8575e43ed3a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f073', '4fd12994-aeac-42b8-9c08-4f1e734d4e9c', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '9c7b92e5-f9e9-4def-8362-c3925a035d37', 'LS6', '例数', 5, null, null, null, '0', 73, 4, 0, 833, 833)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('76c01c86-2c7a-7793-3135-b1a157a72244', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f074', '23065c2c-08fa-4480-912c-ffd65340d401', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '6e07961f-c21a-4eaa-9e8a-038329fd928e', 'LS6', '例数', 5, null, null, null, '0', 74, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('19b447c3-2beb-2155-f702-aa57647e39ca', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f075', 'cbf158c2-b876-4fd5-b0f6-4a4612cbc24e', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '18bbfdc6-5430-453b-a213-6b3f546e6c96', 'LS6', '例数', 5, null, null, null, '0', 75, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('0b513aa4-1009-a0ac-7e7c-d9209c1957b5', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f076', '15fc5760-ae25-4387-b7c3-6a23eb9f6731', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'baaf682a-0756-4595-92ee-50803d16bd7b', 'LS6', '例数', 5, null, null, null, '0', 76, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('cc96b358-3753-b13c-8e81-ed6eea085d3e', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f077', '8ecdcffb-09c1-4a2b-abbe-db932600943e', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '94e20871-0b27-4179-a999-eaccba45e0ce', 'LS6', '例数', 5, null, null, null, '0', 77, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e867810f-8e3e-a1cd-f318-a3c6e49029bf', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f078', 'c78c2e03-cef8-4dc7-8528-718020434a4d', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '30f81d1b-9fb8-4c57-b001-f7c13c840f29', 'LS6', '例数', 5, null, null, null, '0', 78, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9f955cba-eb5c-3585-8e78-d55259ae2821', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f079', '9be227cb-6a5a-4f58-a0a9-29cb0a735844', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '9394cec6-778b-4769-bd28-0e1c7ad28893', 'LS6', '例数', 5, null, null, null, '0', 79, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('18ab448d-57d9-cbc9-3c28-28cbd092862b', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f080', 'c992f566-f8f3-4fd6-895e-45ed5f04080e', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '42f36d65-624c-490f-8f35-4b05b705bfb2', 'LS6', '例数', 5, null, null, null, '0', 80, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('fc4ef391-3280-493c-ae9c-3070075cfd3a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f081', '4ac43cc3-cd41-40cd-b185-c1fcf27ca6d5', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '9f2f557c-87e2-4f18-8213-e7609c8ea5b6', 'LS6', '例数', 5, null, null, null, '0', 81, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('90234287-e1b4-a3dd-678f-26aa3b5af53b', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f082', '57e79757-e154-40e9-aa50-1584457495c8', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a27033ba-b00d-4693-a9ed-a99de629b29b', 'LS6', '例数', 5, null, null, null, '0', 82, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3decf084-5aaf-f416-ad6d-a997bfcde8f6', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f083', 'ff7321f6-1b0b-4f9f-a029-acd2b8e03673', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '065f9737-72ed-483a-ae7d-1b69072378ca', 'LS6', '例数', 5, null, null, null, '0', 83, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('336bf85e-ff77-4d9d-cb5a-171240be68a2', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f084', '8a908aeb-cdfe-49c8-8396-43971929ae2e', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '4f277efb-385b-4fd3-8f93-c9dfed9e0274', 'LS6', '例数', 5, null, null, null, '0', 84, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('37d71367-e708-5af7-7802-705bd3c27f97', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f085', 'b9fe47fa-6bb4-468b-8f8f-fdc91921028f', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c2fc4802-e0c6-4404-ab9a-b943e0050b42', 'LS6', '例数', 5, null, null, null, '0', 85, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('4aab90f8-bd81-fc54-56cf-22435dfcbe56', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f086', '43113a51-cfc2-423b-b45f-a66723839d80', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '976c6942-d12a-4e9e-a7b5-320db3c1ee6f', 'LS6', '例数', 5, null, null, null, '0', 86, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c2b2e7a2-299d-97d0-8bdf-aef00819c68b', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f087', '0163cc3c-6b50-465a-b418-7edea0aea056', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '898d2f87-5ab0-48c7-b825-0a207cd9f3a6', 'LS6', '例数', 5, null, null, null, '0', 87, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('8efc73dd-ab89-cc00-3c6d-8f48f0067a87', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f088', '3b4ba3ad-6eba-4d7a-9ea8-3e4b19744385', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '135e4f6b-f260-4265-8356-c04f6b6b7e6a', 'LS6', '例数', 5, null, null, null, '0', 88, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a43816a0-60d0-0454-ecb2-6c3da824cb53', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f089', '70fac450-04a3-4ab0-9465-989244322a9b', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3dee5179-c4a4-49e5-91c4-fe30be73cfd6', 'LS6', '例数', 5, null, null, null, '0', 89, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('69ebee22-bdb8-0d37-83d2-7ccdd2af312f', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f090', '3005fe02-322c-43db-b288-f17509cdbad1', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '79ec5a96-cc84-4b62-bfb3-de41c4af506a', 'LS6', '例数', 5, null, null, null, '0', 90, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d116d5c1-b8b7-fafa-fc63-b67a5896d45a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f091', 'ca102c40-b3c9-4c6c-acb4-32a70573a8aa', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'cce97933-f183-4262-ae3b-41c7fb18d8c4', 'LS6', '例数', 5, null, null, null, '0', 91, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('8b1a5846-a295-4061-5b52-1f1c6aedbfba', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f092', '1e0c47a4-84ec-4d25-a6a5-3409e853d4b7', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'b81566bc-91ad-4c4d-bcd4-338353396ecf', 'LS6', '例数', 5, null, null, null, '0', 92, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d81c4c52-90df-03df-e70c-3cb98f647ca8', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f093', '784cb7b7-dbe7-4e46-b96a-2402b7bde5d8', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'ee5c36e5-e76f-4176-a6d1-4fbf40e1420a', 'LS6', '例数', 5, null, null, null, '0', 93, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b3e482ea-af10-bcba-eb1d-c57e6cd36df9', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f094', '726dd1b6-7152-4edd-99a0-e1e7cfdfa68c', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'b781b084-faca-4db7-b87a-845528df9e0b', 'LS6', '例数', 5, null, null, null, '0', 94, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c30b9430-9214-1fce-667c-764fcfbb7837', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f095', 'ffa4d599-dc51-4ed2-a647-da51baab86e6', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3cebd68e-c649-4961-9095-74e45c586e1c', 'LS6', '例数', 5, null, null, null, '0', 95, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a576dde5-5328-a73c-1f64-808e2b089a3a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f096', '7c1c399f-06f4-41c1-8cae-3652443dbf3a', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'ea667e14-b054-42ef-98ad-16b309a98c56', 'LS6', '例数', 5, null, null, null, '0', 96, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3d57fb20-0829-6752-823f-f490ed5f2c09', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f097', '14c964e5-3bf7-4199-a82b-0f43006aec20', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '07d88736-b0ea-4fcf-b780-888b24f37e2b', 'LS6', '例数', 5, null, null, null, '0', 97, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7b947457-37b7-00b5-4f3c-66c6c4045beb', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f098', '24484298-e2e6-4f25-b54d-a71d77ff526b', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'b8645847-dd53-4076-814c-dae1c6526601', 'LS6', '例数', 5, null, null, null, '0', 98, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('133babc6-e6c1-0802-ef24-cc8219baba08', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f099', '021e4655-b14a-40da-8095-c3855a07c8ee', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '550d8670-bedd-44c4-8812-446b8f83880d', 'LS6', '例数', 5, null, null, null, '0', 99, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('15f7e78e-e061-81d9-0fff-b8dbc9b7e410', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f100', 'a4e62c5e-5ed8-4fb3-a3d8-51dfb9809528', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '9fd1c5d7-4f21-42ce-af69-cfaf2779e2c6', 'LS6', '例数', 5, null, null, null, '0', 100, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('07837eba-be49-f688-a36c-874b56161897', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f101', '597dec75-3baa-43eb-8223-b2f3153737d5', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'f6b83c27-b98e-4d84-b3b6-471e4c940b78', 'LS6', '例数', 5, null, null, null, '0', 101, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('8e411d46-ca57-a943-4aa5-ccde5ce06203', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f102', '1cf4ed35-56aa-4d14-b677-4d94ae3e3fa6', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '25542d0b-4f44-454a-a187-ef441c363ed0', 'LS6', '例数', 5, null, null, null, '0', 102, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6949fcd3-ab62-7b6e-6e12-9c2db673f99d', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f103', 'e3cca060-6d5e-42f7-81cb-2bd50efccd56', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'bf94d9cf-be4f-4858-88ee-9e91c27f0d26', 'LS6', '例数', 5, null, null, null, '0', 103, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('466e2e49-614c-786e-2283-3ed7c752db35', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f104', '27f9e2ad-20f4-4622-9c48-5e1ebe27e8fd', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'ad03c89c-f3a8-4962-83b9-f752423e71bc', 'LS6', '例数', 5, null, null, null, '0', 104, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d6abadcf-3fb7-5be7-fca6-eefcddab8799', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f105', 'daeef2f2-411d-4be0-93a7-7b1e265b47d0', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'f5381854-8b43-4694-a3cb-621975dfab7a', 'LS6', '例数', 5, null, null, null, '0', 105, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('37cac1ca-50e3-ca42-4ce3-762b5e2a6b39', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f106', 'f64ded76-b506-41aa-b1cd-017ceaed8089', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '578d1429-5397-4b5c-bec1-cc447966e7f1', 'LS6', '例数', 5, null, null, null, '0', 106, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('71101eee-c838-b214-283f-6e45c1310578', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f107', '04fe8bab-66b7-4077-a125-58f2998926f5', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '202b36f0-8473-4e0b-9538-e8504bec7b79', 'LS6', '例数', 5, null, null, null, '0', 107, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('cfd013b1-78ed-38c1-094f-0b7e0b112cac', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f108', '7d58513d-7311-49c5-ab1a-4360329a65ca', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '654a8dc8-e6c3-40ce-8417-e4fb8e875bce', 'LS6', '例数', 5, null, null, null, '0', 108, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6c5a766e-a059-af15-ad0f-48fbd2d50a61', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f109', '0eb2c10a-3f37-4d7a-beb6-7b016e942cd0', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a6a7bc8d-f35e-43aa-9a42-f1104f059ee8', 'LS6', '例数', 5, null, null, null, '0', 109, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('86bfbe4e-0f21-8e6e-ed4a-e1f8d20fdaf6', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f110', '2b318b4e-640f-43e9-95db-4567b7d7ec0a', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '42ce3c8d-9764-426e-9d3d-fa28169ec3eb', 'LS6', '例数', 5, null, null, null, '0', 110, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('58071708-170f-7056-0c67-0ae61273bd09', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f111', '6f012676-e119-480b-849b-3fe0cb7d7cae', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '41482c14-cfd6-4cdf-961c-ef09a257d364', 'LS6', '例数', 5, null, null, null, '0', 111, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7a58c434-d6e0-89b4-1d65-0f252ae584ba', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f112', '24b9d3b7-0841-4a88-a2f6-f5df388faae8', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '5f10af1a-2059-44cc-89ef-7e6e69d5dfdd', 'LS6', '例数', 5, null, null, null, '0', 112, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2182bba1-f129-1462-f3ad-137e328dd47a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f113', '5f12c3c8-9cae-4ec4-9e65-697d5a4004fa', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '32e94d18-9366-4bfa-be0d-a044d5d7b284', 'LS6', '例数', 5, null, null, null, '0', 113, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('91ff733a-8570-fac2-5563-7873be33ba89', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f114', '5c9bf1aa-98e3-4d26-8718-b379ef4943f1', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '7f51df72-8503-4f76-8a54-5e5de9115a5f', 'LS6', '例数', 5, null, null, null, '0', 114, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6294005a-f40f-fcaa-e0dd-512cdf57a5b4', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f115', '8dd0646f-bb18-4743-885e-812d8952ad60', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '87ba4e92-a94e-40b6-8e05-c60bdb39c92a', 'LS6', '例数', 5, null, null, null, '0', 115, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e07932ed-ab9a-a290-e19e-f2d6fe2b6634', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f116', 'bfa999de-5082-40cb-8cdf-4d651a5b6f22', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3ee60777-5823-40e3-96c0-ea7b33ce0bcc', 'LS6', '例数', 5, null, null, null, '0', 116, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2714ab2b-d644-c786-a699-481537325edc', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f117', '0cb1d676-07a4-4e52-9489-7afb384da09d', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '7a176c8f-6a96-4806-9f34-50e92c221e6a', 'LS6', '例数', 5, null, null, null, '0', 117, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f899d00e-a04d-97f5-b603-2a020bcb65a2', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f118', '4e08db27-455b-4c8c-8ee4-fcbb2de033c1', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'cd6ae4de-a58e-4e3a-827e-44e7b7ff174d', 'LS6', '例数', 5, null, null, null, '0', 118, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ea18916c-7032-e357-d422-a87306cc6fd9', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f119', '902c6cd8-e470-4b4c-81b4-8dd6dd3d8370', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'ac321b72-2209-4e10-886c-2f3955289da5', 'LS6', '例数', 5, null, null, null, '0', 119, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('26880bdd-106e-5b03-6aed-6527b0a9e472', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f120', '1809fbe1-db02-4d1f-94b3-da418e810082', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'd44003d7-8a00-41ff-b08d-353f4db413b4', 'LS6', '例数', 5, null, null, null, '0', 120, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('27e36470-87c3-c761-5ce1-b2053c81d0aa', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f121', 'e9def577-a57f-4fd4-b8fe-b2e5ca35e922', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '64ce1af5-382a-41cd-a481-5abb05d96e0f', 'LS6', '例数', 5, null, null, null, '0', 121, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('dcb2732c-5d56-13c8-3749-4a47fce169bb', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f122', '8ca4667d-c4f7-45bc-a1cb-45ba19d014e0', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'b6213048-06d0-46d3-86c1-5df65631771d', 'LS6', '例数', 5, null, null, null, '0', 122, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7afad201-ae3d-9c3e-3110-d9f4ce5ca4d9', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f123', 'e48d3160-e9ed-444c-84d1-00016aafb212', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '1faa7fa7-2cb6-4523-9db5-0755768dd817', 'LS6', '例数', 5, null, null, null, '0', 123, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e56ad6cc-71c6-772e-43f4-56b1703ad388', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f124', 'b3babdb4-c130-4194-a186-4fd6e3efb7e9', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'bb4f9d7e-9fe0-4883-8fba-63ba23150343', 'LS6', '例数', 5, null, null, null, '0', 124, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('727d0b64-f5a3-809d-a1cb-8b3e365ac931', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f125', 'be970d90-0f58-4c7c-9640-949f83505c1b', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '295b4bd8-89f9-4047-9197-74d51269e6f3', 'LS6', '例数', 5, null, null, null, '0', 125, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ea0ef262-6939-ebfe-d4d2-510990d2ed80', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f126', '0d2522e2-f744-4995-a713-77697b29f43e', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'baec6768-2fdb-4d6a-938d-63eb3ccfcce3', 'LS6', '例数', 5, null, null, null, '0', 126, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('318787e0-ef6c-7d7e-4407-8730e52fea3e', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f127', '2532791f-4a04-4063-b817-eba8b9a87def', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'fd7761bd-a322-4e6c-a6f2-54590bfe7086', 'LS6', '例数', 5, null, null, null, '0', 127, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('01984f8f-68e3-8bce-9181-9489d1fec58a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f128', '5b9db9a6-935d-4f77-86c4-c0e98e1b61ae', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '2fd9bde9-febb-4bff-9fc4-fbb450d4a2fc', 'LS6', '例数', 5, null, null, null, '0', 128, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6ee8a216-4ad0-3447-fc79-7a788597b732', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f129', 'eea0dd01-5cc1-4cf0-818b-0ba7c59c019f', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '42e0fefe-a860-4cb5-b537-f12bc48db64e', 'LS6', '例数', 5, null, null, null, '0', 129, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('61e15410-abf1-7331-7c3f-511643373f3a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f130', '63b174c0-2c04-409f-a27e-0d484b2233d9', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '7a2e2114-e31b-4dab-ad2b-1162d02635d6', 'LS6', '例数', 5, null, null, null, '0', 130, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('0ef9a1e5-4371-90a9-e090-c44e07bd0d6c', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f131', 'f430e1a6-9e9c-44cb-8f8e-b8988aaf5a37', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3dec2c62-fad9-4065-b46e-3cdcb48db225', 'LS6', '例数', 5, null, null, null, '0', 131, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c4cddeb7-5d12-f974-f656-244ff6c3842a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f132', '5be1f2b1-bbc4-45b3-8ff8-984d914b987c', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '28f58e52-7f02-4c55-9512-4c86645c3c64', 'LS6', '例数', 5, null, null, null, '0', 132, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('75313216-0101-d2a6-f58a-9813f0a46d49', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f133', 'bf5ad8b9-72b5-415b-b590-a6450b00c0fe', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '57d2e698-bf11-419d-ba5f-e8914c8da80c', 'LS6', '例数', 5, null, null, null, '0', 133, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f5212344-98cc-ef93-8287-f01e6b234233', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f134', '6af37b6f-8717-4c0f-950a-aa134860c0e9', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '5e0103c2-d3c2-4a65-bc76-8f07ae512d89', 'LS6', '例数', 5, null, null, null, '0', 134, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('038b5d34-2332-f3ab-c743-6402d1494e8f', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f135', '1d56c4a7-6c9f-43f3-9497-a0fbdffbe373', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'cb2da639-24eb-41df-ad37-38f6a8fb8ac9', 'LS6', '例数', 5, null, null, null, '0', 135, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f49d0694-b026-6522-8396-8709b18b91d6', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f136', 'f08379b0-32c7-4b3d-acfc-6f0672bea853', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '4206329c-c1ab-4a08-8174-cbd074a3cccc', 'LS6', '例数', 5, null, null, null, '0', 136, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2c23da19-9644-6fdb-7c35-dfd90c803716', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f137', 'dc763a27-a3bb-40c0-8321-98d9f09005c4', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'cd959034-a14c-4dcc-950b-f37adca31059', 'LS6', '例数', 5, null, null, null, '0', 137, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6f6376c4-e0ce-2a5a-d639-d819ff3f9e0c', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f138', '7c62b93e-f7b8-47f9-b254-72bb461f919c', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '5432d803-3613-4c83-a07a-0f5f2e2d9497', 'LS6', '例数', 5, null, null, null, '0', 138, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b02ec978-f2da-43ab-a3c3-91fdaa29fffe', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f139', '04956869-d13f-45aa-9ef6-e81d2c1c0db1', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'f42f2ba7-cfad-47ef-94ba-6ccd771250c8', 'LS6', '例数', 5, null, null, null, '0', 139, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b0ec1235-128e-dafa-eaf0-7d2cb57634e1', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f140', '11a5436b-5f8b-460f-a7bb-b70b10ae84f3', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '45e83cb6-3eb7-4060-aa90-2dac7ab36d3c', 'LS6', '例数', 5, null, null, null, '0', 140, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('fcc6d910-b147-38e0-6ef2-275be9f5c735', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f141', 'f75b76ca-ebc8-4160-aa5b-aef2adeab4e2', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '25603904-84f3-42b7-be2b-c669c37e1e1f', 'LS6', '例数', 5, null, null, null, '0', 141, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('bd2bf2fa-4c82-1454-3b84-a418983eb92b', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f142', '55a17173-254f-4675-873a-4c25c6ba1d22', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '11430e3e-cec1-4b22-b054-a64bf9bb6162', 'LS6', '例数', 5, null, null, null, '0', 142, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d4633919-18cf-f99e-02c3-717a0acf58a1', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f143', 'c6d92378-5687-426e-ba32-bc3f89bd096e', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'dcec4052-e876-43a0-b9c5-38b21a8387e8', 'LS6', '例数', 5, null, null, null, '0', 143, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2af2886d-2f67-a575-51fa-3e9493653baa', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f144', '994f0acf-a354-459c-8a71-85efe64f1411', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '223c80d7-157c-4099-a674-257482693fa3', 'LS6', '例数', 5, null, null, null, '0', 144, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ebc913f9-8758-c5e3-87ca-d360ff2188c7', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f145', 'aa870f0b-197c-4207-8cc3-ea3b68a5cfb9', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'ac9dea0a-8b0d-4de8-bad2-0b8a57a361c5', 'LS6', '例数', 5, null, null, null, '0', 145, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('8f9fa026-c7be-9a0b-813f-a480dd648a9a', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f146', '69487b3f-3e45-4d67-827e-97e35a5bfb86', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '40d3f761-c688-49d3-bb4c-618f980fe182', 'LS6', '例数', 5, null, null, null, '0', 146, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a8688e73-0789-f56a-7d65-545c01f2e67e', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f147', '2afd2ca5-0779-4a78-a0a2-95badcdebb8c', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '8b57b2e3-76f5-403a-a859-58531470d24c', 'LS6', '例数', 5, null, null, null, '0', 147, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('19298d4f-a831-ba6b-53b2-8c0ec6a318e1', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f148', '66d88aa2-2077-489b-8d77-ece938702414', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '59227e48-4e15-4a08-9076-fb54abf44901', 'LS6', '例数', 5, null, null, null, '0', 148, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d8318217-23f5-adea-93fc-cdc62bfd1338', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f149', '8a1aae74-4681-4848-afad-8606c656edfd', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a345f094-0210-4372-83c2-af92dd3a5e59', 'LS6', '例数', 5, null, null, null, '0', 149, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('81e10492-6246-3f7b-a5e3-fd003fc7c405', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f150', '35cb08b4-f35a-44aa-b119-6d1f16b7ded2', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c84913d7-d125-431f-a365-430b3e186cb1', 'LS6', '例数', 5, null, null, null, '0', 150, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b6c8fb8e-a0a8-ba72-bdeb-c048726bb291', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f151', 'd6e13752-95b6-4484-bcce-b8870c229d27', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '289e698d-9322-4ade-a4a9-f721fd656afc', 'LS6', '例数', 5, null, null, null, '0', 151, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c6a3f9d0-66e0-9127-49a6-5db668061fd1', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f152', '6561facd-57b0-42e1-89cf-3679e14745bc', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '07533aeb-7401-4f46-8350-f81cf753533d', 'LS6', '例数', 5, null, null, null, '0', 152, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('5aac067a-f146-be51-5aa3-893f051a2445', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f153', 'be12ad51-1397-460a-8ccf-d5cffa9cbf52', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '0ce4d948-25dd-40b7-8d49-8fa2e92965ff', 'LS6', '例数', 5, null, null, null, '0', 153, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('4a4d8a06-1803-aa01-860b-bd2e7deed12f', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f154', 'e634a9c1-b1be-4a20-8b51-c9177bfae77b', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '7346d493-83f3-460e-a7b2-e755f44eb4c0', 'LS6', '例数', 5, null, null, null, '0', 154, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('39fd7ba1-7cf8-9b64-b388-8d62534ed40f', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f155', 'f8125b52-62cd-4319-aa12-c76f321634cf', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '07056084-2f68-45c5-afcf-a18e3b58d1b9', 'LS6', '例数', 5, null, null, null, '0', 155, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('89f99129-61e6-5025-32b1-0533ae45a9e6', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f156', '67ab2d15-e119-4847-a0d3-8f58d6706b40', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '4c6546ab-eb48-489a-aa8b-6d7ad4e1791b', 'LS6', '例数', 5, null, null, null, '0', 156, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('82273a11-be09-c6dc-bcba-312de051c723', 'bd76fadb-c272-c3e3-00c9-46cd2f7c70a6', 'f157', '4ee7eaba-b3a4-4ccd-a68a-381124bce780', '92bb730e-374e-42a0-b952-de1c1bbb01b6', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'fd711add-7461-465d-9f05-32e138711185', 'LS6', '例数', 5, null, null, null, '0', 157, 4, 0, 833, 832)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_template (id, source_custom_form_id, form_name, business_type, field_count, answer_count, card_count)
values ('2c3141a5-c734-c63d-ff5d-26c37848fc18', '107c9506-6540-4985-9ac6-fd7de6b3f378', '起搏器报表', 'quality', 48, 47520, 990)
on conflict (source_custom_form_id) do update set
    form_name = excluded.form_name,
    business_type = excluded.business_type,
    field_count = excluded.field_count,
    answer_count = excluded.answer_count,
    card_count = excluded.card_count,
    updated_at = now();

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('bd2e46f0-8bb1-e824-3e5e-e64791ab3306', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'quality', 'f827ae4a-f24f-4df9-b92f-7601025a1864', '107c9506-6540-4985-9ac6-fd7de6b3f378', '起搏器及CIED植入/置换')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c046917e-a38e-2788-3216-4bb6773d22a9', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f001', '3b80d11f-8742-4e28-af05-bc1610ef7c69', null, null, '1143dabf-982d-4d42-93ef-a25fbc13f20f', '0193be2a-397b-40a1-a7c9-4623dfdd5d12', 'GXBJRZL2', '起搏器报表', 1, null, null, null, null, 1, 1, 0, 990, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ace96b29-88f3-abf1-6e87-fc566f81d2aa', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f002', 'b621998b-8a1e-49fd-bb30-8c486c4d5b26', '3b80d11f-8742-4e28-af05-bc1610ef7c69', null, 'f2fc2386-7713-4da6-968e-589b1f0f498f', 'bd3b9ea7-d7b6-499f-9a40-eca3a65c7904', 'HZCYSZYF', '患者出院所在月份', 4, null, null, null, 'YYYY-MM', 2, 3, 0, 990, 706)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b67cc2db-968b-5da4-389e-01e8c793669e', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f003', '858ea8a0-0b65-4e9f-8911-f23e05805c77', '3b80d11f-8742-4e28-af05-bc1610ef7c69', null, '43437603-8a66-43fc-bf05-f5e3b969b8b1', '3b26895e-5575-4432-8a3a-f3a96aa96be7', 'CWSZOX2', '单位名称', 10, null, null, null, null, 3, 2, 0, 990, 696)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2a80c955-46f5-82c1-9927-3675dec1824c', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f004', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', '3b80d11f-8742-4e28-af05-bc1610ef7c69', null, 'b9568d81-cfd8-490f-92c4-74855349dc84', '98483699-9d6e-4ab8-be9f-87e42bc3eb60', '0-_-完成例数-_-1###0-_-死亡例数-_-1###0-_-心包压塞例数-_-1###0-_-气胸/血气胸例数-_-1###0-_-电极脱位例数-_-1###0-_-永久起搏器（单腔/双腔）-_-2###0-_-ICD（单腔/双腔）-_-2###0-_-CRT（CRT-P和CRT-D）-_-2###0-_-无导线起搏器植入-_-2###0-_-电极穿孔例数-_-1###0-_-心包积液例数-_-1###0-_-感染例数-_-1###0-_-动静脉瘘例数-_-1###0-_-假性动脉瘤例数-_-1###0-_-其他并发症例数-_-1', '起搏器报表', 13, null, null, null, null, 4, 3, 0, 990, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ed3dc148-9be6-86a4-5f65-6c01fe648137', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f005', '3b9af3a5-8b11-4774-b119-9aaecd799937', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '38504a05-0658-478d-957c-3edfa2e438d2', 'LS6', '例数', 5, null, null, null, '0', 5, 5, 0, 990, 989)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('08d9e974-6eb7-d477-6771-9ada29311734', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f006', 'eaaf9d2a-f6e0-428a-b1ad-fcc5d2a73035', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '808751b2-f4a4-4aad-a6ae-17233ce82973', 'LS6', '例数', 5, null, null, null, '0', 6, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e5e1a3d7-e797-3472-fc52-dd88b9f5c9b1', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f007', '0ae58cda-bffd-4954-92cd-24ac506229dc', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '1f162197-f2ba-4c92-b13c-b029878bb30e', 'LS6', '例数', 5, null, null, null, '0', 7, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3fa9b574-807b-17fa-f2c3-93ee009b280e', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f008', '5d909e13-e832-459c-b019-5f1e203edee7', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '102611c2-d725-4c8e-a265-de06230b0398', 'LS6', '例数', 5, null, null, null, '0', 8, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('7c32e9ec-3411-6348-a58f-7e83057b77c9', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f009', 'e80dbbb4-8a5c-4c84-88dd-6124822b3103', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '29631169-a8a8-4ea9-9538-6b7dfe907b4c', 'LS6', '例数', 5, null, null, null, '0', 9, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('326fdfb9-2479-39e2-c9d6-3d23ee73c47f', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f010', '3111e879-bbee-414e-8dca-0fddb66b65e4', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c99d6eb8-5e79-4cf7-ac4a-b44c79e3b3cf', 'LS6', '例数', 5, null, null, null, '0', 10, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('dea40401-f639-04d0-3a81-a17e69fc1836', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f011', '83495857-c079-4b9e-b43f-289c6b1e7b15', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c5e72c30-0653-4942-b151-efc9bd6b5b49', 'LS6', '例数', 5, null, null, null, '0', 11, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('df7de3dc-8cf5-ad02-c60c-c2543f289283', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f012', '5e6de774-0adb-4787-bfa3-d12520c005f2', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'add1ad4f-28a8-4183-9c29-713da6b8a9f2', 'LS6', '例数', 5, null, null, null, '0', 12, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('70c3688d-8cf8-658f-580f-1a75de4fa450', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f013', '1ab0efb6-5cc3-4951-b813-71f90a03bd6a', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'ab36bf70-01ce-493d-a999-f69bc7a77198', 'LS6', '例数', 5, null, null, null, '0', 13, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('81edea0e-59c2-87de-6ccb-b7b533641d3c', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f014', 'f9bbc094-1d84-46ed-8bd8-4e8e8a094733', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '6af04b79-3621-472f-9de7-ce5aa4246c78', 'LS6', '例数', 5, null, null, null, '0', 14, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('aa5b0e4e-d8de-6ca2-dc71-1c14ca52808c', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f015', '270ae218-8360-4ed1-a5f7-a22cf3065c0f', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '603aaf20-bbfd-47ce-95e3-b5593480238b', 'LS6', '例数', 5, null, null, null, '0', 15, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('334f061a-ddf7-1a9e-d4f7-9d7e31aeba86', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f016', '9637312a-a392-42fc-aa67-d1699749005f', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'b692355a-e968-44bd-a00a-fd95175fc1b7', 'LS6', '例数', 5, null, null, null, '0', 16, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('53454f02-fdd3-7527-1217-fbb28f6e60b4', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f017', '6dc3d8c2-beb4-47ac-b5cd-b2a10c3bf7de', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '406bc7f8-ac92-4148-8690-09f48002b0ff', 'LS6', '例数', 5, null, null, null, '0', 17, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('73455961-75c8-275b-97b9-42cf0b4286a2', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f018', '51bedff9-554c-4204-bcc4-01b3049f8450', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'dce2c6ba-e507-4587-9315-b93c3b023cfb', 'LS6', '例数', 5, null, null, null, '0', 18, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f6739ee0-b010-e980-2233-f8d48f38d989', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f019', '444ea63d-dc62-41db-9258-900ca82271b2', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '4ba24895-f063-4fab-bc4e-6315d361a249', 'LS6', '例数', 5, null, null, null, '0', 19, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('68c2eb4f-d78c-95af-8661-05fae1bf55d0', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f020', 'e51cfabb-9f81-42d0-a9f0-903eb02d945e', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '13ef9e23-1338-4e75-885e-74cc7b8c1003', 'LS6', '例数', 5, null, null, null, '0', 20, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('cc46bcb9-7f6c-3f0d-56aa-082ee7af6fb9', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f021', '4c780c57-0d63-4a77-bf14-0a4599eaf701', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '503d7180-1266-483a-b80c-eed35d08fe64', 'LS6', '例数', 5, null, null, null, '0', 21, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('3152d39f-d531-37c7-b46b-abeae8d50fc0', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f022', '36fac78a-c5fe-4c20-81b3-e997c1b6c3c5', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '0469ee7a-d3bd-48c0-abd0-13780a035c8e', 'LS6', '例数', 5, null, null, null, '0', 22, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c18ccd66-fa34-eefc-8dd6-7cc02f79e527', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f023', '1b60f5fe-5186-458d-a294-d18dd290ecb3', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'f4550fa1-00bb-4b3b-a72f-6da371d55d56', 'LS6', '例数', 5, null, null, null, '0', 23, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('faefee50-89ec-fde9-ca1a-0f2dfac80ad4', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f024', 'ee7221c5-e77a-4dca-9826-9b3c5cb408d0', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'e2ee3c2e-13d8-482f-82ac-8afd28da6d3d', 'LS6', '例数', 5, null, null, null, '0', 24, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('bd0e2e9d-1d8d-6a9b-0e0a-f5c4dbf1f86f', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f025', '09b2f28d-8e06-4426-b00c-068c258da5a5', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'dcaae013-305e-48ef-a287-4d5ec3825727', 'LS6', '例数', 5, null, null, null, '0', 25, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('38bc284c-4b59-a0e0-c121-5625a931b519', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f026', '424aff34-454a-43f1-9877-b43b286b5d96', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '410a10d7-dbe4-402c-9fbe-e483a43a677d', 'LS6', '例数', 5, null, null, null, '0', 26, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('0e4b5a0d-4240-fc6d-f13d-84de1ef7eb74', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f027', '29c63a7a-be4d-4040-a845-fbcea69a74a6', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '16ca4393-63fc-4e4c-9690-d7d00babaa37', 'LS6', '例数', 5, null, null, null, '0', 27, 5, 0, 990, 989)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('655714d5-bf9c-053a-1394-e65d4e9a3723', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f028', '1a2e2397-2896-4d17-ab80-2618c6452ab0', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '681cc28c-5ef3-4c99-ab0e-c09f83477272', 'LS6', '例数', 5, null, null, null, '0', 28, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b1f082d8-b938-6b07-be3e-b539b599c6ca', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f029', '86034c33-416d-417a-bffb-30eeae4dd91b', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '86ddabd5-8dbc-496d-a06d-07efa6a25d9d', 'LS6', '例数', 5, null, null, null, '0', 29, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e74f90b2-7aeb-908d-8ddf-06cf0312a6de', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f030', '5e40c865-661e-4c7a-9f9a-7e19706fb659', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '6d6ae8b7-c5cf-4c3f-944b-46dbf9f4aa62', 'LS6', '例数', 5, null, null, null, '0', 30, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e6642214-43b2-05b1-deef-9d17833332f4', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f031', 'b3f63dc5-0bb3-4843-a61d-b7c4c02a60d4', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'b502f6f5-c5cc-462d-a5aa-a31c6ce774a4', 'LS6', '例数', 5, null, null, null, '0', 31, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('32daae32-1fa0-d22a-ee8e-75a0ccc3bab6', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f032', '4a44441d-1d81-4deb-9832-68189a7d5980', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a50b4cfa-8af1-4953-80e7-cbe5ce817b9c', 'LS6', '例数', 5, null, null, null, '0', 32, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9a4df822-db50-b447-7764-2c0a33f20848', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f033', '284fd295-0ea7-4cf4-b8ed-d6cefa577b90', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'cd93dbdf-79bc-48fa-bbd2-5170dd2f65fe', 'LS6', '例数', 5, null, null, null, '0', 33, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('4fdaf829-716b-bf27-8694-b22aa8e93bea', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f034', '453f07c7-7d9d-4dc2-9b33-a18a72ecc3ec', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '57cbcfc9-e157-43e1-b32b-ffab65869f7a', 'LS6', '例数', 5, null, null, null, '0', 34, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('203f390e-3cea-566a-56b3-34b8573764d0', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f035', 'a1b406a9-01b3-4aba-8468-6ccd5785e629', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a0b9b7cc-6082-40d3-87b8-be2a8f274b27', 'LS6', '例数', 5, null, null, null, '0', 35, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('017130c5-00c1-cf01-2dee-ae8f7ceb8c3f', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f036', 'e6d8c506-12da-4918-bfa5-1fc6654d49c4', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '21fe82ea-05c5-4110-830b-59b651b9ff7d', 'LS6', '例数', 5, null, null, null, '0', 36, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('27c39767-d5d6-45fa-9015-85731172c052', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f037', 'c7dcc327-5bd0-458b-8d7a-0206b5ff0140', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '715c5caa-b277-4ae7-b21a-a0edee667f18', 'LS6', '例数', 5, null, null, null, '0', 37, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('cb095fc7-12d0-9b60-0bb3-f7b6136c2e56', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f038', '6589b432-f76c-48d1-9770-013796d36af9', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'c3faee9a-7013-4701-976b-c864e8b00106', 'LS6', '例数', 5, null, null, null, '0', 38, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ea1da420-262d-dabc-602a-b59a9a02b6ee', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f039', 'a3ba4970-3a96-43e0-a6bc-8a96244adeb6', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'f512004a-d6ee-46be-9857-96ed681e94d2', 'LS6', '例数', 5, null, null, null, '0', 39, 5, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e09bc5c5-d82b-049d-c1fc-707274875f83', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f040', '29495a1e-f014-4ac1-9ce1-5be35c9c26b5', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '2de4b9cf-8ba7-458d-9d4d-f50567f691f9', 'LS6', '例数', 5, null, null, null, '0', 40, 4, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('249bd7fe-9766-ca22-fada-33f2bda774fa', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f041', '1838ffc2-71ee-4960-9217-744bb9a124d0', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'bcf58ad4-c4c6-4a8d-82c8-3e34018514f5', 'LS6', '例数', 5, null, null, null, '0', 41, 4, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('48b732c1-7c7d-c42f-ecb0-1f7febccab3f', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f042', 'dd5ba293-f57e-4993-99fb-ff5365e44611', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'fb1bc8d0-badf-4ff2-9690-96559d0f765d', 'LS6', '例数', 5, null, null, null, '0', 42, 4, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('639c08f4-5bb0-435a-cbd5-73aac452ee73', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f043', 'f8a959ae-0cf8-4ca7-b02e-d96ebb171bca', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '419c58a9-b53e-4181-a09d-f53eedc2cb0b', 'LS6', '例数', 5, null, null, null, '0', 43, 4, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('34ea2d30-d50c-8aa2-6e67-c30a2217481b', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f044', '7986e40f-b3f1-44c9-a777-7cffa8cd059f', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '79fee631-b1ee-4962-9e6f-2026130b4bc8', 'LS6', '例数', 5, null, null, null, '0', 44, 4, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f4f115b1-8979-70b3-aeb3-cdfc45da1e4a', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f045', '902c3cf8-d032-456e-8435-ed1bcdc7ece0', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '713bf65e-195a-4175-97ac-eb5842826077', 'LS6', '例数', 5, null, null, null, '0', 45, 4, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b0f66245-ed28-13d1-442d-7be20cf152b5', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f046', 'ece086b2-0bcc-415f-83ae-c7f12de843b0', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '4450dbe6-195a-4fa6-b094-5afefb2a7fc3', 'LS6', '例数', 5, null, null, null, '0', 46, 4, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('93885aa2-1f8c-4712-9c54-b833166960e9', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f047', '586d17dd-2a57-4c09-8d9f-9fa1f2bbe7ad', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'b89c8bf3-8ed8-4b2e-96e6-4b6083fc5499', 'LS6', '例数', 5, null, null, null, '0', 47, 4, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('80f3a62a-1f12-0503-02e7-edfa0733c8a2', '2c3141a5-c734-c63d-ff5d-26c37848fc18', 'f048', 'b8860cc9-28c0-4255-b771-0813d1848d35', 'b5c3c523-4f8c-4147-9f73-ce25d69e0a7a', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'd0d2da33-c9e4-438d-ba31-8011fb28a6dc', 'LS6', '例数', 5, null, null, null, '0', 48, 4, 0, 990, 990)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_template (id, source_custom_form_id, form_name, business_type, field_count, answer_count, card_count)
values ('6b21024a-9979-4966-9408-670bf4e4c722', '9299ba76-9d95-4bb4-9a3a-2dc1b39dd677', '冠心病介入报表', 'quality', 39, 49335, 1265)
on conflict (source_custom_form_id) do update set
    form_name = excluded.form_name,
    business_type = excluded.business_type,
    field_count = excluded.field_count,
    answer_count = excluded.answer_count,
    card_count = excluded.card_count,
    updated_at = now();

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('e23c3356-4e6b-2ba2-8a7d-4f2f7a22bbc0', '6b21024a-9979-4966-9408-670bf4e4c722', 'quality', '6237dd62-15b9-4676-972d-bf32476b3546', '9299ba76-9d95-4bb4-9a3a-2dc1b39dd677', '冠心病介入')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6f816de6-5405-8554-c66d-1f1b4dcea4b1', '6b21024a-9979-4966-9408-670bf4e4c722', 'f001', 'aa8aa8d5-f9d4-4f31-9df3-3d0639849270', null, null, '1143dabf-982d-4d42-93ef-a25fbc13f20f', '52f4150f-ddc8-49f4-8f5e-e099300a2cf4', 'GXBJRZL2', '冠心病介入报表', 1, null, null, null, null, 1, 1, 0, 1265, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6fb52364-5ecd-f632-38ab-67475cc8fbb3', '6b21024a-9979-4966-9408-670bf4e4c722', 'f002', 'd4206e7d-e68c-470a-a49e-37a88cb99f12', 'aa8aa8d5-f9d4-4f31-9df3-3d0639849270', null, 'f2fc2386-7713-4da6-968e-589b1f0f498f', 'c8e6560d-c8b8-4c95-b025-3ffcce8f09af', 'HZCYSZYF', '患者出院所在月份', 4, null, null, null, 'YYYY-MM', 2, 2, 0, 1265, 983)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('68bcc355-0dfd-52c4-97ed-e94952be1409', '6b21024a-9979-4966-9408-670bf4e4c722', 'f003', 'd43a617d-c411-4733-b973-f18366bc9481', 'aa8aa8d5-f9d4-4f31-9df3-3d0639849270', null, '43437603-8a66-43fc-bf05-f5e3b969b8b1', '86451c4e-846b-4385-887f-815c0abd8710', 'CWSZOX2', '单位名称', 10, null, null, null, null, 3, 2, 0, 1265, 977)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c187f28e-8db0-6c99-a9a9-8e869929a434', '6b21024a-9979-4966-9408-670bf4e4c722', 'f004', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', 'aa8aa8d5-f9d4-4f31-9df3-3d0639849270', null, 'b9568d81-cfd8-490f-92c4-74855349dc84', '053428e4-f2db-474e-8feb-ae438726b1b2', '0-_-完成例数-_-1###0-_-急诊PCI（STEMI）-_-2###0-_-急诊PCI（NSTEMI/UAP）-_-2###0-_-死亡例数-_-1###0-_-心包压塞例数-_-1###0-_-冠状动脉穿孔例数-_-1###0-_-医源性主动脉夹层例数-_-1###0-_-择期PCI-_-2###0-_-急诊CAG（单纯造影）-_-2###0-_-择期CAG（单纯造影）-_-2###0-_-非计划二次手术例数-_-1###0-_-其他并发症例数-_-1', '冠心病介入报表', 13, null, null, null, null, 4, 2, 0, 1265, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2eea1889-d262-6e32-49be-59b17c49052a', '6b21024a-9979-4966-9408-670bf4e4c722', 'f005', 'ab9722ed-f8e8-4a80-9f74-cd2a8215542e', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'f06f413e-336c-46dd-a639-cd9b26b6a5f6', 'LS6', '例数', 5, null, null, null, '0', 5, 3, 0, 1265, 1264)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('2ada9682-ef15-742a-55df-03873c06fca7', '6b21024a-9979-4966-9408-670bf4e4c722', 'f006', 'f451d827-475b-4f97-8576-bc20b4a1df27', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '59106207-5c08-401f-b06b-55a6804298e4', 'LS6', '例数', 5, null, null, null, '0', 6, 3, 0, 1265, 1264)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1bf6c9e6-4b1a-e67a-002a-f6cfcd85bff0', '6b21024a-9979-4966-9408-670bf4e4c722', 'f007', 'a6c595c9-820b-4825-9c63-bac08f9269fe', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'f3979b79-0027-4c36-b266-933f62cbb10b', 'LS6', '例数', 5, null, null, null, '0', 7, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c9b2b96c-36b1-74cb-e58f-943fa17ce15e', '6b21024a-9979-4966-9408-670bf4e4c722', 'f008', 'd6e310b2-abd9-4df9-b99d-664cdf59991a', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'd066bf8e-3fb8-4dc5-b42a-52b40591a6b0', 'LS6', '例数', 5, null, null, null, '0', 8, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('db2aaa55-3d51-3f47-0691-1383b5e46b9c', '6b21024a-9979-4966-9408-670bf4e4c722', 'f009', 'd6815cbf-446f-4696-96b0-2d90f2c07531', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '586de76e-b0b9-4713-b07a-71fc8b57307b', 'LS6', '例数', 5, null, null, null, '0', 9, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('16dfbd79-d8fe-6a48-9246-129ff26702d2', '6b21024a-9979-4966-9408-670bf4e4c722', 'f010', 'ac5106cf-846d-498b-b4fb-c0835dd6c9fc', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '96d937ff-db72-4369-9af4-0208cca3019c', 'LS6', '例数', 5, null, null, null, '0', 10, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b677eb03-985e-6fad-5448-d6b0c35fcf79', '6b21024a-9979-4966-9408-670bf4e4c722', 'f011', '051c3393-e4ad-47e5-9073-d01a8478bb8b', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'cbcfca0b-4e8d-4894-b663-5bf2b21d157f', 'LS6', '例数', 5, null, null, null, '0', 11, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('26f1c338-1ceb-dc0a-70b9-7252c6251473', '6b21024a-9979-4966-9408-670bf4e4c722', 'f012', 'e8f1d118-5185-4b71-9e80-9abfea2f6714', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'ac892b7b-16d1-4c58-8bd8-9b7fae8d7e58', 'LS6', '例数', 5, null, null, null, '0', 12, 3, 0, 1265, 1261)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('36abb770-7576-6c58-2c98-a76301b68dc8', '6b21024a-9979-4966-9408-670bf4e4c722', 'f013', '952a49e0-1f74-4363-9592-08a9fc6d9aea', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '0b1b34a8-33d7-4e04-95bf-3c27b3db472f', 'LS6', '例数', 5, null, null, null, '0', 13, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f6d6b25a-bafd-7ed8-1e51-6c0b52ab10cf', '6b21024a-9979-4966-9408-670bf4e4c722', 'f014', '98346609-49b3-4696-91c2-83c80caaffb5', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'a6bc3a7b-fd08-438a-b6ef-781d1e764766', 'LS6', '例数', 5, null, null, null, '0', 14, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('031e7ede-977d-d5f8-955a-a7ba2a23f01c', '6b21024a-9979-4966-9408-670bf4e4c722', 'f015', '201ce1a3-1767-4351-8e41-719295259695', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'bf7c0be9-8965-40cc-882f-8fd73f2d4286', 'LS6', '例数', 5, null, null, null, '0', 15, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f7630ce2-5330-b717-015a-ef90878738ad', '6b21024a-9979-4966-9408-670bf4e4c722', 'f016', '8547c4bc-01d4-486c-8aa8-866528a7eb5f', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'f3bdc735-553a-4dfc-8895-2d507d3aec88', 'LS6', '例数', 5, null, null, null, '0', 16, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('81131601-e095-843f-e3ad-b967eb2d4c12', '6b21024a-9979-4966-9408-670bf4e4c722', 'f017', '4811c2d7-4177-465a-b1bd-eb1197e87820', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '67e407a6-b306-4241-afbe-64001e1b8eca', 'LS6', '例数', 5, null, null, null, '0', 17, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('8b84f561-9c40-4d21-8515-7d4632b314f3', '6b21024a-9979-4966-9408-670bf4e4c722', 'f018', '4ea2d31d-4aab-44cd-9168-39452e965da9', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '7e6fe77b-dae4-41c1-a9ee-6777d5f4d495', 'LS6', '例数', 5, null, null, null, '0', 18, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('587be6a9-fc19-9d51-fb47-0c5bd7825c74', '6b21024a-9979-4966-9408-670bf4e4c722', 'f019', '4b60d653-2845-4e7a-824d-1b46c1da49b3', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '17a13229-e2a1-442f-b5eb-87a107782e6f', 'LS6', '例数', 5, null, null, null, '0', 19, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('bc6c4552-6642-ac0b-7e26-2a7bdf1adf46', '6b21024a-9979-4966-9408-670bf4e4c722', 'f020', 'c28b854b-d229-4ae0-8d94-effcba91f213', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '77668b51-6bfa-43b9-87a0-33665678d827', 'LS6', '例数', 5, null, null, null, '0', 20, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c1700c62-b053-8a98-0898-87c8fc088250', '6b21024a-9979-4966-9408-670bf4e4c722', 'f021', 'c568063c-ab0c-478e-94ea-e17c5a193f21', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '4b2a9063-beb7-43c4-82de-4695627fe586', 'LS6', '例数', 5, null, null, null, '0', 21, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('64e1341a-3916-2af6-022c-c9622b30a6c6', '6b21024a-9979-4966-9408-670bf4e4c722', 'f022', '429a50c8-b1ee-4d90-80ce-605f340edb75', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '34800069-ef0f-4532-8f6e-c6a9aa69a0f3', 'LS6', '例数', 5, null, null, null, '0', 22, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a2dae2db-0f51-8b5c-4574-44ed7ef4ae4a', '6b21024a-9979-4966-9408-670bf4e4c722', 'f023', '8bb996e2-a1dc-413b-b819-9acc440aa018', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '3c6eab19-41e5-4038-ab95-02187c86d7ab', 'LS6', '例数', 5, null, null, null, '0', 23, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ac50cf1a-a5e3-9061-276f-5ea57869b7fa', '6b21024a-9979-4966-9408-670bf4e4c722', 'f024', '1367f562-1a61-4a42-8010-2a3e0e65db90', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'f44b8cc8-2732-4bb2-b1f0-3fc724fdb03a', 'LS6', '例数', 5, null, null, null, '0', 24, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('bfb6e670-053e-4e31-18df-1b681a8e8ac2', '6b21024a-9979-4966-9408-670bf4e4c722', 'f025', '69b55ad3-fe57-4853-833a-edf6e1205f0a', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '697cfd34-6509-4c12-94f9-19fe3198eecd', 'LS6', '例数', 5, null, null, null, '0', 25, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('71db5766-bb57-bc12-fa0e-e001200644e0', '6b21024a-9979-4966-9408-670bf4e4c722', 'f026', 'b85c783a-bb7b-4ee1-9592-50bcee8d5db8', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '934585b3-b79b-4d2c-8e5f-2ce729d784a0', 'LS6', '例数', 5, null, null, null, '0', 26, 3, 0, 1265, 1262)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6ffdb1d7-566b-dd41-fa3e-b60ff4638dd1', '6b21024a-9979-4966-9408-670bf4e4c722', 'f027', '68def931-3f63-4e77-a144-28eca58b54cc', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '82813926-eedd-450b-b910-eb09e463cbe6', 'LS6', '例数', 5, null, null, null, '0', 27, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('56696ebb-91a0-884d-c6e3-e842607f0eda', '6b21024a-9979-4966-9408-670bf4e4c722', 'f028', '51024f1d-31df-4302-b2cc-9d9b2fddf214', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '2fe7e788-65f8-4035-9406-1f36977b4173', 'LS6', '例数', 5, null, null, null, '0', 28, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('63fee02f-a87c-ed51-6e01-ccd61b72af9f', '6b21024a-9979-4966-9408-670bf4e4c722', 'f029', '4c9bbdc9-6f59-491a-9f6f-dc0b1ba6f699', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'bac029b7-8b33-436f-b795-e41ea219b9f5', 'LS6', '例数', 5, null, null, null, '0', 29, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('15bb1dc1-4394-1118-3abe-3d6724791c0c', '6b21024a-9979-4966-9408-670bf4e4c722', 'f030', '8c51cf5a-a1c6-4794-aa5f-ecc579a1701d', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '5c77a3ad-2192-4661-bb52-acbb82574707', 'LS6', '例数', 5, null, null, null, '0', 30, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('8695779a-4b6e-ef51-d7c3-e9cb7ba77e1e', '6b21024a-9979-4966-9408-670bf4e4c722', 'f031', '35681054-efc1-46ac-b829-190cbcdbd7e6', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '90887190-f81b-4430-b27f-79fc640eca7a', 'LS6', '例数', 5, null, null, null, '0', 31, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('42df7f8f-1323-df63-37b7-8db20c425611', '6b21024a-9979-4966-9408-670bf4e4c722', 'f032', '0b481fa1-eb10-433a-823f-7a7daf9983a3', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '5fb4a9d0-6eef-4f7e-ae5a-03f1fb985b96', 'LS6', '例数', 5, null, null, null, '0', 32, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ba48508b-bf38-9665-65f9-6b78fb622762', '6b21024a-9979-4966-9408-670bf4e4c722', 'f033', '31b315c9-2638-4fee-b3da-212d39aeed4f', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '8bbe9f83-bc59-4f60-93ab-0f2021f0ff5e', 'LS6', '例数', 5, null, null, null, '0', 33, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a298410c-7db1-f1e3-09b0-6a43d2c800be', '6b21024a-9979-4966-9408-670bf4e4c722', 'f034', '2615850a-590c-4b4c-afb1-f035676af8eb', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'ddf7e7be-987a-436c-a9d3-03f5f4899bee', 'LS6', '例数', 5, null, null, null, '0', 34, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b9a14aa7-8140-b57c-9e3b-fdff98d0502e', '6b21024a-9979-4966-9408-670bf4e4c722', 'f035', 'be27b7a4-cdb4-4f43-92a8-123b04439f16', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '1dcc3532-3b02-4ea2-b269-31d8ee853b27', 'LS6', '例数', 5, null, null, null, '0', 35, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6437dc11-1ddb-fcb3-c840-26a88e7191e8', '6b21024a-9979-4966-9408-670bf4e4c722', 'f036', 'f2d7cb71-56ca-4081-8b6d-5f4303b0feaa', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', 'e20cf522-b6eb-454c-8db9-0a78d9e02c88', 'LS6', '例数', 5, null, null, null, '0', 36, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('0ca32581-a1ab-4d3c-ddfe-27c3c658f6f4', '6b21024a-9979-4966-9408-670bf4e4c722', 'f037', '86231406-77d4-4b4a-aa76-f55866a43174', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '36f0045d-f6f2-4dc6-b8bf-8687a7cc6a1c', 'LS6', '例数', 5, null, null, null, '0', 37, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('0d5ae968-3b25-b384-a9aa-ba7497c7ed91', '6b21024a-9979-4966-9408-670bf4e4c722', 'f038', '165fea49-1000-45a4-917e-a2a485c1c0f5', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '4641b418-ce88-4cb7-b8b9-39c7af08b81c', 'LS6', '例数', 5, null, null, null, '0', 38, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('e976d38e-6eee-7a79-4b16-3b24ee2e66e9', '6b21024a-9979-4966-9408-670bf4e4c722', 'f039', 'd17fb560-0712-4e8a-b101-01f05e05c078', '478a9b6b-a7e6-4843-97c3-8ca2a6cb9899', null, '82efc52f-bec8-4c19-8924-8b4d57130950', '31e2f42a-e644-4395-8a13-ed51dd61f75f', 'LS6', '例数', 5, null, null, null, '0', 39, 3, 0, 1265, 1265)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_template (id, source_custom_form_id, form_name, business_type, field_count, answer_count, card_count)
values ('456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'd7531e8e-17d8-4c45-a98e-73c23c31e1db', '专家评审', 'appraise', 18, 114444, 6358)
on conflict (source_custom_form_id) do update set
    form_name = excluded.form_name,
    business_type = excluded.business_type,
    field_count = excluded.field_count,
    answer_count = excluded.answer_count,
    card_count = excluded.card_count,
    updated_at = now();

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('4a723970-39ef-8cf3-7a9a-339b6985904f', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'appraise', 'ae92e4fa-5e02-4d4c-a773-3dc79c4935bc', 'd7531e8e-17d8-4c45-a98e-73c23c31e1db', '导管消融')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('63254f07-2206-41f7-9475-28697ca32c7c', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'appraise', 'c1174c60-2ef2-45f6-85dd-5269b567f996', 'd7531e8e-17d8-4c45-a98e-73c23c31e1db', '结构性心脏病介入')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('16409400-ab21-9636-fd1e-4b4e8cd8546f', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'appraise', 'f827ae4a-f24f-4df9-b92f-7601025a1864', 'd7531e8e-17d8-4c45-a98e-73c23c31e1db', '起搏器及CIED植入/置换')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)
values ('f06a27b1-9f89-0dc9-19a8-d594c8e32997', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'appraise', '6237dd62-15b9-4676-972d-bf32476b3546', 'd7531e8e-17d8-4c45-a98e-73c23c31e1db', '冠心病介入')
on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set
    form_template_id = excluded.form_template_id,
    template_name = excluded.template_name;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('daa56649-11c3-8ea7-ed5c-47e5a177e034', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f001', 'e209fa34-ecf2-49eb-9463-9ab099dbe216', null, null, '3b357cf9-8539-42c8-a508-2db754165c1f', 'f7b9f58f-8c51-46ae-b37a-b87be1142e10', 'JRXX', '介入信息', 1, null, null, null, null, 1, 1, 0, 6358, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('6595478a-4d94-d364-fecb-3d73dba5e076', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f002', '466c5af1-c6ae-4eaa-8e8e-4f379da81746', 'e209fa34-ecf2-49eb-9463-9ab099dbe216', null, '65a01171-11cd-489e-8f76-4c2cef172a5b', 'e45080ac-186f-4a02-a66b-dbfe60c6f7a4', 'JRKYZ', '介入适应症', 2, null, '111', null, null, 2, 2, 0, 6358, 6332)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ce624102-770e-52ee-2496-0b9b8149d81f', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f003', 'ffaee82a-6dfd-4824-b228-fb42bf6607ed', 'e209fa34-ecf2-49eb-9463-9ab099dbe216', null, '347837e7-62c7-44cf-9fc8-5326835005c7', 'b2a82f32-a4b3-41da-b3ba-7849afad6177', 'JRCZ', '介入操作', 2, null, '1111', null, null, 3, 2, 0, 6358, 6299)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('f2a778fc-d43b-4eb4-85c4-4761d383cf70', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f004', '4fca3add-4e61-4947-97bb-f2d7a72106c0', null, null, '4a616b80-5a60-4f6c-a982-a2a2c1fd8578', 'deb4b0c3-95c8-4c1a-96ab-09c03211cb4d', 'YYGL', '医院管理', 1, null, null, null, null, 4, 1, 0, 6358, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('dccec8b8-b3ed-8227-6cc1-cca9b2a17839', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f005', '3c61fdae-4de8-4607-b9ef-5bad584433df', '4fca3add-4e61-4947-97bb-f2d7a72106c0', null, '5ef5dadd-8d77-4aad-934c-217cdb90adaf', '3dd4474e-632a-485b-82f9-d027c204cb76', 'SBQXPTSFJQ', '设备器械配套是否齐全', 2, null, '11', null, null, 5, 2, 0, 6358, 6292)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('a0bce1e3-6b91-4518-5152-af3bf086b73f', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f006', 'af49fa44-7567-49f9-9dcc-b6564cd2e4a5', '4fca3add-4e61-4947-97bb-f2d7a72106c0', null, 'cc7d7381-2ef9-45a2-a7e6-a8703fea283d', '34b5a358-5135-4b19-a24d-9058f817c3cb', 'JRFJSSGLSFLSDW', '介入分级手术管理是否落实到位', 2, null, '11', null, null, 6, 2, 0, 6358, 6244)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ba2cb4c8-c15f-340d-d067-67c100785574', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f007', 'd2b3667f-9be5-4e25-922c-ff0d88d91e54', '4fca3add-4e61-4947-97bb-f2d7a72106c0', null, '7b0308ee-8455-4870-87f9-1c5719e32ad8', '566603b7-e25c-4b25-87d3-37edebec67e5', 'SFCZJTGLWT', '是否存在其他管理问题', 2, null, '11', null, null, 7, 2, 0, 6358, 6180)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('86ab71d6-b4b9-6c3b-6e77-8ca833bbed3f', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f008', '88962db0-5677-42b4-a02b-0b2c57d42e38', '4fca3add-4e61-4947-97bb-f2d7a72106c0', null, '6a9b05fb-3c6b-496f-907b-6849303155a5', '9bb74b44-fc8e-4ee3-ae0a-4af07d00e7f3', 'JTGLWTMS', '其他管理问题描述', 10, null, null, null, null, 8, 2, 0, 6358, 206)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('1d1bfd6d-42ec-7c7f-4d0f-daed10a2e6d8', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f009', '53c7d4d9-3fe6-4b47-b00f-2c856cce08f1', null, null, 'f8087005-5fe4-4ff9-84bd-83e6949a1cce', 'b3c40c04-d055-4a31-b561-a5bd0b8f2d03', 'BFZJZ', '并发症救治', 1, null, null, null, null, 9, 1, 0, 6358, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b5626257-542e-1001-abda-c3c048e819ec', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f010', '05c4ad95-bb04-46e7-8a3e-bc2ae734ee93', '53c7d4d9-3fe6-4b47-b00f-2c856cce08f1', null, 'd8a9779f-a9bb-4937-8ae3-7618faa59217', '67224c77-fa83-41da-bb53-89be3c71d0ff', 'JZSFJS', '救治是否及时', 2, null, '11', null, null, 10, 2, 0, 6358, 6111)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('9810e26f-922b-0dc7-e4be-c0e23911c58e', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f011', '8074b696-96dc-4582-ad4e-48c6962d3e24', '53c7d4d9-3fe6-4b47-b00f-2c856cce08f1', null, '4cdb599c-c682-49e9-bb57-0218d9ba6368', 'a9ecd0d4-2cb9-422a-b3d1-67dc5c8b07ea', 'JZCSSFDD', '救治措施是否得当', 2, null, '11', null, null, 11, 2, 0, 6358, 6071)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('d898a054-9a2b-6dc7-98f0-f34c89c8e49a', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f012', '4a0a4cc5-bc9d-4792-bbb7-a88f55b2543a', '53c7d4d9-3fe6-4b47-b00f-2c856cce08f1', null, '52f37c58-d167-4876-87a7-4e5c460bc2ba', 'dc4ff7e9-692b-4bb6-8aca-70ca41793448', 'JZYPSBSFJQ', '救治药品设备是否齐全', 2, null, '11', null, null, 12, 2, 0, 6358, 5974)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('574ad1c2-a023-622c-2d4d-822af868c0a7', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f013', '64c4ff46-72b9-4207-9e03-c884ae3d31b4', null, null, 'b32e497f-b3cd-412f-99db-7ee48928383e', 'd5e76cb6-e657-457d-be51-70934c931c56', 'SWXX', '死亡信息', 1, null, null, null, null, 13, 1, 0, 6358, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('b56cd7d3-6773-364e-97f7-b5dca7ac0c51', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f014', '4b7cfc2c-b3ee-4317-ace9-e2c5144fbc4a', '64c4ff46-72b9-4207-9e03-c884ae3d31b4', null, '369e732e-6efb-4c9e-bea1-547cbc3b323b', '3f28fa09-0b36-4492-91da-bf55ca9625af', 'SWYY22', '死亡原因', 2, null, '11111', null, null, 14, 2, 0, 6358, 5951)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('061413dd-bee2-4374-3372-bef7b98a00d9', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f015', '969a1dca-83e5-49cd-b0e6-20475e48b367', '64c4ff46-72b9-4207-9e03-c884ae3d31b4', null, 'fff460bd-f635-44dd-a7fc-4a6ee99ab141', '4bbb166c-23f4-4456-b071-53e6ba6c24f3', 'JTSWYY', '其他死亡原因', 10, null, null, null, null, 15, 3, 0, 6358, 86)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('ffb86fff-3f2b-99f2-81ac-1eac83dd2548', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f016', 'd3f9f533-b0dc-4e4e-99f5-75c0198bd09a', null, null, '3f0225f2-3407-40cc-9cd9-664ea73aacdc', 'f2cf942a-b8fa-4985-8ec0-9d4cb138eba5', 'XYBGJCS', '下一步改进措施', 1, null, null, null, null, 16, 1, 0, 6358, 0)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('bea0ffa2-6d59-f664-766a-b3caea882ef8', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f017', 'ea9b06c3-9f03-4905-956a-3e2192ca0327', 'd3f9f533-b0dc-4e4e-99f5-75c0198bd09a', null, '212a2093-f505-4126-8110-0fed0bcf8771', '64e9ea13-b9ca-430e-8521-3ab883c55d21', 'SFXYDJJYBGJCS', '是否需要提交进一步改进措施', 2, null, '11', null, null, 17, 2, 0, 6358, 5600)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)
values ('c9934fbd-76be-2078-c26b-2b2ec7500fd0', '456adc9b-97f5-0a47-9ac9-5d3126457b5e', 'f018', 'e8728967-5c32-4164-8afc-cf63ce147541', 'd3f9f533-b0dc-4e4e-99f5-75c0198bd09a', null, '113bbea1-b557-41b2-ae77-0f35f3302098', '0652bee1-cfab-4b1d-8922-cf6bfcf2c05c', 'GJCSNR', '改进措施内容', 10, null, null, null, null, 18, 2, 0, 6358, 1124)
on conflict (form_template_id, storage_key) do update set
    source_subject_id = excluded.source_subject_id,
    source_parent_subject_id = excluded.source_parent_subject_id,
    source_top_subject_id = excluded.source_top_subject_id,
    source_subject_list_id = excluded.source_subject_list_id,
    source_subject_config_id = excluded.source_subject_config_id,
    field_code = excluded.field_code,
    field_name = excluded.field_name,
    control_type = excluded.control_type,
    is_required = excluded.is_required,
    default_options = excluded.default_options,
    fixed_value = excluded.fixed_value,
    format = excluded.format,
    sort = excluded.sort,
    level = excluded.level,
    status = excluded.status,
    answer_count = excluded.answer_count,
    non_empty_answer_count = excluded.non_empty_answer_count;

commit;
