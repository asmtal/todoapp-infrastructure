variable "iam_users" {
  type        = list(any)
  description = "List of all users to create"
}

variable "dev_users" {
  type        = list(string)
  description = "Users to add to Developer Group"
}

variable "admin_users" {
  type        = list(string)
  description = "Users to add to Administrator Group"
}

variable "prod_admin_role_users" {
  type        = list(string)
  description = "List of users to grant access to assume Administrator role in Production account"
}

variable "prod_dev_role_users" {
  type        = list(string)
  description = "List of users to grant access to assume Developer role in Production account"
}

variable "website_admin_role_users" {
  type        = list(string)
  description = "List of users to grant access to assume Administrator role in Website account"
}

variable "website_dev_role_users" {
  type        = list(string)
  description = "List of users to grant access to assume Developer role in Website account"
}

variable "dev_dev_role_users" {
  type        = list(string)
  description = "List of users to grant access to assume Developer role in Development account"
}

variable "dev_admin_role_users" {
  type        = list(string)
  description = "List of users to grant access to assume Administrator role in Development account"
}

variable "terraform_state_group_users" {
  type = list(string)
}


variable "pgp_key" {
  type        = string
  default     = "keybase:joelfreeman"
  description = "PGP Key to encrypt IAM Access Keys with"
}

variable "account_aliases" {
  type        = map(any)
  description = "Map of AWS Account ID and Account Name."
}

variable "prod_account_id" {
  type = string
}

variable "dev_account_id" {
  type = string
}

variable "website_account_id" {
  type = string
}

variable "domain_name" {
  type        = string
  description = "Domain name for Route53 Zone"
}