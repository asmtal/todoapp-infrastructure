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

variable "pub_key" {
  type = string
}

variable "instance_name" {
  type    = string
  default = "syd-rhel8.4-pritunl-0"

}

/* Cloudflare related stuff */

variable "cf_email" {
  type = string
}

variable "cf_api_token" {
  type	= string
  sensitive = true
}

variable "zone_id" {
  type = string
}


