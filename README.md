# Terraform - EKS IRSA Role for S3 Access

This Terraform configuration provisions the IAM role, policy, and Kubernetes service account needed to allow pods using the `order-processor` role service account to get AWS credentials via IAM Roles for Service Accounts (IRSA), granting them permission to list and read objects in the `s3-incoming-orders` S3 bucket.

## 📜 Requirements

- AWS CLI installed and configured
- Terraform v1.0+
- kubectl configured to access your EKS cluster
- Existing EKS cluster with OIDC provider enabled
- The target S3 bucket (`s3incoming-orders`)

## ⚙️ What This Does

- Creates an IAM policy allowing:
```
  - s3:ListBucket on s3-incoming-orders
  - s3:GetObject on s3-incoming-orders/*
```
- Creates an IAM role trusted by the EKS cluster’s OIDC provider:
  - Limited to the `order-processor` Kubernetes service account in your namespace

- Attaches the policy to the role

- Creates/updates the Kubernetes service account with the `eks.amazonaws.com/role-arn` annotation pointing to the IAM role

## How to Deploy

- Clone the repo
- Initialize Terraform
- Review planned changes
- Apply the config
- terraform init
- terraform plan
- terraform apply


