# Security decisions: PIN, lockout, sessions, retention, operator command (Bar Praza, F1-a)
- Date: 2026-10-22
- Author: JUPITER (CISO). Status: **DRAFT v0.1**. Parameters marked [D] are CISO decisions. The CEO can overrule any of them.
- Answers: [PERICLES → JUPITER](../handoffs/2026-10-21-PERICLES-to-JUPITER.md), [EUNOMIA → JUPITER](../handoffs/2026-10-21-EUNOMIA-to-MINOS-and-JUPITER.md) (open questions 1–4, 8), [ATHENA decisions](../handoffs/2026-10-22-ATHENA-decisions-cycle-1.md).
- Labels: **[D]** decision, **[E]** estimate, **[A]** assumption, **[U]** unknown or needs legal input. No web research was done and nothing was run (Rule 9). Nothing here is a legal conclusion or a compliance claim.

## 1. PIN rules (F1-04, F8)
| Topic | Decision |
|---|---|
| Sign-in | Registered device + staff member picked from the restaurant's list + PIN (D2). The PIN alone never identifies a person. [D] |
| Format | 6 digits. Reject all-same digits, ascending/descending runs, repeated pairs, and a short blocklist (000000, 123123, 112233). [D] |
| Uniqueness | Not required (T-7). [D] |
| Storage | argon2id, per-person salt, server-side pepper held outside the database. Cost parameters set by EUNOMIA from current OWASP guidance [U, not checked]. Never in logs, errors, responses, URLs or analytics. [D] |
| Who sets | The Encargado sets a temporary PIN for staff: shown once, valid 72 h, must be changed at first sign-in. People change their own PIN with the current one. Last 3 PINs can't be reused. No periodic forced rotation. [D/E] |
| Who resets | The Encargado resets any non-Encargado. An Encargado can't reset their own or another Encargado's PIN in the panel. If no second Encargado exists, the Ostaru operator command (section 6) does it. Every set or reset is audited (actor, target, time, no value). [D] |
| Step-up (PIN re-entered within 5 min) | Set/reset a PIN, issue or approve a device, change roles, turn demo mode off, cancel an order. [D] |

## 2. Lockout and pairing limits (confirms H-3, H-4; answers open questions 3 and 8)
| Topic | Decision |
|---|---|
| Per person | 5 wrong PINs in 15 min lock that person for 15 min. 2nd lock in 24 h: 1 h. 3rd: locked until an Encargado unlocks. Success resets the counter. [D] |
| Per device | 20 wrong PINs in 15 min pause PIN entry on that device for 15 min. [D] |
| Per IP | Looser cap set by PROMETHEUS, because a bar shares one address. Correct `trust proxy` setting required. [E] |
| Behaviour | Lock check before PIN check. Same message and similar timing for every failure. Atomic counters. [D] |
| Pairing code | 6 digits, 10 min, one use, voided after 3 wrong tries, new code voids the old one. [D] |
| Pairing attempts | 5 wrong per IP per hour. A global failed-pairing counter above 100 per hour slows every attempt by 2 s and alerts ORPHEUS. It does not block, to avoid a denial of service. Issuing: 5 codes per Encargado per hour. [E] |
| Open question 9 | **Yes, add an approval step**: the new device shows its name, and the Encargado approves it in the panel (with step-up). This binds the code to a restaurant. Cheap, and it closes T-22's main gap. [D, CTO to confirm] |
| Device token | 256-bit random token, hash stored, rotated on each sign-in. Sliding 180 days, absolute cap 365 days, expires after 60 days unused. Cleared cookies mean pairing again. [D] |

## 3. Sessions
| Device | Idle timeout | Absolute |
|---|---|---|
| Shared tablet / console | 5 min for a signed-in person. The registered console keeps showing the board (order numbers, masked phones) with no person signed in. Changing a status needs name tap + PIN. | 12 h |
| Personal phone (bound to its person) | 30 min | 12 h |
| Laptop panel | 30 min | 12 h |

Sessions end on: PIN change/reset, deactivation, role change, device disconnect, sign-out, restaurant suspension. Disconnect also closes open sockets. [D] Timeouts are [E]: test them with Bar Praza in the shadow service.

## 4. Retention
| Data | Rule |
|---|---|
| Customer name, phone, notes on staff-entered orders (S5) | Irreversibly blanked **30 days after the order closes** (Recogido, Cobrado or Cancelado). No partial digits kept. Orders still open 48 h after pickup time are auto-closed as "no recogido". [E/U] |
| Allergy or health notes | Same clock. Visible only to Encargado and Sala y barra. Never exported or copied to Clientes. [A/U] |
| Order record after the purge | Kept without customer data. Period [U, tax/accounting advice]. Nothing deleted until advised. |
| Sign-in and audit events | 12 months, then deleted or aggregated. [E/U] |
| Staff after leaving | Deactivate at once. Delete the PIN hash and revoke devices and sessions. Keep the name as an audit reference until their last audit event expires, then pseudonymize ("ex-staff #n"). [E/U] |
| Data-request records (F9) | Date, type, outcome, handler. No content. 3 years. [E/U] |
| Backups | Daily, 35 days, encrypted, PROMETHEUS only. A deletion ledger (IDs only) is replayed after any restore before go-live. [E] |
| Purge job | Daily, per restaurant, in tenant context, idempotent, with a run record (restaurant, time, cutoff, count, status). Alert if no success in 36 h. [D] |
| Deletion request (R1) | Encargado logs it in F9, finds orders by exact phone, runs a two-step "erase personal data" action (blanks name, phone, notes in that restaurant, logged). Internal target 10 days. [E] |

## 5. CSV exports
**Phones are always masked in every CSV in Release 1. No override.** Allergy notes and free-text notes are never exported. Exports need step-up and are audited (who, when, period). A full-number export, if ever needed, is a new decision. [D]

## 6. Operator command (Q3, Q4, F1-02)
Ostaru creates restaurants with a command-line script on the `platform_operator` role. There is no API route (JANUS, T-15/T-16).
- Runs only from an authorized Ostaru operator account on an approved host. The owner runs it (Rule 9). [D]
- Prints the one-time temporary PIN and first pairing code once, to the terminal only. Never to files, logs, the vault or chat. Delivered to the real Encargado outside the vault. [D]
- The PIN follows section 1 (72 h, forced change). The code follows section 2 and needs approval in the panel. [D]
- Each run writes an audit event (operator, restaurant, time, no secrets). [D]
- Shell history and terminal logging must not capture the secrets. PROMETHEUS documents how. [A]
- The command works only on the restaurant it creates. It cannot read tenant data. [D]
- JUPITER reviews the command's code and tests at G3.

## 7. G3 approver
While the Red Team Lead is vacant I am the **interim G3 approver**, as ATHENA decided on 2026-10-22. Founder rule: the CEO also approves every gate. EUNOMIA authors, ODYSSEUS reviews, and I approve. Since I set several rules the model tests, the CEO should treat my approval as one review, not the only one. [D]

## 8. Review of threat model v0.2
- Severities T-1 to T-28: I agree. Notes:
  - T-6 stays **High** and cannot close until a secret store exists (section 9).
  - T-14 is Medium for staff data. It becomes **High** when F7 adds customer phones.
- Add: **T-29** operator command leaks or misuses a secret (shell history, wrong host) [Medium]; **T-30** lockout abuse locks out staff in a service [Medium]; **T-31** purge job fails silently or crosses restaurants (from F7) [Medium].
- Accept H-1 to H-14 with the numbers above.

## 9. Residual risks and decisions for the CEO
1. **Pepper and secret store (open question 5).** A 6-digit PIN can be guessed offline in seconds if a database copy leaks without the pepper. Until a secret store exists: Cycle 1 uses synthetic staff only, the pepper comes from the environment, and H-11 blocks startup without it. **Before M1 (real staff PINs), choose a secret store, or accept this risk in writing in the decision log.** I can't accept it for you.
2. **Timeout usability.** The 5-minute shared-tablet timeout may slow a busy service. Test in the shadow service.
3. **Design.** No sign-in or pairing screen is designed yet (G2).

## 10. Pre-M1 legal check list (CEO; Business Operations is vacant; external advisor suggested)
1. **Allergens:** what information duties apply to a bar/restaurant, in what form, and what the responsibility split with Bar Praza must say. A disclaimer doesn't replace the duty. [U]
2. **S6 (no tickets or invoices):** does recording "Cobrado" and producing sales reports create invoicing or billing-software duties for the bar or Ostaru? [U]
3. **Phones and notes:** legal basis, customer information notice (WhatsApp customers see no Ostaru screen), controller/processor agreement with each restaurant, identity checks and deadline for deletion requests. [U]
4. **Retention values** in section 4, and tax/accounting periods for order records. [U]
5. **Health data** in allergy notes. [U]
6. **Hosting location** and any transfer outside the EU (hosting not chosen). [U]
7. Permission for read-only web research on the sources above would let me replace these questions with sourced statements.

## Change log
| Version | Date | Note |
|---|---|---|
| 0.1 | 2026-10-22 | First draft by JUPITER. |
