provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "Development"
      Account     = "Development"
      Application = "Todo-App"
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
    bucket         = "terraform-state-jfreeman-dev"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-jfreeman-dev"
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
  name = "dev.tinakori.dev"
}


# module "vpn" {
#   source = "github.com/jxeldotdev/vpn-ansible-packer//terraform/vpn"

#   instance_name   = var.instance_name
#   key_pair_name   = var.instance_name
#   pub_key         = var.pub_key
#   sg_name         = var.sg_name
#   sg_desc         = "Opens required ports for Pritunl VPN and its Web UI."
#   subnet_id       = element(module.vpc.public_subnets, length(module.vpc.public_subnets) - 1)
#   vpc_id          = var.vpc_id
#   vpn_client_cidr = "172.16.1.0/24"
#   home_ip         = var.vpn_home_ip
#   webui_port      = var.vpn_webui_port
#   vpn_port        = var.vpn_port
#   user_data       = "hostnamectl set-hostname ${var.instance_name}"
# }

# resource "aws_route53_record" "vpn" {
#   zone_id = var.r53_zone_id
#   name    = "vpn.${var.domain_name}"
#   type    = "A"
#   ttl     = "300"
#   records = [module.vpn.public_ip]
# }

# resource "aws_route53_record" "vpn_www" {
#   zone_id = var.r53_zone_id
#   name    = "www.vpn.${var.domain_name}"
#   type    = "CNAME"
#   ttl     = "300"
#   records = ["vpn.${var.domain_name}"]