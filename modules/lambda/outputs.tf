output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "function_qualified_arn" {
  description = "The ARN identifying your Lambda function version"
  value       = aws_lambda_function.this.qualified_arn
}

output "function_invoke_arn" {
  description = "The ARN to be used for invoking Lambda function from API Gateway"
  value       = aws_lambda_function.this.invoke_arn
}

output "function_version" {
  description = "Latest published version of the Lambda function"
  value       = aws_lambda_function.this.version
}

output "role_arn" {
  description = "The ARN of the IAM role created for the Lambda function"
  value       = aws_iam_role.lambda.arn
}

output "role_name" {
  description = "The name of the IAM role created for the Lambda function"
  value       = aws_iam_role.lambda.name
}

output "log_group_name" {
  description = "The name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda.name
}

output "function_url" {
  description = "The URL of the Lambda function"
  value       = var.create_function_url ? aws_lambda_function_url.this[0].function_url : null
}

output "alias_arn" {
  description = "The ARN of the Lambda alias"
  value       = var.create_alias ? aws_lambda_alias.this[0].arn : null
}
