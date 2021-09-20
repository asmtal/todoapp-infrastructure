
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "workspace_iam_roles" {
  type = map(any)
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