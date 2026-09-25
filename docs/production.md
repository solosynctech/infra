# Production checklist

1. Build and publish immutable images for homepage, frontend and backend.
2. Configure MongoDB and Redis with network access restricted to the backend.
3. Generate a random JWT_SECRET and store it in the cloud secret manager or deployment environment.
4. Deploy backend first and verify /health and /ready.
5. Deploy frontend with VITE_API_URL pointing at the backend origin; because Vite variables are build-time, rebuild the frontend image when the API origin changes.
6. Deploy homepage.
7. Configure DNS: solosync.live for the company site and app.solosync.live for the user app.
8. Configure HTTPS at the cloud ingress.
9. Run registration/login/logout smoke tests before production traffic.

## Provider choices

Azure: Azure Container Apps.
GCP: Cloud Run.
OCI: Container Instances for the simple non-Kubernetes deployment.

The provider deployment commands intentionally do not create MongoDB or Redis. Existing user-managed services are reused.