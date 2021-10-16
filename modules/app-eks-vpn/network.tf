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

  database_subnet_group_name = "todo-backend-${var.environment}"

  public_subnet_tags = {
    "kubernetes.io/cluster/todo-app-${var.environment}" = "shared"
    "kubernetes.io/role/elb"                                = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/todo-app-${var.environment}" = "shared"
    "kubernetes.io/role/internal-elb"                       = "1"
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

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_mgmt"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [module.vpn.security_group_id]
  }
}