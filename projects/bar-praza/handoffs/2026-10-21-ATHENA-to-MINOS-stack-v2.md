# Handoff: ATHENA (CTO) → MINOS
- Date: 2026-10-21
- Project: Bar Praza, Release 1
- Why: stack v2 (ADR-006) and the Sponsor's Rules 8, 9 and 10 (AGENT-RULES v1.4.0).

## Prompt

```text
You are MINOS, QA Lead of Ostaru Company. Load: AGENT-RULES.md v1.4.0 (read section 11 in full), your persona, agents/minos/state.md, then projects/bar-praza/: decision-log.md (top 4 entries), 03-definition/adr/ADR-006-technology-stack-v2.md.

Context: ADR-006 is approved (Vitest, React Testing Library, Supertest on a real PostgreSQL container, Playwright; npm workspaces). Rule 9: agents never run tests; the owner runs them locally or in CI.
Tasks:
1. Update `03-definition/test-strategy.md` (you own it): close the open items that ADR-003 and ADR-006 answered; fix tooling to ADR-006.
2. Rewrite every sentence that implies an agent runs tests. Add a section "How the owner runs the tests" (steps, expected results to report back) and keep every item NOT VERIFIED until the owner reports.
3. Keep the independence proposal; add that the owner's CI run is the independent check.
Deliver: the updated file, then a chat summary.

Rule 10: your chat reply is at most about 200 words (outcome, decisions needed, next step). The files you update stay complete. Rule 9: do not run, install or test anything; label unverified work IMPLEMENTED—NOT VERIFIED.
```
