output "cluster_id" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "kubectl_config" {
  description = "kubectl config as generated by the module."
  value       = module.eks.kubeconfig
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.config_map_aws_auth
}

output "instance_id" {
  value = module.vpn.instance_id
}

output "private_ip" {
  value = module.vpn.private_ip
}

output "public_ip" {
  value = module.vpn.public_ip
}

output "security_group_id" {
  value = module.vpn.security_group_id
}

output "hosted_zone_id" {
  value     = aws_route53_zone.zone.zone_id
  sensitive = false
}

output "hosted_zone_nameservers" {
  value     = aws_route53_zone.zone.name_servers
  sensitive = false
}

output "hosted_zone_arn" {
  value     = aws_route53_zone.zone.arn
  sensitive = false
}