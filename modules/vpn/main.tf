<<<<<<< Updated upstream
data "aws_ami" "vpn" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-rhel8.4-pritunl-*"]
=======
data "aws_ami" "vpn_ami" {
  executable_users = ["self"]
  most_recent      = true
  owners           = ["self"]
  name_regex       = var.ami_regex

  filter {
    name = "name"
    values = [var.ami_filter]
  }


  filter {
    name   = "root-device-type"
    values = ["ebs"]
>>>>>>> Stashed changes
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
<<<<<<< Updated upstream

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
=======
}

resource "aws_key_pair" "vpn_key_pair" {
  key_name = var.key_pair_name
  public_key = var.pub_key
}

module "vpn_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = var.instance_name
  instance_count         = 1

  ami                    = data.aws_ami.vpn_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.vpn_key_pair.id
  monitoring             = true
  vpc_security_group_ids = aws_security_group.vpn.id
  subnet_id              = var.subnet_id

  tags = {
    Terraform   = "true"
    Environment = "dev"
    App         = "Pritunl"
  }
}
>>>>>>> Stashed changes
