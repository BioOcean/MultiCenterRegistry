param(
    [string]$InventoryDirectory = ".\Script\output\form_inventory"
)

$ErrorActionPreference = "Stop"

function Read-JsonArray {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return @()
    }

    $data = Get-Content -Path $Path -Raw | ConvertFrom-Json
    if ($null -eq $data) {
        return @()
    }

    if ($data -is [array]) {
        return $data
    }

    return @($data)
}

function First-NotEmpty {
    param([object[]]$Values)

    foreach ($value in $Values) {
        if ($null -ne $value -and -not [string]::IsNullOrWhiteSpace([string]$value)) {
            return [string]$value
        }
    }

    return ""
}

$forms = Read-JsonArray (Join-Path $InventoryDirectory "custom_forms.json")
$subjects = Read-JsonArray (Join-Path $InventoryDirectory "custom_form_subjects.json")
$configs = Read-JsonArray (Join-Path $InventoryDirectory "subject_config.json")
$subjectLists = Read-JsonArray (Join-Path $InventoryDirectory "subject_list.json")
$maps = Read-JsonArray (Join-Path $InventoryDirectory "follow_template_form_map.json")
$templates = Read-JsonArray (Join-Path $InventoryDirectory "follow_template.json")
$answerSummary = Read-JsonArray (Join-Path $InventoryDirectory "answer_summary.json")
$ownerSummary = Read-JsonArray (Join-Path $InventoryDirectory "answer_owner_summary.json")

$typeNames = @{
    "0" = "病例"
    "2" = "质控"
    "3" = "专家评审"
}

$mappedFormIds = @($maps | Select-Object -ExpandProperty CustomFormID -Unique)
$catalog = foreach ($formId in $mappedFormIds) {
    $form = $forms | Where-Object { $_.ID -eq $formId } | Select-Object -First 1
    $formMaps = @($maps | Where-Object { $_.CustomFormID -eq $formId })
    $owner = $ownerSummary | Where-Object { $_.CustomFormID -eq $formId } | Select-Object -First 1

    $fieldIndex = 0
    $fields = foreach ($subject in @($subjects | Where-Object { $_.CustomFormID -eq $formId } | Sort-Object Sort, ID)) {
        $fieldIndex++
        $config = $configs | Where-Object { $_.ID -eq $subject.SubjectConfigID } | Select-Object -First 1
        $subjectList = $subjectLists | Where-Object { $_.ID -eq $subject.SubjectListID } | Select-Object -First 1
        $answer = $answerSummary | Where-Object { $_.CustomFormID -eq $formId -and $_.SubjectID -eq $subject.ID } | Select-Object -First 1

        $fieldCode = First-NotEmpty @(
            $config.TableColumnDef,
            $subjectList.Code,
            $config.cubeColumn,
            $subject.SubjectMark,
            $subject.ID
        )

        $fieldName = First-NotEmpty @(
            $subject.Rename,
            $config.ReName,
            $subjectList.Name,
            $fieldCode
        )

        [pscustomobject]@{
            subject_id = $subject.ID
            storage_key = ("f{0:D3}" -f $fieldIndex)
            parent_subject_id = $subject.ParentID
            top_subject_id = $subject.TopID
            field_code = $fieldCode
            field_name = $fieldName
            source_subject_list_id = $subject.SubjectListID
            source_subject_config_id = $subject.SubjectConfigID
            control_type = $config.Type
            is_required = $config.IsRequired
            default_options = $config.DefaultOptions
            fixed_value = $config.FixedValue
            format = $config.Format
            sort = $subject.Sort
            level = $subject.Level
            status = $subject.Status
            answer_count = if ($answer) { $answer.AnswerCount } else { 0 }
            non_empty_answer_count = if ($answer) { $answer.NonEmptyAnswerCount } else { 0 }
        }
    }

    [pscustomobject]@{
        custom_form_id = $formId
        form_name = $form.Name
        business_types = @($formMaps | ForEach-Object { $typeNames[[string]$_.Type] } | Select-Object -Unique)
        templates = @($formMaps | ForEach-Object {
            $map = $_
            $template = $templates | Where-Object { $_.ID -eq $map.FollowTemplateID } | Select-Object -First 1
            [pscustomobject]@{
                type = $map.Type
                type_name = $typeNames[[string]$map.Type]
                follow_template_id = $map.FollowTemplateID
                template_name = $template.Name
            }
        })
        answer_count = if ($owner) { $owner.AnswerCount } else { 0 }
        case_answer_count = if ($owner) { $owner.CaseAnswerCount } else { 0 }
        quality_answer_count = if ($owner) { $owner.QualityAnswerCount } else { 0 }
        appraise_answer_count = if ($owner) { $owner.AppraiseAnswerCount } else { 0 }
        card_count = if ($owner) { $owner.CardCount } else { 0 }
        field_count = @($fields).Count
        fields = @($fields)
    }
}

$summary = $catalog | ForEach-Object {
    [pscustomobject]@{
        custom_form_id = $_.custom_form_id
        form_name = $_.form_name
        business_types = ($_.business_types -join "、")
        templates = (($_.templates | ForEach-Object { $_.template_name }) -join "、")
        field_count = $_.field_count
        answer_count = $_.answer_count
        card_count = $_.card_count
    }
}

$catalog | ConvertTo-Json -Depth 20 | Set-Content -Path (Join-Path $InventoryDirectory "form_field_catalog.json") -Encoding utf8BOM
$summary | ConvertTo-Json -Depth 8 | Set-Content -Path (Join-Path $InventoryDirectory "form_field_catalog_summary.json") -Encoding utf8BOM

Write-Host "字段目录已生成：$InventoryDirectory"
