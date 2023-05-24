
module "backups" {
  source = "git::https://github.com/DNXLabs/terraform-aws-backup?ref=1.0.2"
  # source = "./modules/backup"
  enabled = local.workspace.backups.enabled
  selection_tag_key   = local.workspace.backups.selection_tag_key
  selection_tag_value = local.workspace.backups.selection_tag_value
  for_each = { for rules in local.workspace.backups.rules : rules.rule_name => rules }
  rule = {
    rule_name         = local.workspace.backups.rule_name
    target_vault_name = local.workspace.backups.target_vault_name
    schedule          = local.workspace.backups.schedule
    start_window      = local.workspace.backups.start_window
    completion_window = local.workspace.backups.completion_window
    enable_continuous_backup = local.workspace.backups.enable_continuous_backup
    lifecycle_cold_storage_after = local.workspace.backups.lifecycle_cold_storage_after
    lifecycle_delete_after = local.workspace.backups.lifecycle_delete_after
    lifecycle = {
      cold_storage_after = local.workspace.backups.lifecycle_cold_storage_after
      delete_after       = local.workspace.backups.lifecycle_delete_after
    }
  }
}
