# Sprint 0 QA Checklist

## Scop

Acest checklist valideaza fundatia tehnica Sprint 0 inainte de trecerea la Sprint 1.

Sprint 0 nu valideaza functionalitati de business precum import WME, import WMS, FAPLot, QA workflow, productie, livrari, rapoarte sau exporturi.

## Verificari locale obligatorii

### 1. Instalare dependinte

```bash
pnpm install
```

Criteriu de trecere:

- comanda se finalizeaza fara erori.

### 2. Pornire servicii locale

```bash
pnpm docker:up
```

Criteriu de trecere:

- PostgreSQL porneste local;
- Redis porneste local;
- MinIO porneste local.

### 3. Prisma client

```bash
pnpm db:generate
```

Criteriu de trecere:

- Prisma client se genereaza fara erori.

### 4. Migrare baza de date

```bash
pnpm db:migrate
```

Criteriu de trecere:

- migratia initiala ruleaza fara erori;
- tabelele User, Role, UserRole, SourceSystem si AuditLog exista.

### 5. Seed initial

```bash
pnpm db:seed
```

Criteriu de trecere:

- rolurile MVP sunt create;
- source systems sunt create: WME, WMS_TRACE, WMS_PRODUCTION, FAP, AI.

### 6. Build API

```bash
pnpm --filter api build
```

Criteriu de trecere:

- build-ul API se finalizeaza fara erori TypeScript.

### 7. Build Web

```bash
pnpm --filter web build
```

Criteriu de trecere:

- build-ul Web se finalizeaza fara erori TypeScript/Next.js.

### 8. API local

```bash
pnpm dev:api
```

Verificare:

- API porneste pe portul 3001;
- health endpoint raspunde la /api/health;
- Swagger este disponibil la /api/docs.

### 9. Web local

```bash
pnpm dev:web
```

Verificare:

- frontend porneste pe portul 3000;
- paginile placeholder exista: /login, /dashboard, /admin/users, /admin/roles, /audit.

## Verificare CI

Workflow:

```text
.github/workflows/ci.yml
```

Criteriu de trecere:

- pnpm install ruleaza;
- Prisma client se genereaza;
- API build trece;
- Web build trece.

## Criterii No-Go Sprint 0

Nu trecem la Sprint 1 daca:

- dependintele nu se instaleaza;
- Docker Compose nu porneste serviciile locale;
- Prisma generate esueaza;
- migrarea initiala nu ruleaza;
- seed-ul nu ruleaza;
- API build esueaza;
- Web build esueaza;
- /api/health nu raspunde;
- /api/docs nu este disponibil.

## Observatie

Migrarea initiala trebuie confirmata prin rulare locala. Daca Prisma regenereaza migrarea, versiunea generata local are prioritate fata de migrarea scrisa manual.
