# ADR-006: Technology stack (v2, supersedes ADR-002)
- Date: 2026-10-21
- Status: **Accepted** (CEO, 2026-10-21: chose the stack and PostgreSQL). Supersedes [ADR-002](ADR-002-technology-stack.md).
- Owner: CTO
- Labels: **[V]** decided by the CEO, **[P]** CTO proposal inside the CEO's choice, **[O]** open.

## Context
The CEO proposed React, TypeScript, Tailwind, Node.js, Express, Docker, Docker Compose, GitHub CI/CD, npm and SQLite. The CTO advised against SQLite: no row-level security (risk K-1), one writer at a time ([SQLite: appropriate uses](https://www.sqlite.org/whentouse.html)), and a harder move to larger scale (Rule 3). The CEO chose **PostgreSQL** and approved the rest.

## Decision

| Layer | Choice | |
|---|---|---|
| Language | TypeScript, strict, everywhere | [V] |
| Frontend | React with Vite; TanStack Query; React Router | React [V]; the rest [P] |
| Styling | Tailwind CSS; the design line's colours, fonts and spacing are the Tailwind theme | [V] |
| UI components | `packages/ui` (atoms to organisms), documented in Storybook | [P] |
| Installable app | PWA (`vite-plugin-pwa`) for the console tablet and staff phones | [P] |
| Backend | Node.js (current LTS) with Express | [V] |
| Validation | zod, in one place per request | [P] |
| Database | PostgreSQL with row-level security ([ADR-003](ADR-003-multi-tenancy.md), unchanged) | [V] |
| Data access | Drizzle or Kysely, settled in [ADR-004](ADR-004-data-access.md) Part B | [O] |
| Real time | Socket.IO (automatic reconnect, polling fallback) | [P] |
| PIN hashing | argon2 plus a server-side secret | [P] |
| Files | S3-compatible storage ([ADR-005](ADR-005-file-storage.md)) | [P] |
| Logging | pino, never PINs or tokens | [P] |
| Packages | npm workspaces: `apps/api`, `apps/dashboard`, `packages/ui`, `packages/shared` | [V] |
| Tests | Vitest, React Testing Library, Supertest against a real PostgreSQL container, Playwright | [P] |
| Quality | ESLint, Prettier, `tsc --noEmit` on every change | [P] |
| Module boundaries | dependency-cruiser architecture test (P-02) | [P] |
| Containers | Docker (multi-stage) and Docker Compose: API, dashboard, PostgreSQL, MinIO | [V] |
| CI/CD | GitHub Actions: lint, tests, build, images to GitHub Container Registry | [V] |
| Hosting | **Hostinger, much later.** Until then only local Docker Compose. PROMETHEUS researches the exact product (Docker support, EU region, backups, cost) online before any decision. | [V] provider; product [O] |

## Express and the module rule (Rule 3)
Express has no module system, so the rule is ours:
- Code lives in `apps/api/src/modules/<name>/`. Only `index.ts` is public. Other modules import that file and nothing else.
- A module never reads another module's tables. It calls the other module's interface.
- P-02 fails the build on a forbidden import. This is the only enforcement, so it is mandatory.
- Permission checks are Express middleware that call the single `can(role, action)` function from `identity`.

## Rule 9 (no running software)
Agents do not run or test code. The owner runs tests locally or in CI. Library comparisons (for example Drizzle vs Kysely) are done by online research of specifications, maintenance and documentation, not by installing them. Versions are pinned by the owner from official release pages when the repository is created.

## Consequences
- Easier: one language, a stack the CEO already knows, a lighter backend, and the database still enforces separation between restaurants.
- Harder: structure depends on discipline plus one architecture test; Express gives no dependency injection, so modules receive their dependencies through plain factory functions.
- Changed documents: P-01/P-02 spec, F1-a breakdown, threat model T-18 and the real-time item, and the test strategy (see the ATHENA handoffs of 2026-10-21 to PROMETHEUS, JANUS, EUNOMIA, MINOS, PERICLES and SOLON).
- Unchanged: ADR-001, ADR-003, ADR-005, all stories and the scope.
