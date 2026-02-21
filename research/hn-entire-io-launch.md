← [Index](../README.md)

## HN Thread Distillation: "Ex-GitHub CEO launches a new developer platform for AI agents"

**Source:** [HN thread](https://news.ycombinator.com/item?id=46961345) (611 points, 577 comments) · [Article](https://entire.io/blog/hello-entire-world/) · Feb 2026

**Article summary:** Thomas Dohmke (ex-GitHub CEO) launches Entire.io with a $60M seed round ($300M valuation). The first product, "Checkpoints," is a CLI that captures agent session context (transcripts, prompts, files touched, token usage, tool calls) and associates it with git commits in a separate branch. The long-term vision is a three-layer platform: a new git-compatible database, a semantic reasoning layer, and a UI — to own the "intent and reasoning" layer of AI-assisted development.

**Article critique:** The blog post is nearly content-free — multiple commenters couldn't determine what the product does. The New Stack interview (Dohmke separately) reveals the actual vision: "We are moving from [files and folders] to a much higher abstraction — specifications, reasoning, session logs, intent, outcomes. And we believe that requires a very different developer platform than what GitHub is today." That's a real thesis. Burying it under "The game has changed. The system is cracking." marketing prose guaranteed the hostile reception.

### Dominant Sentiment: Contemptuous and unusually unified

This might be the most negative 600-point HN thread I've seen. The ratio of hostile to supportive comments is roughly 5:1. Notably, the negativity isn't split along usual lines (AI skeptics vs. boosters) — even heavy AI-coding users are dismissive because they've already built their own versions.

### Key Insights

**1. The "I already do this" chorus is the real product-market signal — and it cuts both ways**

An extraordinary number of commenters describe homegrown solutions: woah has agents write structured run logs per session, Aeolun uses CURRENT_TASK.md, visarga uses task.md files with git hooks, vardalab stores session IDs in Gitea issues, ChicagoDave has a dedicated work-summary-writer agent, vidarh notes Claude Code already stores JSONL sessions you can trivially hook into commits. The thread surfaces at least a dozen DIY implementations. This validates the problem while demolishing the product: everyone agrees agent context is valuable, nobody thinks you need a funded startup to capture it. benterix crystallizes it: "We explained why: their moat is trivial to replicate."

**2. The $60M seed is the product, not the CLI**

The thread understands this instinctively. sillyconwalle's satirical VC dialogue (the top comment) ends with: "Here's 60M for you, wine and dine your friends with it." The actual product thesis — a new git-compatible distributed database for agent reasoning — is invisible behind the CLI launch. What VCs funded is Dohmke's Rolodex and the bet that whoever controls the agent-trace layer becomes the next GitHub. The CLI is a data collection trojan. pistoriusp says it directly: "The VC's didn't give Dohmke $60m to build a new frontend for Git... They're going to capture your conversations and code with AI and use that to train better models which they'll rent back at you." agnosticmantis agrees: "The data here will be more valuable than gold for doing RL training later on." The thread circles this insight but never connects it to why the blog post is deliberately vague — saying the quiet part out loud would kill adoption.

**3. thom's razor exposes the temporal paradox**

thom delivers the thread's sharpest single sentence: "Either the models are good and this sort of platform gets swept away, or they aren't, and this sort of platform gets swept away." This names a real problem with Entire's timing. If models improve enough to maintain coherent context across long sessions (which is where they're trending), the need to externally capture and replay reasoning diminishes. If they don't improve, the captured reasoning from inferior models becomes worthless for future sessions. The only scenario where Entire thrives is a narrow middle band: models good enough to generate useful traces but bad enough to need them replayed — and that band has to persist long enough to build a business. zhyder develops this: "Fresh context is also better at problem solving... I didn't save all my intermediate thinking work anywhere."

**4. The real vision is buried and nobody engages with it**

In the New Stack interview, Dohmke describes a three-layer platform with "a new Git-compatible database built from scratch" as its foundation, designed to be globally distributed and queryable for reasoning, not just code. This is orders of magnitude more ambitious than the CLI — it's a bet that the SDLC's source of truth shifts from code to intent, and whoever builds the database for intent wins. The thread never engages with this because the blog post never mentions it. Dohmke announced a git hook when he's actually building a database. This is either brilliant stealth (ship small, build big) or a catastrophic communication failure that poisons the well with early adopters. The thread's reaction suggests the latter.

**5. The "agent observability" framing is directionally correct but the execution is premature**

willmarquis, in the thread's most thoughtful comment, tries to rescue the vision: "The interesting bet here isn't git checkpoints — it's that someone is finally building the observability layer for agent-generated code... The markdown-files-in-git crowd is right that simple approaches work. But they work at small scale. Once you have multiple agents across multiple sessions generating code in production, you hit the same observability problems every other distributed system hits." This is the strongest steel-man. But even willmarquis concludes: "I'm skeptical — but the underlying insight (agent observability > agent orchestration) seems directionally correct." The problem is timing: the 10-person team running a dozen agents in parallel is currently a rounding error of the developer population, and by the time it's mainstream, the agent platforms themselves will have built this in. ef2k names the squeeze: "GitHub or GitLab could build the same capabilities and become a natural extension of what teams already use."

**6. The HN developer-tools reflex is actually correct this time**

HN's default cynicism toward funded developer tools is often wrong — Docker, Vercel, and Linear all survived similar threads. But the "this time is different" defenders (lubujackson: "$60M doesn't just fall in your lap without a clear plan"; bmurphy1976 comparing it to Docker) can't articulate what the product does better than a bash script. Docker had a genuine technical primitive (containers) that individuals couldn't replicate. Entire's primitive (a structured commit message) is something multiple people built at hackathons: ramoz built it in a weekend, EngineerBetter made it in spare time last week, btucker built and abandoned a similar tool months ago. When the "I built this in a weekend" crowd includes people who *also abandoned it because it wasn't useful*, the signal is damning.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "You don't understand the vision / too negative" | Weak | Defenders can't articulate what Entire does that a script can't, only that $60M implies hidden depth |
| "This is like Docker, you'll get it later" | Weak | Docker had a novel technical primitive; this has a git hook. The analogy fails at the foundation |
| "The data/training-data play justifies the round" | Medium | Plausible but unverifiable, and if true, means the product serves VCs' interests more than developers' |
| "Agent observability at scale is a real problem" | Strong | Directionally correct but premature — the scale doesn't exist yet and incumbents will build it first |
| "HN is just anti-AI" | Misapplied | Thread is full of heavy AI-coding users who are dismissive *because* they use agents daily and already solved this |

### What the Thread Misses

- **Nobody asks about the enterprise compliance angle.** Regulated industries (finance, healthcare, defense) will soon need audit trails for AI-generated code — not "who committed this" but "which agent wrote this, what was its reasoning, did it follow approved specifications, and can we reproduce the decision chain?" EU AI Act-style regulation will make this mandatory, not optional. Bash scripts don't pass SOC 2 audits. This is probably the actual enterprise sales pitch that justifies the round, and the thread's "I can do this myself" crowd is precisely the wrong audience to evaluate it.
- **The thread doesn't distinguish between "capture" and "retrieval."** Everyone can save agent context. The hard problem is making it useful later — searchable, queryable, cross-session, across team members. MarcelOlsz asks "how do you handle the retrieval aspect?" and gets no answer. That's the actual product challenge nobody explores.
- **No one discusses what happens to agent traces at organizational scale.** A team of 50 engineers each running 10 agent sessions a day generates an enormous volume of reasoning data. Whether that data is noise or gold is an open question nobody probes.
- **The thread ignores that Dohmke may be right about the *direction* while wrong about the *timing*.** Five years from now, something like this may be essential infrastructure. The question is whether it's a $60M-seed-in-2026 idea or a $5M-seed-in-2029 idea.

### Verdict

The thread treats Entire as a product launch and judges it as a product. It's not — it's a land grab disguised as a product launch. The CLI is the minimum viable data-collection mechanism; the $60M funds a bet that agent reasoning traces become a new category of valuable data (for training, compliance, or collaboration) and that whoever controls the schema and storage wins. The thread is right that the current product is trivial. It's wrong to conclude that the company is therefore trivial — but only if Dohmke can build the database layer and the network effects before GitHub adds "agent traces" as a checkbox feature, which at Microsoft's current pace gives him maybe 18 months. The meta-irony: the ex-CEO of GitHub is betting that GitHub can't adapt fast enough, but the reason GitHub can't adapt fast enough is the institutional inertia he helped create.
