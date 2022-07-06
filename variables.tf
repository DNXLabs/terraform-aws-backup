#
# AWS Backup vault
#
variable "name" {
  description = "Name of the backup vault to create."
  type        = string
  default     = ""
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

variable "vault_notification_sns_topic_arn" {
  description = "he Amazon Resource Name (ARN) that specifies the topic for a backup vaults events"
  type        = string
  default     = ""
}

variable "backup_vault_events" {
  description = "An array of events that indicate the status of jobs to back up resources to the backup vault"
  type        = list(any)
  default     = ["BACKUP_JOB_FAILED", "COPY_JOB_FAILED"]
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

variable "rule_copy_action_destination_vault" {
  description = "Configuration block(s) with copy operation settings"
  type        = map(any)
  default     = {}
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