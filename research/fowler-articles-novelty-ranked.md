← [Index](../README.md)

# Fowler Site Articles (Jul 2025 – Feb 2026): Ranked by Novelty to Me

Based on my conversation history — building toward autonomous software factories, believing code is becoming an intermediate representation ("like assembly"), deep research into SDD/strongDM/Kiro, working on agent topologies with Firecracker VMs, and a sophisticated context engineering setup.

---

**1. The Learning Loop and LLMs (Joshi, Nov 2025)** — The strongest intellectual challenge to my factory thesis. Joshi argues software development is fundamentally a *learning* activity, not a production activity, and that LLMs create an "illusion of speed" — a maintenance cliff where initial velocity collapses once requirements deviate. He directly attacks the assembly-line metaphor I'm building toward. If I'm going to bet my architecture on "code as compiled output," I need to have engaged seriously with the best version of the counter-argument. His maintenance cliff graph maps directly to the problem my utility-scoring system is trying to solve — he just thinks the solution is human learning, not automated measurement.

**2. Conversation: LLMs and the What/How Loop (Joshi, Parsons, Fowler, Jan 2026)** — Argues that human-driven abstraction is irreplaceable and that LLMs swing between procedural slop and over-abstracted nonsense when asked to refactor. I've explicitly said "architectural coherence will be addressed by the advance of code agents themselves." This article is the most detailed argument for why that bet might fail. Parsons's closing question — who builds new paradigms if LLMs only work where training data exists? — is directly relevant to anyone trying to build novel factory architectures on top of LLM capabilities.

**3. Assessing Internal Quality While Coding with an Agent (Doernenburg, Jan 2026)** — I've said code readability won't be a short-term concern. Doernenburg tested this premise with a real feature on a real codebase (Swift/Mac, outside the Python/JS comfort zone) and found the AI confidently hallucinated API structures that didn't exist, took brute-force approaches rather than diagnosing root causes, and left him doing the tedious review work while it did the fun part. Even if I don't care about readability, his findings about *confident incorrectness in domain-specific contexts* are directly relevant to my factory's verification problem — utility scores won't catch an agent that's wrong in structurally subtle ways.

**4. Partner with the AI, Throw Away the Code (Vaccari, Jul 2025)** — Actually aligns with part of my worldview (disposable code), but the mechanism is different from what I'd expect. Vaccari used TDD to *steer* the AI through a hard performance optimization — writing tests one at a time, having the AI iterate, then discarding intermediate code. The insight: AI acceptance rate is a terrible metric because the AI's *real* value was helping him understand the problem, not producing the final code. Relevant to my factory because it suggests the verification loop (utility scores) might need to be *inside* the generation loop, not just at the end of it.

**5. Anchoring AI to a Reference Application (Böckeler, Sep 2025)** — An enterprise pattern I haven't discussed: using a compilable reference application as a living prompt source, then using AI to detect "code pattern drift" between generated services and the reference. This is essentially a concrete implementation of my "attractor" concept from the strongDM work, but approached from a different angle — Böckeler uses git commits to scope drift detection, which gives fine-grained control over what kind of drift matters. Could inform my factory's quality-control layer.

**6. Stop Picking Sides (Highsmith, Jan 2026)** — The explore/exploit framework with four dials (uncertainty, risk, cost of change, evidence threshold) maps onto my factory design problem. I'm building a system that needs to explore (discover the right specs and agent topologies) and then exploit (mass-produce reliably). The "handoff tax" concept — failures at the seams between modes — is relevant to my pipeline transitions. Not AI-specific, but the operational design lens could sharpen my factory architecture.

**7. To Vibe or Not to Vibe (Böckeler, Sep 2025)** — I'm already thinking about verification more rigorously than most (property-based testing, runtime contracts, utility scoring). But Böckeler's probability × impact × detectability framework is a clean heuristic for deciding *where* in my factory pipeline to invest verification effort. I'd probably operationalize it differently, but the three-axis model is compact and useful.

**8. Context Engineering for Coding Agents (Böckeler, Feb 2026)** — I've already installed everything-claude-code with 13+ specialized agents, hooks, skills, and multi-agent orchestration. I live this. The article's taxonomy (instructions vs. guidance, who-decides-to-load, size management) is well-organized but covers territory I already navigate daily. The "illusion of control" closing might be the one paragraph worth reading — it's a concise articulation of why context engineering is probabilistic, not deterministic.

**9. Understanding SDD: Kiro, spec-kit, and Tessl (Böckeler, Oct 2025)** — I've already researched Kiro CLI deeply and evaluated strongDM's spec-driven factory. Böckeler's findings (agents ignore specs, or follow them too eagerly) are things I'd likely discover in my own experiments. Her skepticism about upfront specification is the standard agile objection — I've already heard and partially rejected it.

**10. I Still Care About the Code (Böckeler, Jul 2025)** — I explicitly don't agree with the premise. The on-call acid test is clever, but my architecture deliberately routes around this by making code disposable and verification automated.

**11. Excessive Bold (Fowler, Jan 2026)** — A writing style piece. Not relevant to my work unless I'm writing documentation for my factory.

---

## Key Concept from the Analysis: Cognitive Debt

The single most important concept across all these articles is **cognitive debt** — teams shipping faster while understanding less, accumulating invisible debt that compounds until a change arrives that no one understands how to make. This is the Fowler orbit's strongest contribution and the most direct challenge to the factory model. My utility-scoring + automated verification approach is essentially a bet that cognitive debt can be managed through measurement rather than human understanding. Whether that bet pays off is the open question.
