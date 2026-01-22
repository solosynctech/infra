# Complete Infrastructure Setup Example
# This example shows how to use all modules together

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
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
  source = "../../modules/vpc"

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

# Route53 Module
module "route53" {
  source = "../../modules/route53"

  domain_name = var.domain_name
  create_zone = var.create_route53_zone

  a_records = {
    "www" = {
      ttl     = 300
      records = ["192.0.2.1"]  # Replace with your actual IP
    }
    "api" = {
      ttl     = 300
      records = ["192.0.2.2"]  # Replace with your actual IP
    }
  }

  tags = {
    Environment = var.environment
  }
}

# Security Group for Lambda
resource "aws_security_group" "lambda" {
  name        = "${var.project_name}-${var.environment}-lambda-sg"
  description = "Security group for Lambda functions"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-lambda-sg"
  }
}

# Lambda Module
module "api_lambda" {
  source = "../../modules/lambda"

  function_name = "${var.project_name}-${var.environment}-api"
  description   = "API Lambda function"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  
  # You need to create this zip file
  # See examples/lambda-nodejs for sample code
  filename = var.lambda_filename

  timeout     = 10
  memory_size = 256

  environment_variables = {
    ENV          = var.environment
    PROJECT_NAME = var.project_name
    VPC_ID       = module.vpc.vpc_id
  }

  vpc_config = {
    subnet_ids         = module.vpc.private_subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }

  create_function_url    = true
  function_url_auth_type = "NONE"

  cors_allow_origins = ["*"]
  cors_allow_methods = ["GET", "POST", "PUT", "DELETE"]

  tags = {
    Environment = var.environment
    Function    = "api"
  }
}

# EKS Module
module "eks" {
  source = "../../modules/eks"

  cluster_name    = "${var.project_name}-${var.environment}"
  cluster_version = var.eks_cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  endpoint_private_access = true
  endpoint_public_access  = var.environment == "dev" ? true : false

  node_groups = {
    general = {
      desired_size               = var.eks_node_desired_size
      max_size                   = var.eks_node_max_size
      min_size                   = var.eks_node_min_size
      instance_types             = var.eks_node_instance_types
      capacity_type              = "ON_DEMAND"
      disk_size                  = 30
      labels = {
        role = "general"
      }
      taints                     = []
      max_unavailable_percentage = 33
      tags = {
        NodeGroup = "general"
      }
    }
  }

  enable_irsa = true

  tags = {
    Environment = var.environment
  }
}
