variable "accounts" {
  type        = map
  default     = {
    0 = {
      name = "jfreeman-logging",
      email = ""
    }
  }
  description = "List of maps containing account_name = account_email"
}

variable "account_tags" {
  type        = list(map)
  default     = [
    { 
      Environment = "Logging"
      Owner       = "Ops"
    },
    {
      Environment = "Development"
      Application = "Todo"
      Owner       = "Ops"
    },
    {
      Environment = "Production"
      Application = "Todo"
      Owner       = "Ops"
    },
    {
      Environment = "Production"
      Application = "jxel.dev"
      Owner       = "Ops"
    },
    {
      Environment = "Auth"
      Owner       = "Ops"
    }
  ]
  description = "description"
}


variable "account_aliases" {
  type        = map
  default     = {
    093986075694 = "jfreeman-dev"
    217846142668 = "jfreeman-prod"
    671132023705 = "jfreeman-website-prod"
  }
  description = "description"
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

variable "pgp_key" {
  type    = string
  default = "keybase:joelfreeman"
}