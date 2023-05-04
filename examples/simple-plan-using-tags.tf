
module "backups" {
  source = "git::https://github.com/DNXLabs/terraform-aws-backup?ref=1.0.2"

  name          = "production-by-tags"
  rule_schedule = "cron(0 12 * * ? *)" # 12:00pm UTC -> 10:00pm AEST (http://crontab.org/)

  # Selection of resources by tag
  # Supported resources Aurora, DynamoDB, EBS, EC2, FSx, EFS, RDS, Storage Gateway 
  selection_tag_key   = "Environment"
  selection_tag_value = "production"

  enabled = true
  vault_kms_key_arn = ""
  # selection_resources = ["arn:aws:s3:::s3-test"]
  rule = [{
    rule_name         = "backup-rule"
    target_vault_name = "backup-vault"
    schedule          = "cron(15 * ? * * *)"
    start_window      = 60
    completion_window = 120
    enable_continuous_backup = true
    lifecycle_cold_storage_after = 30
    lifecycle_delete_after = 35
    lifecycle = {
      cold_storage_after = 30
      delete_after       = 35
    }
    },
    {
    rule_name         = "backup-test"
    target_vault_name = "backup-vault-test"
    schedule          = "cron(15 * ? * * *)"
    start_window      = 60
    completion_window = 120
    enable_continuous_backup = false
    lifecycle_cold_storage_after = 30
    lifecycle_delete_after = 120
    lifecycle = {
      cold_storage_after = 30
      delete_after       = 120
    }
    }]
}
