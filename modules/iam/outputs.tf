output "user_access_key" {
    value = aws_iam_access_key.jfreeman.id
}

output "user_secret_key" {
    value = aws_iam_access_key.jfreeman.encrypted_secret
}

output "user_password" {
    value = aws_iam_user_login_profile.jfreeman.encrypted_password
}