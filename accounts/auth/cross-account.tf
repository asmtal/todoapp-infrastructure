locals {
  admin_users = {
    0 = {
      users = var.prod_admin_role_users
      account_id = var.prod_account_id
    }
    1 = {
      users = var.dev_admin_role_users
      account_id = var.dev_account_id
    }
    2 = {
      users = var.website_admin_role_users
      account_id = var.website_account_id
    }
  }
  dev_users = {
    0 = {
      users = var.prod_dev_role_users
      account_id = var.prod_account_id
    }
    1 = {
      users = var.dev_dev_role_users
      account_id = var.dev_account_id
    }
    2 = {
      users = var.website_dev_role_users
      account_id = var.website_account_id
    }
  }
}

/* cross-account access*/
module "iam_group_with_assumable_roles_policy_developer" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  for_each = local.dev_users
  version = "~> 3.0"

  name = "${each.value["account_id"]}-account-developer-role-access"

  assumable_roles = [
    "arn:aws:iam::${each.value["account_id"]}:role/Developer"
  ]

  group_users = each.value["users"]
}


module "iam_group_with_assumable_roles_policy_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 3.0"

  for_each = local.admin_users
  

  name = "${each.value["account_id"]}-account-administrator-role-access"

  assumable_roles = [
    "arn:aws:iam::${each.value["account_id"]}:role/Administrator"
  ]

  group_users = each.value["users"]
}