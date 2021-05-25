terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.39.0"
    }
  }
  backend "s3" {
    bucket         = "jfreeman-tf-state"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "jfreeman-tf-state-locking"
  }
}

// TODO: Add CloudTrail, GuardDuty, SecurityHub
// TODO: Add IAM Roles in Each account.

module "iam" {
  source          = "./modules/iam"
  account_id      = var.aws_account_id
  dev_account_id  = aws_organizations_account.dev.id
  prod_account_id = aws_organizations_account.prod.id

  dev_admin_role_users  = ["jfreeman"]
  dev_dev_role_users    = ["jfreeman"]
  prod_dev_role_users   = ["jfreeman"]
  prod_admin_role_users = ["jfreeman"]


  providers = {
    aws      = aws
    aws.prod = aws.prod
    aws.dev  = aws.dev
  }
}

module "state" {
  source = "./modules/state"

  table_name  = "jfreeman-tf-state-locking"
  bucket_name = "jfreeman-tf-state"
}

// Needs to be in US-East-1
module "billing-alert" {
  source = "./modules/billing-alert"

  billing_alert_email  = var.billing_alert_email
  billing_alert_number = var.billing_alert_number

  providers = {
    aws = aws.root-us-east-1
  }
}