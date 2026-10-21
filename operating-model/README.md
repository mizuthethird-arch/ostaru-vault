---
title: Operating model
owner: CEO (startup workflow, team charter); CTO (this page and the agent roster)
status: PUBLISHED
version: 1.0.0
effective: 2026-10-21
---

# Operating model

How Ostaru Company is organized and how work moves from idea to launch. Every agent reads these documents alongside its own persona.

| Document | What it defines | Owner |
|---|---|---|
| [team-charter](team-charter.md) | The 30 roles, levels, reporting lines, decision rights (authority matrix and vetoes), security operations, rooms, escalation and rules for AI agents | CEO |
| [startup-workflow](startup-workflow.md) | Phases 0–8 with their gates, the cycle loop, delivery gates G1–G8, handoff artifacts, project templates A–F and the project folder structure | CEO |
| [agent-roster](agent-roster.md) | Which agent fills which charter role, vacancies, interim cover and readiness gaps | CTO maintains; CEO decides activation |

Only the CEO approves changes to the charter and the workflow (charter header, change rule). Other agents propose changes in chat.

## How these documents fit with AGENT-RULES

1. **[AGENT-RULES](../AGENT-RULES.md) always applies.** The charter gives roles *decision rights*. It does not give *access*. Every file, tool, repository, cloud, browser or external action still needs explicit, task-specific permission (rules sections 2–3). Deploying, publishing, sending messages, running a Red Team test and spending money are all external actions.
2. **Founder rule.** While the CEO is the only human, every gate also needs CEO approval (charter section 1, workflow section 5). No agent passes a gate on its own, and no agent approves its own work.
3. **Where artifacts are recorded.** The workflow says work moves through written artifacts (workflow section 6). In the vault they live in the project folder (`projects/<name>/`, from [the template](../projects/_template/README.md)). Decisions go in `decision-log.md`, status goes in `status.md`, and ADRs go in `03-definition/adr/`. Because only the CTO and CEO write in the vault (decision D-008), other agents **deliver their artifacts in chat**, and the CTO or CEO files them. The one exception is each agent's own internal folder, `agents/<agent>/` (rules section 8).
5. **Design standards.** Approved standards in `standards/` (and a project's `standards/`) bind every output; reviews at gates G2 and G5 check conformance (rules section 9).
4. **If a persona and the charter disagree.** The rules (section 1) list personas before other approved records, while the charter calls itself the source of truth for structure. Until the CEO says which wins, a conflict is **escalated to the CEO, not resolved silently** (rules section 1, charter section 10). Known conflicts are in [agent-roster](agent-roster.md), sections 2–3.

## Mapping of charter terms to the vault

| Charter or workflow term | In Ostaru |
|---|---|
| "team-charter-template.md" | [team-charter](team-charter.md) |
| Decision log | The project's `decision-log.md`; company-wide decisions in [general-context](../general-context.md), section 6 |
| Roadmap | Not created yet (owned by the CEO and the Head of Product) |
| API contracts | The project's folder (owned by the Backend Lead, [JANUS](../agent-personas/JANUS.md)) |
| Rooms | Shared working sessions for the listed members. The platform used for rooms is not chosen yet. |
| Founder | The Sponsor/Owner, who is also the CEO |
