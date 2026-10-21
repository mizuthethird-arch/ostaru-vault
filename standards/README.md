---
title: Design standards
rule: AGENT-RULES, section 9
status: PUBLISHED
version: 1.0.0
effective: 2026-10-21
---

# Design standards

Approved design lines that **every agent output must follow** ([AGENT-RULES](../AGENT-RULES.md), section 9): code and architecture, UX/UI and the design system, APIs, data, infrastructure, security, content and brand.

## Layout
- Company-wide: `standards/<area>/<standard>.md`. Areas: `code/`, `architecture/`, `ux-ui/`, `api/`, `data/`, `infrastructure/`, `security/`, `content-brand/`.
- Project-specific: `projects/<project-name>/standards/`. These take precedence for that project.
- Every standard starts from [_template/STANDARD.md](_template/STANDARD.md).

## Who approves
Per the [team charter](../operating-model/team-charter.md), and the Sponsor/Owner while the founder rule applies:

| Area | Owner | Approves |
|---|---|---|
| Code, architecture, infrastructure, APIs, data | CTO (with the relevant Lead) | CEO |
| UX/UI, design system | Head of Product, with the Product Designer | CEO |
| Security controls | CISO | CEO |
| Content and brand | Head of Marketing/Growth | CEO |

Only `APPROVED` standards are binding. `DRAFT` standards are proposals.

## Index

| Area | Standard | Version | Status | Owner | Approved |
|---|---|---|---|---|---|
| ux-ui (project: Bar Praza) | [Bar Praza UX/UI design line](../projects/bar-praza/standards/ux-ui-design-line.md) | 1.0.0 | APPROVED | Head of Product | CEO, 2026-10-21 |

Where no approved standard covers an output, agents say so and propose one rather than inventing a style silently. Company-wide code and architecture standards are not approved yet.
