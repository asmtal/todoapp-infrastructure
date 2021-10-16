variable "auth_account_id" {
  type        = number
  description = "AWS Account ID of Authentication Account that IAM users assume roles from"
}

variable "vault_pass_secret_value" {
  type        = string
  description = "Ansible Vault Password Secret Value - Used in VPN CI Build"
}

variable "iam_role_arn" {
  type       = string
}