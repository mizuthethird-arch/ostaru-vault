# CTO decisions and next prompts: ATHENA → JANUS, PERICLES, PROMETHEUS, JUPITER, SOLON
- Date: 2026-10-22
- Project: Bar Praza, Cycle 1
- Source: Owner bypass in the [decision log](../decision-log.md) (entry 2026-10-22). Rule 10: chat replies about 200 words.

## Decisions (JANUS's questions)
- **D1:** option (1). The F1-05 backend (pairing code, device token, token check) moves into F1-a. About +2.5 days [E]; F1-a may spill into week 3.
- **D2:** option (a). Staff pick their name from the restaurant's list, then enter the PIN. Limits per person and per device.
- **Q3:** the operator command prints a one-time temporary PIN; the Encargado must change it at first sign-in.
- **Q4:** the operator command replaces a creation route (JUPITER reviews at G3).
- **R2:** ADR-004 accepted, Kysely.

## Prompts to send now (parallel)
```text
JANUS: Load AGENT-RULES v1.5.0 s.11-12, your state.md, handoffs/2026-10-22-ATHENA-decisions-cycle-1.md and your F1-a breakdown. Update the breakdown for D1 (add the device pairing backend tasks), D2, Q3 and ADR-004 = Kysely. Start task 1 and 2 code; deliver code in chat in small pieces with tests. Rule 9: do not run anything. Reply about 200 words.
```
```text
PERICLES: Load AGENT-RULES v1.5.0 s.11-12, your state.md, the decision-log entry 2026-10-22 and handoffs/2026-10-22-ATHENA-decisions-cycle-1.md. (1) Mark "Cycle 1 ready" and G1 passed in cycle-01.md. (2) Move F1-05 backend into F1-a, add the "change PIN at first sign-in" criterion and H-1..H-14 from EUNOMIA. (3) Write 04-planning/roadmap.md: agent order for the next feature (AGENT-RULES s.12). Reply about 200 words.
```
```text
PROMETHEUS: Load AGENT-RULES v1.5.0 s.11-12, your state.md and your platform spec. Finish the P-01/P-02 files as code in chat (repo layout, Compose, GitHub Actions, dependency-cruiser test). The Owner will create the private repo `ostaru-agora`. Rule 9: do not run anything. Reply about 200 words.
```
```text
JUPITER: Load AGENT-RULES v1.5.0 s.11-12, your state.md, handoffs/2026-10-21-PERICLES-to-JUPITER.md and threat-model.md. You are the interim G3 approver. Answer: PIN length and lockout, session length, phone retention, CSV masking, the operator command. Reply about 200 words.
```
```text
SOLON: Load AGENT-RULES v1.5.0 s.11-12, your state.md and the decision-log entry 2026-10-22. G1 is passed by the Owner. You review the frontend work for the design line (G2). Answer Q9 before F3 and Q11 before M1. Reply about 200 words.
```
