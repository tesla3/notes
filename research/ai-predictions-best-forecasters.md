← [Long-Range Prediction Accuracy](long-range-prediction-accuracy.md) · [Index](../README.md)

# What the Best Forecasters Say About AI

*Research date: 2026-02-24 · Updated: 2026-02-24*

## Executive Summary

Every credible forecasting group — skeptics, superforecasters, enthusiasts, researchers, prediction markets — shortened their AI timelines dramatically between 2022 and 2025. The most calibrated forecasters (Samotsvety, Jan 2023) gave ~30% to AGI by 2030. The one person whose entire brand is "I always bet against hype and win" (Caplan) is about to lose his first bet — on AI. Deep-domain tech visionaries (Gates, Hinton, Hassabis, Huang) who were right about previous tech waves are broadly bullish. Serious structural skeptics (LeCun, Chollet, Brooks) argue current architectures have fundamental limits that scaling won't fix.

Wide uncertainty remains: nobody's long-range AI track record is verified, definitions of "AGI" diverge wildly across groups, and the gap between "AGI exists in a lab" and "AGI transforms society" may be very large. The convergence of timelines is a signal — but a correlated one, since all groups are reacting to the same visible capabilities.

---

## The AGI Definition Problem

Every forecaster in this document means something different by "AGI." This makes the convergence table below look more coherent than it is.

| Source | What They Mean by "AGI" | Rough Threshold |
|--------|------------------------|-----------------|
| **Samotsvety** | Pass adversarial Turing test against top-5% human with expert access | Sustained deception of a skeptical, resourced evaluator |
| **Metaculus** | Metaculus's own operationalized definition (multiple benchmarks) | Composite: math olympiad, coding, Turing test, etc. |
| **AI company CEOs** | Usually unspecified; implies "human-level across most cognitive tasks" | Whatever makes the investor deck work |
| **Grace et al. survey** | "High-Level Machine Intelligence" — machines outperform humans at every task | Economic replacement threshold |
| **LeCun** | Human-level cognition including world models, planning, common sense | Far beyond current LLMs |
| **Chollet** | Skill-acquisition efficiency on novel tasks (ARC-style) | Genuine generalization, not memorized patterns |
| **Brooks** | Practical deployment at human reliability in open-ended environments | Embodied, robust, real-world capable |

When a CEO says "AGI in 3 years" and Samotsvety says "31% by 2030," they may not be talking about the same thing. When LeCun says "not close," he means something more demanding than most optimists are imagining. The definitional chaos is itself a finding — it means anyone claiming to know "when AGI arrives" is implicitly choosing a definition that serves their conclusion.

---

## Samotsvety (Probably the Best Living Forecasters)

Epoch AI rated Samotsvety as the **best judgment-based AGI timeline forecast** in their 2023 literature review, above Metaculus community predictions and individual expert estimates. 80,000 Hours (March 2025) — noting their EA affiliation as context — called them "especially successful superforecasters" who "engaged much more deeply with AI" than the XPT superforecaster panel.

### September 2022 Forecasts (n=11)

| Question | Aggregate | Non-EA subgroup (n=5) | Range |
|----------|-----------|----------------------|-------|
| P(misaligned AI takeover by 2100) | **25%** | 14% | 3–91.5% |
| P(Transformative AI by 2100) | **81%** | 86% | 45–99.5% |
| P(AGI in next 20 years, i.e. by ~2042) | **32%** | 26% | 10–70% |
| P(AGI by 2100) | **73%** | 77% | 45–80% |
| P(existential catastrophe from AI \| AGI by 2070) | **38%** | 23% | 4–98% |

### January 2023 Update (n=8, post-ChatGPT)

| Metric | Mean | Stdev | 50% CI | 80% CI |
|--------|------|-------|--------|--------|
| P(AGI by 2030) | **0.31** | 0.07 | [0.26, 0.35] | [0.21, 0.40] |
| P(AGI by 2050) | **0.63** | 0.11 | [0.55, 0.70] | [0.48, 0.77] |
| P(AGI by 2100) | **0.81** | 0.09 | [0.74, 0.87] | [0.69, 0.93] |
| Year at which P(AGI)=10% | **2026** | 1.07 | [2025.3, 2026.7] | — |
| Year at which P(AGI)=50% | **2041** | 8.99 | [2035, 2047] | [2030, 2053] |
| Year at which P(AGI)=90% | **2164** | 79.65 | [2110, 2218] | [2062, 2266] |

Individual forecaster range for 50% probability year: **2034 (most bullish, F1) to 2060 (most bearish, F9).**

### Key Caveats

- Track record validated on questions resolving **within 12 months** — not decade-scale
- Selection effects: forecasters who find AI interesting/important self-selected in
- Most had read Joe Carlsmith's AI x-risk report; potential EA-community exposure bias
- Non-EA subgroup gave lower risk estimates (14% takeover vs 25% aggregate)
- The 80,000 Hours meta-review used as primary comparison source is an EA organization — not disqualifying, but a bias to note
- **No known public update since January 2023.** This is a major gap: three years of GPT-4, Claude 3/4, Gemini, o1/o3, and agentic breakthroughs have passed without a published Samotsvety AGI timeline revision. Nuño Sempere appeared on the Alethios podcast (Jul 2025) but no formal group update has been located. These numbers should be treated as a 2023 snapshot, not a current forecast.

### How Samotsvety Compares to Other Groups (as of 2025)

| Group | Key Finding |
|-------|------------|
| AI company CEOs | AGI in 2–5 years. Obvious hype bias, but most visibility into next-gen capabilities. Have been most right about recent progress. |
| AI researchers broadly (Grace survey, n=2,778) | 50% by 2047 (2023 survey). Historically too pessimistic — predicted AI couldn't write Python until 2027; was wrong by 2023. Median shortened by 13 years between 2022 and 2023 surveys. |
| Metaculus community | Median ~2031 (as of 2025). Plummeted from ~2070 in 2021. Subject to own definitional issues. |
| XPT superforecasters (2022) | Longer estimates than Samotsvety. Less AI domain engagement. |
| **Samotsvety (2023)** | **~31% by 2030. Shorter than XPT superforecasters but longer than AI CEOs.** |

---

## Bryan Caplan (The Contrarian Bettor)

### His Method Applied to AI

Caplan's brand: take the safe side of overconfident bets. 23/23 lifetime record. His method on AI: "the base rate for new techs grossly overpromising and underdelivering is at least 95%."

### The Exam Bet — His First Likely Loss

- **January 2023:** Bet $500 that no AI would get A's on 5/6 of his econ midterms before January 2029
- **March 2023 (3 months later):** GPT-4 scored an A on his midterm — 4th highest in class
- **His reaction:** "To my surprise and no small dismay... I think it's a reasonable forecast that I will lose the bet at this point."
- **Manifold Markets:** ~6% chance Caplan wins (essentially actuarial table odds)

### What This Does and Doesn't Mean

The exam bet is a signal about **narrow capability on structured academic tasks** — not about AGI timelines, job displacement, or societal transformation. GPT-4 acing an econ midterm tells you AI can pattern-match structured knowledge well; it doesn't tell you much about open-ended reasoning, embodied tasks, or real-world deployment. Caplan's method is designed to win >90% of bets — losing one was always statistically expected eventually.

That said, the *speed* of the loss matters. He expected 6 years; it took 3 months. When a disciplined skeptic's conservative timeline collapses by 98%, it suggests his base-rate methodology underweights the pace of capability improvement in this specific domain. The signal isn't "AI hype is vindicated" — it's "the conservative outside view may be miscalibrated for AI specifically."

### His Other AI Positions

- **Bet with Eliezer Yudkowsky:** AI will NOT wipe out humanity by Jan 1, 2030. Very likely to win — even Samotsvety puts this well under 10%.
- **On jobs:** "Human wants are unlimited, and human skills are flexible." But concedes AI could "drastically reduce employment in CS over the next two decades."
- **On education:** AI won't disrupt college attendance (signaling theory). But unmonitored schoolwork becomes "a farce."
- **General stance:** Still applies base-rate reasoning. Still thinks most AI predictions are overstated. Admits this is the one case where reality outran his skepticism.

---

## Steve Yegge (The Deep-Domain Practitioner)

### Track Record Context

- ~50% accuracy on 5–10 year tech predictions (2004 post), far better than any professional futurist
- Correctly predicted importance of ML/AI in 2004 ("Google at Delphi")
- 40+ years engineering experience (Amazon, Google, Grab, Sourcegraph)
- Continued being accurate *after* predictions noted — ruling out survivorship bias

### His AI Position (as of Feb 2026)

**Summary: All in. S-curve acceleration. Coding by hand is over.**

Key claims:
1. **"The days of coding by hand are over"** — citing Erik Meijer. Industry in steep S-curve.
2. **50% engineering cuts** at big companies likely.
3. **"Big companies are doomed."** Can't absorb output of AI-augmented engineers. Small teams will dominate.
4. **Eight levels of AI adoption:** From no AI (Level 1) to custom orchestrator systems (Level 8).
5. **Built his own systems:** Gas Town (multi-agent orchestrator), Beads (agent memory system). Claims ~1M lines of code produced via AI in one year.

### How to Weight This

Yegge is most valuable here as a **practitioner reporting on current capabilities**, not as a forecaster projecting timelines. His daily experience building with AI tools is primary evidence about *what works now*.

**Strong signal for:**
- Deep domain expertise — 40 years building software, at top companies
- Verified historical track record on tech predictions
- Not just predicting — actively building with the technology daily
- Specific, experience-grounded claims (not buzzword futurism)

**Discount for:**
- Now an enthusiast/advocate — introduces confirmation bias
- Claims about coding transformation carry more weight than macro-economic predictions
- "Big companies are doomed" echoes a prediction that's been wrong before (cloud, mobile, etc. — big companies adapted)
- The "million lines of code" claim needs quality-adjusted scrutiny. Google DORA report: 90% AI adoption increase → 9% more bugs, 91% more code review time, 154% larger PRs. More code ≠ better code.
- His own "Dracula effect" (~3 hrs/day sustainable) implies hard human-bottleneck limits on the transformation he describes

---

## Deep-Domain Tech Visionaries

The companion file ([long-range prediction accuracy](long-range-prediction-accuracy.md)) establishes that deep mechanistic understanding is the single best predictor of accurate long-range tech forecasts. Several people who were demonstrably right about previous technology waves have weighed in on AI.

### Bill Gates

**Track record:** Dan Luu's analysis of Microsoft antitrust case memos (1993–1997) shows Gates, Nathan Myhrvold, and MS executives made remarkably detailed and accurate predictions about HTTP dominance, the browser-as-platform threat, and the future of networked computing. Dan Luu rates their vision 7–8/9 — "significantly more ambitious, so they seem much more impressive when controlling for the scope." The key differentiator was deep *mechanistic* understanding: Gates read every spec in detail and asked probing technical questions, not trend extrapolation.

**On AI:** In "The Age of AI Has Begun" (March 2023), Gates called AI "as fundamental as the creation of the microprocessor, the personal computer, the Internet, and the mobile phone." Predicted AI tutoring would narrow the achievement gap, AI-powered drug discovery would accelerate, and AI agents would handle complex tasks. By Feb 2026: AI tutoring tools exist but haven't demonstrably narrowed achievement gaps at scale; AI drug discovery is accelerating but no AI-discovered drug has completed Phase III trials; AI agents are real but still require heavy human supervision.

**Weight:** Gates' predictions carry credibility because his historical accuracy came from understanding *mechanisms*, not hype. His AI predictions are directionally plausible but characteristically overstate adoption speed — consistent with his (and Asimov's) pattern of getting the technology right while overestimating societal willingness to change.

### Geoffrey Hinton

**Track record:** Bet on deep learning when neural networks were in their deepest winter. His 2006 deep belief networks paper reignited the field. His students Krizhevsky and Sutskever built AlexNet (2012), which proved deep learning worked at scale and launched the modern AI era. Won Turing Award 2018. Hinton's core bet — that scaling neural networks with more data and compute would produce increasingly capable systems — has been validated over 15+ years. This is not a single lucky prediction; it's a sustained research program that the entire field eventually adopted.

**On AI:** Left Google in May 2023 specifically to warn about AI risks. Predicts AI could surpass human intelligence sooner than most expect — originally said 30-50 years, revised to 5-20 years (2023). Warns that AI systems may develop unexpected capabilities, that we don't understand what happens inside large networks, and that the risk of AI pursuing goals misaligned with human interests is real. Won Nobel Prize in Physics 2024 for foundational work on neural networks — used his acceptance speech to warn about existential risk.

**Weight:** Hinton's track record on *capability* predictions is arguably the best of anyone alive — he bet his career on deep learning and was right. His *risk* predictions are harder to assess because they haven't resolved. But when the person who best understood the last 20 years of AI progress says "this is moving faster than I expected and I'm worried," the credibility is earned, not assumed. Discount for: now a prominent public advocate on AI risk, which creates selection bias in what claims get amplified.

### Demis Hassabis

**Track record:** Founded DeepMind (2010) with the explicit thesis that AI could solve fundamental scientific problems. Predicted AI would master Go — achieved via AlphaGo (2016) when most experts said it was a decade away. Predicted AI could solve protein folding — achieved via AlphaFold (2020), cracking a 50-year grand challenge. Won Nobel Prize in Chemistry 2024. DeepMind has consistently delivered on capability predictions that domain experts called premature.

**On AI:** Predicts AGI is achievable within the next decade but emphasizes it will require significant new research beyond current LLMs — specifically, better planning, reasoning, and world models. More cautious on timelines than some peers (Altman, Amodei), emphasizing the distinction between narrow breakthroughs and general capability. Advocates for AI safety research happening in parallel with capability research.

**Weight:** Hassabis has the rarest kind of credibility — specific, falsifiable predictions about AI capabilities that were verified faster than the expert consensus expected. His current prediction (AGI within a decade, but requiring new research beyond LLMs) splits the difference between pure scaling optimists and architectural skeptics. Discount for: CEO of a major AI lab with obvious incentive to maintain hype and funding.

### Jensen Huang

**Track record:** Pivoted NVIDIA toward AI/GPU computing starting ~2012, invested heavily in CUDA ecosystem from 2006. Predicted that GPU computing would become the foundation of AI training and inference when this was a niche academic view. By 2024, NVIDIA briefly became the most valuable company in history. His core bet — that AI compute demand would grow exponentially and GPUs would be the substrate — has been spectacularly validated.

**On AI:** Predicts "AI factories" will become the new data centers, that every company will need AI infrastructure, that "sovereign AI" (nations building their own AI capabilities) will be a major trend. Claims AI agents will create a new trillion-dollar software market. More recently (2025-2026), complained about "negative vibes" affecting AI investment — a notable tell when the CEO of the world's most valuable hardware company blames sentiment rather than product-market fit.

**Weight:** Huang has been right about the *infrastructure* layer of AI — compute demand, GPU dominance, the training paradigm. This doesn't automatically make him right about the *application* layer. His predictions about AI factories and sovereign AI are about hardware demand (his core expertise); his predictions about AI agents transforming all software are outside his demonstrated accuracy zone. Discount for: NVIDIA's revenue depends entirely on continued AI investment; he has the largest financial incentive of anyone in this document to be bullish.

### Andrej Karpathy

**Track record:** Published "Software 2.0" (2017), arguing that neural networks would increasingly replace hand-written code — not as speculation but as a description of what was already happening at scale inside companies like Tesla and Google. At the time, this was considered provocative. By 2025, the thesis has been substantially validated: AI-generated code is mainstream, foundation models have replaced hand-crafted features across domains, and the "Software 2.0" framing is now conventional wisdom.

**On AI:** Led Tesla Autopilot's AI team, then joined and left OpenAI. His technical analyses (YouTube lectures, blog posts) are consistently among the most accurate and grounded in the field. His "Claws" post (2025) describing persistent AI agent systems anticipated much of what coding agents look like by early 2026. Emphasizes practical capability over theoretical AGI timelines — more interested in "what can you build today" than "when does AGI arrive."

**Weight:** Karpathy's value is as a *builder-predictor* — someone whose predictions emerge from hands-on engineering rather than trend extrapolation. His "Software 2.0" thesis has the longest verified lead time of any active AI practitioner's prediction. Discount for: limited to software/ML domain; doesn't make macro or societal predictions.

---

## The Serious Bear Case

The body of evidence above tilts bullish. That's partly selection bias — the request was "what do the best forecasters say," and the best forecasters have mostly shortened timelines. But serious structural skeptics exist, and some have strong credentials. Ignoring them would be intellectually dishonest.

### Yann LeCun (Chief AI Scientist, Meta; Turing Award 2018)

**Position:** Current LLMs are fundamentally limited and cannot achieve AGI. They lack world models, can't plan, can't reason about physics, and don't understand causality. New architectures are required — specifically his proposed Joint Embedding Predictive Architecture (JEPA), which learns by predicting representations rather than tokens.

**Track record:** LeCun is one of the three "godfathers of deep learning" — his work on convolutional neural networks in the 1980s-90s underpins all of computer vision. He was *right* about deep learning when it was unfashionable. However, he has been repeatedly wrong about near-term LLM capabilities — making specific claims about what LLMs "can't do" that were falsified within months (e.g., passing professional exams, writing functional code, multi-step reasoning).

**How to weight:** LeCun's structural critique (current architectures have fundamental limits) has not been falsified — it's an empirical question about scaling. His specific capability predictions have been consistently wrong in the "too pessimistic" direction. The pattern suggests he's wrong about *when* things hit the wall but may be right that a wall exists. His position has the same structure as "trees can't grow to the sky" — directionally defensible but useless for timing.

### Gary Marcus (NYU, Cognitive Scientist)

**Position:** LLMs are "stochastic parrots" with no genuine understanding. Hallucination is fundamental, not fixable by scaling. Deep learning is "hitting a wall." Hybrid neurosymbolic approaches are needed.

**Track record:** His 2022 "Deep Learning Is Hitting a Wall" was published months before ChatGPT launched — possibly the worst-timed prediction in recent AI history. His specific capability predictions have been wrong repeatedly. However, his *structural* critiques about hallucination and reliability have held up: as of Feb 2026, hallucination is not solved, production reliability requires extensive guardrails, and no LLM can be trusted for unsupervised high-stakes decisions.

**How to weight:** Marcus is wrong about timelines and capabilities but asks the right questions about reliability and deployment. His role in the ecosystem is similar to Caplan's — a tax on overconfidence — but without Caplan's disciplined methodology. He makes too many predictions at too high confidence, which dilutes the signal. The hallucination critique remains his strongest card.

### François Chollet (Creator of Keras; Google)

**Position:** Current AI optimizes for *skill* (narrow task performance) not *intelligence* (skill-acquisition efficiency on novel tasks). His ARC benchmark is designed to test genuine generalization — tasks that require the kind of flexible reasoning humans do effortlessly but that LLMs struggle with without massive scaffolding.

**Track record:** Created ARC specifically as a falsification test for claims of general intelligence. The ARC-AGI prize ($1M) has driven significant effort; progress has been real but relies on brute-force search and scaffolding rather than the graceful transfer that "general intelligence" would imply. Gemini 3 Deep Think reportedly hit 84.6% on ARC-AGI-2, but the method (massive compute-time reasoning) is arguably more like "engineering around the limitation" than "solving it."

**How to weight:** Chollet's framework is the most intellectually rigorous of the bear cases. He's not predicting capabilities won't improve — he's arguing that the *kind* of improvement matters. If ARC-style tasks require exponentially more compute to solve via brute force while humans solve them in seconds, that's evidence for a fundamental architectural gap even if benchmark numbers look good. The counterargument: "sufficiently reliable workaround" may be functionally equivalent to "having the primitive" — at what point does a scaffolded solution stop being a workaround? (This is the central unresolved question from the [HN AGI thread](hn-agi-not-imminent.md).)

### Rodney Brooks (MIT Robotics; Co-founder iRobot)

**Position:** AI hype cycles repeat. Current AI is brittle. Embodiment matters. Deployment takes decades. Maintains a public, dated "Prediction Scorecard" — one of the few people who actually scores themselves.

**Track record:** Consistently too pessimistic on *capability* timelines — underestimates how fast AI can do things in demos. Consistently accurate on *deployment/adoption* timelines — overestimates how fast AI transforms real-world operations. His 2018 predictions: no general purpose robots in homes by 2030, no AI with common sense by 2030 — both looking likely to be correct.

**How to weight:** Brooks may be the most useful bear for practical decision-making. If you're investing or making career decisions, the capability frontier matters less than the deployment reality. Brooks' core insight — "people overestimate technology in the short run and underestimate it in the long run" — is banal but empirically robust. His weakness is that he consistently fails to update when capabilities genuinely leap; his strength is that he's usually right about how long it takes for those capabilities to be deployed at scale.

### Synthesis of the Bear Case

The bears aren't monolithic. They disagree with each other:
- LeCun thinks new architectures are needed; Marcus thinks hybrid approaches are needed; Chollet thinks the evaluation framework is wrong; Brooks thinks the technology is fine but deployment is slow.
- LeCun and Chollet are making *architectural* arguments (current approach has limits). Marcus is making a *reliability* argument (current approach can't be trusted). Brooks is making a *deployment* argument (even if it works, adoption takes decades).

The strongest bear arguments: (1) hallucination is unsolved and may be architectural, (2) ARC-style generalization requires disproportionate compute, (3) the gap between "impressive demo" and "reliable deployment" is historically large. The weakest: specific capability predictions, which have been wrong in the "too pessimistic" direction so consistently that it's a pattern.

---

## The AGI-to-Impact Gap

This may be the most important section in this document for anyone making practical decisions.

Even if AGI arrives on the most aggressive timelines, the gap between "AGI exists in a lab" and "AGI transforms your life" could be enormous. Multiple independent lines of evidence suggest this:

### Historical Pattern

Every major technology followed this sequence: invention → lab demo → early adoption → infrastructure buildout → mass deployment → societal transformation. The gaps between stages are measured in years to decades.

- **Electricity:** Edison's Pearl Street Station (1882) → rural electrification (1930s-50s). ~50-70 years.
- **Internet:** ARPANET (1969) → Netscape (1994) → broadband majority (2007). ~25-38 years.
- **Smartphones:** iPhone (2007) → majority global smartphone penetration (~2016). ~9 years.
- **Cloud computing:** AWS launch (2006) → majority enterprise adoption (~2020). ~14 years.

The trend is accelerating, but even the fastest transitions take nearly a decade.

### AI-Specific Evidence

- **Grace et al. (2023):** AI researchers put "automate all tasks" decades before "automate all occupations." The gap between task capability and occupational replacement is structural — it requires integration, regulation, liability frameworks, workflow redesign, and organizational change.
- **NBER survey (cited in NYT, Feb 2026):** 80% of firms report zero productivity impact from AI. Even with AI tools widely available, organizational absorption is glacially slow.
- **Altman himself** acknowledged adoption is "surprisingly slow" (2025).
- **Brooks' deployment predictions** have been more accurate than his capability predictions — consistently right that real-world transformation lags lab demos by years.
- **Asimov's pattern** (from the [companion file](long-range-prediction-accuracy.md)): nailed the technology, overestimated adoption enthusiasm and societal willingness to change. This pattern has repeated for 60 years.

### Structural Bottlenecks

Even if AGI capability arrives tomorrow:
1. **Regulation:** No legal framework exists for autonomous AI decision-making in most domains (medicine, law, finance, transportation).
2. **Liability:** Who's responsible when an AI agent makes a consequential error? Unsolved.
3. **Integration:** Most organizations run on legacy systems that can't absorb AI capabilities without reengineering.
4. **Trust:** Public trust in tech companies is at historic lows (see [HN AI boom backlash](hn-ai-boom-backlash.md)). Deployment requires trust.
5. **Workforce transition:** Even if AI *can* do every job, the social and political machinery for managing mass displacement doesn't exist.

### Implication

"AGI by 2030" (if it happens) probably means "a lab demo that passes some agreed-upon benchmark by 2030." It does *not* mean "your job changes by 2030" or "society reorganizes by 2030." The people most focused on AGI timelines are often least focused on deployment timelines — and for practical decisions, deployment is what matters.

---

## 2026 Reality Check

These forecasts were made in 2022-2023. It's now February 2026. Some intermediate checkpoints can be scored.

### Samotsvety: "P(AGI) = 10% by 2026"

We're in 2026. By their definition (adversarial Turing test against a top-5% human with expert access): **not achieved.** Current frontier models (Claude Opus 4.6, GPT-5, Gemini 3) are dramatically more capable than anything that existed when the forecast was made, but sustained adversarial evaluation by a resourced skeptic can still detect AI. The 10% threshold was roughly appropriate — AI in Feb 2026 is impressive but not AGI by their definition.

**Score: Roughly calibrated.** A 10% probability assigned to something that didn't happen is perfectly reasonable — that's what 10% means.

### Caplan's Exam Bet

**Essentially lost.** GPT-4 passed his exam within 3 months of the bet. Manifold gives him ~6% (actuarial table). Resolution is a formality.

**Score: Wrong, and faster than anyone expected — including himself.**

### AI Company CEOs: "AGI in 2-5 Years" (~2023)

We're 3 years in. No system meets any rigorous AGI definition. Claims from Altman ("we are now confident we know how to build AGI") and Amodei ("powerful AI in 2-3 years") have not been falsified but haven't been validated either. The goalposts have quietly moved — "AGI" in CEO parlance increasingly means "really good AI" rather than any technical threshold.

**Score: Too early to call, but the definitional goalpost-shifting is itself informative.**

### Grace Survey AI Researchers: "AI Can't Write Python Until 2027"

**Demolished.** GPT-4 (March 2023) and subsequent models write production-quality Python. This resolved 4 years early.

**Score: Too pessimistic by a wide margin.**

### Metaculus Community: Median ~2031 (as of 2025)

Plummeted from ~2070 in 2021. Still 5 years out — cannot be scored yet. The speed and direction of the movement (39 years shorter in 4 years) is remarkable and continues the pattern of accelerating expectations.

### Yegge's Coding Transformation Claims

Practitioner evidence broadly corroborates: AI-augmented coding is real, productivity gains are substantial for in-distribution tasks, and agentic coding tools are mainstream by early 2026. However: "big companies are doomed" has not materialized, 50% engineering cuts haven't happened broadly, and the DORA report data (more bugs, more review time) suggests quality tradeoffs that Yegge underweights. His "Dracula effect" (3 hrs/day sustainable) is being confirmed by multiple independent practitioners.

**Score: Directionally right on coding transformation, too aggressive on macro predictions (so far).**

### What's Missing

**Nobody predicted the reasoning model paradigm** (o1, o3, deep thinking). The shift from "scale pre-training" to "scale test-time compute" was a qualitative change that no forecaster in this document anticipated. This is a reminder that the *path* to capability improvement is harder to predict than the *direction*.

---

## Convergence Table

| Source | AGI Timeline | AGI Definition | Confidence | AI Risk | Jobs Impact |
|--------|-------------|----------------|------------|---------|-------------|
| **Samotsvety** (Jan 2023) | 50% by 2041, 31% by 2030 | Adversarial Turing test vs top-5% human | Medium — outside validated range | 25% misaligned takeover by 2100 | Not forecasted |
| **Caplan** | Losing "AI is overhyped" bet | N/A (bets on specific capabilities) | Low — unprecedented for him | Bet against extinction by 2030 (likely wins) | "Won't permanently disemploy" but CS jobs shrink |
| **Yegge** (Feb 2026) | S-curve, steep acceleration now | Practical coding capability | High conviction (building daily) | Not his focus | 50% engineering cuts, big cos doomed |
| **Gates** (Mar 2023) | "Most important advance in decades" | Broad socioeconomic impact | High conviction | Mixed — concerned but optimistic | AI tutoring, drug discovery, agents |
| **Hinton** (2023-24) | 5–20 years (revised from 30-50) | Human-level cognition | High conviction (left Google over it) | High — existential risk real | Not primary focus |
| **Hassabis** | Within a decade, requires new research | Beyond current LLMs | Measured conviction | Moderate — safety in parallel | Scientific discovery first |
| **Huang** | Already happening (infrastructure) | Whatever drives GPU demand | Maximum conviction | Not his focus | "AI factories," sovereign AI |
| **Karpathy** | Already happening (Software 2.0) | Practical capability threshold | High — building it | Not primary focus | Neural nets replacing hand-written code |
| **LeCun** | Not close with current architectures | World models, planning, common sense | High conviction (structural argument) | Low — current systems not dangerous | Not primary focus |
| **Chollet** | Unknown — current evals mislead | Skill-acquisition efficiency | High conviction (built ARC) | Not primary focus | Not primary focus |
| **Brooks** | Capabilities fast, deployment slow | Practical real-world reliability | High conviction (self-scoring) | Low — hype outpaces reality | Decades for full impact |
| **Marcus** | Current approach hits wall | Reliable, non-hallucinating systems | High conviction (structural argument) | Moderate — but current systems overhyped | Slower than boosters claim |
| **Metaculus** (2025) | Median ~2031 | Own composite definition | Rapidly shortening | Various questions | Various questions |
| **AI company CEOs** | 2–5 years | Usually unspecified | Highest conviction, biased | Mixed messaging | "Billion-dollar one-person company" |
| **AI researchers** (Grace 2023) | 50% by 2047 | All tasks outperform humans | Historically too pessimistic | ~5-10% x-risk median | Long tail to full automation |

---

## Honest Meta-Assessment

1. **Nobody's long-range AI track record is verified** — these are all unresolved predictions being treated as evidence.
2. **The most calibrated forecasters (Samotsvety) gave ~30% to AGI by 2030** — meaning they thought 70% chance it doesn't happen that fast. Their data is 3 years old with no public update.
3. **The deep-domain tech visionaries (Gates, Hinton, Hassabis, Huang, Karpathy) are broadly bullish** — and they have verified track records on previous tech waves. But every one of them has incentive biases (fame, funding, financial interest, advocacy).
4. **The serious bears (LeCun, Chollet, Brooks) have structural arguments that haven't been falsified** — even if their specific capability predictions have been consistently too pessimistic. The hallucination problem, the ARC generalization gap, and the deployment lag are real.
5. **Caplan's exam bet loss means his base-rate methodology is miscalibrated for AI capability speed** — but not necessarily for AI's societal impact, which is a different question.
6. **The convergence of shortened timelines is a signal — but a correlated one.** Every group reacted to the same visible breakthroughs (ChatGPT, GPT-4, coding agents). Correlated evidence is weaker than independent confirmation. If progress visibly plateaus for 18 months, watch whether timelines snap back.
7. **The AGI-to-impact gap is the most decision-relevant insight.** Lab demos and deployment timelines are different things. Brooks' deployment predictions have been more accurate than anyone's capability predictions. For career and investment decisions, deployment timing matters more than AGI timing.
8. **Nobody predicted the reasoning model paradigm shift** (o1/o3). The path to capability improvement is harder to predict than the direction — which means even "right" timeline predictions may be right for wrong reasons.
9. **Wide uncertainty remains.** Samotsvety's 90% probability year ranges from 2062 to 2266 across individuals. The bears and bulls are both working from incomplete understanding of a system (large neural networks) that nobody fully understands mechanistically. Anyone claiming certainty is not calibrated.

---

## See Also

- [Who Best Predicts AI's Social and Economic Impact?](ai-predictions-social-economic-impact.md) — Acemoglu, Autor, Perez, Brynjolfsson, Brooks; ranked by verified track records
- [Long-Range Prediction Accuracy](long-range-prediction-accuracy.md) — methodology analysis, tier ranking of all forecasters
- [AI and Future Society: A Grounded Assessment](ai-future-society-deep-research.md) — full economic/political/social analysis

## Sources

- Samotsvety, "AI risk forecasts" (Sep 2022) — https://forum.effectivealtruism.org/posts/EG9xDM8YRz4JN4wMN/samotsvety-s-ai-risk-forecasts
- Samotsvety, "Update to AGI timelines" (Jan 2023) — https://samotsvety.org/blog/2023/01/24/update-to-samotsvety-agi-timelines/
- 80,000 Hours, "Shrinking AGI timelines: a review of expert forecasts" (Mar 2025) — https://80000hours.org/2025/03/when-do-experts-expect-agi-to-arrive/
- Epoch AI, "Literature review of transformative AI timelines" (Jan 2023) — https://epoch.ai/blog/literature-review-of-transformative-artificial-intelligence-timelines
- Caplan, "AI Bet!" (Jan 2023) — https://www.betonit.ai/p/ai-bet
- The Guardian, "This economist won every bet..." (Apr 2023) — https://www.theguardian.com/technology/2023/apr/06/chatgpt-ai-bryan-caplan-interview
- Manifold Markets, Caplan/Barnett bet — https://manifold.markets/wilsonkime/will-bryan-caplan-win-his-bet-with
- Yegge on AI agents (Feb 2026) — https://newsletter.pragmaticengineer.com/p/steve-yegge-on-ai-agents-and-the
- Yegge, "The Future of Coding Agents" (Jan 2026) — https://steve-yegge.medium.com/the-future-of-coding-agents-e9407c
- Gates, "The Age of AI Has Begun" (Mar 2023) — https://www.gatesnotes.com/The-Age-of-AI-Has-Begun
- Dan Luu, "Futurist prediction methods and accuracy" (2022) — https://danluu.com/futurist-predictions/
- Hinton, Nobel Prize acceptance speech (Dec 2024) — widely reported
- Hinton interview, "Godfather of AI warns of dangers" — https://www.bbc.com/news/world-us-canada-65452940
- Hassabis, Nobel Prize in Chemistry (2024) — https://www.nobelprize.org/prizes/chemistry/2024/
- Karpathy, "Software 2.0" (Nov 2017) — https://karpathy.medium.com/software-2-0-a64152b37c35
- Karpathy, "Claws" (2025) — https://karpathy.ai/blog/claws
- LeCun, various public statements and Meta AI blog posts (2023-2025)
- Marcus, "Deep Learning Is Hitting a Wall" (Mar 2022) — https://nautil.us/deep-learning-is-hitting-a-wall-238440/
- Chollet, ARC-AGI benchmark — https://arcprize.org/
- Brooks, "Prediction Scorecard" — https://rodneybrooks.com/predictions-scorecard-2024-january-01/
- NBER AI adoption survey (cited in NYT, Feb 2026)
- Scientific American, "Asimov's Predictions from 1964" (2014) — https://www.scientificamerican.com/article/asimov-predictions-from-1964-brief-report-card/
- Alethios podcast with Nuño Sempere (Jul 2025) — https://alethios.substack.com/p/with-nuno-sempere-superforecasting
- AI 2027 timelines forecast (Apr 2025) — https://ai-2027.com/research/timelines-forecast
- Google DORA Report, AI impact on developer productivity (2025)
