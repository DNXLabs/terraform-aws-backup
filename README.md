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

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup\_vault\_events | An array of events that indicate the status of jobs to back up resources to the backup vault | `list(any)` | <pre>[<br>  "BACKUP_JOB_FAILED",<br>  "COPY_JOB_FAILED"<br>]</pre> | no |
| name | Name of the backup vault to create. | `string` | `""` | no |
| rule\_completion\_window | The amount of time AWS Backup attempts a backup before canceling the job and returning an error | `number` | `120` | no |
| rule\_copy\_action\_destination\_vault | Configuration block(s) with copy operation settings | `map(any)` | `{}` | no |
| rule\_lifecycle\_cold\_storage\_after | Specifies the number of days after creation that a recovery point is moved to cold storage | `number` | `30` | no |
| rule\_lifecycle\_delete\_after | Specifies the number of days after creation that a recovery point is deleted. Must be 90 days greater than `cold_storage_after` | `number` | `120` | no |
| rule\_schedule | A CRON expression specifying when AWS Backup initiates a backup job | `string` | `null` | no |
| rule\_start\_window | The amount of time in minutes before beginning a backup | `number` | `60` | no |
| selection\_resources | An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan | `list(any)` | `[]` | no |
| selection\_tag\_key | The key in a key-value pair | `string` | `"Backup"` | no |
| selection\_tag\_type | An operation, such as StringEquals, that is applied to a key-value pair used to filter resources in a selection | `string` | `"STRINGEQUALS"` | no |
| selection\_tag\_value | The value in a key-value pair | `string` | `"true"` | no |
| vault\_kms\_key\_arn | The server-side encryption key that is used to protect your backups | `string` | `null` | no |
| vault\_notification\_sns\_topic\_arn | he Amazon Resource Name (ARN) that specifies the topic for a backup vaults events | `string` | `""` | no |
| vault\_policy | The backup vault access policy document in JSON format | `string` | `""` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-backup/blob/master/LICENSE) for full details.
