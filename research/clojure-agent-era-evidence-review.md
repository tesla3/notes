# Clojure in the Agent Era: Evidence Review

*March 4, 2026*

*Critical review of evidence and counter-evidence on Clojure's position in the LLM/agent coding era. Organized by thesis, with source credibility assessed.*

---

## The Original Claim Under Review

"Clojure and its library/framework ecosystem will suffer the LISP Curse in the agent era."

**Verdict from initial analysis:** The claim mislabels the threat. The agent-era LISP Curse (fragmentation from agents regenerating bespoke code) primarily hits framework-heavy ecosystems falling from height. Clojure was already at the bottom of that gradient. The actual threats are training data starvation and talent drain. But Clojure's architectural properties (immutability, data orientation, composability) are well-aligned with agent-era patterns.

This document assembles the evidence.

---

## I. The Matthew Effect: Hard Numbers on the Performance Gap

### The core finding

**Li et al., "The Matthew Effect of AI Programming Assistants" (arXiv:2509.23261, v3 Feb 2026)** — the most rigorous study on this question. Large-scale experiments on 3,011 LeetCode problems across 8 languages and 5 frontier models.

Key results:
- Python Pass@1: 79.81% (DeepSeek-V3). Erlang: 24.31%. Racket: 20.82%.
- Gap widens non-linearly with difficulty. On Hard problems: popular languages 50-63%, niche languages 0-6%.
- Failure modes differ qualitatively: popular languages fail with Wrong Answer (semantically plausible but incorrect). Niche languages fail with **Compile Errors** — models can't even produce syntactically valid code.
- Statistical significance confirmed: paired t-tests, p<0.001 across all models. Mean difference +28.9% to +44.8%.

**Credibility: High.** Peer-reviewed, large-scale, multiple models, fresh LeetCode problems (2025) to avoid contamination. Limitation: tests algorithmic puzzles, not real-world software engineering tasks.

### Supporting evidence

**Cassano et al., "Knowledge Transfer from High-Resource to Low-Resource Programming Languages" (ACM OOPSLA 2024)** — MultiPL-T approach. Fine-tuning on translated data closed the gap: Lua exceeded base Python performance. Julia saw 67% relative improvement. OCaml doubled. Racket tripled.

**Implication:** The gap is bridgeable through targeted fine-tuning. It's an engineering problem, not a fundamental limitation. But nobody has done this for Clojure specifically.

**AutoCodeBench (arXiv:2508.09101, Jul 2025)** — Claude Opus 4 outperforms other models significantly on low-resource languages. The gap between models is wider on niche languages. This suggests model capability improvements disproportionately help underserved languages.

**Kirancodes.me blog post (Jun 2025)** — "Programming Language Design in the Era of LLMs." Cites StarCoderBase-15B data showing performance drops sharply as language representation in training data decreases. DSL opportunity cost "has just doubled."

**Credibility: Medium.** Blog post, but references the Cassano et al. paper and presents the training data graph clearly.

### What this means for Clojure specifically

Clojure is not tested in any of these benchmarks directly. It sits in an awkward middle: more training data than Erlang or Racket (thanks to JVM ecosystem, Clojure community output), but far less than Python/JS/Java. The Matthew Effect likely applies to Clojure at a moderate level — worse than mainstream, better than truly niche.

---

## II. Counter-Evidence: The REPL as Equalizer

### Bruce Hauman's Clojure MCP (May 2025 - present)

**Source:** GitHub (bhauman/clojure-mcp), HN thread (44086062, 202 points, 50 comments), Metosin blog review.

Hauman's core claim: "LLMs can definitely write Clojure. However, our secret weapon is the REPL and the fast focused feedback loop that it offers."

The tool connects AI agents directly to a live nREPL. Key capabilities:
- Agent evaluates expressions in the running application, sees actual results
- S-expression-aware structural editing (via clj-kondo, parinfer, cljfmt) prevents paren mismatches
- Agent can inspect application state, test hypotheses, debug iteratively
- Hot dependency loading without losing application state

Hauman: "Until you've tried using an LLM assistant fully hooked into a stateful REPL, you can't speculate. The experience is fantastic."

**Credibility: Medium-High.** First-party (tool creator), but independently confirmed by multiple practitioners. Metosin (respected Clojure consultancy): "Clojure MCP shows how thoughtful integration can overcome the 'training data disadvantage' that niche languages face with AI tools. Quality tooling with live feedback beats pattern matching from static examples every time."

### iwillig.me — "One Year of LLM Usage with Clojure" (Feb 2026)

**Source:** Practitioner blog from Shortcut (production Clojure shop, 11-year codebase).

Key observations:
- "LLM models are more effective with languages that dominate the training dataset... This fact is and was concerning to me."
- Initial Claude Code experience: poor. Agent ran full test suite after every change (minutes). Unacceptable.
- AGENTS.md teaching approach: "We began to tweak our AGENT.md file, teaching Claude Code about how Clojure and Clojure's data structures work. We noticed large improvements."
- Built a "Clojure Skills" system: SQLite DB of skills loaded into system prompt. "Prompt packing" — putting knowledge directly in system prompt.
- Problem: "Over long LLM sessions with large context windows, the knowledge and the skill didn't stay very sticky." Cites Liu et al. 2023 "Lost in the Middle."
- Solution: curated skills in system prompt via OpenCode. "I was able to one-shot more and more tasks with the LLM than I ever could with Claude Code alone."

**Credibility: High.** Practitioner with a year of daily experience, production codebase, honest about struggles. This is exactly the kind of first-hand report that matters.

### Solita blog — "Using Generative AI tooling with Clojure" (Feb 2026)

Confirms the REPL advantage: "coding agents have a far easier time troubleshooting and debugging compared to having them just analyze source code, logs and stacktraces." Notes collaborative dimension: developer and agent can connect to the same REPL simultaneously.

### Julien Bille's experience (via Medium, cited in Barbalet)

Initially: "simple things took way too long" and the AI was "unable to get parentheses right." After integrating s-expression-aware tooling (Clojure-MCP): "the agent experience got much better" and "it goes a LOT faster to write good code solutions."

**Pattern:** The raw LLM-on-Clojure experience is measurably worse. But REPL + structural editing tooling closes much of the gap, and the feedback loop may ultimately be superior for complex tasks.

---

## III. The "Simple Made Inevitable" Thesis

### Barbalet, "Simple Made Inevitable: The Economics of Language Choice in the LLM Era" (Feb 2026)

**Source:** felixbarbalet.com. Self-described decade-long Clojure user, previously at Qantas managing 20 microservices in Clojure/Polylith.

**Core argument:** Language choice is a capital allocation decision with compounding returns. The "brownfield barrier" — where codebases become too large and tangled for agents to navigate — is the real constraint. Clojure pushes that barrier further out through:

1. **Token efficiency.** Martin Alderson's analysis of Rosetta Code: Clojure is the most token-efficient of 19 languages. ~19% fewer tokens than Python, ~30% fewer than JS/Java. Context windows degrade non-linearly, so this compounds.

2. **Immutability eliminates defensive boilerplate.** McKinney identifies agents generating "large amounts of defensive boilerplate that is rarely needed." Clojure's immutable data makes much of this impossible to generate.

3. **Data orientation scales linearly.** One toolkit (`assoc`, `merge`, `get-in`) works on all data. OOP languages require per-class APIs. O(n) vs O(n²) in what the agent must hold in context.

4. **Stability as signal.** `clojure.core/map` has meant the same thing for 17 years. Python 2→3, React class→hooks→server components, Angular.js→Angular all create conflicting training data. Rich Hickey's code retention charts show nearly flat survival — almost all code from every Clojure release survives.

5. **The learning curve is dead.** Nathan Marz built a complex distributed system with Claude Code using Rama (Clojure framework). "Developer familiarity stops being the dominant selection criterion."

**Key cited evidence:**
- Wes McKinney (pandas creator): "already dealing with this problem as I begin to reach the 100 KLOC mark and watch the agents begin to chase their own tails." Chose Go, hit brownfield barrier.
- WalmartLabs (Anthony Marcar): "Clojure shrinks our code base to about one-fifth the size it would be if we had written in Java."
- CodePatchLLM (KDD 2024): Compiler feedback improves Java/Kotlin code gen by 45%, but **zero** improvement for Python (no compiler). Dynamic languages get nothing from the compile loop — they need REPL.
- Token Sugar (ICSE 2025): Compressing verbose patterns achieves 15.1% token reduction with near-identical correctness. Boilerplate doesn't help the model reason.
- Replit Agent: Uses REPL-based verification, reports 3× faster and 10× cheaper than previous approaches.

**Honest counter-arguments Barbalet engages with:**
- "LLMs are measurably worse at Clojure" — concedes this is real, but distinguishes function-level correctness (benchmarked) from system-level maintainability (not benchmarked). "Better at generating Python" ≠ "Python generates better systems."
- FPEval: GPT-5 generates 94% imperative patterns in Scala, 88% in Haskell. LLMs write imperative code *disguised* as functional. But: Clojure's constraints prevent this. "You can't mutate what the language won't let you mutate."
- Static types provide feedback Clojure lacks — grants the function-level advantage, but argues types create coupling that hurts at system scale. Clojure offers middle path via Malli/Spec (optional schemas).

**Credibility: Medium.** Well-argued, extensively cited, but openly biased (decade-long Clojure advocate). The token efficiency data is verifiable. The "brownfield barrier" argument is theoretical — no controlled study compares Clojure vs Python brownfield degradation at scale with agents. McKinney's Go experience is an anecdote about Go, not evidence about Clojure. The strongest claims (5× codebase reduction, token efficiency) have independent sources.

---

## IV. Community Health: The Numbers

### State of Clojure 2025 Survey (Feb 2026)

**Source:** clojure.org, official survey by Christoph Neumann.

- Survey respondents: 1,545 (down from 2,527 peak in 2021, but stabilizing — 2024 was 1,549)
- 15% used Clojure for ≤1 year (new blood exists)
- 82% have 6+ years professional programming experience (experienced community)
- 73% use Clojure at work
- **70% have used AI tools for software development**, 12% considering it, 18% disinterested
- Top industries: Financial Services, Enterprise Software, Healthcare
- Nubank employs thousands of Clojure developers (large concentration)
- NPS: 70% very likely to recommend, only 8% would not
- 10% would quit programming without Clojure (remarkable loyalty)

### Vlaaad's survey trend analysis (Feb 2026)

Respondent counts: rapid growth (2010-2015), long plateau (2015-2022), drop (2022-2024), stabilizing (2024-2025). "Looks like the trend is reversing to growth once again."

### Clojurists Together Member Survey (Jun 2025)

Community members identify AI as a top challenge:
- "Most LLMs tend to replace Clojure with languages they know better"
- "Perceived ability for AI to write code is creating skepticism of the value of notation optimized for humans (e.g., Clojure)"
- "Make the stack traces easier for AI agents"
- "That AI's get better at writing/reviewing Clojure code"
- Still asking for "rails-for-clojure" — the framework gap persists

### StackOverflow 2025 Survey

Clojure was **excluded** from the language list (along with Haskell). "Lisp" was included instead. This is a visibility/recognition problem that feeds the starvation cycle.

---

## V. The Rust Counter-Example

### JetBrains Rust Developer Ecosystem Survey 2025 (Feb 2026)

Relevant comparison because Rust is also "niche" but tells a different story:

- 89% of Rust developers have tried AI tools, 78% actively use them
- Tim McNamara (Rust in Action author): "AI agents are not intimidated by the Rust learning curve. Its type hints and error messages mean that coding agents can learn Rust very well."
- Ben Brandt (Zed): "Rust's built-in documentation, expressive type system, and readable compiler errors provide agents the context they need to work effectively."

### GitHub Agent Adoption Study (arXiv:2601.18341, Jan 2026)

Commit ratio by language: "Widely used languages such as Javascript, Python, Java have also median commit ratios close to the overall median." But: "less established languages such as GraphQL, SCSS, Svelte and Elixir are trailing in median commit ratio."

**Key finding:** "C, C++ or Rust who were expected to have lower commit ratios, due to their low-level nature, are in the middle of the pack." Agent adoption is broader than expected — not limited to high-resource languages.

### Go for Agents — HN thread (Mar 2026, 2 days old)

Practitioner claim: "Go delivers highly consistent results via Claude and Codex regularly and more often than working with clients using TypeScript and/or Python." Reasons: stable training corpus, one way to write it, one build system, one formatter, static typing. "The language hasn't had a breaking version in over a decade."

This maps to Clojure's stability argument — but Go has a massively larger corpus.

---

## VI. Synthesis: What the Evidence Actually Says

### The training data gap is real but not permanent

- The Matthew Effect paper proves the gap exists (p<0.001).
- MultiPL-T proves the gap is bridgeable through targeted fine-tuning.
- Clojure MCP proves tooling can partially compensate via tighter feedback loops.
- No one has done systematic Clojure-specific fine-tuning at frontier model scale.

### The REPL is a genuine structural advantage

- Multiple independent sources confirm tighter feedback loops with REPL-connected agents.
- CodePatchLLM data shows compiler feedback helps static languages but not dynamic ones — REPL feedback is the dynamic language equivalent.
- Replit Agent's REPL-based approach: 3× faster, 10× cheaper (though this is Python, not Clojure).
- Clojure's immutability makes the REPL advantage *safer* than Python/JS REPLs (no mutable state accumulation).

### The brownfield barrier argument is compelling but unproven

- Barbalet's thesis is well-reasoned and internally consistent.
- Token efficiency data is real (Alderson's Rosetta Code analysis).
- McKinney's brownfield experience is real but anecdotal and about Go, not a Clojure comparison.
- No controlled study has compared agent codebase degradation rates across languages.
- The WalmartLabs 5× reduction figure is pre-agent-era and about human-written code.

### Community trajectory is concerning but not terminal

- Survey stabilizing at ~1,545 (down 39% from peak but no longer declining).
- 70% AI adoption shows community is engaging, not burying heads.
- StackOverflow exclusion is a canary — Clojure risks becoming invisible to the next generation.
- Nubank concentration is both a strength (thousands of developers) and a single-point-of-failure.

### The actual LISP Curse diagnosis

The original claim was wrong about the mechanism but gestures at a real risk. Clojure won't suffer the *agent-era* LISP Curse (framework fragmentation) because it was never framework-dependent. What it faces is:

1. **Matthew Effect talent drain** — measurable, empirically confirmed, accelerating.
2. **Invisibility spiral** — StackOverflow exclusion, benchmark exclusion, training data underrepresentation.
3. **Tooling dependency on a few individuals** — Clojure MCP (Hauman), clojure-lsp, shadow-cljs all have single-digit maintainer counts.

But also genuine counter-forces:

1. **REPL + immutability = structurally superior feedback loop** — confirmed by independent practitioners.
2. **Token efficiency at scale** — verifiable, potentially decisive for long-session agent work.
3. **Stability as consistent training signal** — 17 years of semantic consistency vs Python's churn.
4. **Architectural alignment with agent-era patterns** — not just theoretical; maps to the verified-by-construction, compose-primitives patterns from the architecture research.

---

## VII. Key Sources

| Source | Date | Type | Credibility | Finding |
|--------|------|------|-------------|---------|
| Li et al. Matthew Effect | Feb 2026 | arXiv paper | High | 3-4× performance gap, statistically significant |
| Cassano et al. MultiPL-T | 2024 | ACM OOPSLA | High | Gap bridgeable via fine-tuning |
| Hauman Clojure MCP | May 2025+ | Tool + HN | Medium-High | REPL compensates for training data gap |
| iwillig "One Year" | Feb 2026 | Practitioner blog | High | Honest year-long account, skills+prompt approach works |
| Barbalet "Simple Made Inevitable" | Feb 2026 | Blog essay | Medium | Compelling argument, biased source, partially verifiable |
| State of Clojure 2025 | Feb 2026 | Official survey | High | Community stabilizing, 70% using AI tools |
| Clojurists Together Survey | Jun 2025 | Community survey | High | AI identified as top challenge |
| GitHub Agent Adoption | Jan 2026 | arXiv paper | High | Agent adoption is broad, not limited to popular languages |
| Alderson token efficiency | 2025 | Analysis | Medium | Clojure most token-efficient of 19 languages |
| CodePatchLLM | KDD 2024 | Paper | High | Compiler feedback helps static langs, not dynamic |
| FPEval | Jan 2026 | arXiv paper | High | LLMs write imperative code disguised as functional |
| AutoCodeBench | Jul 2025 | arXiv paper | High | Model improvements disproportionately help niche languages |

---

*Filed under: Clojure, agent-era architecture, language viability, Matthew Effect. Cross-references: [software architecture agent era](software-architecture-ai-agent-era.md), [LISP Curse thread](hn-coding-agents-replaced-frameworks.md), [harness engineering](harness-engineering-insights-and-practices.md).*
