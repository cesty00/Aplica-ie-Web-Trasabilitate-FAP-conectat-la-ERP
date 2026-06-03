# Sprint 0 — Project Foundation

## Scop

Sprint 0 creează fundația tehnică a proiectului **Aplicație Web Trasabilitate FAP conectată la WinMentor/WME și Axes/xTrack WMS**.

Sprint 0 nu implementează importuri WME/WMS, FAPLot, QA workflow, producție, livrări, rapoarte sau exporturi. Scopul lui este să creeze proiectul pornibil și verificabil local.

## Repository

Repository oficial:

```text
cesty00/Aplica-ie-Web-Trasabilitate-FAP-conectat-la-ERP
```

## Obiective Sprint 0

La finalul Sprint 0 trebuie să existe:

- structură repository;
- backend API pornibil;
- frontend web pornibil;
- PostgreSQL;
- Redis;
- MinIO pentru storage documente;
- Docker Compose;
- `.env.example`;
- TypeScript configurat;
- lint / format;
- Prisma ORM configurat;
- schema DB inițială;
- seed pentru roluri și source systems;
- endpoint de health check;
- Swagger/OpenAPI;
- documentație minimă de rulare locală.

## Stack tehnic Sprint 0

### Frontend

- Next.js
- React
- TypeScript
- Tailwind CSS
- shadcn/ui
- React Hook Form
- Zod
- TanStack Query

### Backend

- NestJS
- TypeScript
- PostgreSQL
- Prisma ORM
- Swagger/OpenAPI
- JWT pregătit pentru Sprint 1
- class-validator
- BullMQ pregătit pentru importuri ulterioare
- Redis

### Infrastructură locală

- Docker Compose
- PostgreSQL 16
- Redis 7
- MinIO

## Structură repository țintă

```text
fap-traceability-app/
├── apps/
│   ├── api/
│   │   ├── src/
│   │   ├── test/
│   │   ├── prisma/
│   │   ├── package.json
│   │   └── Dockerfile
│   └── web/
│       ├── src/
│       ├── public/
│       ├── package.json
│       └── Dockerfile
├── packages/
│   ├── shared/
│   └── types/
├── docs/
│   ├── project/
│   ├── architecture/
│   ├── api/
│   ├── database/
│   ├── imports/
│   ├── qa/
│   └── ai/
├── infra/
│   ├── docker/
│   ├── postgres/
│   └── nginx/
├── scripts/
├── .env.example
├── .gitignore
├── docker-compose.yml
├── package.json
├── pnpm-workspace.yaml
├── README.md
└── CHANGELOG.md
```

## Source systems seed

Sprint 0 trebuie să creeze următoarele surse:

| Cod | Descriere | Tip |
|---|---|---|
| WME | WinMentor / WME fișă magazie | ERP |
| WMS_TRACE | Axes / xTrack WMS trasabilitate | WMS |
| WMS_PRODUCTION | Axes / xTrack WMS raport producție | WMS |
| FAP | Aplicația FAP | FAP |
| AI | ChatGPT API | AI |

## Roluri seed

Sprint 0 trebuie să pregătească următoarele roluri:

- ADMIN
- ACHIZITII_IMPORT
- RECEPTIE_DEPOZIT
- QA_CONFORMITATE
- PRODUCTIE
- LOGISTICA_VANZARI
- MANAGEMENT
- AUDITOR_READONLY

## Health endpoint

Endpoint țintă:

```http
GET /api/health
```

Răspuns așteptat:

```json
{
  "status": "ok",
  "service": "fap-api",
  "database": "ok",
  "redis": "ok",
  "timestamp": "2026-06-03T12:00:00.000Z"
}
```

## Swagger / OpenAPI

Swagger trebuie să fie disponibil la:

```text
/api/docs
```

Sprint 0 documentează minim:

- health endpoint;
- structura de erori standard;
- DTO-uri disponibile.

## Definition of Done

Sprint 0 este finalizat doar dacă:

- repository-ul are structură monorepo;
- `docker compose up -d` pornește PostgreSQL, Redis și MinIO;
- backend-ul pornește local;
- frontend-ul pornește local;
- `.env.example` există;
- Prisma este configurat;
- migrația inițială rulează;
- seed-ul creează rolurile și sursele;
- `/api/health` returnează status `ok`;
- Swagger este disponibil;
- README explică rularea locală;
- nu există secrete reale în repository.

## GitHub Issues Sprint 0

- S0-01 Initialize repository structure
- S0-02 Add Docker Compose for PostgreSQL Redis MinIO
- S0-03 Add backend NestJS skeleton
- S0-04 Add frontend Next.js skeleton
- S0-05 Add Prisma configuration
- S0-06 Add initial database schema
- S0-07 Add seed for roles and source systems
- S0-08 Add health endpoint
- S0-09 Add Swagger/OpenAPI
- S0-10 Add README local setup

## Limită Sprint 0

Nu se implementează încă:

- Import WME;
- Import WMS;
- ProductMapping;
- FAPLot;
- Reconciliere;
- QA workflow complet;
- documente lot;
- producție input-output;
- livrări;
- rapoarte;
- exporturi;
- AI Assistant.
