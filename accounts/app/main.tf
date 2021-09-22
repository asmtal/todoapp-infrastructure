data "aws_caller_identity" "current" {}

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

resource "cloudflare_record" "vpn" {
  zone_id = var.zone_id
  name    = var.vpn_dns_name[0]
  value   = module.vpn.public_ip
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "vpn_www" {
  zone_id = var.zone_id
  name    = var.vpn_dns_name[1]
  value   = var.vpn_dns_name[0]
  type    = "CNAME"
  ttl     = 3600
}


resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_mgmt"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [module.vpn.security_group_id]
  }
}

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
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts
}



data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}