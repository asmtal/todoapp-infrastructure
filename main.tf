terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.39.0"
    }
  }
  backend "s3" {
    bucket = "jfreeman-tf-state"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
    dynamodb_table = "jfreeman-tf-state-locking"
  }
}

provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "Development"
      Onwer       = "Ops"
    }
  }
}



module "iam" {
  source     = "./modules/iam"
  account_id = var.aws_account_id
}

module "state" {
  source = "./modules/state"

  table_name  = "jfreeman-tf-state-locking"
  bucket_name = "jfreeman-tf-state"
}

