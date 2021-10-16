variable "auth_account_id" {
  type        = string
  description = "AWS Authentication Account ID that users assume cross-account roles from."
}

variable "iam_role_arn" {
  type        = string
  description = "IAM Role used by Terraform"
}
