module "opsuser_iam_role" {
  source             = "./eks-auth-rbac-role/opsuser-iam-role"
  allowed_account_id = "373527788644"
  allowed_ip         = "52.94.236.248/32"
}

## Allowed_account_id is the my account id as the provided arn "arn:aws:iam::1234566789001:user/ops-alice" account is not exists/valid.

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}
locals {
  cluster_endpoint    = data.aws_eks_cluster.cluster.endpoint
  cluster_certificate = data.aws_eks_cluster.cluster.certificate_authority[0].data
  cluster_token       = data.aws_eks_cluster_auth.cluster.token
}


module "aws_auth" {
  source              = "./eks-auth-rbac-role/opsuser-k8s-auth"
  cluster_name        = var.cluster_name
  cluster_endpoint    = local.cluster_endpoint
  cluster_certificate = local.cluster_certificate
  cluster_token       = local.cluster_token
  role_arns = [
    module.opsuser_iam_role.role_arn
  ]
}
