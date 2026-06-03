# Sprint 1 — Auth, Roluri și Audit de Bază

## Scop

Sprint 1 creează sistemul minim de acces, control și audit pentru aplicația FAP.

La finalul Sprint 1 trebuie să existe utilizatori, roluri, autentificare, protecție de rute și audit pentru acțiuni importante.

## Obiective Sprint 1

La finalul Sprint 1 trebuie să existe:

- login;
- logout;
- refresh token;
- utilizatori;
- roluri;
- atribuiri roluri;
- protecție rute backend;
- protecție rute frontend;
- audit pentru acțiuni importante;
- ecran utilizatori;
- ecran roluri read-only;
- ecran audit read-only;
- dashboard placeholder.

## Roluri MVP

- ADMIN
- ACHIZITII_IMPORT
- RECEPTIE_DEPOZIT
- QA_CONFORMITATE
- PRODUCTIE
- LOGISTICA_VANZARI
- MANAGEMENT
- AUDITOR_READONLY

## User stories

## US-1.1 — Login

Ca utilizator, vreau să mă autentific cu email și parolă, ca să pot accesa aplicația.

Endpoint:

```http
POST /api/auth/login
```

Request:

```json
{
  "email": "admin@local.test",
  "password": "password"
}
```

Response:

```json
{
  "accessToken": "...",
  "refreshToken": "...",
  "user": {
    "id": "...",
    "email": "admin@local.test",
    "fullName": "Administrator",
    "roles": ["ADMIN"]
  }
}
```

Criterii de acceptanță:

- emailul este obligatoriu;
- parola este obligatorie;
- parola greșită returnează 401;
- utilizatorul inactiv nu se poate loga;
- loginul reușit este auditat;
- loginul eșuat este auditat fără a expune parola.

## US-1.2 — Refresh token

Endpoint:

```http
POST /api/auth/refresh
```

Criterii de acceptanță:

- primește refresh token valid;
- returnează access token nou;
- refresh token invalid returnează 401;
- refresh-ul poate fi auditat.

## US-1.3 — Logout

Endpoint:

```http
POST /api/auth/logout
```

Criterii de acceptanță:

- utilizatorul se poate deloga;
- evenimentul este auditat;
- tokenul este eliminat client-side;
- dacă se implementează token store, tokenul este invalidat server-side.

## US-1.4 — Creare utilizator

Ca Admin, vreau să creez utilizatori, ca fiecare departament să aibă acces controlat.

Endpoint:

```http
POST /api/users
```

Request:

```json
{
  "email": "qa@company.test",
  "fullName": "Responsabil QA",
  "password": "temporary-password",
  "roles": ["QA_CONFORMITATE"]
}
```

Criterii de acceptanță:

- doar ADMIN poate crea utilizatori;
- emailul trebuie să fie unic;
- parola este hash-uită;
- cel puțin un rol este obligatoriu;
- crearea este auditată;
- parola nu este returnată în răspuns.

## US-1.5 — Listare utilizatori

Endpoint:

```http
GET /api/users
```

Criterii de acceptanță:

- ADMIN vede toți utilizatorii;
- AUDITOR_READONLY poate vedea read-only, dacă se activează această permisiune;
- parola/hash-ul nu este returnat niciodată;
- se poate filtra după status;
- se poate filtra după rol.

## US-1.6 — Dezactivare utilizator

Endpoint:

```http
PATCH /api/users/:id/status
```

Request:

```json
{
  "status": "inactive",
  "reason": "Utilizator dezactivat administrativ"
}
```

Criterii de acceptanță:

- doar ADMIN poate dezactiva;
- motivul este obligatoriu;
- utilizatorul inactiv nu se mai poate autentifica;
- schimbarea este auditată.

## US-1.7 — Roluri

Endpoint:

```http
GET /api/roles
```

Criterii de acceptanță:

- returnează rolurile standard;
- rolurile sunt seed-uite;
- rolurile nu se șterg în MVP;
- doar ADMIN poate modifica atribuirea rolurilor;
- modificarea rolurilor este auditată.

## US-1.8 — Audit log read-only

Endpoint:

```http
GET /api/audit
```

Criterii de acceptanță:

- ADMIN, QA_CONFORMITATE, MANAGEMENT și AUDITOR_READONLY pot consulta auditul;
- auditul este read-only;
- se poate filtra după entitate;
- se poate filtra după utilizator;
- se poate filtra după perioadă;
- se poate filtra după sursă: manual, import, system, api, ai.

## Matrice acces Sprint 1

| Funcție | Admin | QA | Achiziții | Recepție | Producție | Logistică | Management | Auditor |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Login | Da | Da | Da | Da | Da | Da | Da | Da |
| Creare utilizator | Da | Nu | Nu | Nu | Nu | Nu | Nu | Nu |
| Listare utilizatori | Da | Nu | Nu | Nu | Nu | Nu | Opțional | Read-only |
| Dezactivare utilizator | Da | Nu | Nu | Nu | Nu | Nu | Nu | Nu |
| Listare roluri | Da | Da | Da | Da | Da | Da | Da | Da |
| Atribuire roluri | Da | Nu | Nu | Nu | Nu | Nu | Nu | Nu |
| Vizualizare audit | Da | Da | Nu | Nu | Nu | Nu | Da | Da |
| Modificare audit | Nu | Nu | Nu | Nu | Nu | Nu | Nu | Nu |

## Audit service

Tip intern:

```ts
export type AuditInput = {
  entityType: string;
  entityId: string;
  fieldName?: string;
  oldValue?: string | null;
  newValue?: string | null;
  changedBy?: string;
  changeReason?: string;
  changeSource: 'manual' | 'import' | 'system' | 'api' | 'ai';
  metadata?: Record<string, unknown>;
};
```

Evenimente auditate în Sprint 1:

- USER_LOGIN_SUCCESS
- USER_LOGIN_FAILED
- USER_CREATED
- USER_STATUS_CHANGED
- USER_ROLE_ASSIGNED
- USER_ROLE_REMOVED
- USER_LOGOUT
- TOKEN_REFRESHED

Reguli:

- nu se loghează parole;
- nu se loghează refresh token complet;
- nu se permit update/delete pe audit log;
- auditul trebuie să poată fi legat de utilizator, dacă există.

## Frontend Sprint 1

Pagini:

- `/login`
- `/dashboard`
- `/admin/users`
- `/admin/users/new`
- `/admin/roles`
- `/audit`

Layout:

- sidebar;
- topbar;
- user menu;
- logout button;
- role-aware navigation;
- protected routes.

Dashboard placeholder:

- nume utilizator;
- roluri utilizator;
- status API;
- status bază de date;
- module viitoare: Importuri, Loturi FAP, QA, Producție, Livrări, Rapoarte, Exporturi, Audit.

## Convenții de cod

Backend:

- controllerul nu conține logică business;
- logica este în service;
- DTO pentru fiecare request;
- validare cu `class-validator`;
- guards pentru roluri;
- filtre globale pentru erori;
- răspunsuri de eroare standardizate;
- Swagger decorators pe endpoint-uri.

Frontend:

- formulare validate cu Zod;
- API client centralizat;
- componente UI reutilizabile;
- protecție rute;
- navigație în funcție de rol;
- nu se stochează secrete în frontend.

## Teste Sprint 1

Backend tests:

- login success;
- login invalid password;
- login inactive user;
- create user as admin;
- create user as non-admin denied;
- list users as admin;
- deactivate user;
- list roles;
- audit created on login;
- audit created on user creation.

Frontend smoke tests:

- pagina login se afișează;
- utilizatorul se poate loga;
- dashboardul se afișează după login;
- meniul afișează rolurile;
- logout funcționează;
- ruta `/admin/users` este protejată.

## Definition of Done

Sprint 1 este finalizat doar dacă:

- login funcționează;
- refresh token funcționează;
- logout funcționează;
- admin poate crea utilizatori;
- admin poate dezactiva utilizatori;
- rolurile sunt seed-uite;
- utilizatorii au roluri;
- rutele backend sunt protejate;
- rutele frontend sunt protejate;
- auditul înregistrează evenimentele definite;
- pagina audit este read-only;
- Swagger documentează endpoint-urile;
- testele minime rulează;
- nu există parole/secrete reale în commit;
- README este actualizat cu pașii de rulare.

## GitHub Issues Sprint 1

- S1-01 Implement User Role models
- S1-02 Implement Auth login
- S1-03 Implement refresh token
- S1-04 Implement logout
- S1-05 Implement users CRUD minimal
- S1-06 Implement role listing and assignment
- S1-07 Implement RBAC guards
- S1-08 Implement audit service
- S1-09 Implement audit read-only endpoint
- S1-10 Implement frontend login page
- S1-11 Implement dashboard placeholder
- S1-12 Implement admin users page
- S1-13 Implement audit page
- S1-14 Add Sprint 1 tests

## Limită Sprint 1

Nu se implementează încă:

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
