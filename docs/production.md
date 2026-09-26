# Production checklist

## Application

1. Publish immutable frontend and backend images.
2. Configure MongoDB and Redis with private network access.
3. Generate a strong JWT secret and store it in the cloud secret manager.
4. Deploy the backend and verify `/health` and `/ready`.
5. Build the frontend with `VITE_API_URL` set to the backend origin.
6. Configure HTTPS and `app.solosync.live`.

## WhatsApp / WAHA

7. Deploy WAHA on a persistent host or container environment.
8. Mount persistent storage for `/app/.sessions`.
9. Set `WAHA_API_KEY` and keep port 3000 private.
10. Configure the backend with `WAHA_URL`, `WAHA_API_KEY`, webhook URL and HMAC key.
11. Connect a test business account and scan the QR.
12. Confirm the WAHA session reaches `WORKING`.
13. Publish a test message to a controlled chat/channel.
14. Verify the publication becomes `published` and one message ledger entry is recorded.

WAHA documents session persistence, QR authentication, session status events and message/channel APIs. Keep the WAHA API private and protected with an API key.

## Billing

15. Keep `BILLING_ENABLED=false` during the test phase.
16. Confirm the first WhatsApp activation records ₹399 (39,900 paise).
17. Confirm every successful publication records ₹0.10 (10 paise).
18. Integrate a payment provider before enabling real charging.
19. Make payment webhooks and activation charging idempotent.

## Homepage

The company homepage is now a static `index.html` designed for GitHub Pages. Configure GitHub Pages from the repository's `main` branch and configure the custom domain `solosync.live` in repository settings/DNS.

## Cloud

Azure: Azure Container Apps for frontend/backend; private persistent host for WAHA.

GCP: Cloud Run for frontend/backend; private persistent host for WAHA.

OCI: Container Instances or a small VM for the application; persistent private host for WAHA.

Do not put database, WAHA or payment credentials into git.
