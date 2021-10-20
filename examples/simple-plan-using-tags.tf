
module "backups" {
  source = "git::https://github.com/DNXLabs/terraform-aws-backup?ref=1.0.2"

  name          = "production-by-tags"
  rule_schedule = "cron(0 12 * * ? *)" # 12:00pm UTC -> 10:00pm AEST (http://crontab.org/)

  # Selection of resources by tag
  # Supported resources Aurora, DynamoDB, EBS, EC2, FSx, EFS, RDS, Storage Gateway 
  selection_tag_key   = "Environment"
  selection_tag_value = "production"

  rule_lifecycle_cold_storage_after = 30
  rule_lifecycle_delete_after       = 60
}
