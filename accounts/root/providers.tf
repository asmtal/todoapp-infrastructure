provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Managed-By  = "Terraform"
      Environment = "Production"
      Account     = "Root"
      Owner       = "Ops"
    }
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  default_tags {
    tags = {
      Managed-By  = "Terraform"
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
    bucket         = "terraform-state-jfreeman-root"
    key            = "terraform-root.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "jfreeman-tf-state-locking"
  }
}