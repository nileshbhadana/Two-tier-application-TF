# Creating VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_config.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name"     = "${var.stack_name}-vpc",
    "resource" = "ec2-vpc"
  }
}

# Allocating Elastic Ip inside the vpc for nat gateway
resource "aws_eip" "nat_ip" {
  vpc = true
}

# creating public subnet with new instance having public ip on launch
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc_config.public_subnet
  availability_zone_id    = data.aws_availability_zones.azs.zone_ids[0]
  map_public_ip_on_launch = true
  tags = {
    "Name"     = "${var.stack_name}-public-subnet",
    "resource" = "ec2-subnet"
  }
}

# creating private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id               = aws_vpc.vpc.id
  cidr_block           = var.vpc_config.private_subnet
  availability_zone_id = data.aws_availability_zones.azs.zone_ids[1]
  tags = {
    "Name"                                      = "${var.stack_name}-private-subnet",
    "resource"                                  = "ec2-subnet"
  }
}

# creating internet gateway for internet access
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"     = "${var.stack_name}-internetgateway",
    "resource" = "ec2-internetgateway"
  }
}

# creating nat gatway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    "Name"     = "${var.stack_name}-natgateway",
    "resource" = "ec2-natgateway"
  }
}


# creating Route tables public and private
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  lifecycle {
    ignore_changes = [route]
  }

  tags = {
    "Name"     = "${var.stack_name}-publicroutetable",
    "resource" = "ec2-publicroutetable"
  }

}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  lifecycle {
    ignore_changes = [route]
  }

  tags = {
    "Name"     = "${var.stack_name}-privateroutetable",
    "resource" = "ec2-privateroutetable"
  }
}

# creating route table association to connect route table to subnets

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# creating security groups
resource "aws_security_group" "web-server-sg" {
  name_prefix            = "web-server-sg"
  vpc_id                 = aws_vpc.vpc.id
  revoke_rules_on_delete = true

  ingress {
    description     = "Allow Https traffic"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description     = "Allow Http traffic"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }  

  egress {
      description     = "Allow egress traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }


  tags = {
    "Name"     = "${var.stack_name}-web-server-sg",
    "resource" = "ec2-securitygroup"
  }
}


resource "aws_security_group" "db-sg" {
  name_prefix            = "db-sg"
  vpc_id                 = aws_vpc.vpc.id
  revoke_rules_on_delete = true
  ingress {
    description     = "Allow Database connections"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web-server-sg.id]
  }
  egress {
    description     = "Allow egress traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name"     = "${var.stack_name}-db-sg",
    "resource" = "ec2-securitygroup"
  }
}