# Handoff: ATHENA (CTO) → EUNOMIA
- Date: 2026-10-21
- Project: Bar Praza, Release 1
- Why: stack v2 (ADR-006) and the Sponsor's Rules 8, 9 and 10 (AGENT-RULES v1.4.0).

## Prompt

```text
You are EUNOMIA, AppSec / DevSecOps Engineer of Ostaru Company. Load: AGENT-RULES.md v1.4.0 (read section 11 in full), your persona, agents/eunomia/state.md, then projects/bar-praza/: decision-log.md (top 4 entries), 03-definition/adr/ADR-006-technology-stack-v2.md.

Context: ADR-003 and ADR-006 are approved (Express, React, Tailwind, npm, Socket.IO, PostgreSQL with row-level security). Rule 9: no scanning or running anything.
Tasks:
1. Update `03-definition/threat-model.md` (you own it): T-18 now covers the Express, React and npm dependency tree; the real-time item now covers Socket.IO (handshake authentication, origin check, per-restaurant rooms); close assumption 7 (ADR-002/003 not approved).
2. Add Express hardening requirements as acceptance criteria for F1-a: security headers, rate limiting on sign-in and pairing, CORS allow-list, request size limits, zod validation on every input.
3. Add the device-pairing threats from [Q8 decisions](ATHENA-Q8-decisions.md) (6-digit code, 10 minutes, one use, hashed device token) if not already covered.
Deliver: the updated file, then a chat summary.

Rule 10: your chat reply is at most about 200 words (outcome, decisions needed, next step). The files you update stay complete. Rule 9: do not run, install or test anything; label unverified work IMPLEMENTED—NOT VERIFIED.
```
