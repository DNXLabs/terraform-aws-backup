# AWS Backup vault
resource "aws_backup_vault" "backup_vault" {
  # count       = var.enabled && var.vault_name != null ? 1 : 0
  name = "vault-${var.name}"
  # kms_key_arn = var.vault_kms_key_arn
  # tags        = var.tags
}

# AWS Backup plan
resource "aws_backup_plan" "backup_plan" {
  # count = var.enabled ? 1 : 0
  name = "plan-${var.name}"

  rule {
    rule_name         = "rule-${var.name}"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = var.rule_schedule
    start_window      = var.rule_start_window
    completion_window = var.rule_completion_window
    lifecycle {
      cold_storage_after = var.rule_lifecycle_cold_storage_after
      delete_after       = var.rule_lifecycle_delete_after
    }
  }
}

resource "aws_backup_selection" "backup_selection" {
  # count = var.enabled ? length(local.selections) : 0

  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "selection-${var.name}"
  plan_id      = aws_backup_plan.backup_plan.id

  selection_tag {
    type  = var.selection_tag_type
    key   = var.selection_tag_key
    value = var.selection_tag_value
  }

  depends_on = [aws_iam_role_policy_attachment.backup_policy_attach]
}