/* Cross Account IAM Roles */

/* Cross Account*/
output "cross_account_developer_iam_role_arns" {
  value       = [for group in module.iam_group_with_assumable_roles_policy_developer_cross_account : group.this_assumable_roles]
  sensitive   = true
  description = "Groups that grant permissions to assume Developer IAM Role in other AWS Accounts"
  depends_on  = []
}

output "cross_account_administrator_iam_role_arns" {
  value       = [for group in module.iam_group_with_assumable_roles_policy_admin_cross_account : group.this_assumable_roles]
  sensitive   = true
  description = "description"
  depends_on  = []
}

output "cross_account_administrator_group_arn" {
  value       = [for group in module.iam_group_with_assumable_roles_policy_developer_cross_account : group.group_arn]
  sensitive   = true
  description = "Groups that grant permissions to assume Administrator IAM Role in other AWS Accounts"
  depends_on  = []
}

output "cross_account_developer_iam_group_arns" {
  value       = [
    for group in module.iam_group_with_assumable_roles_policy_admin_cross_account : group.group_arn
  ]
  sensitive   = true
  description = "description"
  depends_on  = []
}


/* Users */

output "iam_user_arns" {
  value     = [for user in aws_iam_user.users : user.arn]
  sensitive = false
}

output "iam_user_names" {
  value     = [for user in aws_iam_user.users : user.name]
  sensitive = false
}

output "iam_access_keys" {
  value     = [for x in aws_iam_access_key.users : x.id]
  sensitive = true
}

output "iam_secret_access_keys" {
  value     = [for x in aws_iam_access_key.users : x.encrypted_secret]
  sensitive = true
}


/* IAM Roles */

output "admin_iam_role_arn" {
  description = "ARN of admin IAM role"
  value       = module.iam_assumable_roles.admin_iam_role_arn
}

output "admin_iam_role_name" {
  description = "Name of admin IAM role"
  value       = module.iam_assumable_roles.admin_iam_role_name
}

output "admin_iam_role_requires_mfa" {
  description = "Whether admin IAM role requires MFA"
  value       = module.iam_assumable_roles.admin_iam_role_requires_mfa
}

output "admin_iam_role_path" {
  description = "Path of admin IAM role"
  value       = module.iam_assumable_roles.admin_iam_role_path
}

output "admin_iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.iam_assumable_roles.admin_iam_role_unique_id
}

# Poweruser
output "poweruser_iam_role_arn" {
  description = "ARN of poweruser IAM role"
  value       = module.iam_assumable_roles.poweruser_iam_role_arn
}

output "poweruser_iam_role_name" {
  description = "Name of poweruser IAM role"
  value       = module.iam_assumable_roles.poweruser_iam_role_name
}

output "poweruser_iam_role_requires_mfa" {
  description = "Whether poweruser IAM role requires MFA"
  value       = module.iam_assumable_roles.poweruser_iam_role_requires_mfa
}

output "poweruser_iam_role_path" {
  description = "Path of poweruser IAM role"
  value       = module.iam_assumable_roles.poweruser_iam_role_path
}

output "poweruser_iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.iam_assumable_roles.poweruser_iam_role_unique_id
}