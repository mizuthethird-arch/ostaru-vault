# Stories F2 — Carta y productos

> Delivered by PERICLES (Product Manager) in chat on 2026-10-21 as planning package v0.2, and filed by the CTO (ATHENA) on 2026-10-21 without content changes. **Since it was drafted, the CEO approved S1–S7, the rule 19 deviation, ADR-002 and ADR-003, and settled Q2 (chat only, the CEO commits). The CTO decided Q8.** See the [decision log](../../decision-log.md). Labels: **[V]** verified, **[E]** estimate, **[A]** assumption.

> Common acceptance criteria C1–C7 and the gate list are in the [stories README](README.md) and apply to every story here.

F2-01 to F2-03 are the Cycle 1 stretch slice. The others come later.

**F2-01 · Categories** · `catalog` · size S · G1 G2 G4 G5 G6 G7
*As the Encargado, I want to create, rename and reorder categories, so the menu is organized.*
- **AC1** Given a category name, then it is created, and an empty name is rejected.
- **AC2** Given a rename or reorder, then it persists.
- **AC3** Given no categories, then an empty state in Spanish shows.
- **Isolation:** restaurant B's categories are invisible to A.
- **Role:** Encargado only. Sala y barra and Cocina are denied (r17).
- **Tests:** validation, reorder, role denial, isolation.
- **Design line:** r1–r4, r10, r11.
- **Out of scope:** deleting categories [A], translations, category images.

**F2-02 · Products and variants** · `catalog` · size M · G1 G2 G4 G5 G6 G7
*As the Encargado, I want products with named variants and prices, so each size has its own price.*
- **AC1** Given a name and at least one variant with a price, then the product is saved. A product with no variant is rejected.
- **AC2** Given a price of 11 euros, then it displays as 11,00 €. Given two variants, then the list shows e.g. "3,00 / 14,00 €" (r14, r9).
- **AC3** Given invalid prices (negative or not a number), then they are rejected.
- **AC4** Dish names use the serif face (r8). Edit happens in a side panel (r4).
- **Isolation:** yes.
- **Role:** Encargado only.
- **Tests:** price formatting and validation, variants, role denial, isolation.
- **Design line:** r4, r8, r9, r10, r14.
- **Out of scope:** photo (F2-05), allergens (F2-03), flags (F2-04), stock link (F3), modifiers [A].

**F2-03 · Allergens and review (S3)** · `catalog` · size M · G1 G2 G4 G5 G6 G7
*As the Encargado, I want to record the 14 EU allergens and who reviewed them, so the menu is safe to publish.*
- **AC1** Each product offers exactly these 14 checkboxes: gluten, crustáceos, huevos, pescado, cacahuetes, soja, lácteos, frutos de cáscara, apio, mostaza, sésamo, sulfitos, altramuces, moluscos (Spanish wording to confirm [A]).
- **AC2** Given the Encargado marks allergens "revisado", then who and when are recorded.
- **AC3** Given no allergen ticked, then the product stays unreviewed until "Sin alérgenos" is confirmed explicitly.
- **AC4** Given allergens are edited after review, then the product returns to unreviewed [A: SOLON to confirm].
- **Isolation:** yes.
- **Role:** Encargado only [A]. The review record is not editable.
- **Tests:** the 14 allergens exactly, the review record, the explicit "no allergens" path, the reset on edit, role denial, isolation.
- **Design line:** r13.
- **Out of scope:** nutritional data, the customer-facing allergen display (Release 2).

**F2-04 · Flags, visibility gate and archive (S3)** · `catalog` · size S · G1 G2 G4 G5 G6 G7
*As the Encargado, I want flags and a safe publish switch, so only reviewed products can be made visible.*
- **AC1** Given allergens not reviewed, when the Encargado sets "visible en la app", then it is refused with a Spanish message [copy A].
- **AC2** Given allergens reviewed, then it is allowed.
- **AC3** Given a visible product becomes unreviewed (F2-03 AC4), then it is set not visible [A].
- **AC4** Flags "plato del día" and "solo barra" can be set. Archiving hides a product from lists and ordering but keeps order history [A].
- **AC5** Staff ordering of an unreviewed product is never blocked. This is tested in F7.
- **Isolation:** yes.
- **Role:** Encargado only.
- **Tests:** gate allowed and refused, auto-unpublish, archive, role denial, isolation.
- **Design line:** r10, r13.
- **Out of scope:** customer-facing effect (the customer app is Release 2 [A]).

**F2-05 · Product photo** · `catalog` · size M · G1 G2 G3 G4 G5 G6 G7
*As the Encargado, I want to attach a photo to a product, so the menu looks like the design.*
- **AC1** Given an accepted image, then it attaches to the product.
- **AC2** Given a rejected file (wrong type or too large), then an error shows. The limits are set in G3 [A].
- **Isolation:** B can't read A's photos.
- **Role:** Encargado only.
- **Tests:** accept, reject, isolation.
- **Design line:** r3.
- **Out of scope:** image editing. Storage is not covered by ADR-002 (Q8), which is a dependency.

**F2-06 · Availability state** · `catalog` · size S · G1 G2 G4 G5 G6 G7
*As staff, I want to mark a product AGOTADO, so nobody orders what we can't make.*
- **AC1** Given Encargado, Sala y barra or Cocina marks a product AGOTADO, then it shows the AGOTADO pill (r7).
- **AC2** Given AGOTADO, then it is hidden from "visible en la app".
- **AC3** Auto sold-out at stock 0 is not here (F3).
- **Isolation:** yes.
- **Role:** all three roles may mark sold out (r17). Only the Encargado edits the product.
- **Tests:** role matrix, hide behavior, isolation.
- **Design line:** r7, r15.
- **Out of scope:** auto sold-out, stock.
