# Stories F8 — Personal y ajustes

> Package v0.2 by PERICLES (Product Manager), filed 2026-10-21. **v0.3 on 2026-10-22** after the Owner bypass (all blockers cleared, Cycle 1 starts), ATHENA's decisions handoff and EUNOMIA's hardening criteria H-1 to H-14. See the [decision log](../../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

> Common acceptance criteria C1–C7 and the gate list are in the [stories README](README.md) and apply to every story here.

F8 is priority 5, so Cycle 2 [E]. (2026-10-22) F8 needs the G3 threat model for every story that touches sign-in, PINs, roles or devices. F8-04 no longer waits for F1-b: the device backend is in F1-a.

**F8-01 · Team list, add and deactivate** · `identity` · size M · G1 G2 G3 G4 G5 G6 G7
*As the Encargado, I want to see and manage my team, so only current staff can sign in.*
- **AC1** The list shows name, role, PIN state (set or not set), last access and active flag.
- **AC2** Given the Encargado adds a person with a name and role, then they appear in the list.
- **AC3** Given a person is deactivated, then they can't sign in.
- **AC4** The last active Encargado can't be deactivated or demoted [A].
- **Isolation:** yes.
- **Role:** Encargado only.
- **Tests:** list data, add, deactivate, AC4, role denial, isolation.
- **Design line:** r1–r4, r10, r17.
- **Out of scope:** HR data, invitations by email.

**F8-02 · Set and change PIN** · `identity` · size S · G1 G3 G4 G5 G6 G7
*As the Encargado, I want to set or change a PIN, so staff can sign in.*
- **AC1** Given a valid PIN is set, then PIN state changes to "set". The PIN is never shown again [A].
- **AC2** Given an invalid PIN, then it is rejected. The rules come from JUPITER (Q7).
- **AC3** Given a PIN is changed, then that person's sessions end [A]. Who and when are recorded.
- **Isolation:** yes.
- **Role:** Encargado only.
- **Tests:** valid and invalid PINs, session end, role denial, isolation.
- **Design line:** r10, r17.
- **Out of scope:** self-service PIN reset.

**F8-03 · Permission matrix and role change** · `identity` · size S · G1 G2 G3 G4 G5 G6 G7
*As the Encargado, I want to see what each role can do and change someone's role.*
- **AC1** The matrix matches r17 exactly.
- **AC2** Given a role change, then it applies on the person's next action and is logged.
- **AC3** F8-01 AC4 also applies here.
- **Isolation:** yes.
- **Role:** Encargado only.
- **Tests:** the matrix against the F1-03 table, role change effect, role denial, isolation.
- **Design line:** r17.
- **Out of scope:** custom permissions.

**F8-04 · Devices list and disconnect** · `identity` · size S · G1 G2 G3 G4 G5 G6 G7
*As the Encargado, I want to see devices and disconnect one, so a lost phone is cut off.*
- **AC1** The list shows each device with a CONECTADO (green) pill or its disconnected state, and last seen.
- **AC2** Given the Encargado disconnects a device, then its device token is revoked at once, its sessions end, and it can no longer sign in [V: CTO Q8, item 2, point 5] (2026-10-22).
- **Isolation:** yes.
- **Role:** Encargado only.
- **Tests:** list, disconnect effect (token revoked, sessions ended), role denial, isolation.
- **Design line:** r7, r17.
- **Out of scope:** remote wipe. Depends on F1-05 (in F1-a).

**F8-05 · Restaurant data** · `tenancy` · size S · G1 G2 G4 G5 G6 G7
*As the Encargado, I want to maintain the restaurant's name, address and phone.*
- **AC1** The data saves, and empty fields show placeholders like [DIRECCIÓN] (r11).
- **Isolation:** A edits only A.
- **Role:** Encargado only.
- **Tests:** save, placeholder, role denial, isolation.
- **Design line:** r3, r4, r10, r11.
- **Out of scope:** logo, opening hours (F4).

**F8-06 · Demo-mode toggle** · `tenancy` · size S · G1 G2 G4 G5 G6 G7
*As the Encargado, I want to turn demo mode off when real service starts.*
- **AC1** Given demo mode is on, then the overline "DATOS DE DEMOSTRACIÓN" shows on every screen (r12).
- **AC2** Given the Encargado turns it off after confirming, then the overline disappears. The change is logged with who and when [A].
- **Isolation:** yes.
- **Role:** Encargado only.
- **Tests:** toggle both ways, overline, role denial, isolation.
- **Design line:** r12.
- **Out of scope:** the customer-app DEMO notice and test-code orders (Release 2).
