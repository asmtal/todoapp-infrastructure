
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "EC2 Instance type for Kubernetes Clusters"
}

variable "asg_max_size" {
  type        = number
  default     = 3
  description = "Maximum number of instances in Autoscaling group"
}

variable "subnets" {
  type = map(list(string))
  default = {
    private  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
    database = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  }
  description = "Subnets in CIDR notation"
}

variable "vpn_subnet_id" {
  type        = string
  default     = ""
  description = "description"
}

variable "subnet_ids" {
  type        = list(string)
}

variable "vpn_security_group_id" {
  type        = string
  description = "VPN Security Group ID"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "environment" {
  type        = string
  description = "Name of environment"
}

variable "vpc_id" {
  type        = string
}