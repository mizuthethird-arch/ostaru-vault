---
standard: bar-praza-ux-ui-design-line
area: ux-ui
scope: project:bar-praza
version: 1.0.0
status: APPROVED
owner: Head of Product (SOLON), with the Product Designer (PHIDIAS, pending publication)
approved_by: CEO, 2026-10-21 ("Approved design line")
source: "designs/Bar Praza — Full Design Vision-selection.pdf" (8 pages, admin panel)
---

# Bar Praza UX/UI design line

## Purpose
This standard makes every Bar Praza (and platform) screen look and behave like the approved design. It is **binding** under [AGENT-RULES](../../../AGENT-RULES.md), section 9: every UI, prototype, component or front-end code produced for this project follows it, and the output says that it does.

**Source of truth:** the design PDF, [Bar Praza — Full Design Vision](<../../../designs/Bar Praza — Full Design Vision-selection.pdf>). Where this page and the PDF differ, the PDF wins. The values below were read from the PDF and are **approximate** until the design source file (tokens) is supplied.

## Applies to
The admin panel, and **by extension** the customer app, live console, staff mobile ordering and platform screens. Those are not designed yet, so they must reuse these rules (see "Gaps").

## Rules

### Layout
1. MUST use the admin shell: a fixed dark sidebar on the left (restaurant name at the top, main sections, then a separated group for "Consola en vivo" and "Tomar pedido (móvil)") and a light content area.
2. MUST open each page with a small uppercase overline (date, demo state), then a large serif page title, with primary actions on the right.
3. MUST put content in white cards with a thin border, soft rounded corners and generous padding. Use KPI cards for headline numbers. A highlighted (tinted) card shows a metric that is missing or needs attention.
4. Editing SHOULD happen in a side panel next to the list, not on a separate page (see the menu editor).

### Colour (approximate)
5. Sidebar near-black, warm (about `#1F1B17`). Page background warm off-white (about `#F3EFE8`). Cards white or ivory.
6. Primary action and active navigation: terracotta red (about `#B5432F`). Success and enabled: olive green (about `#4F6B1F`). Warnings and attention: soft terracotta tint.
7. Status pills, always uppercase and small: **NUEVO** (red tint), **PREPARANDO** (beige), **LISTO** (green tint), **Recogido** / **Cobrado** (plain text), **AGOTADO** (grey caps), **RETRASADO** (red text). Connected devices use **CONECTADA** / **CONECTADO** (green pill).

### Typography
8. Serif display face for page titles, card titles and **dish names**. Clean sans-serif for UI text, tables and forms. Small uppercase letter-spaced labels for overlines and statuses.
9. Prices in euros, Spanish format (`11,00 €`, `3,00 / 14,00 €` for variants).

### Content and language
10. The UI language is **Spanish**, with Galician dish and place names kept as written (Pulpo á feira, Raxo, praza). Other languages need a CEO decision.
11. Placeholders are shown in square brackets (`[HORARIO]`, `[DIRECCIÓN]`) until real data exists.
12. **Demo mode** is visible on every screen (an overline such as "DATOS DE DEMOSTRACIÓN"), and the customer app shows a DEMO notice and only accepts test-code orders until the owner turns it off.

### Domain patterns (MUST keep)
13. **Allergens:** the 14 EU allergens are offered as checkboxes on every product and shown on the menu.
14. **Variants:** a product can have several sizes and prices (for example media ración / ración, pincho / entera).
15. **Stock:** optional per item, with a minimum; reaching 0 can auto-mark the item **AGOTADO** and hide it in the app; a shopping list is generated from items below minimum.
16. **Ordering rules:** weekly hours, minimum preparation time, last order before closing, maximum orders per 15 minutes (the app proposes the next free slot), and special closures.
17. **Roles and permissions:** Encargado (everything), Sala y barra (take orders and charge, change status, mark sold out), Cocina (change status, mark sold out). Each person has a PIN, and devices are listed and can be disconnected.
18. **Customer privacy:** only customers who ordered through the app are listed; phone numbers are partly masked and used only to notify about an order; customers with an account can delete their data; data requests appear in the panel.
19. **Orders:** each order shows its number, customer or table, channel (App / Mesa / Barra), pickup time, items, total, payment mode and a timestamped history. Late orders show the delay and offer "Llamar al cliente" (call the customer).

## How conformance is checked
- Design review, gate G2: the Head of Product (with the Product Designer) checks new screens against rules 1–19.
- Code review, gate G5: front-end PRs state that they follow `standards/ux-ui-design-line.md` v1.0.0, and use the shared tokens once they exist.

## Gaps (to design in this style before build)
1. Customer ordering app (mobile first): menu, product, cart, time slot, payment, order status.
2. Live console (tablet): the order board by status.
3. Staff mobile ordering ("Tomar pedido (móvil)").
4. **Platform level, for the SaaS:** restaurant sign-up and onboarding, a restaurant switcher for users who belong to several, an Ostaru operator back office, and billing.
5. Design tokens and a component library: exact colours, fonts and spacing from the design source file.

## Deviations
None yet. Any deviation is approved by the Head of Product and the CEO and logged in the [decision log](../decision-log.md).

## Change log
| Version | Date | Note |
|---|---|---|
| 1.0.0 | 2026-10-21 | Approved by the CEO as the design line. Rules extracted from the PDF by the CTO. |
