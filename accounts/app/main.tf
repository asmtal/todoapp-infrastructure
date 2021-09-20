data "aws_caller_identity" "current" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "todo-app-vpc"
  cidr   = "10.0.0.0/16"

  azs              = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  private_subnets  = var.subnets["private"]
  database_subnets = var.subnets["database"]
  public_subnets   = var.subnets["public"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_vpn_gateway   = false

  database_subnet_group_name = "todo-backend-${terraform.workspace}"

  public_subnet_tags = {
    "kubernetes.io/cluster/todo-app-${terraform.workspace}" = "shared"
    "kubernetes.io/role/elb"                                = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/todo-app-${terraform.workspace}" = "shared"
    "kubernetes.io/role/internal-elb"                       = "1"
  }

  tags = {
    Managed-By  = "Terraform"
    Application = "Todo"
    Account     = "${terraform.workspace}"
    Environment = "${terraform.workspace}"
    Owner       = "Ops"
  }
}


resource "aws_security_group" "postgresql" {
  name_prefix = "todo-backend-postgres"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = var.subnets["private"]
  }
}


# resource "aws_security_group" "all_worker_mgmt" {
#   name_prefix = "all_worker_mgmt"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"
#     security_groups = []
#   }
# }


resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = "todo-app-${terraform.workspace}"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  cluster_create_timeout          = "1h"
  cluster_endpoint_private_access = true

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

  worker_groups = [
    {
      instance_type = var.instance_type
      asg_max_size  = var.asg_max_size
    }
  ]
  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  map_roles                            = var.map_roles
}

