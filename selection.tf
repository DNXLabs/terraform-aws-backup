resource "aws_backup_selection" "backup_selection" {
  # count = var.enabled ? length(local.selections) : 0

  iam_role_arn = aws_iam_role.backup_role.arn
  name         = var.selection_name
  plan_id      = aws_backup_plan.backup_plan.id

  selection_tag {
    type  = var.selection_tag_type
    key   = var.selection_tag_key
    value = var.selection_tag_value
  }

  depends_on = [aws_iam_role_policy_attachment.backup_policy_attach]
}

# resource "aws_iam_policy" "ab_tag_policy" {
#   # count       = var.enabled ? 1 : 0
#   description = "AWS Backup Tag policy"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#         "Effect": "Allow",
#         "Action": [
#             "backup:TagResource",
#             "backup:ListTags",
#             "backup:UntagResource",
#             "backup:CreateBackupPlan",
#             "backup:CreateBackupSelection",
#             "backup:CreateBackupVault",
#             "backup:DeleteBackupPlan",
#             "backup:DeleteBackupSelection",
#             "backup:DeleteBackupVault",
#             "backup:DescribeBackupVault",
#             "backup:GetBackupPlan",
#             "backup:UpdateBackupPlan",
#             "iam:PassRole",
#             "kms:CreateGrant",
#             "kms:GenerateDataKey",
#             "kms:Decrypt",
#             "kms:RetireGrant",
#             "kms:DescribeKey",
#             "tag:GetResources"
#             ],
#         "Resource": "*"
#     }
#   ]
# }
# EOF
# }


# resource "aws_iam_role_policy_attachment" "ab_tag_policy_attach" {
#   # count      = var.enabled ? 1 : 0
#   policy_arn = aws_iam_policy.ab_tag_policy.arn
#   role       = aws_iam_role.backup_role.name
# }