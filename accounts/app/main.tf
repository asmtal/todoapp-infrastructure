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
  cluster_name    = "todo-app-${terraform.workspace}"
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
          "key"                 = "k8s.io/cluster-autoscaler/todo-app-${terraform.workspace}"
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

module "r53_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.3"

  name        = "CertManagerRoute53Management"
  path        = "/"
  description = "Grants required permissions for Cert Manager role to manage route53"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZonesByName",
        "route53:ListHostedZones"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

// used by cert-manager and 
resource "aws_iam_role" "dns_manager" {
  name = "DNSManager"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${local.cluster_hex_id}"
        },
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.${var.aws_region}.amazonaws.com/id/${local.cluster_hex_id}:sub" : [
              "system:serviceaccount:cert-manager:cert-manager",
              "system:serviceaccount:external-dns:external-dns"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "github_actions_terraform" {
  name = "GitHubActionsTerraform"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${local.cluster_hex_id}"
        },
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.${var.aws_region}.amazonaws.com/id/${local.cluster_hex_id}:sub" : [
              "system:serviceaccount:actions-runner-controller:actions-terraform-runner",
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.dns_manager.name
  policy_arn = module.r53_policy.arn
}

resource "aws_iam_role_policy_attachment" "github_actions_terraform" {
  role       = aws_iam_role.github_actions_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}