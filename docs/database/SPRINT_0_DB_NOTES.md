# Sprint 0 Database Notes

## Status

Schema Prisma initiala a fost adaugata pentru:

- User
- Role
- UserRole
- SourceSystem
- AuditLog

Migrarea initiala SQL a fost adaugata.

## Corectii aplicate

- Migrarea initiala include extensia pgcrypto.
- Coloanele UUID au default gen_random_uuid().
- Seed-ul are handling explicit de eroare.

## De verificat local

Inainte de marcarea Sprint 0 ca finalizat, rularea locala trebuie sa confirme:

- pnpm db:generate
- pnpm db:migrate
- pnpm db:seed

## Regula

Nu se continua catre Sprint 1 complet pana cand migrarea si seed-ul nu ruleaza local fara erori.
