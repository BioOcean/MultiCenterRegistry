param(
    [string]$CatalogPath = "./Script/output/form_inventory/form_field_catalog.json",
    [string]$OutputPath = "./Script/05_seed_form_catalog.sql"
)

$ErrorActionPreference = "Stop"

function Read-JsonArray {
    param([string]$Path)

    $data = Get-Content -Path $Path -Raw | ConvertFrom-Json
    if ($data -is [array]) {
        return $data
    }

    return @($data)
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

function ConvertTo-SqlText {
    param([object]$Value)

    if ($null -eq $Value) {
        return "null"
    }

    $text = [string]$Value
    if ([string]::IsNullOrWhiteSpace($text)) {
        return "null"
    }

    return "'" + $text.Replace("'", "''") + "'"
}

function ConvertTo-SqlBool {
    param([object]$Value)

    if ($null -eq $Value) {
        return "null"
    }

    if ($Value -is [bool]) {
        return ($(if ($Value) { "true" } else { "false" }))
    }

    $text = [string]$Value
    if ([string]::IsNullOrWhiteSpace($text)) {
        return "null"
    }

    return ($(if ([bool]::Parse($text)) { "true" } else { "false" }))
}

function ConvertTo-SqlInt {
    param([object]$Value)

    if ($null -eq $Value -or [string]::IsNullOrWhiteSpace([string]$Value)) {
        return "0"
    }

    return [string][int64]$Value
}

function ConvertTo-BusinessTypeCode {
    param([object]$Value)

    $text = [string]$Value
    switch ($text) {
        "病例" { return "case" }
        "质控" { return "quality" }
        "专家评审" { return "appraise" }
        "0" { return "case" }
        "2" { return "quality" }
        "3" { return "appraise" }
        default { return $text }
    }
}

$catalog = Read-JsonArray $CatalogPath
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("begin;")

foreach ($form in $catalog) {
    $templateId = ConvertTo-StableGuid "form-template:$($form.custom_form_id)"
    $businessType = ConvertTo-BusinessTypeCode $form.business_types[0]

    $lines.Add("")
    $lines.Add("insert into mcr.form_template (id, source_custom_form_id, form_name, business_type, field_count, answer_count, card_count)")
    $lines.Add("values ('$templateId', $(ConvertTo-SqlText $form.custom_form_id), $(ConvertTo-SqlText $form.form_name), $(ConvertTo-SqlText $businessType), $(ConvertTo-SqlInt $form.field_count), $(ConvertTo-SqlInt $form.answer_count), $(ConvertTo-SqlInt $form.card_count))")
    $lines.Add("on conflict (source_custom_form_id) do update set")
    $lines.Add("    form_name = excluded.form_name,")
    $lines.Add("    business_type = excluded.business_type,")
    $lines.Add("    field_count = excluded.field_count,")
    $lines.Add("    answer_count = excluded.answer_count,")
    $lines.Add("    card_count = excluded.card_count,")
    $lines.Add("    updated_at = now();")

    foreach ($map in @($form.templates)) {
        $mapBusinessType = ConvertTo-BusinessTypeCode $map.type_name
        $mapId = ConvertTo-StableGuid "form-template-map:$($mapBusinessType):$($map.follow_template_id):$($form.custom_form_id)"
        $lines.Add("")
        $lines.Add("insert into mcr.form_template_map (id, form_template_id, business_type, source_follow_template_id, source_custom_form_id, template_name)")
        $lines.Add("values ('$mapId', '$templateId', $(ConvertTo-SqlText $mapBusinessType), $(ConvertTo-SqlText $map.follow_template_id), $(ConvertTo-SqlText $form.custom_form_id), $(ConvertTo-SqlText $map.template_name))")
        $lines.Add("on conflict (business_type, source_follow_template_id, source_custom_form_id) do update set")
        $lines.Add("    form_template_id = excluded.form_template_id,")
        $lines.Add("    template_name = excluded.template_name;")
    }

    foreach ($field in @($form.fields)) {
        $fieldId = ConvertTo-StableGuid "form-field:$($form.custom_form_id):$($field.storage_key)"
        $lines.Add("")
        $lines.Add("insert into mcr.form_field_definition (id, form_template_id, storage_key, source_subject_id, source_parent_subject_id, source_top_subject_id, source_subject_list_id, source_subject_config_id, field_code, field_name, control_type, is_required, default_options, fixed_value, format, sort, level, status, answer_count, non_empty_answer_count)")
        $lines.Add("values ('$fieldId', '$templateId', $(ConvertTo-SqlText $field.storage_key), $(ConvertTo-SqlText $field.subject_id), $(ConvertTo-SqlText $field.parent_subject_id), $(ConvertTo-SqlText $field.top_subject_id), $(ConvertTo-SqlText $field.source_subject_list_id), $(ConvertTo-SqlText $field.source_subject_config_id), $(ConvertTo-SqlText $field.field_code), $(ConvertTo-SqlText $field.field_name), $(ConvertTo-SqlInt $field.control_type), $(ConvertTo-SqlBool $field.is_required), $(ConvertTo-SqlText $field.default_options), $(ConvertTo-SqlText $field.fixed_value), $(ConvertTo-SqlText $field.format), $(ConvertTo-SqlInt $field.sort), $(ConvertTo-SqlInt $field.level), $(ConvertTo-SqlInt $field.status), $(ConvertTo-SqlInt $field.answer_count), $(ConvertTo-SqlInt $field.non_empty_answer_count))")
        $lines.Add("on conflict (form_template_id, storage_key) do update set")
        $lines.Add("    source_subject_id = excluded.source_subject_id,")
        $lines.Add("    source_parent_subject_id = excluded.source_parent_subject_id,")
        $lines.Add("    source_top_subject_id = excluded.source_top_subject_id,")
        $lines.Add("    source_subject_list_id = excluded.source_subject_list_id,")
        $lines.Add("    source_subject_config_id = excluded.source_subject_config_id,")
        $lines.Add("    field_code = excluded.field_code,")
        $lines.Add("    field_name = excluded.field_name,")
        $lines.Add("    control_type = excluded.control_type,")
        $lines.Add("    is_required = excluded.is_required,")
        $lines.Add("    default_options = excluded.default_options,")
        $lines.Add("    fixed_value = excluded.fixed_value,")
        $lines.Add("    format = excluded.format,")
        $lines.Add("    sort = excluded.sort,")
        $lines.Add("    level = excluded.level,")
        $lines.Add("    status = excluded.status,")
        $lines.Add("    answer_count = excluded.answer_count,")
        $lines.Add("    non_empty_answer_count = excluded.non_empty_answer_count;")
    }
}

$lines.Add("")
$lines.Add("commit;")

$directory = Split-Path -Parent $OutputPath
if (-not [string]::IsNullOrWhiteSpace($directory)) {
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
}

[System.IO.File]::WriteAllLines($OutputPath, $lines, [System.Text.UTF8Encoding]::new($true))
Write-Host "字段目录种子脚本已生成：$OutputPath"
