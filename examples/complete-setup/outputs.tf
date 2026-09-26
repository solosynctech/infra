# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# Route53 Outputs
output "route53_zone_id" {
  description = "Route53 zone ID"
  value       = module.route53.zone_id
}

output "route53_name_servers" {
  description = "Route53 name servers"
  value       = module.route53.name_servers
}

# Lambda Outputs
output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = module.api_lambda.function_arn
}

output "lambda_function_url" {
  description = "Lambda function URL"
  value       = module.api_lambda.function_url
}

# EKS Outputs
output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_id
}

output "eks_cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_id}"
}
