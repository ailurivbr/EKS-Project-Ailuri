output "iam_role_arn" {
  value = aws_iam_role.order_processor_role.arn
}

output "iam_policy_arn" {
  value = aws_iam_policy.order_processor_s3_access.arn
}
