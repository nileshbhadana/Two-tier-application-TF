resource "aws_instance" "web-server" {
  depends_on = [
    aws_route_table_association.public,
    aws_route_table_association.private
  ]
  ami                    = data.aws_ami.ubuntu-ami.id
  instance_type          = var.web-server-instance-type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web-server-sg.id]
  user_data              = data.template_file.init-script.rendered
  monitoring             = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  ebs_block_device {
    device_name           = "/dev/xvda"
    delete_on_termination = false
    volume_size           = 20
    encrypted             = true
  }
  root_block_device {
    encrypted = true
  }
  volume_tags = {
    "Name"     = "${var.stack_name}-web-server-ebs",
    "resource" = "ec2-ebs"
  }

  tags = {
    "Name"     = "${var.stack_name}-web-server-instance",
    "resource" = "ec2-instance"
  }
}

resource "aws_instance" "db-server" {
  depends_on = [
    aws_route_table_association.public,
    aws_route_table_association.private
  ]
  ami                    = data.aws_ami.ubuntu-ami.id
  instance_type          = var.db-instance-type
  key_name               = var.key_name
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.web-server-sg.id]
  monitoring             = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  ebs_block_device {
    device_name           = "/dev/xvda"
    delete_on_termination = false
    volume_size           = 20
    encrypted             = true
  }
  root_block_device {
    encrypted = true
  }
  volume_tags = {
    "Name"     = "${var.stack_name}-db-ebs",
    "resource" = "ec2-ebs"
  }

  tags = {
    "Name"     = "${var.stack_name}-db-instance",
    "resource" = "ec2-instance"
  }
}