provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "Production"
      Account     = "Root"
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
    bucket         = "jfreeman-tf-state"
    key            = "terraform-root.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "jfreeman-tf-state-locking"
  }
}