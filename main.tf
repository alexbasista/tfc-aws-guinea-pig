provider "vault" {}

module "vault-aws-sts" {
  source  = "app.terraform.io/hc-implementation-services/aws-access-credentials/vault"
  version = "1.1.0"

  aws_secrets_engine_name = var.aws_secrets_engine_name
  aws_secrets_engine_role = var.aws_secrets_engine_role
}

provider "aws" {
  access_key = module.vault-aws-sts.access_key
  secret_key = module.vault-aws-sts.secret_key
  token      = module.vault-aws-sts.security_token
  region     = "us-east-1"
}

data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

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

resource "aws_instance" "web" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.micro"

  tags = {
    Name  = "tfc-aws-guinea-pig-instance"
    Owner = "abasista"
    Tool  = "Terraform"
    TTL   = "temp-delete-me-soon"
  }
}