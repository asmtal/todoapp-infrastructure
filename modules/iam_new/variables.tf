variable "account_id" {
  type = string
}

variable "prod_account_id" {
  type = string
}

variable "dev_account_id" {
  type = string
}

variable "pgp_key" {
  type    = string
  default = "keybase:joelfreeman"
}

variable "prod_dev_role_users" {
  type = list(string)
}

variable "prod_admin_role_users" {
  type = list(string)
}

variable "dev_admin_role_users" {
  type = list(string)
}

variable "dev_dev_role_users" {
  type = list(string)
}