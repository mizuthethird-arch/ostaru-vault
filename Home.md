# Ostaru Company: shared knowledge base

This is the human-maintained, shared starting point for every AI agent. Start here, then follow the reading order below.

## Start here
- [Agent operating rules](AGENT-RULES.md): the approved rules, owned by the CTO.
- [General context](general-context.md): durable, company-wide context and decisions.
- [Operating model](operating-model/README.md): how the company is organized and how work moves.
  - [Team charter](operating-model/team-charter.md): the 30 roles, decision rights, vetoes, security operations, rooms and escalation.
  - [Startup workflow](operating-model/startup-workflow.md): phases 0–8, gates G1–G8, handoff artifacts and templates.
  - [Agent roster](operating-model/agent-roster.md): which agent fills which role, vacancies and gaps.
- [Projects](projects/README.md): one folder per project, started from the [project template](projects/_template/README.md).
- [Agent internal folders](agents/README.md): each agent's learned behavior (do and don't), local skills and state, so it can be recreated anywhere.
- [Design standards](standards/README.md): approved design lines that every output must follow (none approved yet).
- [Skills conventions](skills/README.md): the skill format and template.
- [README](README.md): vault structure and the GitHub fallback.

## Agents by department

- **Founder / CEO:** the Sponsor/Owner (human)
- **Engineering (CTO)**
  - [ATHENA, CTO](agent-personas/ATHENA.md)
  - [JANUS, Backend Lead](agent-personas/JANUS.md)
  - [VULCAN, Backend Engineers (2)](agent-personas/VULCAN.md)
  - [PROMETHEUS, Platform/DevOps Lead](agent-personas/PROMETHEUS.md)
  - [SOPHIA, AI Lead](agent-personas/SOPHIA.md)
  - [MINOS, QA Lead](agent-personas/MINOS.md)
- **Security (CISO)**
  - [JUPITER, CISO / Head of Security](agent-personas/JUPITER.md)
  - [ARTEMIS, Blue Team Lead](agent-personas/ARTEMIS.md)
  - [ORPHEUS, Detection & Response Engineer](agent-personas/ORPHEUS.md)
  - [EUNOMIA, AppSec / DevSecOps Engineer](agent-personas/EUNOMIA.md)
  - [ODYSSEUS, Offensive Security Engineer](agent-personas/ODYSSEUS.md)
  - [THEMIS, Security Engineer (not a charter role; see the roster)](agent-personas/THEMIS.md)
- **Product**
  - [SOLON, Head of Product](agent-personas/SOLON.md)
  - [PERICLES, Product Manager](agent-personas/PERICLES.md)
- **Marketing / Growth**
  - [NIKE, Head of Marketing/Growth](agent-personas/NIKE.md)
  - [IRIS, Content & Social (Growth Marketer)](agent-personas/IRIS.md)
- **Support / Customer Success**
  - [HESTIA, Head of Support/Customer Success](agent-personas/HESTIA.md)
- **Business Operations:** vacant

## Reading order for product/business context (from the rules, section 1)
1. Higher-priority platform and safety requirements.
2. The current user's explicit instructions for the task.
3. The latest approved `AGENT-RULES.md`.
4. The applicable agent persona document.
5. `general-context.md`.
6. Relevant project documents and approved records (including the operating model).
7. Conversation history or an agent's temporary memory cache.

If sources conflict, name the conflicting sources and ask the accountable owner which is current.

## Vault conventions
- Plain Markdown with standard relative links, so the vault works in Obsidian, on GitHub and in other AI services.
- Every significant fact has an owner, a source and a last-confirmed date.
- Persona instructions stay separate from project facts.
- No credentials or unnecessary sensitive personal data.
- Each agent writes only in its own area: its `agents/<agent>/` folder, the documents its role owns, and its handoffs. General and sensitive files (rules, general context, operating model, personas, standards, decision logs) are changed only by the CTO and the CEO (AGENT-RULES section 11).
- Agents do not run or test code (that is the owner's job), and chat answers are concise unless a complete report is requested (AGENT-RULES section 11).
- Code, UX/UI and every other designed output follow the approved [design standards](standards/README.md) (AGENT-RULES section 9).
