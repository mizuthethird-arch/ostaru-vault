---
title: Agent internal folders
rule: AGENT-RULES, section 8
status: PUBLISHED
version: 1.0.0
effective: 2026-10-21
---

# Agent internal folders

Each agent's **internal folder** holds its learned behavior, local skills and state, so the agent can be recreated the same way anywhere ([AGENT-RULES](../AGENT-RULES.md), section 8).

```
agents/<agent-name>/
├── state.md              loading order to recreate the agent
├── behavior/
│   ├── positive.md       approved ways of working (keep doing)
│   └── negative.md       rejected ways of working (never do again)
└── skills/               local skills (SKILL.md format)
```

**Who writes here:** each agent writes **only in its own folder**, and only after a committed, Sponsor-approved change (skills, state) or when the Sponsor gives behavior feedback (behavior). The CTO reviews for conflicts and duplicates. The Sponsor/Owner can change or remove anything.

**To recreate an agent:** load the files listed in its `state.md`, in order.

New agents start from [_template](_template/state.md).

## Index

| Agent | Role | Folder | Local skills | Behavior entries (+ / −) |
|---|---|---|---|---|
| [ATHENA](../agent-personas/ATHENA.md) | CTO | [agents/athena](athena/state.md) | [decision-framework](athena/skills/decision-framework.md) | 0 / 1 |
| [JANUS](../agent-personas/JANUS.md) | Backend Lead | [agents/janus](janus/state.md) | none yet | 0 / 0 |
| [VULCAN](../agent-personas/VULCAN.md) | Backend Engineers | [agents/vulcan](vulcan/state.md) | none yet | 0 / 0 |
| [PROMETHEUS](../agent-personas/PROMETHEUS.md) | Platform/DevOps Lead | [agents/prometheus](prometheus/state.md) | none yet | 0 / 0 |
| [SOPHIA](../agent-personas/SOPHIA.md) | AI Lead | [agents/sophia](sophia/state.md) | none yet | 0 / 0 |
| [MINOS](../agent-personas/MINOS.md) | QA Lead | [agents/minos](minos/state.md) | none yet | 0 / 0 |
| [JUPITER](../agent-personas/JUPITER.md) | CISO / Head of Security | [agents/jupiter](jupiter/state.md) | none yet | 0 / 0 |
| [ARTEMIS](../agent-personas/ARTEMIS.md) | Blue Team Lead | [agents/artemis](artemis/state.md) | none yet | 0 / 0 |
| [ORPHEUS](../agent-personas/ORPHEUS.md) | Detection & Response Engineer | [agents/orpheus](orpheus/state.md) | none yet | 0 / 0 |
| [EUNOMIA](../agent-personas/EUNOMIA.md) | AppSec / DevSecOps Engineer | [agents/eunomia](eunomia/state.md) | none yet | 0 / 0 |
| [ODYSSEUS](../agent-personas/ODYSSEUS.md) | Offensive Security Engineer | [agents/odysseus](odysseus/state.md) | none yet | 0 / 0 |
| [THEMIS](../agent-personas/THEMIS.md) | Security Engineer | [agents/themis](themis/state.md) | none yet | 0 / 0 |
| [SOLON](../agent-personas/SOLON.md) | Head of Product | [agents/solon](solon/state.md) | [product-prioritization](solon/skills/product-prioritization.md) | 0 / 0 |
| [PERICLES](../agent-personas/PERICLES.md) | Product Manager | [agents/pericles](pericles/state.md) | none yet | 0 / 0 |
| [NIKE](../agent-personas/NIKE.md) | Head of Marketing/Growth | [agents/nike](nike/state.md) | none yet | 0 / 0 |
| [IRIS](../agent-personas/IRIS.md) | Content & Social Manager | [agents/iris](iris/state.md) | none yet | 0 / 0 |
| [HESTIA](../agent-personas/HESTIA.md) | Head of Support/Customer Success | [agents/hestia](hestia/state.md) | none yet | 0 / 0 |
