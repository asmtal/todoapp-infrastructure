variable "aws_account_id" {
  type = string
}

variable "billing_alert_email" {
  type = string
}

// includes country code
variable "billing_alert_number" {
  type = string
}

variable "home_ip" {
  type = string
}

variable "cloudtrail_bucket_name" {
  type = string
}

variable "account_names" {
  type = list(string)
}

variable "account_emails" {
  type = list(string)
}