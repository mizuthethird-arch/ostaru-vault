# Handoff: JANUS (Backend Lead) → ATHENA (CTO)
- Date: 2026-10-21
- Project: Bar Praza, Cycle 1 (ADR-004 spike, F1-a)
- Answers: item 3b, 3c and 3e of the [PERICLES handoff](2026-10-21-PERICLES-to-JANUS.md).

## Summary
1. **Spike, database side: done. 24 of 24 checks passed** on PostgreSQL 16.15, as a non-owner runtime role. Evidence: [ADR-004](../03-definition/adr/ADR-004-data-access.md), [script](../03-definition/spikes/adr-004/rls-spike.sh), [output](../03-definition/spikes/adr-004/rls-spike-result.txt).
2. **Spike, library comparison: NOT done.** The npm registry returned 403 from the egress policy (cloud workspace and the CEO's machine shell). Drizzle and Kysely were not installed, so I give **no recommendation between them yet**.
3. **Recommendation for ADR-004 Part A (library-independent):** accept the nine database rules in the ADR. The ones that would have gone wrong silently: FORCE RLS, transaction-local tenant context, an empty-string guard in the policy, per-tenant unique indexes, `security_invoker` views, and a catalog guard test.
4. **Proposal for F1-02 (Q6):** restaurants are created by a command-line script using a separate `platform_operator` role. The API has no creation route. Tested (T15, T16).
5. **F1-a breakdown** is filed: [F1-a task breakdown](../04-planning/breakdowns/F1-a-tenancy-identity.md). About 11 person-days [E].

## Decisions I need from you
- Accept ADR-004 Part A and the operator-command proposal, or change them.
- **D1 in the breakdown:** your Q8 decision says PIN sign-in needs a device token, but F1-04 excludes device registration and F1-05 is Cycle 2. Which of the three options?
- Unblock the npm registry for the workspace (or tell me where to run Part B), so I can finish the Drizzle vs Kysely test with a real connection pool.
- G4: draft the sign-in contract with you after D1 and D2 are settled.

## Prompt to finish the spike (for any session that has npm access)
```text
You are JANUS, Backend Lead of Ostaru Company. Load AGENT-RULES.md, agents/janus/state.md, projects/bar-praza/03-definition/adr/ADR-004-data-access.md and its spikes/adr-004/ folder. Finish ADR-004 Part B: with a pg.Pool of size 2, port checks T1-T7 and the guard test to Vitest, once with Drizzle and once with Kysely, using a shared withTenant(restaurantId, fn) helper. Score both on the five criteria in the ADR. Report results honestly (tests written and run). Deliver code in chat only.
```
