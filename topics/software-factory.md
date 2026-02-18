# Software Factory

← [Index](../README.md)

## Core Thesis

The question is no longer "which tool helps me write code faster?" but **"what system can produce software autonomously, at scale, with humans only at the policy and exception layer?"**

The "dark factory" analogy comes from manufacturing: a factory that runs lights-off, robots build/inspect/package/ship, humans design products and set policy. Applied to software: agents write/test/deploy code, humans design systems, define specs, and review exceptions.

## Current State (Feb 2026)

- The dominant pattern is **agent loop with test feedback**: agent writes code → runs it → reads error → fixes → repeats
- Anthropic research: key to spanning multiple context windows is an *initializer agent* that sets up the verification environment
- Rakuten: Claude Code ran 7 hours autonomously on 12.5M-line codebase with 99.9% accuracy
- Kiro's autonomous agent: decomposes objectives into subtasks, assigns to sub-agents, runs 10 concurrent tasks, learns from code review feedback
- The Carlini compiler experiment: 16 agents collaborating on shared codebase for 2 weeks, human role shifted entirely to designing test harnesses

## Verification — The Missing Layer

StrongDM open-sourced the execution engine (Attractor specs + CXDB audit log) but **kept the verification layer proprietary**. The DTU, scenario holdouts, satisfaction scoring, LLM-as-judge — that's the competitive moat.

Frontier AI labs independently discovered the same 3-part architecture for verifying AI output: simulation environments, holdout evaluation criteria, outcome-based scoring. The convergence with RLHF/GRPO training is real but not isomorphic. Both communities hit the same wall: judges are imperfect and gameable.

## Verification Harness Design

Three methods reframed as **layers of machine-readable specification** for agent self-correction:
- **Type hints** = specification of data shape (what goes in, what comes out)
- **Contracts** = specification of semantic boundaries (pre/post conditions)
- **Property-based testing** = specification of behavioral invariants

Key ideas: specification sandwich (types → contracts → PBT wrapping every function), contract gradients (tighten as confidence grows), agent-written properties with human review, differential oracles, verification hooks in the agent harness.

## Deep Research

- [Dark Software Factory Review](../research/dark-software-factory-review.md) — the frame shift from developer tools to autonomous production
- [StrongDM Detective Report](../research/strongdm-detective-report.md) — forensic analysis of Attractor/CXDB repos, what they kept proprietary
- [Verification, Alignment & Software Factory](../research/verification-alignment-software-factory.md) — convergence of factory verification with AI training (RLHF/GRPO)
- [Maximum Leverage Brainstorm](../research/maximum-leverage-brainstorm.md) — verification harness design: type hints, contracts, PBT for agent loops

## Related

- [Coding Agents](coding-agents.md) — the tools and landscape context (agent landscape assessment, Kiro autonomous agent, tool comparisons)
