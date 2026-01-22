# General Variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name to be used as a prefix for resources"
  type        = string
}

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets"
  type        = bool
  default     = false
}

# Route53 Variables
variable "domain_name" {
  description = "Domain name for Route53 hosted zone"
  type        = string
  default     = ""
}

variable "route53_a_records" {
  description = "Map of A records to create"
  type = map(object({
    ttl     = number
    records = list(string)
  }))
  default = {}
}

variable "route53_cname_records" {
  description = "Map of CNAME records to create"
  type = map(object({
    ttl    = number
    record = string
  }))
  default = {}
}

# EKS Variables
variable "eks_cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.28"
}

variable "eks_node_groups" {
  description = "EKS node group configurations"
  type = map(object({
    desired_size               = number
    max_size                   = number
    min_size                   = number
    instance_types             = list(string)
    capacity_type              = string
    disk_size                  = number
    labels                     = map(string)
    taints                     = list(object({
      key    = string
      value  = string
      effect = string
    }))
    max_unavailable_percentage = number
    tags                       = map(string)
  }))
  default = {
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
}
