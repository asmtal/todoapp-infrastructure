locals {
  cluster_name                  = "todo-app-${terraform.workspace}"
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler-aws-cluster-autoscaler-chart"
  cluster_hex_id                = substr(module.eks.cluster_oidc_issuer_url, 49, 82)
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"
}

data "aws_subnet" "vpn_subnet" {
  id = element(module.vpc.public_subnets, length(module.vpc.public_subnets) - 1)
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = local.cluster_name
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  cluster_create_timeout                         = "1h"
  cluster_endpoint_private_access                = true
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_endpoint_private_access_cidrs          = concat(var.subnets["private"], [data.aws_subnet.vpn_subnet.cidr_block])
  cluster_endpoint_public_access                 = false
  enable_irsa                                    = true


  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

  worker_groups = [
    {
      name          = "worker-group-1"
      instance_type = var.instance_type
      asg_max_size  = var.asg_max_size
      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "owned"
        }
      ]
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