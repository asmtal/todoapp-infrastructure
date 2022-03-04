# module "eks_cluster" {
#   source                = "../../modules/app-eks-vpn"
#   vpc_id                = module.vpc.vpc_id
#   environment           = var.environment
#   vpn_subnet_id         = element(module.vpc.public_subnets, length(module.vpc.public_subnets) - 1)
#   vpn_security_group_id = module.vpn.security_group_id
#   map_roles             = var.map_roles
#   map_accounts          = var.map_accounts
#   map_users             = var.map_users
#   instance_type         = "t3a.medium"
#   asg_max_size          = 4
#   subnet_ids            = module.vpc.private_subnets
# }

provider "kubernetes" {
  config = "~/.kube/kubeconfig_todo-app-development"
}
