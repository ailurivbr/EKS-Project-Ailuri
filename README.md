# EKS-Project-Ailuri

## Objective:

### This setup grants a user (ops-alice) view-only access to all Kubernetes resources in the ops namespace of an Amazon EKS cluster. 
Access is secured via:

- An IAM role that can be assumed only by the IAM user arn:aws:iam::xxxx:user/xxxxx.
- A source IP restriction allowing usage of the IAM role only from IP xx.xx.xx.xx.
- Mapping this role to Kubernetes via the aws-auth ConfigMap.
- Binding the IAM identity to a Kubernetes RBAC role with read-only access to all resources in the ops namespace.

### Architecture Overview

- IAM Role – Trusted by ops-alice IAM user, assumes role only from IP: xxxxxxxxxxx
- aws-auth Mapping – Maps the IAM role to a Kubernetes user (opsuser) and group (ops-read-only).
- RBAC Role & Binding – Grants the ops-read-only group read-only access in the ops namespace.

1. IAM Role Creation (modules/opsuser-iam-role)
Creates an IAM role named OpsUserRole with:

Trust policy allowing assumption only by the ops-alice IAM user.

IP restriction on xx.xx.xx.xx.

2. Kubernetes aws-auth Mapping (modules/opsuser-k8s-rbac)
Maps the IAM role to Kubernetes user/group using the aws-auth config map

3. Kubernetes RBAC Permissions
A ClusterRole named ops-read-only is created, with read-only access to all essential resources.

```
resources: ["pods", "services", "endpoints", "configmaps", "secrets"]
verbs: ["get", "list", "watch"]
```

Then a RoleBinding in the ops namespace connects the user to the role:

```
kind: RoleBinding
namespace: ops
roleRef:
  kind: ClusterRole
  name: ops-read-only
subjects:
  - kind: User
    name: opsuser
```

## Apply Instructions:

### Initialize & apply changes:

- terraform init
- terraform apply

### Validation Steps:

Assume Role as ops-alice using AWS CLI:
Use kubectl with the temporary credentials to test access:

```
kubectl get pods -n ops
kubectl get secrets -n ops
```

### Security Notes:

- The IAM role cannot be assumed outside the specified IP: 52.94.236.248.

- Access is read-only. No create/update/delete permissions are granted.

- RBAC scope is limited strictly to the ops namespace.


