# Cycle 1 — Bar Praza

> **CTO DRAFT, handed over (AGENT-RULES section 10).** The CTO drafted this before Rules 6 and 7. It now belongs to **PERICLES (Product Manager), with the Leads breaking it into tasks**, who accepts, rewrites or discards it. Handoff prompts: [to SOLON](../../handoffs/2026-10-21-ATHENA-to-SOLON.md) and [to PERICLES](../../handoffs/2026-10-21-ATHENA-to-PERICLES.md).
- Dates: starts once the CEO approves ADR-002 and ADR-003; two weeks
- Planned by: CTO, with the PM (PERICLES)
- Goal: **a running, tested skeleton.** The monorepo and CI, tenant-safe sign-in, the admin shell in the design line, and the first slice of the menu (Carta y productos) that can be clicked through in demo mode.

> WIP limit: at most 2 features in progress per squad. All code follows the [modular monolith](../../../../standards/architecture/modular-monolith.md) and [focused changes, always tested](../../../../standards/code/change-discipline-and-testing.md) standards, and is delivered in chat until the CEO approves direct codebase work.

## Items

| Item | Owner | Acceptance | Tests required | Status |
|---|---|---|---|---|
| P-01 Monorepo, Docker Compose, CI | PROMETHEUS | `docker compose up` starts the API, dashboard and database; CI runs lint and all tests on every change | CI pipeline green on a sample test | NOT STARTED |
| P-02 Architecture test | PROMETHEUS, JANUS | The build fails when one module imports another's internals | A test proving that a forbidden import fails | NOT STARTED |
| Spike: data access with row-level security | JANUS | Choose Drizzle or Kysely; record the result as ADR-004 | Spike tests showing that row-level security blocks a cross-restaurant read | NOT STARTED |
| F1-a Tenancy and identity core | JANUS, VULCAN | Restaurants, staff, roles, PIN sign-in, tenant context, row-level security | Unit tests for permissions and PINs; **isolation tests** (restaurant A never sees restaurant B) | NOT STARTED |
| UI-01 / UI-02 Tokens, atoms, admin shell | CTO (interim) | Matches design line rules 1–9; Storybook shows every atom | Component unit tests (render, states, accessibility basics) | NOT STARTED |
| F2 (slice) Categories and products with variants and allergens | JANUS, VULCAN, CTO | List and side-panel editor as in the design; save and archive | Unit tests for validation (prices, variants, the 14 allergens); API integration tests | NOT STARTED |

## Written standups
| Date | Squad | Done | Doing | Blocked |
|---|---|---|---|---|
| | | | | |

## Demo (end of cycle)
- Sign in with a PIN, see the admin shell, and create and edit products with variants and allergens in demo mode.

## Retro
- Keep / change / stop: recorded at the end of the cycle; learning goes to each agent's `agents/<name>/` folder (AGENT-RULES section 8).
