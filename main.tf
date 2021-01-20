# AWS Backup vault
resource "aws_backup_vault" "backup_vault" {
  name        = "vault-${var.name}-backup"
  kms_key_arn = var.vault_kms_key_arn
  tags = {
    Job = "${var.name}-backup"
  }
}

# AWS Backup plan
resource "aws_backup_plan" "backup_plan" {
  name = "plan-${var.name}-backup"
  tags = {
    Job = "${var.name}-backup"
  }

  rule {
    rule_name         = "rule-${var.name}-backup"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = var.rule_schedule
    start_window      = var.rule_start_window
    completion_window = var.rule_completion_window
    lifecycle {
      cold_storage_after = var.rule_lifecycle_cold_storage_after
      delete_after       = var.rule_lifecycle_delete_after
    }
    recovery_point_tags = {
      Job = "${var.name}-backup"
    }
  }
}

# AWS Backup selection - tag
resource "aws_backup_selection" "backup_selection" {
  name         = "selection-${var.name}-backup"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.backup_plan.id

  dynamic "selection_tag" {
    for_each = var.selection_tag
    
    content {
      type  = selection_tag.value.type
      key   = selection_tag.value.key
      value = selection_tag.value.value
    }
  }

  depends_on = [aws_iam_role_policy_attachment.backup_policy_attach]
}