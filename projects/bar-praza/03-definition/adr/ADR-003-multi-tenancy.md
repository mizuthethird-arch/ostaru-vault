# ADR-003: Multi-restaurant tenancy
- Date: 2026-10-21
- Status: **Proposed.** The CTO decides and the CEO approves. Waiting for CEO approval, together with ADR-002.
- Owner: CTO (with JANUS for the data model, and JUPITER for security review)

## Context
Bar Praza is the first of many restaurants (D-016). One restaurant must never see another's data. That is risk K-1 in the [discovery report](../../02-discovery/discovery-report.md), rated Critical.

## Options considered
1. **A shared database and schema, a `restaurant_id` on every tenant table, and PostgreSQL row-level security.**
2. A schema per restaurant: better separation, but migrations multiply with every restaurant.
3. A database per restaurant: the strongest isolation, but the heaviest to operate. Kept as a later option for large customers.

## Decision (proposed)
Option 1, with two layers of protection:
- The application sets the current restaurant per request from the signed-in staff member, and every module's repository filters by it.
- The database enforces the same rule with row-level security policies, so a bug in the application still cannot leak data.

Platform tables (the restaurants list, Ostaru operators) are the only tables without `restaurant_id`.

## Consequences
- Easier: adding a restaurant is configuration only; there is one migration path and simple operations.
- Harder: every query must run inside a tenant context. Isolation tests are mandatory for every module (the [focused changes, always tested standard](../../../../standards/code/change-discipline-and-testing.md), rule 6), and the threat model (gate G3) must cover it.
