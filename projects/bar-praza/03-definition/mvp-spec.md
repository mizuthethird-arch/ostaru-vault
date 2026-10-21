# MVP spec v0.2 — Bar Praza Release 1 (restaurant dashboard)

> Delivered by PERICLES (Product Manager) in chat on 2026-10-21 as planning package v0.2, and filed by the CTO (ATHENA) on 2026-10-21 without content changes. **Since it was drafted, the CEO approved S1–S7, the rule 19 deviation, ADR-002 and ADR-003, and settled Q2 (chat only, the CEO commits). The CTO decided Q8.** See the [decision log](../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

**Bar Praza, Release 1: restaurant dashboard**
- Version 0.2 DRAFT, owned by the PM. It supersedes the CTO draft v0.1.
- Approved by: pending. The Head of Product approves G1, and the CEO approves the MVP plan (workflow Phase 2).

## Decisions applied
**CEO:**
- Bar Praza is built as a multi-restaurant SaaS (D-016).
- Release 1 is the dashboard F1–F11. The customer app and online payments are Release 2 (D-019).
- UX/UI design line v1.0.0 is binding (D-017).
- ADR-001 is accepted. ADR-002 and ADR-003 are pending, and Cycle 1 waits for them.

**SOLON (CEO approval pending):**

| # | Decision | Effect in this spec |
|---|---|---|
| S1 | F1–F11 stay. Out: customer app, online payments, customer accounts, self-service onboarding, SaaS billing, native apps, tickets/invoices, WhatsApp API, card-terminal integration | Out-of-scope list |
| S2 | WhatsApp/phone is a staff-entered channel (name, phone, pickup time). Rule 19 deviation to log | New channel in F5, F7, F10 |
| S3 | A product can't be "visible in app" until its allergens are marked reviewed (who, when). "No allergens" is confirmed explicitly. Staff ordering is never blocked | F2-03, F2-04 |
| S4 | Capacity rules and pause apply to pickup orders only | F4, F11 |
| S5 | No customer profiles from staff-entered orders. Phone is order data, masked in lists. JUPITER sets retention | F5, F7, F9 |
| S6 | No tickets or invoices. "Cobrado" is an internal status | F5, F7 |
| S7 | F6 and F7 need approved designs (G2) before build | Backlog, Cycle plan |

## Goal
Test the riskiest Release 1 assumption, that Bar Praza's staff will run service on the dashboard [V: SOLON priority rationale]. That proves the restaurant side before customers order on their own [V: v0.1].

## Users and main flow
- **Roles:** Encargado, Sala y barra, Cocina [V: design line r17]. Ostaru operators create restaurants (S1).
- **Flow:**
  1. The Encargado sets up the team, PINs, menu with allergens, hours and stock.
  2. Staff take orders on a phone for Barra, Mesa N, or WhatsApp/teléfono (name, phone, pickup time), and charge at the bar.
  3. Kitchen and bar move each order NUEVO → PREPARANDO → LISTO → Recogido/Cobrado on the live console.
  4. The Encargado checks the summary, orders, stock and reports.

## In scope

| # | Feature | Module(s) | Milestone | Priority order |
|---|---|---|---|---|
| F1 | Foundation | tenancy, identity | M1 | 2 |
| F2 | Carta y productos | catalog | M1 | 4 |
| F8 | Personal y ajustes | identity, tenancy | M1 | 5 |
| F7 | Tomar pedido (móvil) | ordering | M1 | 6 |
| F6 | Consola en vivo | ordering (real time) | M1 | 7 |
| F5 | Pedidos | ordering | M1 | 8 |
| F4 | Horario y pedidos | scheduling | M2 | 9 |
| F3 | Stock | inventory | M2 | 10 |
| F10 | Informes | reporting | M2 | 11 |
| F11 | Resumen | reporting | M2 | 12 |
| F9 | Clientes | customers | M2 | 13 |

Platform items P-01 and P-02 come first (order 1) and the UI shell UI-01/02 is order 3.

- **M1, "shadow service":** Bar Praza runs a real service on the dashboard beside its usual way. It needs items 1–8 [V: SOLON].
- **M2:** Release 1 complete.

## Out of scope
- **S1 list** [V]: customer app, online payments, customer accounts, self-service onboarding, SaaS billing, native apps, tickets/invoices, WhatsApp API, card-terminal integration.
- **S5:** customer profiles from staff-entered orders.
- **Other:**
  - Operator back-office UI, a restaurant switcher, and users in several restaurants [A, Q6].
  - Capacity limits on Mesa and Barra orders [A, Q4].
  - Languages other than Spanish [V: design line r10].

## Features and acceptance criteria
Stories refine these (section 2).

**F1 Foundation**
- Given restaurants A and B, when a user of A uses any screen or API, then nothing of B is returned. Isolation tests cover every module [V: ADR-003].
- Given staff with a PIN, when they sign in, then they get only their role's permissions (r17). Sign-in is limited to registered devices from F1-05 [V: v0.1].
- Given Ostaru creates a restaurant, then it has an isolated data space and a first Encargado, and it starts in demo mode [A: default on]. Given demo mode is on, every screen shows "DATOS DE DEMOSTRACIÓN" (r12), and only the Encargado turns it off.

**F2 Carta y productos**
- Categories can be created, renamed and reordered.
- Products have a name, description, photo, one or more variants with prices (r14, r9), the 14 EU allergens (r13), and flags: visible in app, plato del día, bar only, archive.
- **S3:** a product can't be "visible in app" until its allergens are reviewed (who, when). "No allergens" needs explicit confirmation. Staff ordering is never blocked.
- The optional stock link moves to F3, which is built after F2 [A].
- Editing happens in a side panel (r4). Only the Encargado edits the menu [V: r17 grants the other roles only the actions it lists].

**F3 Stock**
- Items have a unit, level, minimum and linked products.
- Movements are entrada, merma or recuento, each logged with who and when.
- Stock is deducted when an order is Cobrado [V: ADR-001 `OrderCharged`]. At 0 with auto-sold-out on, the product shows AGOTADO (auto) and is hidden from ordering. A shopping list covers items below minimum.

**F4 Horario y pedidos**
- Weekly hours, special closures, minimum preparation time, last order before closing, maximum orders per 15 minutes, and a live state with pause for X minutes.
- **S4:** the rules and pause apply to pickup orders only, enforced on the server. "Pickup order" means an order with a pickup time, which is WhatsApp/teléfono now and App in Release 2 [A, Q4].

**F5 Pedidos**
- List with search, period, channel (Barra, Mesa, WhatsApp/teléfono; App from Release 2) and status filters, plus CSV export.
- Detail shows customer or table, masked phone (S5), pickup time, items with variants, total, payment mode and a timestamped history.
- A late order shows RETRASADO N MIN, with "Llamar al cliente" and "Cancelar pedido" (Encargado only).
- No ticket or invoice is produced (S6). The CSV never includes unmasked phones [A, Q7].

**F6 Consola en vivo**
- The board by status updates on every connected device within [3] s [A: CTO to confirm].
- Late orders are highlighted. CONECTADA is visible, the board reconnects automatically, and an offline message shows when disconnected.
- **Build needs an approved design first (S7).**

**F7 Tomar pedido (móvil)**
- Staff choose Barra, Mesa N, or WhatsApp/teléfono with name, phone and pickup time (S2), then add products and variants and send the order to the console.
- Charging records cash or card terminal as a manual mark, and sets Cobrado (S6, S1).
- Staff ordering is never blocked by allergen state (S3).
- F4 rules aren't enforced in M1 because F4 is built after M1 [A, Q4].
- **Build needs an approved design first (S7).**

**F8 Personal y ajustes**
- Team list with role, PIN state, last access and active flag.
- Add a person; set or change a PIN.
- Permission matrix per r17: the Encargado has everything; Sala y barra takes orders, charges, changes status and marks sold out; Cocina changes status and marks sold out.
- Devices list with disconnect. Restaurant data. Demo-mode toggle.

**F9 Clientes**
- **S5:** staff-entered orders create no profiles, which also matches r18. In Release 1 the screen has its structure, an empty state and the "Solicitudes de datos" panel (manual handling) [A, Q5].
- Phone is order data, masked in lists, with retention set by JUPITER.

**F10 Informes**
- KPIs, orders per day by channel, top products, peak hours, late orders, and export.
- "App vs WhatsApp" shows WhatsApp/teléfono only until Release 2 [A].

**F11 Resumen**
- Today's orders, sales and average ticket, channel comparison, today's orders table, quick menu availability, hours card, and pause (pickup only, S4).

## Success metrics

| Metric | Target | Measured how |
|---|---|---|
| M1 reached | One real shadow service on the dashboard [V: SOLON] | Service log |
| Services run on the dashboard without paper or WhatsApp-only fallback | [N] [A: v0.1 leaves N open, Q11] | Orders logged per service |
| Visible products with allergens reviewed | 100 % [V: S3 enforces it] | Catalog report |
| Orders ready on time | [90] % [A: from v0.1] | F10 "collected on time" |
| Second restaurant set up by configuration only | Under [1] day, no code changes [A: from v0.1] | Onboarding run by Ostaru |

## Risks

| # | Risk |
|---|---|
| K-1 | Data leaking between restaurants (Critical) [V: discovery report]. Hence the platform and F1 come first |
| K-2 | Late or lost orders on bad bar Wi-Fi (F6) |
| K-4 | Wrong allergen data. S3 is the mitigation |
| K-5 | Scope too large for the team |
| K-6 | Frontend and design roles inactive |
| K-7 | Spanish legal obligations unverified. S6 removes tickets and invoices from scope, but the obligations remain unconfirmed (Q10) |
| K-8 | No approved design for F6, F7 or sign-in (Q3) |
| K-9 | Tests can't be run until Q2 is settled |
| K-10 | The estimate has no basis until the Leads estimate (section 3) |

## Open questions

| # | Owner | Question |
|---|---|---|
| Q1 | CEO | Approve S1–S7, and approve the S2 deviation from design-line r19 |
| Q2 | CEO | How code reaches the repository and where tests run |
| Q3 | CEO / SOLON | Activate the Product Designer (PHIDIAS). Designs needed: live console, staff mobile ordering including WhatsApp/teléfono capture, and sign-in/PIN screen (none is listed in the design line) |
| Q4 | SOLON | Confirm "pickup order" = has a pickup time. Mesa and Barra are never limited. F7 runs without F4 rules in M1 |
| Q5 | SOLON | Keep F9 in Release 1 (S1 says yes) or move it to Release 2, since the priority rationale says it has little data before then |
| Q6 | SOLON / CEO | Release 1 has no operator UI. Ostaru creates restaurants by a non-UI route. A user belongs to one restaurant |
| Q7 | JUPITER | Retention for staff-entered phones. PIN rules and lockout. Interim G3 approver (Red Team Lead is vacant). Export masking |
| Q8 | CTO | Confirm the [3] s target. Choose the device-registration mechanism. Decide photo storage (ADR-002 lists none). Decide whether P-01 is Phase 3 pre-work or in Cycle 1 (workflow says repo, CI and environments are ready before Cycle 1) |
| Q9 | SOLON | What separates Recogido from Cobrado? v0.1 says stock is deducted on "collected or charged", while ADR-001 says `OrderCharged` |
| Q10 | CEO | Tickets and invoices obligations, to confirm before M1 (Business Operations is vacant) |
| Q11 | SOLON | Metric targets (N services, 90 %, under 1 day) |
| Q12 | CEO / SOLON | Design tokens: exact values need the design source file. UI-01 starts from the approximate PDF values [V: design line] |

## Changes from CTO draft v0.1
- S1–S7 applied.
- The WhatsApp/teléfono channel is adopted.
- The stock link moved from F2 to F3.
- F9 is reduced.
- The F2-04 visibility gate is added.
- M1/M2 milestones are added.
- Build order follows SOLON's priority list.
