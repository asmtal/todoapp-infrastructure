provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "Build"
      Account     = "Build"
      Application = "Misc"
      Managed-By  = "Terraform"
      Owner       = "Ops"
    }
  }
  assume_role {
    role_arn = var.iam_role_arn
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
    bucket         = "terraform-state-jfreeman-build"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-jfreeman-build"
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

module "vpn_ci_infra" {
  source = "github.com/jxeldotdev/vpn-ansible-packer//terraform/ci"

  svc_packer_role_name = {
    name        = "PackerServiceRoleForCI"
    description = "Role used by Github Actions for vpn-ansible-packer"
  }

  svc_packer_policy_info = {
    name        = "PackerEC2PolicyForCI"
    description = "Grants permissions to specific secrets and required permissions for using Packer with EC2"
  }

  svc_secretsmanager_policy_info = {
    name        = "PackerSecretsManagerPolicyForCI"
    description = "Grants required permissions to access specific secrets used in vpn-ansible-packer project in AWS secrets manager"
  }
  service_group_name      = "AllowAssumePackerRole"
  root_aws_account_id     = var.auth_account_id
  vault_pass_secret_name  = "AnsibleVaultPasswordForPackerBuilderCI"
  vault_pass_secret_value = var.vault_pass_secret_value
}