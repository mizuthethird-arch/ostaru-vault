# User stories — Bar Praza Release 1

> Delivered by PERICLES (Product Manager) in chat on 2026-10-21 as planning package v0.2, and filed by the CTO (ATHENA) on 2026-10-21 without content changes. **Since it was drafted, the CEO approved S1–S7, the rule 19 deviation, ADR-002 and ADR-003, and settled Q2 (chat only, the CEO commits). The CTO decided Q8.** See the [decision log](../../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

Proposed filing path: `projects/bar-praza/04-planning/stories/`. The workflow folder structure has no stories folder, so the CTO decides.

## Common acceptance criteria (apply to every story)
- **C1** Criteria are testable Given/when/then. A story fits one cycle (max size M [E]). A Lead who judges one larger splits it before "Cycle 1 ready".
- **C2** A story touching restaurant data requires "restaurant A never sees restaurant B" plus an automated isolation test (ADR-003; change-discipline r6).
- **C3** Every action is checked on the server against the role. Each story has one allowed and one denied test per role involved (design line r17).
- **C4** UI:
  - Spanish copy (r10) and prices like 11,00 € (r9).
  - Empty, loading and error states.
  - Demo overline when demo mode is on (r12), and status pills per r7.
  - Side-panel editing where a list is edited (r4).
  - The PR states it follows design line v1.0.0.
- **C5** Only the files the story needs. No refactor and no speculative generality (Rule 4). The story's out-of-scope list is binding.
- **C6** Done = unit tests written and run, CI green, and gates passed. If tests weren't run, the status is IMPLEMENTED—NOT VERIFIED (change-discipline r10). Code is delivered in chat until the CEO approves direct codebase work.
- **C7** PRs state they follow modular-monolith v1.0.0, change-discipline v1.0.0 and ux-ui-design-line v1.0.0 (AGENT-RULES s.9).

Gates: G1 spec, G2 design, G3 threat model (auth, personal data, uploads), G4 API contract, G5 merge, G6 QA, G7 security. G8 is the release.

## Files
- [F1 Foundation](f1-foundation.md)
- [F2 Carta y productos](f2-carta.md)
- [F8 Personal y ajustes](f8-personal.md)

Filing path decided by the CTO: `04-planning/stories/`, one file per feature, with the common criteria in this README.
