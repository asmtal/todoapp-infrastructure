output "user_access_key" {
  value = aws_iam_access_key.jfreeman.id
}

output "user_secret_key" {
  value     = aws_iam_access_key.jfreeman.encrypted_secret
  sensitive = true
}

output "user_name" {
  value = aws_iam_user.jfreeman.name
}

output "user_password" {
  value     = aws_iam_user_login_profile.jfreeman.encrypted_password
  sensitive = true
}

// Terraform Service User

output "svc_user_access_key" {
  value = aws_iam_access_key.terraform.id
}

output "svc_user_secret_key" {
  value     = aws_iam_access_key.terraform.encrypted_secret
  sensitive = true
}