variable "allowed_account_id" {
  description = "AWS account ID that can assume this role"
  type        = string
}

variable "allowed_ip" {
  description = "CIDR IP allowed to assume the role"
  type        = string
}
