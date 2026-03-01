← [Agent Skills: Emerging Winners](agent-skills-emerging-winners.md) · [Agent Skills: Category Landscape](agent-skills-landscape-categories-winners.md) · [Harness Engineering](harness-engineering-insights-and-practices.md) · [Insights](../insights.md) · [Index](../README.md)

# Skills: Deep Synthesis — When, Why, For Who, How, ROI

*February 28, 2026*

*This is not a skill shopping list. This is a structural analysis of when skills create durable value, when they're waste, and why — grounded in the full research corpus. The goal: a decision framework you can apply to any skill, present or future.*

---

## I. The Durability Filter: Most Skills Are Transitional

Before asking "which skills to build," ask "which skills *survive*?"

The [agent-skills architecture analysis](agent-skills.md) established a four-category durability taxonomy:

| What the skill encodes | Durable? | Example | Half-life |
|---|---|---|---|
| Public tool syntax | **No** | `gh pr checks 55`, basic git | Already in training data |
| Popular agent-tool patterns | **No** | Agent-browser refs, tmux sockets | 1-2 training cycles (~6-12 months) |
| Private/internal tool interfaces | **Yes** | Company CLIs, deploy scripts, internal APIs | Permanent (can't leak) |
| Personal conventions & editorial judgment | **Yes** | Commit format, analysis guidelines, verification rituals | Permanent (subjective choices) |

A fifth category emerged from the landscape research:

| Training-data-staleness patches | **Temporarily** | Live API docs, new framework patterns | Until next training cutoff |

**The uncomfortable implication:** Most skills on skills.sh (57,000+) are in categories 1-2. They teach agents things the next model will know natively. The 112 battle-tested production bug skills from sstklen? Category 2 — Hypothesis will find these patterns in training data within a year. The Playwright CLI skill? Category 1 — Opus 4.6 probably already knows most of it.

**But durability ≠ value.** Transitional skills can be high-value right now — they're just not investments. A training-data-staleness patch that saves you 10 minutes today is worth using even if the next model obsoletes it. The durability filter matters for deciding what to *build and maintain*, not what to *use*. Use community skills for immediate value, build personal skills for durable value, and don't confuse the two decisions.

**What survives permanently:** Skills that encode *your* decisions, *your* team's knowledge, *your* verification rituals, *your* editorial standards. Not knowledge that could be Googled — judgment that can't.

This is the [Skill Author Competence Paradox](../insights.md#skill-author-competence-paradox) applied to durability: the skills that survive are the ones only *you* can write, because they encode context only you hold. Which means the most durable skills are also the hardest to outsource or download.

---

## II. The Five Structural Skill Archetypes

Not all skills work the same way. Connecting the evidence across harness engineering, insights, and practitioner reports, five archetypes emerge — each with different value mechanisms, ROI profiles, and audiences.

### Archetype 1: The Verification Gauntlet
*Forces the agent through mechanical checks after every change.*

**Mechanism:** Creates the [Broken Abstraction Contract](../insights.md#broken-abstraction-contract)'s missing contract. The LLM can't provide determinism, stability, or testability — so the gauntlet wraps it in external checks that create those properties.

**Evidence strength:** Consensus-level. LangChain +13.7 pts. Stripe's 1000+ merged PRs/week. Every serious harness engineering source confirms. The [hierarchy of leverage](harness-engineering-insights-and-practices.md) ranks it #1.

**Examples:**
- PostToolUse hooks: `ruff check` + `pyright` + `pytest -x` after every file write
- Pre-commit gates: AST-based banned-API detection (the HN practitioner who replaced an AGENTS.md rule with a TypeScript compiler check)
- Architectural constraint tests: `test_no_backward_imports()` — a 20-line pytest that enforces layered dependencies

**Who benefits:**
- **Solo devs writing production code** — highest ROI. You're the only reviewer; mechanical verification substitutes for the review you'd skip.
- **Teams with CI** — moderate ROI. The gauntlet augments existing CI by catching errors *during* the agent session, not after the PR.
- **Research/notes users** — low ROI. No code to verify.

**ROI calculation:**
- **Investment:** 30 minutes to 2 hours of one-time setup (hooks, linter config, architectural test)
- **Return:** Every agent session benefits. Prevents the #1 harness failure mode: "agent wrote solution, re-read own code, confirmed it looks ok, stopped." Based on LangChain data, this is worth ~13 percentage points of task success rate.
- **Compounding:** The gauntlet improves with each rule added. Each production bug becomes a new lint rule. Ratchet effect.
- **Durability:** **Permanent.** Good engineering regardless of AI. If the AI bubble pops, you still have a linted, type-checked, architecturally-tested codebase. This is the [harness engineering meta-insight](harness-engineering-insights-and-practices.md#vii-the-meta-insight): these were best practices before LLMs existed.

**When NOT to build:** Throwaway scripts, exploration, prototyping. The [Exploration Phase Mismatch](../insights.md#exploration-phase-mismatch) applies: front-loaded correctness is wasted on disposable experiments.

### Archetype 2: The Compounding Loop
*Makes each session better than the last.*

**Mechanism:** Exploits [Workflow as Tribal Knowledge](../insights.md#workflow-as-tribal-knowledge) constructively. Instead of letting implicit process knowledge accumulate and die with the session, the skill *externalizes* it — promoting learnings to the right memory tier, catching recurring mistakes, building rules for itself.

**Evidence strength:** Strong practitioner signal, no controlled studies. The `wrap-up` skill is the canonical example (4-phase: Ship → Remember → Review & Apply → Publish). Reddit testimonials are specific and consistent. Block's 100+ internal skills are a scaled version of this pattern.

**Examples:**
- Session wrap-up: auto-commit, review what was learned, categorize as skill gap / friction / knowledge / automation, update CLAUDE.md or rules files, identify publishable content
- Continuous learning agent: logs errors to markdown, promotes recurring patterns to project memory
- Bug pattern libraries (the 112-skill collection): each production incident becomes a permanent pattern trigger

**Who benefits:**
- **Daily practitioners** — highest ROI. The compounding effect requires frequency. If you code with your agent 5 days/week, each session improves the next. After a month, the accumulated memory is substantial.
- **Solo devs** — high ROI. All the tribal knowledge is in one head anyway, and the skill prevents the [Workflow as Tribal Knowledge](../insights.md#workflow-as-tribal-knowledge) scaling trap by externalizing it before it's lost.
- **Teams** — moderate ROI, but requires deliberate shared memory architecture. Block's marketplace works because 100+ skills are the *team's* tribal knowledge, not one person's.
- **Infrequent users** — low ROI. Compounding requires frequency. Monthly sessions don't compound.

**ROI calculation:**
- **Investment:** 2-4 hours to design and build a session wrap-up skill. Ongoing: zero (it runs automatically).
- **Return:** Practitioners report "changed everything" — but this is the [Hidden Denominator](../insights.md#hidden-denominator) at work. The people reporting 10x gains have the largest uncounted investment in exactly these process skills. Realistic estimate: 5-15% reduction in recurring friction per month, compounding. After 3 months, the accumulated rules catch the mistakes you used to make weekly.
- **Accumulation:** The mechanism is sediment, not compound interest. Each session deposits a thin layer. Early layers are thick and transformative (the first 10 rules catch the most common friction). Later layers are thinner — diminishing returns as each subsequent rule addresses rarer cases. The curve is logarithmic, not exponential. And unlike compound interest, accumulated rules can compound *errors*: a wrong lesson captured in session 5 persists and influences sessions 6-50. [Approval Fatigue](../additional_insights.md#approval-fatigue) predicts the human will rubber-stamp the 30th wrap-up summary less carefully than the first, making contamination more likely over time. Periodic excavation — reviewing accumulated rules, discarding what's stale, correcting what's wrong — is essential. The "Review & Apply" phase isn't just load-bearing, it's the excavation.
- **Context budget ceiling:** Accumulated rules carry a token cost. At 50-100 tokens per rule × 100 accumulated rules = 5,000-10,000 tokens of always-loaded context. The [ETH Zurich result](harness-engineering-insights-and-practices.md) (-3% from generated context) applies here: there's a crossover point where accumulated rules cost more in context degradation than they save in error prevention. Nobody has measured where this ceiling is. The compounding loop doesn't just accumulate value — it accumulates context tax.
- **Durability:** **Permanent for the mechanism, temporary for the content.** The *habit* of externalizing session learnings is durable regardless of tooling changes. The *specific rules* accumulated may become obsolete as models improve (the [temporal harness practices](harness-engineering-insights-and-practices.md#the-temporal-structure-of-harness-practices) classification applies). But the loop itself — learn → externalize → apply — is good practice with or without AI.

**The critical design constraint:** [Steering ∝ Theory](../insights.md#steering-theory) warns that full delegation degrades understanding. A wrap-up skill that *only* automates (commit, update, move on) could accelerate the [Shen & Tamkin comprehension loss](../insights.md#naurs-nightmare). The "Review & Apply" phase must include genuine cognitive engagement — the human reads the skill's self-assessment and decides whether to accept. Without that, you're compounding automation, not compounding learning.

**When NOT to build:** If you don't code with an agent regularly. The compounding requires deposit frequency.

### Archetype 3: The Specification Scaffold
*Structures the human's intent into machine-verifiable form.*

**Mechanism:** Implements the [Specification Sandwich](maximum-leverage-brainstorm.md) — the human writes types + contracts + properties, the agent implements against them. The spec IS the [theory](../insights.md#naurs-nightmare) that survives the implementation. Connected to the #4 slot in the [leverage hierarchy](harness-engineering-insights-and-practices.md): "Write specifications, not just instructions."

**Evidence strength:** The JUXT Allium case (3K spec → 5.5K Kotlin, distributed BFT system) is the strongest single data point. SDD has gone mainstream in 2-3 weeks (dbreunig, O'Reilly, New Stack, Augment Code). But [the critical review](harness-leverage-critical-review-feb28-2026.md) warns: the JUXT case involved a deep expert, not a generalizable methodology. The cargo-culting risk is real — "write a spec" is being conflated with "write executable, verifiable specifications."

**Examples:**
- Skill that prompts you to write a typed Protocol + deal contracts before implementation starts
- Skill that has the agent propose Hypothesis properties for human review before coding
- Skill that sets up differential oracles (slow-but-correct reference implementation)

**Who benefits:**
- **Experienced devs building production systems** — highest ROI. You have the domain knowledge to write meaningful specs. The agent handles the tedious implementation. Your time shifts from writing code to specifying intent — which is where [Steering ∝ Theory](../insights.md#steering-theory) says the value lives.
- **Teams with shared codebases** — high ROI. The spec persists as documentation. Addresses [Naur's Nightmare](../insights.md#naurs-nightmare) directly: the next developer can read the spec to understand *why* the system is shaped as it is.
- **Junior devs** — **negative ROI.** The [Anthropic comprehension study](harness-leverage-critical-review-feb28-2026.md) (17% lower understanding with AI) confirms: if you skip the implementation step, you don't build the understanding needed to write good specs. Juniors need to write code *and* specs.
- **Non-developers** — low ROI. Writing good specs requires domain + engineering knowledge. The [Skill Author Competence Paradox](../insights.md#skill-author-competence-paradox) applies: the person who needs the spec scaffold most can't use it effectively.

**ROI calculation:**
- **Investment:** 15-30 minutes per module to write the spec. Zero per agent iteration.
- **Return:** The [JUXT ratio](harness-engineering-insights-and-practices.md) was ~2 lines of working code per line of spec. The spec work IS the engineering; the code generation is the implementation detail. For complex systems where the implementation would take hours, the ROI is 5-10x.
- **Compounding:** Moderate. Each spec improves the codebase's verifiability permanently. But specs don't self-improve — each new module requires fresh specification effort.
- **Durability:** **Potentially permanent.** The [critical review](harness-leverage-critical-review-feb28-2026.md) classifies this as "unknown shelf life" — it may be superseded by models that can extract intent from examples, or it may be the permanent equilibrium because specification IS the engineering. The strong hypothesis: as long as [essential complexity](../insights.md#brooks-naur-vindication) exists (always), someone must specify it. Whether that's a typed Protocol or a future spec format, the role survives.

**When NOT to build:** Throwaway scripts, exploration, CRUD. If the problem is well-understood and the implementation is standard, spec overhead exceeds value.

### Archetype 4: The Behavioral Constitution
*Tells the agent what NOT to do.*

**Mechanism:** Counters the LLM's default sycophancy and eagerness to please. Block's principle: "LLMs are people pleasers by nature. They want to soften bad news, add caveats." Constitutional rules channel helpfulness into something reliable. This maps directly to [Steering ∝ Theory](../insights.md#steering-theory): the constitution IS the steering, encoded once and applied every session.

**Evidence strength:** Block's engineering blog (3 design principles) is the best published design framework. Tessl's quantitative scoring shows `receiving-code-review` (anti-sycophancy) at 79% vs `requesting-code-review` at 71%. The `commit` skill is the simplest example — "Only commit; do NOT push" prevents a destructive default.

**Examples:**
- Engineering methodology: "Never skip the planning phase. Never declare a task complete without re-reading the original spec. Never modify files in specs/."
- Code review reception: "Push back with technical reasoning when a suggestion is wrong. Do not implement every suggestion uncritically."
- Output formatting: "Never add caveats. Never soften results. Never override deterministic scores."
- Commit discipline: "Do not push. Do not add sign-offs. Ask about ambiguous files."

**Who benefits:**
- **Everyone who uses an agent for anything repeatable** — universal benefit. Constitutions are the cheapest skill to write and the most portable across projects.
- **Teams** — especially high ROI. The constitution encodes team conventions once. Every agent session enforces them without the team needing to review for style compliance.
- **Research/writing users** — applicable beyond code. "Do not use em-dashes. Do not add disclaimers. Do not summarize away detail." Editorial constitutions are underexplored.

**ROI calculation:**
- **Investment:** 15-60 minutes to write. Often < 50 lines.
- **Return:** Prevents the most common agent failure mode: doing something helpful that breaks your workflow. Each prevented mistake saves 5-30 minutes of manual correction.
- **Compounding:** Indirect. The constitution doesn't improve itself, but it prevents the need for the same correction repeatedly. Combined with a compounding loop (Archetype 2), mistakes caught by the constitution can generate new constitutional rules.
- **Durability:** **High for personal conventions, temporal for model-compensating rules.** "Use conventional commits" is permanent — it's your choice, not model limitation. "Never use Node APIs where Bun APIs exist" is temporal — future models may learn this from training data. But as the HN practitioner discovered, this rule is better as a linter anyway (Archetype 1).

**The design insight:** The best constitutions contain exactly two types of statements: (1) decisions that *resolve ambiguity* the model can't infer from code ("Use SerializerV2 for new features"), and (2) constraints that *prevent known failure modes* ("Never override scores"). Everything else is overhead per [ETH Zurich](harness-engineering-insights-and-practices.md) (-3% from generated context files).

**When NOT to build:** When you're still exploring what conventions you want. Premature constitutions lock in decisions you haven't validated.

### Archetype 5: The Tribal Knowledge Codifier
*Converts unwritten organizational knowledge into agent-executable form.*

**Mechanism:** Addresses the [Workflow as Tribal Knowledge](../insights.md#workflow-as-tribal-knowledge) problem directly. Block: "Documentation goes from something you read to something your agent can execute. A runbook becomes a workflow. A style guide becomes an enforcer. An onboarding guide becomes an interactive tutor."

**Evidence strength:** Block's 100+ internal skills is the strongest signal. The sstklen 112-bug-pattern collection is a solo-dev version. The concept is the logical extension of the [Hidden Denominator](../insights.md#hidden-denominator): power users amortize their tribal knowledge across every session.

**Examples:**
- Oncall runbook skill: which dashboards to check, which logs, how to escalate — specific to your team's infrastructure
- Deployment convention skill: your team's exact feature flag experiment setup process
- Bug pattern library: "When you see a Hono sub-router sharing paths, check auth isolation — we've had 3 production incidents from this"
- Onboarding skill: walks new agents (and new team members via agent) through the repo's architecture

**Who benefits:**
- **Teams with accumulated process knowledge** — highest ROI. The ROI is proportional to how much tribal knowledge exists and how often it's needed. A team with 5 years of accumulated deployment conventions gets enormous value from codifying them.
- **Solo devs with complex personal workflows** — high ROI. You're the only person who knows your deployment pipeline, your testing conventions, your project structure decisions.
- **New projects without history** — zero ROI. No tribal knowledge to codify yet.

**ROI calculation:**
- **Investment:** 1-4 hours per runbook/convention codified. Requires the domain expert's time — the [Competence Paradox](../insights.md#skill-author-competence-paradox) means only the person who holds the knowledge can codify it.
- **Return:** Each codified runbook saves 15-60 minutes every time it's needed. Oncall runbook used 3x/month = 45-180 minutes saved/month. Deployment convention used daily = hours saved/week. The math gets dramatic fast for frequently-used knowledge.
- **Compounding:** Moderate. Each production incident can generate a new pattern. Bug pattern libraries grow organically. But it requires active maintenance — stale tribal knowledge is worse than no knowledge.
- **Durability:** **Permanent by construction.** Private knowledge can't be absorbed into training data. Your team's deploy pipeline, your oncall runbook, your POS crash investigation patterns — these are inherently local. This is the most durable archetype because it encodes what only you know.

**When NOT to build:** When the knowledge isn't stable yet (team still figuring out conventions), or when the knowledge is generic enough that the model already knows it.

### Delivery Mechanism Fit: Not Everything Is a Skill

The five archetypes describe *engineering practices*, not SKILL.md files. The skill format (progressive disclosure, on-demand loading, conditional activation) is well-suited to some archetypes and wrong for others:

| Archetype | Best delivery mechanism | Why |
|---|---|---|
| Verification Gauntlet | **Hooks + linter/test config** | Must run unconditionally on every change; depending on skill loading defeats the purpose |
| Compounding Loop | **Skill** | Conditional (triggered at session end), periodic, benefits from on-demand loading |
| Specification Scaffold | **Project template + AGENTS.md** | One-time setup per project, not session-conditional |
| Behavioral Constitution | **AGENTS.md rules or always-loaded config** | Must be active every session; conditional loading creates gaps |
| Tribal Knowledge Codifier | **Skill or structured documentation** | Benefits from on-demand loading when the specific domain surfaces |

Only Archetypes 2 and 5 are genuinely well-suited to the skill format. The gauntlet is hooks and CI. The constitution is always-loaded rules. The spec scaffold is a project template. Packaging them as skills conflates the *practice* (what creates value) with the *format* (how it's delivered). The value is in the practice. Use whatever delivery mechanism makes the practice most reliable.

---

## III. The ROI Matrix: Combining Archetypes

The archetypes aren't mutually exclusive. They stack. The highest-leverage setup combines them:

```
                    Archetype stacking (cumulative value)

                    ┌─────────────────────────────────┐
                    │  5. Tribal Knowledge Codifier    │ ← your team's specific knowledge
                    │     (permanent, high investment) │
                    ├─────────────────────────────────┤
                    │  3. Specification Scaffold       │ ← for complex/critical modules
                    │     (permanent?, medium invest)  │
                    ├─────────────────────────────────┤
                    │  2. Compounding Loop             │ ← session hygiene, self-improvement
                    │     (permanent mechanism, low $) │
                    ├─────────────────────────────────┤
                    │  4. Behavioral Constitution      │ ← what NOT to do
                    │     (high durability, trivial $) │
                    ├─────────────────────────────────┤
                    │  1. Verification Gauntlet        │ ← mechanical checks
                    │     (permanent, low investment)  │
                    └─────────────────────────────────┘
```

**Build bottom-up.** The gauntlet is the foundation — everything else is less valuable without it because unverified output from any archetype is unreliable. The constitution is next (cheap, universal). The compounding loop requires both to be in place (what's it learning from if there's no verification signal?). Specs are for when you're building something complex enough to warrant them. Tribal knowledge is for when you've accumulated enough to codify.

**The estimated investment for a solo dev:**

| Layer | Setup time | Ongoing maintenance | When it pays back |
|---|---|---|---|
| Verification gauntlet | 1-2 hours | Low — update when toolchain changes | First session |
| Behavioral constitution | 30 min | 5 min/week (tweaks) | First session |
| Compounding loop | 2-4 hours | Periodic excavation of stale rules | After 2-3 weeks |
| Spec scaffold | 30 min/module | Zero per iteration | Complex projects only |
| Tribal knowledge | 1-4 hours/runbook | Active — stale knowledge is worse than none | First time the runbook fires |

**Estimated initial investment: ~6-12 hours for a complete stack.** These are estimates, not measurements — no empirical ROI data exists for any skill archetype. The [Hidden Denominator](../insights.md#hidden-denominator) applies to this table too: the 6-12 hours doesn't include learning time (understanding linting, type checking, property testing), debugging time (getting the hooks right), or the prerequisite knowledge that makes the setup possible. The actual cost includes an unknown amount of prior investment that's itself a hidden denominator. Be as skeptical of these numbers as of anyone else's.

Skills are also maintenance commitments, not one-time investments. Every skill is a promise to keep it current. A skill encoding permanent knowledge in a format that changes every 6 months has the same practical half-life as a transitional skill. The "ongoing maintenance" column is where the real cost hides.

---

## IV. The Anti-Patterns: Skills That Destroy Value

Not all skills help. Some actively harm. The research identifies three failure modes:

### Anti-Pattern 1: The Competence Illusion
**What:** Installing a general-purpose "security review" or "architecture audit" skill from an unknown author on skills.sh.

**Why it fails:** The [Skill Author Competence Paradox](../insights.md#skill-author-competence-paradox). The skill produces confident, professional-looking output that's wrong. The person who needs the skill can't evaluate whether it works. The person who can evaluate it didn't need it.

**The deeper problem:** [Cognition ≠ Decision](../insights.md#cognition-not-decision). The skill's output looks like an expert assessment but is actually a probability-weighted average of all security discussions in the training data. The user treats cognition as decision. The failure is silent.

**When it's safe:** When you have the domain expertise to evaluate the output yourself. At that point the skill is a *checklist*, not an oracle — it reminds you to check things you know how to check. That's legitimate. The danger is when the skill replaces expertise you don't have.

### Anti-Pattern 2: The Context Tax
**What:** Installing 15+ skills that inject descriptions into the system prompt, expanding it by 1500+ tokens of skill descriptions the agent rarely uses.

**Why it fails:** [ETH Zurich](harness-engineering-insights-and-practices.md): LLM-generated context files reduced success rates by ~3% and increased cost by 20%+. More tools = more decision space = more misrouting = fewer tokens for actual work. Vercel improved by *removing* 80% of tools.

**The math:** At ~50-100 tokens per skill description × 15 skills = 750-1500 tokens of system prompt overhead. At current Opus 4.6 pricing, that's ~$0.02-0.04 per turn. Over a 50-turn session, $1-2 per session. Trivial in dollar cost — but the context window cost is what matters. Each skill description competes for attention with the actual task.

**The [Skill Loading Illusion](../additional_insights.md#skill-loading-illusion):** Models can't reliably decide when to load a skill. You end up with hooks forcing evaluation at session start, which defeats the "progressive disclosure" promise.

**When it's safe:** When you have ≤7-8 well-chosen skills with non-overlapping descriptions. Your current setup (7 skills) is near the sweet spot.

### Anti-Pattern 3: The Delegation Spiral
**What:** Skills that maximize automation and minimize cognitive engagement.

**Why it fails:** [Steering ∝ Theory](../insights.md#steering-theory) and [Shen & Tamkin](harness-leverage-critical-review-feb28-2026.md) (17% comprehension loss). Full delegation is self-reinforcing — the [Progressive AI Reliance](../insights.md#steering-theory) pattern literally demonstrates this within a single session. You lose the ability to steer, which means you lose the ability to catch when the automation goes wrong.

**The paradox:** The compounding loop (Archetype 2) teeters on this edge. If the wrap-up skill auto-commits, auto-updates memory, and auto-drafts articles *without human review*, it's compounding automation, not compounding learning. The "Review & Apply" phase where the human decides is load-bearing.

**When it's safe:** For genuinely mechanical steps that require zero judgment. Auto-formatting code? Safe to automate. Auto-committing after all tests pass? Borderline — depends on whether you want to review the diff. Auto-deploying? Only with strong verification (Archetype 1) and rollback.

---

## V. Skills Not Yet Built But Structurally Demanded

The research points to gaps where structural demand exists but no quality solution has shipped. These aren't guesses — they're logical consequences of identified structural problems.

### 1. The Verification Scaffold Generator
**Structural demand:** The [specification sandwich](maximum-leverage-brainstorm.md) is the #4 leverage practice, but the setup cost is too high for most people. A meta-skill that generates the verification scaffold (typed Protocols, deal contracts, Hypothesis property proposals) from a natural-language description of what the module should do would dramatically lower the barrier.

**Why it doesn't exist:** The [Competence Paradox](../insights.md#skill-author-competence-paradox) applies to the meta-level too — building a skill that generates good specs requires all three competencies (domain expertise to know what specs matter, model calibration to know what the LLM can reliably generate, instruction design to make it consistent). But the payoff is enormous: it turns a 30-minute-per-module investment into a 5-minute review.

**Who'd pay for it:** Experienced devs who know SDD is valuable but find the setup friction too high. This is the [Activation Energy](../insights.md#activation-energy) insight applied to verification: lower the barrier and projects that wouldn't have been verified will be.

**Expected demand:** High — SDD has gone mainstream (O'Reilly, New Stack, dbreunig). The tools lag the concept.

### 2. The Cross-Session Memory Architect
**Structural demand:** The [memory hierarchy problem](agent-skills-landscape-categories-winners.md) is real — CLAUDE.md, .claude/rules/, CLAUDE.local.md, auto memory, @import — and "most users don't use any of these deliberately." The wrap-up skill gestures at this but nobody has formalized a skill that intelligently routes learnings to the right tier based on scope (project vs global), persistence (temporary vs permanent), and audience (me vs team).

**Why it doesn't exist:** The memory architecture differs across harnesses (Pi vs Claude Code vs Codex). A truly good memory architect needs to understand the specific harness's memory model. Cross-platform portability — the Agent Skills promise — breaks down here.

**Who'd pay for it:** Anyone who uses an agent daily and is frustrated by context loss between sessions. The [OneContext](../insights.md#workflow-as-tribal-knowledge) and Google ADK citations show vendors recognize this need.

**Expected demand:** Very high — context loss is the #1 practitioner complaint.

### 3. The Skill Auditor (That Isn't Itself an Attack)
**Structural demand:** Oathe found 5.4% of skills are dangerous/malicious. The leading scanner missed 91%. A "security audit" skill was itself a trojan. The [SKILL.md-as-payload](agent-skills-landscape-categories-winners.md) attack surface is novel and undefended.

**Why it doesn't exist (correctly):** Behavioral analysis of natural-language instructions is fundamentally harder than code scanning. You need to simulate what the agent *would do* with these instructions — which requires running the skill in a sandbox, observing behavior, and judging intent. This is the same [confused deputy](../insights.md#agent-social-engineered-by-prompt-injection) problem that plagues agent sandboxing generally.

**Who'd pay for it:** Enterprise teams evaluating community skills. The security audit market is always willingness-to-pay-high.

**Expected demand:** Will spike after the first visible malicious-skill incident. Currently latent.

### 4. The Brownfield Onboarding Skill
**Structural demand:** Every harness engineering success story is greenfield. The [critical review](harness-engineering-insights-and-practices.md) flags this explicitly: "Applying these techniques to a ten-year-old codebase with no architectural constraints, inconsistent testing, and patchy documentation is a much more complex problem." A skill that systematically explores a brownfield codebase — maps architecture, identifies test gaps, finds undocumented conventions, builds a progressive AGENTS.md — addresses the gap where most real-world codebases live.

**Why it doesn't exist:** The [ETH Zurich result](harness-engineering-insights-and-practices.md) (-3% from generated context) shows that naive auto-generated context files hurt. A good brownfield onboarding skill would need to be genuinely intelligent about what to include (ambiguity resolution, expensive inference caching) and what to skip (anything the agent can discover on its own).

**Who'd pay for it:** Enterprise teams with legacy codebases trying to adopt agent-assisted development. This is probably the largest underserved market.

**Expected demand:** High and growing. As agent adoption hits the enterprise, brownfield is the default, not the exception.

### 5. Non-Coding Archetypes: Research and Knowledge Work

The first four unbuilt skills above are coding-centric. But the archetype framework applies to any domain with repeatable agent-assisted workflows. Research and knowledge work have their own structurally demanded skills:

**Research synthesis skill (Archetype 5 + 2).** The `hn-distill` skill encodes editorial judgment for individual threads. No equivalent exists for "you have 8 research files on this topic — synthesize them." The methodology (follow backlinks, check for contradictions, cross-reference evidence strength, identify what the corpus circles but never states) is tribal knowledge that's currently implicit. A skill that codifies this would combine tribal knowledge codification with session accumulation — each synthesis refines the methodology.

**Knowledge base consistency checker (Archetype 1 for notes).** Link rot, stale claims, contradictory conclusions across files, orphaned research without topic-page backlinks. This is the verification gauntlet for a non-code repository. Best delivered as a hook or periodic check, not as a skill — it should run unconditionally, same as a linter.

**Source credibility protocol (Archetype 4 for research).** Account age checks, burst-vs-sustained posting patterns, AI-generation signals — this already exists in project AGENTS.md but competes for attention with everything else there. Formalizing it as a standalone always-loaded rule or a skill invoked during source evaluation would make it reliably applied rather than sometimes-noticed.

These examples demonstrate that the framework is domain-agnostic — the archetypes describe *how value is created* (verification, accumulation, codification, constraint), not *what domain they serve*. The coding-centric framing of the first four unbuilt skills is a limitation of the evidence base, not of the framework.

### 6. The Cognitive Rest Pacer
**Structural demand:** [Cognitive Rest Erosion](../additional_insights.md#cognitive-rest-erosion) identifies that AI removes the implicit recovery periods embedded in mechanical work. When the agent handles all the rote parts, the human does 8 hours of sustained architectural decisions — unsustainably draining. A skill that deliberately paces the session (summary checkpoints, forced review pauses, "here's what we've decided so far" recaps) would address the human throughput ceiling that's invisible to productivity benchmarks.

**Why it doesn't exist:** Nobody measures human cognitive load during agent sessions. The problem is invisible because output volume looks great while the human burns out.

**Who'd pay for it:** Solo devs who marathon agent sessions and burn out. Knowledge workers who notice they're mentally exhausted after AI-heavy days. This maps to the wellness/productivity intersection — niche but real.

**Expected demand:** Low initially, growing as the burnout pattern becomes visible. This is a 12-18 month lead indicator.

---

## VI. The Meta-Insight: Skills Are Infrastructure, Not Features

The deepest pattern across all the research is this: **the skills that create the most value are the ones that feel least like "skills."**

The verification gauntlet isn't exciting — it's a linter config. The behavioral constitution isn't clever — it's a list of don'ts. The compounding loop isn't innovative — it's session hygiene. The specification scaffold isn't novel — it's type annotations and contracts.

These are all **engineering infrastructure**. They're the same practices that made software reliable before LLMs existed, now expressed as agent-executable instructions instead of team norms.

The [harness engineering meta-insight](harness-engineering-insights-and-practices.md#vii-the-meta-insight) crystallizes it: "Strip away the AI framing and harness engineering is: strict linting, fast CI, enforced architecture, good documentation, mechanical verification, observable systems." Skills are the delivery mechanism for engineering practices that most teams skipped for decades and now find load-bearing.

The HN commenter who said it best: "My pet peeve with AI is that it tends to work better in codebase where humans do well and for the same reason... refactoring our antiquated packages in the name of 'making it compatible with AI' which actually means compatible with humans."

Skills don't make agents smart. They make the environment the agent operates in *rigorous enough* that even a probabilistic, theory-less, sycophantic text predictor can produce reliable output — because the environment catches mistakes faster than the agent can make them.

That's why the [Culture Amplifier](../insights.md#culture-amplifier) is the master insight for skills: **skills amplify whatever engineering culture they find.** Install a verification gauntlet on a well-tested codebase and get reliable agent output. Install it on an untested codebase and drown in alerts. The skill is the same; the culture determines the outcome.

**The uncomfortable conclusion for skill marketplaces:** The skills ecosystem is inverting the value chain. skills.sh's 57,000+ listings suggest the value is in *having* skills. The evidence says the value is in *the engineering practices the skills encode* — practices that require human investment, domain knowledge, and organizational discipline that can't be downloaded.

The most valuable skill is the one you write yourself, for your own codebase, encoding your own hard-won knowledge. It will never appear on a leaderboard. It will never get 45K stars. It will be 50 lines of opinionated instructions that save you 20 minutes every day because nobody else on earth has your exact combination of tools, conventions, and production war stories.

**The format question this raises:** If the value is in the *practices* and not the *packaging*, then SKILL.md files are just one delivery mechanism among several — and not always the best one (see [Delivery Mechanism Fit](#delivery-mechanism-fit-not-everything-is-a-skill) above). AGENTS.md rules, hooks, CI config, project templates, and linter settings all deliver engineering practices to agents. The Agent Skills specification adds progressive disclosure and portability, which matter for some archetypes (tribal knowledge codification, session loops) and are irrelevant for others (verification gauntlets, constitutions). The framework in this document is about engineering practices that happen to benefit from agent awareness, not about a markdown file format. Use whatever mechanism makes the practice most reliable.

That's the durable value. Everything else is transitional.
