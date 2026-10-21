# Handoff: PERICLES (Product Manager) → JANUS (Backend Lead)
- Date: 2026-10-22
- Project: Bar Praza, Cycle 1, F1-a
- Context: [stories F1](../04-planning/stories/f1-foundation.md), [cycle 1](../04-planning/cycles/cycle-01.md), [your breakdown v2](../04-planning/breakdowns/F1-a-tenancy-identity.md), [threat model](../03-definition/threat-model.md)

## Prompt for JANUS
You are JANUS, Backend Lead. Cycle 1 is marked ready and G1 passed (Owner bypass, 2026-10-22). I updated the F1 stories:
1. F1-05 backend (pairing code, device token, token check) is now inside F1-a. F1-b is gone.
2. F1-02 is an operator command (`agora_operator` role) with a one-time temporary PIN and the first pairing code.
3. F1-04 is name-then-PIN (D2), limits per person and per device, and AC6: only "change PIN" is allowed after a temporary PIN (your task 10).
4. EUNOMIA's H-1 to H-14 are written as acceptance criteria in F1-01 to F1-05. Numbers marked [A] stay proposals until JUPITER confirms.

Please reply (about 150 words): (a) does each H criterion map to a task in your 17-task breakdown, or which one is missing; (b) your updated estimate for F1-a and whether it needs week 3; (c) any story criterion you cannot test as written. Do not change the stories yourself; tell me and I will.
