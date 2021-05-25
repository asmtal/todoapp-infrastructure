resource "aws_organizations_account" "logs" {
  name      = var.account_names[0]
  email     = var.account_emails[0]
  role_name = "Admin"

  tags = {
      Environment = "Logging"
      Owner       = "Ops"
  }
}

resource "aws_organizations_account" "dev" {
  name      = var.account_names[1]
  email     = var.account_emails[1]
  role_name = "Admin"
}

resource "aws_organizations_account" "prod" {
  name      = var.account_names[2]
  email     = var.account_emails[2]
  role_name = "Admin"

  tags = {
      Environment = "Production"
      Owner       = "Ops"
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
