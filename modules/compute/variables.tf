#compute main.tf

variable "public_sg" {}
variable "private_sg" {}
variable "private_subnet" {}
variable "public_subnet" {}
variable "key_name" {}
variable "elb" {}
variable "lb_tg" {}

variable "public_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "private_instance_type" {
  type    = string
  default = "t2.micro"
}