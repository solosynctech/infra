# SoloSync low-cost production deployment

## Recommended first production shape

Use one VPS for the application runtime:

- Caddy: HTTPS + reverse proxy
- Frontend: Nginx/static React build
- Backend: Node.js/Express API + Redis worker
- WAHA: WhatsApp session runtime with persistent volume
- Existing MongoDB: managed 256 MB instance
- Existing Redis: managed 256 MB instance

Do **not** put MongoDB or Redis on the VPS while the managed instances are sufficient.

### Why a VPS

WAHA's current Docker deployment guide lists a minimum of 2 CPU and 2 GB RAM for a clean Linux server. The WhatsApp session also needs persistent storage. This makes a tiny serverless/PaaS instance a poor fit for the first production deployment.

A practical low-cost starting point is a DigitalOcean Basic 4 GiB / 2 vCPU Droplet in Bangalore. DigitalOcean currently lists that configuration at $24/month and has a Bangalore region. The server is sufficient for one or a small number of WAHA sessions plus the SoloSync API and frontend, while MongoDB and Redis remain external.

## Domain layout

Use:

- `solosync.live` -> company homepage
- `app.solosync.live` -> developer dashboard
- `api.solosync.live` -> public developer API

Caddy terminates HTTPS automatically and routes the three hostnames to the internal Docker services.

The dashboard frontend also proxies `/api`, `/v1` and `/openapi.json` to the backend. This makes dashboard requests same-origin and avoids accidentally compiling `localhost:4000` into a production browser bundle.

## VPS setup

Recommended OS:

- Ubuntu 24.04 LTS
- 2 vCPU
- 4 GB RAM
- 50+ GB SSD

Install Docker Engine and Compose, then:

```bash
git clone https://github.com/solosynctech/infra.git
cd infra/solosync
cp .env.example .env
nano .env
```

Set all secrets before starting:

```env
MONGODB_URI=<existing MongoDB URI>
REDIS_URL=<existing Redis URI>
JWT_SECRET=<random 32+ byte secret>

WAHA_API_KEY=<random strong secret>
WAHA_WEBHOOK_HMAC_KEY=<random strong secret>

GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

BILLING_ENABLED=false
RAZORPAY_KEY_ID=
RAZORPAY_KEY_SECRET=
RAZORPAY_WEBHOOK_SECRET=

ADMIN_EMAIL=
ADMIN_PASSWORD=
```

Generate secrets with:

```bash
openssl rand -hex 32
```

## DNS

Point all three names to the VPS public IPv4:

```text
A   @      <VPS_IP>
A   app    <VPS_IP>
A   api    <VPS_IP>
```

Caddy will obtain and renew TLS certificates after DNS resolves and ports 80/443 are reachable.

## Deploy

```bash
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
docker compose -f docker-compose.prod.yml ps
```

Check:

```bash
curl https://api.solosync.live/health
curl https://api.solosync.live/ready
```

Then open:

```text
https://app.solosync.live
```

## First WhatsApp connection

1. Create a SoloSync account.
2. In local development billing can remain disabled.
3. In production, enable Razorpay before charging customers.
4. Open **WhatsApp**.
5. Start the connection.
6. If the session is `FAILED`, the dashboard now shows the failure returned by WAHA and provides a retry path.
7. Scan the QR from WhatsApp Linked Devices.
8. Wait for `WORKING`.

WAHA's documentation confirms that sessions can be stopped, restarted and queried through its session API, and that session data should be persisted. citeturn3search0turn3search5

## Memory expectations

WAHA's current Docker guide specifies at least 2 CPU and 2 GB RAM. For SoloSync, 4 GB RAM / 2 vCPU gives practical headroom for Node.js, Nginx/Caddy and a WhatsApp browser session. citeturn1search4

Do not run MongoDB and Redis on the same 4 GB VPS if managed 256 MB services are already available.

## Scaling later

When the first VPS becomes constrained:

1. Move WAHA to its own 4 GB+ VPS.
2. Keep the API/worker on a separate 2 GB+ VPS.
3. Keep MongoDB and Redis managed.
4. Put Caddy/Cloudflare in front.
5. Add more WAHA workers only when session count justifies it.

The current WAHA setup already uses a persistent `waha_sessions` volume so WhatsApp authentication state survives container recreation.

## Cost target

Initial architecture:

| Component | Initial choice |
|---|---|
| Homepage | Same VPS |
| Dashboard | Same VPS |
| API | Same VPS |
| WAHA | Same VPS |
| MongoDB | Existing 256 MB managed |
| Redis | Existing 256 MB managed |
| TLS | Caddy |
| Domain | Existing |
| VPS | DigitalOcean Bangalore, 4 GB / 2 vCPU |
| Approx. VPS price | $24/month before taxes/credits |

DigitalOcean currently lists the 4 GiB / 2 vCPU Basic Droplet at $24/month and offers Bangalore as a datacenter. citeturn0search4

Railway is attractive for simple Node deployments, but its current pricing bills RAM, CPU, storage and egress separately. A continuously running 2-vCPU/2-GB WAHA service can therefore become substantially more expensive than a fixed VPS. Railway Hobby starts at $5/month but includes only $5 of resource usage credit; resource rates are currently $10/GB-month RAM and $20/vCPU-month CPU. citeturn2search0turn2search10

## Important operational rule

Never run WAHA without persistent storage. Never expose WAHA's dashboard/API directly to the public internet. Keep it on the Docker network and expose only SoloSync's API. WAHA's own Docker deployment guide recommends keeping the container private and putting a reverse proxy in front of exposed services. citeturn1search4
