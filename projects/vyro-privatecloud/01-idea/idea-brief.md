# Idea brief — VYRO PrivateCloud
- Date: 2026-10-21
- Author: CEO
- Status: **DRAFT, prepared by the CTO (ATHENA) for the CEO to edit and approve.** Phase 0 belongs to the CEO alone (startup workflow, section 3), so nothing here is decided until the CEO signs it.

> **What the draft is built from.** Two things are on record. The CEO's instruction on 2026-10-21 was to "explore the idea of Vyro private local cloud network system with docker", and an earlier charter describes VYRO PrivateCloud as a self-hosted private infrastructure platform. The original charter file (`main-idea.txt`) is not in the vault, so everything else is marked **[assumption]**. Please attach `main-idea.txt` so this brief can follow it.

## Problem
[assumption] People and small teams want what the public cloud gives them: their files, photos and apps available everywhere, with access shared with the right people. They do not want to hand their data to a third party to get it. Self-hosting is the alternative today, but it means wiring together Docker, a reverse proxy, DNS, certificates, a VPN, single sign-on and backups by hand. The result is fragile, hard to keep updated and easy to leave insecure.

## Target user
**To be chosen by the CEO.** These candidates lead to different products:
1. Privacy-minded households and prosumers: one box at home, simple to run.
2. Small businesses and offices, especially in the EU, that want data sovereignty: several machines and possibly several sites, with users, roles and audits.
3. Developers and homelabbers who want a private platform to deploy their own apps. This space is already crowded with tools such as Coolify and Dokploy.

## Why now
[assumption, to be validated in Discovery]
- Capable, low-power hardware (mini PCs, ARM boards) is cheap.
- WireGuard-based private networking has mature open-source control servers, for example Headscale under BSD-3 ([WZ-IT, Oct 2026](https://wz-it.com/en/blog/mesh-vpn-comparison-2026-overview/)).
- Some incumbents are losing momentum. CasaOS's last stable core release was in December 2024, and its users have been asking about alternatives ([IceWhale / Zima community, 2026](https://shop.zimaspace.com/pages/is-casaos-abandoned-development-status)).

## First guess at the solution
VYRO PrivateCloud is software installed on one or more machines on a local network that turns them into a **private cloud**:
- one web console;
- a curated catalog of apps that run as Docker containers;
- built-in private networking between the user's devices and sites;
- single sign-on;
- automatic HTTPS;
- encrypted backups.

It is **local-first**: it keeps working without the internet, and it needs no public cloud account.

## How we'll know it works
Proposed signals; the CEO sets the targets.
1. A non-expert goes from a blank machine to their first app, reachable from their phone away from home, in under **[15] minutes**.
2. **[N]** pilot users run VYRO as their main storage or apps for at least **[4] weeks**.
3. No data-loss incidents during the pilot, and every pilot user completes at least one restore test.

## Biggest unknowns
1. **Who** is the user, and will they pay? This decides single-box versus multi-node, and consumer versus business features.
2. **Software only or an appliance?** Selling hardware, as Umbrel and Zima do, changes cost, support and margins.
3. **How "local" is local?** Reaching devices from outside a home network behind NAT usually needs a relay on the internet. We must decide whether VYRO provides that relay, the user self-hosts it, or it is optional.
