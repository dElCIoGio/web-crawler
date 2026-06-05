# Web Crawler

Microservice-based web crawler built as a learning and architecture project. The goal is to split crawling into small services that can be owned, tested, deployed, and scaled independently instead of building one large crawler process.

> Status: active development. Phase 1 focuses on the crawler service, API contracts, generated clients, and service orchestration.

## What This Project Demonstrates

- Service boundaries for a crawler pipeline
- OpenAPI-first service contracts
- Python and Go services in the same system
- Generated clients for cross-service communication
- Dockerized local development
- A React/Vite frontend for observing and controlling crawler workflows

## Planned Crawler Pipeline

The system is being built around these responsibilities:

| Component | Responsibility |
| --- | --- |
| Frontend | Operator UI for starting crawls and viewing crawler state |
| Crawler service | HTTP API for crawler health and crawler-specific operations |
| Saga service | Orchestration layer for multi-step crawl workflows |
| Scheduler | Schedules crawl jobs and recurring crawl runs |
| URL frontier | Queue of URLs waiting to be fetched |
| Fetcher | Downloads pages and handles request-level failures |
| Parser | Extracts links, metadata, and useful page content |

## Repository Layout

```text
.
|-- apps/
|   `-- frontend/              # React + Vite operator UI
|-- contracts/
|   `-- openapi/               # Service OpenAPI definitions
|-- infrastructure/            # Deployment and runtime support
|-- packages/
|   `-- clients/               # Generated API clients
|-- services/
|   |-- crawler-service/       # Python/FastAPI crawler API
|   `-- saga-service/          # Go orchestration service
|-- Makefile                   # Local workflow helpers
`-- openapitools.json          # OpenAPI generator configuration
```

## Tech Stack

- Frontend: React, TypeScript, Vite, Tailwind CSS
- Backend: Python 3.12, FastAPI, Uvicorn
- Orchestration: Go
- Contracts: OpenAPI 3
- Tooling: Docker, Docker Compose, OpenAPI Generator

## Local Development

Generate service clients and start the local stack:

```bash
make run
```

Useful commands:

```bash
make openapi-generate
make build
make up
make down
```

Run the frontend directly:

```bash
cd apps/frontend
npm install
npm run dev
```

Run the crawler service directly:

```bash
cd services/crawler-service
pip install -r requirements.txt
uvicorn main:app --reload
```

## API Contracts

The crawler service contract lives at:

```text
contracts/openapi/crawler.yaml
```

Generated clients are written to:

```text
packages/clients/python/
packages/clients/go/
```

## Current Focus

- Expand crawler operations beyond health checks
- Add URL frontier, fetcher, parser, and scheduler services
- Wire saga orchestration across the crawler pipeline
- Persist crawl jobs, page state, and extracted links
- Add tests around service contracts and workflow boundaries

## Why I Built This

I wanted a project that makes distributed-system tradeoffs visible: contracts, queues, orchestration, retry boundaries, and observability. A crawler is a good domain for that because even a small implementation quickly needs scheduling, deduplication, failure handling, parsing, and coordination between services.
