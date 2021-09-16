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
  value     = module.website.user_secret_key
  sensitive = true
}

