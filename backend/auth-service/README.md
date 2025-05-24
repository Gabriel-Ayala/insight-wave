# Overview


```bash
auth-service/
├── src/
│   ├── config/         # Environment variables, RBAC roles (admin/viewer)
│   ├── controllers/    # Login, signup, token refresh
│   ├── middlewares/    # JWT validation, requireRole("admin")
│   ├── models/         # Drizzle ORM user schema
│   └── routes/         # /auth/login, /auth/signup
├── test/               # Supertest + Jest tests for auth flows
├── Dockerfile          # Multi-stage build with npm ci
└── README.md           # Quickstart, RBAC setup guide
```

---

## Purpose:

Centralized authentication, authorization (RBAC), and JWT token management for Insight-Wave.
Scope:

- User registration/login
- Token generation/refresh
- Role validation for other services (Query, Realtime)

## Core Components

| Component	         | Responsibility                                       | Technology        |
|--------------------|------------------------------------------------------|-------------------|
| REST API	         | Expose auth endpoints                                | Node.js + Express |
| Passport           | Strategies	Local (email/password) + JWT validation	| Passport.js       |
| RBAC               | Module	Validate user roles (admin/viewer)	        | Custom middleware |
| Session Store      | Token blacklist (optional)	                        | PostgreSQL/Redis  |
| Logging & Auditing | Track auth attempts	                                | Winston + Pino    |

---

## Database Schema

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(10) CHECK (role IN ('admin', 'viewer')) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Optional token blacklist for logout
CREATE TABLE revoked_tokens (
  jti UUID PRIMARY KEY,
  revoked_at TIMESTAMP DEFAULT NOW()
);
```

---
## API Endpoints

| Endpoint	       | Method |	Description	Request Body                              |
|------------------|--------|---------------------------------------------------------|
| `/auth/login`	   | POST	| Issue JWT token	{ email, password }                   |
| `/auth/signup`   | POST	| Create new user (admin only)	{ email, password, role } |
| `/auth/refresh`  | POST	| Refresh expired token	{ refreshToken }                  |
| `/auth/validate` | GET	| Validate token + return role	token (query param)       |

---

## Risks & Mitigation
| Risk	          | Mitigation Strategy                                                                   |
|-----------------|---------------------------------------------------------------------------------------|
| Token theft     |	Short expiration (1h) + HTTPS only. Use refresh tokens with stricter expiration (7d). |
| Weak passwords  |	Enforce complexity rules (8+ chars, mix of letters/numbers).                          |
| SQL Injection	  | Use Drizzle ORM (parameterized queries).                                              |
| DoS attacks	  | Rate limiting + AWS Shield/WAF in production.                                         |
| Role escalation |	Validate roles server-side (never trust client).                                      |

---

## Monitoring & Alerts

- Key Metrics:
  - `auth_login_attempts_total` (success/failure)
  - `jwt_tokens_issued`
  - token_validation_errors

- Alerts:
  - Spike in failed login attempts (>20/min)
  - DB connection pool saturation (>90%)

---

## Testing Strategy

### **Test Cases** 

- **Happy Path:** Valid login → `JWT returned`.
- **RBAC Failure:** Viewer tries to access admin-only endpoint → `403`.
- **Token Tampering:** Modified JWT → `401`.
- **Brute-force:** 6th login attempt → `429`.

### **Tools**
- **Integration Tests:** Jest + Supertest.
- **Security Scan:** OWASP ZAP for vulnerabilities.
- **Load Test:** k6 (simulate 100 RPS on /login).

---

## Scaling Considerations

- **Horizontal Scaling:** Deploy multiple Auth Service instances behind a load balancer.
  - **Stateless:** No sticky sessions needed (JWT is self-contained).


- **Blacklist Scaling:** Use Redis instead of PostgreSQL for `revoked_tokens` if revocation frequency increases.

- **Federation:** Add OAuth2 (Google/GitHub) in future via Passport strategies.

---

## API Documentation (OpenAPI Spec)

```yaml

openapi: 3.0.0
paths:
  /auth/login:
    post:
      summary: Authenticate user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                email:
                  type: string
                  format: email
                password:
                  type: string
      responses:
        200:
          content:
            application/json:
              schema:
                type: object
                properties:
                  token:
                    type: string
```

