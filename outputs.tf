# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

# Route53 Outputs (uncomment when using Route53 module)
# output "route53_zone_id" {
#   description = "The hosted zone ID"
#   value       = module.route53.zone_id
# }
#
# output "route53_name_servers" {
#   description = "Name servers for the hosted zone"
#   value       = module.route53.name_servers
# }

# Lambda Outputs (uncomment when using Lambda module)
# output "lambda_function_arn" {
#   description = "ARN of the Lambda function"
#   value       = module.lambda_function.function_arn
# }
#
# output "lambda_function_url" {
#   description = "URL of the Lambda function"
#   value       = module.lambda_function.function_url
# }

# EKS Outputs (uncomment when using EKS module)
# output "eks_cluster_endpoint" {
#   description = "Endpoint for EKS control plane"
#   value       = module.eks.cluster_endpoint
# }
#
# output "eks_cluster_name" {
#   description = "Name of the EKS cluster"
#   value       = module.eks.cluster_id
# }
#
# output "eks_cluster_certificate_authority_data" {
#   description = "Certificate authority data for EKS cluster"
#   value       = module.eks.cluster_certificate_authority_data
#   sensitive   = true
# }
