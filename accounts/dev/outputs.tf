output "packer_ci_role_arn" {
  value       = module.vpn_ci_infra.svc_role_arn
  sensitive   = false
  depends_on  = []
}

output "packer_ci_access_key" {
  value       = module.vpn_ci_infra.svc_user_access_key
  sensitive   = true
}

output "packer_ci_secret_key" {
  value       = module.vpn_ci_infra.svc_user_secret_key
  sensitive   = true
}

output "vpc_id" {
  value       = module.vpn_ci_infra.vpc_id
}

output "vpc_public_subnets" {
  value       = module.vpn_ci_infra.public_subnets
}
