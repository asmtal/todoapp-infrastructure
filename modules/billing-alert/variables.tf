variable "currency" {
  type    = string
  default = "USD"
}

variable "billing_threshold" {
  type    = number
  default = 30
}

variable "billing_alert_email" {
  type = string
}

variable "billing_alert_number" {
  type = string
}