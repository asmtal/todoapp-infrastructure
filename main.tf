terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.39.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

# S3 Bucket

resource "aws_budgets_budget" "cost-alert" {
  name              = "budget-ec2-monthly"
  budget_type       = "COST"
  limit_amount      = var.budget_amount
  limit_unit        = "NZD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.alert_email_address]
  }
}