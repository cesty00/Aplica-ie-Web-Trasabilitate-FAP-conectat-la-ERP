# Sprint 0 Status Report

## Status

Sprint 0 este in progres avansat.

## Implementat

- README extins
- CHANGELOG
- gitignore
- pnpm workspace
- package root
- Docker Compose
- API skeleton NestJS
- Web skeleton Next.js
- Prisma schema initiala
- Prisma migration initiala
- Prisma seed initial
- Health endpoint
- Swagger setup
- GitHub Actions CI
- QA checklist

## Confirmat

- GitHub Actions build: trecut.

## De confirmat inainte de Sprint 1

- pnpm install ruleaza local
- pnpm docker:up ruleaza local
- pnpm db:generate ruleaza local
- pnpm db:migrate ruleaza local
- pnpm db:seed ruleaza local
- pnpm dev:api porneste API
- pnpm dev:web porneste Web
- /api/health raspunde
- /api/docs este disponibil

## Observatii

- Migrarea initiala trebuie verificata local.
- Daca Prisma regenereaza migrarea, versiunea locala generata are prioritate.
- Tailwind este temporar dezactivat din CSS pentru build stabil.

## In afara scope Sprint 0

Nu sunt implementate import WME, import WMS, FAPLot, QA workflow, productie, livrari, rapoarte, exporturi sau AI Assistant.
