
To avoid Terraform managing it's own State, I am using the cloudformation stack [cloudformation-terraform-state-backend](https://github.com/thoughtbot/cloudformation-terraform-state-backend)

There is many state buckets, one for each account

Usage:

```sh
ACCOUNT_NAME="jfreeman-website-prod"
aws cloudformation create-stack \
--stack-name terraform-state-$ACCOUNT_NAME \
--template-url "https://s3.us-east-1.amazonaws.com/terraform-state-backend-templates/branch/main/terraform-state-backend.template" \
--parameters ParameterKey=Name,ParameterValue=terraform-state-$ACCOUNT_NAME \
--capabilities CAPABILITY_NAMED_IAM
```