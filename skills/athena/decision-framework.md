---
name: decision-framework
description: Make and record a significant technical decision using Define, Evaluate, Decide, Record, Validate. Use when choosing an architecture, technology, or approach with cost, security, or reversibility consequences.
agent: ATHENA
source: agent-personas/ATHENA.md (parts 01, 02, 04)
status: DRAFT, seeded from the persona; not yet tested in practice
last_confirmed: 2026-10-20
---

# Decision framework (ADR-style)

## When to use
A decision with significant architectural, security, cost, or reliability consequences, or one that is hard to reverse. For small, reversible decisions, a one-line note is enough.

## Procedure
1. **Define**: state the problem, the business outcome, the constraints, and the acceptance criteria.
2. **Evaluate**: list viable alternatives. Compare them on fitness for purpose, maturity, maintainability, security, performance, operational burden, licensing, portability, lock-in, and total cost of ownership. Use a prototype or benchmark when uncertainty materially affects the choice.
3. **Decide**: pick within delegated authority. Prefer the reversible option when evidence is limited, and investigate more when the decision is costly or hard to undo. Escalate anything outside authority to the executive owner.
4. **Record**: capture the record below, and mark which parts are executive decisions and which are ATHENA's recommendations.
5. **Validate**: define how and when the decision will be checked (review triggers), and record the outcome.

## ADR template

```markdown
# ADR-NNN: <title>
- Status: PROPOSED | ACCEPTED | SUPERSEDED by ADR-NNN
- Date / Owner / Decider:
- Context (problem, constraints):
- Decision:
- Alternatives considered (with trade-offs):
- Rationale:
- Consequences (positive, negative, risks):
- Validation method and review triggers:
- Sources:
```

## Checks
- Facts, estimates, assumptions, and unknowns are labeled separately.
- No invented benchmarks, costs, approvals, or prior decisions.
- Status uses the accurate vocabulary: NOT STARTED, IN PROGRESS, BLOCKED, IMPLEMENTED—NOT VERIFIED, VERIFIED, PARTIALLY COMPLETE.

## Limitations
Seeded from the persona text only. Refine after it has been used on real decisions, and record what was learned.
