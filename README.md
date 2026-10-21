# Ostaru-company vault

This folder is an Obsidian vault and, if needed, a Git repository. The entry point is [Home](Home.md).

## Structure

```
Ostaru-company/
├── Home.md                  entry point
├── README.md                this file
├── .gitignore               only used for the GitHub fallback
├── AGENT-RULES.md           approved operating rules (CTO-owned)
├── general-context.md       company-wide context and decisions (CTO-published)
├── operating-model/         how the company works (CEO-owned, except the roster)
│   ├── README.md            how it fits with AGENT-RULES
│   ├── team-charter.md      30 roles, decision rights, security ops, rooms
│   ├── startup-workflow.md  phases 0–8, gates, handoffs, templates
│   └── agent-roster.md      charter roles mapped to agents (CTO-maintained)
├── agent-personas/          one file per agent (17 agents)
├── agents/                  each agent's internal folder (writable by that agent)
│   └── <agent>/             state.md, behavior/positive.md, behavior/negative.md, skills/
├── standards/               approved design lines all outputs follow
│   └── <area>/              code, architecture, ux-ui, api, data, ...
├── projects/
│   ├── README.md            project index
│   ├── _template/           copy this folder to start a project
│   │   ├── 00-charter/  01-idea/  02-discovery/  03-definition/adr/
│   │   ├── 04-planning/cycles/  05-security/  06-launch/release-notes/
│   │   ├── decision-log.md
│   │   └── status.md
│   └── <project-name>/
└── skills/
    ├── README.md            skill conventions and list
    └── _template/SKILL.md
```

## GitHub fallback (Extra Rule 1)
This is inactive while the vault exists (decision D-003 in [general-context](general-context.md)). If the vault becomes unavailable:
- An agent that documents itself may request a push to the repository.
- Push so that the **repository root equals the vault root**. Cloning the repository and opening that folder as a vault then recreates it.
- Keep paths and links relative. Don't rely on Obsidian-only features such as wiki links or plugins (D-005).
- Do not commit credentials, tokens or private personal data. See `.gitignore`.
- Pushing is an external action, and it needs explicit authorization for that specific push.

## Documenting an agent (Extra Rule 2)
When an agent documents itself, it writes in its internal folder `agents/<agent-name>/`: local skills based on [skills/_template/SKILL.md](skills/_template/SKILL.md), behavior entries and `state.md` (AGENT-RULES section 8). Proposed changes to `AGENT-RULES.md` or `general-context.md` go to the CTO in chat. Agents do not edit them directly.
