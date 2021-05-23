terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.39.0"
    }
  }
  backend "s3" {
    bucket         = "jfreeman-tf-state"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
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

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
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

// Needs to be in US-East-1
module "billing-alert" {
  source = "./modules/billing-alert"

  billing_alert_email  = var.billing_alert_email
  billing_alert_number = var.billing_alert_number

  providers = {
    aws = aws.us-east-1
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "todo-app"
  cidr = "10.0.0.0/16"

  azs                = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]
  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "Development"
  }
}

// module "vpn" {
//   source = "./modules/vpn"

//   // all the other variables have defaults
//   home_ip = var.home_ip
//   account_id = var.aws_account_id
//   subnet_id  = element(module.vpc.public_subnets, length(module.vpc.public_subnets)-1)
//   vpc_id     = module.vpc.vpc_id
// }
