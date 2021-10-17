module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "todo-app-${var.environment}"
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
    "kubernetes.io/role/elb"                            = "1"
    "Environment"                                       = "Development"
    "Account"                                           = "Development"
    "Application"                                       = "Todo-App"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/todo-app-${var.environment}" = "shared"
    "kubernetes.io/role/internal-elb"                   = "1"
    "Environment"                                       = "Development"
    "Account"                                           = "Development"
    "Application"                                       = "Todo-App"
  }
}


resource "aws_route53_zone" "main" {
  name = "dev.tinakori.dev"
}

module "vpn" {
  source = "../../modules/vpn"

  instance_name   = var.instance_name
  pub_key         = var.pub_key
  sg_name         = var.sg_name
  subnet_id       = element(module.vpc.public_subnets, length(module.vpc.public_subnets) - 1)
  vpc_id          = module.vpc.vpc_id
  vpn_home_ip     = var.vpn_home_ip
  vpn_webui_port  = var.vpn_webui_port
  vpn_port        = var.vpn_port
  r53_zone_id     = aws_route53_zone.main.zone_id
  domain_name     = "vpn.dev.tinakori.dev"
  vpn_client_cidr = "172.16.1.0/24"
}