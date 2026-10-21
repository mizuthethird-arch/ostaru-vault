# User stories — Bar Praza Release 1

> Package v0.2 by PERICLES (Product Manager), filed 2026-10-21. **v0.3 on 2026-10-22** after the Owner bypass (all blockers cleared, Cycle 1 starts), ATHENA's decisions handoff and EUNOMIA's hardening criteria H-1 to H-14. See the [decision log](../../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

Filing path decided by the CTO: `04-planning/stories/`, one file per feature, with the common criteria in this README.

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
- **C6** Done = unit tests written, CI green and gates passed. Agents do not run tests (Rule 9): the owner runs them and reports the result. Until then the status is IMPLEMENTED—NOT VERIFIED (change-discipline r10). Code is delivered in chat and the CEO commits it.
- **C7** PRs state they follow modular-monolith v1.0.0, change-discipline v1.0.0 and ux-ui-design-line v1.0.0 (AGENT-RULES s.9). The stack is [ADR-006](../../03-definition/adr/ADR-006-technology-stack-v2.md).

Gates: G1 spec, G2 design, G3 threat model (auth, personal data, uploads), G4 API contract, G5 merge, G6 QA, G7 security. G8 is the release.

## Files
- [F1 Foundation](f1-foundation.md)
- [F2 Carta y productos](f2-carta.md)
- [F8 Personal y ajustes](f8-personal.md)

## Security criteria
EUNOMIA's H-1 to H-14 (threat model, "Express hardening") are written into F1-01 to F1-05. A story that adds an endpoint also meets H-7 (validation, error handler, rate limit, audit). Numbers marked [A] are proposals until JUPITER confirms them.

## Changes on 2026-10-22 (v0.3)
- F1-05 backend moved into F1-a. F1-b is gone.
- F1-02 is an operator command with a one-time temporary PIN and the first pairing code (Q3, Q4).
- F1-04 uses name-then-PIN (D2), limits per person and per device, and AC6: change PIN at first sign-in.
- H-1 to H-14 added to F1-01 to F1-05. G3 added to F8-03 and kept on F2-05, F5, F7, F9.

## Changes earlier on 2026-10-22 (v0.2.1)
- C6 reflects Rule 9; C7 names the stack (ADR-006).
- F1-02, F1-04, F1-05, F2-05 and F8-04 were updated for the CTO's Q8 decisions (device pairing, photo storage). Each change is marked "(2026-10-22)" in its story.
