---
title: Agent skills index
rule: AGENT-RULES, Extra Rule 2 (layout per decision D-004 in general-context)
status: PUBLISHED
version: 2.0.0
effective: 2026-10-21
---

# Skills

Agents' local skills live in **each agent's internal folder**, `agents/<agent-name>/skills/`, one file per skill. They can be translated into agent skills on platforms such as Claude ([AGENT-RULES](../AGENT-RULES.md), section 8 and Extra Rule 2). This folder keeps the shared conventions and the template.

## Rules
- One skill per file, based on [_template/SKILL.md](_template/SKILL.md). Always keep the `name` and `description` front-matter fields, because platform skills use them to decide when a skill applies.
- An agent adds or updates a skill only in its own folder, and only after a change has been committed and approved by the Sponsor/Owner.
- Record only knowledge that is sourced and reusable, and label assumptions. Project-specific facts belong in `projects/`. Company-wide facts are proposed for [general-context](../general-context.md).
- No credentials or sensitive personal data.
- A skill derived only from a persona stays `DRAFT` until it has been used on real work.

## Index
The per-agent index, including skill and behavior counts, is in [agents/README](../agents/README.md). Current skills:

| Agent | Skill | Description | Status | Last confirmed |
|---|---|---|---|---|
| ATHENA (CTO) | [decision-framework](../agents/athena/skills/decision-framework.md) | Make and record significant technical decisions (ADR-style). | DRAFT | 2026-10-20 |
| SOLON (Head of Product) | [product-prioritization](../agents/solon/skills/product-prioritization.md) | Prioritize product opportunities and roadmap items. | DRAFT | 2026-10-20 |

## Change log

| Version | Date | Note |
|---|---|---|
| 2.0.0 | 2026-10-21 | Skills moved into each agent's internal folder, `agents/<agent>/skills/` (AGENT-RULES section 8). This page keeps the conventions, the template and a skills list. |
| 1.7.0 | 2026-10-21 | Index now lists all 17 agents; ARTEMIS, IRIS, MINOS and NIKE were missing. |
| 1.6.0 | 2026-10-20 | Added EUNOMIA (AppSec / DevSecOps Engineer) to the index. |
| 1.5.0 | 2026-10-20 | Added ODYSSEUS (Offensive Security Engineer) to the index. |
| 1.4.0 | 2026-10-20 | Added ORPHEUS (Detection & Response Engineer) to the index. |
| 1.3.0 | 2026-10-20 | Added VULCAN (Backend Engineers) to the index. |
| 1.2.0 | 2026-10-20 | Added THEMIS (Security Engineer) to the index. |
| 1.1.0 | 2026-10-20 | Merged PERICLES's proposal: added the skill template and a description column. Converted links to standard Markdown. |
| 1.0.0 | 2026-10-20 | Published. Merged ATHENA's and SOLON's conventions. |
