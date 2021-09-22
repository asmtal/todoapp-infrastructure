# todoapp-infrastructure

This repository manages all of my AWS infrastructure.

Terraform configuration for todo app aws infrastructure.
The following repositories are also part of this project:

* [todoapp-frontend](https://github.com/jxeldotdev/todoapp-frontend)
* [todoapp-backend](https://github.com/jxeldotdev/todoapp-backend)
* [vpn-ansible-packer](https://github.com/jxeldotdev/vpn-ansible-packer)

## Directories

### state

Contains CloudFormation template used to create required resources for terraform state.

### shared

Shared configuration between all accounts (Excluding auth)

### root

Config for root AWS Account.

### auth

Confguration for auth / management account.

### dev

required resources for building AMIs. This is used mainly by github actions in the vpn-ansible-packer repo.

### app

Underlying compute infrastructure for todo app. EKS, VPC, Security Groups, VPN, etc.
This is present in the dev and prod account.

