# Backlog — Bar Praza Release 1 (PM-owned)

> Delivered by PERICLES (Product Manager) in chat on 2026-10-21 as planning package v0.2, and filed by the CTO (ATHENA) on 2026-10-21 without content changes. **Since it was drafted, the CEO approved S1–S7, the rule 19 deviation, ADR-002 and ADR-003, and settled Q2 (chat only, the CEO commits). The CTO decided Q8.** See the [decision log](../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

Gates are G1–G7 for every feature row. G3 is marked where personal data, auth or uploads apply [V: workflow §5]. Sizes are [E] relative sizes, to be replaced by the Leads' estimates.

| Order | ID | Item | Module | Owner(s) | Depends on | Gates | Size | Status |
|---|---|---|---|---|---|---|---|---|
| 1 | P-01 | Monorepo, Docker Compose, CI | platform | PROMETHEUS | ADR-002 approved; Q2 | G5 | M | NOT STARTED |
| 1 | P-02 | Architecture test | platform | PROMETHEUS, JANUS | P-01 | G5 | S | NOT STARTED |
| 1 | ADR-004 | Data-access spike (Drizzle vs Kysely with row-level security) | platform | JANUS (ADR by CTO) | P-01; ADR-003 approved | G5 | S | NOT STARTED |
| 2 | F1-a | F1-01 to F1-04 | tenancy, identity | JANUS, VULCAN | P-01, ADR-004 | G1 G3 G4 G5 G6 G7 | L | NOT STARTED |
| 2 | F1-b | F1-05 device registration | identity | JANUS, VULCAN | F1-a; Q8 | G1 G3 G4 G5 G6 G7 | M | NOT STARTED |
| 3 | UI-01 | Design tokens and atoms in Storybook | ui | CTO (interim) | P-01; Q12 | G2 G5 | M | NOT STARTED |
| 3 | UI-02 | Admin shell template | ui | CTO (interim) | UI-01 | G2 G5 | S | NOT STARTED |
| 4 | F2 | F2-01 to F2-06 | catalog | JANUS, VULCAN, CTO (UI) | F1-a, UI-02 | G1 G2 G4 G5 G6 G7 (G3 for F2-05) | L | NOT STARTED |
| 5 | F8 | F8-01 to F8-06 | identity, tenancy | VULCAN, CTO (UI), JANUS (contract) | F1-a (F8-04 needs F1-b) | G1–G7 incl. G3 | L | NOT STARTED |
| 6 | F7 | Tomar pedido (móvil) | ordering | JANUS, VULCAN, CTO (UI) | F2; **G2 design (S7)**; discovery 29 Oct | G1–G7 incl. G3 | L | HELD |
| 7 | F6 | Consola en vivo | ordering | JANUS, PROMETHEUS, CTO (UI) | F7; **G2 design (S7)** | G1–G7 (G3 if it shows customer data, EUNOMIA to confirm) | L | HELD |
| 8 | F5 | Pedidos | ordering | VULCAN, CTO (UI) | F7 | G1–G7 incl. G3 | M | HELD |
| | **M1** | **Shadow service** (items 1–8) | | | | | | |
| 9 | F4 | Horario y pedidos | scheduling | VULCAN, CTO (UI) | F1-a; Q4; discovery 29 Oct | G1 G2 G4 G5 G6 G7 | M | HELD |
| 10 | F3 | Stock | inventory | VULCAN, CTO (UI) | F2, F7 | G1 G2 G4 G5 G6 G7 | M | NOT STARTED |
| 11 | F10 | Informes | reporting | VULCAN | F5 | G1 G2 G5 G6 G7 | M | NOT STARTED |
| 12 | F11 | Resumen | reporting | VULCAN, CTO (UI) | F10 | G1 G2 G5 G6 G7 | M | NOT STARTED |
| 13 | F9 | Clientes | customers | VULCAN | F7; Q5; Q7 | G1–G7 incl. G3 | S | NOT STARTED |
| | **M2** | **Release 1 complete** | | | | | | |
| R2 | | Public customer app, online payments, customer accounts, self-service onboarding, SaaS billing | | | Release 1 | | | NOT PLANNED |

**Why this order** [V: SOLON]:
- Isolation (K-1) comes first.
- F7 tests the riskiest assumption, staff adoption, early.
- F4 mostly serves the app.
- F9 has little data before Release 2.

**Changes from the CTO draft:**
- F4 moves after M1, so F7 no longer depends on it.
- F3 now depends on F7 (it consumes `Cobrado`).
- G3 is added to F7, F5, F6 and F2-05.
- F1 is split into F1-a and F1-b.

**Dependencies by agent:**

| Who | What the plan needs |
|---|---|
| JANUS | Task breakdown and estimates; the ADR-004 spike; the F1-a API contract; the order lifecycle proposal |
| PROMETHEUS | P-01, P-02; environments; real-time infrastructure for F6 |
| MINOS | Test strategy and testability review (note: no QA Automation role; MINOS can't sign off tests it wrote itself) |
| EUNOMIA | G3 threat model for F1-a first, then F8, F7, F5 |
| CTO (interim frontend) | UI-01/02 and UI for 10 more items; G4 as interim Frontend Lead; "Cycle 1 ready" |
| JUPITER | Retention, PIN rules, interim G3 approver (Q7) |
| SOLON | G1 spec approval; Q4, Q5, Q6, Q9, Q11; designs for F6/F7 |
| CEO | S1–S7, ADR-002/003, Q2, Q3, Q10 |

## Estimate
- **SOLON's indicative plan** [E, low confidence]:

  | Cycle | Items |
  |---|---|
  | C1 | 1–3 |
  | C2 | 4–5 |
  | C3 | 6 |
  | C4 | 7–8 (M1) |
  | C5 | 9–10 |
  | C6 | 11–13 (M2) |

- **I can't replace it with a real estimate yet.** Phase 3 needs the Leads' task breakdown and estimates, and the prompts in section 5 request them.
- **Three things suggest six cycles is optimistic** [E]:
  - The CTO's 6–9 estimate assumed a full squad with frontend and design agents active.
  - 12 of 17 items share one interim frontend capacity.
  - F6 and F7 have no designs.
- **One thing cuts the other way:** the CTO's 6–9 cycles included the customer app and payments (T1, T6), which D-019 moved out.
- I'll recompute the estimate when the Leads reply.
