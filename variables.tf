#root variables.tf

variable "access_ip" {
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "public_cidrs"{
  default = ["10.1.0.0/24", "10.1.1.0/24"]
}

variable "private_cidrs"{
  default = ["10.1.2.0/24", "10.1.3.0/24"]
}

variable "key_name" {
  default = "cf_key"
}

variable "tags" {
  default = "coalfire_project"
}

variable "bucket_name" {
  default     = "coalfire-project-1022"
  type        = string
  description = "bucket name"
}

variable "public_access" {
  default = "0.0.0.0/0"
}