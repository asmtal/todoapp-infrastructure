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

data "aws_caller_identity" "current" {
}

// TODO: Add CloudTrail, GuardDuty, SecurityHub
// TODO: Add IAM Roles in Each account.

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