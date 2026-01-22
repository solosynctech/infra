# Lambda Module

This module creates and manages AWS Lambda functions with supporting resources including IAM roles, CloudWatch logs, and optional function URLs.

## Features

- Lambda function with configurable runtime and settings
- Automatic IAM role creation with necessary permissions
- CloudWatch log group with configurable retention
- VPC support for private subnet deployment
- Function URL support with CORS configuration
- Lambda alias support
- Dead letter queue configuration
- Custom IAM policies
- Environment variables support
- Lambda layers support

## Usage

### Basic Lambda function from local file

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "my-function"
  description   = "My Lambda function"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = "${path.module}/lambda/my-function.zip"
  
  timeout     = 10
  memory_size = 256
  
  environment_variables = {
    ENV       = "production"
    LOG_LEVEL = "info"
  }
  
  tags = {
    Environment = "production"
  }
}
```

### Lambda function from S3

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "my-s3-function"
  handler       = "index.handler"
  runtime       = "python3.11"
  
  s3_bucket = "my-deployment-bucket"
  s3_key    = "lambda/my-function.zip"
  
  tags = {
    Environment = "dev"
  }
}
```

### Lambda with VPC configuration

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "vpc-lambda"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = "${path.module}/lambda/function.zip"
  
  vpc_config = {
    subnet_ids         = module.vpc.private_subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }
  
  tags = {
    Environment = "production"
  }
}
```

### Lambda with Function URL

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "api-function"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = "${path.module}/lambda/api.zip"
  
  create_function_url   = true
  function_url_auth_type = "NONE"
  
  cors_allow_origins = ["https://example.com"]
  cors_allow_methods = ["GET", "POST"]
  
  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| function_name | Name of the Lambda function | `string` | n/a | yes |
| description | Description of the Lambda function | `string` | `""` | no |
| handler | Lambda function handler | `string` | `"index.handler"` | no |
| runtime | Lambda runtime | `string` | `"nodejs20.x"` | no |
| timeout | Lambda timeout in seconds | `number` | `3` | no |
| memory_size | Lambda memory size in MB | `number` | `128` | no |
| filename | Path to deployment package | `string` | `null` | no |
| s3_bucket | S3 bucket containing deployment package | `string` | `null` | no |
| s3_key | S3 key of deployment package | `string` | `null` | no |
| environment_variables | Environment variables | `map(string)` | `{}` | no |
| vpc_config | VPC configuration | `object` | `null` | no |
| create_function_url | Whether to create function URL | `bool` | `false` | no |
| log_retention_days | CloudWatch log retention | `number` | `7` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| function_arn | The ARN of the Lambda function |
| function_name | The name of the Lambda function |
| function_invoke_arn | ARN for invoking from API Gateway |
| role_arn | The ARN of the IAM role |
| log_group_name | The name of CloudWatch log group |
| function_url | The URL of the Lambda function |

## Example Lambda Function Code

### Node.js (index.js)
```javascript
exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event, null, 2));
    
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Hello from Lambda!',
            timestamp: new Date().toISOString()
        })
    };
};
```

### Python (index.py)
```python
import json
import datetime

def handler(event, context):
    print('Event:', json.dumps(event))
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Hello from Lambda!',
            'timestamp': datetime.datetime.now().isoformat()
        })
    }
```
