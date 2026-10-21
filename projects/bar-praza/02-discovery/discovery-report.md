# Discovery report — Bar Praza (multi-restaurant ordering SaaS)
- Date: 2026-10-21 (preliminary)
- Owner: Head of Product ([SOLON](../../../agent-personas/SOLON.md))
- Contributors: PM, Designer (research), Head of Marketing, CTO, CISO, Business Ops
- Status: **PARTIALLY COMPLETE.** Only the CTO's section is drafted. It becomes formal Phase 1 input once the CEO approves the [idea brief](../01-idea/idea-brief.md).

> Every point is labeled **verified** (with a source), **estimate** or **assumption**.

## Problem evidence (Product)
- TBD by SOLON and PERICLES. Interview Bar Praza's owner and staff about today's order flow, WhatsApp volume, peak hours, the stock routine and payment habits.

## Market and competitors (Marketing)
- TBD by NIKE: restaurant ordering and management tools in Spain, pricing, and positioning against marketplace apps.

## Technical feasibility (CTO)

### T1. What we are building
Five parts on one platform. Each restaurant (a **tenant**) has its own menu, staff, customers, orders and settings:

| Part | Users | Device | Design status |
|---|---|---|---|
| Customer ordering app | Restaurant customers | Phone browser (installable web app) | Not designed yet |
| Admin panel | Owner or manager | Laptop or tablet | **Approved** ([standard](../standards/ux-ui-design-line.md)) |
| Live console | Kitchen and bar | Tablet, always on | Not designed yet |
| Staff mobile ordering | Floor and bar staff | Phone | Not designed yet |
| Platform back office | Ostaru (onboarding, billing, support) | Laptop | Not designed yet |

### T2. The hard parts
1. **Isolation between restaurants.** One restaurant must never see another's data. This is the most important design property of a multi-restaurant SaaS.
2. **Real-time orders.** A new order must reach the live console within seconds and keep working on a bar's unreliable Wi-Fi.
3. **Payments for many restaurants.** Money must go to each restaurant, with refunds, fees and reconciliation, while card data stays out of our systems.
4. **Correct menu data.** Allergens and prices shown to customers are legally sensitive.
5. **Capacity rules.** A maximum number of orders per 15 minutes, minimum preparation time and special closures must be enforced on the server, not only in the app.

### T3. Architecture direction (proposal; the CEO approves at the Phase 2 gate)
- **One codebase and one database for all restaurants** (shared schema). Every row carries a `restaurant_id`, and **database-level row isolation** enforces it (for example PostgreSQL row-level security), on top of checks in the application.
  - Why: simplest to run for many small tenants; new restaurants need configuration only, not code.
  - Alternative: a database per restaurant. Stronger isolation, but heavier operations. Kept as an option for large customers later.
- **Restaurant identity in the URL**, for example a subdomain or path per restaurant, so each one has its own link and QR code for customers.
- **One web front end family** in the approved design line: an installable web app for customers, and responsive web for the panel, console and staff mobile. Native apps are not needed for the MVP [assumption].
- **Real-time console** over a persistent connection (for example WebSockets), with automatic reconnect and a visible "connected" state. The design already shows device status (CONECTADA).
- **Payments through a provider's hosted checkout**, so card data never touches our servers and our PCI scope stays small, with **per-restaurant payouts**. Candidates to evaluate in Phase 2:
  - a marketplace-style provider with connected accounts, such as Stripe Connect;
  - a Spanish bank gateway for Bizum and local cards, such as Redsys.
  Availability, fees and Bizum support must be verified; nothing is chosen yet.
- **Containerised deployment** (Docker), with separate dev, staging and production environments (owner: [PROMETHEUS](../../../agent-personas/PROMETHEUS.md)).
- **Stack choice** (language, framework, database, hosting) will be one ADR per decision in Phase 2. Not decided yet.

### T4. Data model sketch (proposal)
`Restaurant` → `Staff` (role, PIN) and `Device`; `Menu` → `Category` → `Product` → `Variant` (price), with `Allergens` (14 EU) and `StockItem` (unit, minimum, deduction per variant); `OpeningHours`, `OrderingRules` and `SpecialClosure`; `Customer` (consent, masked phone, deletion requests); `Order` → `OrderItem` and `OrderEvent` (status history), with a `channel` of App / Table / Bar; and `Payment` (provider reference, status, refund). Everything except platform tables is scoped by `restaurant_id`. Owner: [JANUS](../../../agent-personas/JANUS.md).

### T5. Risks (CTO view)

| # | Risk | Impact | Mitigation | Owner |
|---|---|---|---|---|
| K-1 | Data leaking between restaurants | Critical | Database-level row isolation, isolation tests on every change, a Red Team test before launch | JANUS, JUPITER |
| K-2 | Lost or late orders on bad bar Wi-Fi | High | Reconnecting console, audible alert, fallback order list, health checks | PROMETHEUS |
| K-3 | Payment errors (charged, but no order) | High | Hosted checkout, idempotent order creation, provider webhooks, daily reconciliation | JANUS (ARGUS pending) |
| K-4 | Wrong allergen information shown | High (legal, health) | Allergens required on each product before it is visible, demo mode until checked (already in the design) | SOLON, Business Ops |
| K-5 | MVP scope too large for the team | High | All four MVP parts plus SaaS foundations is a large scope. Build Bar Praza's flow end to end first, then generalise onboarding | PERICLES, CTO |
| K-6 | Frontend and design roles not active yet | High | Publish APOLLO, DAEDALUS, HERMES and PHIDIAS (their documents are in the vault) | CTO, CEO |
| K-7 | Spanish legal and invoicing obligations (tickets, invoices, GDPR) | Medium–High | Business Operations to verify current rules before launch | CEO (AURELIUS pending), JUPITER |

### T6. Rough effort (estimate, low confidence; not a commitment)
- **MVP for Bar Praza on multi-restaurant foundations:** about **6–9 two-week cycles** with a full squad (frontend, backend, platform, QA, AppSec, design). This assumes the frontend and design agents are activated and the payment provider is chosen by Cycle 2.
- **Self-service onboarding of further restaurants and SaaS billing:** another **3–5 cycles** after the MVP.
- **Running cost during development:** small. One staging server and a database, about **€20–60/month** (estimate). Payment fees are per transaction, paid by the provider's pricing model.

### T7. What the CTO needs before Phase 2
1. Bar Praza's current process and volumes (Product, Phase 1).
2. A payment preference: methods (card, Bizum), and who pays the fees.
3. A pricing idea for the SaaS (Business Ops / CEO).
4. Activation of the frontend and design agents.

## Legal and security risks (CISO)
- TBD by JUPITER. CTO inputs: tenant isolation (K-1), PCI scope through hosted checkout (K-3), GDPR for customer data (consent, masking, deletion, already reflected in the design), and staff PINs and device control.

## Business model (Business Ops)
- TBD. Business Operations is vacant (AURELIUS pending), so the CEO decides: the client terms with Bar Praza, SaaS pricing, and payment fees.

## Assumptions list (riskiest first)

| # | Assumption | Why it is risky | How we will test it | Owner |
|---|---|---|---|---|
| 1 | Bar Praza's customers will order through an app instead of WhatsApp | It is the core adoption risk | Interviews, then a pilot in demo mode | SOLON |
| 2 | Online payments are wanted by customers and acceptable to the bar (fees) | It is in MVP scope but affects cost and complexity | Bar Praza interview, provider comparison | SOLON, CEO |
| 3 | Other restaurants need the same features with configuration only | It is the SaaS premise | Talk to 3–5 other bars | NIKE, SOLON |
| 4 | A web app (no native app) is good enough for customers and staff | It affects scope and cost | Prototype on real phones and tablets | CTO, Designer |
| 5 | The shared-database tenancy model gives enough isolation | It is a security premise | Isolation tests, threat model (G3) | JANUS, JUPITER |
