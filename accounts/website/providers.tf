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
    bucket         = "terraform-state-jfreeman-website-prod"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-jfreeman-website-prod"
  }
}

provider "cloudflare" {
  email     = var.cf_email
  api_token = var.cf_api_token
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "Production"
      Managed-By  = "Terraform"
      Application = "jxel.dev"
      Owner       = "Ops"
    }
  }
}