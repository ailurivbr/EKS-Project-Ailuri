resource "aws_s3_bucket" "incoming_orders" {
  bucket        = var.s3_bucket_name
  force_destroy = false
}
