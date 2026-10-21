# Roadmap: agent order for the next feature (Bar Praza, F1-a)

- Owner: PERICLES (Product Manager). Rule: AGENT-RULES s.12. Date: 2026-10-22 (v1). Cycle 1 is **ready**, G1 **passed** (Owner bypass, [decision log](../decision-log.md)).
- Next feature: **F1-a**, stories F1-01 to F1-05 with H-1 to H-14 ([stories](stories/f1-foundation.md)). Breakdown: [JANUS v2](breakdowns/F1-a-tenancy-identity.md).
- Rule 9: agents write, the Owner runs. Every result is IMPLEMENTED—NOT VERIFIED until the Owner reports.
- Labels: **[V]** decided, **[E]** estimate, **[A]** assumption.

## Chain
**Owner** (creates private repo `ostaru-agora`, Q13) → **PROMETHEUS** (delivers P-01 files and P-02 rule; Owner runs them in Docker and reports) → **JUPITER** (confirms the [A] numbers: threat-model open questions 3 and 8; interim G3 approver) → **EUNOMIA** (final threat model, **G3** for F1-a) → **JANUS** (G4 contract for F1-a, then builds F1-01 to F1-05 with unit and isolation tests) ∥ **MINOS** (turns H-1 to H-14 into test cases; testability review) → **ATHENA / CTO** (**G4** contract agreement, **G5** merge review) → **Owner** (runs tests, commits code, reports) → **MINOS** (**G6** QA) → **EUNOMIA** (**G7** security) → **PERICLES** (updates status, cycle, backlog).

UI branch, in parallel after P-01: **ATHENA (interim frontend)** (UI-01 tokens, UI-02 shell) → **SOLON / JANUS / MINOS + Owner** (review; the CTO cannot approve own work) → **ATHENA** (sign-in, change-PIN and pairing screens, **G2** first) → **VULCAN** (connects the screens to the F1-a API).

## Steps
| # | Agent | Delivers | Needs | Gate | Parallel with |
|---|---|---|---|---|---|
| 1 | Owner | Private repo `ostaru-agora` | none | — | 2 |
| 2 | PROMETHEUS | P-01 files, P-02 rule | 1 | G5 | 3 |
| 3 | JUPITER | Answers on [A] numbers (rate limits, body limit, token life) | threat model | — | 2 |
| 4 | EUNOMIA | Threat model final, G3 | 3 | G3 | 5 |
| 5 | JANUS | G4 contract, then F1-01 to F1-05 | 2, 4 (numbers) | G4 | 6 |
| 6 | MINOS | Test cases for AC and H-1 to H-14 | 5 contract | — | 5 |
| 7 | ATHENA | UI-01, UI-02; G2 for sign-in and pairing screens | 2 | G2 | 5 |
| 8 | VULCAN | Dashboard screens wired to the API | 5, 7 | G5 | — |
| 9 | Owner | Runs tests and CI, commits, reports | 5, 8 | — | — |
| 10 | MINOS, EUNOMIA | QA and security sign-off | 9 | G6, G7 | — |
| 11 | PERICLES | Status update, next cycle plan | 10 | — | — |

## Capacity and risk
- F1-a is about 14 person-days [E, low confidence] against a one-week window. It may spill into week 3. F2 slice is probably Cycle 2.
- Items tracked, not blocking: Q13 repository and CI, JUPITER's confirmation of [A] numbers, no design yet for sign-in and pairing screens.

## First prompts to send now
Filed in `handoffs/`: [PERICLES to JANUS](../handoffs/2026-10-22-PERICLES-to-JANUS.md) (size change and story updates). Next, once the Owner confirms: PERICLES to JUPITER (the [A] numbers) and PERICLES to PROMETHEUS (P-01 start).
