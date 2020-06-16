data "aws_ami" "amzn2" {
  count = var.os_distro == "amzn2" ? 1 : 0
  
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ami" "ubuntu" {
  count = var.os_distro == "ubuntu" ? 1 : 0
  
  owners      = ["099720109477", "513442679011"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "inline" {
  ami                    = var.os_distro == "amzn2" ? data.aws_ami.amzn2[0].id : data.aws_ami.ubuntu[0].id
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.ssh_keypair_name
  subnet_id              = var.subnet_id
  
  provisioner "remote-exec" {
      inline = [
          "echo 'hello, world' > /tmp/hello_world.log",
      ]
  }

  tags = {
    Name        = "tfc-aws-guinea-pig"
    Owner       = "abasista"
    Tool        = "Terraform"
    TTL         = "temporary"
    remote-exec = "inline"
  }
}