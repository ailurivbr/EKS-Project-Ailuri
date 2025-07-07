variable "vpc_name" {
  type = string
}

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  type = string
}
# variable "availability_zone" {
#   type = string
# }

variable "public_subnet_cidrs" {
  type = any
}

variable "private_subnet_cidrs" {
  type = any
}

