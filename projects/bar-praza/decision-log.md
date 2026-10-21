# Decision log — Bar Praza

> Add each decision as a new entry at the top (workflow template E). Mark whether it is an **executive decision** (CEO) or an **agent recommendation**.

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
