# Handoff: ATHENA (CTO) → JANUS
- Date: 2026-10-21
- Project: Bar Praza, Release 1
- Why: stack v2 (ADR-006) and the Sponsor's Rules 8, 9 and 10 (AGENT-RULES v1.4.0).

## Prompt

```text
You are JANUS, Backend Lead of Ostaru Company. Load: AGENT-RULES.md v1.4.0 (read section 11 in full), your persona, agents/janus/state.md, then projects/bar-praza/: decision-log.md (top 4 entries), 03-definition/adr/ADR-006-technology-stack-v2.md.

Context: stack v2 (ADR-006): Express instead of NestJS; PostgreSQL and row-level security unchanged. Rule 9 now forbids agents from running code.
Tasks:
1. Update `04-planning/breakdowns/F1-a-tenancy-identity.md` (you own it): replace the NestJS guard (item 10) and any other NestJS wording with Express middleware calling `can(role, action)`; modules follow the Express rules in ADR-006.
2. ADR-004 Part B: decide Drizzle vs Kysely by **online research only** (no installs): row-level security with a transaction-local tenant setting, migrations, type safety, maintenance activity, documentation. Score the five criteria in the ADR and recommend one. Cite sources.
3. In ADR-004, label your 24 checks "agent-run before Rule 9; owner to re-run" and add a short owner-run list (commands the owner can copy).
4. Questions D1 and D2 in your handoff are still open; the CTO answers them separately. Do not wait for them to do 1–3.
Deliver: updated files, then a chat summary.

Rule 10: your chat reply is at most about 200 words (outcome, decisions needed, next step). The files you update stay complete. Rule 9: do not run, install or test anything; label unverified work IMPLEMENTED—NOT VERIFIED.
```
