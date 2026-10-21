---
standard: modular-monolith
area: architecture
scope: company
version: 1.0.0
status: APPROVED
owner: CTO (ATHENA)
approved_by: CEO, 2026-10-21 (Project instruction, Rule 3)
---

# Modular monolith, ready to split

## Purpose
The CEO's Rule 3: *"every project should start as a monolith very well defined and with a component style (atomization) in the most clean and easy way possible; at some point projects will pivot to microservices and big scale products, so that transition should be easy."*

This standard turns that rule into checkable rules. It is binding for every project ([AGENT-RULES](../../AGENT-RULES.md), section 9).

## Applies to
All backend and frontend code, in every project, from the first commit.

## Rules

### One deployable, many modules
1. MUST start as **one deployable application** (one backend service and one front end per audience), with **one repository**. No microservices at the start.
2. MUST split the backend into **modules by business capability** (bounded contexts), for example `catalog`, `inventory`, `ordering`, `identity`. A module is named after the business, never after a technical layer.
3. Each module MUST own its data: its own tables (or schema or prefix), which **no other module reads or writes directly**.
4. Modules MUST talk to each other only through:
   - (a) the other module's **public interface**, an exported service or facade with typed inputs and outputs; or
   - (b) **domain events** published in-process, for example `OrderPlaced`.
   Importing another module's internals, repositories or tables is forbidden.
5. MUST keep a module's public interface small and stable. A change to it is treated like an API change.
6. Cross-cutting code (logging, configuration, authentication context, tenant context) lives in a small **shared kernel**. Business logic MUST NOT live there.

### Ready to split
7. Every module MUST be extractable into its own service without rewriting its business logic. In practice: no shared database transactions across modules, no cross-module joins, IDs instead of object references across module boundaries, and events instead of direct calls where one module only reacts to another.
8. In-process events MUST go through one event bus interface, so it can later be backed by a message broker without changing publishers or subscribers.
9. Module boundaries MUST be enforced by tooling (lint rules or architecture tests), not only by convention.

### Components on the front end (atomization)
10. UI MUST be built from **atomic components**:
    - atoms (button, input, pill);
    - molecules (form field, KPI card);
    - organisms (orders table, product editor);
    - templates (the admin shell);
    - pages.
11. Components MUST be presentational and reusable. Data fetching and business logic live in page or feature containers, not in atoms or molecules.
12. Visual values (colours, fonts, spacing, radius) MUST come from **design tokens** that implement the approved design line, never hard-coded in components.
13. Features on the front end are grouped by the same business modules as the backend.

### Clean and simple
14. Prefer the simplest design that satisfies the requirement. No abstraction is added "for the future" unless this standard requires it or the CEO asks.

## How conformance is checked
- Code review (gate G5): module boundaries respected (rules 2–9), components atomized and token-based (rules 10–13).
- An automated architecture test or lint rule fails the build when a module imports another module's internals.

## Deviations
Only with CTO and CEO approval, logged in the project's decision log.

## Change log
| Version | Date | Note |
|---|---|---|
| 1.0.0 | 2026-10-21 | Created from the CEO's Rule 3 (Project instructions). |
