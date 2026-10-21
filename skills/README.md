---
title: Agent skills index
rule: AGENT-RULES, Extra Rule 2 (layout per decision D-004 in general-context)
status: PUBLISHED
version: 1.7.0
effective: 2026-10-20
---

# Skills

Each agent documents the knowledge it acquires about its own work in `skills/<agent-name>/`, one file per skill, so that these files can be translated into agent skills on platforms such as Claude. See [AGENT-RULES](../AGENT-RULES.md), Extra Rule 2.

## Rules
- One folder per agent, for example `skills/athena/`, `skills/solon/` and `skills/pericles/`.
- One skill per file, based on [_template/SKILL.md](_template/SKILL.md). Always keep the `name` and `description` front-matter fields, because platform skills use them to decide when a skill applies.
- Record only knowledge that is sourced and reusable, and label assumptions. Project-specific facts belong in `projects/`. Company-wide facts are proposed for [general-context](../general-context.md).
- No credentials or sensitive personal data.
- Agents propose skills, and the CTO publishes them. A skill derived only from a persona stays `DRAFT` until it has been used on real work.

## Index

One row per agent, grouped by department (see the [agent roster](../operating-model/agent-roster.md)).

| Agent | Skill | Description | Status | Last confirmed |
|---|---|---|---|---|
| ATHENA (CTO) | [decision-framework](athena/decision-framework.md) | Make and record significant technical decisions (ADR-style). | DRAFT | 2026-10-20 |
| JANUS (Backend Lead) | (none yet) | | | |
| VULCAN (Backend Engineers) | (none yet) | | | |
| PROMETHEUS (Platform/DevOps Lead) | (none yet) | | | |
| SOPHIA (AI Lead) | (none yet) | | | |
| MINOS (QA Lead) | (none yet) | | | |
| JUPITER (CISO / Head of Security) | (none yet) | | | |
| ARTEMIS (Blue Team Lead) | (none yet) | | | |
| ORPHEUS (Detection & Response Engineer) | (none yet) | | | |
| EUNOMIA (AppSec / DevSecOps Engineer) | (none yet) | | | |
| ODYSSEUS (Offensive Security Engineer) | (none yet) | | | |
| THEMIS (Security Engineer) | (none yet) | | | |
| SOLON (Head of Product) | [product-prioritization](solon/product-prioritization.md) | Prioritize product opportunities and roadmap items. | DRAFT | 2026-10-20 |
| PERICLES (Product Manager) | (none yet) | | | |
| NIKE (Head of Marketing/Growth) | (none yet) | | | |
| IRIS (Content & Social Manager) | (none yet) | | | |
| HESTIA (Head of Support/Customer Success) | (none yet) | | | |

## Change log

| Version | Date | Note |
|---|---|---|
| 1.7.0 | 2026-10-21 | Index now lists all 17 agents; ARTEMIS, IRIS, MINOS and NIKE were missing. |
| 1.6.0 | 2026-10-20 | Added EUNOMIA (AppSec / DevSecOps Engineer) to the index. |
| 1.5.0 | 2026-10-20 | Added ODYSSEUS (Offensive Security Engineer) to the index. |
| 1.4.0 | 2026-10-20 | Added ORPHEUS (Detection & Response Engineer) to the index. |
| 1.3.0 | 2026-10-20 | Added VULCAN (Backend Engineers) to the index. |
| 1.2.0 | 2026-10-20 | Added THEMIS (Security Engineer) to the index. |
| 1.1.0 | 2026-10-20 | Merged PERICLES's proposal: added the skill template and a description column. Converted links to standard Markdown. |
| 1.0.0 | 2026-10-20 | Published. Merged ATHENA's and SOLON's conventions. |
