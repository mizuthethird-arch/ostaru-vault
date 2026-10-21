---
title: Team Charter & Authority Matrix (Ostaru Company)
owner: CEO (only the CEO approves changes)
status: PUBLISHED
version: "1.0"
effective: 2026-10-21
published_by: CTO (ATHENA), on CEO instruction
source: team-charter-template.md, supplied by the CEO in the Ostaru Company project on 2026-10-21
---

> **Vault note (CTO):** this is the CEO's charter template, applied to Ostaru Company. The only change is in the header table: the company name, the description ("not defined yet", per the CEO) and the date are filled in. Everything else is unchanged. Which agent fills each role is in [agent-roster](agent-roster.md). How this document relates to [AGENT-RULES](../AGENT-RULES.md) is explained in [operating-model/README](README.md). "team-charter-template.md" in the text refers to this file, and "startup-workflow.md" refers to [startup-workflow](startup-workflow.md).

# Ostaru Company — Team Charter & Authority Matrix

> **Source of truth** for team structure, reporting lines, decision rights, rooms and security rules.
> Every role (human or AI agent) follows this document. If a request conflicts with it, escalate — do not improvise.
> How work moves from idea to launch is defined in **startup-workflow.md**.

| Field | Value |
|---|---|
| Project / Company | Ostaru Company |
| One-line description | Not defined yet (CEO, 2026-10-20) |
| Version | 1.0 |
| Date | 2026-10-21 |
| Owner | Founder / CEO |
| Change rule | Only the CEO approves changes. Every change bumps the version and adds a changelog entry. |

---

## 1. Operating context

- This is a **full 30-role organization** used from day one to practice a real company workflow.
- Roles can be filled by **humans or AI agents**.
- **Founder rule:** while the founder is the only human, the founder holds final approval at every gate. No agent may pass a gate on its own.
- Roles are activated in **waves** (adjust per project):

| Wave | When | Roles activated |
|---|---|---|
| Wave 1 | Discovery → MVP | CEO, CTO, Head of Product, PM, Designer, Frontend, Backend, Platform, QA, AppSec |
| Wave 2 | First users / pilot | Support, Blue Team, Red Team, Data |
| Wave 3 | Selling / scaling | Marketing, AI, Business Operations, remaining roles |

---

## 2. Levels

| Level | Title | Scope |
|---|---|---|
| **L1** | Founder / CEO | Vision, budget, final decisions |
| **L2** | Department Heads (CTO, CISO, Heads) | Own a department, its strategy and standards |
| **L3** | Leads | Own a team, its quality and delivery |
| **L4** | Individual Contributors (ICs) | Own assigned work within an approved spec |

---

## 3. Organization chart

```
CEO (L1)
├── CTO (L2)
│   ├── Frontend Lead (L3)
│   │   ├── Frontend Engineer (L4)
│   │   └── Web / Performance Engineer (L4)
│   ├── Backend Lead (L3)
│   │   ├── Backend Engineer (L4) ×2
│   │   └── Payments / Integrations Engineer (L4)
│   ├── Platform / DevOps Lead (L3)
│   │   └── SRE (L4)
│   ├── AI Lead (L3)
│   │   ├── ML / LLM Engineer (L4)
│   │   └── Data Engineer / Analyst (L4)
│   └── QA Lead (L3)
│       └── QA Automation Engineer (L4)
├── CISO / Head of Security (L2)
│   ├── Red Team Lead (L3)                 🔴 attackers
│   │   └── Offensive Security Engineer (L4)
│   └── Blue Team Lead (L3)                🔵 defenders
│       ├── Detection & Response Engineer (L4)
│       └── AppSec / DevSecOps Engineer (L4)
├── Head of Product (L2)
│   ├── Product Manager (L3)
│   └── Product Designer (incl. UX research) (L3)
├── Head of Marketing / Growth (L2)
│   └── Growth Marketer (L4)
├── Head of Support / Customer Success (L2)
│   └── Support Agent (L4)
└── Business Operations (finance, legal, people) (L2)
```

**Why the CISO reports to the CEO:** the Red Team attacks what Engineering builds. Security must be able to report findings and block releases without being overruled by the team that built the system.

---

## 4. Roster (30 roles)

| # | Role | Level | Reports to | Responsibilities | Owns (outputs) |
|---|---|---|---|---|---|
| 1 | Founder / CEO | L1 | — | Vision, priorities, budget, final decisions | Company roadmap, this charter |
| 2 | CTO | L2 | CEO | Architecture, tech stack, engineering standards, technical feasibility | Architecture decision records (ADRs) |
| 3 | Frontend Lead | L3 | CTO | Frontend architecture, component library, code review | Frontend standards |
| 4 | Frontend Engineer | L4 | Frontend Lead | UI features | Frontend features |
| 5 | Web / Performance Engineer | L4 | Frontend Lead | Performance, offline, PWA, accessibility | Performance budget |
| 6 | Backend Lead | L3 | CTO | API design, data model, backend review | API contracts |
| 7 | Backend Engineer | L4 | Backend Lead | Services, business logic | Backend features |
| 8 | Backend Engineer | L4 | Backend Lead | Services, business logic | Backend features |
| 9 | Payments / Integrations Engineer | L4 | Backend Lead | Payments, third-party integrations | Integration modules |
| 10 | Platform / DevOps Lead | L3 | CTO | Containers, CI/CD, infrastructure as code, environments | Pipelines, environments |
| 11 | SRE | L4 | Platform Lead | Monitoring, uptime, backups, on-call | SLOs, runbooks |
| 12 | AI Lead | L3 | CTO | AI strategy and features | AI roadmap, model evals |
| 13 | ML / LLM Engineer | L4 | AI Lead | Models, prompts, evaluation suites | AI features |
| 14 | Data Engineer / Analyst | L4 | AI Lead | Pipelines, analytics, metrics | Data models, dashboards |
| 15 | QA Lead | L3 | CTO | Test strategy, quality gates | Test plans, QA sign-off |
| 16 | QA Automation Engineer | L4 | QA Lead | E2E and regression suites | Automated tests |
| 17 | CISO / Head of Security | L2 | CEO | Security strategy, risk register, compliance | Risk register, security policy |
| 18 | Red Team Lead | L3 | CISO | Attack campaigns, rules of engagement, threat modeling | Campaign reports |
| 19 | Offensive Security Engineer | L4 | Red Team Lead | Pentests of app, API, cloud; phishing simulations | Findings reports |
| 20 | Blue Team Lead | L3 | CISO | Defense architecture, incident response, incident command | IR playbooks, postmortems |
| 21 | Detection & Response Engineer | L4 | Blue Team Lead | Logging, alerts, threat hunting, first response | Detection rules |
| 22 | AppSec / DevSecOps Engineer | L4 | Blue Team Lead | Secure code review, security scans in CI, secrets, hardening | Security checks |
| 23 | Head of Product | L2 | CEO | Product strategy, priorities, success metrics | Product roadmap |
| 24 | Product Manager | L3 | Head of Product | Specs, backlog, cycle planning, delivery coordination | Specs, backlog |
| 25 | Product Designer | L3 | Head of Product | UX / UI, design system, user research | Designs, design system |
| 26 | Head of Marketing / Growth | L2 | CEO | Positioning, brand, acquisition | Go-to-market plan |
| 27 | Growth Marketer | L4 | Head of Marketing | Content, social, SEO, CRM | Campaigns |
| 28 | Head of Support / Customer Success | L2 | CEO | Support process, onboarding, satisfaction | Support process |
| 29 | Support Agent | L4 | Head of Support | Tickets, user training, feedback triage | Feedback summaries |
| 30 | Business Operations | L2 | CEO | Finance, contracts, legal, hiring logistics | Budget, contracts, terms |

---

## 5. Decision rights by level

| Level | Can decide alone | Must escalate |
|---|---|---|
| **L4 — IC** | Implementation details inside an approved spec | Changes to scope, API contract, data model, security, or deadline |
| **L3 — Lead** | Task assignment, code review and merge in their area, team conventions | Cross-team changes, new dependencies with security or cost impact, architecture |
| **L2 — Head** | Department priorities and standards; approvals in Section 6 | Budget, pricing, cross-department roadmap, conflicts with another Head |
| **L1 — CEO** | Everything; final tiebreaker | — |

---

## 6. Authority matrix

**D** = Decides · **A** = Approves · **C** = Consulted · **I** = Informed · **V** = Veto

| Decision | CEO | CTO | CISO | Head of Product | Lead (area) | QA Lead | Others |
|---|---|---|---|---|---|---|---|
| Start / stop an idea or project | D | C | C | C | I | I | Business Ops: C |
| Vision and company roadmap | D | C | C | C | I | I | I |
| Feature priority and scope | A | C | C | D | C | I | Support: C |
| Spec approved | A | C | C (if security-relevant) | D | C | C | — |
| Architecture and tech stack | A | D | C | I | C | I | — |
| API contract | I | A | C | C | D (Backend Lead) | C | Frontend Lead: C |
| Code merge | — | — | — | — | D | C | AppSec: C on sensitive code |
| Quality sign-off | I | I | — | I | C | D | — |
| Security sign-off | I | C | A | I | C | I | AppSec / Red Team: C |
| Release to production | D | C | **V** | C | C | **V** | Platform Lead: C |
| Vulnerability severity | I | C | D | I | C | — | Red / Blue Leads: C |
| Declare a security incident | I | I | A | I | — | — | Blue Team Lead: D |
| Take a system offline in an incident | I | C | A | I | — | — | Blue Team Lead + SRE: D |
| Red Team campaign and scope | A | I | D | — | — | — | Red Team Lead: C |
| Pricing and plans | D | I | — | C | — | — | Marketing, Business Ops: C |
| Budget and spending | D | C | C | C | — | — | Business Ops: C |
| Public communication | A | — | C (if security-related) | C | — | — | Head of Marketing: D |
| Customer communication in an incident | A | — | C | — | — | — | Head of Support: D |
| Contracts, terms, privacy policy | A | — | C | — | — | — | Business Ops: D |
| Activating / hiring a role | D | C | C | C | C | — | — |
| Changes to this charter | D | C | C | C | — | — | — |

### Vetoes

- **CISO** can block a release with an open **Critical** or **High** vulnerability.
- **QA Lead** can block a release when quality gates fail.
- Only the **CEO** can override a veto, with a written **risk acceptance** in the decision log (risk, reason, expiry date, fix owner).

---

## 7. Security operations

### 7.1 Red Team rules of engagement

- **In scope:** only systems the company owns — local development, staging, test accounts.
- **Production:** only with written CISO + CEO approval, a time window and a named Blue Team contact.
- **Never in scope:** third-party systems (payment providers, hosting, clients, other companies) without their **written permission**. Unauthorized testing is illegal.
- No real user data in attacks; use test accounts and synthetic data.
- The Red Team **reports** findings; it never fixes, changes or deletes anything in targets.
- Stop immediately and notify the CISO if a test causes an outage or exposes real data.

### 7.2 Red / Blue cycle

1. **Threat model** — Red Team Lead + AppSec review the design before build.
2. **Attack** — Red Team runs a campaign against staging.
3. **Detect** — Blue Team tries to catch it in real time, without warning.
4. **Purple review** — both compare the attack timeline with what was detected.
5. **Fix** — findings become backlog tickets with severity.
6. **Retest** — Red Team confirms the fix; Blue Team adds a detection rule.

### 7.3 Severity and fix deadlines

| Severity | Example | Fix deadline |
|---|---|---|
| **Critical** | Access to other users' or customers' data, payment manipulation, auth bypass | Before release; in production within 24 h |
| **High** | Account takeover, sensitive data exposure | Before release; in production within 7 days |
| **Medium** | Limited information leak, missing hardening | Within 30 days |
| **Low** | Best-practice gaps | Backlog, prioritized by Product |

### 7.4 Incidents

- **Declared by:** Blue Team Lead (CISO approves). **Incident commander:** Blue Team Lead.
- **Incident room:** Blue Team Lead, SRE, affected Engineering Lead, Head of Support, CISO.
- **Postmortem:** blameless, within 5 working days, with action items in the backlog.

---

## 8. Rooms

### Company-wide

| # | Room | Members | Purpose | Cadence |
|---|---|---|---|---|
| 1 | All-hands | Everyone | Updates, demos | Biweekly |
| 2 | Leadership | CEO, CTO, CISO, all Heads | Priorities, conflicts, budget | Weekly |

### Team rooms

| # | Room | Members | Purpose |
|---|---|---|---|
| 3 | Frontend | Frontend team | Standup, reviews |
| 4 | Backend | Backend team | Standup, reviews |
| 5 | Platform | Platform team | Infra, CI/CD, on-call |
| 6 | AI & Data | AI / Data team | Models, evals, analytics |
| 7 | QA & Release | QA team + Leads | Test status, release readiness |
| 8 | Product & Design | Product team | Specs, designs, research |
| 9 | Growth | Marketing team | Campaigns, positioning |
| 10 | 🔴 Red Team | Red Team + CISO **(restricted)** | Attack planning, kept confidential |
| 11 | 🔵 Blue Team / SOC | Blue Team + CISO | Alerts, monitoring, hardening |

### Cross-functional

| # | Room | Members | Purpose |
|---|---|---|---|
| 12 | Squad: [Area A] | PM, Designer, Frontend, Backend, QA, AppSec | [Main user flow] end to end |
| 13 | Squad: [Area B] | PM, Designer, Frontend, Backend, Data, QA | [Second area] end to end |
| 14 | Support & Feedback | Support, PM, QA | User issues → backlog |
| 15 | 🟣 Purple Team | Red + Blue Teams, CISO, relevant Lead | Post-exercise review |

### Temporary

| Room | Members | Lifetime |
|---|---|---|
| Incident room | See 7.4 | Opened per incident, closed after the postmortem |
| Kickoff room | See startup-workflow.md | Opened per new idea, closed at the Phase 2 gate |

---

## 9. Escalation path

1. **IC → Lead** — answer within 1 working day.
2. **Lead → Head** — within 2 working days.
3. **Head → CEO** — CEO decides; the decision goes into the decision log.

**Security exception:** anyone who finds an active security problem reports **directly to the Blue Team Lead and CISO**.

---

## 10. Rules for AI agents

- Each agent works **only within its role** (Section 4) and decision rights (Section 5).
- Agents don't share memory. Shared context = **this charter, startup-workflow.md, the roadmap, the decision log, API contracts**. Attach them to every room.
- An agent never approves its own work.
- When unsure, an agent **stops and escalates** instead of guessing.
- Red Team agents follow Section 7.1 with no exceptions.

---

## Changelog

| Version | Date | Change | Approved by |
|---|---|---|---|
| 1.0 | [YYYY-MM-DD] | Initial charter | CEO |
