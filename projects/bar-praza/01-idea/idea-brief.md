# Idea brief — Bar Praza (multi-restaurant ordering SaaS)
- Date: 2026-10-21
- Author: CEO
- Status: **SIGNED** by the CEO/Owner on 2026-10-22 (Owner bypass, see the [decision log](../decision-log.md)). Items marked **[assumption]** remain assumptions until discovery confirms them.

## Problem
Small bars and restaurants such as Bar Praza take takeaway and pickup orders informally today. The design's "App vs WhatsApp" report suggests WhatsApp is the current channel **[assumption: to confirm with Bar Praza]**. That makes it hard to:
- see every order in one place, and prepare and hand each one over on time;
- keep the menu, prices, **allergens** and sold-out items correct for customers;
- control stock, opening hours and how many orders the kitchen can take;
- know what sells and when.

## Target user
1. **Restaurant operators:** the owner or manager, floor and bar staff, and the kitchen. Bar Praza is the first.
2. **Their customers:** people who order for pickup or at the table, and pay in the app or at the bar.
3. **Ostaru as platform operator:** onboards and supports many restaurants. The product is a **multi-restaurant SaaS** (CEO).

## Why now
- Bar Praza is a real first client who will use it from day one (CEO).
- [assumption] Small hospitality businesses want their own ordering channel without marketplace commissions.

## First guess at the solution
One platform. Each restaurant gets its own space, menu, staff and data.

**MVP scope (CEO, 2026-10-21):**
1. **Customer ordering app:** browse the menu (with variants and the 14 EU allergens), order for pickup at a time slot, see order status.
2. **Online payments** in the app, plus pay-at-the-bar.
3. **Live console** for the bar and kitchen: new → preparing → ready → collected, with delays highlighted.
4. **Staff mobile ordering:** take bar and table orders, and charge for them.
5. **Admin panel**, as in the approved design:
   - summary, orders, and the menu with variants, photos and allergens;
   - stock, which auto-marks items "sold out" at zero;
   - ordering hours and rules: preparation time, last order, a maximum per 15 minutes, special closures;
   - staff roles and PINs, and devices;
   - customers, with privacy controls;
   - reports and demo mode.

## How we'll know it works
Proposed signals; the CEO sets the targets.
1. Bar Praza takes **[X] %** of its pickup orders through the app instead of WhatsApp within **[4] weeks** of launch.
2. **[90] %** of app orders are ready before the pickup time. The design already tracks "Recogidos a tiempo" (collected on time).
3. A second restaurant can be onboarded **without code changes**: configuration only, in under **[1] day**.

## Biggest unknowns
1. **Payments:** which provider and methods (card, Bizum), how money reaches each restaurant, and who carries the fees.
2. **Commercial model** for the SaaS (subscription, per-order fee), and the terms with Bar Praza as the first client.
3. **Legal:** allergen information, GDPR for customer data, invoicing and tickets in Spain. This needs Business Operations (vacant) and the CISO.
4. **Design gaps:** the approved design covers the admin panel only. The customer app, the live console, the staff mobile ordering screens and the platform-level (multi-restaurant) screens still need designs in the same style.
