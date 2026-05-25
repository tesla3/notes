← [Index](../README.md)

# The AI Productivity Decay Curve: Elaboration and Source Audit

**Date:** 2026-03-16
**Context:** Elaboration on the "alexpotato decay curve" claim from the [100-hour vibecoding gap distillation](research/hn-100-hour-vibecoding-gap.md) and the [senior delegation hypothesis evaluation](research/hypothesis-senior-delegation-ai-steering.md).

---

## Source Decomposition

The "alexpotato decay curve" in the distillation is a **synthesis of three independent HN commenters** in thread #47386636, not a single person's framework. The distillation compressed them into one person's name.

### The Three Original Sources

**1. alexpotato** ([HN #47387423](https://news.ycombinator.com/item?id=47387423)) — the numbers

20-year DevOps/SRE in FinTech and crypto. Provided the quantitative decay:

> "vibe coding can 100% get you to a PoC/MVP probably **10x faster** than pre LLMs... But then I need to go in and double check performance, correctness, information flow, security etc. The LLM makes this easier but **the improvement drops to about 2-3x** b/c there is a lot of back and forth + me reading the code to confirm... Testing workloads that take hours to run still take hours to run with either a human or LLM testing them out (**that is still the bottleneck**)."

His conclusion names the mechanism behind bimodal experience reports:
> "If you've never built a data pipeline and a LLM can spin one up in a few minutes, you think it's magic. But if you've spent years debugging complicated trading or compliance data pipelines you realize that the LLM is saving you some time but not 10x time."

**2. netbioserror** ([HN #47389907](https://news.ycombinator.com/item?id=47389907)) — the principle

Stated the inverse proportionality as a general law:

> "LLM effectiveness is inversely proportional to domain specificity. They are very good at producing the average, but completely stumble at the tails. Highly particular brownfield optimization falls into the tails."

**3. matt_heimer** ([HN #47387913](https://news.ycombinator.com/item?id=47387913)) — the domain-specific evidence

Java HFT engine developer. Showed the near-zero endpoint of the curve:

> "The amount of things AI gets wrong is eye opening. If I didn't benchmark everything I'd end up with much less optimized solution. AI really wants to use Project Panama... I'm talking about primitive arrays being better for Vector/SIMD operations on large sets of data. NIO being better than FFM+mmap for file reading."

Background: former Sun Java curriculum author, wrote concurrency certification exams, decades of experience in the exact niche where AI fails hardest.

---

## The Decay Curve, Reconstructed

| Phase | Speedup | What's happening | Source |
|---|---|---|---|
| **Prototyping** (unfamiliar domain, standard patterns) | ~10x | LLM handles boilerplate, API glue, CRUD, scaffolding. Low domain specificity. | alexpotato |
| **Production hardening** (correctness, security, perf) | ~2-3x | Human must verify every decision. Back-and-forth review. Domain knowledge required. | alexpotato |
| **Domain-specific optimization** (HFT, compliance, niche infra) | ~0-1x | LLM reaches for popular/fashionable solutions, not optimal ones. Benchmarking required. May be net negative. | matt_heimer, netbioserror |

---

## Corroborating Institutional Sources

### 1. McKinsey (cited in arXiv Oct 2025 survey)
**Source:** [arXiv:2510.10819v1](https://arxiv.org/html/2510.10819v1)

The closest thing to a formal measurement of this curve:
- **Simple tasks: ~50% time savings**
- **Highly complex tasks: <10% time savings**

The practitioner decay curve expressed in controlled research. alexpotato's 10x→2-3x→0x and McKinsey's 50%→<10% are the same curve from different measurement angles (speedup multiplier vs. time savings percentage). Referenced in the KB's [Steering ∝ Theory](insights.md#steering-theory) and [Context-Task Crossover](insights.md#context-task-crossover) insights.

### 2. METR RCT (Feb–June 2025)
**Source:** METR blog, 16 experienced OSS devs, 246 tasks on their own mature repos

Experienced developers on their own mature repos were **19% slower** with AI assistance — while self-reporting 20% faster. This is the endpoint of the curve: for domain experts working on codebases they already understand deeply, AI provides net-zero or net-negative productivity. Domain specificity is maximum (their own code), and the curve predicts near-zero benefit.

### 3. Mike Judge independent A/B (Sep 2025)
**Source:** Mike Judge blog + BigQuery analysis

Six weeks of coin-flip A/B testing on himself: AI slowed him down ~21%, matching METR. His BigQuery analysis of GitHub, app stores, and package registries shows flat output across every sector — consistent with the curve's prediction that domain-specific professional work sees minimal gains.

### 4. DX Survey (Laura Tacho, Feb 2026)
**Source:** [shiftmag.dev coverage](https://shiftmag.dev/this-cto-says-93-of-developers-use-ai-but-productivity-is-still-10-8013/) · 121K devs, 450+ companies

Self-reported productivity plateaued at ~10%. AI-authored production code at 26.9% (up from 22%). If a quarter of code is AI-written but productivity only rose 10%, the generation-to-value conversion is decaying — more AI code, same output. The organizational expression of the curve: easy generation (the 10x phase) is consumed by review overhead (the 2-3x phase), leaving a flat residual.

### 5. Addy Osmani (Dec 2025)
**Source:** Addy Osmani blog

Practitioner confirmation of the mechanism:
> "The AI lets me operate at a higher level of abstraction (focusing on design, interface, architecture) while it churns out the boilerplate, but I need to have those high-level skills first."

The boilerplate phase is fast (10x). The architecture/design phase — the domain-specific part — is unchanged.

### 6. IDC (2024) + Microsoft "Time Warp" (2025)
**Sources:** [IDC 2024](https://www.infoworld.com/article/3831759/developers-spend-most-of-their-time-not-coding-idc-report.html) · [Microsoft "Time Warp" 2025](https://arxiv.org/abs/2502.15287) (484 devs)

Coding is 11-16% of developer time. Communication, debugging, architecture, and meetings consume the rest. Even infinitely fast coding (the 10x phase applied to 100% of coding tasks) yields only 1.1-1.2x organizational speedup — because everything after the coding phase operates at the 2-3x or 0x portion of the curve.

### 7. Shen & Tamkin RCT (Jan 2026)
**Source:** [arXiv:2601.20245](https://arxiv.org/abs/2601.20245) · Anthropic Fellows Program, n=52

The mechanistic explanation for the curve's shape. The 6 interaction patterns show:
- **Full delegation** (the 10x phase): fastest completion, worst understanding
- **Conceptual inquiry** (the 2-3x phase): the human is doing the domain-specific thinking, AI assists
- The decay IS the shift from delegation to steering. As domain specificity increases, more of the work becomes steering, and steering doesn't scale with AI speed.

---

## Why the Curve Has This Shape

The curve isn't arbitrary. It follows from three structural properties documented in the KB:

**[Prediction-Meaning Tension](insights.md#prediction-meaning-tension):** LLMs optimize for next-token probability, which gravitates toward the statistical average of training data. Standard patterns = lots of training data = high accuracy = 10x. Domain-specific optimization = sparse training data = convergence to the popular-but-wrong solution = 0x. The curve is a direct function of training data density.

**[Steering ∝ Theory](insights.md#steering-theory):** For theory-sparse work, LLMs genuinely excel and steering is overhead. For theory-dense work, steering IS the product. The decay curve is the Steering ∝ Theory relationship expressed as a productivity multiplier: as theory density increases, the human's share of the work increases, and the AI's contribution approaches zero.

**[Context-Task Crossover](insights.md#context-task-crossover):** Below the crossover, context < task and AI saves time. Above it, context ≥ task and AI costs time. alexpotato's 10x→2-3x→0x maps exactly: prototyping is below the crossover, production hardening is near it, domain-specific optimization is above it.

---

## What the Curve Predicts

If the curve is structural (and the convergent evidence suggests it is):

1. **Model improvements shift the curve right, not up.** Better models will handle more complex tasks at the 10x rate, but the decay shape persists — there will always be a domain-specificity frontier where AI provides near-zero value. The frontier moves; the curve doesn't flatten.

2. **The senior-vs-junior gap IS the curve.** Seniors operate in the 2-3x zone because they know when to stop trusting AI and start verifying. Juniors think they're in the 10x zone when they're actually in the 0x zone — they can't tell when AI output has crossed from "standard pattern, probably right" to "domain-specific, probably wrong."

3. **Organizations will systematically overestimate AI value** because the 10x phase is visible (prototypes, demos, POCs) and the 0x phase is invisible (maintenance, debugging, domain-specific optimization). Every AI productivity claim is measured in the 10x zone; every AI productivity disappointment is discovered in the 0x zone.

---

## Connection to the Senior Delegation Hypothesis

The decay curve reframes the [senior delegation hypothesis](research/hypothesis-senior-delegation-ai-steering.md): seniors who delegated to juniors succeed with AI because they learned to **operate at the 2-3x point on the curve** — the zone where human judgment adds the most marginal value. They know:
- When to trust AI output (10x zone: boilerplate, standard patterns)
- When to verify carefully (2-3x zone: production correctness, security)
- When to do it themselves (0x zone: domain-specific optimization, architectural decisions)

Juniors lack this discrimination. They treat all AI output as 10x-zone quality regardless of where on the curve they actually are. The delegation skill is, at its core, **the ability to locate yourself on the decay curve in real time**.
