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

resource "aws_backup_vault_lock_configuration" "backup_vault_lock" {
  count               = try(var.min_retention_days != null ? 1 : 0, 0)
  backup_vault_name   = aws_backup_vault.backup_vault.name
  min_retention_days  = var.min_retention_days
  max_retention_days  = var.max_retention_days
  changeable_for_days = var.changeable_for_days
}

# AWS Backup plan
resource "aws_backup_plan" "backup_plan" {
  count = var.account_type == local.account_type.workload ? 1 : 0

  name = "plan-${var.name}-backup"
  tags = {
    Job = "${var.name}-backup"
  }

  dynamic "rule" {
    for_each = var.rule
    content {
      rule_name                = "rule-${var.name}-backup"
      target_vault_name        = aws_backup_vault.backup_vault.name
      schedule                 = try(rule.value.schedule, null)
      start_window             = try(rule.value.start_window, null)
      enable_continuous_backup = try(rule.value.enable_continuous_backup, null)
      completion_window        = try(rule.value.completion_window, null)
      lifecycle {
        cold_storage_after = try(rule.value.lifecycle.cold_storage_after, null)
        delete_after       = try(rule.value.lifecycle.delete_after, null)
      }

      copy_action {
        destination_vault_arn = aws_backup_vault.backup_vault.arn
        lifecycle {
          cold_storage_after = try(rule.value.lifecycle.cold_storage_after, null)
          delete_after       = try(rule.value.lifecycle.delete_after, null)
        }
      }

      recovery_point_tags = {
        Job = "rule-${var.name}-backup"
      }
    }
  }
}
# AWS Backup selection - tag
resource "aws_backup_selection" "tag" {
  count = length(var.selection_resources) == 0 && var.account_type == local.account_type.workload ? 1 : 0

  name         = "selection-${var.name}-backup-tag"
  iam_role_arn = aws_iam_role.backup_role[0].arn

  plan_id = aws_backup_plan.backup_plan[0].id

  selection_tag {
    type  = var.selection_tag_type
    key   = var.selection_tag_key
    value = var.selection_tag_value
  }

  condition {}
}


# AWS Backup selection - resources arn
resource "aws_backup_selection" "resources" {
  count        = length(var.selection_resources) > 0 && var.account_type == local.account_type.workload ? length(var.selection_resources) : 0
  name         = "selection-${element(split(":", var.selection_resources[count.index]), length(var.selection_resources[count.index]) - 1)}-backup-${count.index}"
  iam_role_arn = aws_iam_role.backup_role[0].arn
  plan_id      = aws_backup_plan.backup_plan[0].id
  resources    = var.selection_resources[count.index]
}

# AWS Backup vault notification
resource "aws_backup_vault_notifications" "default" {
  count               = try(var.enable_aws_backup_vault_notifications, false) ? 1 : 0
  backup_vault_name   = aws_backup_vault.backup_vault.name
  sns_topic_arn       = var.vault_notification_sns_topic_arn
  backup_vault_events = var.backup_vault_events
}