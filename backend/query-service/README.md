query-service/
├── src/
│   ├── api/            # OpenAPI spec, Swagger UI
│   ├── controllers/    # GET /analytics?start=2024-01-01
│   ├── db/             # Drizzle queries (e.g., getEventsByDate)
│   └── middlewares/    # Rate limiting, JWT validation
├── test/               # Postman/k6 load tests
├── Dockerfile
└── README.md