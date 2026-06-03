# Sprint 0 Database Notes

## Status

Schema Prisma initiala a fost adaugata pentru:

- User
- Role
- UserRole
- SourceSystem
- AuditLog

Migrarea initiala SQL a fost adaugata, dar trebuie verificata la rularea locala cu Prisma.

## Nota de corectie

La verificarea manuala s-a observat ca migrarea SQL trebuie aliniata cu defaulturile UUID definite in Prisma schema.

Inainte de marcarea Sprint 0 ca finalizat, rularea locala trebuie sa confirme:

- pnpm db:generate
- pnpm db:migrate
- pnpm db:seed

Daca Prisma regenereaza migrarea, versiunea generata local are prioritate fata de migrarea scrisa manual.

## Regula

Nu se continua catre Sprint 1 complet pana cand migrarea si seed-ul nu ruleaza local fara erori.
