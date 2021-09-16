provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "Auth"
      Account     = "Auth"
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
    bucket         = "terraform-state-jfreeman-auth"
    key            = "auth.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-jfreeman-auth"
  }
}