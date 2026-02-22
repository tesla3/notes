← [Exploit Industrialisation](hn-industrialisation-exploit-generation.md) · [Index](../README.md)

# The SRE Canary: Why Autonomous SRE Is a Proxy for Offensive Cyber Automation

**Origin:** Sean Heelan, "The coming industrialisation of exploit generation with LLMs" (July 2025)

---

## The Two Capability Thresholds

Most discussion conflates "LLMs can hack" as a single capability. Heelan quietly splits it into two distinct thresholds:

### Threshold 1: Offline exploit generation (crossed)

Build a local copy of the target, burn tokens, fail 100 times, deploy the one that works. The agent operates in a controlled environment — it can rehearse, revert, retry. Verification is binary (shell spawns or it doesn't). This is industrialised now. $30-50 per working exploit chain against a real zero-day with modern mitigations.

### Threshold 2: Online adversarial operation (not yet demonstrated)

Once inside a network, an attacker must:

- Move laterally (hop between machines)
- Escalate privileges
- Maintain persistence without detection
- Exfiltrate data

All of these require **online search** — the agent operates in a live, adversarial environment where:

1. It **can't rehearse offline** and replay a solution. The environment's state is unknown and changes.
2. Wrong moves are **permanently punishing** — triggering an alert burns the entire operation. No revert and retry.
3. The environment is **partially observable** — the agent doesn't have full knowledge of what's running, who's watching, or what will trigger detection.

---

## The SRE Parallel

Site Reliability Engineering has the exact same structural properties:

- The agent operates on a **live production system**
- The environment is **complex, partially observable, and stateful**
- Wrong moves are **catastrophic** (drop production database, misconfigure load balancer → outage)
- You **can't fully rehearse offline** because production state is unique

SRE automation is therefore a **civilian proxy** for post-access hacking capability. If a frontier model can autonomously diagnose and fix production incidents — navigating an adversarial environment where bad actions are irreversible — then the same model can almost certainly navigate an enemy network for the same structural reasons.

---

## Why This Is a Good Framing

- **Publicly observable.** We can't know if NSA has automated lateral movement, but we *can* know if PagerDuty or Datadog ships a fully autonomous SRE agent.
- **Falsifiable.** If autonomous SRE arrives and post-access hacking doesn't follow, the parallel breaks.
- **Separates two distinct thresholds** that most commentary conflates: offline exploit generation (here now) vs. online adversarial operation (not yet demonstrated).

---

## Current State

No company has fully automated SRE with general-purpose frontier models. By Heelan's own logic, this means the "online adversarial search" problem remains unsolved — and therefore post-access hacking automation isn't here yet either.

**Watch for:** Any company credibly claiming autonomous incident response (not triage, not alerting — actual remediation in production) using general-purpose models. That's the canary.
