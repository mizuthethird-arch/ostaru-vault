# F1-a task breakdown: Tenancy and identity core
- Author: JANUS (Backend Lead), for PERICLES (owner of the stories) and ATHENA (CTO). Version 2, 2026-10-22. Status: **tasks 1-2 code delivered in chat, IMPLEMENTED—NOT VERIFIED; the rest not started.**
- Covers stories F1-01 to F1-04 plus the **F1-05 backend** (device pairing), moved into F1-a by the CTO (decision D1).
- Sources: [Cycle 1 plan](../cycles/cycle-01.md), [F1 stories](../stories/f1-foundation.md), [ADR-003](../../03-definition/adr/ADR-003-multi-tenancy.md), [ADR-004](../../03-definition/adr/ADR-004-data-access.md) (Part A rules; Part B = Kysely), [ADR-006](../../03-definition/adr/ADR-006-technology-stack-v2.md) (Express), [CTO Q8 decisions](../../handoffs/2026-10-21-ATHENA-Q8-decisions.md), [CTO decisions of 2026-10-22](../../handoffs/2026-10-22-ATHENA-decisions-cycle-1.md), [platform spec](../../03-definition/platform-p01-p02.md).
- Labels: **[V]** decided, **[E]** estimate, **[A]** assumption. Per Rule 9 agents write code and tests in chat and never run them; the owner runs and commits. Every task stays IMPLEMENTED—NOT VERIFIED until the owner reports the result.
- Per [change discipline](../../../../standards/code/change-discipline-and-testing.md): each task touches only the files it needs and ships with tests.

## Decisions taken (CTO, 2026-10-22)
| # | Decision | Effect on this breakdown |
|---|---|---|
| D1 [V] | Option 1: the F1-05 backend (pairing code, device token, token check) moves into F1-a | Tasks 13-16 added. About +2.5 days [E]; F1-a may spill into week 3 |
| D2 [V] | Staff pick their name from the restaurant's list, then enter the PIN. Limits per person and per device | Tasks 8 and 9 |
| Q3 [V] | The operator command prints a one-time temporary PIN; the Encargado must change it at first sign-in | Task 6 and new task 10 |
| Q4 [V] | An operator command replaces a creation route (JUPITER reviews at G3) | Task 6 |
| R2 [V] | ADR-004 accepted, Kysely | Library-dependent tasks use Kysely |

## Tasks, in build order
| # | Task | Story | Owner | Est. [E] | Done when (tests required) | Depends on | Status |
|---|---|---|---|---|---|---|---|
| 1 | Database roles and bootstrap migration: `agora_owner`, `agora_app` (runtime), `agora_operator`; `app_tenant()` | F1-01 | JANUS | 0.5 d | Test: runtime role is not superuser, not owner, no BYPASSRLS; cannot insert a restaurant; `app_tenant()` is null without context, also on a reused connection | P-01, ADR-004 | **Code in chat** |
| 2 | `restaurants` table with RLS and FORCE | F1-01 | JANUS | 0.5 d | Isolation test: A sees only its row; cannot read, write or delete B's; owner is filtered too | 1 | **Code in chat** |
| 3 | **Guard test** reading the catalog: every table with `restaurant_id` has RLS enabled, forced, a policy, and unique indexes that include `restaurant_id` | F1-01 | JANUS | 1 d | Fails when a deliberately unprotected table is added | 1 | Next |
| 4 | Tenant context: request step that resolves the restaurant from the session and refuses the request when none resolves; pooled-connection and nested-use tests (`withTenant` itself is delivered with task 2) | F1-01 AC1, AC2 | JANUS | 1 d | No leak to the next request on a pool of size 2; no context returns nothing; nested use rejected | 1, 9 | |
| 5 | Two-layer test: a repository whose application filter is removed on purpose still returns nothing of B | F1-01 AC3 | JANUS | 0.5 d | Passes against the real database | 2, 4 | |
| 6 | Restaurant creation command for Ostaru operators (CLI, `agora_operator`): restaurant, first Encargado, demo mode on, **one-time temporary PIN printed once** | F1-02 | JANUS | 1 d | Happy path; no HTTP creation route (test); second restaurant needs no code change; A and B isolated; the PIN is never stored readable or logged | 1, 7, 8 | |
| 7 | `staff` and `roles` tables, permission matrix and `can(role, action)` | F1-03 | JANUS | 1 d | Table-driven test of every role against every permission; isolation test | 2, 4 | |
| 8 | PIN storage and checking: argon2 plus server-side secret, attempt counters **per staff member and per device**, temporary block, inactive staff refused, `must_change_pin` flag, PIN never logged or returned | F1-04 AC2-AC5 | VULCAN, JANUS | 1.5 d | Correct, wrong, blocked, block expiry, inactive; logs never contain a PIN | 7, G3 limits | |
| 9 | Staff list and PIN sign-in: the device lists its restaurant's active staff names, then name + PIN signs in; session scoped to the restaurant; sign-out; Spanish error that does not reveal which part was wrong | F1-04 AC1, AC2 | VULCAN | 1.5 d | Success, failure, expiry, no session refused; device of A never signs into B | 4, 8, 15 | |
| 10 | **Change PIN at first sign-in** (temporary PIN must be replaced before anything else is allowed) | F1-04 (new criterion, PERICLES adds) | VULCAN | 0.5 d | Temporary PIN signs in but every other route is refused until changed; new PIN checked for length rule | 8, 9 | |
| 11 | Permission check as Express middleware calling `can(role, action)` | F1-03 AC1 | VULCAN | 0.5 d | Each role against one allowed and one forbidden route | 7, 9 | |
| 12 | HTTP isolation suite for F1: sign in as A, never see B's staff, devices or restaurant | F1-01 AC1 | JANUS, VULCAN | 1 d | Stories' acceptance test, automated | 9, 11, 16 | |
| 13 | `devices` and `pairing_codes` tables with RLS (only hashes stored) | F1-05 | JANUS | 0.5 d | Isolation test; guard test passes | 3 | |
| 14 | Pairing: Encargado issues a 6-digit code (valid 10 minutes, single use, limited attempts); a new device redeems it | F1-05 AC1 | JANUS | 1 d | Expiry, single use, wrong code, attempt limit, code of A never works for B | 13, 11 | |
| 15 | Device token: random token in an `HttpOnly`, `Secure`, `SameSite=Strict` cookie, hash stored; middleware accepts PIN sign-in only with a valid token of the same restaurant; revoke ends its sessions | F1-05 AC1, AC2 | VULCAN | 1 d | Valid, missing, revoked, other restaurant's token; cookie flags | 14 | |
| 16 | First device: the operator command also issues the first pairing code for the first Encargado | F1-05 / F1-02 | JANUS | 0.5 d | Code printed once; usable once | 6, 14 | |
| 17 | G4 contract for pairing, staff list, sign-in, change PIN, sign-out, current user and restaurant, with errors and examples | G4 | JANUS with ATHENA | 0.75 d | Agreed by the CTO | 9, 14 | |

**Total about 14 person-days [E, low confidence]** (11 before D1, +2.5 for pairing, +0.5 change-PIN). With two people it exceeds the one-week window in the plan; the CTO has accepted that F1-a may spill into week 3. PERICLES re-plans.

## Structure and rules
- **Express (ADR-006).** Modules `tenancy` and `identity` in `apps/api/src/modules/<name>/`; only `index.ts` is public; dependencies are passed through plain factory functions. The shared kernel (`src/shared-kernel/`, including `db/`) imports nothing from `modules/`. zod validates requests, pino logs never hold PINs or tokens.
- **Migrations are central** in `src/shared-kernel/db/migrations/` (Kysely needs one ordered list). Each table belongs to one module by name. **[A] for the CTO to confirm.**
- **Three database roles** (ADR-004 rule 1): `agora_owner` runs migrations, `agora_app` serves requests, `agora_operator` is used only by the operator command. The API never gets the superuser.
- **Database tests need PostgreSQL.** They fail loudly when the connection settings are missing; they never skip silently, because a skipped isolation test looks like a pass. Locally the owner runs them in the Compose workspace; CI needs a Postgres service (change request to PROMETHEUS in the task 1-2 delivery).

## Gates
| Gate | What F1-a needs |
|---|---|
| G1 | Passed by the Owner (2026-10-22) |
| G3 | JUPITER (interim approver) and EUNOMIA: PIN length and lockout, session length, token lifetime, pairing attempts, the operator command, the staff-list endpoint (exposes names before sign-in) |
| G4 | Task 17 |
| G5 | Owner runs tests in CI; changed files match the tasks |
| G6 | MINOS: isolation suite, PIN, pairing |

## Open items
| # | Item | Owner |
|---|---|---|
| Q7 | PIN length, wrong attempts before a block, block duration, session length, token lifetime [A: 180 days], pairing attempts | JUPITER, EUNOMIA |
| Q5 | Central migrations folder (above) | ATHENA |
| Q6 | The CI and Compose changes for database tests (task 1-2 delivery) | PROMETHEUS |
| R1 | Capacity: about 14 person-days; spill into week 3 | PERICLES |
| R3 | A forgotten RLS table in a later feature: mitigated by task 3 | JANUS |
