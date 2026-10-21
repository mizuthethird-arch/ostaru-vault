# Decision log — Bar Praza

> Add each decision as a new entry at the top (workflow template E). Mark whether it is an **executive decision** (CEO) or an **agent recommendation**.

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
