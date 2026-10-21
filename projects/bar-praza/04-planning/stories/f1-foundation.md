# Stories F1 — Foundation

> Delivered by PERICLES (Product Manager) in chat on 2026-10-21 as planning package v0.2, and filed by the CTO (ATHENA) on 2026-10-21 without content changes. **Since it was drafted, the CEO approved S1–S7, the rule 19 deviation, ADR-002 and ADR-003, and settled Q2 (chat only, the CEO commits). The CTO decided Q8.** See the [decision log](../../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

> Common acceptance criteria C1–C7 and the gate list are in the [stories README](README.md) and apply to every story here.

F1-a = F1-01 to F1-04 (Cycle 1). F1-b = F1-05 (Cycle 2 [E]).

**F1-01 · Tenant context and isolation** · `tenancy` · size M · G1 G3 G4 G5 G6 G7
*As Ostaru, I need every request to run inside exactly one restaurant, so no restaurant sees another's data.*
- **AC1** Given restaurants A and B with data, when a signed-in user of A calls any endpoint, then nothing of B is returned or changed.
- **AC2** Given a request with no resolvable restaurant, then it is refused and returns nothing.
- **AC3** Given the application-level filter is bypassed in a test, then the database layer still blocks B's rows (ADR-003, two layers; ADR-003 is pending).
- **Isolation:** this story is the foundation, and its tests are the template for every module.
- **Role:** none (no user action).
- **Tests:** unit tests for tenant context; integration tests across two restaurants, including the bypass case.
- **Design line:** none.
- **Out of scope:** UI, restaurant creation (F1-02), users in several restaurants [A].

**F1-02 · Restaurant creation by Ostaru** · `tenancy` · size S · G1 G3 G4 G5 G6 G7
*As an Ostaru operator, I want to create a restaurant with its first Encargado, so a new client is set up by configuration only.*
- **AC1** Given an operator creates "Bar Praza", then the restaurant exists with a first Encargado, demo mode on [A], and its own isolated data.
- **AC2** Given a second restaurant is created, then no code change is needed.
- **AC3** Given someone who isn't an Ostaru operator, then creation is refused.
- **Isolation:** each restaurant's data is invisible to the other.
- **Role:** Ostaru operator only; no restaurant role can create restaurants (S1).
- **Tests:** creation happy path and denied path, plus isolation between two created restaurants.
- **Design line:** none. There is no operator UI in Release 1, and the mechanism is JANUS's and the CTO's to decide [A, Q6].
- **Out of scope:** self-service sign-up, billing, operator back office, restaurant switcher.

**F1-03 · Staff, roles and permissions** · `identity` · size S · G1 G3 G4 G5 G6 G7
*As the Encargado, I want every staff member to have one role with fixed permissions, so people can do only their job.*
- **AC1** Given each role, when an action is attempted, then it is allowed or denied per the matrix: Encargado everything; Sala y barra takes orders, charges, changes status and marks sold out; Cocina changes status and marks sold out [V: r17].
- **AC2** Given a staff member of restaurant A, then they can't be assigned in or see restaurant B.
- **Isolation:** yes (AC2).
- **Role:** this is the permission system itself.
- **Tests:** a table-driven test of every role against every permission, plus the isolation test.
- **Design line:** r17.
- **Out of scope:** custom roles, per-user overrides [A], multi-restaurant staff.

**F1-04 · PIN sign-in** · `identity` · size M · G1 G2 G3 G4 G5 G6 G7
*As staff, I want to sign in with my PIN, so I can start my shift quickly with my role's permissions.*
- **AC1** Given an active staff member and their correct PIN, then they are signed in with their role, and the session is scoped to their restaurant.
- **AC2** Given a wrong PIN, then sign-in is refused with a Spanish error that doesn't reveal which part was wrong.
- **AC3** Given repeated wrong PINs, then a temporary block applies. The limit is set in the G3 threat model [A, Q7].
- **AC4** Given an inactive staff member, then sign-in is refused.
- **AC5** A PIN is never shown or stored readable [A].
- **Isolation:** a PIN of restaurant A never signs into B.
- **Role:** the pre-sign-in action is open to everyone; every later action follows F1-03.
- **Tests:** unit tests for AC1–AC5, and an isolation test.
- **Design line:** r5–r10 for a minimal PIN screen. No sign-in design exists (Q3), so G2 is needed. How a person is identified (select name or other) is undecided.
- **Out of scope:** device registration (F1-05), password reset, SSO.

**F1-05 · Device registration** (F1-b) · `identity` · size M · G1 G3 G4 G5 G6 G7
*As the Encargado, I want PIN sign-in limited to registered devices, so a stranger's phone can't be used.*
- **AC1** Given an Encargado registers a device, when staff sign in from it, then sign-in works.
- **AC2** Given an unregistered device, then PIN sign-in is refused.
- **AC3** A registered device appears in the F8-04 list.
- **Isolation:** a device registered to A is not accepted by B.
- **Role:** registering a device needs the Encargado.
- **Tests:** unit tests for AC1–AC3, and an isolation test.
- **Design line:** none until a UI is designed. The mechanism is for the CTO and JANUS to decide (Q8).
- **Out of scope:** device management products, native apps.
