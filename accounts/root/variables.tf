variable "accounts" {
  type = map(any)
  default = {
    0 = {
      name  = "jfreeman-logging",
      email = ""
    }
  }
  description = "List of maps containing account_name = account_email"
}

variable "account_tags" {
  type = list(map(string))
  default = [
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
  type = map(any)
  default = {
    093986075694 = "jfreeman-dev"
    217846142668 = "jfreeman-prod"
    671132023705 = "jfreeman-website-prod"
  }
  description = "description"
}

variable "pgp_key" {
  type    = string
  default = "keybase:joelfreeman"
}

variable "billing_alert_number" {
  type        = string
}

variable "billing_alert_email" {
  type        = string
}

