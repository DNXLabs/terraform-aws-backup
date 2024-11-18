output "vault_arn" {
  value = aws_backup_vault.backup_vault.arn
}

output "plan_id" {
  value = aws_backup_plan.backup_plan[0].id
}
