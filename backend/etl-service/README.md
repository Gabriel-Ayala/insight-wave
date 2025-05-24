etl-service/
├── src/
│   ├── connectors/     # API clients, DB connection pool
│   ├── jobs/           # ETL jobs (e.g., process_logs.py)
│   ├── models/         # Pydantic data validation schemas
│   └── utils/          # Retry logic, logging
├── Dockerfile          # Python 3.11 + asyncpg
└── README.md           # Job scheduling, retry config