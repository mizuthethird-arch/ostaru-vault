# Backlog — Bar Praza
- Owner: PM ([PERICLES](../../../agent-personas/PERICLES.md)); drafted by the CTO, 2026-10-21
- Last updated: 2026-10-21

> Ordered by build sequence (CEO, 2026-10-21): **dashboard first, public app last.** Every item needs acceptance criteria (see the [MVP spec](../03-definition/mvp-spec.md)) and unit tests ([standard](../../../standards/code/change-discipline-and-testing.md)). Gates: G1 spec, G2 design, G3 threat model (auth, payments, personal data), G4 API contract, G5 merge, G6 QA.

| Order | ID | Feature / task | Module | Owner | Depends on | Gates | Status |
|---|---|---|---|---|---|---|---|
| 1 | P-01 | Monorepo, Docker Compose, CI running tests on every change | platform | PROMETHEUS | ADR-002 approval | G5 | NOT STARTED |
| 2 | P-02 | Architecture test: modules cannot import each other's internals | platform | PROMETHEUS, JANUS | P-01 | G5 | NOT STARTED |
| 3 | F1-a | Tenancy and identity core: restaurants, staff, roles, PIN sign-in, tenant context, row-level security, isolation tests | tenancy, identity | JANUS, VULCAN | P-01, ADR-003 approval | G1, G3, G4, G5, G6 | NOT STARTED |
| 4 | UI-01 | Design tokens and atoms (button, input, pill, checkbox, card) from the design line, in Storybook | ui | CTO (interim Frontend Lead) | P-01 | G2, G5 | NOT STARTED |
| 5 | UI-02 | Admin shell template: sidebar, overline, page title, actions | ui | CTO (interim) | UI-01 | G2, G5 | NOT STARTED |
| 6 | F2 | Carta y productos: categories, products, variants, allergens, photo, flags, side-panel editor | catalog | JANUS, VULCAN, CTO (UI) | F1-a, UI-02 | G1, G2, G4, G5, G6 | NOT STARTED |
| 7 | F8 | Personal y ajustes: team, permission matrix, PINs, devices, restaurant data, demo mode | identity, tenancy | VULCAN, CTO (UI) | F1-a | G1, G2, G3, G4, G5, G6 | NOT STARTED |
| 8 | F4 | Horario y pedidos: hours, closures, ordering rules, pause | scheduling | VULCAN | F1-a | G1, G2, G4, G5, G6 | NOT STARTED |
| 9 | F3 | Stock: items, movements, minimums, auto sold out, shopping list | inventory | VULCAN | F2 | G1, G2, G4, G5, G6 | NOT STARTED |
| 10 | F7 | Tomar pedido (móvil): staff order taking and charging at the bar | ordering | JANUS, VULCAN | F2, F4 | G1, G2, G4, G5, G6 | NOT STARTED |
| 11 | F6 | Consola en vivo: real-time order board | ordering | JANUS, PROMETHEUS | F7 | G1, G2, G4, G5, G6 | NOT STARTED |
| 12 | F5 | Pedidos: list, filters, detail, history, export | ordering | VULCAN | F7 | G1, G2, G4, G5, G6 | NOT STARTED |
| 13 | F9 | Clientes: customers from orders, masking, data requests | customers | VULCAN | F7 | G1, G2, G3, G5, G6 | NOT STARTED |
| 14 | F10 | Informes: KPIs, charts, top products, peak hours, export | reporting | VULCAN | F5 | G1, G2, G5, G6 | NOT STARTED |
| 15 | F11 | Resumen: today's summary page | reporting | VULCAN, CTO (UI) | F10 | G1, G2, G5, G6 | NOT STARTED |
| — | R2 | **Later:** public customer app, online payments, customer accounts, self-service restaurant onboarding, SaaS billing | — | — | Release 1 | all | NOT STARTED |

**Resourcing note:** the UI work is covered by the CTO only until the frontend agents (APOLLO, DAEDALUS, HERMES) and the designer (PHIDIAS) are published. Their activation is the main capacity risk.
