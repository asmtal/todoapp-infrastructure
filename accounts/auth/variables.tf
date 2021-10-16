variable "iam_users" {
  type        = list(any)
  description = "List of all users to create in Authentication Account."
}

variable "dev_users" {
  type        = list(string)
  description = "Users to add to Developer Group"
}

variable "admin_users" {
  type        = list(string)
  description = "Users to add to Administrator Group"
}

variable "build_account_role_users" {
  type = map(list(string))
  default = {
    dev   = []
    admin = []
  }
}

variable "dev_account_role_users" {
  type = map(list(string))
  default = {
    dev   = []
    admin = []
  }
}

variable "prod_account_role_users" {
  type = map(list(string))
  default = {
    dev   = []
    admin = []
  }
}

variable "website_account_role_users" {
  type = map(list(string))
  default = {
    dev   = []
    admin = []
  }
}

variable "terraform_state_group_users" {
  type = list(string)
}

variable "pgp_key" {
  type        = string
  default     = "keybase:joelfreeman"
  description = "PGP Key to encrypt IAM Access Keys with"
}

variable "admin_role" {
  type        = string
  description = "Administrator IAM Role ARN"
}

variable "dev_role" {
  type        = string
  description = "Developer IAM Role ARN"
}

variable "account_ids" {
  type        = list(number)
  description = "List of AWS Account IDs"
}

variable "dev_account_id" {}
