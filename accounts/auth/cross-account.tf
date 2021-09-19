locals {
  admin_users = {
    0 = {
      users      = var.prod_admin_role_users
      account_id = var.prod_account_id
    }
    1 = {
      users      = var.dev_admin_role_users
      account_id = var.dev_account_id
    }
    2 = {
      users      = var.website_admin_role_users
      account_id = var.website_account_id
    }
  }
  dev_users = {
    0 = {
      users      = var.prod_dev_role_users
      account_id = var.prod_account_id
    }
    1 = {
      users      = var.dev_dev_role_users
      account_id = var.dev_account_id
    }
    2 = {
      users      = var.website_dev_role_users
      account_id = var.website_account_id
    }
  }
  admin_users_list = distinct(concat([var.prod_admin_role_users[*], var.dev_admin_role_users[*]]))
}

/* cross-account access*/
module "iam_group_with_assumable_roles_policy_developer_cross_account" {
  source   = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  for_each = local.dev_users
  version  = "~> 3.0"

  name = "${each.value["account_id"]}-account-developer-role-access"

  assumable_roles = [
    "arn:aws:iam::${each.value["account_id"]}:role/Developer"
  ]

  group_users = each.value["users"]
}


module "iam_group_with_assumable_roles_policy_admin_cross_account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 3.0"

  for_each = local.admin_users


  name = "${each.value["account_id"]}-account-administrator-role-access"

  assumable_roles = [
    "arn:aws:iam::${each.value["account_id"]}:role/Administrator"
  ]

  group_users = each.value["users"]
}

/* Policy to grant roles access to Terraform S3 Bucket */

module "iam_group_with_policies_tfstate_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "~> 4.3"

  name = "ManageTerraformState"

  attach_iam_self_management_policy = false

  group_users = var.terraform_state_group_users

  custom_group_policy_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ManageTerraformStatePolicy",
  ]
}