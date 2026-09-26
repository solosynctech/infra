# Root Main Configuration
# This is an example of how to use the modules together

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Uncomment and configure for remote state storage
  # backend "s3" {
  #   bucket         = "my-terraform-state"
  #   key            = "terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = var.environment
      Project     = var.project_name
    }
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  name               = "${var.project_name}-${var.environment}"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# Route53 Module (example)
# Uncomment and configure as needed
# module "route53" {
#   source = "./modules/route53"
#
#   domain_name = var.domain_name
#   create_zone = true
#
#   a_records = var.route53_a_records
#   cname_records = var.route53_cname_records
#
#   tags = {
#     Environment = var.environment
#   }
# }

# Lambda Module (example)
# Uncomment and configure as needed
# module "lambda_function" {
#   source = "./modules/lambda"
#
#   function_name = "${var.project_name}-${var.environment}-function"
#   description   = "Example Lambda function"
#   handler       = "index.handler"
#   runtime       = "nodejs20.x"
#   filename      = "${path.module}/lambda/function.zip"
#
#   timeout     = 10
#   memory_size = 256
#
#   environment_variables = {
#     ENV = var.environment
#   }
#
#   vpc_config = {
#     subnet_ids         = module.vpc.private_subnet_ids
#     security_group_ids = [aws_security_group.lambda.id]
#   }
#
#   tags = {
#     Environment = var.environment
#   }
# }

# EKS Module (example)
# Uncomment and configure as needed
# module "eks" {
#   source = "./modules/eks"
#
#   cluster_name    = "${var.project_name}-${var.environment}"
#   cluster_version = var.eks_cluster_version
#
#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnet_ids
#
#   node_groups = var.eks_node_groups
#
#   endpoint_private_access = true
#   endpoint_public_access  = var.environment == "dev" ? true : false
#
#   tags = {
#     Environment = var.environment
#   }
# }
