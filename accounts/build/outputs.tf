output "svc_role_arn" {
  value       = module.vpn_ci_infra.svc_role_arn
  sensitive   = false
  description = "ARN of service role"
}

output "svc_user_access_key" {
  value     = module.vpn_ci_infra.svc_user_access_key
  sensitive = true
}

output "svc_user_secret_key" {
  value     = module.vpn_ci_infra.svc_user_secret_key
  sensitive = true
}

output "vpc_id" {
  value = module.vpn_ci_infra.vpc_id
}

output "public_subnets" {
  value       = module.vpn_ci_infra.public_subnets
  description = "List of public subnets in VPC"
}

output "private_subnets" {
  value       = module.vpn_ci_infra.private_subnets
  description = "List of private subnets in VPC"
}


