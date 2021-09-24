locals {
  cluster_name                  = "todo-app-dev"
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler-aws-cluster-autoscaler-chart"
  cluster_hex_id = substr(module.eks.cluster_oidc_issuer_url, 49, 82)
}