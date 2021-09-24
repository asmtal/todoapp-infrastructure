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


module "vpn" {
  source = "github.com/jxeldotdev/vpn-ansible-packer//terraform/vpn"

  instance_name   = "todo-app-vpn-${terraform.workspace}"
  key_pair_name   = "todo-app-vpn-${terraform.workspace}"
  pub_key         = var.pub_key
  sg_name         = "${terraform.workspace}-vpn"
  sg_desc         = "Opens required ports for Pritunl VPN and its Web UI."
  subnet_id       = element(module.vpc.public_subnets, length(module.vpc.public_subnets) - 1)
  vpc_id          = module.vpc.vpc_id
  vpn_client_cidr = "172.16.1.0/24"
  home_ip         = var.vpn_home_ip
  webui_port      = var.vpn_webui_port
  vpn_port        = var.vpn_port
  user_data       = "hostnamectl set-hostname todo-app-vpn-${terraform.workspace}"
}

resource "aws_route53_record" "vpn" {
  zone_id = aws_route53_zone.zone.id
  name    = "vpn.${terraform.workspace}.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [module.vpn.public_ip]
}


resource "aws_route53_record" "vpn_www" {
  zone_id = aws_route53_zone.zone.id
  name    = "www.vpn.${terraform.workspace}.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["vpn.${terraform.workspace}.${var.domain_name}"]
}

resource "aws_route53_zone" "zone" {
  name = "${terraform.workspace}.${var.domain_name}"
}