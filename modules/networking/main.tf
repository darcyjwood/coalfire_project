#networking main.tf

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "cf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "cf_vpc-${random_integer.random.id}"
  }
}

resource "aws_subnet" "cf_public_subnet" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.cf_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = ["us-east-1a", "us-east-1b"][count.index]

  tags = {
    Name = "cf_public_${count.index + 1}"
  }
}

resource "aws_route_table_association" "cf_public_assoc" {
  count          = length(var.public_cidrs)
  subnet_id      = aws_subnet.cf_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.cf_public_rt.id
}

resource "aws_subnet" "cf_private_subnet" {
  count             = length(var.private_cidrs)
  vpc_id            = aws_vpc.cf_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = ["us-east-1a", "us-east-1b"][count.index]

  tags = {
    Name = "cf_private_${count.index + 1}"
  }
}

resource "aws_route_table_association" "cf_private_assoc" {
  count          = length(var.private_cidrs)
  subnet_id      = aws_subnet.cf_private_subnet.*.id[count.index]
  route_table_id = aws_route_table.cf_private_rt.id
}

resource "aws_internet_gateway" "cf_internet_gateway" {
  vpc_id = aws_vpc.cf_vpc.id

  tags = {
    Name = "cf_igw"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "cf_eip" {
  vpc = true
}

resource "aws_nat_gateway" "cf_natgateway" {
  allocation_id = aws_eip.cf_eip.id
  subnet_id     = aws_subnet.cf_public_subnet[0].id
}

resource "aws_route_table" "cf_public_rt" {
  vpc_id = aws_vpc.cf_vpc.id

  tags = {
    Name = "cf_public"
  }
}

resource "aws_route" "default_public_route" {
  route_table_id         = aws_route_table.cf_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cf_internet_gateway.id
}

resource "aws_route_table" "cf_private_rt" {
  vpc_id = aws_vpc.cf_vpc.id

  tags = {
    Name = "cf_private"
  }
}

resource "aws_route" "default_private_route" {
  route_table_id         = aws_route_table.cf_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.cf_natgateway.id
}

resource "aws_default_route_table" "cf_private_rt" {
  default_route_table_id = aws_vpc.cf_vpc.default_route_table_id
  route {
    cidr_block     = var.public_access
    nat_gateway_id = aws_nat_gateway.cf_natgateway.id
  }

  tags = {
    Name = "cf_private"
  }
}

resource "aws_security_group" "cf_public_sg" {
  name        = "cf_public_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.cf_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cf_private_sg" {
  name        = "cf_private_sg"
  description = "Allow SSH from bastion and HTTP from web"
  vpc_id      = aws_vpc.cf_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.cf_public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.cf_web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cf_web_sg" {
  name        = "cf_web_sg"
  description = "Allow all inbound HTTP traffic"
  vpc_id      = aws_vpc.cf_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
