#
# AWS Backup vault
#
variable "name" {
  description = "Name of the backup vault to create."
  type        = string
}

variable "account_type" {
  description = "Type of the account to create backup resources."
  type        = string
  default     = "workload"

  validation {
    condition = contains([
      "workload",
      "backup"
    ], var.account_type)

    error_message = "Invalid account_type. Current valid types are: workload and backup."
  }
}

variable "vault_kms_key_arn" {
  description = "The server-side encryption key that is used to protect your backups"
  type        = string
  default     = null
}

variable "vault_policy" {
  description = "The backup vault access policy document in JSON format"
  type        = string
  default     = ""
}

variable "enable_aws_backup_vault_notifications" {
  description = "Enable vault notifications"
  type        = bool
  default     = false
}

variable "vault_notification_sns_topic_arn" {
  description = "The Amazon Resource Name (ARN) that specifies the topic for a backup vaults events"
  type        = string
  default     = ""
}

variable "backup_vault_events" {
  description = "An array of events that indicate the status of jobs to back up resources to the backup vault"
  type        = list(string)
  default     = ["BACKUP_JOB_FAILED", "COPY_JOB_FAILED"]

  validation {
    condition = alltrue([
      for event in var.backup_vault_events : contains([
        "BACKUP_JOB_STARTED",
        "BACKUP_JOB_COMPLETED",
        "BACKUP_JOB_SUCCESSFUL",
        "BACKUP_JOB_FAILED",
        "BACKUP_JOB_EXPIRED",
        "RESTORE_JOB_STARTED",
        "RESTORE_JOB_COMPLETED",
        "RESTORE_JOB_SUCCESSFUL",
        "RESTORE_JOB_FAILED",
        "COPY_JOB_STARTED",
        "COPY_JOB_SUCCESSFUL",
        "COPY_JOB_FAILED",
        "RECOVERY_POINT_MODIFIED",
        "BACKUP_PLAN_CREATED",
        "BACKUP_PLAN_MODIFIED",
        "S3_BACKUP_OBJECT_FAILED",
        "S3_RESTORE_OBJECT_FAILED"
      ], event)
    ])
    error_message = "Invalid backup_vault_events."
  }
}

# Default rule
variable "rule_schedule" {
  description = "A CRON expression specifying when AWS Backup initiates a backup job"
  type        = string
  default     = null
}

variable "rule_start_window" {
  description = "The amount of time in minutes before beginning a backup"
  type        = number
  default     = 60
}

variable "rule_completion_window" {
  description = "The amount of time AWS Backup attempts a backup before canceling the job and returning an error"
  type        = number
  default     = 120
}

# Rule lifecycle
variable "rule_lifecycle_cold_storage_after" {
  description = "Specifies the number of days after creation that a recovery point is moved to cold storage"
  type        = number
  default     = 30
}

variable "rule_lifecycle_delete_after" {
  description = "Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after`"
  type        = number
  default     = 120
}

# Selection
variable "selection_resources" {
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan"
  type        = list(any)
  default     = []
}

variable "selection_tag_type" {
  description = "An operation, such as StringEquals, that is applied to a key-value pair used to filter resources in a selection"
  type        = string
  default     = "STRINGEQUALS"
}

variable "selection_tag_key" {
  description = "The key in a key-value pair"
  type        = string
  default     = "Backup"
}

variable "selection_tag_value" {
  description = "The value in a key-value pair"
  type        = string
  default     = "true"
}

variable "min_retention_days" {
  description = "The minimum retention period that the vault retains its recovery points"
  type        = number
  default     = null
}

variable "max_retention_days" {
  description = "The maximum retention period that the vault retains its recovery points"
  type        = number
  default     = null
}

variable "changeable_for_days" {
  description = "The number of days before the lock date. Until that time, the configuration can be edited or removed. The minimum number of day is 3 days"
  type        = number
  default     = null
}

variable "rules" {
  description = "List of backup rules"
type = list(object({
    rule_name                    = string
    schedule                     = string
    start_window                 = number
    completion_window            = number
    enable_continuous_backup    = bool
    lifecycle_cold_storage_after = number
    lifecycle_delete_after       = number
    lifecycle                    = object({
      cold_storage_after = number
      delete_after       = number
    })
  }))
  default = [{
    rule_name         = "backup-rule"
    schedule          = null
    start_window      = 60
    completion_window = 120
    enable_continuous_backup = true
    lifecycle_cold_storage_after = null
    lifecycle_delete_after = 30
    lifecycle = {
      cold_storage_after = null
      delete_after       = 30
    }
  }]
}

variable "enabled" {
  description = "Change to false to avoid deploying any AWS Backup resources"
  type        = bool
  default     = true
}