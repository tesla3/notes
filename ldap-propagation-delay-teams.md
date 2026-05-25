# LDAP Propagation Delay After Adding a Team Member

**Date:** 2026-03-24
**Sources:** Permissions_Tool/Teams wiki, AmazonFederate/help/Permissions wiki, Sage posts 32250 & 20030

## Summary

Adding a member via Permissions Teams can take **up to 6 hours** to fully propagate to LDAP/ANT/POSIX groups. Typical case for a single member: **2–3 hours** (dominated by team rule evaluation cycle).

## Delay Breakdown

### 1. Teams → LDAP Group Sync

- **Team rule evaluation** runs **every 2 hours** (attribute data from HRIS refreshes every 2 hrs).
- **LDAP replication rate**: ~1 member/second once the sync kicks off.
  - First-time attach of a 10K-member team → ~3 hrs to replicate all members to LDAP.
  - Subsequent syncs push only **delta** (new/removed members) at 1 member/sec.

### 2. LDAP Group → Downstream Access Propagation

- **LDAP directory replication** (ldap.amazon.com): changes replicate in **tens of seconds** once written.
- **ANT (Active Directory)** groups: replicate in **seconds to minutes**, but Windows caches group memberships — users may need to log off/on.
- **POSIX groups** (via Guam/SinglePass): **~1 hour or more** to deploy to hosts.

### 3. End-to-End Official Guidance

- **Amazon Federate** states: **up to 6 hours** propagation delay when adding/removing users from ANT, LDAP, or POSIX groups.
- New **ANT groups** specifically need **~4 hours** to replicate through the network initially.

## Quick Reference

| What | Typical Delay |
|---|---|
| Team rule eval picks up the change | ≤ 2 hours |
| Delta pushed to LDAP | seconds per member (small delta near-instant) |
| LDAP replication across directory | ~10s of seconds |
| Federate / access checks stabilize | up to 6 hours (official SLA) |
| POSIX on hosts (Guam/SinglePass) | ~1 hour+ |
| New ANT group initial replication | ~4 hours |

## Key Details

- If someone was added within 4 hours, tell them to wait for propagation before escalating.
- Some teams offer a manual "Sync Now" button that triggers immediate LDAP sync, granting access within 5–15 minutes instead of waiting for the automatic cycle.
- Adding someone as an "Additional Member" (override) on a Team follows the same sync pipeline — it still waits for the next team evaluation cycle.
