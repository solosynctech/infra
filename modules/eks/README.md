# EKS Module

This module creates and manages an AWS EKS (Elastic Kubernetes Service) cluster with managed node groups.

## Features

- EKS cluster with configurable Kubernetes version
- Managed node groups with autoscaling
- IAM roles with required permissions
- OIDC provider for IAM Roles for Service Accounts (IRSA)
- Security groups
- Control plane logging
- Encryption of Kubernetes secrets
- Multiple node groups with different configurations
- Support for spot and on-demand instances
- Node labels and taints

## Usage

### Basic EKS cluster

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.28"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  node_groups = {
    default = {
      desired_size               = 2
      max_size                   = 4
      min_size                   = 1
      instance_types             = ["t3.medium"]
      capacity_type              = "ON_DEMAND"
      disk_size                  = 20
      labels                     = {}
      taints                     = []
      max_unavailable_percentage = 33
      tags                       = {}
    }
  }
  
  tags = {
    Environment = "production"
  }
}
```

### EKS cluster with multiple node groups

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name    = "my-multi-ng-cluster"
  cluster_version = "1.28"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  node_groups = {
    general = {
      desired_size               = 2
      max_size                   = 4
      min_size                   = 1
      instance_types             = ["t3.medium"]
      capacity_type              = "ON_DEMAND"
      disk_size                  = 20
      labels = {
        role = "general"
      }
      taints                     = []
      max_unavailable_percentage = 33
      tags = {
        NodeGroup = "general"
      }
    }
    
    spot = {
      desired_size               = 2
      max_size                   = 10
      min_size                   = 0
      instance_types             = ["t3.large", "t3a.large"]
      capacity_type              = "SPOT"
      disk_size                  = 20
      labels = {
        role = "worker"
        lifecycle = "spot"
      }
      taints = []
      max_unavailable_percentage = 33
      tags = {
        NodeGroup = "spot"
      }
    }
  }
  
  enable_irsa = true
  
  tags = {
    Environment = "production"
  }
}
```

### Private EKS cluster

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name    = "private-cluster"
  cluster_version = "1.28"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  endpoint_private_access = true
  endpoint_public_access  = false
  
  node_groups = {
    default = {
      desired_size               = 2
      max_size                   = 4
      min_size                   = 1
      instance_types             = ["t3.medium"]
      capacity_type              = "ON_DEMAND"
      disk_size                  = 20
      labels                     = {}
      taints                     = []
      max_unavailable_percentage = 33
      tags                       = {}
    }
  }
  
  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the EKS cluster | `string` | n/a | yes |
| cluster_version | Kubernetes version | `string` | `"1.28"` | no |
| vpc_id | VPC ID where cluster will be deployed | `string` | n/a | yes |
| subnet_ids | List of subnet IDs for the cluster | `list(string)` | n/a | yes |
| endpoint_private_access | Enable private API endpoint | `bool` | `true` | no |
| endpoint_public_access | Enable public API endpoint | `bool` | `true` | no |
| public_access_cidrs | CIDRs for public API access | `list(string)` | `["0.0.0.0/0"]` | no |
| enabled_cluster_log_types | Control plane logging types | `list(string)` | `["api", "audit", ...]` | no |
| kms_key_arn | KMS key for secret encryption | `string` | `null` | no |
| node_groups | Map of node group configurations | `map(object)` | See below | no |
| enable_irsa | Enable IRSA | `bool` | `true` | no |
| tags | Tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The name/id of the EKS cluster |
| cluster_arn | The ARN of the cluster |
| cluster_endpoint | Endpoint for EKS control plane |
| cluster_security_group_id | Security group ID of the cluster |
| cluster_certificate_authority_data | Certificate data for cluster communication |
| cluster_version | Kubernetes version |
| cluster_oidc_issuer_url | OIDC Issuer URL |
| oidc_provider_arn | ARN of the OIDC Provider |
| node_groups | Node group outputs |

## Post-Deployment Steps

After deploying the EKS cluster, configure kubectl:

```bash
# Update kubeconfig
aws eks update-kubeconfig --region <region> --name <cluster_name>

# Verify connection
kubectl get nodes

# Install essential add-ons (optional)
# AWS Load Balancer Controller
# Cluster Autoscaler
# Metrics Server
# etc.
```

## Node Group Configuration

Each node group can be customized with the following parameters:

- `desired_size`: Initial number of nodes
- `max_size`: Maximum number of nodes for autoscaling
- `min_size`: Minimum number of nodes for autoscaling
- `instance_types`: List of EC2 instance types
- `capacity_type`: "ON_DEMAND" or "SPOT"
- `disk_size`: Root volume size in GB
- `labels`: Kubernetes labels for the nodes
- `taints`: Kubernetes taints for the nodes
- `max_unavailable_percentage`: Max percentage of unavailable nodes during updates
- `tags`: Additional tags for the node group
