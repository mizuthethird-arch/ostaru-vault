# Handoff: EUNOMIA → MINOS (QA Lead) and JUPITER (CISO)
- Date: 2026-10-21
- Project: Bar Praza, Cycle 1, item F1-a (tenancy and identity core)
- Why: Rule 7. The F1-a threat model is drafted, and two parts need other owners first. EUNOMIA does not decide test strategy or retention and PIN policy.
- Input: [threat model F1-a, DRAFT v0.1](../03-definition/threat-model.md)

## Prompt for JUPITER (CISO): PIN rules and retention
> You are JUPITER, CISO. Read AGENT-RULES, your persona, and `projects/bar-praza/03-definition/threat-model.md` (DRAFT v0.1 by EUNOMIA). Answer open questions 1 to 4 as a short decision note for Bar Praza Release 1, and label each point as verified, assumption or recommendation:
> 1. PIN rules: length and format, who may set or reset whose PIN, lockout and throttling numbers, session idle timeout, and what must be audited. EUNOMIA's starting proposal: 6 digits, no uniqueness requirement, a registered device plus a named person plus the PIN, argon2id or scrypt plus a server-side pepper, growing lockout.
> 2. Retention periods: sign-in and audit events, staff records after leaving, and staff-entered customer phone numbers (decision S5). Say which need legal or privacy input, since no privacy owner exists yet (route through the CTO to the CEO).
> 3. Review severities T-1 to T-20 and say whether any is wrong, and whether any residual risk needs a CEO decision.
> Do not claim GDPR compliance. Do not edit RULES or general-context. Propose, and put your note in `projects/bar-praza/05-security/`.

## Prompt for MINOS (QA Lead): test strategy
> You are MINOS, QA Lead. Read AGENT-RULES, your persona, the standard `standards/code/change-discipline-and-testing.md`, the MVP spec (F1 acceptance criteria), `cycle-01.md`, and the "Test" column of `threat-model.md` (DRAFT v0.1). Draft the Bar Praza test strategy for Cycle 1 and Release 1: test levels (Vitest, Supertest, Playwright per ADR-002), the mandatory tenant isolation suite per module, the permission-matrix test (every endpoint × every role), PIN and session tests, the throttled-network test for the console (3 s p95), and release gates. List which security tests from the threat model you will own, and which EUNOMIA keeps in CI (dependency and secret scanning). Mark the draft DRAFT and put it in `projects/bar-praza/04-planning/`.

## Status
| Item | Owner | State |
|---|---|---|
| F1-a threat model | EUNOMIA | DRAFT v0.1 written |
| Review of attack cases | ODYSSEUS | Not started; no testing without approved rules of engagement |
| PIN rules and retention | JUPITER | Waiting for the prompt above |
| Test strategy | MINOS | Waiting for the prompt above |
