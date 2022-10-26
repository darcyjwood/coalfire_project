#compute main.tf

data "aws_ami" "rhel_8_5" {
  most_recent = true
  owners = ["309956199498"] 
  filter {
    name   = "name"
    values = ["RHEL-8.5*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "cf_public" {
  name_prefix            = "cf_public"
  image_id               = data.aws_ami.rhel_8_5.id
  instance_type          = var.public_instance_type
  vpc_security_group_ids = [var.public_sg]
  key_name               = var.key_name

  tags = {
    Name = "cf_public"
  }
}

resource "aws_autoscaling_group" "cf_public" {
  name                = "cf_public"
  vpc_zone_identifier = tolist(var.public_subnet)
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1

  launch_template {
    id      = aws_launch_template.cf_public.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "cf_private" {
  name_prefix            = "cf_private"
  image_id               = data.aws_ami.rhel_8_5.id
  instance_type          = var.private_instance_type
  vpc_security_group_ids = [var.private_sg]
  key_name               = var.key_name
  user_data              = filebase64("apache.sh")

  tags = {
    Name = "cf_public"
  }
}

resource "aws_autoscaling_group" "private_asg" {
  name                = "private_asg"
  vpc_zone_identifier = tolist(var.private_subnet)
  min_size            = 2
  max_size            = 6
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.cf_private.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.private_asg.id
  lb_target_group_arn    = var.lb_tg
}

