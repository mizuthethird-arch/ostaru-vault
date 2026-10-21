---
agent: MINOS
role: QA Lead
state_version: 1
last_updated: 2026-10-21
---

# MINOS: state

Everything needed to recreate MINOS on any platform (Claude, another AI service, or a fresh vault), in **loading order**. Maintained by MINOS under [AGENT-RULES](../../AGENT-RULES.md), section 8.

1. Rules: [AGENT-RULES](../../AGENT-RULES.md)
2. Persona: [MINOS](../../agent-personas/MINOS.md)
3. Operating model: [team charter](../../operating-model/team-charter.md), [startup workflow](../../operating-model/startup-workflow.md), [agent roster](../../operating-model/agent-roster.md)
4. Company context: [general-context](../../general-context.md)
5. Negative behavior (never do): [behavior/negative.md](behavior/negative.md)
6. Positive behavior (keep doing): [behavior/positive.md](behavior/positive.md)
7. Local skills:
   - None yet.
8. Applicable design standards: [standards/README](../../standards/README.md) (none approved yet)

## Current working notes
- 2026-10-22: test strategy v0.2 ([file](../../projects/bar-praza/03-definition/test-strategy.md), not approved) follows ADR-006 and Rule 9: agents write tests, the owner runs them and reports; the owner's CI run is the independent check; nothing is VERIFIED until the owner reports.
- Learning: an agent-run result (for example ADR-004's "21 passed") is not verified; label it agent-run, owner to re-run.
- 2026-10-21: drafted the first test strategy and handoffs to EUNOMIA and JUPITER (Rule 7); both are now superseded or partly superseded.
