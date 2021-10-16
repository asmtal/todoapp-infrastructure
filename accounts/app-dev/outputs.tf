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

output "route53_zone_id" {
  value       = aws_route53_zone.main.zone_id
}

output "route53_zone_ns" {
  value       = aws_route53_zone.main.arn
}
output "route53_zone_arn" {
  value       = aws_route53_zone.main.name_servers
}