## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.58.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_group_with_assumable_roles_policy_admin_cross_account"></a> [iam\_group\_with\_assumable\_roles\_policy\_admin\_cross\_account](#module\_iam\_group\_with\_assumable\_roles\_policy\_admin\_cross\_account) | terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy | ~> 3.0 |
| <a name="module_iam_group_with_assumable_roles_policy_dev_admin"></a> [iam\_group\_with\_assumable\_roles\_policy\_dev\_admin](#module\_iam\_group\_with\_assumable\_roles\_policy\_dev\_admin) | terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy | ~> 4.3 |
| <a name="module_iam_group_with_assumable_roles_policy_developer_cross_account"></a> [iam\_group\_with\_assumable\_roles\_policy\_developer\_cross\_account](#module\_iam\_group\_with\_assumable\_roles\_policy\_developer\_cross\_account) | terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy | ~> 3.0 |
| <a name="module_iam_group_with_policies"></a> [iam\_group\_with\_policies](#module\_iam\_group\_with\_policies) | terraform-aws-modules/iam/aws//modules/iam-group-with-policies | ~> 4.3 |
| <a name="module_iam_group_with_policies_tfstate_admin"></a> [iam\_group\_with\_policies\_tfstate\_admin](#module\_iam\_group\_with\_policies\_tfstate\_admin) | terraform-aws-modules/iam/aws//modules/iam-group-with-policies | ~> 4.3 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.require_mfa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.user_password_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.require_mfa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.user_password_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_role"></a> [admin\_role](#input\_admin\_role) | Administrator IAM Role ARN | `string` | n/a | yes |
| <a name="input_admin_users"></a> [admin\_users](#input\_admin\_users) | Users to add to Administrator Group | `list(string)` | n/a | yes |
| <a name="input_build_account_role_users"></a> [build\_account\_role\_users](#input\_build\_account\_role\_users) | n/a | `map(list)` | <pre>{<br>  "admin": [],<br>  "dev": []<br>}</pre> | no |
| <a name="input_dev_account_role_users"></a> [dev\_account\_role\_users](#input\_dev\_account\_role\_users) | n/a | `map(list)` | <pre>{<br>  "admin": [],<br>  "dev": []<br>}</pre> | no |
| <a name="input_dev_role"></a> [dev\_role](#input\_dev\_role) | Developer IAM Role ARN | `string` | n/a | yes |
| <a name="input_dev_users"></a> [dev\_users](#input\_dev\_users) | Users to add to Developer Group | `list(string)` | n/a | yes |
| <a name="input_iam_users"></a> [iam\_users](#input\_iam\_users) | List of all users to create in Authentication Account. | `list(any)` | n/a | yes |
| <a name="input_pgp_key"></a> [pgp\_key](#input\_pgp\_key) | PGP Key to encrypt IAM Access Keys with | `string` | `"keybase:joelfreeman"` | no |
| <a name="input_prod_account_role_users"></a> [prod\_account\_role\_users](#input\_prod\_account\_role\_users) | n/a | `map(list)` | <pre>{<br>  "admin": [],<br>  "dev": []<br>}</pre> | no |
| <a name="input_terraform_state_group_users"></a> [terraform\_state\_group\_users](#input\_terraform\_state\_group\_users) | n/a | `list(string)` | n/a | yes |
| <a name="input_website_account_role_users"></a> [website\_account\_role\_users](#input\_website\_account\_role\_users) | n/a | `map(list)` | <pre>{<br>  "admin": [],<br>  "dev": []<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_iam_role_arn"></a> [admin\_iam\_role\_arn](#output\_admin\_iam\_role\_arn) | ARN of admin IAM role |
| <a name="output_admin_iam_role_name"></a> [admin\_iam\_role\_name](#output\_admin\_iam\_role\_name) | Name of admin IAM role |
| <a name="output_admin_iam_role_path"></a> [admin\_iam\_role\_path](#output\_admin\_iam\_role\_path) | Path of admin IAM role |
| <a name="output_admin_iam_role_requires_mfa"></a> [admin\_iam\_role\_requires\_mfa](#output\_admin\_iam\_role\_requires\_mfa) | Whether admin IAM role requires MFA |
| <a name="output_admin_iam_role_unique_id"></a> [admin\_iam\_role\_unique\_id](#output\_admin\_iam\_role\_unique\_id) | Unique ID of IAM role |
| <a name="output_cross_account_administrator_group_arn"></a> [cross\_account\_administrator\_group\_arn](#output\_cross\_account\_administrator\_group\_arn) | Groups that grant permissions to assume Administrator IAM Role in other AWS Accounts |
| <a name="output_cross_account_administrator_iam_role_arns"></a> [cross\_account\_administrator\_iam\_role\_arns](#output\_cross\_account\_administrator\_iam\_role\_arns) | description |
| <a name="output_cross_account_developer_iam_group_arns"></a> [cross\_account\_developer\_iam\_group\_arns](#output\_cross\_account\_developer\_iam\_group\_arns) | description |
| <a name="output_cross_account_developer_iam_role_arns"></a> [cross\_account\_developer\_iam\_role\_arns](#output\_cross\_account\_developer\_iam\_role\_arns) | Groups that grant permissions to assume Developer IAM Role in other AWS Accounts |
| <a name="output_iam_access_keys"></a> [iam\_access\_keys](#output\_iam\_access\_keys) | n/a |
| <a name="output_iam_secret_access_keys"></a> [iam\_secret\_access\_keys](#output\_iam\_secret\_access\_keys) | n/a |
| <a name="output_iam_user_arns"></a> [iam\_user\_arns](#output\_iam\_user\_arns) | n/a |
| <a name="output_iam_user_names"></a> [iam\_user\_names](#output\_iam\_user\_names) | n/a |
| <a name="output_poweruser_iam_role_arn"></a> [poweruser\_iam\_role\_arn](#output\_poweruser\_iam\_role\_arn) | ARN of poweruser IAM role |
| <a name="output_poweruser_iam_role_name"></a> [poweruser\_iam\_role\_name](#output\_poweruser\_iam\_role\_name) | Name of poweruser IAM role |
| <a name="output_poweruser_iam_role_path"></a> [poweruser\_iam\_role\_path](#output\_poweruser\_iam\_role\_path) | Path of poweruser IAM role |
| <a name="output_poweruser_iam_role_requires_mfa"></a> [poweruser\_iam\_role\_requires\_mfa](#output\_poweruser\_iam\_role\_requires\_mfa) | Whether poweruser IAM role requires MFA |
| <a name="output_poweruser_iam_role_unique_id"></a> [poweruser\_iam\_role\_unique\_id](#output\_poweruser\_iam\_role\_unique\_id) | Unique ID of IAM role |
