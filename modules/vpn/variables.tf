variable "instance_name" {
  type        = string
  description = "EC2 Instance name"
}

variable "pub_key" {
  type        = string
  description = "SSH Public key to add"
}

variable "r53_zone_id" {
  type        = string
  description = "Route53 Zone ID"
}

variable "vpn_home_ip" {
  type        = string
  description = "IP Address to whitelist for VPN UI Access"
}

variable "sg_name" {
  type        = string
  description = "Name of security group to create for VPN access"
}

variable "vpn_port" {
  type        = number
  description = "VPN Port (UDP)"
}

variable "vpn_webui_port" {
  type        = number
  description = "VPN Web UI port"
}

variable "domain_name" {
  type        = string
  description = "domain name for VPN."
}

variable "vpn_client_cidr" {
  type        = string
  default     = "172.16.1.0/24"
  description = "description"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID that EC2 instance resides in."
}