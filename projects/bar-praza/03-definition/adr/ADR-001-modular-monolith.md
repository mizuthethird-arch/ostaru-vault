# ADR-001: Modular monolith with business modules
- Date: 2026-10-21
- Status: **Accepted.** Required by the CEO's Rule 3 and the [modular monolith standard](../../../../standards/architecture/modular-monolith.md).
- Owner: CTO

## Context
Bar Praza starts as one product for one restaurant, but it is a SaaS that must grow, and the CEO requires a monolith that can later become microservices (Rule 3).

## Options considered
1. Microservices from day one: too much operational weight for the team and the scale.
2. A plain layered monolith (controllers, services, repositories): fast, but the boundaries blur and later extraction is hard.
3. **A modular monolith:** one deployable, with modules by business capability and strict boundaries.

## Decision
Option 3. **One backend application and one dashboard front end**, in one repository, with these modules:

| Module | Owns | Public interface (examples) | Publishes events |
|---|---|---|---|
| `tenancy` | Restaurants, restaurant settings, demo mode | `getRestaurant`, `isDemo` | `RestaurantCreated` |
| `identity` | Staff, roles, permissions, PINs, devices, sessions | `authenticate`, `can(staff, permission)` | `DeviceDisconnected` |
| `catalog` | Categories, products, variants, allergens, photos | `getMenu`, `getProduct`, `setAvailability` | `ProductChanged` |
| `inventory` | Stock items, movements, minimums, shopping list | `recordMovement`, `deductFor(orderLines)` | `StockDepleted`, `StockBelowMinimum` |
| `scheduling` | Weekly hours, closures, ordering rules, pause | `canAcceptOrder(at)`, `nextFreeSlot` | `OrderingPaused` |
| `ordering` | Orders, lines, status history, console | `placeOrder`, `changeStatus`, `charge` | `OrderPlaced`, `OrderStatusChanged`, `OrderCharged` |
| `customers` | Customers, consent, data requests | `upsertFromOrder`, `requestDeletion` | — |
| `reporting` | Read models for the summary and reports | `getSummary`, `getReport(period)` | — (it consumes events) |
| `payments` | **Later** (public app): online payments | — | — |

Interactions, for example: `ordering` calls `scheduling.canAcceptOrder` before placing an order. `inventory` **subscribes** to `OrderCharged` to deduct stock, and `catalog` subscribes to `StockDepleted` to mark a product AGOTADO.

The front end mirrors the same modules as feature folders, built from atomic components on design tokens.

## Consequences
- Easier: a clear ownership map for agents (JANUS and VULCAN by module), safe parallel work, and any module can be extracted later because it owns its tables and talks through interfaces and events.
- Harder: some extra discipline (no cross-module joins; reports use read models), and architecture tests are needed from Cycle 1.
