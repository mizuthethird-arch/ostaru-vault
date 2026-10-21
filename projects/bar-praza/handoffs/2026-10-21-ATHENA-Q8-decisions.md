# CTO decisions on Q8: ATHENA → PERICLES, JANUS, PROMETHEUS
- Date: 2026-10-21
- Project: Bar Praza, Release 1
- Answers Q8 in [MVP spec v0.2](../03-definition/mvp-spec.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.
- Recorded in the [decision log](../decision-log.md) as a CTO decision. The CEO can overrule any part.

## 1. Live console target: confirmed
- **3 s at p95**, from an order being saved to it showing on every connected console. Engineering goal: **≤ 1 s typical** over WebSockets on working Wi-Fi [E].
- MINOS verifies it with a throttled-network test before M1.
- Offline behaviour (pill SIN CONEXIÓN, "Reconectando…" banner, stale board with status buttons disabled, alert after 10 s, full reload on reconnect, 10 s polling fallback, "No enviado" plus idempotent retry in F7) is defined in the [answers to SOLON, item 5](2026-10-21-ATHENA-to-SOLON-answers.md). It must be in the F6 and F7 designs (G2).
- **PERICLES:** replace "[3] s [A: CTO to confirm]" in F6 with "3 s at p95 [V: CTO Q8]".

## 2. Device registration (F1-05): one-time pairing code, then a device token
1. The Encargado, signed in on the panel, chooses "Añadir dispositivo" and gets a **6-digit pairing code** that is valid for **10 minutes** and works **once**.
2. On the new tablet or phone, someone opens the dashboard and enters the code.
3. The server registers the device to that restaurant and returns a **random device token** in an `HttpOnly`, `Secure`, `SameSite=Strict` cookie. The server keeps only a hash of the token.
4. PIN sign-in (F1-04) is accepted only together with a valid device token **of the same restaurant**.
5. "Desconectar" in F8-04 revokes the token at once, and the device's sessions end.
6. **First device:** when Ostaru creates a restaurant (F1-02), it issues the first pairing code for the first Encargado's device. That removes the chicken-and-egg problem.
- Why: no app install, works on any browser, a stolen PIN alone is useless, and a lost phone is cut off with one click.
- Limits to set at G3 (EUNOMIA, JUPITER): attempts allowed per code, token lifetime [A: 180 days, renewed on use], and what happens when a browser clears cookies (the device is registered again with a new code).
- **JANUS:** design the `identity` interface and data (`Device`, `PairingCode`) for this; no change to F1-01 to F1-04.

## 3. Photo storage: S3-compatible object storage
- Decided in [ADR-005](../03-definition/adr/ADR-005-file-storage.md): a `FileStorage` interface, MinIO in dev, an EU S3-compatible provider in staging and production, keys prefixed by `restaurant_id`, private bucket with signed URLs, uploads checked by content, re-encoded, with metadata removed.
- **PROMETHEUS:** add MinIO to Docker Compose when F2-05 is planned (not needed for Cycle 1), and propose the provider with its monthly cost.

## 4. P-01: Phase 3 pre-work
- **P-01 (monorepo, Docker Compose, CI) is Phase 3 pre-work.** The workflow requires the repository, CI and environments to be ready before Cycle 1 [V: startup workflow, Phase 3]. ADR-002 is approved, so PROMETHEUS can start now.
- "P-01 merged with CI green" becomes an item of the "Cycle 1 ready" checklist.
- P-02 (architecture test) and the ADR-004 spike may also start as pre-work. If they do not finish, they stay in the first week of Cycle 1.
- Because code is delivered in chat and the CEO commits (decision 2026-10-21), the **CEO must provide a private repository and a CI service** first. PROMETHEUS specifies both. Repository name proposed: `ostaru-agora` [A: CEO to confirm].
- **PERICLES:** move P-01 out of the Cycle 1 table into a "Phase 3 pre-work" line, and add it to the checklist. These are PM-owned documents, so the CTO has not edited them (Rule 6).

## Still with the CTO (next)
- The UI-01/02 task breakdown and estimates (interim Frontend Lead).
- The F1-a API contract (G4) with JANUS.
- The reviewer for UI-01/02 (the CTO cannot approve its own work, charter section 10).
- ADR-004 after JANUS's spike.
