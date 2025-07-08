variable "cluster_name" {
  type = string
}

variable "role_arns" {
  description = "List of role ARNs to map"
  type        = list(string)
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_certificate" {
  type = string
}

variable "cluster_token" {
  type = string
}