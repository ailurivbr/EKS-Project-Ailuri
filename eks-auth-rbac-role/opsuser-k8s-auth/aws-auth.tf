provider "kubernetes" {
  # These need to be passed or fetched from root module
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate)
  token                  = var.cluster_token
}

resource "kubernetes_config_map" "aws_auth_ops" {
  metadata {
    name      = "aws-auth-ops"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      for role_arn in var.role_arns : {
        rolearn  = role_arn
        username = "opsuser"
        groups   = ["ops-readonly-group"]
      }
    ])
  }
}
