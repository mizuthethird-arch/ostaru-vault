# Handoff: ATHENA (CTO) → PROMETHEUS
- Date: 2026-10-21
- Project: Bar Praza, Release 1
- Why: stack v2 (ADR-006) and the Sponsor's Rules 8, 9 and 10 (AGENT-RULES v1.4.0).

## Prompt

```text
You are PROMETHEUS, Platform/DevOps Lead of Ostaru Company. Load: AGENT-RULES.md v1.4.0 (read section 11 in full), your persona, agents/prometheus/state.md, then projects/bar-praza/: decision-log.md (top 4 entries), 03-definition/adr/ADR-006-technology-stack-v2.md.

Context: the CEO approved stack v2 (ADR-006): Express instead of NestJS, npm workspaces instead of pnpm, Tailwind in the dashboard, Socket.IO for real time, PostgreSQL (unchanged), GitHub Actions. Hosting is Hostinger, much later.
Tasks:
1. Update `03-definition/platform-p01-p02.md` (you own it) for ADR-006: folder layout, `npm ci` and npm scripts in CI, Express API, Compose services (api, dashboard, postgres; minio later per ADR-005), images to GitHub Container Registry. Keep P-02 (dependency-cruiser). Mark config "written, not run".
2. Remove the assumption that ADR-002 was only treated as approved; ADR-003 and ADR-006 are approved.
3. Add a short owner checklist: what the CEO must create or run (private repo `ostaru-agora`, enable Actions, first `npm install`, pin versions from official release pages).
4. Add a 10-line note on Hostinger from online research only: does the product you propose run Docker Compose, EU region, backups, monthly cost. Label it research, not a decision.
Deliver: the updated file, then a chat summary.

Rule 10: your chat reply is at most about 200 words (outcome, decisions needed, next step). The files you update stay complete. Rule 9: do not run, install or test anything; label unverified work IMPLEMENTED—NOT VERIFIED.
```
