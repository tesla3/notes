← [Index](../README.md)

## HN Thread Distillation: "How I write software with LLMs"

**Source:** [stavros.io](https://www.stavros.io/posts/how-i-write-software-with-llms/) | [HN thread](https://news.ycombinator.com/item?id=47394022) (466 pts, 460 comments)

**Article summary:** Stavros describes a structured multi-agent workflow: Claude Opus as architect (planning/chat), Sonnet as developer (implementation), Codex/Gemini as reviewers. Includes a full annotated session adding email support to his personal assistant bot. Claims tens of thousands of reliable SLoC on projects where he knows the domain, admits failure when he doesn't. Uses OpenCode as harness. Key thesis: engineering skill has shifted from writing code to architecting systems.

### Dominant Sentiment: Skeptical respect, mounting fatigue

The thread is tired of "how I use LLMs" articles but engages seriously because the article is unusually concrete. The annotated session transcript — showing actual back-and-forth, corrections, and a security edge case catch — elevated it above the typical workflow post. But when commenters inspected the actual output (Stavrobot repo), the mood shifted hard.

### Key Insights

**1. The multi-model pipeline is a proxy for the real question: does splitting roles add value, or just legibility?**

`akhrail1996` opens with the thread's sharpest question: "what's the evidence that the architect → developer → reviewer pipeline actually produces better results than just... talking to one strong model in one session?" `arialdomartini` ran a direct A/B test with colleagues — multi-agent hierarchy vs. same instructions fed to Claude Code directly — and found the results "comparable." The author's three stated reasons (cost savings, cross-model review, capability separation) are pragmatic rather than quality-driven. The honest answer may be that the pipeline serves the *human* more than the code: it forces structured decision-making and creates legible artifacts. `jumploops` confirms this — they write plans to markdown files as "anchored decisions" primarily to avoid regressions across sessions, not because the LLM needs them.

**2. The code quality gap is the article's load-bearing blind spot.**

`danbruc` did what most commenters don't: read the actual Stavrobot source. The verdict was damning — "no structure, everything bunched together, one line after the other... almost no function calls to provide any structure." A 200-line function implementing everything inline where a simple switch/dispatch would do. `never_inline` nails the mechanism: "The clankeren are super bad at [class/interface-level design]. They treat everything as a disposable script." The author's response — "it works really well... it wasn't really meant to be readable" — reveals the core tension. The article claims "each change being as reliable as the first one" but the codebase shows the classic LLM pattern: functional correctness with zero structural investment. `ossianericson` distills it: "Bad architecture doesn't look like a crash. It looks like a codebase that works today and becomes unmaintainable."

**3. The failure mode confession is the most valuable part — and the thread knows it.**

`devlinMckhay`: "you miss one bad architectural decision because you are tired or in a hurry, and three sessions later the llm is confidently making it worse and you are not even sure when it started going wrong." This matches the author's own admission that on unfamiliar tech, code "quickly becomes a mess of bad choices." `neonstatic` spots the contradiction: if LLM code is a mess when you don't know the domain but fine when you do, the variable isn't the LLM — it's the human. The LLM is generating roughly the same quality either way; your domain knowledge is what rescues it.

**4. The greenfield/brownfield divide remains the unspoken filter on all LLM productivity claims.**

`rednafi` is blunt: "everyone yapping about how great AI is isn't actually showing the tools' capabilities in building greenfield stuff. In reality, we have to do a lot more brownfield work that's super boring, and AI isn't as effective there." Every project the author lists is greenfield, solo, and personal. `kul_` adds the other half: "the place where you really need help is the intersection of domain and tech. LLMs need a LOT of baby sitting to be somewhat useful here." The article's workflow may work beautifully for its context but says nothing about the majority of professional software work.

**5. The maintainability crisis is approaching faster than the tooling to manage it.**

`TacticalCoder` makes the systemic argument: "By definition, unless the AIs can maintain that code, nothing is maintainable anymore: the reason being the sheer volume. Humans who could properly review and maintain code are already outnumbered." This is the thread's most forward-looking claim. The author's Stavrobot has been running for "close to a month" — that's not maintenance, that's launch afterglow. The real test is year two, when requirements shift and accumulated inline code resists refactoring. The thread circles this but nobody connects it to the tooling gap: we need theorem provers, coverage analysis, and structural linters scaled to AI output volume, and none of that exists yet.

**6. The "polite prompting" tangent reveals how unsettled the fundamentals still are.**

`cpt_sobel`'s question — does proper grammar in prompts actually matter? — spawned 20+ replies and zero evidence. `kqr` offers the best hypothesis: it mattered more when user prompts were a larger fraction of context, now system prompts dominate. `stavros` (the author): "The LLM doesn't care, but I do." The real insight from `vikramkr`: models that reveal reasoning traces "spend way too many tokens complaining about the typo" when given sloppy input, suggesting prompt style affects *internal resource allocation* even if final output seems comparable.

**7. The "where are the billion-dollar IPOs" challenge remains unanswered.**

`codeflo`: "if the productivity claims were even half true, those '1000x' LLM shamans would have toppled the economy by now." `zingar`'s response separates the problem well — writing code is solved, organizing it is being solved, *finding problems worth solving* is a completely different problem. But `ugtr3`'s counter is sharp: "Come on you're taking the piss, surely." The productivity is real but scoped: it accelerates execution of ideas you already have, in domains you already understand, on greenfield projects. That's a narrow slice of economic value creation.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Multi-agent is just ceremony over single strong model | Medium | One A/B test showed comparable results, but sample size of 1. Cost argument is valid. |
| The actual code produced is poor quality | Strong | Multiple commenters independently verified structural issues in Stavrobot source |
| This only works for greenfield solo projects | Strong | All examples are personal projects; no evidence of team/brownfield applicability |
| "Each change as reliable as the first" is unfalsifiable at 1 month | Strong | Maintenance burden hasn't materialized yet because there's been no maintenance period |
| The workflow will be obsolete in weeks | Weak | Core pattern (plan → implement → review) is model-agnostic; specific model names change, structure doesn't |
| GPL laundering / ethical concerns | Medium | `cousin_it` raises it; thread mostly ignores it. Real issue, wrong venue. |

### What the Thread Misses

- **Nobody asks about test coverage or correctness verification.** The author mentions "421 tests passing" but no one examines whether those tests are meaningful or whether LLM-generated tests suffer from the same "agreeing with itself" problem the author identifies for code review. If the same model wrote the code and the tests, the tests may validate the implementation rather than the specification.
- **The cost analysis is absent.** Multiple Opus sessions for architecture, Sonnet for implementation, Codex + Gemini for review — on a personal project. What does this workflow cost per feature? Nobody asks.
- **The YOLO security question goes unanswered.** `benterris` asks if everyone runs agents with full machine access. `neobrain` mentions Claude's sandbox mode is disabled by default. Thread moves on. This is a real operational risk that the community is collectively ignoring.

### Verdict

The article is unusually honest for the genre — the failure mode section alone is worth the read. But it inadvertently demonstrates the very problem it claims to have solved. The annotated session shows a skilled engineer catching edge cases (email wildcard injection, missing owner identity seeding) that the multi-agent pipeline missed entirely. The system works *because* the human is good, not because the pipeline is good. Strip the human expertise and you get Stavrobot's actual codebase: functional, structureless, and one year away from being rewritten from scratch. The thread's real conclusion, never quite stated: LLMs have made the gap between "it works" and "it's well-made" wider than ever, and the workflows people are building optimize for the former while claiming the latter.
