variable "ami_filter" {
    type    = string
    default = "packer-rhel8.4-pritunl*"
}

variable "instance_name" {
    type = string
}

variable "instance_type" {
    type = string
    default = t3a.small
}


variable "key_pair_name" {
    type = string
}

variable "pub_key" {
    type = string
}

variable "sg_name" {
    type = string
}

variable "sg_desc" {
    type = string
}

var "vpc_id" {
    type = string
}

variable "subnet_id" {
    type = string
}