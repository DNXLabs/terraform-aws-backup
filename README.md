# terraform-aws-backup

[![Lint Status](https://github.com/DNXLabs/terraform-aws-backup/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-backup/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-backup)](https://github.com/DNXLabs/terraform-aws-backup/blob/master/LICENSE)

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.20 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vault\_name | Name of the backup vault to create. If not given, AWS use default | `string` | `null` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-backup/blob/master/LICENSE) for full details.
