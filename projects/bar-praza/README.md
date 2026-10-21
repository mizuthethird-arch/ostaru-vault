# Bar Praza (multi-restaurant ordering SaaS)

> A client project for **Bar Praza**, a Galician tapas bar, **built from day one as a multi-restaurant SaaS** that Ostaru can offer to any other restaurant (CEO, 2026-10-21). Bar Praza is the first restaurant (tenant). **Release 1 = the restaurant dashboard; the public app comes last (CEO, 2026-10-21).** Definition is drafted: [MVP spec](03-definition/mvp-spec.md), [ADR-001](03-definition/adr/ADR-001-modular-monolith.md) (accepted), [ADR-002 stack](03-definition/adr/ADR-002-technology-stack.md) and [ADR-003 tenancy](03-definition/adr/ADR-003-multi-tenancy.md) (waiting for the CEO), [backlog](04-planning/backlog.md) and [Cycle 1](04-planning/cycles/cycle-01.md). The [idea brief](01-idea/idea-brief.md) is still a draft for the CEO.
>
> **Approved design line:** [Bar Praza — Full Design Vision](<../../designs/Bar Praza — Full Design Vision-selection.pdf>), recorded as [standards/ux-ui-design-line.md](standards/ux-ui-design-line.md) (AGENT-RULES section 9).
>
> Only the CTO and CEO write in the vault (decision D-008). Other agents deliver their documents in chat, and the CTO or CEO files them here.

| Field | Value |
|---|---|
| Purpose (one line) | Ordering and management platform for restaurants: customer ordering app, admin panel, live console, staff mobile ordering, online payments. First client: Bar Praza. |
| Started | 2026-10-21 |
| Current phase | 0 Idea intake |
| Accountable owner | CEO |
| Status board | [status.md](status.md) |
| Decision log | [decision-log.md](decision-log.md) |

## Documents by phase

| Phase | Gate | Document | Owner | Template |
|---|---|---|---|---|
| — | — | [00-charter/team-charter.md](00-charter/team-charter.md) | CEO | Project overrides of the company charter |
| — | — | [00-charter/startup-workflow.md](00-charter/startup-workflow.md) | CEO | Project header of the workflow |
| 0 Idea intake | Idea brief exists | [01-idea/idea-brief.md](01-idea/idea-brief.md) | CEO | A |
| 1 Discovery | Go / No-go (CEO) | [02-discovery/discovery-report.md](02-discovery/discovery-report.md) | Head of Product | — |
| 1 Discovery | Go / No-go (CEO) | [02-discovery/go-no-go.md](02-discovery/go-no-go.md) | Head of Product, CEO decides | B |
| 2 Definition | MVP plan approved (CEO) | [03-definition/mvp-spec.md](03-definition/mvp-spec.md) | PM | C |
| 2 Definition | MVP plan approved (CEO) | [03-definition/adr/](03-definition/adr/ADR-000-template.md) | CTO | D |
| 2 Definition | MVP plan approved (CEO) | [03-definition/threat-model.md](03-definition/threat-model.md) | Red Team Lead + AppSec | — |
| 3 Planning | Cycle 1 ready (PM + CTO) | [04-planning/backlog.md](04-planning/backlog.md), [04-planning/cycles/](04-planning/cycles/cycle-template.md) | PM, Leads | — |
| 4–5 Build, Verify | Delivery gates G1–G8; release candidate approved | [05-security/](05-security/rules-of-engagement.md) | CISO | — |
| 6 Launch | Launch approved (CEO) | [06-launch/release-notes/](06-launch/release-notes/release-notes-template.md) | CEO, Platform | — |
| 8 Decide | Decision recorded | [decision-log.md](decision-log.md) | CEO | E |
| All | — | [status.md](status.md) | PM | F |

Phase 2 also needs a budget (owned by Business Operations, a vacant role). Until that role exists, the CEO supplies it, recorded in the MVP spec or the decision log.

## Project standards
- [UX/UI design line](standards/ux-ui-design-line.md): **APPROVED** (CEO, 2026-10-21). Every UI output for this project follows it.
- Company standards that also apply: [modular monolith](../../standards/architecture/modular-monolith.md) and [focused changes, always tested](../../standards/code/change-discipline-and-testing.md), both APPROVED.
