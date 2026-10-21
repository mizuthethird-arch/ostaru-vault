---
agent: EUNOMIA
role: AppSec / DevSecOps Engineer
state_version: 1
last_updated: 2026-10-21
---

# EUNOMIA: state

Everything needed to recreate EUNOMIA on any platform (Claude, another AI service, or a fresh vault), in **loading order**. Maintained by EUNOMIA under [AGENT-RULES](../../AGENT-RULES.md), section 8.

1. Rules: [AGENT-RULES](../../AGENT-RULES.md)
2. Persona: [EUNOMIA](../../agent-personas/EUNOMIA.md)
3. Operating model: [team charter](../../operating-model/team-charter.md), [startup workflow](../../operating-model/startup-workflow.md), [agent roster](../../operating-model/agent-roster.md)
4. Company context: [general-context](../../general-context.md)
5. Negative behavior (never do): [behavior/negative.md](behavior/negative.md)
6. Positive behavior (keep doing): [behavior/positive.md](behavior/positive.md)
7. Local skills:
   - None yet.
8. Applicable design standards: [standards/README](../../standards/README.md) (none approved yet)

## Current working notes
- 2026-10-21: drafted the Bar Praza F1-a threat model (DRAFT v0.1, 20 threats), see projects/bar-praza/03-definition/threat-model.md. Waiting on JUPITER (PIN rules, retention) and ODYSSEUS (review); MINOS owns the test strategy. Handoff: projects/bar-praza/handoffs/2026-10-21-EUNOMIA-to-MINOS-and-JUPITER.md.
- Learning: a short PIN is only safe with throttling plus a server-side pepper, and RLS only holds if the runtime role is not the table owner and the tenant is set per transaction.
- 2026-10-22: threat model v0.2 after stack v2 (ADR-006): T-18 covers the Express/React/npm tree, T-21 covers Socket.IO, T-22 to T-28 cover device pairing (Q8), plus Express hardening criteria H-1 to H-14. Handoff to PERICLES: projects/bar-praza/handoffs/2026-10-22-EUNOMIA-to-PERICLES.md. Open: JUPITER confirms the numbers, CTO decides whether a pairing code is tied to a restaurant on entry.
- Learning: with Rule 9 a threat model is a requirements document; every control stays IMPLEMENTED—NOT VERIFIED until the owner runs the tests. A pairing code entered before sign-in is the most exposed entry point.
