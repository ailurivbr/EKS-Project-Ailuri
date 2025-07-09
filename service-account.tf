resource "kubernetes_service_account" "order_processor" {
  metadata {
    name      = var.service_account_name
    namespace = var.service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.order_processor_role.arn
    }
  }
}
