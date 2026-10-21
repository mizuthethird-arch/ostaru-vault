# ADR-005: File storage for product photos
- Date: 2026-10-21
- Status: **Accepted by the CTO (Q8).** It adds one component to the stack in [ADR-006](ADR-006-technology-stack-v2.md); the CEO can overrule it. Not needed before F2-05 (Cycle 2 [E]).
- Owner: CTO (PROMETHEUS for hosting and cost, EUNOMIA for the G3 upload review)

## Context
F2-05 attaches a photo to each product. The original stack (ADR-002) named no file storage (PERICLES, Q8). Photos must stay separate per restaurant (ADR-003, risk K-1), and uploads are an attack surface (gate G3).

## Options considered
1. **S3-compatible object storage behind a storage interface.** MinIO in Docker Compose for dev; an EU-region S3-compatible provider for staging and production.
2. Photos in PostgreSQL (bytea): one system to run, but it bloats backups and the database.
3. The server's local disk: simplest, but breaks with more than one server and has no managed backups.

## Decision
Option 1.
- `catalog` calls a small **`FileStorage` interface** (put, get a signed read URL, delete) from `packages/shared`. The S3 adapter is infrastructure, so a later provider change touches only the adapter (Rule 3).
- **Keys always start with the restaurant:** `restaurants/<restaurant_id>/products/<uuid>.<ext>`. The bucket is private. Photos are read through short-lived signed URLs that the API issues only after the tenant check.
- **Upload rules (limits to confirm at G3):** JPEG, PNG or WebP only, checked by content, not by name; maximum [5] MB [A]; the server re-encodes the image and strips metadata (EXIF, location) before storing it.
- The database stores only the key, type and size.

## Consequences
- Positive: isolation per restaurant; small database; cheap; portable between providers.
- Negative: one more service in Docker Compose and in production. PROMETHEUS gives the provider and its monthly cost before F2-05 [E: a few euros per month at Bar Praza's size].
- Tests: unit tests for the adapter (against MinIO in CI), an isolation test (restaurant B cannot get a signed URL for A's photo), and rejection tests for wrong type and size.

## Revisit on
G3 for F2-05; the provider choice by PROMETHEUS.
