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

provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "Development"
      Onwer       = "Ops"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
  default_tags {
    tags = {
      Environment = "Development"
      Onwer       = "Ops"
    }
  }
}


// resource "aws_organizations_account" "prod" {
//   name      = "jfreeman-dev"
//   email     = "joel+aws-prod@jxel.dev"
// }

// resource "aws_organizations_account" "dev" {
//   name      = "jfreeman-dev"
//   email     = "joel+aws-dev@jxel.dev"
// }

resource "aws_organizations_organization" "org" {

  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com"
  ]

  feature_set = "ALL"
}

// TODO:
// Add GuardDuty
// Add Config
// Add SecurityHb
// Add CloudTrail
// Add roles in each Account

resource "aws_organizations_account" "security" {
  name      = var.security_account_name
  email     = var.security_account_email
  role_name = "Admin"

resource "aws_organizations_account" "logs" {
  name      = var.logs_account_name
  email     = var.logs_account_email
  role_name = "Admin"
}

resource "aws_organizations_account" "dev" {
  name      = var.dev_account_name
  email     = var.dev_account_email
  role_name = "Admin"
}

resource "aws_organizations_account" "prod" {
  name      = var.prod_account_name
  email     = var.prod_account_email
  role_name = "Admin"
}


module "iam" {
  source     = "./modules/iam"
  account_id = var.aws_account_id
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
    aws = aws.us-east-1
  }
}

// module "iam_account_prod" {
//   source  = "terraform-aws-modules/iam/aws//modules/iam-account"
//   version = "~> 3.0"

//   account_alias = "jfreeman-prod"

//   minimum_password_length = 37
//   require_numbers         = false
// }

// module "iam_account_dev" {
//   source  = "terraform-aws-modules/iam/aws//modules/iam-account"
//   version = "~> 3.0"

//   account_alias = "jfreeman-dev"

//   minimum_password_length = 37
//   require_numbers         = false
// }


// module "iam_assumable_roles" {
//   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
//   version = "~> 3.0"

//   trusted_role_arns = [
//     "arn:aws:iam::${module.iam_account_dev.}:root",
//   ]

//   create_admin_role = true

//   create_poweruser_role = true
//   poweruser_role_name   = "developer"

//   create_readonly_role       = true
//   readonly_role_requires_mfa = false
// }