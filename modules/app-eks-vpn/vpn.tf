
module "vpn" {
  source = "github.com/jxeldotdev/vpn-ansible-packer//terraform/vpn"

  instance_name   = "todo-app-vpn-${terraform.workspace}"
  key_pair_name   = "todo-app-vpn-${terraform.workspace}"
  pub_key         = var.pub_key
  sg_name         = "${terraform.workspace}-vpn"
  sg_desc         = "Opens required ports for Pritunl VPN and its Web UI."
  subnet_id       = element(module.vpc.public_subnets, length(module.vpc.public_subnets) - 1)
  vpc_id          = module.vpc.vpc_id
  vpn_client_cidr = "172.16.1.0/24"
  home_ip         = var.vpn_home_ip
  webui_port      = var.vpn_webui_port
  vpn_port        = var.vpn_port
  user_data       = "hostnamectl set-hostname todo-app-vpn-${terraform.workspace}"
}

resource "aws_route53_record" "vpn" {
  zone_id = aws_route53_zone.zone.id
  name    = "vpn.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [module.vpn.public_ip]
}

resource "aws_route53_record" "vpn_www" {
  zone_id = aws_route53_zone.zone.id
  name    = "www.vpn.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["vpn.${var.domain_name}"]
}