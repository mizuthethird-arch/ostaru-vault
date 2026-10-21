# ADR-004: Data access and tenant isolation in the database
- Date: 2026-10-21
- Status: **Accepted** by the CTO on 2026-10-22 (Owner bypass, see the [decision log](../../decision-log.md)): Part B = **Kysely**, fallback Drizzle. Part A checks were agent-run before Rule 9; the owner re-runs them. Everything stays IMPLEMENTED—NOT VERIFIED until the owner reports. (Previous status: Part A backed by 24 agent-run checks; Part B recommended by online research.)
- Owner: CTO (drafted by JANUS, Cycle 1 spike; JUPITER reviews the security parts)
- Depends on: [ADR-002](ADR-002-technology-stack.md) and [ADR-003](ADR-003-multi-tenancy.md), [ADR-006](ADR-006-technology-stack-v2.md) replaced ADR-002 (Express instead of NestJS); ADR-003 is accepted. Both approvals came after this spike was run.

## Context
ADR-003 chose one database with `restaurant_id` on every tenant table and PostgreSQL row-level security (RLS). ADR-002 left the data-access library open: Drizzle or Kysely, "settled in a Cycle 1 spike". The spike acceptance is: *tests showing that row-level security blocks a cross-restaurant read* ([Cycle 1](../../04-planning/cycles/cycle-01.md)).

## What the spike did
- **Part A, database side (done).** 24 automated checks against a real PostgreSQL 16.15, connecting as a non-owner application role, with a separate migration-owner role. Script and output: [spikes/adr-004/](../spikes/adr-004/rls-spike.sh) and [result](../spikes/adr-004/rls-spike-result.txt). Result: **24 passed, 0 failed.** Label: *agent-run before Rule 9; owner to re-run* (list below).
- **Rule 9 note (2026-10-21):** the CEO's Rule 9 forbids agents from running or testing code. The Part A checks were run before the rule; treat them as agent-run evidence that the owner should re-run. Part B is now settled **by online research of specifications and maintenance, not by installing the libraries**.
- **Part B, library comparison (not done).** The sandbox could not reach the npm registry (HTTP 403 from the egress policy), on the cloud workspace and on the CEO's machine shell. Drizzle and Kysely were **not installed or tested**. Nothing below claims a library result.

## Evidence (Part A)
| # | Check | Result |
|---|---|---|
| T1-T2 | Restaurant A reads only its rows; B's product by id returns 0 rows | Pass |
| T3 | Insert with B's `restaurant_id` is rejected (WITH CHECK) | Pass |
| T4 | Update or delete of B's rows touches 0 rows; moving an own row to B is rejected | Pass |
| T5, T5b | No tenant context returns 0 rows (fails closed), also on a reused connection | Pass |
| T6 | Transaction-local context never leaks to the next request on the same connection | Pass |
| T7 | **Anti-pattern confirmed:** a session-level setting persists and leaks across requests | Pass (proves the risk) |
| T5c | **Gotcha:** after a transaction ends, the setting becomes an empty string, and a plain `::uuid` cast raises an error on that connection. The policy needs `nullif(..., '')` | Pass |
| T8 | The table owner bypasses RLS unless `FORCE ROW LEVEL SECURITY`; a superuser always bypasses | Pass |
| T9 | **Leak:** a global unique index (for example on a PIN hash) reveals that another restaurant has the value. Unique indexes must include `restaurant_id` | Pass |
| T10 | Joins across tenant tables return only the caller's rows | Pass |
| T11 | A plain view runs as its owner; a `security_invoker` view respects the caller's tenant | Pass |
| T12 | A `SECURITY DEFINER` function is still filtered when its owner has FORCE RLS and no `BYPASSRLS` | Pass |
| T13 | The `restaurants` platform table is filtered to the caller's restaurant | Pass |
| T15-T16 | The runtime role cannot create a restaurant (no INSERT grant). A separate operator role creates a restaurant and its first staff member in one transaction, the new restaurant sees only its own data, and A still sees none of it | Pass |
| T14 | With 200,000 rows and 51 tenants, the planner uses the `restaurant_id` index under RLS (about 1.4 ms per query). **No RLS vs no-RLS overhead was measured.** | Info only |

Limits of this evidence: one database server, plain `psql` sessions rather than an application connection pool, a toy schema, no concurrency test, no load test.

## Decision

### Part A. Database rules (proposed; library-independent)
1. **Two database roles.** A migration owner that owns the tables, and a runtime role for the API that is not the owner, not a superuser and has no `BYPASSRLS`. The API only ever connects as the runtime role. Tests must connect as the runtime role too (a superuser hides every RLS bug, T8c).
2. **Every tenant table** has `restaurant_id uuid NOT NULL` referencing `restaurants`, `ENABLE` and `FORCE ROW LEVEL SECURITY`, one policy with both `USING` and `WITH CHECK`, and an index that starts with `restaurant_id`.
3. **Tenant context is set per request, inside the transaction,** with `set_config('app.restaurant_id', <id>, true)` (transaction-local). Never at session level (T7). One shared helper wraps every database call; no module sets it by hand.
4. **Policy reads the context through one function** that guards the empty string:
   ```sql
   create function app_tenant() returns uuid language sql stable as
   $$ select nullif(current_setting('app.restaurant_id', true), '')::uuid $$;
   -- per table:
   --   create policy tenant_isolation on <table>
   --     using (restaurant_id = app_tenant()) with check (restaurant_id = app_tenant());
   ```
5. **Unique constraints** on tenant tables always include `restaurant_id` (T9).
6. **Views** over tenant tables use `security_invoker = true` (T11).
7. **No `SECURITY DEFINER` functions** on tenant tables without a JUPITER review.
8. **Restaurant creation (F1-02) is not an API call in Release 1.** The runtime role has only SELECT on `restaurants`. A command-line script run by an Ostaru operator connects as a third role, `platform_operator` (can bypass RLS, used by nothing else), and creates the restaurant and its first Encargado in one transaction (T15, T16). "Someone who is not an operator is refused" then holds by construction: there is no route to call. This is a **proposal to the CTO** (it answers Q6 and F1-02).
9. **A guard test** reads the catalog and fails the build if any table with a `restaurant_id` column lacks RLS, FORCE or a policy. This catches a forgotten table in a later feature.

### Part B. Data-access library: recommendation Kysely (JANUS, confidence medium-low [E])
Researched online only (Rule 9); nothing was installed or run. Sources are listed at the end. The release pages show dates without a year; the dates below are as displayed.

| Criterion | Drizzle | Kysely | Edge |
|---|---|---|---|
| 1. Safety: a `withTenant` helper with a transaction-local setting | `db.transaction(async tx => ...)` with savepoints for nesting [1]. Docs have **no built-in API** for per-request settings; they point to an external wrapper (`createDrizzle`) that sets `set_config` and resets in `finally`, and the example uses `sql.raw` [2]. Whether `tx.execute(sql...)` works is **not confirmed** in the fetched docs [3] | `db.transaction().execute(async trx => ...)`; any query started from `trx` runs in that transaction, isolation level settable [4]. Raw SQL on `trx` is **not confirmed** in the fetched pages; the owner test below checks it | Even. Both need our own small wrapper |
| 2. RLS migrations (roles, FORCE, grants, `app_tenant()`) | Schema can declare policies (`pgPolicy`), `withRLS`, roles (`pgRole`, `.existing()`) and `securityInvoker` views [2]. Role management is off by default and the docs call parts incomplete [2]. `FORCE ROW LEVEL SECURITY`, grants and our function are **not mentioned**, so they need custom SQL-only migrations [5]. A 2026 article states drizzle-kit does not generate RLS policies [6]; the official docs do not say either way for generated DDL | Migrations are `up`/`down` functions using raw SQL; ordered, with a database lock for safe parallel starts [7]. No RLS abstraction, so everything is raw SQL, which our rules need anyway | Kysely for uniformity; Drizzle for declared policies, but only partly |
| 3. Type safety | Types follow the TypeScript schema. Drift risk if raw SQL migrations change the database | Types come from a `Database` interface, hand-written or **generated from the real database** (recommended for production) [8]. The database stays the source of truth, which fits raw SQL migrations | Even |
| 4. Maintenance and docs | Very active. Latest listed stable is 0.45.2; the 1.0 line is at release-candidate stage (rc.4 latest) [9]. Choice: stable 0.x now and migrate later, or adopt an RC | Latest stable 0.29.5; 0.30 betas; still 0.x; one deprecation (`disableTransactions`) noted [10]. Docs are clear but thin on transactions and RLS | Even. Both are pre-1.0 in practice; Drizzle has more churn to absorb |
| 5. Simplicity and module fit (ADR-001, Rule 4) | ORM layer plus kit tooling; schema files per module fit well | Query builder only, smaller surface, per-module `Database` slices | Kysely |

**Recommendation:** Kysely, because (a) every protection we depend on (FORCE, grants, `app_tenant()`, roles) is raw SQL in both tools, so Drizzle's declarative policies add little; (b) a smaller surface suits Rule 4; (c) it avoids deciding between a stable 0.x Drizzle and a 1.0 release candidate in Cycle 1. **Fallback:** Drizzle, if the owner prefers declared schemas; the Part A rules do not change.

**What would change my mind** (the owner can check cheaply): Kysely cannot run raw `set_config` on a transaction object; Kysely's generated types prove awkward in CI; or the owner wants one schema file as the single source of truth.

## Consequences
- Easier: isolation is enforced by the database even if application code forgets a filter; the rules are testable and the same whichever library wins.
- Harder: every query needs the tenant wrapper; migrations need raw SQL for policies; the pooled-connection test (owner-run, below) must pass with the chosen library.
- Remaining risk: the Part A checks ran in plain `psql` sessions, not through an application connection pool, and before Rule 9. The pooled version of T5b, T6 and T7 is the first F1-a test (task 4 of the breakdown).

## Owner-run checks (Rule 9: the owner runs these; the agent has not)
These commands are copy-and-paste and **have not been run in this form**. They need Docker. The first block repeats the 24 database checks; each line ends `PASS` or `FAIL`, and the last line is the total.
```bash
docker run -d --name pgspike -e POSTGRES_PASSWORD=spike postgres:16
docker cp projects/bar-praza/03-definition/spikes/adr-004/rls-spike.sh pgspike:/tmp/rls-spike.sh
docker exec pgspike bash -c "sed -i 's#-h /tmp -p 54329#-h /var/run/postgresql#' /tmp/rls-spike.sh && bash /tmp/rls-spike.sh"
docker rm -f pgspike
```
Expected: `RESULT: 24 passed, 0 failed` (the T14 timing lines vary). Send the full output to JANUS. Run `docker cp` from the vault root; the script's socket path is the only line that differs inside the container.

When the repository exists (P-01), the owner also runs, with Kysely:
1. The F1-a pooled-connection tests (breakdown task 4) with a pool of size 2: no tenant leak to the next request, and no context returns nothing.
2. The one-line check that raw `set_config` runs on a Kysely transaction (`sql` tag executed on `trx`). If it fails, switch to the Drizzle fallback and tell JANUS.

## Sources (all fetched 2026-10-21)
1. [Drizzle: transactions](https://orm.drizzle.team/docs/transactions)
2. [Drizzle: row-level security](https://orm.drizzle.team/docs/rls)
3. [Drizzle: sql operator](https://orm.drizzle.team/docs/sql)
4. [Kysely 0.29.2 type definitions, `transaction()` doc](https://cdn.jsdelivr.net/npm/kysely@0.29.2/dist/kysely.d.ts)
5. [Drizzle: custom migrations](https://orm.drizzle.team/docs/kit-custom-migrations) and [migrations overview](https://orm.drizzle.team/docs/migrations)
6. [ECOSIRE: Drizzle ORM + Postgres RLS for multi-tenancy (May 2026; secondary source, contradicts the official docs on policies, treat with care)](https://ecosire.com/blog/drizzle-orm-postgres-rls-multitenancy)
7. [Kysely: migrations](https://kysely.dev/docs/migrations)
8. [Kysely: getting started](https://kysely.dev/docs/getting-started)
9. [Drizzle ORM releases](https://github.com/drizzle-team/drizzle-orm/releases)
10. [Kysely releases](https://github.com/kysely-org/kysely/releases)

## Change log
| Version | Date | Note |
|---|---|---|
| 0.2 | 2026-10-22 | Part B recommendation by online research (Rule 9): Kysely, fallback Drizzle. Part A labeled agent-run before Rule 9; owner-run list added. |
| 0.1 | 2026-10-21 | Part A tested (24/24). Part B open. Drafted by JANUS. |
