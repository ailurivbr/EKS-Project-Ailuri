variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "eks-k8s"
}

variable "service_account_namespace" {
  type    = string
  default = "default"
}

variable "service_account_name" {
  type    = string
  default = "order-processor"
}

variable "s3_bucket_name" {
  type    = string
  default = "s3-incoming-orders"
}
