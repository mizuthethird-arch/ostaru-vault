---
title: General Context
owner: CTO (publishes changes; see AGENT-RULES section 4)
status: PUBLISHED
version: 1.18.0
effective: 2026-10-21
contributors: ATHENA (CTO), SOLON (Head of Product), PERICLES (Product Manager), and the CEO
---

# General Context

> Durable, company-wide context only. Keep it concise and link to project folders for detail. Agents **propose** changes in chat, with a suggested location and a supporting source, and the CTO publishes them ([AGENT-RULES](AGENT-RULES.md), section 4).
> Every significant item lists its **owner, source and last-confirmed date**. **`TBD` means unknown. Do not infer it.**

## 1. Company and product

| Item | Value | Owner | Source | Last confirmed |
|---|---|---|---|---|
| Company | Ostaru Company, operated through a set of AI agents working under shared rules. | Sponsor/Owner | Sponsor/Owner, chat | 2026-10-20 |
| Vault name | Ostaru-company | Sponsor/Owner | Project instructions | 2026-10-20 |
| Product summary | **Not defined yet** (TBD) | CEO | Sponsor/Owner, chat | 2026-10-20 |
| Mission and positioning | TBD | CEO | none yet | not confirmed |

## 2. Business model, users, terminology
- Business model: TBD
- User groups / customers: TBD
- Key terminology (glossary): TBD

## 3. Organizational roles and decision owners

The organization follows the CEO's [team charter](operating-model/team-charter.md): 30 roles in four levels, with decision rights, vetoes and rooms. **Which agent fills each role is in the [agent roster](operating-model/agent-roster.md)**, which is the single maintained list.

| Item | Value | Source | Last confirmed |
|---|---|---|---|
| Founder / CEO (L1) | The Sponsor/Owner (human). Approves every gate while the only human (founder rule). | Sponsor/Owner, chat; charter section 1 | 2026-10-21 |
| CTO (L2) | ATHENA (AI agent) | [ATHENA](agent-personas/ATHENA.md) | 2026-10-21 |
| Other department heads (L2) | CISO JUPITER, Head of Product SOLON, Head of Marketing/Growth NIKE, Head of Support HESTIA. Business Operations is vacant. | [agent roster](operating-model/agent-roster.md) | 2026-10-21 |
| Roster status | 18 of 30 charter roles filled by 17 agents; 12 vacant; THEMIS is outside the charter (CEO decision pending) | [agent roster](operating-model/agent-roster.md) | 2026-10-21 |
| Biggest gaps before an MVP | Product Designer (#25), Frontend Lead (#3) and frontend engineers (#4–#5) | [agent roster](operating-model/agent-roster.md), section 5 | 2026-10-21 |

## 4. Vault access and permissions
- All agents may **read and search** the vault at any time, with no per-task permission needed (D-015). Mirrors: the Ostaru Company Claude Project knowledge (`Ostaru-company/...` documents) and GitHub. (Sponsor/Owner, 2026-10-21)
- **Only the CTO and the CEO may write** in the vault. (Sponsor/Owner, chat, 2026-10-20)
- All other agents are read-only, and propose changes in chat to the CTO.
- Anything outside the vault (codebase, repositories, tools, external services) still needs separate task-specific permission ([AGENT-RULES](AGENT-RULES.md), section 3).

## 5. Shared constraints
- **Operating rules:** [AGENT-RULES](AGENT-RULES.md) v1.2.0. Code is delivered in chat, there is no file or tool access without task-specific permission, and vault updates are proposed to the CTO.
- **Operating model:** the CEO's [team charter](operating-model/team-charter.md) and [startup workflow](operating-model/startup-workflow.md), both v1.0. They set roles, decision rights, phases 0–8, gates G1–G8 and handoff artifacts. They grant decision rights, **not access**; how they fit with the rules is in [operating-model/README](operating-model/README.md).
- **Founder rule:** while the CEO is the only human, every gate also needs CEO approval, and no agent approves its own work (charter sections 1 and 10).
- **Implementation-first:** work starts with the information available. Specialist review is code-review feedback, not a prerequisite.
- **Security and privacy:** no passwords, keys, tokens or unnecessary personal data in the vault. Use an approved secret-management system (TBD). Red Team work follows charter section 7.1 with no exceptions.
- **Product, technical, legal and operational constraints** (budget, capacity, compliance): TBD

## 6. Cross-project decisions and current priorities

| # | Decision | Decided by | Date | Notes |
|---|---|---|---|---|
| D-001 | Publish the approved rules as `AGENT-RULES.md` (Markdown), from `RULES.txt`. | CTO | 2026-10-20 | `RULES.txt` remains the Sponsor's source copy. |
| D-002 | The "Extra Rules" at the end of `RULES.txt` are part of the approved text. | CTO, on the Sponsor's supplied text | 2026-10-20 | They appear after section 7 of the file the Sponsor supplied. |
| D-003 | Extra Rule 1 (GitHub fallback) is **inactive while the vault exists**, and **no fallback repository has been created yet** (CEO, 2026-10-20). It triggers only if the vault is unavailable. Any push still needs explicit Sponsor approval. | CTO | 2026-10-20 | Vault kept repository-ready: see [README](README.md) and `.gitignore`. |
| D-004 | Extra Rule 2: one `skills/` folder at the vault root, with **one subfolder per agent** (`skills/<agent>/<skill>.md`). | CTO | 2026-10-20 | Reversible. |
| D-005 | Use **standard relative Markdown links** (`[text](path.md)`), not Obsidian `[[wiki links]]`. | CTO, on PERICLES's proposal | 2026-10-20 | Section 4 of the rules asks for "ordinary links". It also keeps the GitHub mirror usable. |
| D-006 | `Home.md` is the vault entry point. `README.md` describes structure and the GitHub fallback. | CTO, on PERICLES's proposal | 2026-10-20 | |
| D-007 | New projects start from `projects/_template/`, and new skills from `skills/_template/SKILL.md`. | CTO, on PERICLES's proposal | 2026-10-20 | The project template was rebuilt under D-010. |
| D-008 | Vault write access is limited to the CTO and the CEO. | CEO | 2026-10-20 | Executive decision. Other agents deliver workflow artifacts in chat, and the CTO or CEO files them. **Exception (D-012):** each agent may write in its own `agents/<agent>/` folder. |
| D-009 | The CEO's startup workflow and team charter are the company operating model, published in `operating-model/`. | CEO (instruction to update the vault) | 2026-10-21 | Executive decision. Only the CEO changes them. |
| D-010 | `projects/_template/` follows the workflow's folder structure (section 8), with templates A–F. The old template files (`requirements.md`, `architecture.md`, `decisions.md`, `risks-dependencies.md`) are superseded. | CTO | 2026-10-21 | The superseded files are stubs waiting for the CEO to delete them; the CTO cannot delete files. |
| D-011 | Interim cover for vacant engineering roles: the CTO covers the Frontend Lead; the Backend Lead covers Payments; the Platform Lead covers the SRE; the AI Lead covers ML/LLM and Data; the QA Lead covers QA Automation. | CTO | 2026-10-21 | Within the CTO's department; reversible. Cover for non-engineering vacancies is a recommendation for the CEO ([agent roster](operating-model/agent-roster.md), section 4). |
| D-012 | Every agent has an internal folder `agents/<agent>/` (behavior, local skills, state) that it may write itself, after committed and approved changes or on Sponsor behavior feedback. Existing skills moved there. | CEO | 2026-10-21 | Executive decision; AGENT-RULES section 8. |
| D-013 | Approved design standards (code, UX/UI and any other design line) are binding on every agent output. They live in `standards/` or a project's `standards/` folder. | CEO | 2026-10-21 | Executive decision; AGENT-RULES section 9. No standard is approved yet. |
| D-014 | The erroneous product name that appeared in agent source documents was removed from every vault file, including the source documents. | CEO | 2026-10-21 | Executive decision. |
| D-015 | All agents may read and search the vault at any time, without per-task permission: the vault, its mirror in the Ostaru Company Claude Project knowledge, and GitHub. Read-only; writing rules unchanged. | CEO | 2026-10-21 | Executive decision; AGENT-RULES v1.2.0, section 4. The vault is the source of truth; the Project mirror is refreshed by the CTO. |

**Current priorities:** not defined yet (CEO, 2026-10-20).

## 7. Projects and authoritative records
- Projects: none registered yet. See [projects/README](projects/README.md); new projects start from [the template](projects/_template/README.md).
- Rules: [AGENT-RULES](AGENT-RULES.md)
- Operating model: [team charter](operating-model/team-charter.md), [startup workflow](operating-model/startup-workflow.md), [agent roster](operating-model/agent-roster.md)
- Personas: one per agent in `agent-personas/`, listed in the [agent roster](operating-model/agent-roster.md)
- Agent internal folders (behavior, skills, state): [agents/README](agents/README.md); skill conventions: [skills/README](skills/README.md)
- Design standards: [standards/README](standards/README.md) (none approved yet)
- Roadmap: not created yet (owned by the CEO, with the Head of Product)
- Secret management system: TBD (never the vault).

## 8. Open items (awaiting the CEO)
1. Product or business definition, and the top priority: **not defined yet**.
2. **Activate the Wave 1 gaps** before an MVP: Product Designer (#25) and Frontend Lead (#3), plus at least one frontend engineer (#4).
3. **THEMIS** is not a charter role: add it as a 31st role (and under whom), or merge its scope ([agent roster](operating-model/agent-roster.md), section 2).
4. **IRIS** fills the content and social part of Growth Marketer (#27). Confirm, and decide who owns SEO and CRM (NIKE holds them meanwhile).
5. Confirm the **recommended interim cover**: the CISO for the Red Team Lead, the Head of Product for the Product Designer, the Head of Support for the Support Agent, and the CEO for Business Operations.
6. **Precedence:** when a persona and the charter disagree, which wins? Until decided, conflicts are escalated to the CEO ([operating-model/README](operating-model/README.md)).
7. **Rooms:** which platform hosts the charter's rooms (all-hands, leadership, squads, incident room)?
8. GitHub fallback repository: **not created yet**.
9. Delete the four superseded files in `projects/_template/` (D-010).

## Change log

| Version | Date | Note |
|---|---|---|
| 1.18.0 | 2026-10-21 | D-015: standing read access for all agents; vault mirrored into the Claude Project knowledge. |
| 1.17.0 | 2026-10-21 | Recorded D-012 (agent internal folders), D-013 (design standards) and D-014 (erroneous product name removed everywhere). Rules now v1.1.0. |
| 1.16.0 | 2026-10-21 | Added the operating model (D-009), the rebuilt project template (D-010) and interim cover for engineering vacancies (D-011). Replaced the roles table with a summary linking to the agent roster; the old table omitted ARTEMIS and had stale reporting lines. Updated constraints, records and open items. |
| 1.15.0 | 2026-10-20 | Added EUNOMIA (AppSec / DevSecOps Engineer, reports to the Blue Team Lead ARTEMIS) to the roles table and records. |
| 1.14.0 | 2026-10-20 | Added JUPITER (CISO / Head of Security, reports to the CEO) to the roles table and records. |
| 1.13.0 | 2026-10-20 | Added ODYSSEUS (Offensive Security Engineer, reports to a Red Team Lead that is not in the roster yet) to the roles table and records. |
| 1.12.0 | 2026-10-20 | Added ORPHEUS (Detection & Response Engineer, reports to a Blue Team Lead that is not in the roster yet) to the roles table and records. |
| 1.11.0 | 2026-10-20 | Added VULCAN (Backend Engineers, 2 positions, reports to the Backend Lead) to the roles table and records. |
| 1.10.0 | 2026-10-20 | Added THEMIS (Security Engineer, reports to the Platform/DevOps Lead) to the roles table and records. |
| 1.9.0 | 2026-10-20 | Added SOPHIA (AI Lead, reports to the CTO) to the roles table and records. |
| 1.8.0 | 2026-10-20 | Added PROMETHEUS (Platform/DevOps Lead, reports to the CTO) to the roles table and records. |
| 1.7.0 | 2026-10-20 | Added NIKE (Head of Marketing/Growth, reports to the CEO). IRIS now reports to NIKE. |
| 1.6.0 | 2026-10-20 | Added MINOS (QA Lead, reports to the CTO) to the roles table and records. |
| 1.5.0 | 2026-10-20 | Added JANUS (Backend Lead, reports to the CTO) to the roles table and records. |
| 1.4.0 | 2026-10-20 | Added IRIS (Content & Social Manager) to the roles table and records. |
| 1.3.0 | 2026-10-20 | Added HESTIA (Head of Support/Customer Success) to the roles table and records. |
| 1.2.0 | 2026-10-20 | Recorded the CEO's answers: the Sponsor/Owner is the CEO; product and priorities are not defined yet; the roster is being created; only the CTO and CEO write to the vault (D-008); no fallback repository yet. |
| 1.1.0 | 2026-10-20 | Merged PERICLES's proposal: added PERICLES as Product Manager, the vault-access section, open questions, and decisions D-005 to D-007. Removed an erroneous product name per the Sponsor's correction. Converted links to standard Markdown. |
| 1.0.0 | 2026-10-20 | Initial publication by the CTO. Merged ATHENA's skeleton with SOLON's proposal. |
