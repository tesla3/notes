← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Final Re-Evaluation: Peter Steinberger and the Agentic Coding Movement

## What the Evidence Actually Shows (as of February 16, 2026)

This document consolidates three rounds of research, self-critique, and source verification. It weighs Peter Steinberger's claims against the best available evidence — not just from his circle, but from rigorous studies, macro-level data, and independent practitioners outside his network.

---

## I. THE MACRO PICTURE: Something Is Very Wrong With the Productivity Narrative

My first two analyses failed to center the most important evidence. Here it is, assembled:

### The METR Study (July 2025)
- Randomized controlled trial. 16 experienced developers. 246 tasks. Screen-recorded.
- Developers using AI tools (Cursor Pro + Claude 3.5/3.7 Sonnet) were **19% slower**.
- Developers *believed* they were 20% faster. The perception gap is ~40 percentage points.
- Deep familiarity with the codebase made AI *less* useful, not more. Developers were slowed down more on tasks where they had high prior exposure.
- This is the only RCT in the space. No follow-up with late-2025 models has been published as of February 2026.
- One participant (Domenic Denicola, jsdom) noted tools like Codex and Jules hadn't launched during the study period, and that parallel agent workflows — Peter's mode — weren't measured. This is a legitimate limitation.

### Mike Judge's Independent Replication (September 2025)
- Judge, a principal developer at Substantial, ran a six-week self-experiment after reading the METR study.
- Found AI slowed him down by a median of 21%, mirroring METR.
- Then investigated *macro-level output*: new apps on App Store, new games on Steam, new GitHub projects, new website registrations. Found flat lines everywhere across every sector. "You could not tell looking at these charts when AI-assisted coding became widely adopted."
- His framing: "Where's the shovelware?" If millions of developers are 2-10x more productive, where is the flood of new software? It doesn't exist.

### Faros AI Telemetry (July 2025)
- Analyzed data from 10,000+ developers across 1,255 teams.
- Individual output up: 21% more tasks completed, 98% more pull requests merged.
- But: PR review time ballooned by 91%. Developers interacting with 47% more PRs daily.
- **Organizational delivery metrics: flat.** No improvement in lead time, deployment frequency, change failure rate, or MTTR.
- Named this "The AI Productivity Paradox": AI is everywhere, but impact isn't.

### DORA 2025 Report (September 2025)
- Nearly 5,000 technology professionals surveyed.
- AI adoption at ~90%. Median usage: 2 hours/day.
- 2025 marked a shift: AI's relationship with throughput went from *negative* (2024) to positive.
- But: **AI adoption continues to correlate with increased software delivery instability.** This hasn't improved.
- Core finding: "AI is an amplifier. It magnifies the strengths of high-performing organizations and the dysfunctions of struggling ones."
- No correlation between AI adoption and reduced burnout — but also no correlation with increased burnout. Neutral.

### GitClear Code Quality Data (2024-2025)
- 211 million changed lines of code analyzed across five years.
- Code duplication up 8x since pre-AI baseline.
- Copy/paste now exceeds code-moved-to-new-location for the first time in history.
- Short-term code churn (code rewritten within two weeks) rose from 3.1% (2020) to 5.7% (2024).
- Bug frequency: 19% lower short-term, but 12% *higher* over 6 months — delayed consequences.
- Maintainability index dropped 17%. Team review participation fell 30%.
- GitClear calls this "the illusion of correctness" — AI code looks clean but has deeper structural problems.

### Stack Overflow 2025 Developer Survey
- 65% of developers using AI tools weekly.
- Positive sentiment toward AI tools *fell* for the first time: from 72% favorable (2024) to 60% (2025).
- Only 3% of developers "highly trust" AI outputs. 46% actively distrust them.
- 66% report dealing with "AI solutions that are almost right, but not quite."

### MIT Technology Review Investigation (December 2025)
- Interviewed 30+ developers, executives, analysts, and researchers.
- Found growing gap between vendor claims and developer experience.
- Bain & Company described real-world savings as "unremarkable."
- Sonar research: obvious bugs decreasing, but "code smells" (maintenance-debt indicators) now make up 90%+ of issues in AI-generated code.

### Penn Wharton Budget Model (2025)
- AI increased aggregate productivity by only 0.01 percentage points despite 26.4% of workers using generative AI.
- McKinsey: only 6% of organizations are "AI high performers" (5%+ EBIT impact from AI).
- S&P Global: 42% of companies abandoned most AI pilot projects before reaching production.

**Verdict on the macro picture:** The weight of institutional evidence — RCTs, telemetry from 10,000+ developers, surveys of 50,000+ developers, industry analysis from Bain, McKinsey, and DORA — points in the same direction. Individual developers produce more *stuff* faster. But that stuff requires more review, more debugging, more maintenance. Organizational delivery metrics are flat. Macro-level software output shows no visible boom. Developer sentiment is declining even as adoption increases. The productivity revolution, measured at any scale larger than a single person's screen, has not materialized as of early 2026.

---

## II. RE-EVALUATING PETER'S CLAIMS AGAINST THIS EVIDENCE

### Claim 1: "I ship code I never read" → PARTIALLY VALID, HEAVILY CONTEXTUAL

Peter is telling the truth about his own experience. He does ship code he hasn't read line-by-line. But this works for specific reasons that don't generalize:

- He builds **CLIs, web frontends, personal automation tools, messaging bots**. These are domains saturated in LLM training data. Error costs are low (a CLI bug doesn't kill anyone).
- He has **13 years of architecture experience**. He knows what good structure looks like without reading every line.
- His projects are **solo, greenfield, and disposable**. No team needs to maintain this code. No compliance requirements. No customers whose data is at risk (except OpenClaw users — and that went badly).
- He commits to main with no PRs because **he is the only reviewer**. The Faros data shows that review is the bottleneck that absorbs AI productivity gains in teams. Peter eliminates the bottleneck by eliminating review.

The METR data suggests that for developers working in **mature, complex codebases they know well**, not reading AI-generated code is actively harmful. Peter works in the opposite context: new, simple codebases where he's the sole architect.

### Claim 2: "Models got qualitatively better" → TRUE, BUT THE GAP MATTERS

Model improvements are real. SWE-bench scores went from 33% to 70%+ in a year. Context windows expanded dramatically. One-shot success on standard tasks genuinely improved.

But here's what Peter doesn't address:

- SWE-bench measures whether code *passes automated tests*, not whether it's maintainable, secure, or architecturally sound. METR found that "AI systems often produce code that scores well but isn't production-ready due to issues with test coverage, formatting, and code quality."
- The models Peter used in his December 2025 "Shipping at Inference-Speed" post (GPT-5.2 Codex) are genuinely better than the METR study's models (Claude 3.5/3.7 Sonnet, February-June 2025). **No rigorous study has tested the late-2025 models.** Peter's claim that 5.2 "one-shots almost anything" is plausible but empirically unverified.
- Sonar's research shows a troubling pattern: as models improve, obvious bugs decrease but subtle maintenance problems ("code smells") increase. The code *looks* better while becoming harder to maintain. This is exactly the kind of failure mode that would fool a developer who isn't reading code line-by-line.

### Claim 3: "The workflow is radically simple" → TRUE FOR HIM, DANGEROUS AS PRESCRIPTION

Peter's workflow (no branches, no PRs, no issue tracker, commit to main, 3-8 parallel agents) is genuinely optimized for a solo expert builder of disposable tools.

The DORA 2025 findings directly contradict this as general advice:
- "AI doesn't fix a team; it amplifies what's already there."
- Teams lacking strong version control, automated testing, and fast feedback loops see AI *increase* instability.
- The practices Peter *removes* (branching, PRs, code review) are the exact practices DORA identifies as necessary guardrails for AI-accelerated development.

Anthropic's own 2026 Agentic Coding report — from the company that makes Claude Code — says developers use AI in 60% of work but fully delegate only 0-20% of tasks. Peter claims near-100% delegation. He is an extreme outlier, not a template.

### Claim 4: "Language/ecosystem choice matters more than code quality" → INTERESTING, PARTIALLY SUPPORTED

Peter's claim that Go is ideal for agents is corroborated by Armin Ronacher and Thorsten Ball independently. The reasoning (simple type system, fast linting, low ecosystem churn, agents generate idiomatic Go easily) holds up.

But "matters more than code quality" is dangerous framing. GitClear's data shows that AI-generated code quality is declining on every measurable axis. The language choice helps agents produce *syntactically correct* code more reliably. It does not address the structural, architectural, and maintenance quality problems that are accumulating at industry scale.

### Claim 5: "OpenClaw is the future of personal AI" → THE DEMAND IS REAL, THE EXECUTION IS NOT

OpenClaw's 180K+ stars and viral adoption prove genuine demand for personal AI agents. Peter identified a real product space. This is validated.

What's not validated:
- Security: 512 vulnerabilities (8 critical) in January 2026 audit. 1.5M API keys exposed via Moltbook. 135K+ instances exposed on public internet. 15% of community skills contained malicious instructions.
- These aren't Peter's engineering failures alone — they're inherent to the "open personal agent" model. But Peter's response was to join OpenAI rather than fix them. The problems remain for the 180K+ users.
- The "foundation" structure announced February 14 is days old. No governance details. No security roadmap. OpenAI "sponsors" the project but the relationship between "foundation" and "core to our product offerings" (Altman's words) is undefined.

---

## III. THE SOCIAL NETWORK PROBLEM

My original analysis treated Peter, Armin, Mario, and Thorsten as partially independent voices converging on similar conclusions. This was generous. They are:

- **Peter Steinberger** → inspired Mario to build Pi, directly influenced by Armin
- **Armin Ronacher** → contributor to Pi/OpenClaw, close friend of Peter, shares the Vienna tech scene
- **Mario Zechner** → built Pi because of Peter's work, based in Austria
- **Thorsten Ball** → part of the same European developer community, works at Amp/Sourcegraph (which competes in the agent space and has commercial incentives)

Their convergence on "minimal tooling, CLI-first, agents are transformative" is partly real pattern-matching by smart people and partly social consensus formation within a tight friend group. **This is not independent replication.** It's correlated evidence.

Simon Willison stands slightly outside this cluster and is more careful — he validated specific claims while consistently flagging risks and calling for rigor. His voice carries more independent weight.

Voices *truly* outside this circle — Mike Judge, the METR researchers, Bill Harding (GitClear), the 30+ developers MIT Technology Review interviewed, the 5,000 DORA respondents — tell a more mixed story.

---

## IV. WHAT MY PREVIOUS ANALYSES GOT WRONG

### Error 1: I took practitioner enthusiasm as evidence of productivity
The METR study's deepest finding is that **subjective productivity perception is unreliable**. Developers consistently believe AI makes them faster even when it doesn't. This is not an accusation of dishonesty — it's a documented cognitive bias. Peter, Armin, Mario, and Thorsten may all sincerely believe they are dramatically more productive. They may all be wrong, or at least less right than they think.

One METR participant described the "generative AI slot machine effect." Another called it "Turbo-Charged Rubber Ducking." Peter's own admission that he had to stop coding from his phone for mental health and Armin's discomfort with parasocial bonds to AI both point to the same phenomenon: these tools engage reward systems in ways that feel productive regardless of whether they are.

### Error 2: I underweighted the macro evidence
If the productivity claims were true at scale, Mike Judge's question would have an answer: where's the shovelware? Where's the hockey stick in new app releases, new GitHub projects, new game launches? The data shows flat lines. This is not conclusive — there are lag effects, and "productivity" might mean "same output, fewer people" rather than "more output" — but it is the strongest available macro signal, and I buried it.

### Error 3: I treated the METR study as a footnote to add in self-critique
It should have been the anchor of the entire analysis. It's the only randomized controlled trial. Everything else — vendor studies from GitHub/Google/Microsoft, practitioner testimonials, benchmark scores — is either methodologically weaker or has commercial conflicts of interest.

### Error 4: I was too impressed by Peter's *activity* without questioning its *value*
Peter runs 3-8 projects simultaneously and ships constantly. But volume ≠ value. Many of his projects are CLIs, utilities, and personal tools. VibeTunnel, Summarize, Oracle — these are useful but small. The big one, OpenClaw, immediately hit severe security problems at scale. Shipping fast is impressive. Shipping well is harder. The GitClear data shows this pattern at industry scale: more code, more churn, declining quality.

### Error 5: I framed the OpenAI hire too generously
I described it as Peter choosing "access to frontier models" over building a company. The CNBC reporting makes it clearer: OpenAI sees OpenClaw's 180K-star distribution channel as "core to our product offerings." Peter rejected Meta and OpenAI *acquisition* offers but accepted an *employment* offer. This is an acqui-hire that preserves open-source optics. Post-hire, every Peter Steinberger blog post carries OpenAI's institutional interests as context. His pre-hire writing is more epistemically valuable than anything he'll write going forward.

---

## V. WHAT STANDS — THE GENUINE CONTRIBUTIONS

Despite all the above, Peter has made real contributions that survive harsh scrutiny:

**1. The minimal tooling insight is real.** Read/write/edit/bash as a sufficient agent toolkit is validated by multiple independent implementations (Pi, Amp's 315-line agent, Claude Code's own architecture). This isn't hype — it's engineering wisdom.

**2. "Design codebases for agents" is genuine foresight.** Armin designing a programming language for agents is the logical extreme. This idea will matter regardless of current productivity debates.

**3. He identified the personal agent market.** OpenClaw proved massive latent demand exists. The product space is real even if the execution was premature.

**4. His blog is the best primary source document of this era.** Whatever one concludes about his claims, the posts are detailed, specific, timestamped, and honest about failures. This kind of real-time field documentation has enormous historical value.

**5. He moved the Overton window on solo-operator engineering.** Whether or not his productivity claims survive rigorous measurement, he demonstrated a *style* of working — many parallel agents, messaging-as-interface, docs-as-shared-state — that is genuinely novel and will influence how tools are built.

---

## VI. THE REAL STATE OF PLAY (February 2026)

Weighing all evidence:

**AI coding tools genuinely help with:** boilerplate, tests, bug fixes, explaining unfamiliar code, overcoming blank-page paralysis, prototyping, and expanding the range of tasks a single developer can attempt. These are real, validated, multiply-confirmed benefits.

**AI coding tools do NOT yet deliver:** measurable productivity gains for experienced developers on familiar codebases (METR), organizational delivery improvements (Faros/DORA), maintainable code at scale (GitClear/Sonar), or a visible increase in aggregate software output (Judge's macro analysis).

**The gap between these two truths is where Peter lives.** He uses AI for the things it's good at (greenfield projects, CLIs, personal tools, rapid prototyping) while avoiding the things it's bad at (mature codebases, team coordination, security-critical systems, long-term maintenance). His blog documents the first category. The institutional research documents the second. Both are true simultaneously.

**The critical question for 2026:** Will late-2025 / early-2026 models (GPT-5.2, Claude Opus 4.5, Codex) close this gap? Peter says yes. The METR team plans follow-up studies. No rigorous data exists yet. This is an empirical question, not a philosophical one, and it remains open.

**The honest assessment:** Peter Steinberger is a skilled engineer who found genuine leverage in a specific niche (solo, greenfield, tool-heavy development) and documented it with unusual candor. His work inspired thousands and identified a real product category. But the broader narrative — that agentic coding is a productivity revolution — is not supported by the best available evidence as of February 2026. The revolution may come. It hasn't arrived yet. And the people most convinced it has already arrived are, per the METR data, the least reliable judges of that question.

---

## Sources and Evidence Quality

| Source | Type | Sample | Independence | Weight |
|--------|------|--------|-------------|--------|
| METR (Jul 2025) | RCT | 16 devs, 246 tasks | Non-profit, no vendor ties | **Highest** |
| Faros AI (Jul 2025) | Telemetry | 10,000+ devs, 1,255 teams | Analytics vendor, no AI tool stake | **High** |
| DORA 2025 (Sep 2025) | Survey + analysis | ~5,000 respondents | Google-backed but multi-vendor | **High** |
| GitClear (2024-2025) | Code analysis | 211M changed lines | Analytics vendor | **High** |
| Stack Overflow (2025) | Survey | 49,000+ devs | Independent platform | **High** |
| MIT Tech Review (Dec 2025) | Investigative journalism | 30+ interviews | Independent | **High** |
| Judge macro analysis (Sep 2025) | Public data analysis | Multiple platforms | Independent developer | **Medium-High** |
| Anthropic 2026 Report (Jan 2026) | Industry report | Customer case studies | **Vendor** (sells Claude Code) | **Medium** — conflicts of interest |
| Peter's blog (2025-2026) | Personal testimony | N=1 | **Now OpenAI employee** | **Medium** pre-hire, **Low** post-hire |
| Armin/Mario/Thorsten | Personal testimony | N=3 | Correlated with Peter's circle | **Medium** as group, **Low** individually |
| GitHub/Google/Microsoft vendor studies | Controlled experiments | Varies | **Vendors** selling AI tools | **Low** — commercial conflicts |
