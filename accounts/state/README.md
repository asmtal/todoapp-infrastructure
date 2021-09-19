
To avoid Terraform managing it's own State, I am using the cloudformation stack [cloudformation-terraform-state-backend](https://github.com/thoughtbot/cloudformation-terraform-state-backend)

There is many state buckets, one for each account. It also contains an IAM policy that's used in an IAM group to grant users access to state.

Usage:

```sh
ACCOUNT_NAME="jfreeman-auth"
aws cloudformation create-stack \
--stack-name terraform-state-$ACCOUNT_NAME \
--template-url "file://terraform-state-backend.template" \
--parameters ParameterKey=Name,ParameterValue=terraform-state-$ACCOUNT_NAME \
--capabilities CAPABILITY_NAMED_IAM
```
