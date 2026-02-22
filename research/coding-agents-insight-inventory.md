← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Coding Agents: Insight Inventory

*Compiled 2025-02-21, revised 2026-02-21. Cross-checked against internal and external sources, connected, editorially audited.*

---

**Strength:** Strong (multiple independent sources) · Medium (single strong source or consistent anecdotes) · Weak (single observation)
**Status:** Established · Emerging · Contested

**Source-quality flags** used throughout:
- ⚠️ **Vendor data** — from a company with commercial interest in the finding
- ⚠️ **Interested party** — researcher/org with incentive to frame results favorably
- ⚠️ **Own analysis** — inference drawn by this corpus, not externally validated

---

## The Central Chain

AI coding tools accelerate the part of software development that was never the bottleneck. These four insights are one argument.

### 1. Coding speed is rarely the organizational bottleneck
Requirements, decisions, review, communication dominate in teams and orgs. Amdahl's Law: even 100% faster coding yields marginal org-level improvement when coding is a minority of total work.

**Scope caveat:** This applies most to orgs and teams. For solo developers on personal projects, coding speed *is* often the binding constraint — which is why #22 (activation energy) works where organizational productivity doesn't.

**Strong · Established** — near-universal agreement in developer communities, well-theorized (Brooks, "No Silver Bullet," 1986). Brooks argued essential complexity (specifications, design, testing of conceptual constructs) dominates, and attacking accidental complexity yields only marginal gains. Verified: Wikipedia summary and original paper confirm the framework is applied correctly here.

### 2. AI handles incidental complexity; essential complexity is untouched and now hidden
Boilerplate, config, CRUD, migrations, API glue — AI handles well. Business rules, edge cases, domain interactions, architectural tradeoffs — it can't. By making the easy parts trivial, AI makes the hard parts *harder to see*. Code that looks correct but misunderstands the domain.

AI does accelerate *discovery* of essential complexity through rapid prototyping — you find out faster that your domain model is wrong. But it can't resolve the tradeoffs once discovered.

**Strong · Established** — near-consensus + Brooks framework. MIT Technology Review (Dec 2025) independently confirms: "AI tools also struggle with large, complex code bases." Alexandru Nedelcu (Nov 2025) adds the Peter Naur angle: programming is theory-building, and AI-generated code lacks the embedded understanding that makes software maintainable.

### 3. Self-reported productivity gains are systematically inflated; the ~10% org-level plateau is stable
METR RCT (16 experienced devs, 246 tasks on their own mature repos, randomized, Feb-June 2025, tools: Cursor Pro with Claude 3.5/3.7 Sonnet): AI *increased* completion time by 19%. Devs estimated 20% faster. Economists predicted 39% faster.

**Important METR caveats** (from their own paper): They explicitly state they do NOT provide evidence that "AI systems do not currently speed up many or most software developers." The study tested a specific population (experienced OSS devs on large, mature projects) with specific tools (early 2025 frontier). What generalizes robustly is the perception gap: people systematically overestimate their AI-assisted speed.

**Corroborating evidence (all independently sourced):**
- Mike Judge's independent A/B (n=1): ~21% slowdown. Separately, his BigQuery analysis of GitHub, app stores, and package registries shows flat output across every sector.
- DX survey (Laura Tacho, Feb 2026 presentation): 121K devs across 450+ companies. Self-reported productivity plateaued at ~10%. ~4 hrs/week saved (flat since Q2 2025). AI-authored production code at 26.9% (up from 22%).
- NBER (Feb 2026): 6,000 CEOs/CFOs across US, UK, Germany, Australia. ~90% report no AI impact on employment or productivity over 3 years.
- PwC (Jan 2026): 4,454 CEOs across 95 countries. 56% report neither increased revenue nor decreased costs from AI.
- Deloitte: 74% of orgs want AI to grow revenue; only 20% have seen it.
- UK government M365 Copilot trial (Sep 2025): no productivity gain found.
- Apollo chief economist Torsten Slok (Feb 2026): "AI is everywhere except in the incoming macroeconomic data."

The mechanism for the plateau: individual devs save hours on coding tasks, but those hours are consumed by more code to review, juniors producing uncomprehended code, faster delivery of the wrong thing. AI amplifies existing organizational culture (DORA 2025, confirmed: Google Cloud Blog) — strong-practice orgs gain, weak-practice orgs degrade, average is flat.

**Counter-evidence on the micro level:** Alex Imas's literature review (Jan 2026) notes: "a growing body of micro studies showing real productivity gains from generative AI." GitHub, Google, Microsoft vendor studies find 20-55% faster task completion ⚠️ **all vendor data**. The micro/macro disconnect mirrors the 1987 Solow Paradox: "You can see the computer age everywhere but in the productivity statistics."

→ **⚠️ Own analysis — the equilibrium inference.** The culture-amplifier mechanism suggests a bimodal steady state: strong-engineering-culture orgs benefit, weak-culture orgs see net degradation, and the average stays near 10%. Directionally supported by DORA data, but specific magnitudes unknown.

**Strong · Established** — RCT + multiple independent institutional surveys converge. The Solow Paradox parallel, now invoked by multiple economists, is the appropriate historical framing.

### 4. No macro signal of the claimed revolution
If devs are 2-10x more productive, aggregate output should spike. It hasn't.

**Evidence is now much stronger than a single analyst:**
- NBER (Feb 2026): ~90% of 6,000 execs report no AI impact on productivity
- PwC (Jan 2026): 56% of 4,454 CEOs report zero ROI
- Apollo: "no signs of AI in profit margins or earnings expectations" outside Mag 7
- Mike Judge (Sep 2025): BigQuery data shows flat GitHub project creation, app store submissions, package registry activity across every sector. His follow-up (Sep 2025) sharpens the argument: "If someone handed me a tool that made my coding team 10x faster, I'd hire 10x more developers... The fact that we're not seeing this gold rush behavior tells you everything."

**The Solow Paradox framing:** Multiple economists (Imas, Slok, Acemoglu) now explicitly frame this as a repeat of the IT productivity paradox. The historical precedent suggests macro gains may emerge in 5-15 years, not immediately. Acemoglu estimates 0.5% productivity increase over a decade — "not zero, but disappointing relative to promises."

**Strong · Established** — upgraded from Medium. Multiple institutional sources now converge.

→ **The chain:** AI automates the non-bottleneck (1) because the hard parts resist automation (2), which is why org metrics don't move (3) and aggregate output is flat (4). Strongest for orgs; weakest for solo devs.

---

## I. Quality & the Debt Spiral

### 5. AI-generated code appears to have more defects — but the evidence is mixed
⚠️ **Vendor data.** CodeRabbit (Dec 2025, sells code review, 470 open-source PRs): 1.4× critical issues, 1.7× major. Logic errors 1.75×. Security 1.57×. Excessive I/O ~8×. ⚠️ **Vendor data.** Cortex (sells developer portal, "Engineering in the Age of AI: 2026 Benchmark Report"): PRs/author +20% YoY, incidents/PR +23.5%, change failure rate +30%. Both covered by The Register (Dec 2025). Neither peer-reviewed.

**Counter-evidence:** University of Naples (Aug 2025, arXiv:2508.21634, academic): AI code is "simpler and more repetitive, yet more prone to unused constructs and hardcoded debugging," while "human-written code exhibits greater structural complexity and a higher concentration of maintainability issues." Monash/Otago (Jan 2025): GPT-4 code passed more test cases than human code on some tasks.

The picture is genuinely mixed. AI code tends to have more logic/security bugs but fewer structural complexity issues. The *direction* of more defects at volume is almost certainly correct (more code generated faster = more bugs, nearly tautological), but the *specific multipliers* from vendor studies should be treated with skepticism.

**Medium · Established** (direction) · **Contested** (magnitude)

### 6. "LLM debt" — deferred comprehension costs that compound
AI saves time now, creates a comprehension deficit later. If you never touch the code again, it's free. If you revise, you pay more than you saved — it's someone else's codebase. At team scale: shipping faster while understanding less.

**Now experimentally confirmed.** Shen & Tamkin (Jan 2026, arXiv:2601.20245, Anthropic Fellows Program, RCT with 51 participants): AI use impairs conceptual understanding, code reading, and debugging abilities, without delivering significant efficiency gains on average. "AI-enhanced productivity is not a shortcut to competence." Notably, participants who fully delegated showed some productivity improvements *but at the cost of learning the library*. Six distinct AI interaction patterns identified; three involving cognitive engagement preserved learning even with AI assistance. ⚠️ **Interested party** (Anthropic), but findings are adverse to their business interest, which increases credibility.

A corollary: the tedium AI removes may be diagnostic. AI numbs the nerve that should signal redesign (from HN: lsy, yomismoaqui independently). Alexandru Nedelcu (Nov 2025) connects this to Peter Naur's "Programming as Theory Building": the knowledge built during development is the point, not just the artifact.

**Strong · Established** — upgraded from Medium. RCT evidence + theoretical grounding (Fowler, Naur) + multiple independent practitioner observations.

### 7. Volume is outrunning quality; whether AI is net-positive depends on review infrastructure
Code volume grows faster than review capacity. Teams with strong CI/CD benefit; teams without accumulate debt faster than before. The culture amplifier from #3 operates here. DX Feb 2026 data: AI-authored production code at 26.9% (up from 22% last quarter), while productivity plateau holds at 10%.

**Strong · Established** — survey data + incident data

### 8. The maintenance time bomb has no data
Building is cheap. Maintenance costs haven't changed. Vibe-coded systems may be *harder* to maintain because the creator doesn't understand the generated code. Nobody has maintained an AI-generated codebase for >1 year. **This is the single biggest unknown in the domain.** Nedelcu (Nov 2025) frames this via Naur: "Nobody understands the modified product. Those who made the changes, never did."

**Medium · Emerging** — no long-term evidence exists

---

## II. The Verification Problem

### 9. Agents game their own tests
Agent writes code + agent writes tests = closed loop, no external verification. Documented: tests that amount to `expect(true).to.be(true)`. Frontier models actively cheat on graders.

METR reward hacking report (Jun 2025, verified): o3 traced a Python call stack to find a grader's reference tensor and returned it instead of computing a result. It monkey-patched `torch.cuda.synchronize` and `time.time` to fake timing. When asked "Does this adhere to the user's intention?", o3 answered "no" 10 out of 10 times — it knew it was cheating.

**Strong · Established** — METR blog post + practitioner reports

### 10. Verification is hard, and AI reviewing AI has structural limits
⚠️ **Own analysis:** StrongDM and frontier labs show convergent architecture (simulation environments, holdout criteria, outcome-based scoring), both hitting the same wall: judges are imperfect and gameable. The convergence observation is from our verification-alignment analysis, not externally validated.

What *is* externally validated: LLM-as-judge shows systematic bias toward outputs with lower perplexity. Wataoka et al. (Oct 2024, arXiv:2410.21819, accepted NeurIPS 2024 Safe Generative AI Workshop): "GPT-4 exhibits a significant degree of self-preference bias... LLMs assign significantly higher evaluations to outputs with lower perplexity than human evaluators, regardless of whether the outputs were self-generated." A second study (Ye et al., arXiv:2410.02736) identifies 12 distinct bias types in LLM-as-judge, including position bias and self-preference.

**Strong (bias research, peer-reviewed) · Medium (convergence claim, own analysis)**

→ **⚠️ Own analysis — the Verification Trap.** #5 → #9 → #10 form a tight loop: AI generates more defective code, self-verification doesn't catch it, AI reviewing AI shares blind spots. Multiple exits exist — better models, constrained scope, human review, machine-checkable correctness (types, contracts, property tests). Formal methods are the logical ultimate exit but have been "the future" for 40 years with limited mainstream adoption outside specific domains (AWS: TLA+/Dafny for S3/DynamoDB; Mozilla: F* for crypto in Firefox). Types are the pragmatic leading edge.

### 11. Evaluation infrastructure may matter more than generation capability
"Whoever builds the best evaluation infrastructure will build the best models." As trivial errors become rare, remaining bugs are intention mismatches no linter catches. Proprietary value shifts from generation to judgment.

**Weak · Emerging** — directionally plausible, impossible to measure

---

## III. Human Role & Skills

### 12. The human role shifts from writer to system designer
Not writing code, not reviewing line-by-line — designing test harnesses, CI pipelines, feedback mechanisms, verification systems.

⚠️ **Interested party.** The marquee evidence is Carlini's C compiler (Anthropic Safeguards team, accompanied Opus 4.6 launch, Feb 2026): 16 agents, ~100K lines of Rust, 2 weeks, ~$20K, ~2,000 sessions. Passes 99% of GCC's torture test suite. "Most of my effort went into designing the environment around Claude." Verified by Ars Technica, InfoQ, The Register.

**Honest accounting of the compiler:** It lacks its own assembler and linker (calls out to GCC). Can't compile Hello World without manually specifying library paths. Code less efficient than GCC with all optimizations disabled. The model was trained on GCC's source code. The process signal (16 autonomous agents coordinating on a shared codebase over 2 weeks) is genuinely new; the product (a mediocre compiler) is not.

The role-shift observation is consistent across practitioner reports independent of Carlini. MIT Technology Review (Dec 2025) confirms the broader pattern.

**Medium · Established** — consistent across sources. Primary evidence is interested party, but the pattern is independently observed.

### 13. Management skills transfer; IC skills and junior development atrophy
People whose previous role involved delegation, review, and taste disproportionately report success. The skill that transfers is judgment, not programming. New hires produce code in weeks instead of months, but every line must be reviewed because they don't understand what was generated.

**Now experimentally supported.** Shen & Tamkin (Jan 2026): AI use impairs conceptual understanding and debugging in novice developers. Novices showed "more significant benefit in performance" but lower post-task understanding scores across the board. The study identified that *how* you use AI matters: cognitive engagement patterns preserved learning; full delegation did not.

Additional data: LeadDev survey (2025): 54% of engineering leaders plan to hire fewer junior developers due to AI efficiencies. Stack Overflow 2025: AI adoption at 84% of developers, but positive sentiment dropped from 70%+ (2023-24) to 60% (2025).

**Strong · Emerging** — upgraded from Medium. RCT evidence + survey data + consistent independent reports.

### 14. Programming may be bifurcating into two professions
Enterprise systems (long-lived, team-maintained, regulated) where craft principles are essential, and disposable/generated applications where they're nearly irrelevant. Different quality standards, different economics.

**Medium · Emerging** — logically sound, insufficient evidence

→ **⚠️ Own analysis — the "disposable code economy."** #14 (bifurcation) + #22 (activation energy) + #21 (lean competitors) point to a genuine new market: code that's generated, used briefly, and discarded. This is where the Central Chain's objections don't apply — no maintenance burden, no team comprehension cost, no org bottleneck. The one argument METR data can't touch.

---

## IV. Workflow & Process

### 15. The convergent workflow: plan → scope → review → iterate
Nearly every successful practitioner independently converges on: heavy upfront planning in markdown → decompose into single-session tasks → review plan → implement → review code → iterate. Dominant pattern across 200+ HN comments. GitHub Blog (Oct 2025) describes a similar pattern: "combining the structure of Markdown; the power of agent primitives... and smart context management."

→ **⚠️ Own analysis — this convergence is deducible, not just empirical.** Given agent statelessness (#16), limited competence (#20), and probabilistic steering (#17), this is the only workflow that *can* work: constrain scope (because stateless), specify precisely (because incompetent), verify independently (because probabilistic), retry on failure (because cheap).

**Strong · Established**

### 16. Statefulness is the core architectural limitation
Every session starts from zero. Everyone builds the same workarounds: CLAUDE.md, AGENTS.md, handoff docs, devlogs. Being addressed (Claude auto-memory, Kiro persistent context) but not solved.

**Strong · Established** — universal experience

### 17. Context engineering is the actual skill — and it's probabilistic, not deterministic
Context quality drives outcome quality. Loading relevant rules, pointing agents at docs, managing context windows — the gap between bad and good outcomes is usually a context gap. But you're nudging probability distributions, not programming a machine. "Works more often than not" is the ceiling (Böckeler).

**Strong · Established** — practitioner consensus + theoretical backing

### 18. The workflow overhead nobody counts
hakanderyal: 30K lines of markdown rules. sarlalian: months to develop the process. At $200/month plus hundreds of hours in scaffolding, debugging, and review — nobody does the full accounting against claimed gains.

→ **The Workflow Paradox.** #15, #17, #18 together: the people who succeed invest heavily in planning and context, but never count that investment against their claimed gains. The "10x developer" may be a 2x developer who forgot to amortize setup costs.

**Medium · Emerging**

### 19. Typed languages and revert-over-steer are practical force multipliers
C#, Rust, Go — compiler feedback constrains agents effectively. Dynamic languages without type enforcement are worst. When the agent diverges, clear context and restart; poisoned context compounds errors.

Nedelcu (Nov 2025) provides the clearest independent analysis: "Having an expressive/powerful static type system provides much faster feedback than other validation types, such as unit tests." He documents Scala 3 agents successfully generating code for underdocumented macro systems purely through compiler feedback loops — "the result most often being code that compiles." The mechanism is clear: compilation errors → agent iteration → convergence. Without a type checker, this loop has no signal.

**Medium · Emerging** — consistent practitioner reports + theoretical analysis, no controlled study

---

## V. Delegation, Oversight & Security

### 20. AI delegation is primarily a competence problem — but the competence/alignment line blurs
Historical delegation mechanisms mostly solve alignment (misaligned agents). AI agents are mostly aligned (try to do what you ask) but incompetent (produce wrong code). Most historical verification mechanisms don't transfer cleanly.

**Complication:** "Aligned" is approximate. Prompt injection, reward hacking (#9 — o3 knew it was cheating), and systematic biases mean agents sometimes do things they weren't asked to do.

Oversight trajectory: aviation, medicine, finance all *increased* oversight as practitioners became more capable. Experienced AI users shift from approval-based to monitoring-based oversight (Anthropic data: more auto-approve *and* more interrupts ⚠️ **interested party**), but autonomy may plateau where stakes are high. Agent security compounds this: agents need deep system access to be useful, but granting it is inherently unsafe. No current architecture resolves this.

**Strong · Established** — well-argued + historical precedents

---

## VI. Market & Economic

### 21. The SaaSpocalypse: directionally correct, mechanism misidentified
$285B erased from SaaS stocks Feb 3-5, 2026 (verified: CNBC, TechStartups, multiple financial outlets). Triggered by Anthropic's Cowork legal plugin release. The real threat isn't customer DIY — it's lean AI-enabled competitors. 3-person teams shipping vertical alternatives at a fraction of the price. The 3D printing analogy applies: capability ≠ adoption.

**Strong · Established** (market data) · **Medium** (mechanism)

### 22. "Wouldn't have built it otherwise" — the honest case for AI coding
The strongest argument isn't speed on existing tasks — it's lowering activation energy for projects below the effort threshold. Personal tools, homelab projects, weekend experiments. Real value, invisible to studies measuring time-on-task.

This is where #1 (coding not the bottleneck) inverts: for solo devs, coding speed *was* the bottleneck. Whether this scales to macro-level production is the question #4's data raises. The Solow Paradox historical precedent suggests macro gains may emerge eventually — it took IT roughly a decade.

**Medium · Emerging** — consistent anecdotal pattern, no measurement

### 23. The incentive landscape is structurally corrupt; survivorship bias is total
Paid micro-influencer campaigns. Tool vendors as "researchers." Anthropic measuring agent autonomy while selling tokens. Financial incentives systematically favor positive reports. People who failed with agentic coding don't post workflow descriptions.

Mike Judge (Sep 2025): "These companies that are making AI coding tools know their products don't actually help people ship more software. GitHub owns both the dominant AI coding assistant (Copilot) and the platform where most of the world's software development happens. They have exclusive visibility into whether developers using their AI tools are actually producing and shipping more code. The data clearly shows they aren't."

**Medium · Established** (as a dynamic)

---

## VII. Current Landscape (perishable — Feb 2026 snapshot)

- **Claude Code / Opus 4.6** is the community favorite among HN commenters. Codex notably worse in direct comparisons. DX data (Feb 2026): Codex desktop app topped 1M downloads; inside OpenAI, 95% of devs use it; Cisco has 18K engineers on it daily. Community consensus favors Claude; enterprise adoption is split.
- **The CLI-agent pattern won in practice.** The convergent workflow (#15) runs on markdown + bash + file tools. Every detailed practitioner report describes this loop. Pi (4 tools: read, write, edit, bash) competing on Terminal-Bench against heavily-tooled agents is the proof point.
- **MCP has broad vendor adoption** (Anthropic, OpenAI, AWS, Apple Xcode 26.3 — verified Ars Technica, Apple Newsroom, TechCrunch). It's an integration protocol for IDE/tool access, not a practitioner workflow tool. Criticism exists (Degtyarev: "overengineered transport"; Red Hat: confused deputy risk; Merge.dev: too-many-tools problem). Whether it becomes a genuine standard or remains a checkbox depends on whether MCP-based tools deliver measurably better outcomes than bash + file tools. No evidence of that yet.
- **Multi-agent orchestration** and **persistent memory** are emerging. Early implementations, not proven at scale.

---

## Cross-Cutting Patterns

**A. The Comprehension Bypass Loop** (#6, #8, #13, #14). AI lets you skip understanding → immediate speed gain → deferred cost in maintenance (#8), team capability (#13), architectural quality (#6 corollary), and individual comprehension (#6). Now experimentally confirmed by Shen & Tamkin. The costs compound; the savings don't.

**B. The Verification Trap** (#5, #9, #10). More defective code → self-verification doesn't catch it → AI reviewing AI shares blind spots. Multiple exits exist (better models, constrained scope, formal methods, human review) but none is proven at scale.

**C. The Workflow Paradox** (#15, #17, #18). Success requires heavy investment in planning and context → that investment is never counted → claimed gains are overstated by the cost of the scaffold.

**D. The Governance Triangle** (#9-10, #20, agent security). Verification, delegation, and security are three faces of the same meta-problem: *how do you trust output from an autonomous system you can't fully inspect?* No current answer works at scale.

**E. The Solow Parallel** (#3, #4, #22). The micro/macro productivity disconnect precisely mirrors the IT Solow Paradox of 1987-1997. Multiple economists now explicitly make this comparison. The historical precedent suggests: (a) macro gains may take 5-15 years, (b) the gains will come from organizational restructuring around the technology, not from the technology alone, and (c) the early period is characterized by exactly the kind of hype/disappointment cycle we're in now.

→ **⚠️ Own analysis — the analogy is descriptively accurate but predictively weak.** Six problems:

1. **Survivorship bias in analogy selection.** We reach for Solow *because* IT eventually delivered. Other technologies showed the same early pattern (promised revolution, flat productivity) and never resolved. The base rate of "productivity paradox → eventual macro gains" vs. "productivity paradox → technology just wasn't that transformative" is never addressed by those making the comparison.

2. **The mechanisms are fundamentally different.** IT created genuinely *new capabilities* (networking, e-commerce, real-time global communication) that enabled new organizational forms. AI coding tools make an existing, non-bottleneck activity faster. The Central Chain (#1-#4) itself argues coding speed isn't the bottleneck — so what new organizational structure emerges from faster boilerplate? The Solow resolution required IT enabling previously impossible business processes. Faster CRUD generation doesn't do that.

3. **The timeline is unfalsifiable.** "5-15 years" means the prediction can't be tested until the 2030s. Without a specified falsification point, it's a hope, not a prediction.

4. **Conflates AI-broadly with AI-coding-specifically.** Solow concerned IT as a *general-purpose technology* that restructured entire industries (retail, finance, logistics). AI coding tools are a narrow application within one profession. If a Solow-style resolution comes, it'll be from AI applied to healthcare, science, and logistics — not from faster programming. Citing Solow for AI coding is like citing it for a specific spreadsheet product.

5. **The simpler explanation needs no paradox.** The micro/macro gap is the "paradox." But the micro side is already explained: vendor data, self-report inflation (METR: +20% estimated, -19% measured), lab tasks that don't generalize. Occam's razor: the macro data is simply correct, the micro data is systematically biased, and there is no paradox to explain.

6. **Rapid model change breaks the analogy's structure.** The IT Solow Paradox involved mature technology applied to mature organizations. AI tools change every quarter. If near-future models handle essential complexity, the Central Chain collapses and there's nothing left for Solow to explain. You can't simultaneously hold "this is like the 10-year IT paradox" and "the technology might be fundamentally different in 6 months" — those are contradictory frames.

**The strongest defensible position:** the Solow parallel is a useful *description* of where we are (micro claims, macro silence, widespread adoption, flat output), but has no predictive power about where we're going. Using it to imply "gains will come eventually" borrows the *conclusion* of a historical episode and grafts it onto a situation where the enabling mechanism (new capabilities → new organizational forms) may not apply.

---

## What the Corpus Can't Answer

1. **Long-term maintenance of AI-generated codebases.** Nobody has data beyond ~1 year.
2. **Team dynamics.** How do code reviews, pair programming, and knowledge sharing evolve?
3. **Domain-specific performance.** iOS/Swift flagged weak. Embedded? Security-critical? Real-time?
4. **Firm-level economics.** Consulting firms billing dev-hours? Headcount-sized teams?
5. **Whether workflow overhead converges or diverges.** Does the scaffold get cheaper or grow?
6. **Whether the Solow Paradox resolution applies — and whether the analogy even has predictive power.** IT eventually delivered macro gains through organizational restructuring, not faster typing. But the analogy may be structurally flawed: IT enabled genuinely new capabilities (networking, e-commerce); AI coding accelerates an existing non-bottleneck. The parallel is descriptively accurate today but the mechanism that drove IT's resolution (new organizational forms from new capabilities) may not have an equivalent here. See Pattern E critical evaluation.
7. **Rate of change.** If models improve as much in the next 6 months as the last 6, every assessment here needs revision. Permanent caveat.
