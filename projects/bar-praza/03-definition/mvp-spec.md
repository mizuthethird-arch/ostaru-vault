# MVP spec — Bar Praza, Release 1: restaurant dashboard

> **CTO DRAFT, handed over (AGENT-RULES section 10).** The CTO drafted this before Rules 6 and 7. It now belongs to **PERICLES (Product Manager), with SOLON (Head of Product) deciding scope and priority**, who accepts, rewrites or discards it. Handoff prompts: [to SOLON](../handoffs/2026-10-21-ATHENA-to-SOLON.md) and [to PERICLES](../handoffs/2026-10-21-ATHENA-to-PERICLES.md).
- Version: 0.1 (DRAFT)
- Owner: PM ([PERICLES](../../../agent-personas/PERICLES.md)); drafted by the CTO on the CEO's instruction of 2026-10-21
- Approved by: pending. The Head of Product approves the spec (gate G1), and the CEO approves the MVP plan.

> **Build order (CEO, 2026-10-21):** the **restaurant dashboard comes first**, with every feature shown in the approved design. The **public customer app comes last**. Every screen follows the [UX/UI design line](../standards/ux-ui-design-line.md). All code follows the [modular monolith](../../../standards/architecture/modular-monolith.md) and [focused changes, always tested](../../../standards/code/change-discipline-and-testing.md) standards.

## Goal
Bar Praza's team runs a full service with the dashboard: the menu with allergens, stock, hours and ordering rules, staff, and orders taken at the bar, at tables and from WhatsApp. That proves the restaurant side works before customers order on their own.

## Users and main flow
1. The owner (Encargado) sets up the restaurant, team, PINs, menu, allergens, stock and hours.
2. Floor and bar staff take orders on a phone ("Tomar pedido") for the bar, a table or a phone/WhatsApp request, and charge at the bar.
3. The kitchen and bar see every order on the live console and move it New → Preparing → Ready → Collected.
4. The owner checks today's summary, orders, stock alerts and reports.

## In scope (Release 1)
The dashboard modules in the design, plus the platform foundation they need:

| # | Module (design section) | Business module |
|---|---|---|
| F1 | Foundation: restaurants, sign-in, roles and PINs, devices, demo mode | `tenancy`, `identity` |
| F2 | Carta y productos (menu and products) | `catalog` |
| F3 | Stock | `inventory` |
| F4 | Horario y pedidos (hours and ordering rules) | `scheduling` |
| F5 | Pedidos (orders list and detail) | `ordering` |
| F6 | Consola en vivo (live console) | `ordering` (real time) |
| F7 | Tomar pedido (móvil) (staff order taking) | `ordering` |
| F8 | Personal y ajustes (staff and settings) | `identity`, `tenancy` |
| F9 | Clientes (customers) | `customers` |
| F10 | Informes (reports) | `reporting` |
| F11 | Resumen (today's summary) | `reporting` (read model) |

## Out of scope (Release 1, comes later)
- The **public customer app** (browse, order, time slots, order status). This is the last part (CEO).
- **Online payments in the app.** They belong to the customer app; Release 1 records payment at the bar (cash or card terminal) without processing cards.
- Customer accounts and self-service data deletion (the Clientes module shows the structure, filled from staff-entered orders).
- Self-service onboarding of new restaurants and SaaS billing. In Release 1, Ostaru creates restaurants.
- Native apps.

## Features and acceptance criteria

### F1. Foundation
- Given two restaurants, when a user of restaurant A uses any screen or API, then no data from restaurant B is ever returned. Covered by automated isolation tests.
- Given a staff member with a PIN, when they enter it on a registered device, then they are signed in with their role's permissions only.
- Given demo mode is on, then every screen shows "DATOS DE DEMOSTRACIÓN", and turning it off requires the Encargado.

### F2. Carta y productos
- Categories (create, rename, reorder) and products with a name, description, photo, one or more **variants with prices**, and the **14 EU allergens** (checkboxes).
- Flags: visible in the app, plato del día, bar only, archive.
- Optional stock link: "deduct N units of a stock item per variant", for example 250 g of pulpo per ración.
- Given a product with no allergens reviewed, then it cannot be made visible to customers. This is **proposed**; SOLON to confirm.

### F3. Stock
- Stock items with a unit (kg, units, bottles, portions), current level and minimum, and the products they are used in.
- Movements: **entrada** (delivery, with supplier), **merma** (waste) and **recuento** (count). Each is logged with who did it and when.
- When an order is collected or charged, the linked stock is deducted.
- Given "mark sold out at 0" is on, when a level reaches 0, then the product shows **AGOTADO (auto)** and is hidden from ordering.
- A shopping list of items below minimum, shareable as text.

### F4. Horario y pedidos
- Weekly hours per day, open or closed, plus special closures (date, reason, alternative hours).
- Rules: minimum preparation time, last order before closing, maximum orders per 15 minutes.
- Live state: "accepting orders until HH:MM, N in queue", and **pause orders for X minutes** or until resumed.
- Rules are enforced on the server when an order is created.

### F5. Pedidos
- List with search, period, channel (App / Mesa / Barra / **WhatsApp**, *proposed*) and status filters, plus CSV export.
- Detail: customer or table, phone (masked), pickup time, items with variants, total, payment mode, and a **timestamped history**.
- A late order is marked **RETRASADO N MIN**, with "Llamar al cliente" (call the customer) and "Cancelar pedido" (cancel the order, Encargado only).

### F6. Consola en vivo
- A board by status (NUEVO → PREPARANDO → LISTO → Recogido/Cobrado) that updates in **real time** on every connected device.
- Late orders are highlighted. The connection state is visible (CONECTADA), and the board reconnects automatically.

### F7. Tomar pedido (móvil)
- Staff pick a channel (Barra, Mesa N, or WhatsApp/phone with name and pickup time), add products and variants, and send the order to the console.
- Charging at the bar records the method (cash or card terminal) and marks the order **Cobrado**.

### F8. Personal y ajustes
- Team list with role, PIN state, last access and active flag. Add a person, and set or change a PIN.
- The **permission matrix** follows the design: Encargado has everything; Sala y barra can take orders and charge, change status and mark sold out; Cocina can change status and mark sold out.
- Devices are listed with their status and can be disconnected. Restaurant data includes the address and phone. Demo mode is a toggle.

### F9. Clientes
- Customers created from orders. The phone is masked (`··· ··· 000`), with the number of orders, last order and usual items.
- A "Solicitudes de datos" (data requests) panel for access and deletion requests, handled manually in Release 1.

### F10. Informes
- KPIs for the period: orders, sales, % collected on time, and App vs WhatsApp.
- Orders per day by channel, top products, peak hours (lunch and dinner), late orders, and export.

### F11. Resumen
- Today: orders (new and in progress), sales, average ticket and the channel comparison; today's orders table; a quick menu with availability; the hours card; and pause orders.

## Success metrics

| Metric | Target | Measured how |
|---|---|---|
| Bar Praza runs a full service on the dashboard | [N] services without falling back to paper or WhatsApp-only | Orders logged per service |
| Menu complete with allergens | 100 % of visible products | Catalog report |
| Orders ready on time | [90] % | F10 "collected on time" |
| Second restaurant set up by configuration only | Under [1] day, no code changes | Onboarding run |

## Risks and open questions
- Will Bar Praza's staff adopt phone-based order taking during a busy service? Test it in demo mode first.
- Whether a **WhatsApp channel** (staff-entered) is wanted. It also gives the App-vs-WhatsApp baseline.
- How the card terminal is used: is "card" a manual mark, or is the terminal integrated? Release 1 assumes a manual mark.
- Invoicing and tickets in Spain: Business Operations (vacant) must confirm the obligations before go-live.
