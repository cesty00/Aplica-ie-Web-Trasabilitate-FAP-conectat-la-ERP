# Sprint 0 Local Validation Guide

## Scop

Acest ghid valideaza local fundatia tehnica Sprint 0.

Nu valideaza importuri WME, importuri WMS, FAPLot, QA workflow, productie, livrari, rapoarte, exporturi sau AI Assistant.

## Cerinte

- Node.js 20 sau mai nou
- pnpm 9 sau mai nou
- Docker Desktop sau Docker Engine

## Pas 1 - instalare dependinte

```bash
pnpm install
```

Rezultat asteptat:

- dependintele se instaleaza fara erori.

## Pas 2 - pornire infrastructura locala

```bash
pnpm docker:up
```

Rezultat asteptat:

- PostgreSQL ruleaza pe portul 5432;
- Redis ruleaza pe portul 6379;
- MinIO ruleaza pe porturile 9000 si 9001.

## Pas 3 - Prisma generate

```bash
pnpm db:generate
```

Rezultat asteptat:

- Prisma Client se genereaza fara erori.

## Pas 4 - Prisma migrate

```bash
pnpm db:migrate
```

Rezultat asteptat:

- migratia initiala ruleaza;
- tabelele User, Role, UserRole, SourceSystem si AuditLog sunt create.

## Pas 5 - Prisma seed

```bash
pnpm db:seed
```

Rezultat asteptat:

- rolurile MVP sunt create;
- sursele WME, WMS_TRACE, WMS_PRODUCTION, FAP si AI sunt create.

## Pas 6 - build API

```bash
pnpm --filter api build
```

Rezultat asteptat:

- build-ul API trece fara erori TypeScript.

## Pas 7 - build Web

```bash
pnpm --filter web build
```

Rezultat asteptat:

- build-ul Web trece fara erori Next.js.

## Pas 8 - rulare API

```bash
pnpm dev:api
```

Verificari:

- http://localhost:3001/api/health
- http://localhost:3001/api/docs

## Pas 9 - rulare Web

```bash
pnpm dev:web
```

Verificari:

- http://localhost:3000
- http://localhost:3000/login
- http://localhost:3000/dashboard
- http://localhost:3000/admin/users
- http://localhost:3000/admin/roles
- http://localhost:3000/audit

## Criteriu de trecere Sprint 0

Sprint 0 poate fi marcat ca validat local doar daca toti pasii de mai sus trec.

## No-Go

Nu se intra in Sprint 1 daca:

- migratia nu ruleaza;
- seed-ul nu ruleaza;
- API build esueaza;
- Web build esueaza;
- health endpoint nu raspunde;
- Swagger nu este disponibil.
