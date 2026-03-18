← [Index](../README.md)

## HN Thread Distillation: "Ask HN: How is AI-assisted coding going for you professionally?"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47388646) · 388 points · 578 comments · March 2026

**Ask HN description:** OP (svara) explicitly wants to cut through the "we're all cooked" vs "AI is useless" split, asking for concrete professional experiences with context (stack, team size, experience level).

### Dominant Sentiment: Cautiously positive, deeply fractured

The thread is overwhelmingly not the binary OP feared — most commenters occupy a nuanced middle. But the fracture is along a different axis than expected: not "works vs doesn't" but **"works for me, destroying my team."**

### Key Insights

**1. The individual-vs-organization productivity paradox is the real story**

The thread's most striking pattern: the same person often reports AI as a personal superpower *and* an organizational burden. `hdhdhsjsbdh`: "It has made my job an awful slog, and my personal projects move faster." `queenkjuul`: "Invaluable for personal projects but a little bit take or leave at work... my manager uses Claude for EVERYTHING and is completely careless with it. Hallucinations in performance reviews, hallucinations in documentation, trash tier PRs."

The dynamic: AI amplifies *individual* velocity but degrades *collective* signal quality. PRs flood in faster than review capacity scales. Documentation becomes voluminous but unvetted. The people cleaning up the mess are invisible and unrewarded — `suzzer99` nails it: "you get about as much credit as the worker who cleans up the job site after the contractors are done, even though you're actually fixing structural defects."

**2. The "slop escalator" — AI is generating organizational dysfunction, not just bad code**

The most upvoted subthread (viccis, top comment) isn't about code at all. It's about managers generating 50-page design docs with Claude that nobody reads — including the authors. `BoneShard`: "What previously would take 30 mins, now takes a week. We had a performance issue with a DB... now there is a 37 page document with explanation, mitigation, planning, steps, reviews, risks, deployment plan." The slop isn't limited to code — it's metastasized into specs, tickets, PRDs, performance reviews. `solaire_oa` reports managers writing Jira tickets with "nonsense implementation details" that lead junior engineers astray. `prohobo` gets specs from freelance clients that are AI-inflated prose for what's actually a 30-row CSV.

This is a genuinely new organizational failure mode: **AI makes it cheap to produce artifacts that are expensive to consume.**

**3. Greenfield vs brownfield is the real capability boundary**

Across FAANG and non-FAANG reports, a consistent pattern: AI excels at greenfield/small-scope work and struggles with large, legacy, or highly interconnected codebases. `onlyrealcuzzo` (FAANG): "Non-professionally, it's amazing how well it does on a small greenfield task... But, at work, close to 0 so far." `wg0` offers the structural explanation: FAANG codebases use internal libraries/frameworks not in the training data, so the models "can't generate what they haven't seen." `stainlu` identifies the precise failure mode: "anything involving the interaction between systems... the model gives you a confident answer that addresses one layer and quietly ignores the rest."

Counter-evidence: `anyonecancode` and `jv22222` report strong results on large legacy codebases — but their use pattern is fundamentally different. They use AI as an *explorer/planner* on existing code, not a *generator* of new code into complex environments. That's the key distinction the thread mostly fails to articulate.

**4. The "driver's seat" pattern separates winners from losers**

Commenters reporting genuine productivity gains (2-5x) share a common workflow: they maintain architectural control, use AI for implementation/exploration, and invest heavily in documentation/rules files. `druide67`: "I own the architecture, make the decisions, validate everything. The key is a good CLAUDE.md file with strict rules." `alexmuro`: "I keep the bottleneck at my own understanding of the code." `trusche` describes multi-agent review loops. `x3n0ph3n3` emphasizes pre-existing documentation as the enabler.

Those reporting negative experiences share a different pattern: someone else generates code or specs with AI and dumps the review burden downstream. The tool isn't the variable — the organizational power dynamics around who generates and who reviews are.

**5. The expertise prerequisite is real and underappreciated**

`FpUser` articulates it bluntly: "I understand how everything works starting from the very bottom and am able to see good stuff from the bullshit... I have no idea how youngsters would train their brains." `ventana` (ex-FAANG): "It's never a 'single prompt' result. I think about the high level design and have an understanding of how things will work before I start talking to the agent." `owenpalmer`: "I don't let it generate anything that I couldn't have written myself."

The thread reveals a deepening two-tier dynamic: experienced engineers using AI as a force multiplier vs. less experienced engineers whose skill development is being short-circuited. `Izkata` reports a junior "seemed to get dumber over the past year, opening merge requests that didn't solve the problem." This is the atrophy concern made concrete.

**6. The productivity claims cluster around 2-5x with outlier noise**

Stripping away vibes and looking at concrete numbers: `chr15m` measured 2x issues closed. `humbleharbinger` claims 2-4x at work, >10x side projects. `ventana` estimates 4-5x on personal projects. `jwr` claims 12x (solo founder, self-measured). `lazy_afternoons` estimates their 3-person team replaces ~10 engineers.

The 10x+ claims come exclusively from solo/small-team contexts doing greenfield or personal work. Professional large-team environments cluster at 2-4x. Several FAANG engineers report ~0x or negative. The variance is enormous and context-dependent — single-number productivity claims are meaningless without specifying: greenfield/brownfield, team size, codebase age, and whether you count the downstream review burden.

**7. Claude Code has won the tool war (for now)**

Near-universal convergence on Claude Code as the best agentic coding tool. Cursor gets mentions for IDE-integrated work. GitHub Copilot autocomplete is divisive — `stainlu` dropped it ("interrupted my thinking more than it helped"). `KronisLV` describes a tool graveyard: Continue.dev, Aider, JetBrains AI, local models — all abandoned for Claude Code. `pjdkoch` casually drops "Cursor with GPT-5.4 puts me to shame" — one of the few OpenAI mentions. The thread is overwhelmingly Anthropic-centric.

**8. The expectations ratchet is already turning**

`ventana`: "the expectations are adapting to the new performance, so it's not like we are getting more free time." `morkalork`: "More work, shorter deadlines, smaller headcount, higher expectations." `casey2` admits using AI "not because it makes me more productive, but because it's better for my career." `spondyl` observes: "eventually you just normalise and the new 'speed' starts to feel slow again."

This is the treadmill effect: productivity gains are captured by the organization as new baseline expectations, not returned to engineers as slack. The engineers who opt out face career pressure, not just productivity pressure.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "You're just using it wrong" | Medium | Real skill gap exists, but dismisses legitimate structural limitations (brownfield, proprietary codebases) |
| "It's just autocomplete / a tool" | Weak | Undersells the agentic shift; people running 5 concurrent sessions aren't using autocomplete |
| "AI code is unmaintainable slop" | Medium | Valid for unsupervised generation; `philipp-gayret` counters that if you can generate it, you can regenerate it — plausible but unproven at scale |
| "Skills will atrophy" | Strong | Multiple concrete anecdotes of atrophy already happening; the Google Maps/paper map analogy from `philipp-gayret` is apt but doesn't address the failure mode when the GPS goes down |
| "Just review the AI output" | Misapplied | Ignores that review is cognitively expensive and doesn't scale; the bottleneck has moved from generation to comprehension |

### What the Thread Misses

- **Nobody discusses testing infrastructure as the actual enabler.** The successful users all have strong test suites, but they describe their success in terms of prompting skill or documentation. The real unlock is: AI + fast feedback loops (tests, CI, deployments) = productivity. AI + no automated verification = slop factory. `lnrd` hints at this ("giving the agent a way to autonomously validate its changes") but it's never elevated to a first principle.

- **The junior pipeline problem is acknowledged but never confronted.** `luisgvv`: "there are no Juniors, which is sad to see." Multiple people worry about skill atrophy. But nobody addresses the structural question: if juniors can't learn by writing code, and seniors are reviewing AI output instead of mentoring, where do the next generation of "experienced engineers who can use AI effectively" come from?

- **Security is hand-waved.** `spondyl` flags it but admits "I don't think any of this can be 100% secure as long as it has internet access." For a thread with 578 comments about professional coding, the near-total absence of security discussion is alarming — especially when people report running 5 concurrent AI sessions on monorepos or deploying from AI-generated code with `kubectl` access.

- **The cost question is barely touched.** `lnrd` mentions "tens of thousands of euro per month that could translate to 15/20 hires" but nobody does the actual math. If your 3-person team replaces 10 engineers but you're each burning $500+/month on API costs plus the hidden cost of review fatigue, burnout, and skill atrophy — what's the real ROI?

### Verdict

The thread reveals March 2026 as the moment AI-assisted coding graduated from a personal productivity tool to an **organizational coordination problem**. The technology works — that debate is effectively over for greenfield work and increasingly for brownfield exploration. But the thread circles without ever landing on the real emerging crisis: **the review bottleneck is the new bottleneck**, and nothing in the current toolchain addresses it. AI shifted the cost from generation to comprehension, and organizations haven't restructured around that shift. The enthusiasts are running faster; the skeptics are drowning in other people's output; and nobody has figured out how to make a team of AI-augmented developers more effective than the sum of their individual gains. The people having the best time are solo developers, which tells you everything about where the organizational problem lies.
