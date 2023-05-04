# terraform-aws-backup

[![Lint Status](https://github.com/DNXLabs/terraform-aws-backup/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-backup/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-backup)](https://github.com/DNXLabs/terraform-aws-backup/blob/master/LICENSE)

This terraform module automate the backup of data across AWS services using a resource tag.

The following resources will be created:
 - An Identity and Access Management (IAM) that Provides AWS Backup permissions to create backups of all supported resource types on your behalf.
 - AWS Backup - It is a fully managed backup service that makes it easy to centralize and automate the backup of data across AWS services
 - AWS Vault - Backup vaults are containers where your backups are stored. You can have one default vault, or multiple vaults to backup to.
 - AWS Backup plan - Backup rules specify the backup schedule, backup window, and lifecycle rules.
     - The amount of time AWS Backup attempts a backup before canceling the job and returning an error
        - The default value is 120
     - The number of days after creation that a recovery point is moved to cold storage
        - The default value is 30
     - The number of days after creation that a recovery point is deleted. Must be 90 days greater than cold storage
        - The default value is 120
     - The amount of time in minutes before beginning a backup
        - The default value is 60
     - A cron specifying when AWS Backup initiates a backup job

<!--- BEGIN_TF_DOCS --->

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_type | Type of the account to create backup resources. | `string` | `"workload"` | no |
| backup\_vault\_events | An array of events that indicate the status of jobs to back up resources to the backup vault | `list(string)` | <pre>[<br>  "BACKUP_JOB_FAILED",<br>  "COPY_JOB_FAILED"<br>]</pre> | no |
| changeable\_for\_days | The number of days before the lock date. Until that time, the configuration can be edited or removed. The minimum number of day is 3 days | `number` | `null` | no |
| enable\_aws\_backup\_vault\_notifications | Enable vault notifications | `bool` | `false` | no |
| enabled | Change to false to avoid deploying any AWS Backup resources | `bool` | `true` | no |
| max\_retention\_days | The maximum retention period that the vault retains its recovery points | `number` | `null` | no |
| min\_retention\_days | The minimum retention period that the vault retains its recovery points | `number` | `null` | no |
| name | Name of the backup vault to create. | `string` | `""` | no |
| rule | List of backup rules | <pre>list(object({<br>    rule_name                    = string<br>    target_vault_name            = string<br>    schedule                     = string<br>    start_window                 = number<br>    completion_window            = number<br>    enable_continuous_backup    = bool<br>    lifecycle_cold_storage_after = number<br>    lifecycle_delete_after       = number<br>    lifecycle                    = object({<br>      cold_storage_after = number<br>      delete_after       = number<br>    })<br>  }))</pre> | <pre>[<br>  {<br>    "completion_window": 120,<br>    "enable_continuous_backup": true,<br>    "lifecycle": {<br>      "cold_storage_after": 30,<br>      "delete_after": 130<br>    },<br>    "lifecycle_cold_storage_after": 30,<br>    "lifecycle_delete_after": 130,<br>    "rule_name": "backup-rule",<br>    "schedule": "cron(15 * ? * * *)",<br>    "start_window": 60,<br>    "target_vault_name": "backup-vault"<br>  }<br>]</pre> | no |
| selection\_resources | An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan | `list(any)` | `[]` | no |
| selection\_tag\_key | The key in a key-value pair | `string` | `"Backup"` | no |
| selection\_tag\_type | An operation, such as StringEquals, that is applied to a key-value pair used to filter resources in a selection | `string` | `"STRINGEQUALS"` | no |
| selection\_tag\_value | The value in a key-value pair | `string` | `"true"` | no |
| vault\_kms\_key\_arn | The server-side encryption key that is used to protect your backups | `string` | `null` | no |
| vault\_notification\_sns\_topic\_arn | The Amazon Resource Name (ARN) that specifies the topic for a backup vaults events | `string` | `""` | no |
| vault\_policy | The backup vault access policy document in JSON format | `string` | `""` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-backup/blob/master/LICENSE) for full details.
