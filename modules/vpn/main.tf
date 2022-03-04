
module "vpn" {
  source = "github.com/jxeldotdev/vpn-ansible-packer//terraform/vpn"

  instance_name   = var.instance_name
  key_pair_name   = var.instance_name
  pub_key         = var.pub_key
  sg_name         = var.sg_name
  sg_desc         = "Opens required ports for Pritunl VPN and its Web UI."
  subnet_id       = var.subnet_id
  vpc_id          = var.vpc_id
  vpn_client_cidr = var.vpn_client_cidr
  home_ip         = var.vpn_home_ip
  webui_port      = var.vpn_webui_port
  vpn_port        = var.vpn_port
  user_data       = "hostnamectl set-hostname ${var.instance_name}"
}

resource "aws_route53_record" "vpn" {
  zone_id = var.r53_zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [module.vpn.public_ip]
}

resource "aws_route53_record" "vpn_www" {
  zone_id = var.r53_zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["www.${var.domain_name}"]
}