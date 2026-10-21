# Handoff: MINOS (QA Lead) → EUNOMIA (AppSec), cc ODYSSEUS and JUPITER
- **SUPERSEDED (2026-10-22):** EUNOMIA already filed the F1-a threat model (draft v0.1), and the stack changed (ADR-006). Kept as a record only; do not paste it.
- Date: 2026-10-21
- Project: Bar Praza, Release 1, feature F1-a (tenancy and identity core)
- Why: the threat model (gate G3) belongs to the Red Team Lead and AppSec, reviewed by the CISO ([workflow](../../../operating-model/startup-workflow.md), section 5). The Red Team Lead is vacant, so ODYSSEUS contributes. MINOS does not write it ([AGENT-RULES](../../../AGENT-RULES.md), section 10). MINOS needs it first so the abuse cases can become tests.
- Order: EUNOMIA first. JUPITER reviews. Then MINOS turns the threats into tests.

## Prompt (paste into EUNOMIA's chat)

```text
You are EUNOMIA, AppSec / DevSecOps Engineer of Ostaru Company. You report to ARTEMIS; the CISO is JUPITER.

1. Load your context from the Ostaru Company project knowledge (or the vault), in this order:
   - Ostaru-company/AGENT-RULES.md (sections 8, 9, 10)
   - Ostaru-company/agent-personas/EUNOMIA.md and Ostaru-company/agents/eunomia/state.md
   - Ostaru-company/operating-model/team-charter.md (section 7: Red / Blue cycle, severity) and startup-workflow.md (gate G3)
   - Ostaru-company/projects/bar-praza/03-definition/threat-model.md (the template to fill)
   - Ostaru-company/projects/bar-praza/03-definition/mvp-spec.md (F1, F8)
   - Ostaru-company/projects/bar-praza/03-definition/adr/ADR-003-multi-tenancy.md and ADR-001, ADR-002
   - Ostaru-company/projects/bar-praza/02-discovery/discovery-report.md (risks K-1 and K-2)
   - Ostaru-company/projects/bar-praza/03-definition/test-strategy.md (MINOS draft, section 4)

2. Context:
   - F1-a is the tenancy and identity core: restaurants, staff, roles, PIN sign-in on registered devices, tenant context, PostgreSQL row-level security. It touches authentication and personal data, so it needs the threat model at gate G3.
   - Release 1 is the restaurant dashboard. Staff sign in with a PIN on shared bar devices. One restaurant must never see another's data (K-1, Critical).
   - ADR-002 and ADR-003 are proposed and waiting for the CEO. Treat them as the working design and say where your conclusions depend on them.
   - JUPITER is setting the PIN rules and the retention period at the same time (handoff MINOS → JUPITER). Do not invent them; list what you need from JUPITER.

3. Your task:
   a. Fill the threat model for F1-a using the template: system and data flows, assets, trust boundaries and entry points, threats with likelihood, impact, severity (charter 7.3), mitigation and owner, and open questions.
   b. Coordinate with ODYSSEUS (Red Team) on attacker paths and ask JUPITER to review.
   c. MINOS asks you to make sure the model covers at least these abuse cases (add others you find):
      - cross-restaurant read or write through the API, guessed ids, joins and cross-tenant references
      - missing or leaked tenant context (forgotten context, pooled connections)
      - row-level security skipped because of the database role used by the app
      - PIN guessing and brute force, shoulder-surfing on shared devices, PIN reuse across people
      - a stolen, lost or disconnected device that stays signed in
      - privilege escalation between Cocina, Sala y barra and Encargado
      - an Ostaru operator or platform table reached from a restaurant session
      - PINs or personal data in logs, errors or API responses
      - demo mode turned off by someone who is not the Encargado
   d. For each threat say whether it should be covered by an automated test, a manual check, or a scan in CI, so MINOS can plan it.

4. Constraints:
   - Follow AGENT-RULES. No credentials, real user data or exploit code in the vault. Deliver in chat; the CTO files the document.
   - Do not decide the PIN rules or the retention period (JUPITER) and do not accept business risk (CEO).

5. Deliver: (1) the filled threat model for F1-a; (2) the mapping threat → test type; (3) open questions for JUPITER and the CTO.
```
