# Threat model: Bar Praza, F1-a (tenancy and identity core)
- Date: 2026-10-22 (v0.1 written 2026-10-21)
- Status: **DRAFT v0.2**, by EUNOMIA (AppSec). Not a G3 pass until ODYSSEUS and JUPITER have reviewed it.
- Owners: Red Team Lead (not in the roster; ODYSSEUS covers meanwhile) + AppSec (EUNOMIA)
- Reviewed by: CISO (JUPITER), pending
- Scope: backlog items F1-a and F1-05 (device pairing), plus the F8 screens that change PINs, roles and devices. Later features (catalog, ordering, customers, payments) get their own section here when they reach G3.

> Gate **G3** ([startup workflow](../../../operating-model/startup-workflow.md), section 5): auth and personal data are touched. This is step 1 of the Red / Blue cycle (charter 7.2). Severity follows [charter 7.3](../../../operating-model/team-charter.md) and means the severity **if the threat is not mitigated**. No credentials or real user data in this file. Design basis, all **Accepted**: [ADR-001](adr/ADR-001-modular-monolith.md), [ADR-003](adr/ADR-003-multi-tenancy.md), [ADR-006](adr/ADR-006-technology-stack-v2.md) (Express, React, Tailwind, npm, Socket.IO, PostgreSQL with RLS; supersedes ADR-002) and the [Q8 decisions](../handoffs/2026-10-21-ATHENA-Q8-decisions.md) (device pairing). **Rule 9:** this model comes from reading documents only. Nothing was scanned, run or tested, so every control below is a requirement, not a verified fact. Labels: **[V]** verified in a document, **[A]** assumption.

## System and data flows in scope
1. **PIN sign-in:** staff picks or is identified on a registered device, enters a PIN, `identity.authenticate` returns a session with role and permissions (ADR-001, MVP spec F1).
2. **Tenant context:** each request sets the current restaurant from the session. Repositories filter by it, and PostgreSQL row-level security (RLS) enforces the same rule (ADR-003).
3. **Administration (F8):** the Encargado adds staff, sets or changes PINs, edits the permission matrix, lists and disconnects devices, and toggles demo mode.
4. **Platform operations:** Ostaru creates restaurants and operators. Platform tables are the only ones without `restaurant_id` (ADR-003).
5. **Real time:** Socket.IO (ADR-006) pushes console updates per restaurant room, with a polling fallback. The handshake, the origin and the room join must be checked here (T-21).
6. **Device pairing (Q8, F1-05):** the Encargado gets a 6-digit code valid 10 minutes and one use. A new browser enters it, the server registers the device to that restaurant and sets a random device token in an `HttpOnly`, `Secure`, `SameSite=Strict` cookie (only its hash is stored). PIN sign-in needs a valid device token of the same restaurant. Ostaru issues the first code when it creates a restaurant (F1-02).

## Assets and sensitive data
| Asset | Why it matters |
|---|---|
| Tenant boundary (restaurant A vs B) | Risk K-1, rated Critical in the discovery report [V] |
| Staff PINs and PIN hashes | A short secret. Offline cracking is cheap if hashes leak [A: 4 to 6 digits] |
| Sessions, device tokens, pairing codes | They carry the identity and the role. A pairing code lets a new device join a restaurant |
| Role and permission matrix | Decides who can charge, change status or change PINs |
| Staff personal data (name, role, last access) | GDPR personal data |
| Audit trail (who did what) | Needed for investigation, but must not hold PINs or tokens |
| Platform tables and operator accounts | They cross tenants by design |
| Secrets (PIN pepper, signing keys, DB roles) | Secret-management system is TBD ([general-context](../../../general-context.md), section 5) |

## Trust boundaries and entry points
- Browser or tablet ↔ API (HTTP and Socket.IO): untrusted client. Browser origin is also untrusted until checked.
- Pairing endpoint: reachable before any sign-in, so it is the most exposed entry point.
- API ↔ PostgreSQL: the application role must **not** be able to bypass RLS.
- Tenant users ↔ platform operators: different privilege domains.
- CI/CD and migrations ↔ production database: privileged role, separate from the runtime one.
- Shared bar devices (tablet on the counter): physical access by anyone in the bar.

## Threats

Likelihood and impact: L / M / H. "Test" is the minimum automated test that proves the mitigation (Rule 4, [change discipline and testing](../../../standards/code/change-discipline-and-testing.md)).

| # | Threat | Affected component | Likelihood | Impact | Severity (charter 7.3) | Mitigation, and the test that proves it | Owner |
|---|---|---|---|---|---|---|---|
| T-1 | **Cross-tenant read or write** through a missing tenant filter, a guessable id (IDOR), or a query run outside a tenant context | every module, `tenancy` | M | H | **Critical** | Tenant context is mandatory: a query without it fails closed. Ids are checked against the tenant, never trusted. Test: isolation suite, restaurant A never reads, updates or deletes B's rows, for every table and every endpoint | JANUS, VULCAN |
| T-2 | **RLS is bypassed** because the runtime role owns the tables, is a superuser, or RLS is not forced | PostgreSQL | M | H | **Critical** | Runtime role is non-owner, non-superuser. `FORCE ROW LEVEL SECURITY` on all tenant tables. Separate migration role. Test: with the runtime role and no tenant set, a select returns zero rows; a CI check lists any tenant table without a policy | JANUS, PROMETHEUS |
| T-3 | **Tenant context leaks between requests** through connection pooling (a session setting that survives on a reused connection) | API ↔ DB | M | H | **Critical** | Set the tenant per transaction (`SET LOCAL`), never per connection, and reset it on release. Test: two concurrent requests from different restaurants on a one-connection pool never see each other's rows | JANUS |
| T-4 | **Background jobs, event handlers and reporting read models** run without a tenant context or with the wrong one (events cross modules, ADR-001) | `reporting`, `inventory`, event bus | M | H | **Critical** | Every event carries `restaurant_id`, and handlers run inside that context. Test: an event for A processed while B is the current context writes only to A | JANUS, VULCAN |
| T-5 | **PIN brute force** on the sign-in endpoint (a 4-digit PIN has 10,000 values) | `identity` | H | H | **High** | Throttle per device, per staff member and per IP, with a growing lockout, and an alert on repeated failures. Sign in needs a registered device plus a named staff member, not PIN alone. Test: the Nth failed attempt is refused and the lockout holds even with the correct PIN | VULCAN, ORPHEUS |
| T-6 | **PIN hashes leaked and cracked offline** (small keyspace) | `identity` DB, backups | L | H | **High** | Slow salted hash (argon2, per ADR-006) **plus a server-side pepper held outside the database**. Hashes never in logs or exports. Test: hash format and parameters asserted; PIN absent from logs and API responses | VULCAN, EUNOMIA |
| T-7 | **PIN uniqueness leak:** if PINs must be unique per restaurant, an error on "PIN already used" tells a manager (or attacker) which PINs are taken | F8, `identity` | M | M | **Medium** | Do not require uniqueness. Identify the person first, then check the PIN. Generic error messages. Test: identical response for unknown staff and wrong PIN, and similar timing | VULCAN |
| T-8 | **Session theft or reuse** (token in logs, long lifetime, no server-side revocation) | sessions, WebSocket | M | H | **High** | Short sessions with idle timeout, server-side revocation, httpOnly secure cookies, session re-checked when a Socket.IO connection is made and on reconnect (T-21). Test: a revoked session is refused on HTTP and on Socket.IO | VULCAN, JANUS |
| T-9 | **Disconnected or lost device keeps access** (stolen tablet, former employee's phone) | devices (F8) | M | H | **High** | Disconnect revokes the device and all its sessions immediately, and open sockets are closed. Test: after disconnect, the next request and the live socket both fail | VULCAN |
| T-10 | **Privilege escalation:** a Cocina or Sala y barra user performs Encargado actions (set PINs, change roles, toggle demo mode) by calling the API directly | permission matrix | M | H | **High** | Permissions are checked server-side on every endpoint (`can(staff, permission)`), never only hidden in the UI. Test: a matrix test calls every protected endpoint with every role and checks allow or deny | VULCAN |
| T-11 | **Account takeover through PIN reset:** an Encargado account is compromised, or a staff member resets another's PIN without trace | F8 | L | H | **High** | PIN change is audited (actor, target, time, no PIN value). The Encargado role is limited, and changes by one Encargado on another are flagged. Rules for who may reset whom: see open question 2. Test: an audit entry exists for every PIN change and holds no secret | VULCAN, JUPITER |
| T-12 | **Platform operator crosses tenants** (support or admin access to every restaurant) | platform tables | L | H | **High** | Separate operator identity and privilege domain, every cross-tenant action audited, and no operator access in the Release 1 runtime beyond creating restaurants [A]. Test: tenant sessions cannot reach platform endpoints | JANUS, JUPITER |
| T-13 | **Demo mode abused or left on:** fake data shown as real, or turned off by the wrong role, or demo data mixed with a real restaurant | `tenancy` | M | M | **Medium** | Only the Encargado turns it off (spec F1). Demo data lives in its own restaurant record and is purged on switch-off [A]. Test: a non-Encargado cannot toggle it; demo rows never appear in a live restaurant | JANUS |
| T-14 | **Sensitive data in logs, errors or analytics:** PINs, tokens, staff names, phone numbers | whole stack | M | M | **Medium** | A log redaction layer and a code-review rule. Secrets scanning in CI. Test: a log-capture test for the sign-in and PIN-change flows | EUNOMIA, PROMETHEUS |
| T-15 | **Secrets in source or images:** the PIN pepper, JWT keys or DB passwords committed or baked into a container | repo, CI, Docker | M | H | **High** | Secrets come from the environment, GitHub Actions secrets or a secret manager (TBD), and are validated at startup. Never in the repo, a Docker layer or an image pushed to the registry. Secret scanning and pre-commit checks in CI (P-01). `.env` never committed. Test: a CI job that fails on a planted dummy secret | PROMETHEUS, EUNOMIA |
| T-16 | **Web attacks on the admin UI:** XSS, CSRF, clickjacking against Encargado actions | `apps/dashboard`, API | M | M | **Medium** | Framework escaping, CSRF protection or SameSite cookies, strict CSP and frame-ancestors, input validation on every DTO. Test: header assertions; a malicious name renders as text | CTO (UI), VULCAN |
| T-17 | **Shoulder surfing or shared-tablet misuse:** PIN seen or a signed-in console left open at the bar | devices, console | H | M | **Medium** | PIN entry masked, idle auto-lock, per-person sessions, and each action tagged with the named person (the design already shows "[Uxía], consola" [V]). Test: idle timeout locks the session | VULCAN, CTO (UI) |
| T-18 | **Dependency or supply-chain compromise** in the Express, React, Tailwind and npm tree (malicious or typosquatted package, hijacked maintainer, install scripts, transitive dependencies; later also the base Docker images and GitHub Actions) | repo, CI, Docker | M | H | **High** | Commit `package-lock.json` and install with `npm ci` in CI. Minimal, reviewed new dependencies: each new package is checked online (maintenance, downloads, repository, licence) before approval. Dependency-vulnerability scanning and secret scanning in CI, run by CI and reported by the owner (Rule 9: agents run nothing). Pin GitHub Actions to commit SHAs, least-privilege `GITHUB_TOKEN`, pinned base image versions. Test: a CI job fails on a known-vulnerable dependency or a planted dummy secret (owner runs it, status IMPLEMENTED—NOT VERIFIED until reported) | EUNOMIA, PROMETHEUS |
| T-19 | **Backups and database dumps expose all tenants** | PostgreSQL, ops | L | H | **High** | Encrypted backups, restricted access, tested restore, and restores never go to dev unmasked. Test or review: backup configuration checked in Cycle 1 platform work | PROMETHEUS, JUPITER |
| T-20 | **Audit trail missing or editable**, so an incident cannot be reconstructed | `identity`, platform | M | M | **Medium** | Append-only audit events for sign-in, failures, PIN, role and device changes, with the tenant id. Test: each action writes exactly one event | VULCAN, ORPHEUS |
| T-21 | **Socket.IO abuse:** connecting without authentication, joining another restaurant's room by naming it, cross-site WebSocket hijacking from a malicious page, oversized or flooding messages, or a revoked session staying connected | Socket.IO gateway, console | M | H | **Critical** | Authenticate in the handshake middleware (session plus device token) and refuse otherwise, on the polling fallback too. The server decides the room from the session, and never from a client-sent room name. Check `Origin` against the CORS allow-list. Re-authenticate on reconnect. Close sockets when a device or session is revoked. Limit `maxHttpBufferSize` and messages per socket. Test: no cookie is rejected; a wrong origin is rejected; a socket of A never receives B's events or joins B's room; a revoked device's socket is closed | JANUS, VULCAN |
| T-22 | **Pairing code guessing:** 1,000,000 possible codes, and the code is entered before any sign-in [A: not tied to a restaurant on entry], so a guess could hit any restaurant's active code | pairing endpoint (F1-05) | M | H | **High** | CSPRNG codes, compared in constant time. Strict rate limit per IP and per device, plus a **global** failed-attempts throttle. A code is voided after a few wrong attempts. Keep few active codes. Same error for unknown, expired and used codes. See H-4. Test: the limit holds, a used or expired code fails, and the error is identical | VULCAN, JANUS |
| T-23 | **Pairing code leaked or reused:** shoulder surfing, sent over chat, still valid after being shown, several codes alive at once | F1-05, F8 | M | M | **Medium** | One use, 10 minutes, shown once, and issuing a new code voids the previous one for that restaurant. Only a hash of the code is stored [A]. Never in logs. Test: second use fails, a new code voids the old one, the code is absent from logs | VULCAN |
| T-24 | **Pairing issued by the wrong person or for the wrong restaurant** (a Cocina user, another tenant, or a replayed request) | F1-05, F8-04, permission matrix | M | H | **High** | Only the Encargado can issue a code, enforced server-side, and the code is bound to the issuer's restaurant. Each issue, use and revoke is audited. Test: Cocina and Sala y barra are refused; a code issued in A registers the device only in A | VULCAN |
| T-25 | **First-device bootstrap abused:** the first code issued by Ostaru in F1-02 is intercepted, or an operator can mint codes for any restaurant without trace | F1-02, platform | L | H | **High** | The first code is delivered to the real Encargado through a channel outside the vault, lives 10 minutes, and is audited like any other. Operator actions are audited (T-12). Test: operator-issued code follows the same limits and creates an audit event | JANUS, JUPITER |
| T-26 | **Device token theft:** read by XSS or malware, copied from a stolen device, or leaked if stored in plaintext in the database | device cookie, `identity` DB | M | H | **High** | `HttpOnly`, `Secure`, `SameSite=Strict`. 256-bit random token, and only its hash stored. Rotate the token on each sign-in so a copy goes stale. The XSS mitigations of T-16. Test: the cookie flags are asserted; the table holds no readable token; an old rotated token is refused | VULCAN |
| T-27 | **Token and tenant mismatch:** a device registered to restaurant A is accepted for a PIN of restaurant B, or the tenant is taken from client input | F1-04, F1-05 | M | H | **Critical** | Sign-in requires device restaurant = staff restaurant = tenant context, all derived server-side. Test (isolation): A's device with B's staff and PIN is refused, and so is the reverse | VULCAN, JANUS |
| T-28 | **Stale devices:** lifetime too long, an ex-employee's phone still paired, or cleared cookies leave unmanaged registrations | F8-04, `identity` | M | M | **Medium** | Sliding lifetime with an absolute cap, and expiry of unused devices. F8-04 shows last use so the Encargado can disconnect. A browser that clears cookies is paired again with a new code (Q8). Limits: open question 8. Test: an expired or unused device is refused and the old registration is not reused | VULCAN, JUPITER |

## Express hardening: acceptance criteria for F1-a
Proposed for PERICLES to add to F1-01 to F1-05 (stories are PM-owned, so EUNOMIA does not edit them). Numbers are **[A] proposals** for JUPITER to confirm. Each criterion needs a unit or integration test (Rule 4), written in chat and run by the owner (Rule 9).

| # | Requirement | Test | Covers | Story |
|---|---|---|---|---|
| H-1 | **Security headers** on every response (Helmet or equivalent): strict CSP, `frame-ancestors 'none'`, HSTS, `nosniff`, a referrer policy, and `X-Powered-By` off | Supertest asserts each header | T-16 | F1-01 |
| H-2 | **Default-deny:** every route needs authentication unless it is on an explicit allow-list (sign-in, pairing, health). Permission middleware calls the single `can(role, action)` | A test lists all routes and fails on an unprotected one; the role × endpoint matrix | T-10 | F1-03 |
| H-3 | **Rate limiting** on sign-in [A: 5 wrong PINs per staff member in 15 minutes, then a growing lockout; 20 per device; a looser per-IP cap], with a shared store if the API ever runs more than one instance, and a correct `trust proxy` setting so the IP cannot be spoofed | Nth failure refused even with the right PIN; spoofed `X-Forwarded-For` does not reset the limit | T-5 | F1-04 |
| H-4 | **Rate limiting on pairing** [A: 5 wrong attempts per IP per hour, a global failed-attempts throttle, a code voided after 3 wrong tries], and on code issuing [A: a few per Encargado per hour] | Limit holds; a voided code fails even if correct | T-22, T-23 | F1-05 |
| H-5 | **CORS allow-list** with exact origins, no wildcard, credentials only for those origins. The same list is used for the Socket.IO origin check | A disallowed origin gets no CORS headers and no socket | T-21, T-16 | F1-01 |
| H-6 | **Request size limits:** a small JSON body limit [A: 100 kB], separate limits for uploads (ADR-005), and request timeouts | An oversized body returns 413 | T-21 | F1-01 |
| H-7 | **zod validation on every input** (body, params, query, headers), strict, rejecting unknown keys, with ids as UUIDs. No SQL built from strings: only parameterized queries | An invalid or extra field returns 400; an injection string is stored or rejected as plain text | T-1, T-16 | all |
| H-8 | **One central error handler:** generic messages, no stack traces, no tenant or SQL detail, and a request id for support | A forced error returns the generic body | T-7, T-14 | F1-01 |
| H-9 | **Cookies:** `HttpOnly`, `Secure`, `SameSite=Strict`. State-changing requests also check `Origin` or a custom header | Flags asserted; a cross-origin POST is refused | T-16, T-26 | F1-04, F1-05 |
| H-10 | **Logging with pino redaction** of PINs, tokens, cookies and codes, and an audit event for sign-in, failure, PIN, role, device and pairing changes, each with the tenant id | Log-capture test for sign-in, PIN change and pairing; one audit event per action | T-14, T-20 | F1-04, F1-05 |
| H-11 | **Configuration validated at startup** with zod. The app refuses to start if a secret (PIN pepper, signing key, DB URL) is missing or weak, and never ships a default | Start-up test fails without each secret | T-15 | F1-01 |
| H-12 | **Database roles:** runtime role non-owner and non-superuser, `FORCE ROW LEVEL SECURITY`, tenant set with `SET LOCAL` per transaction | See T-2 and T-3 tests | T-1 to T-3 | F1-01 |
| H-13 | **Socket.IO:** handshake auth, server-chosen rooms, origin check, message size and rate limits, close on revoke | See T-21 tests | T-21 | F1-01, F1-05 |
| H-14 | **Pairing:** 6-digit CSPRNG code, 10 minutes, one use, constant-time compare, only hashes stored, device token with 256 bits of entropy | See T-22 to T-27 tests | T-22 to T-27 | F1-05 |

**Later stories needing G3** (for PERICLES): F8 (PIN and device admin), F7 (staff-entered orders with phone numbers), F5, F9 (customer data), F2-05 (photo upload, ADR-005).

## Residual risks and exceptions
- None accepted yet. Accepting a risk is a decision for the CISO and the CEO (AppSec does not accept business risk, [persona](../../../agent-personas/EUNOMIA.md)).

## Open questions
1. **PIN length and format** (4, 5 or 6 digits; numeric only?). Not defined in the MVP spec [V]. EUNOMIA recommends **6 digits** if the design allows it [A: the design shows no length]. Owner: JUPITER with SOLON.
2. **Who may set or reset whose PIN** (can the Encargado reset another Encargado? is a PIN reset self-service?). Owner: JUPITER.
3. **Lockout and session lifetime numbers** (attempts, lockout time, idle timeout). EUNOMIA's proposals are in H-3 and H-4, **[A]** until JUPITER confirms. Owner: JUPITER.
4. **Retention periods** for audit events, sign-in logs, staff records after they leave, and staff-entered customer phones (decision S5 in the SOLON answers: the purge period is JUPITER's to set). Owner: JUPITER, then legal/privacy owner (none exists; goes to the CTO and the CEO).
5. **Secret-management system and pepper storage** (TBD). Owner: CTO.
6. ~~Device registration~~ **Resolved by Q8** (CTO, 2026-10-21): one-time pairing code, then a hashed device token. Threats T-22 to T-28.
7. ~~ADR-002 and ADR-003 not approved~~ **Closed:** ADR-003 and ADR-006 are Accepted (CEO, 2026-10-21), and ADR-006 supersedes ADR-002.
8. **Pairing limits** (Q8 left them to G3, EUNOMIA with JUPITER): attempts per code, device token lifetime, and cleared cookies. EUNOMIA proposes: a code is voided after 3 wrong attempts; the token lasts 180 days of use [A, from Q8] with an **absolute cap of 365 days** and expiry after **60 days unused**; cleared cookies mean pairing again. Owner: JUPITER.
9. **Is the pairing code tied to a restaurant on entry?** If it is entered alone, a guess can hit any restaurant's active code (T-22). Option: the Encargado also approves the new device in the panel. This is a decision for the CTO and JANUS; EUNOMIA recommends the approval step if it is cheap. Owner: CTO.

## Next steps (Red / Blue cycle)
1. ODYSSEUS reviews T-1 to T-12 and proposes abuse cases to test once there is code. **No testing starts** until the rules of engagement are approved and the CEO authorizes the specific test ([rules of engagement](../05-security/rules-of-engagement.md)).
2. JUPITER answers open questions 1 to 4 and reviews severity.
3. PERICLES adds H-1 to H-14 to F1-01 to F1-05. JANUS and VULCAN fold the "Test" column into F1-a's acceptance tests, and MINOS adds them to the test strategy. Per Rule 9, the owner runs all of them.
4. EUNOMIA re-issues this as v1.0 and records the G3 result.

## Change log
| Version | Date | Note |
|---|---|---|
| 0.1 | 2026-10-21 | First draft by EUNOMIA from the MVP spec, ADR-001 to ADR-003 and the discovery report. |
| 0.2 | 2026-10-22 | Per the ATHENA handoff (stack v2): T-18 covers the Express, React and npm tree; new T-21 for Socket.IO; new T-22 to T-28 for device pairing (Q8); Express hardening criteria H-1 to H-14; assumption 7 closed; open questions 8 and 9 added. |
