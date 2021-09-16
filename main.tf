terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 2.21.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.40"
    }
  }
  backend "s3" {
    bucket         = "jfreeman-tf-state"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "jfreeman-tf-state-locking"
  }
}

resource "aws_organizations_account" "logs" {
  name  = var.account_names[0]
  email = var.account_emails[0]
  // Cross account access role
  role_name = "Admin"

  tags = {
    Environment = "Logging"
    Owner       = "Ops"
  }
}

resource "aws_organizations_account" "dev" {
  name  = var.account_names[1]
  email = var.account_emails[1]
  // Cross account access role
  role_name = "Admin"
}


resource "aws_organizations_account" "prod" {
  name  = var.account_names[2]
  email = var.account_emails[2]
  // Cross account access role
  role_name = "Admin"
}

resource "aws_organizations_organization" "org" {

  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "access-analyzer.amazonaws.com",
  ]

  feature_set = "ALL"
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



// // Disabled for now to save costs while not being used.

// module "vpn" {
//   source = "github.com/jxeldotdev/vpn-ansible-packer//terraform/vpn"

//   instance_name   = var.instance_name
//   key_pair_name   = "pritunl-key"
//   pub_key         = var.pub_key
//   sg_name         = "vpn"
//   sg_desc         = "Opens required ports for Pritunl VPN and its Web UI."
//   subnet_id       = element(module.vpc-dev.public_subnets, length(module.vpc-dev.public_subnets) - 1)
//   vpc_id          = module.vpc-dev.vpc_id
//   vpn_client_cidr = "172.16.1.0/24"
//   home_ip         = var.home_ip
//   webui_port      = 443
//   vpn_port        = 6823
//   user_data       = "hostnamectl set-hostname ${var.instance_name}"
//   providers = {
//     aws = aws.dev
//   }
// }

// IAM resources for CI Build
module "vpn-ci" {
  source = "../vpn-ansible-packer/terraform/ci"

  svc_packer_role_name = {
    name = "PackerServiceRoleForCI"
    description = "Role used by Github Actions for vpn-ansible-packer"
  }

  svc_packer_policy_info = {
    name = "PackerEC2PolicyForCI"
    description = "Grants permissions to specific secrets and required permissions for using Packer with EC2"
  }

  svc_secretsmanager_policy_info = {
    name = "PackerSecretsManagerPolicyForCI"
    description = "Grants required permissions to access specific secrets used in vpn-ansible-packer project in AWS secrets manager"
  }


  service_group_name = "AllowAssumePackerRole"
  root_aws_account_id    = var.aws_account_id
  vault_pass_secret_name = "AnsibleVaultPasswordForPackerCI"

  providers = {
    aws = aws.dev
  }
}

# module "vpc-dev" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "todo-app"
#   cidr = "10.0.0.0/16"

#   azs             = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
#   enable_dns_hostnames = true

#   tags = {
#     Terraform   = "true"
#     Environment = "development"
#     Owner       = "Operations"
#   }

#   providers = {
#     aws = aws.dev
#   }
# }

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


module "website" {
  source             = "git::git@github.com:jxeldotdev/jxel.dev.git//tf-module?ref=main"
  domains            = ["jxel.dev", "www.jxel.dev"]
  zone_id            = var.zone_id
  bucket_name        = "jxel-dev-prod"
  service_role_group = "assume-gh-actions-role"
  service_role_name  = "website-gh-actions"
  service_user       = "website-gh-actions"
  pgp_key            = "keybase:joelfreeman"

  providers = {
    aws        = aws.prod-ue1
    cloudflare = cloudflare
  }
}