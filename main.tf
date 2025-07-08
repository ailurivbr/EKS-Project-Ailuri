module "opsuser_iam_role" {
  source    = "./eks-auth-rbac-role/opsuser-iam-role"
  role_name = "OpsUserRole"
  user_arn  = "arn:aws:iam::373527788644:user/ops-alice"
  source_ip = "52.94.236.248/32"
}

module "opsuser_k8s_rbac" {
  source                = "./eks-auth-rbac-role/opsuser-k8s-rbac"
  cluster_name          = "eks-k8s"
  cluster_endpoint      = "https://BE4689DAC4D257622797D31D5F199FAE.gr7.us-east-1.eks.amazonaws.com"
  cluster_certificate   = var.cluster_certificate
  opsuser_role_arn      = module.opsuser_iam_role.role_arn
}
