#networking outputs.tf

output "vpc_id" {
  value = aws_vpc.cf_vpc.id
}

output "public_sg" {
  value = aws_security_group.cf_public_sg.id
}

output "private_sg" {
  value = aws_security_group.cf_private_sg.id
}

output "web_sg" {
  value = aws_security_group.cf_web_sg.id
}

output "private_subnet" {
  value = aws_subnet.cf_private_subnet[*].id
}

output "public_subnet" {
  value = aws_subnet.cf_public_subnet[*].id
}