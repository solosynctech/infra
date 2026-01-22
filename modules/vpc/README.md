# VPC Module

This module creates a complete VPC infrastructure with public and private subnets across multiple availability zones.

## Features

- VPC with customizable CIDR block
- Public and private subnets across multiple AZs
- Internet Gateway for public subnets
- NAT Gateway(s) for private subnet internet access
- Route tables and associations
- DNS support and hostnames enabled

## Usage

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
    Environment = "dev"
    Project     = "my-project"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name to be used on all resources as prefix | `string` | n/a | yes |
| vpc_cidr | The CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| public_subnet_cidrs | List of CIDR blocks for public subnets | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]` | no |
| private_subnet_cidrs | List of CIDR blocks for private subnets | `list(string)` | `["10.0.10.0/24", "10.0.20.0/24"]` | no |
| availability_zones | List of availability zones | `list(string)` | n/a | yes |
| enable_nat_gateway | Provision NAT Gateways for private networks | `bool` | `true` | no |
| single_nat_gateway | Use a single shared NAT Gateway | `bool` | `false` | no |
| enable_dns_hostnames | Enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_dns_support | Enable DNS support in the VPC | `bool` | `true` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| public_subnet_ids | List of IDs of public subnets |
| private_subnet_ids | List of IDs of private subnets |
| nat_gateway_ids | List of NAT Gateway IDs |
| internet_gateway_id | The ID of the Internet Gateway |
| public_route_table_id | ID of the public route table |
| private_route_table_ids | List of IDs of private route tables |
