# Allows Terraform to interact with Kubernetes cluster (for Helm, etc.)
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Helm provider will use the default Kubernetes provider config
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}


###############################################
# EKS Authentication Data Source
###############################################

# Fetches authentication token for the EKS cluster
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

###############################################
# Helm Chart: AWS CloudWatch Metrics
#
# Deploys:
#   - CloudWatch Agent DaemonSet
#   - Collects node/pod metrics
#   - Sends metrics to CloudWatch Container Insights
###############################################

resource "helm_release" "cloudwatch_agent" {
  name             = "aws-cw-metrics"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-cloudwatch-metrics"
  namespace        = "amazon-cloudwatch"
  create_namespace = true

  values = [
    yamlencode({
      clusterName = module.eks.cluster_name
      region      = var.aws_region
    })
  ]
}

###############################################
# VPC Module
###############################################

module "vpc" {
  source               = "./Modules/VPC"
  vpc_name             = "vpc-4-k8s"
  vpc_cidr             = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
}

###############################################
# EKS Cluster Module
###############################################

module "eks" {
  source             = "./Modules/EKS"
  name               = "eks-k8s"
  subnet_ids         = module.vpc.private_subnet_ids
  kubernetes_version = "1.29"
}

###############################################
# EKS Node Group Module
###############################################

module "node_group" {
  source       = "./Modules/Node-group"
  name         = "eks-k8s"
  cluster_name = module.eks.cluster_name
  subnet_ids   = module.vpc.private_subnet_ids

  instance_type = "m5.2xlarge"
  desired_size  = 4
  min_size      = 3
  max_size      = 6
}
