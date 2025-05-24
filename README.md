# 📊 Insight-Wave

A full-stack real-time analytics platform designed for ingesting and visualizing live data. Built using a distributed microservices architecture.

---

## 🚀 Tech Stack

| Layer        | Technologies |
|--------------|--------------|
| **Frontend** | React, TypeScript, Tailwind CSS, ShadCN/UI, TanStack Query, WebSockets |
| **Backend**  | Node.js (Express), Passport.js, Helmet       |
| **Data**     | PostgreSQL + JSONB, Drizzle ORM |
| **ETL**      | Python  |

---

## 🔐 Security Features

- 👥 Role-Based Access Control (RBAC)
- 🛡️ Auth via Passport.js + .NET Identity
- 🧠 Secure session store with JWT or Redis
- ✅ HTTPS, Helmet, and CORS hardening

---

## Architecture Breakdown

| Service          | Responsibility                         | Tech               | Risk Mitigation Strategy                                                                         |
|------------------|----------------------------------------|--------------------|--------------------------------------------------------------------------------------------------|
| 1. Auth Service  | User auth, JWT, RBAC                   | Node.js + Passport | - Isolate security logic<br>- Over-test token validation<br>- Predefined roles (admin/viewer)    |
| 2. ETL Service   | Data ingestion, cleaning, DB insertion | Python + asyncpg	 | - Idempotent data processing<br>- Retry queues for failed jobs<br>- Validate inputs aggressively |
| 3. Query Service | REST APIs for historical data          | Node.js + Drizzle	 | - Stored procedures for complex queries<br>- Rate limiting                                       |
| 4. WS Service    | WebSocket server + live updates        | Node.js + ws	 | - Use PostgreSQL NOTIFY (no Kafka)<br>- Backpressure handling<br>- Connection heartbeat checks   |

## Testing Strategy 

| Test Type	    | Scope                      | Tools	| Risk Coverage                              |
|-------------------|----------------------------|--------------|--------------------------------------------|
| Contract Tests    | Verify API/WebSocket specs | Pact/Pactum	| Prevents breaking changes between services |
| Chaos Engineering | Simulate service outages   | Chaos Mesh   | Validates fallback mechanisms              |
| Load Testing	    | ETL + Realtime services	 | k6	        |Ensure PostgreSQL doesn’t bottleneck        |    
