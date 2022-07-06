# AWS Backup vault
resource "aws_backup_vault" "backup_vault" {
  name        = "vault-${var.name}-backup"
  kms_key_arn = var.vault_kms_key_arn
  tags = {
    Job = "${var.name}-backup"
  }
}

resource "aws_backup_vault_policy" "backup_vault" {
  count             = var.vault_policy != "" ? 1 : 0
  backup_vault_name = aws_backup_vault.backup_vault.name
  policy            = var.vault_policy
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

    dynamic "copy_action" {
      for_each = var.rule_copy_action_destination_vault
      content {
        destination_vault_arn = copy_action.value.destination_vault_arn
        lifecycle {
          cold_storage_after = copy_action.value.cold_storage_after
          delete_after       = copy_action.value.delete_after
        }
      }
    }
  }
}


# AWS Backup selection - tag
resource "aws_backup_selection" "backup_selection" {
  name         = "selection-${var.name}-backup"
  iam_role_arn = aws_iam_role.backup_role.arn

  plan_id = aws_backup_plan.backup_plan.id

  selection_tag {
    type  = var.selection_tag_type
    key   = var.selection_tag_key
    value = var.selection_tag_value
  }

  condition {}
}


