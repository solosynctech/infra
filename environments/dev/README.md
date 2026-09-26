# Development Environment

This directory contains Terraform configuration for the development environment.

## Usage

```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan -var-file=environments/dev/terraform.tfvars

# Apply changes
terraform apply -var-file=environments/dev/terraform.tfvars

# Destroy resources
terraform destroy -var-file=environments/dev/terraform.tfvars
```

## Configuration

The dev environment uses:
- Single NAT gateway to reduce costs
- Smaller EKS node group (1-3 nodes)
- Public EKS endpoint for easier access
