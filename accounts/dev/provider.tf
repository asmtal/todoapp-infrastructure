provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "Build"
      Account     = "Dev"
      Managed-By  = "Terraform"
      Owner       = "Ops"
    }
  }
  assume_role {
    role_arn = var.iam_role
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
    key            = "dev.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-jfreeman-auth"
  }
}