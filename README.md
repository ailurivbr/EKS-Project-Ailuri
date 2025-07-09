# AWS EKS Cluster with Terraform

This Terraform configuration deploys an Amazon EKS cluster with:

✅ A dedicated new VPC (with public and private subnets across at least 2 AZs)
✅ Highly available design (resilient to single AZ failure)
✅ Managed node group sized to run ~250 pods per node (ENI limit)
✅ Nodes sized for 28 GB peak memory each
✅ CloudWatch Container Insights for monitoring & logs

## How It Works

### VPC Module

Creates a new VPC with:

- CIDR block

- At least 2 public and 2 private subnets in different AZs

- NAT Gateway for private subnets

- Ensures resilience to single AZ failure

```
Example:

vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
```

### EKS Module

Creates an EKS cluster with:

- Control plane logging (audit, api, scheduler, etc.)

- Enabled public/private endpoints

- IAM role for the cluster

- CloudWatch logs are enabled

```
name               = "eks-k8s"
kubernetes_version = "1.29"
```

### Node Group Module

Creates a managed node group with:

- Instance type ≈ m5.2xlarge

- Scaling config supporting the desired pod density

- Kubernetes ENI limits dictate ~250 pods per node (This is applied using deployment.yml manifest which is added in this branch)

- Uses private subnets

- Spans multiple AZs

### CloudWatch Agent Helm Chart

Installs AWS CloudWatch Container Insights via Helm:

- Metrics collection

- Log forwarding

- Admin can monitor metrics and logs in AWS Console

## How to Deploy
- Clone the repo
- Initialize Terraform
- Review planned changes
- Apply the config

```
terraform init
terraform plan
terraform apply

To register the Cluter in your CLI, run below command:

aws eks update-kubeconfig --name eks-k8s --region us-east-1
aws eks describe-cluster --name eks-k8s --query "cluster.endpoint" --output text
kubectl get nodes
kubectl apply -f deployment.yaml
kubectl get pods
```

## Validation

- Check EKS cluster in AWS Console

- Verify node group health

- Check subnets across AZs

- View logs in CloudWatch:
```
API
Audit
Scheduler
ControllerManager
```
- View Container Insights metrics




