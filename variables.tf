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
  type        = list
  default     = []
}

variable "selection_tag" {
  description = "Tag-based conditions used to specify a set of resources to assign to a backup plan"
  type = list(object({
    type  = string
    key   = string
    value = string
  }))
  default = [
    {
      type  = "STRINGEQUALS"
      key   = "Backup"
      value = "true"      
    }
  ]
}