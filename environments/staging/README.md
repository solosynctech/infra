# Staging Environment

This directory contains Terraform configuration for the staging environment.

## Usage

```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan -var-file=environments/staging/terraform.tfvars

# Apply changes
terraform apply -var-file=environments/staging/terraform.tfvars

# Destroy resources
terraform destroy -var-file=environments/staging/terraform.tfvars
```

## Configuration

The staging environment uses:
- NAT gateway per availability zone for higher availability
- Medium-sized EKS node group (2-5 nodes)
- Production-like configuration for testing
