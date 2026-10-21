# Startup Workflow — From Idea to Launch

> **Source of truth** for how work is organized when starting any new idea, project or startup.
> Roles, decision rights and rooms are defined in **team-charter-template.md**.

| Field | Value |
|---|---|
| Project | [Project name] |
| Started | [YYYY-MM-DD] |
| Current phase | [0–8] |
| Version | 1.0 |

---

## 1. Chain of command for a new idea

```
CEO ── decides to explore an idea
 │
 ├── Head of Product ── owns WHAT and WHY  (problem, users, scope)
 └── CTO ────────────── owns HOW           (feasibility, architecture, stack)
        │
        └── Product Manager ── turns WHAT + HOW into specs, backlog and cycles
               │
               ├── Leads (Frontend, Backend, Platform, AI, QA) ── break specs into tasks
               │      └── ICs ── build
               │
               └── Support functions, consulted at each phase:
                      CISO / Security · Design · Marketing · Support · Business Ops
```

**Note on the PM:** the **Product Manager** coordinates delivery (the job of a project manager in this setup). The PM reports to the Head of Product, but works hand in hand with the CTO: the PM decides **order and scope**, the CTO and Leads decide **how it's built**.

---

## 2. Phases overview

| Phase | Name | Owner | Goal | Gate to pass |
|---|---|---|---|---|
| 0 | Idea intake | CEO | Write the idea down | Idea brief exists |
| 1 | Discovery | Head of Product | Is the problem real and worth solving? | **Go / No-go** (CEO) |
| 2 | Definition | PM + CTO | What is the MVP and how will we build it? | **MVP plan approved** (CEO) |
| 3 | Planning | PM + Leads | Break the MVP into cycles and tasks | **Cycle 1 ready** (PM + CTO) |
| 4 | Build | Leads + squads | Build in short cycles | Each feature passes delivery gates |
| 5 | Verify | QA Lead + CISO | Prove it works and is safe | **Release candidate approved** |
| 6 | Launch | CEO | Put it in front of real users | **Launch approved** (CEO) |
| 7 | Operate & learn | Head of Product | Measure, support, improve | Monthly review |
| 8 | Decide | CEO | Persevere, pivot or stop | Decision recorded |

Each phase ends with a **written artifact** and a **gate**. No phase starts until the previous gate is passed.

---

## 3. Phases in detail

### Phase 0 — Idea intake
| | |
|---|---|
| **Owner** | CEO |
| **Who** | CEO alone |
| **Do** | Write the idea in one page: problem, target user, why now, first guess at solution |
| **Output** | Idea brief (template A) |
| **Room** | Open the **Kickoff room** (CEO, CTO, Head of Product, CISO, Head of Marketing, Business Ops) |

### Phase 1 — Discovery
| | |
|---|---|
| **Owner** | Head of Product |
| **Who** | Head of Product, PM, Designer (research), Head of Marketing, CTO, CISO, Business Ops |
| **Do** | • **Product:** talk to potential users, confirm the problem<br>• **Marketing:** competitors, market size, positioning options<br>• **CTO:** technical feasibility, big risks, rough cost<br>• **CISO:** legal and security risks (personal data, payments, regulation)<br>• **Business Ops:** business model, pricing hypothesis, costs |
| **Output** | Discovery report + assumptions list (riskiest first) |
| **Gate** | **Go / No-go** — CEO decides (template B). No-go is a valid, good outcome. |

### Phase 2 — Definition
| | |
|---|---|
| **Owner** | PM (scope) + CTO (architecture) |
| **Who** | PM, Designer, CTO, all Engineering Leads, Red Team Lead + AppSec, Business Ops |
| **Do** | • **PM:** MVP scope — the smallest version that tests the riskiest assumption; explicit **out of scope** list<br>• **Designer:** main user flows, low-fidelity prototype<br>• **CTO:** architecture, stack, environments (ADRs)<br>• **Red Team Lead + AppSec:** first threat model<br>• **Business Ops:** budget, legal basics (terms, privacy) |
| **Output** | MVP spec (template C), architecture ADRs (template D), threat model, budget |
| **Gate** | **MVP plan approved** — CEO, with CTO and Head of Product sign-off. Close the Kickoff room; open team and squad rooms. |

### Phase 3 — Planning
| | |
|---|---|
| **Owner** | PM |
| **Who** | PM, CTO, all Leads, QA Lead |
| **Do** | • **PM:** split the MVP into features and order them; define cycles (1–2 weeks)<br>• **Leads:** break features into tasks, estimate, flag dependencies<br>• **QA Lead:** test strategy<br>• **Platform Lead:** repo, CI/CD, environments ready before Cycle 1 |
| **Output** | Backlog, cycle plan, test strategy, working dev environment |
| **Gate** | **Cycle 1 ready** — PM + CTO agree; every Cycle 1 task has an owner and acceptance criteria |

### Phase 4 — Build (repeats every cycle)
| | |
|---|---|
| **Owner** | Leads, coordinated by PM |
| **Who** | Squads (Product, Design, Engineering, QA, AppSec) |
| **Do** | Cycle loop — see Section 4 |
| **Output** | Working features, merged with tests |
| **Gate** | Every feature passes the **delivery gates** (Section 5) |

### Phase 5 — Verify
| | |
|---|---|
| **Owner** | QA Lead + CISO |
| **Who** | QA, Red Team, Blue Team, AppSec, Platform |
| **Do** | • **QA:** full regression and E2E on staging<br>• **Red Team:** attack campaign on staging<br>• **Blue Team:** monitoring, alerts and incident playbook ready<br>• **Platform:** backups, rollback plan, load test |
| **Output** | Test report, security report, rollback plan |
| **Gate** | **Release candidate approved** — QA Lead and CISO (both can veto) |

### Phase 6 — Launch
| | |
|---|---|
| **Owner** | CEO |
| **Who** | Platform, Marketing, Support, Product |
| **Do** | • **Platform:** deploy, watch metrics<br>• **Marketing:** launch to a small first group (pilot users)<br>• **Support:** onboarding guide, FAQ, support channel ready<br>• **Product:** success metrics tracking live |
| **Output** | Release notes, launch plan, live metrics dashboard |
| **Gate** | **Launch approved** — CEO |

### Phase 7 — Operate & learn
| | |
|---|---|
| **Owner** | Head of Product |
| **Who** | Everyone |
| **Do** | • **Support → Product:** weekly feedback summary<br>• **Data:** weekly metrics report<br>• **SRE + Blue Team:** uptime and security monitoring<br>• **Red Team:** recurring campaigns<br>• Back to Phase 3 for each new set of features |
| **Output** | Metrics reports, feedback summaries, postmortems, updated roadmap |
| **Gate** | Monthly review in the Leadership room |

### Phase 8 — Persevere, pivot or stop
| | |
|---|---|
| **Owner** | CEO |
| **Who** | Leadership room |
| **Do** | Compare results with the success metrics set in Phase 2 |
| **Output** | Decision record (template E) |
| **Decision** | **Persevere** (keep going) · **Pivot** (change direction → back to Phase 1) · **Stop** (archive and write lessons learned) |

---

## 4. Cycle loop (Phase 4)

| Day | Activity | Who | Room |
|---|---|---|---|
| Start | **Cycle planning** — PM picks features; Leads assign tasks | PM, Leads | Squad rooms |
| Daily | **Written standup** — done / doing / blocked | Each squad | Squad rooms |
| During | Build → PR → review → merge | ICs, Leads, AppSec | Team rooms |
| During | Test each feature as it lands | QA | QA & Release |
| End | **Demo** — show working features | Everyone | All-hands |
| End | **Retro** — what to keep, change, stop | Each team | Team rooms |

**WIP rule:** a squad works on at most **[2]** features at a time. Finish before starting.

---

## 5. Delivery gates (every feature)

| # | Gate | Owner | Required artifact |
|---|---|---|---|
| G1 | Spec approved | Head of Product | Spec with acceptance criteria |
| G2 | Design approved | Designer + Head of Product | Designs / prototype |
| G3 | Threat model done | Red Team Lead + AppSec | Threat model (if feature touches auth, payments, personal data, uploads, integrations) |
| G4 | API contract agreed | Backend Lead + Frontend Lead | API contract |
| G5 | Code merged | Lead of the area | PR with tests, passing CI and security scans |
| G6 | QA sign-off | QA Lead | Test report |
| G7 | Security sign-off | CISO (via AppSec) | No open Critical / High |
| G8 | Release | CEO | Release notes, rollback plan |

While the founder is the only human, **every gate also needs founder approval**.

---

## 6. Handoff artifacts

Work moves through **written artifacts**, not conversation. If the receiver can't work from the artifact alone, the sender fixes it.

| From → To | Artifact |
|---|---|
| CEO → Kickoff room | Idea brief |
| Head of Product → CEO | Discovery report, Go / No-go request |
| PM → Design, Engineering | Spec with acceptance criteria |
| CTO → Leads | Architecture decisions (ADRs) |
| Designer → Frontend | Designs, component specs, states |
| Backend → Frontend | API contract |
| Red Team + AppSec → Engineering | Threat model |
| Engineering → QA | PR + test plan |
| QA → CEO | Test report, release go / no-go |
| Red Team → CISO → Engineering | Findings → backlog tickets with severity |
| Support → Product | Feedback summary |
| Anyone → Decision log | Decision record |

---

## 7. Empty project documents

Copy these into the project and fill them in.

### Template A — Idea brief

```markdown
# Idea brief — [Project name]
- Date:
- Author: CEO

## Problem
[What hurts, for whom]

## Target user
[Who exactly]

## Why now
[What changed that makes this possible or needed]

## First guess at the solution
[One paragraph]

## How we'll know it works
[1–3 measurable signals]

## Biggest unknowns
1.
2.
3.
```

### Template B — Go / No-go

```markdown
# Go / No-go — [Project name]
- Date:
- Requested by: Head of Product
- Decided by: CEO

## Evidence the problem is real
-

## Market and competitors
-

## Feasibility (CTO)
-

## Risks (CISO, Business Ops)
-

## Recommendation
[Go / No-go] — because:

## Decision
[Go / No-go] — signed: CEO
```

### Template C — MVP spec

```markdown
# MVP spec — [Project name]
- Version:
- Owner: PM
- Approved by:

## Goal
[The riskiest assumption this MVP tests]

## Users and main flow
1.
2.
3.

## In scope
-

## Out of scope
-

## Features and acceptance criteria
### Feature 1: [name]
- Given … when … then …

## Success metrics
| Metric | Target | Measured how |
|---|---|---|
|  |  |  |

## Risks and open questions
-
```

### Template D — Architecture decision record (ADR)

```markdown
# ADR-[000]: [Decision title]
- Date:
- Status: [Proposed / Accepted / Replaced by ADR-xxx]
- Owner: CTO

## Context
[What problem we're solving]

## Options considered
1.
2.

## Decision
[What we chose]

## Consequences
[Trade-offs, what becomes easier or harder]
```

### Template E — Decision log entry

```markdown
## [YYYY-MM-DD] — [Decision title]
- Decided by:
- Consulted:
- Decision:
- Why:
- Revisit on:
```

### Template F — Project status board

```markdown
# Status — [Project name]
- Current phase:
- Current cycle:
- Last updated:

| Area | Status | Next step | Owner | Blocked by |
|---|---|---|---|---|
| Product |  |  |  |  |
| Design |  |  |  |  |
| Frontend |  |  |  |  |
| Backend |  |  |  |  |
| Platform |  |  |  |  |
| AI / Data |  |  |  |  |
| QA |  |  |  |  |
| Security |  |  |  |  |
| Marketing |  |  |  |  |
| Support |  |  |  |  |
| Business Ops |  |  |  |  |
```

---

## 8. Recommended project folder structure

```
[project-name]/
├── 00-charter/
│   ├── team-charter.md
│   └── startup-workflow.md
├── 01-idea/
│   └── idea-brief.md
├── 02-discovery/
│   ├── discovery-report.md
│   └── go-no-go.md
├── 03-definition/
│   ├── mvp-spec.md
│   ├── threat-model.md
│   └── adr/
├── 04-planning/
│   ├── backlog.md
│   └── cycles/
├── 05-security/
│   ├── rules-of-engagement.md
│   ├── findings/
│   └── postmortems/
├── 06-launch/
│   └── release-notes/
├── decision-log.md
└── status.md
```

---

## Changelog

| Version | Date | Change | Approved by |
|---|---|---|---|
| 1.0 | [YYYY-MM-DD] | Initial workflow | CEO |
