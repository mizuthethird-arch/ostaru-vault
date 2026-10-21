# Cycle 1 plan — Bar Praza (PM-owned)

> Delivered by PERICLES (Product Manager) in chat on 2026-10-21 as planning package v0.2, and filed by the CTO (ATHENA) on 2026-10-21 without content changes. **Since it was drafted, the CEO approved S1–S7, the rule 19 deviation, ADR-002 and ADR-003, and settled Q2 (chat only, the CEO commits). The CTO decided Q8.** See the [decision log](../../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

- **Starts when:** the CEO approves ADR-002 and ADR-003, and the PM and CTO agree "Cycle 1 ready" [V].
- **Length:** two weeks [V: CTO draft].
- **Goal:** a running, tested skeleton. That means the monorepo with CI, tenant-safe sign-in, the admin shell in the design line, and, if capacity allows, the first menu slice.
- **WIP:** at most 2 features per squad [V: workflow §4]. Squads are proposed by the CTO and need CEO confirmation.
- **Must:** P-01, P-02, ADR-004 spike, F1-a, UI-01/02.
- **Stretch:** F2 slice (F2-01 to F2-03).
- **Not in Cycle 1:** F1-b, F2-04 to F2-06, F8, F4 to F7.
- **Why** [V: SOLON]:
  - The WIP limit is 2 per squad.
  - F2 depends on F1-a and UI-02.
  - Isolation is the critical risk.

| Item | Owner | Depends on | Acceptance | Tests required | Size |
|---|---|---|---|---|---|
| P-01 | PROMETHEUS | ADR-002 approved; Q2 | Given a clean checkout, `docker compose up` starts API, dashboard and database, and the dashboard loads. Every change runs lint and all tests in CI, and a failure blocks the merge | A sample unit test per app and package, CI green | M |
| P-02 | PROMETHEUS, JANUS | P-01 | The build fails when a module imports another module's internals, and passes for public-interface imports | A test proving a forbidden import fails (modular-monolith r9) | S |
| ADR-004 spike | JANUS (ADR by CTO) | P-01; ADR-003 approved | Drizzle and Kysely are compared with row-level security. The recommendation is delivered in the first half of the cycle so F1-a can use it [A], and the CTO records ADR-004 | Spike tests show that row-level security blocks a cross-restaurant read | S |
| F1-a | JANUS, VULCAN | P-01, ADR-004 | F1-01 to F1-04 pass. The G3 threat model and G4 contract exist | Unit tests, isolation tests, role table test, PIN tests, all in CI | L |
| UI-01 | CTO (interim) | P-01; Q12 | Tokens implement r5–r9 using the approximate PDF values. Storybook shows every atom (button, input, status pill, checkbox, card) in all states | Component tests: render, states, accessibility basics | M |
| UI-02 | CTO (interim) | UI-01 | Dark sidebar with restaurant name and sections, and the separated group "Consola en vivo" and "Tomar pedido (móvil)" (r1). Overline, serif title and actions on the right (r2). "DATOS DE DEMOSTRACIÓN" shows when demo is on (r12). Spanish copy | Component tests | S |
| F2 slice | JANUS, VULCAN, CTO | F1-a, UI-02 | F2-01 to F2-03 pass | As the stories | M |

**Sequence** [A, Leads confirm]:
- Week 1: P-01, then P-02, the spike and UI-01 in parallel.
- Week 2: F1-a (after the spike) and UI-02.
- F2 starts only when WIP is below 2 and F1-a and UI-02 are merged. Otherwise it moves to Cycle 2, which is the likelier outcome [E, low confidence].

**"Cycle 1 ready" checklist.** I won't declare it alone; it needs the CTO.
- ☐ CEO approves ADR-002, ADR-003 and S1–S7 (Q1).
- ☐ SOLON approves spec v0.2 (G1).
- ☐ Q2 is settled.
- ☐ P-01 timing is decided (Q8).
- ☐ MINOS delivers the test strategy.
- ☐ G3 threat model exists for F1-a (Q7).
- ☐ G4 contract for F1-a is agreed by JANUS and the CTO.
- ☐ The Leads have broken every Cycle 1 item into tasks with an owner and acceptance criteria.
- ☐ PM and CTO agree.

**Cycle risks:**
- UI-01/02 authored by the CTO can't be self-approved (charter §10). I propose another Lead reviews it and the CEO approves under the founder rule [A].
- Q2 and Q3 are not settled.
- The sign-in screen has no design.

**Demo (end of cycle):** sign in with a PIN, see the admin shell with the demo overline, and, if the stretch lands, create categories and products with variants and allergens.

**Written standups:** Done / Doing / Blocked per squad (empty until the cycle starts). **Retro:** keep, change, stop, then each agent records learning in its own folder.
