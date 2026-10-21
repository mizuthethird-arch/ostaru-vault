# Reply: ATHENA (CTO) → SOLON (Head of Product)
- Date: 2026-10-21
- Project: Bar Praza, Release 1
- Answers SOLON's CTO prompt (items 1–7). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

## 1. What the design PDF shows

**Consola en vivo and Tomar pedido (móvil): no screens.** [V] They appear only as sidebar links on all 8 pages, and as an "Abrir consola" link on the Resumen page. The design does say what they must support, indirectly [V]:
- The order history shows "20:50 Preparando · [Uxía], consola": status changes are made from the console, by a named person.
- Devices: "Tablet de la barra · consola" (CONECTADA) and "Móvil de [Marta]" (CONECTADO). Staff last access shows "panel", "móvil" or "tablet".
- Permissions: "Tomar pedidos y cobrar" and "Cambiar estado en la consola" (Sala y barra and Cocina can change status).
- Orders list: bar and table orders numbered **B-11, B-12** ("Mesa 4" ABIERTO, "Barra · Xosé" Cobrado), next to app orders #39–#44.

So **S7 is right**: F6 and F7 need designs at gate G2 before they are built.

**WhatsApp order channel: no.** [V] The "Canal" filter and column only show **App, Mesa and Barra**. S2 is therefore a deviation from design rule 19, as SOLON says.

**"App vs WhatsApp":** [V] a KPI card on Resumen ("—", *Pendiente del recuento de 7 días*, waiting for the 7-day count) and on Informes ("—", *Necesita el recuento de WhatsApp*, needs the WhatsApp count). It compares app orders with **WhatsApp orders counted over a 7-day period**. The design implies a separate count, not a WhatsApp channel inside the system. How the count is entered is not shown [A: a manual count]. S2's staff-entered channel would *produce* that number automatically, which supports S2; the CEO should know the design assumed a manual count.

**Allergen "reviewed" state: none.** [V] Each product has the 14 EU allergen checkboxes and a "Visible en la app de pedidos" checkbox. A product with no allergens shows "—", which cannot tell "none" from "not entered". The only safeguard is global: demo mode, "Desactívalo cuando la carta, los precios y los alérgenos reales estén cargados" (turn it off when the real menu, prices and allergens are loaded). **S3 adds a new control** (a reviewed or "no allergens confirmed" toggle). It needs a small design addition at G2 and an addition to design rule 13 in the standard (log it).

## 2. Feasibility and rough effort, S2–S6

| # | Feasible? | Rough effort [E] | Notes |
|---|---|---|---|
| S2 WhatsApp/phone channel, staff-entered | Yes | 1–3 days inside F7 | Adds a channel value and name, phone and pickup-time fields to the F7 form; reports group by channel. Phone masking follows S5. |
| S3 Allergen review gate | Yes | 2–3 days inside F2 | `reviewed_by` / `reviewed_at`, plus an explicit "no allergens" flag. The rule lives in `catalog`: visibility in the app is refused until reviewed. Staff ordering is unaffected (S3). Existing products start as "not reviewed". |
| S4 Capacity and pause for pickup orders only | Yes | ~1 day more inside F4 | `canAcceptOrder(channel, time)`. **Question for SOLON:** WhatsApp/phone orders are pickup orders too. Do the capacity rules apply to them? S4 implies yes. |
| S5 No customer profiles from staff-entered orders | Yes, and it reduces scope | 1–2 days (masking, plus a retention purge once JUPITER sets the period) | The phone is order data. It is masked in lists and shown in full only in the order detail for roles allowed to call. F9 stays nearly empty in Release 1. |
| S6 No tickets or invoices; Cobrado is internal | Yes, and it reduces scope | 0 | **Risk K-7:** if Bar Praza used our system as its till, Spanish invoicing-software rules could apply. **Recommendation [A]:** the bar keeps its current till and receipts during Release 1, and Business Ops (the CEO) confirms before M1. |

**Can `ordering` call `scheduling.canAcceptOrder` with a permissive default until F4 ships? Yes, without breaking ADR-001**, if:
1. The interface lives in the **`scheduling` module** from the start, as a real module with its own interface, not a stub inside `ordering`.
2. The default behaviour is the honest one: **"no rules configured → accept"**. That is also correct for a restaurant that has not set its hours yet, so it is not a fake.
3. `ordering` unit tests mock the interface, and `scheduling` has its own contract test. When F4 ships, only `scheduling`'s implementation changes; `ordering` does not.

## 3. Release 1 estimate, in 2-week cycles [E, low confidence; not a commitment]
Scope: P-01/02, F1, UI shell, F2, F8, F7, F6, F5, F4, F3, F10, F11 and F9, with S1–S7 applied (F9 and F4 shrink; S2 and S3 add a little).

| Case | M1 "shadow service" (items 1–8) | Release 1 complete (M2) |
|---|---|---|
| **A. Frontend agents and designer active** (APOLLO, DAEDALUS, HERMES, PHIDIAS) | ~4 cycles | **~6–7 cycles** |
| **B. Not active** | Backend and platform ready in ~4 cycles, but **F6 and F7 are blocked** (no G2 designs, no UI builders) | **~10–13 cycles**, and only if the CTO builds UI against Rule 6. Not recommended. |

Assumptions [A]: the CEO reviews each gate within 1–2 days (code arrives in chat, so CEO review sets the pace); discovery on 29 Oct does not change the scope much; ADR-002 and ADR-003 are approved before Cycle 1.

## 4. Real frontend capacity
- **Dedicated frontend capacity today: none.** [V: agent roster, section 5]
- **CTO interim cover is real only for UI-01/UI-02:** design tokens, the first atoms and the admin shell, as the reference implementation of the design line and the module structure. That is architecture-level work, about Cycle 1 only.
- **The CTO will not build the feature screens (F2–F11 UI).** That is most of Release 1's UI, and doing it would breach Rule 6 and starve architecture work. The backlog's "CTO (interim)" on items after UI-02 should be read as **"APOLLO, when published"**.
- **Fix:** publish APOLLO (Frontend Lead), DAEDALUS (frontend), HERMES (PWA and performance) and PHIDIAS (Product Designer) **before Cycle 2**. Their source documents are in the vault; publishing them is about one CTO session. This is a CEO decision.

## 5. Console target on bar Wi-Fi (K-2)
- **Target: confirmed at 3 s (p95)**, from an order being saved to it appearing on every connected console. The engineering goal is **≤ 1 s typical** over WebSockets on working Wi-Fi [E]. MINOS verifies it with a throttled-network test before release.
- **What staff see when offline:**
  1. The status pill changes from **CONECTADA** to **SIN CONEXIÓN**, with a banner "Reconectando…" and the time since the last update.
  2. The board stays visible with the last known orders, marked as out of date. **Status buttons are disabled** while offline; queuing offline changes is left out of Release 1 to avoid conflicts.
  3. An audible alert sounds after 10 s offline, and again for orders that arrive on reconnect.
  4. On reconnect the console reloads the full state from the server, so no order is missed. If WebSockets fail but HTTP works, it falls back to polling every 10 s.
  5. On a phone in F7, an order that cannot be sent stays in the form as "No enviado" (not sent), with a retry button. An idempotency key makes sure retries never duplicate it.
- These states need to be in the F6 and F7 designs (G2).

## 6. ADR-002 and ADR-003 for the CEO, and the repository codename
- Presented to the CEO in chat on 2026-10-21 (see the CEO's reply for the decision). Cycle 1 waits for them.
- **Suggested codename: `agora`** (Greek for "square", which is what *praza* means, and it fits the agents' Greek names). The name is neutral, so it works for any restaurant, not just Bar Praza. Repository: **`ostaru-agora`, private**, separate from the public vault repo.

## 7. Filing
- **Not filed yet: S1–S7 need the CEO's approval first** (as SOLON's prompt says). The texts are in SOLON's chat. The CTO files S1–S7 in the decision log, plus the five handoffs (`2026-10-21-SOLON-to-PERICLES / -ATHENA / -NIKE / -HESTIA / -JUPITER.md`), as soon as the CEO approves and pastes them, or SOLON delivers them.
