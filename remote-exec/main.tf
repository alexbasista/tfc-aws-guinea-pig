#---------------------------------------------------------------------------------------------------------
# AMI Data Sources
#---------------------------------------------------------------------------------------------------------
data aws_ami amzn2 {
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

data aws_ami ubuntu {
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

#---------------------------------------------------------------------------------------------------------
# Security Groups
#---------------------------------------------------------------------------------------------------------
resource aws_security_group ec2_allow {
  name   = "ec2-allow"
  vpc_id = var.vpc_id
  tags   = merge({ "Name" = "ec2-allow" }, var.common_tags)
}

resource aws_security_group_rule ssh {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.ssh_cidr_ingress_allow
  description = "Allow SSH ingress from these CIDR ranges."

  security_group_id = aws_security_group.ec2_allow.id
}

resource aws_security_group_rule egress_allow_all {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all traffic outbound from EC2 instance."

  security_group_id = aws_security_group.ec2_allow.id
}

#---------------------------------------------------------------------------------------------------------
# EC2 Instances
#---------------------------------------------------------------------------------------------------------
resource aws_instance inline_public {
  count = var.public_subnet_id == null ? 0 : 1

  ami                    = var.os_distro == "amzn2" ? data.aws_ami.amzn2[0].id : data.aws_ami.ubuntu[0].id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_allow.id]
  key_name               = var.ssh_keypair_name
  subnet_id              = var.public_subnet_id

  provisioner remote-exec {
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.os_distro == "amzn2" ? "ec2-user" : "ubuntu"
      port        = 22
      private_key = var.remote_exec_private_key
    }

    inline = [
      "echo 'Hello, World. Remote-Exec was here.' > /tmp/hello_world.log",
    ]
  }

  tags = merge(
    {
      "Name"        = "tfc-aws-guinea-pig-inline-public"
      "Tool"        = "Terraform"
      "remote-exec" = "inline"
      "exposure"    = "public"
    },
    var.common_tags
  )
}

resource aws_instance inline_private {
  count = var.private_subnet_id == null ? 0 : 1

  ami                    = var.os_distro == "amzn2" ? data.aws_ami.amzn2[0].id : data.aws_ami.ubuntu[0].id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_allow.id]
  key_name               = var.ssh_keypair_name
  subnet_id              = var.private_subnet_id

  provisioner remote-exec {
    connection {
      type        = "ssh"
      host        = self.private_ip
      user        = var.os_distro == "amzn2" ? "ec2-user" : "ubuntu"
      port        = 22
      private_key = var.remote_exec_private_key
    }

    inline = [
      "echo 'Hello, World. Remote-Exec was here.' > /tmp/hello_world.log",
    ]
  }

  tags = merge(
    {
      "Name"        = "tfc-aws-guinea-pig-inline-private"
      "Tool"        = "Terraform"
      "remote-exec" = "inline"
      "exposure"    = "private"
    },
    var.common_tags
  )
}

resource aws_instance inline_bastion {
  count = var.private_subnet_id != null && var.remote_exec_bastion_host != null ? 1 : 0

  ami                    = var.os_distro == "amzn2" ? data.aws_ami.amzn2[0].id : data.aws_ami.ubuntu[0].id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_allow.id]
  key_name               = var.ssh_keypair_name
  subnet_id              = var.private_subnet_id

  provisioner remote-exec {
    connection {
      type         = "ssh"
      bastion_host = var.remote_exec_bastion_host
      bastion_user = var.remote_exec_bastion_user
      host         = self.private_ip
      user         = var.os_distro == "amzn2" ? "ec2-user" : "ubuntu"
      port         = 22
      private_key  = var.remote_exec_private_key
    }

    inline = [
      "echo 'Hello, World. Remote-Exec was here.' > /tmp/hello_world.log",
    ]
  }

  tags = merge(
    {
      "Name"        = "tfc-aws-guinea-pig-inline-bastion"
      "Tool"        = "Terraform"
      "remote-exec" = "inline"
      "exposure"    = "private-with-bastion"
    },
    var.common_tags
  )
}

resource aws_instance script_private {
  count = var.private_subnet_id != null && var.remote_exec_bastion_host != null ? 1 : 0

  ami                    = var.os_distro == "amzn2" ? data.aws_ami.amzn2[0].id : data.aws_ami.ubuntu[0].id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_allow.id]
  key_name               = var.ssh_keypair_name
  subnet_id              = var.private_subnet_id

  provisioner remote-exec {
    connection {
      type         = "ssh"
      bastion_host = var.remote_exec_bastion_host
      bastion_user = var.remote_exec_bastion_user
      host         = self.private_ip
      user         = var.os_distro == "amzn2" ? "ec2-user" : "ubuntu"
      port         = 22
      private_key  = var.remote_exec_private_key
    }

    inline = [
      "echo 'Hello, World. Remote-Exec was here.' > /tmp/hello_world.log",
    ]
  }

  tags = merge(
    {
      Name        = "tfc-aws-guinea-pig-inline-bastion"
      Tool        = "Terraform"
      remote-exec = "inline"
      exposure    = "private-with-bastion"
    },
    var.common_tags
  )
}

