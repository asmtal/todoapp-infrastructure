data "terraform_remote_state" "dev" {
  backend = "s3"

  config = {
    bucket = "terraform-state-jfreeman-auth"
    key    = "env:/dev/todo-backend-compute.tfstate"
    region = "ap-southeast-2"
    dynamodb_table = "terraform-state-jfreeman-auth"
  }
}

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "dev-ns" {
  zone_id = aws_route53_zone.main.id
  name    = "dev.${var.domain_name}"
  type    = "NS"
  ttl     = "300"
  records = [
    data.terraform_remote_state.dev.outputs.hosted_zone_nameservers[0],
    data.terraform_remote_state.dev.outputs.hosted_zone_nameservers[1],
    data.terraform_remote_state.dev.outputs.hosted_zone_nameservers[2],
    data.terraform_remote_state.dev.outputs.hosted_zone_nameservers[3],
  ]
}