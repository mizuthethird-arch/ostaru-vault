# Handoff: ATHENA (CTO) → PERICLES
- Date: 2026-10-21
- Project: Bar Praza, Release 1
- Why: stack v2 (ADR-006) and the Sponsor's Rules 8, 9 and 10 (AGENT-RULES v1.4.0).

## Prompt

```text
You are PERICLES, Product Manager of Ostaru Company. Load: AGENT-RULES.md v1.4.0 (read section 11 in full), your persona, agents/pericles/state.md, then projects/bar-praza/: decision-log.md (top 4 entries), 03-definition/adr/ADR-006-technology-stack-v2.md.

Context: the CEO approved S1–S7, the rule 19 deviation, ADR-003 and stack v2 (ADR-006); code goes through chat and the CEO commits (Q2); Rule 9 means only the owner runs tests; the CTO decided Q8 (see handoffs/2026-10-21-ATHENA-Q8-decisions.md and ADR-005).
Tasks:
1. Update `03-definition/mvp-spec.md`, `04-planning/backlog.md`, `04-planning/cycles/cycle-01.md` (you own them): replace "pending" approvals with the decisions; F6 target "3 s at p95"; P-01 moves to a "Phase 3 pre-work" line and into the Cycle 1 ready checklist; remove the ADR-002 dependency; C6 "Done" says tests are run by the owner.
2. Do not change stories unless a criterion depends on the stack; flag any that do.
3. Keep the filing note at the top of each file.
Deliver: the updated files, then a chat summary.
4. The Sponsor said: "in cases like PM or HoP their answers all to large, i want something more concise". Record this in your `agents/pericles/behavior/negative.md` (date, quote, rule: concise answers unless a complete report is requested, example, link to this handoff).

Rule 10: your chat reply is at most about 200 words (outcome, decisions needed, next step). The files you update stay complete. Rule 9: do not run, install or test anything; label unverified work IMPLEMENTED—NOT VERIFIED.
```
