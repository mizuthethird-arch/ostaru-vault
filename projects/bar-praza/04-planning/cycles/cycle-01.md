# Cycle 1 plan — Bar Praza (PM-owned)

> Package v0.2 by PERICLES (Product Manager), filed 2026-10-21. **v0.3 on 2026-10-22** after the Owner bypass (all blockers cleared, Cycle 1 starts), ATHENA's decisions handoff and EUNOMIA's hardening criteria H-1 to H-14. See the [decision log](../../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

- **Status: CYCLE 1 READY. G1 PASSED.** Marked by PERICLES on 2026-10-22 under the Owner bypass ("[BYPASS all blocking] right now i OWNER approve all", [decision log](../../decision-log.md), 2026-10-22) and ATHENA's [decisions handoff](../../handoffs/2026-10-22-ATHENA-decisions-cycle-1.md). Items still open in the checklist are tracked below, not blockers.
- **Length:** two weeks [V: CTO draft].
- **Goal:** a running, tested skeleton. That means tenant-safe sign-in, the admin shell in the design line and, if capacity allows, the first menu slice, on top of the repository and CI built as pre-work.
- **WIP:** at most 2 features per squad [V: workflow §4]. Squads are proposed by the CTO and need CEO confirmation.
- **Phase 3 pre-work (before the cycle):** P-01, monorepo with npm workspaces, Docker Compose and GitHub Actions CI ([ADR-006](../../03-definition/adr/ADR-006-technology-stack-v2.md)). Owner PROMETHEUS [V: CTO Q8]. It needs a private repository and CI from the CEO (Q13). "P-01 merged with CI green" is part of the checklist.
- **Must:** P-02 (may also start as pre-work; otherwise it takes week 1), F1-a (F1-01 to F1-05, with H-1 to H-14), UI-01/02. ADR-004 is accepted (Kysely), so it is no longer a work item.
- **Stretch:** F2 slice (F2-01 to F2-03).
- **Not in Cycle 1:** F2-04 to F2-06, F8, F4 to F7. (F1-b is merged into F1-a.)
- **Capacity warning:** JANUS's breakdown v2 is 17 tasks, about 14 person-days [E, low confidence]. F1-a may spill into week 3. The F2 slice is very likely Cycle 2.
- **Why** [V: SOLON]:
  - The WIP limit is 2 per squad.
  - F2 depends on F1-a and UI-02.
  - Isolation is the critical risk.
- **Done (Rule 9):** tests are written. Agents do not run them. The owner runs the tests, in CI or locally, and reports the result. Until then every item is IMPLEMENTED—NOT VERIFIED. Code is delivered in chat and the CEO commits it.

| Item | Owner | Depends on | Acceptance | Tests required | Size |
|---|---|---|---|---|---|
| P-02 | PROMETHEUS, JANUS | P-01 | The build fails when a module imports another module's internals (dependency-cruiser, ADR-006), and passes for public-interface imports | A test proving a forbidden import fails (modular-monolith r9) | S |
| F1-a | JANUS, VULCAN | P-01, ADR-004 (accepted) | F1-01 to F1-05 pass, including H-1 to H-14 and change-PIN-at-first-sign-in. G3 (interim approver JUPITER) and G4 exist | Unit tests, isolation tests (Supertest against a real PostgreSQL container, per ADR-006), role table test, PIN tests, pairing tests, hardening tests, all in CI | L |
| UI-01 | CTO (interim) | P-01; Q12 | Tokens implement r5–r9 as the Tailwind theme, using the approximate PDF values. Storybook shows every atom (button, input, status pill, checkbox, card) in all states | Component tests: render, states, accessibility basics | M |
| UI-02 | CTO (interim) | UI-01 | Dark sidebar with restaurant name and sections, and the separated group "Consola en vivo" and "Tomar pedido (móvil)" (r1). Overline, serif title and actions on the right (r2). "DATOS DE DEMOSTRACIÓN" shows when demo is on (r12). Spanish copy | Component tests | S |
| F2 slice | JANUS, VULCAN, CTO | F1-a, UI-02 | F2-01 to F2-03 pass | As the stories | M |

**Sequence** [A, Leads confirm]:
- Before the cycle: P-01. P-02 may start now.
- Week 1: F1-a starts at once (ADR-004 is done); P-02 if unfinished; UI-01.
- Week 2: F1-a continues; UI-02.
- Week 3 (spill): the rest of F1-a if JANUS's estimate holds.
- F2 starts only when WIP is below 2 and F1-a and UI-02 are merged. Otherwise it moves to Cycle 2, which is the likelier outcome [E, low confidence].

**"Cycle 1 ready" checklist (2026-10-22: marked ready under the Owner bypass).**
- ☑ CEO approves ADR-003, the stack (ADR-006) and S1–S7 (2026-10-21).
- ☑ Code delivery decided: chat only, the CEO commits (2026-10-21).
- ☑ P-01 timing decided: Phase 3 pre-work (CTO Q8).
- ☑ SOLON G1 on spec v0.2.1: passed by the Owner bypass (2026-10-22).
- ☑ ADR-004 accepted (Kysely).
- ☑ G3 interim approver named: JUPITER (EUNOMIA's threat model v0.2 exists with H-1 to H-14).
- ☑ MINOS test strategy v0.2 exists (draft).
- ☑ Leads' breakdown for F1-a exists (JANUS v2, 17 tasks).
- ☑ PM and CTO agree (ATHENA's handoff, 2026-10-22).
- ◐ **Tracked, not blocking:** Q13 repository `ostaru-agora` and CI; P-01 merged with CI green (Owner runs it, Rule 9); G4 contract for F1-a; JUPITER confirms the [A] numbers (threat-model open questions 3 and 8); breakdowns for P-02, UI-01/02.

**Story changes after the Q8 decisions and ATHENA's handoff (done in stories v0.3):** F1-02 is an operator command with temporary PIN and first pairing code. F1-05 backend is in F1-a. F1-04 has name-then-PIN and change-PIN-at-first-sign-in. F2-05 storage is ADR-005.

**Cycle risks:**
- UI-01/02 authored by the CTO can't be self-approved (charter §10). I propose another Lead reviews it and the CEO approves under the founder rule [A].
- Q3 is not settled in the design: the sign-in and pairing screens have no design (G2).
- Q13 (repository and CI) is tracked; until P-01 is merged nothing runs in CI.
- F1-a capacity: about 14 person-days [E] against a one-week window.
- Results depend on the owner running tests and reporting back (Rule 9).

**Demo (end of cycle):** sign in with a PIN, see the admin shell with the demo overline, and, if the stretch lands, create categories and products with variants and allergens.

**Written standups:** Done / Doing / Blocked per squad (empty until the cycle starts). **Retro:** keep, change, stop, then each agent records learning in its own folder.
