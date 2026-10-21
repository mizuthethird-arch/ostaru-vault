# Decision log — VYRO PrivateCloud

> Add each decision as a new entry at the top (workflow template E). Mark whether it is an **executive decision** (CEO) or an **agent recommendation**.

## 2026-10-21 — Explore VYRO PrivateCloud (Phase 0 opened)
- Type: executive decision
- Decided by: CEO ("Let's explore the idea of Vyro private local cloud network system with docker", chat, 2026-10-21)
- Consulted: CTO
- Decision: open the project and start Phase 0. The CTO drafted the idea brief for the CEO, plus preliminary technical feasibility.
- Why: the CEO decides to explore an idea (startup workflow, section 1).
- Revisit on: Phase 1 Go / No-go.

## 2026-10-21 — Recommended architecture direction (proposal, not decided)
- Type: agent recommendation (CTO)
- Decided by: not decided; the CEO approves architecture at the Phase 2 gate
- Consulted: none yet
- Decision (proposed): Option B, a control plane plus node agents on plain Docker Compose; single-node MVP; no Swarm or Kubernetes in the MVP. See [discovery report, T4](02-discovery/discovery-report.md).
- Why: it fits "cloud network" and the less-served multi-site space, and stays portable.
- Revisit on: after spikes S1–S4 and the market scan.

---

## [YYYY-MM-DD] — [Decision title]
- Decided by:
- Consulted:
- Decision:
- Why:
- Revisit on:

---

### Risk acceptance (only to override a CISO or QA Lead veto; charter section 6)

## [YYYY-MM-DD] — Risk acceptance: [title]
- Decided by: CEO
- Veto overridden: CISO / QA Lead
- Risk:
- Reason:
- Expiry date:
- Fix owner:
