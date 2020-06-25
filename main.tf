# AWS Backup vault
resource "aws_backup_vault" "backup_vault" {
  # count       = var.enabled && var.vault_name != null ? 1 : 0
  name = var.vault_name
  # kms_key_arn = var.vault_kms_key_arn
  # tags        = var.tags
}

# AWS Backup plan
resource "aws_backup_plan" "backup_plan" {
  # count = var.enabled ? 1 : 0
  name = var.plan_name

  rule {
    rule_name         = var.rule_name
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
