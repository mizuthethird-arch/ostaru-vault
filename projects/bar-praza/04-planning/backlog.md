# Backlog — Bar Praza Release 1 (PM-owned)

> Delivered by PERICLES (Product Manager) in chat on 2026-10-21 as planning package v0.2, and filed by the CTO (ATHENA) on 2026-10-21 without content changes. **Updated by PERICLES on 2026-10-22** for the CEO's approvals (S1–S7, rule 19 deviation, ADR-003, stack v2 / ADR-006), the code-delivery decision (chat only, the CEO commits), Rules 8–10 and the CTO's Q8 decisions. See the [decision log](../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

Gates are G1–G7 for every feature row. G3 is marked where personal data, auth or uploads apply [V: workflow §5]. Sizes are [E] relative sizes, to be replaced by the Leads' estimates. Agents do not run tests (Rule 9): every row stays IMPLEMENTED—NOT VERIFIED until the owner runs the tests and reports.

**Phase 3 pre-work (before "Cycle 1 ready"):** P-01 (monorepo with npm workspaces, Docker Compose, GitHub Actions CI; [ADR-006](../03-definition/adr/ADR-006-technology-stack-v2.md)). Owner PROMETHEUS [V: CTO Q8]. It needs a private repository and a CI service from the CEO (Q13). It is finished when it is merged with CI green.

| Order | ID | Item | Module | Owner(s) | Depends on | Gates | Size | Status |
|---|---|---|---|---|---|---|---|---|
| 1 | P-01 | Monorepo, Docker Compose, CI | platform | PROMETHEUS | Q13 (CEO repository and CI) | G5 | M | PRE-WORK |
| 1 | P-02 | Architecture test (dependency-cruiser) | platform | PROMETHEUS, JANUS | P-01 | G5 | S | NOT STARTED (pre-work if time allows, else Cycle 1 week 1) |
| 1 | ADR-004 | Data access: **Kysely accepted** (Drizzle is the fallback) | platform | CTO | ADR-003 | — | S | DONE (accepted) |
| 2 | F1-a | F1-01 to F1-05 (incl. pairing backend), H-1 to H-14 | tenancy, identity | JANUS, VULCAN | P-01, ADR-004 | G1 G3 G4 G5 G6 G7 | L (≈14 person-days [E]; may spill to week 3) | READY |
| 3 | UI-01 | Design tokens (Tailwind theme) and atoms in Storybook | ui | CTO (interim) | P-01; Q12 | G2 G5 | M | NOT STARTED |
| 3 | UI-02 | Admin shell template | ui | CTO (interim) | UI-01 | G2 G5 | S | NOT STARTED |
| 4 | F2 | F2-01 to F2-06 | catalog | JANUS, VULCAN, CTO (UI) | F1-a, UI-02; F2-05 also needs MinIO in Compose ([ADR-005](../03-definition/adr/ADR-005-file-storage.md)) | G1 G2 G4 G5 G6 G7 (G3 for F2-05) | L | NOT STARTED |
| 5 | F8 | F8-01 to F8-06 | identity, tenancy | VULCAN, CTO (UI), JANUS (contract) | F1-a | G1–G7 incl. G3 | L | NOT STARTED |
| 6 | F7 | Tomar pedido (móvil) | ordering | JANUS, VULCAN, CTO (UI) | F2; **G2 design (S7)**; discovery 29 Oct | G1–G7 incl. G3 | L | HELD |
| 7 | F6 | Consola en vivo (target 3 s at p95 [V: CTO Q8]) | ordering | JANUS, PROMETHEUS, CTO (UI) | F7; **G2 design (S7)** | G1–G7 (G3 if it shows customer data, EUNOMIA to confirm) | L | HELD |
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

**Changes on 2026-10-22 (v0.3):**
- Owner bypass: G1 passed, Cycle 1 ready. Open checklist items are tracked, not blockers.
- F1-b merged into F1-a (pairing backend). F1-a grows to about 14 person-days [E, JANUS].
- ADR-004 accepted (Kysely). JUPITER is interim G3 approver.
- Q4, Q5, Q6 have working answers; Q9 is due before F3, Q11 before M1.

**Changes earlier on 2026-10-22:**
- P-01 is Phase 3 pre-work. The ADR-002 dependency is removed (ADR-006 supersedes it).
- The ADR-004 spike becomes Part B by online research, because agents do not run code (Rule 9). No "P-01" dependency remains for it.
- F1-b names the pairing-code mechanism. F2-05 no longer waits for a storage decision (ADR-005).

**Dependencies by agent:**

| Who | What the plan needs |
|---|---|
| JANUS | Task breakdown and estimates; ADR-004 Part B; the F1-a API contract; the `identity` design for devices; the order lifecycle proposal |
| PROMETHEUS | P-01 (pre-work), P-02; MinIO for F2-05; real-time infrastructure for F6 |
| MINOS | Test strategy and testability review (no QA Automation role; MINOS can't sign off tests it wrote itself) |
| EUNOMIA | G3 threat model for F1-a first, then F1-05, F8, F7, F5, F2-05 |
| CTO (interim frontend) | UI-01/02 and UI for 10 more items; G4 as interim Frontend Lead; "Cycle 1 ready" |
| JUPITER | Retention, PIN rules, interim G3 approver (Q7) |
| SOLON | G1 spec approval; Q4, Q5, Q6, Q9, Q11; designs for F6/F7 |
| CEO | Q13 (private repository and CI), Q3, Q10, Q12; runs the tests and reports results |

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

- **I can't replace it with a real estimate yet.** Phase 3 needs the Leads' task breakdowns and estimates, which the handoff prompts request. Stack v2 means JANUS and PROMETHEUS must redo theirs.
- **Reasons six cycles may be optimistic** [E]:
  - The CTO's 6–9 estimate assumed a full squad with frontend and design agents active.
  - 12 of 17 items share one interim frontend capacity.
  - F6 and F7 have no designs.
- **One reason in the other direction:** the CTO's 6–9 cycles included the customer app and payments (T1, T6), which D-019 moved out.
- I'll recompute the estimate when the Leads reply.
