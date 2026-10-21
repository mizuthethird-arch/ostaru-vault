# ADR-002: Technology stack
- Date: 2026-10-21
- Status: **Proposed.** The CTO decides and the CEO approves (team charter, section 6). **Waiting for CEO approval.**
- Owner: CTO

## Context
We need a stack that supports ADR-001 (modules with strict boundaries), a real-time console, a component-based UI in the approved design line, unit tests everywhere (Rule 4), a later public web app, and Docker deployment. The team is AI agents plus the CEO, so popular, well-documented tools matter.

## Options considered
1. **TypeScript end to end:** a NestJS backend, PostgreSQL, and a React front end.
2. Python: Django with HTMX or React. Strong admin features, but a weaker fit for the real-time console and shared types.
3. Next.js full stack: one framework, but it mixes UI and backend and blurs the module boundaries the CEO asked for.
4. PHP Laravel: mature, but no shared types with the front end.

## Decision (proposed)
Option 1:

| Layer | Choice | Why |
|---|---|---|
| Language | TypeScript (strict) everywhere | Shared types between the API and the UI; one language for all agents |
| Backend | **NestJS** | Its modules and dependency injection map directly to ADR-001's business modules and make extraction easier |
| Database | **PostgreSQL**, with row-level security for tenants (ADR-003) | Relational data, reporting, mature isolation features |
| Data access | A typed query builder or ORM that works with row-level security (Drizzle or Kysely, settled in a Cycle 1 spike) | Prisma is avoided only if the spike shows that row-level security is awkward |
| Real time | WebSockets through NestJS gateways | Live console updates and reconnects |
| Front end | **React with Vite**, TanStack Query and React Router | Simple single-page dashboard; components built on atomic design |
| UI components | An in-house `ui` package (atoms → organisms) with **design tokens** from the approved design line, documented in Storybook | Enforces the design line and atomization |
| Tests | **Vitest** for unit tests (API and UI), React Testing Library for components, Supertest for API integration tests, Playwright for end-to-end before release | Rule 4: unit tests always |
| Repository | One monorepo with pnpm workspaces: `apps/api`, `apps/dashboard`, `packages/ui`, `packages/shared` | One deployable per audience; shared types |
| Run and deploy | Docker and Docker Compose for local development; one container image per app; CI on every change | PROMETHEUS's platform standards |

Exact versions are fixed when the repository is created, using current stable releases.

## Consequences
- Easier: one language, typed contracts between modules and the UI, components reusable for the later public app, and a clear path to split a NestJS module into its own service.
- Harder: NestJS conventions are verbose for small modules, and the right data-access tool must be settled early (the Cycle 1 spike).
