#loadbalancing variables.tf

variable "public_subnet" {}
variable "vpc_id" {}
variable "web_sg" {}
variable "private_asg" {}
#variable "default_sg" {}

variable "tg_protocol" {
  default = "HTTP"
}

variable "tg_port" {
  default = 80
}

variable "listener_protocol" {
  default = "HTTP"
}

variable "listener_port" {
  default = 80
}