This terraform configuration is applied to the Production and Development accounts.

High-Level resources:
* EKS Cluster
* IAM Service Roles to manage Route53 
* IAM Service Roles to be used by Terraform
* VPN Deployment
* VPC
* Route53 Zone
* Route53 Subzone (Conditional)