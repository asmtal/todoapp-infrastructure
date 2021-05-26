data "aws_caller_identity" "current" {}

// Administrators
resource "aws_iam_role" "administrators" {
  name               = "administrators"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "administrators" {
  role       = aws_iam_role.administrators.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "administrators" {
  group      = aws_iam_group.administrators.name
  policy_arn = aws_iam_policy.administrators.arn
}

resource "aws_iam_group" "administrators" {
  name = "administrators"
}

// Developers

resource "aws_iam_role" "developers" {
  name               = "developers"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_role_policy_attachment" "developers" {
  role       = aws_iam_role.developers.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_group_policy_attachment" "developers" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developers.arn
}

// Require users to have MFA and grant permissions to manage password etc.

resource "aws_iam_group" "mfa_and_password_management" {
  name = "require_mfa"
}

resource "aws_iam_group_policy_attachment" "require_mfa" {
  group      = aws_iam_group.mfa_and_password_management.name
  policy_arn = aws_iam_policy.require_mfa.arn
}

resource "aws_iam_group_policy_attachment" "password_management" {
  group      = aws_iam_group.mfa_and_password_management.name
  policy_arn = aws_iam_policy.user_password_management.arn
}

// Administrator Users

resource "aws_iam_user" "jfreeman" {
  name = "jfreeman"
}

resource "aws_iam_access_key" "jfreeman" {
  user    = aws_iam_user.jfreeman.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_group_membership" "jfreeman" {
  user = aws_iam_user.jfreeman.name
  groups = [
    aws_iam_group.administrators.name,
    aws_iam_group.mfa_and_password_management.name,
    module.iam_group_with_assumable_roles_policy_prod_admin.group_name,
    module.iam_group_with_assumable_roles_policy_prod_dev.group_name,
    module.iam_group_with_assumable_roles_policy_dev_admin.group_name,
    module.iam_group_with_assumable_roles_policy_dev_dev_role.group_name,
  ]
}

resource "aws_iam_user_login_profile" "jfreeman" {
  user    = aws_iam_user.jfreeman.name
  pgp_key = var.pgp_key
}

// Terraform Service User

resource "aws_iam_user" "terraform" {
  name = "terraform"
  tags = {
    Name        = "Terraform"
    Environment = "Development"
    Owner       = "Ops"
    ServiceUser = "True"
  }
}

resource "aws_iam_access_key" "terraform" {
  user    = aws_iam_user.terraform.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_group_membership" "terraform" {
  user = aws_iam_user.terraform.name
  groups = [
    aws_iam_group.administrators.name,
    aws_iam_group.mfa_and_password_management.name
  ]
}

resource "aws_iam_user_login_profile" "terraform" {
  user    = aws_iam_user.terraform.name
  pgp_key = var.pgp_key
}

// This is done so there isn't individual users to manage in each account

module "dev_iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "~> 3.0"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  create_admin_role       = true
  admin_role_requires_mfa = true
  admin_role_name         = "administrator"

  create_poweruser_role       = true
  poweruser_role_requires_mfa = true
  poweruser_role_name         = "developer"

  create_readonly_role       = true
  readonly_role_requires_mfa = true

  providers = {
    aws = aws.dev
  }
}

// This is done so there isn't individual users to manage in each account

module "prod_iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "~> 3.0"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  create_admin_role       = true
  admin_role_requires_mfa = true
  admin_role_name         = "administrator"

  create_poweruser_role       = true
  poweruser_role_requires_mfa = true
  poweruser_role_name         = "developer"

  create_readonly_role       = true
  readonly_role_requires_mfa = true

  providers = {
    aws = aws.prod
  }
}

###########################################
## Group to allow Prod Admin role access ##
###########################################

module "iam_group_with_assumable_roles_policy_prod_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 3.0"

  name = "prod-admin-role"

  assumable_roles = [
    "arn:aws:iam::${var.prod_account_id}:role/administrator"
  ]

  group_users = var.prod_admin_role_users

}

###########################################
## Group to allow Prod Dev role access ##
###########################################

module "iam_group_with_assumable_roles_policy_prod_dev" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 3.0"

  name = "prod-dev-role"

  assumable_roles = [
    "arn:aws:iam::${var.prod_account_id}:role/developer"
  ]

  group_users = var.prod_dev_role_users


}

################################################
## Group to allow Developer Admin role access ##
################################################

module "iam_group_with_assumable_roles_policy_dev_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 3.0"

  name = "dev-admin-role"

  assumable_roles = [
    "arn:aws:iam::${var.dev_account_id}:role/administrator"
  ]

  group_users = var.dev_admin_role_users
}

####################################################
## Group to allow Developer Developer role access ##
####################################################

module "iam_group_with_assumable_roles_policy_dev_dev_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 3.0"

  name = "dev-dev-role"

  assumable_roles = [
    "arn:aws:iam::${var.dev_account_id}:role/developer"
  ]

  group_users = var.dev_dev_role_users
}