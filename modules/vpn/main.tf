data "aws_ami" "vpn" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-rhel8.4-pritunl-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.account_id]
}

resource "aws_instance" "vpn" {
  ami                         = data.aws_ami.vpn.id
  instance_type               = "t3a.medium"
  associate_public_ip_address = true
  source_dest_check           = false

  network_interface {
    network_interface_id = aws_network_interface.vpn.id
    device_index         = 0
  }

  tags = {
    Name = "vpn"
  }
}
