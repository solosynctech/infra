# Complete Infrastructure Setup Example

This example demonstrates how to use all modules together to create a complete AWS infrastructure.

## Architecture

This setup includes:
- VPC with public and private subnets across 2 AZs
- Route53 hosted zone with DNS records
- Lambda function with VPC access
- EKS cluster with managed node groups

## Directory Structure

```
complete-setup/
├── main.tf           # Main configuration
├── variables.tf      # Variable definitions
├── outputs.tf        # Outputs
├── terraform.tfvars.example  # Example variables
└── README.md         # This file
```

## Prerequisites

1. AWS account with appropriate permissions
2. Terraform >= 1.5.0
3. AWS CLI configured
4. Domain name (for Route53)

## Setup Steps

1. **Copy the example files:**
   ```bash
   cd examples/complete-setup
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit `terraform.tfvars`:**
   - Update AWS region
   - Set your project name
   - Configure domain name (if using Route53)
   - Adjust CIDR blocks if needed

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Review the plan:**
   ```bash
   terraform plan
   ```

5. **Apply the configuration:**
   ```bash
   terraform apply
   ```

6. **Get the outputs:**
   ```bash
   terraform output
   ```

## Post-Deployment

### Configure EKS Access

```bash
# Update kubeconfig
aws eks update-kubeconfig --region <region> --name <cluster-name>

# Verify access
kubectl get nodes
```

### Update DNS Nameservers

If using Route53:
1. Get nameservers: `terraform output route53_name_servers`
2. Update your domain registrar with these nameservers

### Access Lambda Function

```bash
# Get Lambda function URL
terraform output lambda_function_url

# Test the function
curl $(terraform output -raw lambda_function_url)/health
```

## Cost Considerations

This complete setup will incur AWS charges:
- VPC: NAT Gateway (~$32/month per AZ)
- EKS: Control plane (~$73/month) + EC2 instances
- Lambda: Pay per invocation
- Route53: $0.50/month per hosted zone

To minimize costs in dev:
- Set `single_nat_gateway = true`
- Use smaller EKS node instance types
- Set lower EKS node counts

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

⚠️ **Warning:** This will delete all resources. Ensure you have backups if needed.

## Customization

You can customize this setup by:
- Modifying module parameters in `main.tf`
- Adding more Lambda functions
- Adding additional node groups to EKS
- Adding more DNS records
- Integrating with other AWS services

## Troubleshooting

### Issue: Terraform state conflicts
**Solution:** Use remote state backend (S3 + DynamoDB)

### Issue: NAT Gateway timeout
**Solution:** Increase timeout in VPC module or use single NAT gateway

### Issue: EKS cluster creation fails
**Solution:** Ensure subnet CIDR blocks don't overlap and have enough IPs

### Issue: Lambda VPC timeout
**Solution:** Ensure Lambda security group allows outbound traffic to NAT Gateway

## Next Steps

After deployment:
1. Install Kubernetes addons (AWS Load Balancer Controller, Cluster Autoscaler)
2. Set up monitoring (CloudWatch, Prometheus)
3. Configure logging (CloudWatch Logs, ELK)
4. Set up CI/CD pipelines
5. Implement backup strategies
