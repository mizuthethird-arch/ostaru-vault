# Stories F1 — Foundation

> Package v0.2 by PERICLES (Product Manager), filed 2026-10-21. **v0.3 on 2026-10-22** after the Owner bypass (all blockers cleared, Cycle 1 starts), ATHENA's decisions handoff and EUNOMIA's hardening criteria H-1 to H-14. See the [decision log](../../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

> Common acceptance criteria C1–C7 and the gate list are in the [stories README](README.md) and apply to every story here.

**F1-a = F1-01 to F1-05 (Cycle 1).** F1-05's backend (pairing code, device token, token check) moved from F1-b into F1-a on 2026-10-22 [V: ATHENA decisions handoff, PERICLES item 2]. The pairing screens (add device, enter code) follow the F1-a UI slice. F1-b no longer exists as a separate item.

**Security criteria H-1 to H-14** come from EUNOMIA's [threat model](../../03-definition/threat-model.md) ("Express hardening: acceptance criteria for F1-a"). Each is a testable Given/when/then. Numbers marked **[A]** are proposals until JUPITER confirms them (threat-model open questions 3 and 8). H-7 applies to every story.

**F1-01 · Tenant context and isolation** · `tenancy` · size M · G1 G3 G4 G5 G6 G7
*As Ostaru, I need every request to run inside exactly one restaurant, so no restaurant sees another's data.*
- **AC1** Given restaurants A and B with data, when a signed-in user of A calls any endpoint, then nothing of B is returned or changed.
- **AC2** Given a request with no resolvable restaurant, then it is refused and returns nothing.
- **AC3** Given the application-level filter is bypassed in a test, then the database layer still blocks B's rows (ADR-003, two layers; accepted by the CEO).
- **H-1** Given any API response, then it carries the security headers listed in the threat model (Helmet defaults plus the project's choices).
- **H-5** Given a browser request from an origin not on the allow-list, then CORS refuses it. The allow-list comes from configuration, never `*`.
- **H-6** Given a JSON body above the limit [A: 100 kB, JUPITER to confirm], then it is refused with 413 and no handler runs.
- **H-8** Given any error, then a central handler returns a generic Spanish message with a request ID. No stack trace, SQL or internal path leaves the server.
- **H-11** Given a missing or invalid required setting at startup (database URL, secrets, allowed origins), then the process refuses to start and names the setting, never its value.
- **H-12** Given the database connection, then the application uses a role without ownership or `BYPASSRLS`. Tables use `FORCE ROW LEVEL SECURITY`, and the tenant is set with `SET LOCAL` inside each transaction.
- **H-13** Given a Socket.IO connection (when real time exists), then it follows the threat model's hardening list. In F1-a this criterion is a placeholder test that the module is not mounted.
- **Isolation:** this story is the foundation, and its tests are the template for every module.
- **Role:** none (no user action).
- **Tests:** unit tests for tenant context; integration tests across two restaurants, including the bypass case; one test per H criterion above.
- **Design line:** none.
- **Out of scope:** UI, restaurant creation (F1-02), users in several restaurants [A].

**F1-02 · Restaurant creation by Ostaru (operator command)** · `tenancy` · size S · G1 G3 G4 G5 G6 G7
*As an Ostaru operator, I want to create a restaurant with its first Encargado, so a new client is set up by configuration only.*

(2026-10-22) Decided: creation is an **operator command-line command**, not an API route. It uses a database role `agora_operator` [V: ATHENA decisions, Q3 and Q4 bypass; JANUS breakdown v2].
- **AC1** Given an operator runs the command for "Bar Praza", then the restaurant exists with a first Encargado, demo mode on [A], its own isolated data, and a **one-time temporary PIN** for that Encargado.
- **AC2** Given a second restaurant is created, then no code change is needed.
- **AC3** Given anyone other than the operator role, then creation is impossible: no API route exists, and the application's database role cannot create restaurants.
- **AC4** Given the command finishes, then it prints the first **pairing code** for the Encargado's device (see F1-05).
- **AC5** Given the temporary PIN is shown, then it is shown once, never logged and never stored readable. The Encargado must change it at first sign-in (F1-04 AC6).
- **H-9** Given the command runs, then an audit event records who ran it and which restaurant was created, with no PIN or code in the log.
- **Isolation:** each restaurant's data is invisible to the other.
- **Role:** Ostaru operator only; no restaurant role can create restaurants (S1).
- **Tests:** creation happy path, denied path (application role), temporary PIN shown once, isolation between two created restaurants.
- **Design line:** none. There is no operator UI in Release 1.
- **Out of scope:** self-service sign-up, billing, operator back office, restaurant switcher.

**F1-03 · Staff, roles and permissions** · `identity` · size S · G1 G3 G4 G5 G6 G7
*As the Encargado, I want every staff member to have one role with fixed permissions, so people can do only their job.*
- **AC1** Given each role, when an action is attempted, then it is allowed or denied per the matrix: Encargado everything; Sala y barra takes orders, charges, changes status and marks sold out; Cocina changes status and marks sold out [V: r17].
- **AC2** Given a staff member of restaurant A, then they can't be assigned in or see restaurant B.
- **H-2** Given any action not listed for a role, then `can(role, action)` denies it (default deny). Given a new action added without a rule, then it is denied and a test fails until the rule exists.
- **Isolation:** yes (AC2).
- **Role:** this is the permission system itself.
- **Tests:** a table-driven test of every role against every permission, the default-deny test, plus the isolation test.
- **Design line:** r17.
- **Out of scope:** custom roles, per-user overrides [A], multi-restaurant staff.

**F1-04 · PIN sign-in** · `identity` · size M · G1 G2 G3 G4 G5 G6 G7
*As staff, I want to pick my name and enter my PIN, so I can start my shift quickly with my role's permissions.*

(2026-10-22) Decided D2: the person **picks their name from the restaurant's staff list, then enters the PIN** [V: ATHENA decisions]. The list is only shown to a registered device (F1-05).
- **AC1** Given an active staff member picked from the list and their correct PIN, then they are signed in with their role, and the session is scoped to their restaurant.
- **AC2** Given a wrong PIN, then sign-in is refused with a Spanish error that does not reveal which part was wrong.
- **AC3** Given repeated wrong PINs, then a temporary block applies, **per person and per device**. The numbers are a proposal [A] until JUPITER confirms (threat-model open question 3).
- **AC4** Given an inactive staff member, then sign-in is refused.
- **AC5** A PIN is never shown or stored readable. PINs are hashed with argon2 plus a server-side secret and never logged [V: ADR-006].
- **AC6** Given a person signs in with a temporary PIN (F1-02), then the only allowed next action is **"change PIN"**. Every other action is refused until a valid new PIN is set. The temporary PIN stops working after that.
- **H-3** Given a sign-in request, then rate limits apply per IP, per device and per person, with the numbers in the threat model [A].
- **H-9** Given sign-in success, failure, block or PIN change, then an audit event is written (who, device, result, time) and no PIN or token appears in any log.
- **H-10** Given pino logging, then PINs, tokens, cookies and the Authorization header are redacted by configuration, and a test proves it.
- **Isolation:** a PIN of restaurant A never signs into B.
- **Role:** the pre-sign-in action is open to registered devices; every later action follows F1-03.
- **Tests:** unit tests for AC1–AC6, rate limits, log redaction, and an isolation test.
- **Design line:** r5–r10 for a minimal name-then-PIN screen and a change-PIN screen. No sign-in design exists (Q3), so G2 is needed.
- **Out of scope:** password reset, SSO, self-service PIN reset (F8-02 covers the Encargado setting PINs).

**F1-05 · Device registration by pairing code** · `identity` · size M [E; JANUS task breakdown: tasks 13 to 16] · G1 G3 G4 G5 G6 G7
*As the Encargado, I want PIN sign-in limited to registered devices, so a stranger's phone can't be used.*

(2026-10-22) **Backend moved into F1-a (Cycle 1).** Mechanism decided by the CTO [V: Q8 decisions, item 2].
- **AC1** Given the signed-in Encargado chooses "Añadir dispositivo", then a 6-digit pairing code is shown. It is valid for 10 minutes and works once.
- **AC2** Given a new device enters a valid code, then it is registered to that restaurant and receives a random device token in an `HttpOnly`, `Secure`, `SameSite=Strict` cookie. The server keeps only a hash of the token.
- **AC3** Given an expired, already used or wrong code, then registration is refused.
- **AC4** Given PIN sign-in, then it is accepted only together with a valid device token of the same restaurant. An unregistered device is refused.
- **AC5** A registered device appears in the F8-04 list.
- **AC6** Given Ostaru creates a restaurant (F1-02), then the command issues the first pairing code for the first Encargado's device.
- **H-4** Given a cookie-authenticated request that changes data, then the server checks the `Origin` header and the cookie flags above, and refuses a request from another origin.
- **H-9** Given a pairing event (code issued, used, refused, device revoked), then an audit event is written without the code or token.
- **H-10** Pairing codes and device tokens are redacted from logs, with a test.
- **H-13** Given Socket.IO handshakes (later), then they require the device token too. Covered by the placeholder test in F1-01.
- **H-14** Given wrong pairing codes, then attempts are limited per code and per IP. After the limit, the code is dead. The numbers are a proposal [A] until JUPITER confirms (threat-model open question 8). Token lifetime [A: 180 days, renewed on use] and cookie-clearing behaviour (the device registers again with a new code) are confirmed at G3.
- **Isolation:** a code or token of restaurant A is never accepted by B.
- **Role:** the Encargado adds devices. The Ostaru operator issues the first code only.
- **Tests:** unit tests for AC1–AC6, code expiry and single use, hashed token storage, attempt limits, Origin check, and an isolation test.
- **Design line:** r1–r4, r10 for the add-device and enter-code screens. No design exists for them (Q3), so G2 is needed. The screens may land after the backend; the backend is testable without them.
- **Out of scope:** device management products, native apps.

## Size and capacity note (for JANUS and ATHENA)
F1-05's backend plus the H criteria enlarge F1-a. JANUS's v2 breakdown is 17 tasks, about 14 person-days [E, low confidence], so F1-a may spill into week 3. Sizes: F1-05 stays M; F1-01 and F1-04 grow in effort but stay inside M. PERICLES has told JANUS in the 2026-10-22 handoff.
