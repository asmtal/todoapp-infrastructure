variable "az" {
  type    = string
  default = "ap-southeast-2a"
}

variable "account_id" {
    type = number
}

variable "subnet_id" {
    type = string
}

variable "vpc_id" {
    type = string
}


variable "vpn_client_cidr" {
  type    = string
  default = "172.16.1.0/24"
}

variable "sg_name" {
  type    = string
  default = "vpn-apse2a"
}

variable "sg_desc" {
  type    = string
  default = "Security group for Pritunl VPN instance"
}

variable "home_ip" {
    type = string
}

variable "vpn_port" {
    type = number
    default = 6823
}

variable "webui_port" {
    type = number
    default = 8080
}