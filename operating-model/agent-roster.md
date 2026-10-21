---
title: Agent Roster (charter roles to Ostaru agents)
owner: CTO (maintains the mapping); CEO (decides activation and any change of role)
status: PUBLISHED
version: 1.0.0
effective: 2026-10-21
source: team-charter.md section 4 (CEO), and the 17 published personas in agent-personas/
---

# Agent Roster

This page maps every role in the [team charter](team-charter.md) (section 4) to the Ostaru agent that fills it. The charter defines each role's level, reporting line, decision rights and rooms. The persona defines how the agent works. **Activating or changing a role is a CEO decision** (charter, section 6).

**Summary (2026-10-21):** 18 of the 30 charter roles are filled by 17 agents, because VULCAN covers both Backend Engineer positions. 12 roles are vacant, and 1 agent (THEMIS) fills a role that is not in the charter.

## 1. Roster

| # | Charter role | Level | Reports to (charter) | Agent | Wave | Status |
|---|---|---|---|---|---|---|
| 1 | Founder / CEO | L1 | — | Sponsor/Owner (human) | 1 | Filled |
| 2 | CTO | L2 | CEO | [ATHENA](../agent-personas/ATHENA.md) | 1 | Filled |
| 3 | Frontend Lead | L3 | CTO | — | 1 | **Vacant** |
| 4 | Frontend Engineer | L4 | Frontend Lead | — | 1 | **Vacant** |
| 5 | Web / Performance Engineer | L4 | Frontend Lead | — | 1 | **Vacant** |
| 6 | Backend Lead | L3 | CTO | [JANUS](../agent-personas/JANUS.md) | 1 | Filled |
| 7 | Backend Engineer | L4 | Backend Lead | [VULCAN](../agent-personas/VULCAN.md) (position 1 of 2) | 1 | Filled |
| 8 | Backend Engineer | L4 | Backend Lead | [VULCAN](../agent-personas/VULCAN.md) (position 2 of 2) | 1 | Filled |
| 9 | Payments / Integrations Engineer | L4 | Backend Lead | — | 1 | **Vacant** |
| 10 | Platform / DevOps Lead | L3 | CTO | [PROMETHEUS](../agent-personas/PROMETHEUS.md) | 1 | Filled |
| 11 | SRE | L4 | Platform Lead | — | 1 | **Vacant** |
| 12 | AI Lead | L3 | CTO | [SOPHIA](../agent-personas/SOPHIA.md) | 3 | Filled |
| 13 | ML / LLM Engineer | L4 | AI Lead | — | 3 | **Vacant** |
| 14 | Data Engineer / Analyst | L4 | AI Lead | — | 2 | **Vacant** |
| 15 | QA Lead | L3 | CTO | [MINOS](../agent-personas/MINOS.md) | 1 | Filled |
| 16 | QA Automation Engineer | L4 | QA Lead | — | 1 | **Vacant** |
| 17 | CISO / Head of Security | L2 | CEO | [JUPITER](../agent-personas/JUPITER.md) | 1 | Filled |
| 18 | Red Team Lead | L3 | CISO | — | 2 | **Vacant** |
| 19 | Offensive Security Engineer | L4 | Red Team Lead | [ODYSSEUS](../agent-personas/ODYSSEUS.md) | 2 | Filled |
| 20 | Blue Team Lead | L3 | CISO | [ARTEMIS](../agent-personas/ARTEMIS.md) | 2 | Filled |
| 21 | Detection & Response Engineer | L4 | Blue Team Lead | [ORPHEUS](../agent-personas/ORPHEUS.md) | 2 | Filled |
| 22 | AppSec / DevSecOps Engineer | L4 | Blue Team Lead | [EUNOMIA](../agent-personas/EUNOMIA.md) | 1 | Filled |
| 23 | Head of Product | L2 | CEO | [SOLON](../agent-personas/SOLON.md) | 1 | Filled |
| 24 | Product Manager | L3 | Head of Product | [PERICLES](../agent-personas/PERICLES.md) | 1 | Filled |
| 25 | Product Designer (incl. UX research) | L3 | Head of Product | — | 1 | **Vacant** |
| 26 | Head of Marketing / Growth | L2 | CEO | [NIKE](../agent-personas/NIKE.md) | 3 | Filled |
| 27 | Growth Marketer | L4 | Head of Marketing | [IRIS](../agent-personas/IRIS.md) (content and social only; see section 3) | 3 | Partly filled |
| 28 | Head of Support / Customer Success | L2 | CEO | [HESTIA](../agent-personas/HESTIA.md) | 2 | Filled |
| 29 | Support Agent | L4 | Head of Support | — | 2 | **Vacant** |
| 30 | Business Operations (finance, legal, people) | L2 | CEO | — | 3 | **Vacant** |

The Wave column follows charter section 1. Roles the charter doesn't name in a wave sit with their department: SRE, Payments and QA Automation with Wave 1 engineering; ML/LLM with AI in Wave 3. "Platform", "QA" and "AppSec" are in Wave 1, and the CISO is placed in Wave 1 because AppSec reports into security.

## 2. Agent outside the charter

| Agent | Persona title | Persona reporting line | Issue |
|---|---|---|---|
| [THEMIS](../agent-personas/THEMIS.md) | Security Engineer | Platform/DevOps Lead (PROMETHEUS); escalates to CTO | The charter has no "Security Engineer". Its nearest roles are AppSec / DevSecOps (#22, already EUNOMIA) and the Blue Team, and they report to the CISO, not to Platform. The charter keeps security independent of the teams that build ("Why the CISO reports to the CEO"). **CEO decision needed:** add THEMIS as a 31st role, and under whom, or merge its scope into an existing role. |

## 3. Title differences

| Agent | Persona title | Charter role | Note |
|---|---|---|---|
| [IRIS](../agent-personas/IRIS.md) | Content & Social Manager | #27 Growth Marketer (content, social, SEO, CRM) | IRIS covers content and social. SEO and CRM have no owner yet; until they do, [NIKE](../agent-personas/NIKE.md) holds them. CEO to confirm the mapping. |
| [VULCAN](../agent-personas/VULCAN.md) | Backend Engineers (2 positions) | #7 and #8 Backend Engineer | One persona fills both charter rows. |

## 4. Interim cover for vacant roles

Charter section 9 sends escalations up the line (IC → Lead → Head → CEO), so a vacant role is covered by the next role up until the CEO activates it.

| Vacant role | Interim cover | Basis |
|---|---|---|
| #3 Frontend Lead (and #4, #5) | CTO ([ATHENA](../agent-personas/ATHENA.md)) for frontend architecture and the Frontend Lead's part in gate G4. There is no frontend implementation capacity. | CTO decision within the engineering department (D-011) |
| #9 Payments / Integrations | Backend Lead ([JANUS](../agent-personas/JANUS.md)) | CTO decision (D-011) |
| #11 SRE | Platform Lead ([PROMETHEUS](../agent-personas/PROMETHEUS.md)) | CTO decision (D-011) |
| #13 ML / LLM, #14 Data | AI Lead ([SOPHIA](../agent-personas/SOPHIA.md)) | CTO decision (D-011) |
| #16 QA Automation | QA Lead ([MINOS](../agent-personas/MINOS.md)). Note: an agent never approves its own work (charter section 10), so MINOS cannot sign off tests it wrote itself. | CTO decision (D-011) |
| #18 Red Team Lead | CISO ([JUPITER](../agent-personas/JUPITER.md)) | **Recommendation:** outside the CTO's department, CEO to confirm |
| #25 Product Designer | Head of Product ([SOLON](../agent-personas/SOLON.md)) for design approval (G2) | **Recommendation:** CEO to confirm |
| #29 Support Agent | Head of Support ([HESTIA](../agent-personas/HESTIA.md)) | **Recommendation:** CEO to confirm |
| #30 Business Operations | CEO | **Recommendation:** CEO to confirm |

## 5. Readiness for the workflow

| Workflow need | Blocked or weakened by | Effect |
|---|---|---|
| Phase 0–2 Kickoff room, Phase 1 business model, Phase 2 budget and legal basics | #30 Business Operations vacant | The CEO has to supply these directly. |
| Phase 1 research, Phase 2 user flows, gate **G2** Design approved | #25 Product Designer vacant | No designs or prototypes can be produced. |
| Gate **G4** API contract (Backend Lead + Frontend Lead) | #3 Frontend Lead vacant | Interim cover by the CTO (section 4). |
| Phase 2 threat model, gate **G3** (Red Team Lead + AppSec) | #18 Red Team Lead vacant | EUNOMIA and ODYSSEUS can draft. The approving role needs the CEO's confirmation of interim cover. |
| Phase 4 build of any user interface | #3–#5 Frontend vacant | **No agent can build frontend features.** This is the biggest Wave 1 gap. |

**Wave 1 gaps to activate before an MVP:** Product Designer (#25) and Frontend Lead (#3), plus at least one frontend engineer (#4).

## Change log

| Version | Date | Note |
|---|---|---|
| 1.0.0 | 2026-10-21 | Created by the CTO from the CEO's team charter and the 17 published personas. |
