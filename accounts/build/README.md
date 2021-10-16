## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.63.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_roles"></a> [iam\_assumable\_roles](#module\_iam\_assumable\_roles) | terraform-aws-modules/iam/aws//modules/iam-assumable-roles | ~> 3.0 |
| <a name="module_vpn_ci_infra"></a> [vpn\_ci\_infra](#module\_vpn\_ci\_infra) | github.com/jxeldotdev/vpn-ansible-packer//terraform/ci | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth_account_id"></a> [auth\_account\_id](#input\_auth\_account\_id) | AWS Account ID of Authentication Account that IAM users assume roles from | `number` | n/a | yes |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | n/a | `string` | n/a | yes |
| <a name="input_vault_pass_secret_value"></a> [vault\_pass\_secret\_value](#input\_vault\_pass\_secret\_value) | Ansible Vault Password Secret Value - Used in VPN CI Build | `string` | n/a | yes |

## Outputs

No outputs.
