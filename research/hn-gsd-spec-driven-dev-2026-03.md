← [Index](../README.md)

## HN Thread Distillation: "Get Shit Done: A meta-prompting, context engineering and spec-driven dev system"

**Source:** [HN](https://news.ycombinator.com/item?id=47417804) · 394 points · 212 comments · 2026-03-17
**Article:** [GitHub repo](https://github.com/gsd-build/get-shit-done) — a Claude Code plugin that imposes a structured spec → plan → execute workflow with subagents, verification steps, and autonomous multi-phase execution.

**Article assessment:** GSD is a collection of markdown skills, JS helper scripts, and prompt pipelines that wrap Claude Code into a waterfall-ish flow: research → spec → plan → execute → verify, with subagents at each stage. The README leads with "250K lines in a month" and recommends `--dangerously-skip-permissions` as the intended workflow. No examples of shipped production systems. The value proposition is discipline-by-prompt — forcing structure that vanilla Claude Code doesn't enforce. The tension is whether that structure is worth the token cost and rigidity.

### Dominant Sentiment: Skeptical pragmatism from practitioners

The thread is unusually experience-dense. Most commenters have actually *tried* GSD (or its competitors: Superpowers, OpenSpec, PAUL, BMad). The dominant mood is "I tried it, it burned tokens, I went back to something simpler" — but there's a meaningful minority who swear by it. The split maps cleanly to project type: greenfield toy apps vs. existing codebases with real constraints.

### Key Insights

**1. The spec-driven harness market has already commoditized — and nobody's winning**

GSD, Superpowers, OpenSpec, PAUL, BMad, ECC, Oh-My-OpenAgent, acai.sh — the thread names at least 8 competing systems, all doing roughly the same thing (structured prompt → plan → execute). Nobody has breakaway traction. The real tell: multiple commenters describe stripping these systems down to 30% of their features and getting better results. As `esperent` puts it: *"There's a kernel of a good idea in there but I feel it's something that we're all gradually aligning on independently, these shared systems are just fancy versions of a 'standard agentic workflow'."* The implication is that the kernel — "write a spec, review it, then execute" — is trivially implementable and doesn't need a framework.

**2. The token economics are brutal and nobody's measuring ROI**

This is the thread's most consistent signal. `MeetingsBrowser`: *"hit the 5-hour limits in ~30 minutes and my weekly limits by Tuesday with GSD."* `sigbottle` spent $25 on 500 LOC. `DamienB` found GSD took "hours instead of minutes" for the same task as Plan Mode. `vinnymac` gave up after a week: too much back-and-forth, too many tokens, too much human-in-the-loop. `gtirloni` — the top comment — abandoned both GSD and Superpowers for native Plan Mode. The pattern: these harnesses multiply token consumption by 5-10x while adding planning ceremony that's orthogonal to code quality.

**3. The validation gap is the actual unsolved problem — and the thread knows it**

The sharpest insight comes from `Andrei_dev` and the subthread it spawns: *"All these frameworks are racing to generate faster. Nobody's solving the verification side at that speed."* `kace91` lands the perfect reframe: *"Code is a cost... Saying 'I generated 250k lines' is like saying 'I used 2500 gallons of gas'."* `CuriouslyC` links a blog post ("Stop Orchestrating, Start Validating") arguing that orchestration is irrelevant when you can't validate what you're producing. `joegaebel` makes the strongest technical case: natural language specs can't be systematically verified against running code — only executable tests can. `knes` cites a paper showing 80% of agent-authored PRs needed human fixes, with the #1 rejection reason being missing context. The thread circles a stark conclusion: the entire spec-driven movement is optimizing the wrong side of the pipeline.

**4. The "250K lines" claim is a credibility Rorschach test**

`prakashrj`'s claim of writing 250K lines in a month with GSD provoked the thread's most revealing exchange. Multiple commenters challenged it: `tkiolp4` (*"I got a promotion once for deleting 250K lines"*), `icedchai` (*"This does not feel like 250K lines of complexity"*), `rsoto2` (*"I could copy 250k lines from github. Faster."*). When pressed, `prakashrj` admitted: *"I didn't look at code."* This is the thread's meta-irony: GSD's marquee success story is someone who generated a quarter-million lines they never read, for a VPN manager that doesn't obviously need that much code. It validates every skeptic's concern about generation without verification.

**5. Plan Mode ate the harness market from below**

The most actionable signal: Claude Code's native Plan Mode (shift-tab) has quietly become "good enough" for most users. `gtirloni` (top comment, well-reasoned): Plan Mode + manual steering beats GSD/Superpowers. `healsdata` ran both on the same task: Plan Mode finished in 20 minutes, GSD took hours. `btiwaree` after a hackathon: *"don't overcomplicate — write better specs, use claude plan mode, iterate."* The harness builders are in a squeeze: models keep absorbing the features that justified the harness. `observationist` names the dynamic explicitly: *"They're going to be a temporary thing — a hack that boosts utility for a few model releases until there's sufficient successful use cases in the training data."*

**6. The real workflow convergence is simpler than any framework**

Across dozens of experience reports, the pattern that actually works keeps emerging: write a clear spec (in any format — markdown, YAML, even bullet points), have the LLM review it, then execute in small chunks with human checkpoints. `visarga` ran evals and found *"the planning ceremony is mostly useless, claude can deal with simple prose, item lists, checkbox todos, anything works"* — but plan-review and work-review subagents from *separate* contexts did pull their weight. `coopykins`: *"Just Plan, Code and Verify, simple as that."* `Franny`: start with requirements, ask for step-by-step plan, greenlight each step individually. The frameworks are ceremony around a 3-step loop that doesn't need ceremony.

**7. The security model is `--dangerously-skip-permissions` and nobody's okay with it**

`ibrahim_h` delivers the thread's best technical analysis: GSD's plan-checker verifies logical completeness but never inspects what commands will actually run. The verifier runs *after* execution, checking outcomes not safety. The granular permissions fallback only covers reads and git ops — insufficient for actual GSD operation. `rdtsc` asks the obvious: *"Is this supposed to run in a VM?"* The answer appears to be "yes, but nobody says so." This is a structural problem for all autonomous agent harnesses, not just GSD, and the thread treats it as an afterthought.

**8. Existing codebases are the real test — and every framework fails it**

`DIVx0` offers the most technically detailed failure report: GSD works for greenfield but *"the project gets too big and GSD can't manage to deliver working code reliably. Agents working GSD plans will start leaving orphans all over."* `dhorthy`: *"it is very hard for me to take seriously any system that is not proven for shipping production code in complex codebases."* `noduerme`'s detailed account of refactoring a 500K LOC codebase — bouncing between OpenClaw, Paperclip, and Claude Pro — is the thread's most honest report of the actual complexity of real-world AI-assisted development. Nobody in the thread claims success with GSD on a mature codebase.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Just use Plan Mode" | Strong | Multiple independent confirmations with direct A/B comparisons |
| "Burns too many tokens" | Strong | Consistent across 6+ commenters with specific numbers |
| "Waterfall doesn't work for iterative dev" | Strong | `galexyending`: impossible to adjust phases when bugs arise |
| "250K lines proves it works" | Weak | The poster admitted to not reading the generated code |
| "AI can audit/review itself" | Medium | Works for catching surface bugs; no evidence it catches architectural drift |
| "These frameworks are temporary" | Strong | Models are absorbing the features; Plan Mode already replaced most value |

### What the Thread Misses

- **No one discusses formal verification or property-based testing as the actual answer to the validation gap.** The thread identifies the problem (can't verify at generation speed) but only proposes more LLM-based review, which has the same trust problem. Mutation testing gets one mention.
- **The economic incentive structure is perverse.** These harnesses burn 5-10x tokens. The harness creators are often API resellers or have API partnerships. Nobody in the thread connects these dots.
- **Zero discussion of what happens when the spec and the code diverge over time.** Every spec-driven system assumes the spec stays authoritative. In practice, after 3 iterations, the code *is* the spec and the markdown is stale. `joegaebel` gets closest but doesn't name the inevitable entropy.
- **The "I built a SaaS with AI" comments are all greenfield hobby projects.** Not one commenter describes using GSD (or any harness) to ship features in a team environment with code review, CI, and other engineers touching the same code.

### Verdict

The thread reveals a market in the "trough of disillusionment" phase: early adopters have tried the spec-driven harnesses, found them slow and token-hungry, and are reverting to simpler workflows. The harnesses solved a problem that existed for about 6 months — the gap between "Claude can code" and "Claude has Plan Mode." Now that the models themselves are internalizing planning capabilities, the harness layer is being squeezed from below. The real unsolved problem — validation at generation speed — isn't a prompting problem at all; it's a testing infrastructure problem. The thread circles this truth repeatedly but never lands on it because the participants are prompt engineers, not test engineers. The most telling absence: in 212 comments about "getting shit done," nobody ships a demo, a benchmark, or a before/after comparison. It's all anecdote and vibes — which is exactly what these frameworks claim to eliminate.
