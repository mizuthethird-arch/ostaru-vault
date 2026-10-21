# Decision log — Bar Praza

> Add each decision as a new entry at the top (workflow template E). Mark whether it is an **executive decision** (CEO) or an **agent recommendation**.

## 2026-10-22 — Owner bypass: all blockers cleared; Cycle 1 starts
- Type: executive decision
- Decided by: CEO/Owner ("[BYPASS all blocking] right now i OWNER approve all", chat 2026-10-22)
- Decision, applied by the CTO:
  1. **Cycle 1 is ready and starts now.** Open checklist items become tracked items, not blockers.
  2. **G1 passed** for spec v0.2. Working answers from the spec are approved: Q4 a pickup order is one with a pickup time, and Mesa and Barra are never limited; Q5 F9 stays in Release 1 (reduced); Q6 no operator UI, one restaurant per user. **Q9** (Recogido vs Cobrado) must be answered before F3; **Q11** (metric targets) before M1.
  3. **JUPITER is the interim G3 approver** (Red Team Lead vacant). The idea brief is approved (status SIGNED).
  4. **Frontend work reviewer:** JANUS (module structure), SOLON (design line, G2), MINOS (tests); the Owner gives the final approval.
  5. **CTO decisions on JANUS's questions:** D1 option (1), the device pairing backend (F1-05) is pulled into F1-a, about +2.5 days [E]; D2 option (a), pick your name from the restaurant's list, then the PIN, with attempt limits per person and per device; first Encargado gets a one-time temporary PIN from the operator command and must change it at first sign-in; F1-02 uses the operator command instead of an API route (JUPITER reviews at G3); [ADR-004](03-definition/adr/ADR-004-data-access.md) accepted with **Kysely** (fallback Drizzle if the owner's one-line `set_config` check fails).
- Not bypassed: per-feature gates G3 to G7 still apply when a feature is built; the Owner may waive one only by a logged risk acceptance against a CISO or QA Lead veto. Items that were estimates stay labelled estimates.
- Revisit on: end of Cycle 1.

## 2026-10-21 — Rules 8, 9 and 10 recorded; concise answers; no running of code by agents
- Type: executive decision
- Decided by: CEO (Project instructions; chat 2026-10-21)
- Decision: agents write in their own area of the vault (Rule 8); no agent runs or tests code, the owner does, and software is compared by online research (Rule 9); chat answers are concise unless a complete report is requested (Rule 10). Recorded in AGENT-RULES v1.4.0, section 11. Effects here: JANUS's ADR-004 Part B is settled by research, and all agent-run test results are "agent-run, owner to re-run".
- Revisit on: CEO request.

## 2026-10-21 — Stack v2 approved; hosting Hostinger (later)
- Type: executive decision
- Decided by: CEO (chat, 2026-10-21: "ok we will use postgres... I approve")
- Consulted: CTO (advised against SQLite)
- Decision: React, TypeScript, Tailwind, Node.js, Express, PostgreSQL, Docker, Docker Compose, GitHub Actions, npm workspaces. Full list and rules in [ADR-006](03-definition/adr/ADR-006-technology-stack-v2.md), which supersedes [ADR-002](03-definition/adr/ADR-002-technology-stack.md). ADR-003 (row-level security), ADR-004, ADR-005 unchanged. Hosting is Hostinger, much later; until then only local Docker Compose. PROMETHEUS researches the Hostinger product online before any decision.
- Why: familiar tools for the CEO; PostgreSQL keeps tenant isolation enforced by the database (K-1).
- Revisit on: hosting decision (after Release 1).

## 2026-10-21 — CTO decisions on Q8: console target, device registration, photo storage, P-01 timing
- Type: CTO decision (technical; the CEO can overrule)
- Decided by: CTO (ATHENA)
- Decision: (1) the console target is 3 s at p95, ≤ 1 s typical; (2) devices are registered with a one-time 6-digit pairing code that issues a hashed, revocable device token, and PIN sign-in needs a device token of the same restaurant; (3) photos go to S3-compatible object storage ([ADR-005](03-definition/adr/ADR-005-file-storage.md)); (4) P-01 is Phase 3 pre-work and part of "Cycle 1 ready". Details: [Q8 decisions](handoffs/2026-10-21-ATHENA-Q8-decisions.md).
- Revisit on: G3 for F1-05 and F2-05.

## 2026-10-21 — Code delivery: chat only, CEO commits
- Type: executive decision
- Decided by: CEO (answer to PERICLES's question, 2026-10-21)
- Decision: agents deliver code in chat and the CEO commits it. Tests run in CI under the CEO's control; items stay IMPLEMENTED—NOT VERIFIED until the CEO reports the result.
- Revisit on: when the CEO decides to approve direct codebase work.

## 2026-10-21 — ADR-002 (stack) and ADR-003 (tenancy) accepted
- Type: executive decision
- Decided by: CEO (answer to PERICLES's question, 2026-10-21)
- Decision: [ADR-002](03-definition/adr/ADR-002-technology-stack.md) and [ADR-003](03-definition/adr/ADR-003-multi-tenancy.md) are Accepted. Cycle 1 may start once "Cycle 1 ready" is agreed.

## 2026-10-21 — SOLON decisions S1-S7 approved; rule 19 deviation approved
- Type: executive decision
- Decided by: CEO (answer to PERICLES's question, 2026-10-21)
- Decision: S1–S7 apply to Release 1, as applied in [MVP spec v0.2](03-definition/mvp-spec.md): S1 scope, S2 WhatsApp/phone staff-entered channel, S3 allergen review gate, S4 capacity and pause for pickup orders only, S5 no profiles from staff-entered orders, S6 no tickets or invoices, S7 designs before F6/F7. Orders may use the channel "WhatsApp/teléfono" (staff-entered) in addition to App, Mesa and Barra, a deviation from design-line rule 19, logged in the [design line](standards/ux-ui-design-line.md).
- Why: SOLON's product decisions, 2026-10-21.
- Revisit on: end of discovery, 29 Oct.

## 2026-10-21 — Planning package v0.2 filed
- Type: record
- Decided by: PERICLES (author), filed by the CTO
- Decision: MVP spec v0.2 supersedes the CTO draft v0.1. Filed: [spec](03-definition/mvp-spec.md), [stories F1/F2/F8](04-planning/stories/README.md) (new folder `04-planning/stories/`, CTO decision), [backlog](04-planning/backlog.md), [Cycle 1 plan](04-planning/cycles/cycle-01.md), [status](status.md), and seven handoffs `handoffs/2026-10-21-PERICLES-to-*.md`. PERICLES's two PROPOSED entries are replaced by the approved entries above, as PERICLES asked.

## 2026-10-21 — Planning handed to SOLON and PERICLES (Rules 6 and 7)
- Type: process correction, from the Sponsor's new rules
- Decided by: CEO (Project instructions, Rules 6 and 7)
- Decision: the CTO's draft MVP spec, backlog and Cycle 1 plan are handed to the Head of Product and the Product Manager to own. The CTO keeps architecture only (ADR-001 to ADR-003). Handoff prompts are in [handoffs/](handoffs/2026-10-21-ATHENA-to-SOLON.md).
- Revisit on: when SOLON's plan reaches PERICLES.

## 2026-10-21 — Build order: dashboard first, public app last
- Type: executive decision
- Decided by: CEO ("We need to start working first in all the dashboard (with the feature shown in image). The public part will be the last part.")
- Decision: Release 1 is the restaurant dashboard with every feature in the approved design (F1–F11 in the [MVP spec](03-definition/mvp-spec.md)). The public customer app and online payments come last (Release 2). The CEO directed work to move straight to definition for the dashboard.
- Why: CEO priority.
- Revisit on: end of Release 1.

## 2026-10-21 — Architecture: modular monolith (ADR-001, accepted); stack and tenancy (ADR-002 and ADR-003, proposed)
- Type: ADR-001 follows the CEO's Rule 3 (accepted). ADR-002 and ADR-003 are CTO recommendations that need CEO approval.
- Decision: see [ADR-001](03-definition/adr/ADR-001-modular-monolith.md), [ADR-002](03-definition/adr/ADR-002-technology-stack.md) and [ADR-003](03-definition/adr/ADR-003-multi-tenancy.md).
- Revisit on: CEO approval; then a Cycle 1 spike (ADR-004, data access).

## 2026-10-21 — Start Bar Praza; build it as a multi-restaurant SaaS
- Type: executive decision
- Decided by: CEO (chat, 2026-10-21)
- Consulted: CTO
- Decision: Bar Praza is a client project. It is built as a multi-restaurant SaaS so that Ostaru can offer it to any other restaurant. Bar Praza is the first restaurant.
- Why: one product to sell many times, instead of a one-off build.
- Revisit on: Phase 1 Go / No-go.

## 2026-10-21 — MVP scope
- Type: executive decision
- Decided by: CEO
- Decision: the MVP includes the customer ordering app, the admin panel, the live console with staff mobile ordering, and online payments.
- Why: CEO choice.
- Revisit on: Phase 2 (MVP spec).

## 2026-10-21 — Approved design line
- Type: executive decision
- Decided by: CEO
- Decision: "Bar Praza — Full Design Vision" is the approved UX/UI design line for the project, recorded as [standards/ux-ui-design-line.md](standards/ux-ui-design-line.md).
- Why: AGENT-RULES section 9.
- Revisit on: when the missing screens (customer app, console, platform) are designed.

## 2026-10-21 — Recommended architecture direction (proposal, not decided)
- Type: agent recommendation (CTO)
- Decided by: not decided; the CEO approves architecture at the Phase 2 gate
- Decision (proposed): one codebase and one database for all restaurants, with every record scoped to a restaurant (tenant ID plus database-level row isolation); hosted payment checkout with per-restaurant payouts. See [discovery report, T3](02-discovery/discovery-report.md).
- Revisit on: Phase 2 ADRs.

---

## [YYYY-MM-DD] — [Decision title]
- Decided by:
- Consulted:
- Decision:
- Why:
- Revisit on:

---

### Risk acceptance (only to override a CISO or QA Lead veto; charter section 6)

## [YYYY-MM-DD] — Risk acceptance: [title]
- Decided by: CEO
- Veto overridden: CISO / QA Lead
- Risk:
- Reason:
- Expiry date:
- Fix owner:
