# Attach AI Infrastructure

This repository contains modular Terraform configurations for managing AWS infrastructure for Attach AI. It provides reusable modules for VPC networking, Route53 DNS, Lambda functions, and EKS clusters.

## 📁 Repository Structure

```
infra/
├── modules/
│   ├── vpc/              # VPC and networking module
│   ├── route53/          # Route53 DNS management module
│   ├── lambda/           # Lambda function module
│   └── eks/              # EKS cluster module
├── environments/
│   ├── dev/              # Development environment configuration
│   ├── staging/          # Staging environment configuration
│   └── prod/             # Production environment configuration
├── main.tf               # Root Terraform configuration
├── variables.tf          # Variable definitions
├── outputs.tf            # Output definitions
├── terraform.tfvars.example  # Example variables file
└── README.md             # This file
```

## 🚀 Quick Start

### Prerequisites

Before you begin, ensure you have the following installed:

1. **Terraform** (>= 1.5.0)
   ```bash
   # macOS
   brew install terraform
   
   # Linux
   wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
   unzip terraform_1.6.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

2. **AWS CLI** (>= 2.0)
   ```bash
   # macOS
   brew install awscli
   
   # Linux
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   ```

3. **kubectl** (for EKS)
   ```bash
   # macOS
   brew install kubectl
   
   # Linux
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
   ```

### AWS Configuration

1. **Configure AWS credentials:**
   ```bash
   aws configure
   ```
   Enter your AWS Access Key ID, Secret Access Key, default region, and output format.

2. **Verify AWS credentials:**
   ```bash
   aws sts get-caller-identity
   ```

### Initial Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/attach-ai/infra.git
   cd infra
   ```

2. **Create your variables file:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit `terraform.tfvars` with your configuration:**
   ```hcl
   aws_region   = "us-east-1"
   environment  = "dev"
   project_name = "my-project"
   
   vpc_cidr             = "10.0.0.0/16"
   availability_zones   = ["us-east-1a", "us-east-1b"]
   public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
   private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
   ```

4. **Initialize Terraform:**
   ```bash
   terraform init
   ```

5. **Review the plan:**
   ```bash
   terraform plan
   ```

6. **Apply the configuration:**
   ```bash
   terraform apply
   ```

## 🏗️ Module Usage

### VPC Module

Creates a complete VPC with public and private subnets, NAT gateways, and route tables.

```hcl
module "vpc" {
  source = "./modules/vpc"

  name               = "my-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = false
  
  tags = {
    Environment = "production"
  }
}
```

**Outputs:** `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `nat_gateway_ids`

[See full VPC module documentation](./modules/vpc/README.md)

### Route53 Module

Manages Route53 hosted zones and DNS records.

```hcl
module "route53" {
  source = "./modules/route53"

  domain_name = "example.com"
  create_zone = true
  
  a_records = {
    "www" = {
      ttl     = 300
      records = ["192.0.2.1"]
    }
  }
  
  cname_records = {
    "blog" = {
      ttl    = 300
      record = "www.example.com"
    }
  }
}
```

**Outputs:** `zone_id`, `name_servers`, `zone_arn`

[See full Route53 module documentation](./modules/route53/README.md)

### Lambda Module

Creates Lambda functions with IAM roles, CloudWatch logs, and optional function URLs.

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "my-function"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = "${path.module}/lambda/function.zip"
  
  timeout     = 10
  memory_size = 256
  
  environment_variables = {
    ENV = "production"
  }
  
  create_function_url = true
}
```

**Outputs:** `function_arn`, `function_name`, `function_url`, `role_arn`

[See full Lambda module documentation](./modules/lambda/README.md)

### EKS Module

Creates EKS clusters with managed node groups.

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name    = "my-cluster"
  cluster_version = "1.28"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  node_groups = {
    general = {
      desired_size   = 2
      max_size       = 4
      min_size       = 1
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 20
      labels         = {}
      taints         = []
      max_unavailable_percentage = 33
      tags           = {}
    }
  }
}
```

**Outputs:** `cluster_id`, `cluster_endpoint`, `cluster_certificate_authority_data`

[See full EKS module documentation](./modules/eks/README.md)

## 🌍 Environment Management

This repository supports multiple environments with isolated configurations.

### Using Environment-Specific Configurations

#### Development Environment
```bash
terraform plan -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars
```

#### Staging Environment
```bash
terraform plan -var-file=environments/staging/terraform.tfvars
terraform apply -var-file=environments/staging/terraform.tfvars
```

#### Production Environment
```bash
terraform plan -var-file=environments/prod/terraform.tfvars
terraform apply -var-file=environments/prod/terraform.tfvars
```

### Environment Differences

| Feature | Dev | Staging | Prod |
|---------|-----|---------|------|
| Availability Zones | 2 | 2 | 3 |
| NAT Gateways | 1 (shared) | 2 (per AZ) | 3 (per AZ) |
| EKS Nodes | 1-3 | 2-5 | 3-10 |
| Instance Types | t3.medium | t3.medium | t3.large |
| Spot Instances | No | No | Yes |

## 📦 Remote State Management

For team collaboration, configure remote state storage with S3 and DynamoDB:

1. **Create S3 bucket for state:**
   ```bash
   aws s3api create-bucket \
     --bucket my-terraform-state \
     --region us-east-1
   
   aws s3api put-bucket-versioning \
     --bucket my-terraform-state \
     --versioning-configuration Status=Enabled
   ```

2. **Create DynamoDB table for locking:**
   ```bash
   aws dynamodb create-table \
     --table-name terraform-state-lock \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST \
     --region us-east-1
   ```

3. **Update `main.tf` backend configuration:**
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "my-terraform-state"
       key            = "terraform.tfstate"
       region         = "us-east-1"
       dynamodb_table = "terraform-state-lock"
       encrypt        = true
     }
   }
   ```

4. **Initialize with new backend:**
   ```bash
   terraform init -migrate-state
   ```

## 🔐 Security Best Practices

1. **Never commit sensitive files:**
   - `*.tfvars` files (except `.example`)
   - `*.tfstate` files
   - AWS credentials

2. **Use environment variables for secrets:**
   ```bash
   export TF_VAR_db_password="your-secret-password"
   ```

3. **Enable encryption:**
   - S3 bucket encryption for state files
   - KMS encryption for EKS secrets
   - Enable VPC flow logs

4. **Follow least privilege:**
   - Use IAM roles with minimal permissions
   - Restrict security group rules
   - Use private subnets for workloads

## 🛠️ Common Operations

### Deploying a Lambda Function

1. **Create your Lambda code:**
   ```javascript
   // lambda/index.js
   exports.handler = async (event) => {
       return {
           statusCode: 200,
           body: JSON.stringify({ message: 'Hello from Lambda!' })
       };
   };
   ```

2. **Package the function:**
   ```bash
   mkdir -p lambda
   cd lambda
   zip function.zip index.js
   cd ..
   ```

3. **Enable Lambda module in `main.tf`:**
   ```hcl
   module "my_lambda" {
     source = "./modules/lambda"
     
     function_name = "my-function"
     handler       = "index.handler"
     runtime       = "nodejs20.x"
     filename      = "${path.module}/lambda/function.zip"
   }
   ```

4. **Apply:**
   ```bash
   terraform apply
   ```

### Deploying an EKS Cluster

1. **Enable EKS module in `main.tf`:**
   ```hcl
   module "eks" {
     source = "./modules/eks"
     
     cluster_name = "my-cluster"
     vpc_id       = module.vpc.vpc_id
     subnet_ids   = module.vpc.private_subnet_ids
   }
   ```

2. **Apply:**
   ```bash
   terraform apply
   ```

3. **Configure kubectl:**
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name my-cluster
   kubectl get nodes
   ```

### Configuring DNS with Route53

1. **Enable Route53 module in `main.tf`:**
   ```hcl
   module "route53" {
     source = "./modules/route53"
     
     domain_name = "example.com"
     create_zone = true
     
     a_records = {
       "api" = {
         ttl     = 300
         records = ["192.0.2.1"]
       }
     }
   }
   ```

2. **Apply:**
   ```bash
   terraform apply
   ```

3. **Update nameservers at your domain registrar** with the output from:
   ```bash
   terraform output route53_name_servers
   ```

## 🧹 Cleanup

To destroy all resources:

```bash
# Review what will be destroyed
terraform plan -destroy

# Destroy resources
terraform destroy
```

**Warning:** This will delete all resources. Make sure to backup any important data first.

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
- [EKS Best Practices Guide](https://aws.github.io/aws-eks-best-practices/)
- [Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [Route53 Documentation](https://docs.aws.amazon.com/route53/)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test with `terraform plan`
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 💬 Support

For issues and questions:
- Create an issue in this repository
- Contact the DevOps team

---

**Note:** Always review the Terraform plan before applying changes to production environments.
