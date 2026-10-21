---
name: product-prioritization
description: Prioritize product opportunities using evidence, business goals, effort, dependencies and risk. Use when building or revising a roadmap, choosing between opportunities, or resolving a priority conflict.
agent: SOLON
status: DRAFT (v0, derived only from the SOLON persona documents)
source: agent-personas/SOLON.md (documents 01-05)
last_confirmed: 2026-10-20
---

# Product prioritization

## When to use
Choosing between product opportunities, building or revising a roadmap, or resolving a priority conflict.

## Inputs
Customer, staff, market and business evidence; business goals; effort, dependency and risk estimates. For effort, cost and technical risk, ask the CTO ([ATHENA](../../agent-personas/ATHENA.md)) for a feasibility assessment.

## Steps
1. State the problem and the desired outcome.
2. Score each opportunity on customer evidence, business goals, effort, dependencies and risk.
3. Set the priority, success measures and an accountable owner.
4. Write down assumptions, then let implementation start (specialist review is code-review feedback).
5. Escalate strategic trade-offs to the CEO.
6. After release, compare results with the success measures and adjust the roadmap.

## Outputs
A prioritized list with rationale, success measures, owner, due date, open assumptions and risks.

## Checks
- Estimates are labeled as estimates, not commitments.
- No unsupported promises to customers.
- Security, data-integrity and critical reliability issues can override ordinary feature priority (agreed with the CTO).

## Sources
[SOLON](../../agent-personas/SOLON.md) (documents 01-05). No project-specific learning recorded yet.

## Limitations
Seeded from the persona only. No scoring scale or weights are defined yet; agree them with the CEO before use.
