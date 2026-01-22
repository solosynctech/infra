# Production Environment

This directory contains Terraform configuration for the production environment.

## Usage

```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan -var-file=environments/prod/terraform.tfvars

# Apply changes
terraform apply -var-file=environments/prod/terraform.tfvars

# Destroy resources (use with caution!)
terraform destroy -var-file=environments/prod/terraform.tfvars
```

## Configuration

The production environment uses:
- Three availability zones for maximum availability
- NAT gateway per availability zone
- Multiple EKS node groups with on-demand and spot instances
- Larger capacity and disk sizes
- Private EKS endpoint for security

## Important Notes

- Always review the plan carefully before applying
- Consider using `terraform apply -target` for incremental changes
- Ensure proper backup and disaster recovery procedures are in place
- Use remote state backend with locking for team collaboration
