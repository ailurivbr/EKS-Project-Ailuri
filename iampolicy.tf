resource "aws_iam_policy" "order_processor_s3_access" {
  name        = "OrderProcessorS3AccessPolicy"
  description = "Allow listing and reading objects in incoming-orders bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
  depends_on = [aws_s3_bucket.incoming_orders]
}
