provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "${terraform.workspace}"
      Account     = "${terraform.workspace}"
      Managed-By  = "Terraform"
      Owner       = "Ops"
    }
  }
  assume_role {
    role_arn = var.workspace_iam_roles[terraform.workspace]
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.40"
    }
  }
  backend "s3" {
    bucket         = "terraform-state-jfreeman-auth"
    key            = "shared.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-jfreeman-auth"
  }
}

data "aws_caller_identity" "current" {}

/* IAM Roles */

module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "~> 3.0"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
    "arn:aws:iam::${var.auth_account_id}:root"
  ]

  create_admin_role       = true
  admin_role_requires_mfa = true
  admin_role_name         = "Administrator"

  create_poweruser_role       = true
  poweruser_role_requires_mfa = true
  poweruser_role_name         = "Developer"

  create_readonly_role = false
}

resource "aws_iam_role" "terraform" {
  name               = "Terraform"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "arn:aws:iam::${var.auth_account_id}:root"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "terraform" {
  role       = aws_iam_role.terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}