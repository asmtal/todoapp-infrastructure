CloudFormation configs for KMS Keys (Used for Encryption) and S3 Buckets for state.

This is applied by the ansible playbook, organization cross account roles are used as this is intended to be ran before all the other terraform configs (excluding the AWS organisation in root account.)

Usage:

1. Create a YAML file containing the following variables:
```yaml
dev_role_arn: 
prod_role_arn: 
auth_role_arn: 
website_role_arn: 
build_role_arn: 
profile: 
```
2. Install Ansible, Boto3 and the Ansible AWS module collection:
```sh
cd cfn/
pipenv install
pipenv shell
ansible-galaxy collection install amazon.aws
```
3. Run the playbook and create apply the stacks :)
```sh
ansible-playbook
```
