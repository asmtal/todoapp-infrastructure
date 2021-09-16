resource "aws_organizations_account" "accounts" {
  for_each = var.accounts
  name  = each.value["name"]
  email = each.value["email"]

  // Cross account access role
  role_name = "Admin"

  tags = var.account_tags[each.key]
}

resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "access-analyzer.amazonaws.com",
  ]

  feature_set = "ALL"
}
