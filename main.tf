provider "aws" {
  region  = "us-east-1"
  version = "~> 2.63.0"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "vault-dev-server" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.vault_ec2__instance_profile.id
  user_data            = data.template_file.vault-server-init.rendered

  tags = {
    Name = "vault-dev-server"
  }
}

data "template_file" "vault-server-init" {
  template = "${file("${path.module}/template_file/userdata.tpl")}"
  vars = {

    unsecured_token = random_password.user1_vault_password.result
    dumbpassword    = random_password.vault_token.result
    vault_user_1    = random_pet.user1_vault_user_name.id

  }
}