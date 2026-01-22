# Lambda Python Example

This is a simple Lambda function example written in Python.

## Features

- HTTP request handling
- Multiple endpoints (health check, data API)
- GET and POST methods
- JSON responses

## Packaging

To package this Lambda function:

```bash
cd examples/lambda-python
zip function.zip index.py
```

## Deployment

Use the Lambda module to deploy:

```hcl
module "api_lambda" {
  source = "./modules/lambda"

  function_name = "api-function-python"
  handler       = "index.handler"
  runtime       = "python3.11"
  filename      = "${path.module}/examples/lambda-python/function.zip"
  
  timeout     = 10
  memory_size = 256
  
  create_function_url = true
  
  tags = {
    Environment = "dev"
  }
}
```

## Testing

After deployment, you can test the function:

```bash
# Health check
curl https://your-function-url.lambda-url.us-east-1.on.aws/health

# Get data
curl https://your-function-url.lambda-url.us-east-1.on.aws/api/data

# Post data
curl -X POST https://your-function-url.lambda-url.us-east-1.on.aws/api/data \
  -H "Content-Type: application/json" \
  -d '{"name": "New Item"}'
```

## With Dependencies

If your function needs dependencies:

```bash
cd examples/lambda-python
pip install -r requirements.txt -t .
zip -r function.zip .
```
