output "svc_access_key" {
  value = module.iam.svc_user_access_key
}

output "svc_secret_key" {
  value     = module.iam.svc_user_secret_key
  sensitive = true
}

output "user_access_key" {
  value = module.iam.user_access_key
}

output "user_secret_key" {
  value     = module.iam.user_secret_key
  sensitive = true
}

output "user_name" {
  value = module.iam.user_name
}

output "user_password" {
  value     = module.iam.user_password
  sensitive = true
}


// // Disabled for now since VPN is off to save costs! :)
// output "instance_id" {
//   value = module.vpn.instance_id
// }

// output "private_ip" {
//   value = module.vpn.private_ip
// }

// output "public_ip" {
//   value = module.vpn.public_ip
// }


output "website_role_arn" {
  value = module.website.role_arn
}

output "website_user_arn" {
  value = module.website.user_arn
}

output "website_user_access_key" {
  value = module.website.user_access_key
}

output "website_user_secret_key" {
  value = module.website.user_secret_key
  sensitive = true
}