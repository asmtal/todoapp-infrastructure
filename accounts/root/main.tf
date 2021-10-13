resource "aws_organizations_account" "accounts" {
  for_each = var.accounts
  name     = each.value["name"]
  email    = each.value["email"]

  // Cross account access role
  role_name = "Admin"

  tags = var.account_tags[each.key]

  lifecycle {
    ignore_changes = ["role_name"]
  }
}

resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "access-analyzer.amazonaws.com",
  ]
  feature_set = "ALL"
}


module "billing-alert" {
  source = "../../modules/billing-alert"

  billing_alert_email  = var.billing_alert_email
  billing_alert_number = var.billing_alert_number

  providers = {
    aws = aws.us-east-1
  }
}
