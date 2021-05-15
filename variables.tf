variable "aws_account_id" {
  type = string

}

variable "dev_group_users" {
  type    = list(string)
  default = ["jfreeman"]
}

variable "admin_group_users" {
  type    = list(string)
  default = ["jfreeman"]
}