# Aplicație Web Trasabilitate FAP conectată la ERP

Repository oficial pentru dezvoltarea aplicației web de trasabilitate FAP conectată la WinMentor/WME și Axes/xTrack WMS.

## Scop

Aplicația FAP va funcționa ca strat separat de conformitate, trasabilitate, QA, audit și exporturi peste sistemele existente:

- **WinMentor / WME** — sursă scriptică și comercială: articole, furnizori, clienți, recepții, facturi, avize, fișă de magazie, stoc scriptic.
- **Axes / xTrack WMS** — sursă fizică și operațională pe loturi: loturi fizice, locații, mișcări, picking, dispatch, raport producție.
- **Aplicația FAP** — strat separat pentru conformitate, documente pe lot, QA, audit, trasabilitate, recall și exporturi.

Aplicația nu înlocuiește WinMentor și nu înlocuiește xTrack WMS.

## Status proiect

Faza curentă: **Sprint 0 — inițializare proiect**.

Obiectiv Sprint 0: creare fundație tehnică minimă pentru dezvoltare controlată.

## Roluri de lucru

Asistentul ChatGPT va acționa ca echipă integrată de dezvoltare software:

- **Project Manager** — scope, planificare, livrabile, riscuri, Definition of Done.
- **Arhitect Software** — arhitectură, model de date, integrări WinMentor/WMS.
- **Lead Developer** — implementare modulară, structură repo, backend, frontend, API.
- **QA Engineer** — testare, securitate, criterii de acceptanță, Go/No-Go.
- **UI/UX Designer** — fluxuri utilizator, navigație, ecrane operaționale.

## Principiu de bază

WinMentor/WME și Axes/xTrack WMS nu se suprascriu unul pe altul.

Aplicația FAP trebuie să păstreze separat:

- cantitatea scriptică din WinMentor/WME;
- cantitatea fizică din Axes/xTrack WMS;
- diferențele WME/WMS;
- sursa fiecărei date;
- deciziile QA;
- audit log-ul modificărilor.

## Obiectiv MVP

MVP-ul este acceptat doar dacă demonstrează pe loturi reale:

1. Import WME.
2. Import WMS trasabilitate.
3. Import WMS raport producție.
4. Mapare produse WME ↔ WMS.
5. Creare FAPLot.
6. Reconciliere WME ↔ WMS.
7. Completare origine / captură / acvacultură.
8. Atașare documente pe lot.
9. Validare sau blocare QA.
10. Producție input-output.
11. Lot finit.
12. Livrare către client.
13. Raport trasabilitate înapoi.
14. Raport trasabilitate înainte.
15. Simulare recall.
16. Export Excel/CSV arhivat.
17. Audit log.

## Reguli GitHub

- `main` trebuie să rămână branch stabil.
- După bootstrap-ul inițial, nu se lucrează direct pe `main`.
- Dezvoltarea se face prin branch-uri și Pull Request-uri.
- Fiecare PR trebuie să aibă scope clar, checklist și pași de testare.
- Nu marcăm un sprint ca finalizat fără commit-uri, verificări și dovadă de rulare/testare.

## Sprint 0 — livrabile urmărite

- structură repository;
- backend API pornibil;
- frontend web pornibil;
- PostgreSQL;
- Redis;
- Docker Compose;
- `.env.example`;
- TypeScript config;
- lint / format;
- Prisma schema inițială;
- seed pentru roluri și source systems;
- health endpoint;
- Swagger/OpenAPI;
- documentație inițială.

## Sprint 1 — livrabile urmărite

- login/logout;
- refresh token;
- utilizatori;
- roluri;
- atribuiri roluri;
- protecție rute backend;
- protecție rute frontend;
- audit pentru evenimente importante;
- ecran utilizatori;
- ecran roluri;
- ecran audit read-only;
- dashboard placeholder.

## Stack tehnic propus

Frontend:

- Next.js;
- React;
- TypeScript;
- Tailwind CSS;
- shadcn/ui;
- React Hook Form;
- Zod;
- TanStack Query.

Backend:

- NestJS;
- TypeScript;
- PostgreSQL;
- Prisma ORM;
- Swagger/OpenAPI;
- JWT;
- class-validator;
- BullMQ;
- Redis.

Infrastructură locală:

- Docker Compose;
- PostgreSQL 16;
- Redis 7;
- MinIO pentru storage documente.

## Limită curentă

În Sprint 0 și Sprint 1 nu implementăm încă:

- Import WME;
- Import WMS;
- ProductMapping;
- FAPLot;
- Reconciliere completă;
- QA workflow complet;
- documente lot;
- producție input-output;
- livrări;
- rapoarte;
- exporturi;
- AI Assistant.

Aceste module încep după ce fundația tehnică și accesul utilizatorilor sunt stabile.
