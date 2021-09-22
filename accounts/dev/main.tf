
data "aws_caller_identity" "current" {}

module "vpn_ci_infra" {
  source = "github.com/jxeldotdev/vpn-ansible-packer//terraform/ci?ref=fix-ci-user-permissions"

  svc_packer_role_name = {
    name        = "PackerServiceRoleForCI"
    description = "Role used by Github Actions for vpn-ansible-packer"
  }

  svc_packer_policy_info = {
    name        = "PackerEC2PolicyForCI"
    description = "Grants permissions to specific secrets and required permissions for using Packer with EC2"
  }

  svc_secretsmanager_policy_info = {
    name        = "PackerSecretsManagerPolicyForCI"
    description = "Grants required permissions to access specific secrets used in vpn-ansible-packer project in AWS secrets manager"
  }
  service_group_name      = "AllowAssumePackerRole"
  root_aws_account_id     = var.aws_auth_account_id
  vault_pass_secret_name  = "AnsibleVaultPasswordForPackerBuilderCI"
  vault_pass_secret_value = var.vault_pass_secret_value
}