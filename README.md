# todoapp-infrastructure

This repository manages all of my AWS infrastructure.

Terraform configuration for todo app aws infrastructure.
The following repositories are also part of this project:

* [todoapp-frontend](https://github.com/jxeldotdev/todoapp-frontend)
* [todoapp-backend](https://github.com/jxeldotdev/todoapp-backend)
* [vpn-ansible-packer](https://github.com/jxeldotdev/vpn-ansible-packer)

# Directories

## cfn

Contains CloudFormation template and an an ansible playbook to apply it in each account.

The template creates:
* Encrypted S3 Bucket (for terraform state) 
* KMS key (to be used with SOPS to encrypt .tfvars files in this repository)

## modules

Terraform modules used in multiple accounts.

## accounts

