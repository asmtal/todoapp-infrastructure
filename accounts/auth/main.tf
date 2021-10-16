locals {
  dev_and_admin_users_for_roles = {
    DeveloperRoleAccess     = [var.dev_role, var.dev_users]
    AdministratorRoleAccess = [var.admin_role, var.admin_users]
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_user" "users" {
  for_each = toset(var.iam_users)
  name     = each.key
}

resource "aws_iam_access_key" "users" {
  for_each = toset(var.iam_users)
  user     = aws_iam_user.users[each.key].name
  pgp_key  = var.pgp_key
}

module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "~> 3.0"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
  ]

  create_admin_role       = true
  admin_role_requires_mfa = true
  admin_role_name         = "Administrator"

  create_poweruser_role       = true
  poweruser_role_requires_mfa = true
  poweruser_role_name         = "Developer"

  create_readonly_role = false
}

module "iam_group_with_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 4.3"

  name = "require-mfa"

  group_users = var.iam_users

  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
    aws_iam_policy.require_mfa.arn
  ]

  depends_on = [aws_iam_user.users]
}

module "iam_group_with_assumable_roles_policy_dev_admin" {
  for_each = local.dev_and_admin_users_for_roles
  source   = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version  = "~> 4.3"

  name            = each.key
  assumable_roles = [each.value[0]]

  group_users = each.value[1]
}