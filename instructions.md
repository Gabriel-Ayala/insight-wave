## Key Architecture Decisions to Reduce Risk

# 1. Synchronous Communication Only (Avoid Event Bus)

Why: Event-driven architectures (e.g., Kafka) add complexity and failure modes.

How:

ETL → Query Service: Use direct HTTP calls to update aggregations after insertion.

Realtime Service: Listen to PostgreSQL NOTIFY instead of a message broker.

# 2. Shared PostgreSQL Database (Temporary)
Why: Avoid distributed transactions and eventual consistency headaches.

How:

All services read/write to the same DB initially.

Phase 2: Split into service-owned databases once MVP validates.

# 3. Pre-Baked Service Templates
Why: Reduce human error and speed up development.

How:

Create reusable templates for:

Auth: Preconfigured Passport.js + JWT middleware.

Node.js: Standardized Express + Drizzle setup.

Python: Base ETL script with retry logic.

---

## Risk Mitigation Tactics
# 1. Service Contracts
Define and freeze OpenAPI specs for HTTP endpoints (Query/Auth services).

Use TypeScript interfaces for WebSocket message formats (Realtime Service).

# 2. Deployment Safety
Dockerize Everything: Identical environments for dev/prod.

Rolling Updates: Deploy one service at a time (e.g., update Query Service before Realtime).

# 3. Fault Tolerance
Circuit Breakers: Use @nestjs/axios or resilient-http for HTTP calls between services.

Graceful Degradation:

If Realtime Service fails, Query Service serves cached historical data.

If Auth Service fails, return 503 (vs. cascading failures).

--------

## Security Hardening (Non-Negotiable)
Service-to-Service Auth:

Use short-lived JWTs with service-specific claims.

Auth Service acts as the central OAuth2 provider.

Network Isolation:

Place Auth Service and PostgreSQL in a private subnet (no public internet access).

Audit Logging:

Log all ETL data mutations and RBAC changes.


---

## Deployment Steps
Local Development:

Use docker-compose to spin up all services + PostgreSQL.

Staging:

Deploy to a single VM (e.g., AWS EC2) with Docker.

Use nginx as a reverse proxy + Let’s Encrypt SSL.

Production:

Start with 2 replicas for Query/Realtime services (manual scaling).

Use managed PostgreSQL (e.g., AWS RDS) with daily backups.