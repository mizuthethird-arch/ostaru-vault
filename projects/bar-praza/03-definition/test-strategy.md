# Test strategy: Bar Praza, Release 1 (dashboard)
- Status: **DRAFT v0.2, by MINOS (QA Lead)**. Not approved.
- Date: 2026-10-22
- Owner: MINOS. Reports to the CTO (ATHENA). Gate G6 (QA sign-off) is MINOS's.
- **Verification status: everything here is NOT VERIFIED.** No code exists yet, and under Rule 9 ([AGENT-RULES](../../../AGENT-RULES.md), section 11.2) agents never run tests. A test counts as passing only when the Sponsor/Owner (or CI under the owner's control) runs it and reports the result.
- Sources: [MVP spec v0.2](mvp-spec.md), [ADR-001](adr/ADR-001-modular-monolith.md), [ADR-003](adr/ADR-003-multi-tenancy.md) (accepted), [ADR-004](adr/ADR-004-data-access.md), [ADR-006](adr/ADR-006-technology-stack-v2.md) (accepted; supersedes ADR-002), [threat model F1-a](threat-model.md), [stories](../04-planning/stories/README.md), [F1-a breakdown](../04-planning/breakdowns/F1-a-tenancy-identity.md), [Q8 decisions](../handoffs/2026-10-21-ATHENA-Q8-decisions.md), [change discipline and testing](../../../standards/code/change-discipline-and-testing.md).
- Labels: **[V]** verified in a source, **[A]** assumption, **[P]** proposal for the named owner to decide.

## 1. Approach
Test by risk, not by volume. Every feature ships with unit tests (CEO Rule 4). QA adds what unit tests cannot give: isolation against a real database, contract and flow tests, and release evidence. Tests are small, live next to the module they test, and run in CI on every change (G5). **Agents write and review tests; the owner runs them.** A result is never reported as passing before the owner reports it ([standard](../../../standards/code/change-discipline-and-testing.md), rule 10).

## 2. Tooling (from ADR-006) [V]
| Purpose | Tool |
|---|---|
| Unit and module tests (API and shared code) | Vitest |
| React component tests | Vitest + React Testing Library |
| API and database integration tests | Supertest against a **real PostgreSQL in a container** (Docker Compose) |
| End-to-end tests | Playwright |
| Static checks | ESLint, Prettier, `tsc --noEmit` on every change |
| Architecture test (P-02) | dependency-cruiser, run inside the test suite |
| Packages | npm workspaces: `apps/api`, `apps/dashboard`, `packages/ui`, `packages/shared` |
| Real time under test | Socket.IO (automatic reconnect, polling fallback) |

The mocked database is not allowed for isolation tests: row-level security only exists in the real database ([ADR-003](adr/ADR-003-multi-tenancy.md)).

## 3. Risk ranking (drives coverage)
| Rank | Risk | Source | Main protection | Test owner |
|---|---|---|---|---|
| 1 | One restaurant sees another's data (K-1, Critical) | discovery, ADR-003 | Isolation tests on real PostgreSQL, every table and operation | MINOS, JANUS |
| 2 | Weak or bypassed sign-in (PIN, device token) | MVP spec F1, F8 | PIN, lockout, session and permission tests | VULCAN (code), MINOS (review), EUNOMIA |
| 3 | Wrong allergen information shown | F2, S3 | Rule tests in `catalog`; visibility refused until reviewed | JANUS, MINOS |
| 4 | Console misses or delays an order (K-2) | F6, F7 | Throttled-network and reconnect tests; 3 s p95, ≤ 1 s typical [V] | MINOS, PROMETHEUS |
| 5 | Personal data kept too long or exposed (phone numbers) | F5, F9, S5 | Masking tests; retention purge test (period pending JUPITER) | JUPITER, MINOS |
| 6 | Wrong prices, stock or order totals | F2, F3, F7 | Business-rule unit tests | Feature owners |

## 4. Test levels
| Level | What it proves | Where | Gate |
|---|---|---|---|
| Unit | One rule or function, including edge cases and error paths | In each module, Vitest | G5 |
| Component | A React component renders its states (empty, loading, error) and basic accessibility | `packages/ui`, `apps/dashboard`, RTL | G5 |
| Architecture | A module cannot import another's internals | dependency-cruiser in CI | G5 |
| Integration | Module interfaces and database access, including row-level security | Supertest + PostgreSQL container | G5 |
| Contract | API shapes and errors match the approved contract | Supertest, CI | G4, G5 |
| End-to-end | Main flows as a user sees them: sign in, edit a product, take an order, change its status | Playwright, before each release | G6 |
| Exploratory | Charter-based sessions on new features, with a short note each | Each cycle, by the owner on a running build | G6 |
| Non-functional | Console latency and offline behaviour; accessibility basics; list-screen performance | Before a release | G6 |
| Security | Abuse cases from the threat model; scanning in CI | CI plus targeted checks | G3, G6 |

Rules:
- **Synthetic data only.** No real names, phones or credentials in tests or fixtures.
- A bug fix needs a test that fails before the fix and passes after it.
- Flaky tests are fixed or removed within the cycle. They are not retried until green.
- Code is delivered in chat and the CEO commits it ([decision log](../decision-log.md), "Code delivery"). QA reviews the proposal and its tests in chat.

## 5. F1-a test plan: tenancy and identity core
F1-a is the base of everything else, so it gets the deepest plan. Cases are tied to [stories F1-01 to F1-04](../04-planning/stories/f1-foundation.md) and to the threat model (T-numbers).

### 5.1 Tenant isolation (K-1; F1-01; T-1 to T-4)
Fixture: two restaurants (A, B), staff in every role, and data in every tenant table. The tests follow the database rules in ADR-004 Part A, which are library-independent.
1. **Matrix test:** for every tenant table and every operation (read, list, insert, update, delete), a user of A gets nothing from B and cannot write into B.
2. **Guard test (catalog):** every table with `restaurant_id` has row-level security enabled **and forced**, and a policy; unique indexes include `restaurant_id`. The build fails if a table is added without these. (ADR-004 rule 8; breakdown task 4.)
3. **Database layer alone:** with the application filter bypassed on purpose, the database still blocks B's rows (story F1-01, AC3).
4. **Runtime role:** the test connects as the application role and asserts it is not owner, not superuser and has no `BYPASSRLS` (T-2; breakdown task 1). Tests never run as a superuser, which hides every RLS bug.
5. **No tenant context returns 0 rows,** including on a reused connection and after a transaction ends (the empty-string case in ADR-004). A request that cannot resolve a restaurant is refused (story F1-01, AC2).
6. **No leak between requests on a pool:** use a pool of size 2 so connection reuse is forced; context is set per transaction and never at session level (T-3).
7. **Guessed identifiers:** a valid id from B, requested as A, returns "not found", the same answer as a missing id.
8. **Cross-tenant references:** an A record cannot point at a B record.
9. **Events and jobs:** an event for A processed while B is the current context writes only to A (T-4). Applies once a module publishes events.
10. **Platform tables and operators:** restaurant sessions cannot reach platform endpoints or the restaurants list beyond their own row (T-12; stories F1-02 AC3).
11. **Views and functions:** views over tenant tables are `security_invoker`; any `SECURITY DEFINER` function is reviewed by JUPITER and tested (ADR-004 rules 6 and 7).

### 5.2 Device pairing and PIN sign-in (F1-04, F1-05; T-5 to T-9, T-14, T-17)
Design decided by the CTO [V]: a device is paired with a one-time 6-digit code that issues a hashed, revocable device token. PIN sign-in needs a device token of the same restaurant. PINs are hashed with argon2 plus a server-side secret (ADR-006). Exact numbers (length, lockout, timeouts) come from JUPITER's PIN rules ([handoff](../handoffs/2026-10-21-MINOS-to-JUPITER.md)); tests read them from configuration, so no value is hard-coded in the plan.
- Pairing code: single use, expires, wrong code refused; the device list shows the new device.
- Correct PIN on a paired device of the same restaurant signs in with that role's permissions only.
- Refused with one generic message: wrong PIN, unknown person, unpaired device, device of another restaurant, deactivated person. Timing does not reveal which part failed (T-7).
- Repeated wrong PINs are throttled per device and per person; the lockout holds even with the correct PIN, and expires or is cleared as the rule says (T-5).
- The PIN is never stored readable, logged, returned or shown in an error; a log-capture test covers sign-in and PIN change (T-6, T-14).
- Changing or resetting a PIN ends that person's sessions. Disconnecting a device ends its sessions and closes its live connections (T-9).
- A revoked session is refused over HTTP **and** over Socket.IO, at connect and on reconnect (T-8).
- Idle timeout locks the session on a shared device (T-17).
- Sign-in attempts, lockouts, device pairing and PIN changes each write exactly one audit event, with no secret in it (T-11, T-20).
- A PIN of restaurant A never signs into B (story F1-04 isolation).

### 5.3 Roles and permissions (F1-03; T-10)
A table-driven test from the permission matrix ([design line](../standards/ux-ui-design-line.md), rule 17) [V]: Encargado (everything); Sala y barra (take orders, charge, change status, mark sold out); Cocina (change status, mark sold out). Every role × every protected endpoint, allowed and refused, checked at the API and not only in the screen. Permissions go through the single `can(role, action)` function in `identity` (ADR-006). Only the Encargado can turn demo mode off, and demo mode shows "DATOS DE DEMOSTRACIÓN" on every screen [V].

## 6. Other Release 1 coverage (outline)
| Area | Key checks |
|---|---|
| F2 Carta | Price and variant validation; the 14 allergens; a product cannot go visible until allergens are reviewed (S3, approved) |
| F3 Stock | Deduction per variant; movements logged with who and when; "AGOTADO (auto)" at 0 |
| F4 Horario | `canAcceptOrder`: no rules = accept; rules enforced on the server; pause and resume |
| F5/F7 Pedidos | Totals; status history with time and person; idempotency key prevents duplicates on retry |
| F6 Consola | Order appears on all connected devices within 3 s p95 [V]; offline banner and disabled buttons; full reload on reconnect; polling fallback |
| F9 Clientes | Phone masked in lists, full only in order detail for allowed roles; retention purge (period pending) |
| F10/F11 | Report numbers match the underlying orders on a known data set |

## 7. Who owns which security test
| Owner | Tests |
|---|---|
| MINOS (reviews, plans, signs off) | Isolation suite, permission matrix, PIN and session behaviour, device revocation, audit events, log-capture test, console latency and offline checks |
| JANUS, VULCAN (write, with the feature) | The unit and integration tests above, as part of each story's "done" |
| EUNOMIA (kept in CI) | Dependency scanning, secret scanning (T-15, T-18), SAST, header and CSRF checks (T-16) |
| ODYSSEUS (Red Team) | Attacker-path review of T-1 to T-12. **No testing until the rules of engagement are approved and the Sponsor authorizes the specific test.** |
| PROMETHEUS | CI jobs, backup configuration review (T-19) |

## 8. How the owner runs the tests
Rule 9: agents do not run, install or test anything. The Sponsor/Owner (or CI under the owner's control) runs the steps below and reports back; until then every item stays **NOT VERIFIED / IMPLEMENTED—NOT VERIFIED**.

**Prerequisite:** P-01 exists (repository, Docker Compose, CI). Script names below are **[A]** until PROMETHEUS confirms them in the P-01 spec.

| Step | What to do | Expected result to report |
|---|---|---|
| 1 | `npm ci` at the repository root | Installs without errors; lockfile unchanged |
| 2 | `npm run lint` and the type check (`tsc --noEmit`) | 0 errors |
| 3 | Start the test database: `docker compose up -d db` | PostgreSQL container healthy |
| 4 | `npm test` (Vitest, all workspaces, including the architecture test) | Number of tests passed / failed / skipped, and the names of any failures |
| 5 | Isolation suite (inside step 4, or its own script) | Every tenant table covered; guard test green; list of tables checked |
| 6 | `npm run build` | Both apps build |
| 7 | End-to-end tests (Playwright) against the Compose stack, before a release | Flows passed / failed, with traces or screenshots of failures |
| 8 | Console network check on a throttled connection (before M1) | Time from order saved to shown on every console: p95 and typical |
| 9 | Exploratory session on the bar's real tablet and phone (before M1) | Notes: defects found, with steps |

How to report back to MINOS (copy this form):
```text
Date / commit:
Steps run (1-9):
Passed / failed / skipped:
Failures (test name, message):
Not run, and why:
```
MINOS records the result in the cycle test report and changes an item from NOT VERIFIED only on the owner's report. If a test fails, the item goes back to its feature owner with the failure text.

## 9. Gates: what QA checks
| Gate | QA contribution |
|---|---|
| G1 spec | Acceptance criteria are testable (Given / when / then); gaps sent to PERICLES (see section 10) |
| G3 threat model | Abuse cases have tests, or a written reason why not |
| G4 API contract | A contract test exists for every endpoint |
| G5 merge | Tests listed; CI run reported by the owner and green; only the needed files changed |
| G6 QA sign-off | Test report: what was run (by the owner), results, open defects with severity, residual risk, go / no-go advice to the CTO |

**G6 exit criteria for a feature [P]:** every acceptance criterion has a test, and the owner reported it passing; no open Critical or High defect; isolation tests reported green for every table the feature touches; known gaps written down with an owner.
**M1 (shadow service at Bar Praza) [P]:** G6 passed for every feature in the M1 scope of the [backlog](../04-planning/backlog.md) (items 1 to 8); console target measured on the real bar network; no open Critical or High defect; staff PIN sign-in tried on the real devices. The QA Lead and the CISO can both veto a release candidate (workflow, Phase 5).

## 10. Testability findings (F1 stories)
| Story | Finding | Owner |
|---|---|---|
| F1-04 | **PIN sign-in is not testable as designed:** how a person is identified is undecided (name picker or PIN only). The threat model (T-7) assumes the person is identified first and PINs need not be unique; the breakdown's API ("device credential plus PIN") does not say who is signing in; ADR-004's example of a unique PIN hash assumes uniqueness. | SOLON, JUPITER, JANUS |
| F1-04 AC3, AC5 | "Temporary block" and "never stored readable" have no numbers or format; tests wait for JUPITER's rules | JUPITER |
| F1-02 | Operator mechanism to create a restaurant is undecided (Q3/Q6), so AC1 cannot be tested | CTO, JUPITER |
| F1-03 | Role names in the breakdown ("owner, manager, floor, kitchen") differ from the design and stories (Encargado, Sala y barra, Cocina) | JANUS |
| F1-a breakdown | No task covers sessions on live connections (T-8) or events and jobs in the right tenant (T-4); task 12 covers HTTP only | JANUS |

## 11. Independence
- QA Automation is vacant, so MINOS writes the strategy and reviews tests but **does not sign off tests it wrote itself**.
- **The independent check is the owner's own run in CI** (section 8): the author of a test never reports its result. MINOS signs off at G6 only on results the owner reports, never on an agent's claim.
- Feature owners (JANUS, VULCAN) write their story's tests; MINOS reviews them. Any test MINOS writes (for example the isolation matrix) is reviewed by JANUS and run by the owner.
- Part A evidence in ADR-004 ("21 passed") was run by an agent before Rule 9, so it is **agent-run, owner to re-run**, not a verified result. The script and output are now filed in `spikes/adr-004/`.

## 12. Reporting
A short test report per cycle to the CTO: coverage against the risk ranking, results reported by the owner, open defects (steps, severity, owner, next date), trend, and residual risk. Facts and estimates are labeled. This strategy is reviewed at the end of every cycle.

## 13. Dependencies and open decisions
| # | Needed | From | State |
|---|---|---|---|
| 1 | ADR-002 / ADR-003 approval | CEO | **Closed:** ADR-003 accepted; ADR-002 superseded by ADR-006 (accepted) |
| 2 | Test tooling | JANUS, PROMETHEUS | **Closed:** ADR-006 (Vitest, RTL, Supertest on PostgreSQL, Playwright). Script names [A] until P-01 |
| 3 | Data-access library (Drizzle or Kysely) | JANUS | Open; decided by online research (Rule 9). Isolation tests do not depend on it |
| 4 | F1-a threat model | EUNOMIA | Draft v0.1 filed; ODYSSEUS and JUPITER review pending |
| 5 | PIN rules and retention period | JUPITER | Open |
| 6 | How a person is identified at PIN sign-in | SOLON, JUPITER | Open (section 10) |
| 7 | Roles and permissions list (Q1) | SOLON, PERICLES | Open |
| 8 | QA Automation role | CEO / CTO | Vacant |
| 9 | Real devices and bar Wi-Fi for the console check (K-2) | CEO, HESTIA | Open |

## 14. Change log
| Version | Date | Note |
|---|---|---|
| 0.2 | 2026-10-22 | Tooling fixed to ADR-006; ADR-003 and ADR-006 items closed; Rule 9 applied (owner runs tests, new section 8); security test ownership; testability findings; M1 and G6 criteria; independence via the owner's CI run. |
| 0.1 | 2026-10-21 | First draft. |
