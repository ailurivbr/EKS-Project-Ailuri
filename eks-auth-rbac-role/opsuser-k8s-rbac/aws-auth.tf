data "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

locals {
  existing_roles = yamldecode(data.kubernetes_config_map.aws_auth.data["mapRoles"])

  new_ops_role = {
    rolearn  = var.opsuser_role_arn
    username = "ops-user"
    groups   = ["ops-readonly"]
  }

  updated_roles = concat(local.existing_roles, [local.new_ops_role])
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(local.updated_roles)
  }
}
