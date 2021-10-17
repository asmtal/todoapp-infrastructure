variable "auth_account_id" {
  type        = string
  description = "AWS Authentication Account ID that users assume cross-account roles from."
}

variable "iam_role_arn" {
  type        = string
  description = "IAM Role used by Terraform"
}

variable "instance_name" {
  type        = string
  description = "EC2 Instance Name"
}

variable "pub_key" {
  type        = string
  description = "Public SSH key to add to EC2 Instance"
}

variable "sg_name" {
  type        = string
  description = "todo-app-dev-vpn"
}

variable "vpn_home_ip" {
  type        = string
  description = "IP to whitelist"
}

variable "vpn_webui_port" {
  type        = number
  default     = 443
  description = "VPN Web UI Port"
}

variable "vpn_port" {
  type        = number
  description = "VPN Port"
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

variable "environment" {
  type        = string
  description = ""
}

variable "map_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}


variable "map_accounts" {
  type = list(string)
}

variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

