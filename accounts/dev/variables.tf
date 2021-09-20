variable "vault_pass_secret_value" {
  type        = string
  sensitive   = true
  description = "description"
}

variable "aws_auth_account_id" {
  type        = string
}

variable "iam_role" {
  type        = string
}
