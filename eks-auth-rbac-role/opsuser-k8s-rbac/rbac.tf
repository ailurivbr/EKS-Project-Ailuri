resource "kubernetes_namespace" "ops" {
  metadata {
    name = "ops"
  }
}

resource "kubernetes_role" "ops_view" {
  metadata {
    name      = "ops-view"
    namespace = kubernetes_namespace.ops.metadata[0].name
  }

  rule {
    api_groups = [""] 
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "ops_view_binding" {
  metadata {
    name      = "ops-view-binding"
    namespace = kubernetes_namespace.ops.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.ops_view.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "ops-readonly"
    api_group = "rbac.authorization.k8s.io"
  }
}
