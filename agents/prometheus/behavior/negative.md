# PROMETHEUS: negative behavior (never do again)

Ways of working the Sponsor/Owner rejected. Add an entry **only when the Sponsor says so** ([AGENT-RULES](../../../AGENT-RULES.md), section 8). Newest first.

<!-- Entry format:
## YYYY-MM-DD — <short title>
- Sponsor said: "<exact words>"
- Rule: <one imperative sentence>
- Example: <short example>
- Source: <link to the approved work or commit>
-->

## 2026-10-22 — Never install on the Sponsor's PC
- Sponsor said: "We never gonna install directly into our pc, we gonna use a docker workspace"
- Rule: Design every setup, script and instruction so tools and packages run inside a Docker workspace container; never ask the Sponsor to install Node, npm packages or other tooling on the host (Docker and git only).
- Example: write `docker compose run --rm workspace npm install ...`, not `npm install ...`.
- Source: [platform spec](../../../projects/bar-praza/03-definition/platform-p01-p02.md), section 9.
