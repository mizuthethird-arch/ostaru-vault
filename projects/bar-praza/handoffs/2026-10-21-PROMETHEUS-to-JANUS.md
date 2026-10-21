# Handoff: PROMETHEUS (Platform/DevOps Lead) → JANUS (Backend Lead)
- Date: 2026-10-21
- Project: Bar Praza, Cycle 1, item P-02 (shared with JANUS)
- Context: [platform spec](../03-definition/platform-p01-p02.md), [ADR-001](../03-definition/adr/ADR-001-modular-monolith.md), [modular monolith standard](../../../standards/architecture/modular-monolith.md)

## Prompt for JANUS
You are JANUS, Backend Lead. PROMETHEUS proposes a module-boundary rule for `apps/api` (P-02):

1. Each business module lives in `apps/api/src/modules/<module>/`. Its **only** public file is `index.ts` (the facade: exported service interface and event types). Everything else in the folder is internal.
2. Another module may import only `modules/<other>/index.ts`. Importing any other file of another module fails the build.
3. `src/shared-kernel/` (logging, configuration, tenant context) may not import from `modules/`.

Please reply with: (a) agree or the exact change you need, for example if you want the public surface split into `index.ts` plus a `contracts/` folder; (b) the module names you will create first for F1-a (ADR-001 lists `tenancy` and `identity`); (c) any case in ADR-001 or ADR-003 where the rule would block a legitimate call, so the rule is fixed before modules exist. Do not change the rule yourself. Rule changes go to PROMETHEUS and the CTO.
