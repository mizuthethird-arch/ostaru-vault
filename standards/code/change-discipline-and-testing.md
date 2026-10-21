---
standard: change-discipline-and-testing
area: code
scope: company
version: 1.0.0
status: APPROVED
owner: CTO (ATHENA), with the QA Lead (MINOS)
approved_by: CEO, 2026-10-21 (Project instruction, Rule 4)
---

# Focused changes, always tested

## Purpose
The CEO's Rule 4 (code work): *"Always modify only files needed, never do big changes through a lot of files if it not necessary; when we build a feature we work on that, not in a complete refactor because we thought is a good decision; every feature should be correct and right, not over engineering (just if I ask so) and always with unit tests; we need to test everything to make sure we are delivering quality code and working features. Only in specific and needed files."*

Binding for every agent that writes code ([AGENT-RULES](../../AGENT-RULES.md), sections 2 and 9).

## Rules

### Scope of a change
1. A change MUST touch **only the files the feature or fix needs**. List the files changed and why.
2. MUST NOT refactor, rename, reformat or "improve" code outside the feature's scope, even if it looks better. Propose it separately as its own item; the CEO or Lead decides.
3. One change = one feature or one fix. Large features are split into small, reviewable steps.
4. MUST NOT over-engineer. No speculative abstractions, layers, configuration or generality beyond the requirement, unless the CEO asks. The [modular monolith](../architecture/modular-monolith.md) rules are not over-engineering; they are required.

### Correctness and tests
5. Every feature or fix MUST ship with **unit tests** that cover its behaviour, including edge cases and error paths. No tests means not done.
6. Business rules (prices, stock, ordering limits, permissions, tenant isolation) MUST have explicit tests.
7. A bug fix MUST include a test that fails before the fix and passes after it.
8. Tests MUST run in CI on every change, and a change with failing tests is not merged (gate G5).
9. Integration tests cover module interfaces and database access, including the tenant isolation rules. End-to-end tests cover the main user flows before a release (gate G6).
10. Report honestly: say which tests were written and **run**, with the result. Never claim tests pass without running them; otherwise the status is IMPLEMENTED—NOT VERIFIED.

### Delivery
11. Code is delivered in chat as a complete, reviewable proposal (or a clear diff) until the CEO approves direct codebase work ([AGENT-RULES](../../AGENT-RULES.md), section 2).
12. After an approved and committed change, the agent records what it learned in its internal folder (the CEO's Rule 5; [AGENT-RULES](../../AGENT-RULES.md), section 8).

## How conformance is checked
Code review (gate G5) checks the file list against the feature, the absence of unrelated changes, and the tests; QA sign-off (gate G6) checks behaviour.

## Change log
| Version | Date | Note |
|---|---|---|
| 1.0.0 | 2026-10-21 | Created from the CEO's Rule 4 (Project instructions). |
