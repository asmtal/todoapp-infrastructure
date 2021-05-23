resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "main-todo-dev"
    Environment = "Development"
    Owner       = "Ops"
  }
}

resource "aws_subnet" "vpn" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpn_subnet_cidr
  availability_zone = var.az

  tags = {
    Name        = "vpn"
    Environment = "Development"
    Owner       = "Ops"
  }
}

resource "aws_network_interface" "vpn" {
  subnet_id       = aws_subnet.vpn.id
  private_ips     = [var.vpn_ip]
  security_groups = [aws_security_group.vpn.id]

  tags = {
    Name = "vpn-eni"
  }
}

resource "aws_security_group" "vpn" {
  name        = var.sg_name
  description = var.sg_desc
  vpc_id      = aws_vpc.main.id
}

// Allow Web UI traffic to home IP
resource "aws_security_group_rule" "web_ui" {
  type              = "ingress"
  from_port         = var.webui_port
  to_port           = var.webui_port
  protocol          = "tcp"
  cidr_blocks       = [var.home_ip]
  security_group_id = aws_security_group.vpn.id
}


// Required for LetsEncrypt to work properly
resource "aws_security_group_rule" "letsencrypt" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpn.id
}

// Allow VPN Traffic
resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = var.vpn_port
  to_port           = var.vpn_port
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpn.id
}

// Allow SSH
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.home_ip, var.vpn_client_cidr]
  security_group_id = aws_security_group.vpn.id
}

// Outbound traffic
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpn.id
}
