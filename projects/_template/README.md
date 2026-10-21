# [Project name]

> **Project template.** Copy this whole `_template` folder to `projects/<project-name>/` to start a project, then fill in [00-charter/startup-workflow.md](00-charter/startup-workflow.md) and [status.md](status.md). The structure follows the [startup workflow](../../operating-model/startup-workflow.md), section 8.
>
> Only the CTO and CEO write in the vault (decision D-008). Other agents deliver these documents in chat, and the CTO or CEO files them here.

| Field | Value |
|---|---|
| Purpose (one line) | TBD |
| Started | YYYY-MM-DD |
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
