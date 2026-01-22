/**
 * Example Lambda function in Node.js
 * This is a simple HTTP handler that can be used with Lambda Function URLs
 */

exports.handler = async (event) => {
    console.log('Event received:', JSON.stringify(event, null, 2));
    
    // Parse request method and path
    const method = event.requestContext?.http?.method || 'GET';
    const path = event.requestContext?.http?.path || '/';
    
    // Example response based on path
    let response;
    
    if (path === '/health') {
        response = {
            statusCode: 200,
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                status: 'healthy',
                timestamp: new Date().toISOString()
            })
        };
    } else if (path === '/api/data' && method === 'GET') {
        response = {
            statusCode: 200,
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                data: [
                    { id: 1, name: 'Item 1' },
                    { id: 2, name: 'Item 2' },
                    { id: 3, name: 'Item 3' }
                ],
                timestamp: new Date().toISOString()
            })
        };
    } else if (path === '/api/data' && method === 'POST') {
        const body = event.body ? JSON.parse(event.body) : {};
        
        response = {
            statusCode: 201,
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                message: 'Data created successfully',
                data: body,
                timestamp: new Date().toISOString()
            })
        };
    } else {
        response = {
            statusCode: 404,
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                error: 'Not Found',
                path: path,
                method: method
            })
        };
    }
    
    return response;
};
