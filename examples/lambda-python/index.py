"""
Example Lambda function in Python
This is a simple HTTP handler that can be used with Lambda Function URLs
"""

import json
import datetime


def handler(event, context):
    """Lambda function handler"""
    print(f'Event received: {json.dumps(event)}')
    
    # Parse request method and path
    method = event.get('requestContext', {}).get('http', {}).get('method', 'GET')
    path = event.get('requestContext', {}).get('http', {}).get('path', '/')
    
    # Example response based on path
    if path == '/health':
        response = {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': json.dumps({
                'status': 'healthy',
                'timestamp': datetime.datetime.now().isoformat()
            })
        }
    elif path == '/api/data' and method == 'GET':
        response = {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': json.dumps({
                'data': [
                    {'id': 1, 'name': 'Item 1'},
                    {'id': 2, 'name': 'Item 2'},
                    {'id': 3, 'name': 'Item 3'}
                ],
                'timestamp': datetime.datetime.now().isoformat()
            })
        }
    elif path == '/api/data' and method == 'POST':
        try:
            body = json.loads(event.get('body', '{}'))
        except json.JSONDecodeError:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                },
                'body': json.dumps({
                    'error': 'Invalid JSON in request body'
                })
            }
        
        response = {
            'statusCode': 201,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': json.dumps({
                'message': 'Data created successfully',
                'data': body,
                'timestamp': datetime.datetime.now().isoformat()
            })
        }
    else:
        response = {
            'statusCode': 404,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': json.dumps({
                'error': 'Not Found',
                'path': path,
                'method': method
            })
        }
    
    return response
