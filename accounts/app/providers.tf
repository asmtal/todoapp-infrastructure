provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Managed-By  = "Terraform"
      Environment = "${terraform.workspace}"
      Account     = "${terraform.workspace}"
      Application = "Todo"
      Owner       = "Ops"
    }
  }
  assume_role {
    role_arn = var.workspace_iam_roles[terraform.workspace]
  }
}

provider "cloudflare" {
  email     = var.cf_email
  api_token = var.cf_api_token
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.40"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 2.21.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-state-jfreeman-auth"
    key            = "todo-backend-compute.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-jfreeman-auth"
  }
}