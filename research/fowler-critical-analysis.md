← [Index](../README.md)

# Martin Fowler's Site: A Deep Critical Analysis
## July 2025 – February 2026

---

## Executive Summary

Martin Fowler's site has become the most rigorous, empirically grounded voice in the AI-and-software-development discourse — and simultaneously the voice most at risk of being overtaken by events.

Over the past six-plus months, the site published roughly 12 substantive pieces (articles + fragments) almost entirely about generative AI. The work is exceptional: grounded in real tool usage, skeptical without being dismissive, and anchored to decades of software engineering principles. But the ground is moving fast. The strongest counter-arguments to Fowler's position — from engineers like Andrej Karpathy, DHH, Simon Willison, and Boris Cherny — suggest the profession may be mutating faster than the site's analytical framework can accommodate.

This analysis covers every major piece from the period, evaluates it on its own terms, then places it against the wider industry context.

---

## What I Got Wrong (and Missed) in My First Pass

My initial analysis missed four substantive articles that significantly change the picture: Böckeler's **"To Vibe or Not to Vibe"** (Sep 2025), her **"Anchoring AI to a Reference Application"** (Sep 2025), Joshi's **"The Learning Loop and LLMs"** (Nov 2025), and Vaccari's **"Partner with the AI, Throw Away the Code"** (Jul 2025). Including these reveals a body of work that's both more prolific and more intellectually diverse than my first analysis conveyed. I also understated how explicitly Fowler acknowledges the magnitude of the shift — he's called it comparable to the move from assembler to high-level languages, which is anything but conservative.

---

## The Full Inventory (Jul 2025 – Feb 2026)

**Major articles:**
1. Partner with the AI, Throw Away the Code — Vaccari (Jul 2025)
2. I Still Care About the Code — Böckeler (Jul 2025)
3. To Vibe or Not to Vibe — Böckeler (Sep 2025)
4. Anchoring AI to a Reference Application — Böckeler (Sep 2025)
5. Understanding Spec-Driven Development — Böckeler (Oct 2025)
6. The Learning Loop and LLMs — Joshi (Nov 2025)
7. Stop Picking Sides — Highsmith (Jan 2026)
8. Conversation: LLMs and the What/How Loop — Joshi, Parsons, Fowler (Jan 2026)
9. Assessing Internal Quality While Coding with an Agent — Doernenburg (Jan 2026)
10. Excessive Bold — Fowler (Jan 2026)
11. Context Engineering for Coding Agents — Böckeler (Feb 2026)

**Plus:** ~6 substantive "Fragments" posts and the Pragmatic Engineer podcast conversation.

This is a *prolific* output. Böckeler alone contributed 5 major articles in 8 months — she is the site's most important voice right now, arguably surpassing Fowler himself in this period.

---

## Article-by-Article Assessment

### The Böckeler Arc (5 pieces, Jul 2025 – Feb 2026)

Birgitta Böckeler's work across this period forms the single most comprehensive practitioner's account of AI-assisted software development published anywhere. Taken together, it traces an arc from concern ("I Still Care About the Code") through practical frameworks ("To Vibe or Not to Vibe") to infrastructure-level tooling ("Context Engineering"). This matters because it's not abstract theorizing — it's one experienced engineer systematically working through each layer of the problem.

**"To Vibe or Not to Vibe" (Sep 2025)** is, on reflection, the most practically useful article in the entire collection. Its three-factor risk framework — probability of AI error × impact if undetected × detectability through feedback loops — gives practitioners something they can actually use Monday morning. Most writing on "should I review AI code?" is either absolutist ("always review everything!") or nihilist ("vibe coding is fine!"). Böckeler cuts through this by making it a risk management question. The legacy reverse-engineering case study demonstrates the framework in action. The article's weakness is that it works best for individual decisions and doesn't address how these micro-assessments scale to team-level governance.

**"I Still Care About the Code" (Jul 2025)** raises the right question — the on-call test ("would you deploy a 5,000 LOC AI-generated changeset if you were on call tonight?") is a beautifully simple acid test that cuts through hype. But the article assumes the current relationship between developer and code persists. The strongest counter-argument: if AI-generated code becomes cheap enough to throw away and regenerate, "caring about the code" may matter less than caring about the specs, tests, and constraints that guide regeneration.

**"Anchoring AI to a Reference Application" (Sep 2025)** is deeply practical and under-discussed. Using a reference application as a living prompt source — and then using AI to detect "code pattern drift" between real services and the reference — is an enterprise architecture insight with real legs. This is one of the few pieces that could plausibly *only* come from the Thoughtworks enterprise context, and it's stronger for it.

**"Understanding SDD: Kiro, spec-kit, and Tessl" (Oct 2025)** is a timely demolition. Böckeler finds that SDD tools frequently ignore their own specs, or follow them too eagerly, producing duplicates and drift. Her core skepticism — that heavy upfront specification contradicts decades of iterative learning — is exactly right for now. But I note a tension: if models get dramatically better (as they appear to be doing), the "specs can't capture everything" argument weakens. Böckeler's analysis may have a shorter shelf life than other pieces here.

**"Context Engineering for Coding Agents" (Feb 2026)** is the best taxonomy of its kind. My first-pass criticism (too Claude Code-centric) stands, but is softer now that I see the broader arc: Böckeler is clearly using Claude Code as a concrete example of patterns that are appearing across tools. The "illusion of control" closing is the most important paragraph — context engineering is probabilistic steering, not deterministic engineering.

**Overall Böckeler verdict:** This is a body of work that deserves recognition beyond the Fowler site. She is doing what the field needs most: careful, honest, detailed field reports from someone with genuine expertise. The risk is that the work's incremental, cautious tone may cause it to be drowned out by louder voices making bigger claims.

---

### The Joshi Arc (2 pieces, Nov 2025 – Jan 2026)

**"The Learning Loop and LLMs" (Nov 2025)** is the most philosophically ambitious piece in the collection and the most vulnerable to challenge. Joshi's core argument: software development is fundamentally a learning activity. LLMs provide speed but bypass the learning loop, creating an "illusion of speed" — a maintenance cliff where initial velocity collapses when requirements deviate from what the AI generated. He compares LLMs to low-code platforms: powerful initial velocity, zero internalized knowledge.

**Strengths:** The learning loop model (observe → experiment → recall/apply) is clean and true. The analogy to system performance at saturation — the "knee" beyond which latency spikes — is vivid and precise. The distinction between LLMs as translators (bridging human intent to specialized syntax) versus LLMs as learners (they aren't) is useful.

**Critical weakness:** Joshi makes a strong claim — "AI cannot automate learning" — and leaves it as self-evident. But this deserves more interrogation. Can a developer who has AI generate code, then carefully reviews and tests it, learn *almost as much* as one who typed it by hand? The piece implicitly equates typing with learning, which is at best an unexamined assumption. Many developers report learning *more* when they use LLMs to explore unfamiliar codebases or paradigms. The maintenance cliff graph is presented without data — it's an assertion, not evidence. This matters because the piece is explicitly arguing against claims of productivity gains, and those claims increasingly come with data (however imperfect).

**"Conversation: LLMs and the What/How Loop" (Jan 2026)** is the intellectual centerpiece. The what/how feedback loop model — where programming is the iterative refinement of intent ("what") through mechanism ("how") — is the strongest conceptual contribution the site has made in this period. The connection to TDD is sharp: tests operationalize the what/how loop by forcing you to articulate intent before implementation. The observation that LLM code tends to be either too procedural or over-abstracted captures something real.

**Revised criticism:** The deeper problem with this piece is that it underestimates how much LLMs may be changing the *granularity* of the what/how loop. When Fowler says LLMs "allow us to explore that loop in an informal and more fluid manner," he treats this as an improvement within the existing paradigm. But Karpathy's observation — that there's now a new programmable layer of abstraction (agents, subagents, prompts, contexts, memory, modes, tools, plugins, skills, hooks, MCP) — suggests something more radical: the what/how loop may be moving to a higher level of abstraction entirely. If "what" becomes a natural-language specification and "how" becomes the orchestration of AI agents, the loop still exists, but the skills needed to navigate it change fundamentally. The conversation doesn't reckon with this possibility.

Rebecca Parsons's closing question — who builds new languages and paradigms if LLMs only work where training data is abundant? — remains the sharpest unanswered question in the entire body of work.

---

### The Doernenburg Piece (Jan 2026)

**"Assessing Internal Quality While Coding with an Agent"** remains the most *needed* article in the collection. In a discourse drowning in speed claims, Doernenburg asks the unfashionable question: what does the code look like? His finding — that the AI did the fun part (writing code) while leaving him the tedious part (reviewing mediocre output) — deserves to be quoted in every executive decision about AI adoption. The Claude Code hallucination about an API field that didn't exist is a textbook illustration of confident error in a domain-specific context.

The article would be stronger with systematic quality metrics. But its fundamental value — someone actually looking at the output rather than celebrating the throughput — is undiminished.

---

### The Vaccari Piece (Jul 2025)

**"Partner with the AI, Throw Away the Code"** is a piece I missed entirely in my first pass, and it's important. Vaccari demonstrates that the common metric for AI coding tools — acceptance rate (what percentage of AI-generated code developers keep) — has a fatal blind spot. The AI helped him solve a genuinely difficult performance optimization problem not by generating the final code, but by helping him *understand the problem*. He used TDD to drive the AI incrementally through test cases, then threw away intermediate code when it wasn't good enough.

This is the practical instantiation of the what/how loop. The AI accelerated Vaccari's learning, even when its code was discarded. This is a more nuanced and defensible position than "AI can't help with learning" — it suggests AI can be instrumentalized *within* the learning loop, not as a replacement for it. It's arguably the most important corrective to Joshi's stronger claim.

---

### The Highsmith Piece (Jan 2026)

**"Stop Picking Sides"** is the outlier — the only non-AI-focused piece. The core insight (manage the explore/exploit tension, don't pick a tribe) is sound, the "handoff tax" concept is useful, the DARE framework is practical. The piece is weakened by a 20-year-old case study and an AI-assisted prose style that's ironic for a site that just published "Excessive Bold." But for leaders who need permission to stop the agile-vs-traditional purity wars, it serves its purpose.

---

### The Fowler Fragments and Bliki (Jan–Feb 2026)

The fragments deserve more weight than I initially gave them. Some of the most provocative ideas in the entire body of work appear here, undeveloped:

- **"Cognitive debt"**: Teams ship faster but learn less. This may be the single most important long-term concern in the AI-coding discourse, and it deserves a full article, not a fragment. The analogy to technical debt is powerful: cognitive debt compounds silently until a change arrives that no one on the team understands how to make.

- **"LLMs are drug dealers"**: They provide output but don't care about the resulting system or the humans that develop and use it. Context resets every session. Provocative, directionally true, and deeply uncomfortable for AI optimists.

- **"Skeptical of my own skepticism"**: The right posture, stated explicitly. Also easier to state than to practice. The site's output is more skeptical than self-skeptical in practice.

- **"Managing agents resembles managing junior developers"**: May be the most practically resonant observation for engineering managers trying to understand their role in AI-augmented teams.

- **"Language Workbenches revisited"**: The idea that LLMs might reintroduce something like projectional editors — non-human-readable source representations with human-readable projections — is genuinely fascinating and entirely unexplored.

- **"Will two-pizza teams shrink to one-pizza teams?"** Fowler suspects not — that collaboration benefits stabilize team size even as per-person output increases. An important bet.

**"Excessive Bold"** is a minor piece with outsized meta-commentary: it is, effectively, Fowler telling every LLM in existence to stop formatting like a marketing email. The irony that his site now hosts a Highsmith article visibly edited by an LLM is unacknowledged.

---

## The Central Thesis (Refined)

Reading all 11 articles, 6 fragments posts, and the podcast context, the Fowler orbit's position can be distilled precisely:

> **Programming is a learning activity, not a production activity. LLMs dramatically accelerate production but do not accelerate learning — and may actively inhibit it. The essential challenge remains building systems that survive change, which requires human-driven abstraction, iterative design, and managed cognitive load. The what/how feedback loop is the core mechanism, TDD its best-known operationalization, and LLMs are powerful instruments *within* this loop but cannot replace it. The acute danger is cognitive debt: teams that ship faster while understanding less, creating systems that will resist the unanticipated changes that inevitably come.**

---

## The Strongest Counter-Argument the Site Doesn't Fully Engage

The Fowler orbit's position is internally consistent and currently well-evidenced. But it faces a serious challenge that the site acknowledges without fully engaging.

In January 2026, Gergely Orosz documented a growing chorus of deeply experienced engineers — Karpathy, DHH, Simon Willison, Thorsten Ball, Adam Wathan, Jaana Dogan (principal engineer at Google), and Boris Cherny (creator of Claude Code) — reporting that models released in November-December 2025 crossed an invisible capability line. Karpathy writes that the programming profession is being "dramatically refactored." DHH, who was skeptical of AI just months earlier, says his stance has "flipped." Cherny reports committing 200 PRs in a month without opening an IDE.

These are not breathless newcomers. They are engineers with 10-30+ years of experience reporting a qualitative shift. And their testimony creates a tension with the Fowler orbit's emphasis on what hasn't changed.

The Fowler orbit would respond: these reports are mostly about greenfield work, side projects, or single-developer contexts. Enterprise systems with legacy constraints, team coordination, regulatory requirements, and decade-long maintenance horizons are a different beast. This is fair. But it's also the argument that has been made about every previous technology shift: "yes, it works for new, simple things, but *our* problems are different." Sometimes that's correct. Sometimes it's the last thing a paradigm says before it's replaced.

The honest assessment: Fowler's framework (learning loop, what/how loop, cognitive debt) is probably correct *and* may be insufficient. The profession may be splitting into two worlds — one where Fowler's principles are essential (long-lived enterprise systems) and one where they're nearly irrelevant (disposable, generated applications). The site would be stronger if it engaged this bifurcation explicitly rather than implicitly assuming enterprise is the only context that matters.

---

## Cross-Cutting Strengths

**Empiricism.** Every claim grounded in someone actually using the tools. Doernenburg built a feature. Böckeler evaluated tools. Vaccari solved a performance problem. Joshi wrote a distributed systems framework. This is the gold standard.

**Connecting new tools to old principles.** The what/how loop, cognitive debt, TDD as a forcing function — these aren't invented for the AI moment. They're established ideas applied to a new context. This is what a platform with 25+ years of institutional memory should do.

**Intellectual honesty.** Fowler's "skeptical of my own skepticism" is rare. The site acknowledges genuine utility (legacy modernization, exploration, boilerplate) without catastrophizing.

**Böckeler's practical frameworks.** The probability × impact × detectability model, the context engineering taxonomy, the reference application as prompt source — these are tools practitioners can use immediately.

---

## Cross-Cutting Weaknesses

**The learning-typing conflation.** The site's strongest argument (LLMs bypass learning) rests on an underexamined assumption: that writing code by hand is the primary mechanism through which developers learn. But many developers report learning effectively by reviewing, testing, and reasoning about AI-generated code. The learning loop may be more flexible than Joshi's model allows. Vaccari's own piece — where AI *aided* his learning even when code was discarded — undermines the strongest version of the learning-loop argument from within the site's own pages.

**Selective engagement with the frontier.** The site cites the accelerationist voices in fragments but doesn't build systematic arguments against their strongest claims. When Karpathy says there's a "new programmable layer of abstraction" involving agents/subagents/prompts/context/tools, that's a claim about the what/how loop itself changing level. The site should engage this directly.

**Monoculture of perspective.** Every author is a current or former Thoughtworker. The enterprise-consulting lens is consistently high-quality but systematically excludes: solo developers, startup founders, open-source maintainers, and academics.

**Fragment-heavy provocation.** The most important ideas (cognitive debt, the future of source code, Language Workbenches) are fragments, not articles. The site's most provocative contributions are its least developed.

**Missing the speed-of-change meta-question.** The site evaluates whether LLMs change the fundamentals of programming. It does not evaluate whether the *rate of model improvement* changes the fundamentals of evaluation. If models improve as much in the next 6 months as they did in the last 6, every assessment published today — including Fowler's — may need revision.

---

## What's Missing Entirely

- **No treatment of AI and team dynamics.** How do code reviews change when half the code is AI-generated? How does pair programming evolve?
- **No security deep-dive.** The "Lethal Trifecta" appears only in fragments, despite being one of the most consequential issues for enterprise adoption.
- **No economic analysis.** What does AI-assisted development mean for consulting firms like Thoughtworks specifically? A company that bills for developer-hours engaging with a technology that may dramatically reduce the developer-hours needed — this is the elephant in the room.
- **No quantitative evidence.** Rich in qualitative case studies, weak on numbers. In a field drowning in dubious productivity claims, the absence of rigorous counter-data is a missed opportunity.

---

## Final Assessment

The Fowler orbit is producing the most intellectually honest, empirically grounded work on AI and software development available anywhere. It is also producing work that is, by its own cautious nature, at risk of becoming a snapshot of a moment that has already passed by the time it's published.

The site's framework — learning loop, what/how loop, cognitive debt, TDD as forcing function — will age well *if* software development remains fundamentally a learning activity where humans must understand what they're building. This is the site's bet. It's probably right for the next 2–3 years, and possibly right forever. But the site would be stronger if it explicitly engaged the scenario where it's wrong.

The most important single contribution is the concept of **cognitive debt** — teams shipping faster while understanding less. If there is a reckoning with AI-assisted development, it will come in this form: not code that doesn't work, but code that no one understands well enough to change when the world shifts beneath it. The Fowler orbit saw this first and named it best. Whether the industry listens before the debt comes due is another question entirely.

---

*Revised analysis conducted February 15, 2026. Based on full-text reading of all major articles and fragments published on martinfowler.com from July 2025 through February 2026, plus external context from The Pragmatic Engineer, The New Stack, and competing perspectives from Karpathy, DHH, Willison, Cherny, Orosz, and others.*
