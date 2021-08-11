provider "aws" {
}

# Fetching Availablity zones in region
data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_ami" "ubuntu-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "init-script" {
  template = file(abspath("init.tpl"))
}