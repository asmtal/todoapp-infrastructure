#######################################################
## Developer and Administrator Roles in Each Account ##
#######################################################

module "iam_assumable_roles" {
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
}