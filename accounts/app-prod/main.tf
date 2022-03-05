provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "Production"
      Account     = "Production"
      Application = "Todo-App"
      Managed-By  = "Terraform"
      Owner       = "Ops"
    }
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
    bucket         = "terraform-state-jfreeman-prod"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-jfreeman-prod"
  }
}

data "aws_caller_identity" "current" {}

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

resource "aws_route53_zone" "main" {
  name = "app.jxel.dev"
}

resource "aws_route53_record" "dev-ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "dev.app.jxel.dev"
  type    = "NS"
  ttl     = "30"
  records = var.dev_ns
}
