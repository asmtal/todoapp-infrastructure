output "private_ip" {
  value = module.vpn.private_ip
}

output "public_ip" {
  value = module.vpn.public_ip
}

output "security_group_id" {
  value       = module.vpn.security_group_id
}
