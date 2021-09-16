data "aws_caller_identity" "current" {}

/* Roles for access within account */
module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "~> 3.0"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  create_admin_role       = true
  admin_role_requires_mfa = true
  admin_role_name         = "Administrator"

  create_poweruser_role       = true
  poweruser_role_requires_mfa = true
  poweruser_role_name         = "Developer"

  create_readonly_role = false
}

resource "aws_iam_user" "users" {
  for_each = toset(var.iam_users)
  name     = each.key
}

resource "aws_iam_access_key" "users" {
  for_each = toset(var.iam_users)
  user     = aws_iam_user.users[each.key]
  pgp_key  = var.pgp_key
}

module "iam_group_with_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 4.3"

  name = "require-mfa"

  group_users = var.admin_users

  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
    aws_iam_policy.require_mfa.arn
  ]
}

module "iam_group_with_assumable_roles_policy_developers" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 4.3"

  name = "developer-role-access"

  assumable_roles = [
    module.iam_assumable_roles.poweruser_iam_role_arn
  ]

  group_users = var.dev_users
}


module "iam_group_with_assumable_roles_policy_administrator" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 4.3"

  name = "administrator-role-access"

  assumable_roles = [module.iam_assumable_roles.admin_iam_role_arn]

  group_users = var.admin_users

}