← [Index](../README.md)

## HN Thread Distillation: "Grief and the AI split"

**Article summary:** lmorchard (40+ year programmer) argues AI coding is exposing a pre-existing divide: "craft lovers" who valued the texture of writing code vs. "make-it-go" people who always cared about results. Both sat side by side doing identical work before AI; now their different motivations are visible because they're making different choices. His own grief isn't about the craft — it's about the ecosystem, the economy, the open web eroding around it.

### Dominant Sentiment: Skeptical agreement, uneasy self-sorting

The thread broadly accepts that a divide exists but pushes back hard on the binary framing. Most commenters resist being cleanly categorized, and the sharpest voices argue the real fault line is about quality standards and economic fear, not aesthetic preference.

### Key Insights

**1. The binary collapses on contact with reality**

Nearly every experienced commenter rejects the clean dichotomy. `epolanski` gives the strongest counter: antirez spent two weeks interrogating LLMs about Redis design — zero lines generated, months of design work compressed. "Am I a craft lover or a result chaser?" `wiml` nails the deeper issue: "I think the real divide we're seeing is between people who saw software as something that is, fundamentally, improvable and understandable; and people who saw it as a mysterious roadblock foisted upon them by others." The article's framing is comforting precisely because it's reductive — it lets both sides feel validated rather than confronting the messier truth that motivations are entangled.

**2. The livelihood grief dwarfs the craft grief**

`nlawalker` makes the sharpest observation: "it's the livelihood that's gone, not the craft. There's never been a better time to practice the craft itself." `rimunroe` extends this painfully: "I've felt incredibly lucky for over a decade that my work gave me the opportunity to chase that... I'd have to do it on my own time. That would mean sacrificing time I've previously spent on other interests, and I don't have a ton of time to begin with." This is the thread's most honest moment — the real grief is losing the *coincidence* of passion and paycheck, not the ability to write code.

**3. The "moving up a level" metaphor is doing illegitimate work**

`umanwizard` fires the cleanest shot: "People who say directing an AI is just 'moving up another level of abstraction' are missing the point that it's a completely different kind of work. Everything from machine code to Haskell is a predictable deductive logical system, whereas AIs are not." `dang` agrees it's "different, but it isn't completely different." This is the unresolved philosophical core — the author's central argument (assembly→functions→systems→AI direction) breaks because every prior step preserved determinism. The new step doesn't.

**4. CharlieDigital's .md-as-code system is the thread's most concrete vision — and its most contested**

`CharlieDigital` describes an elaborate system: .md specs as the new code, MCP servers for doc delivery, OTEL telemetry on agent behavior, AI code review skills encoding senior heuristics. `jacquesm` immediately identifies the failure mode: review fatigue when humans are reduced to rubber-stamping. Charlie's response — that the docs improve in a feedback loop until reviews become unnecessary — is either prescient engineering or the most dangerous idea in the thread. `g-b-r`: "There will never be a point when human reviews will be less needed; you're doomed to ship something horribly insecure at some point."

**5. The "10x" claims are empirically empty**

`kace91` delivers the thread's best reality check: if everyone's 10x now, where are the results? "Did you see the last iOS version pack a decade worth of features? Do you remember when Meta moved their backend to Rust in a month?" Nobody has a good answer. `kypro` provides the math: if you only spent 20-30% of your day coding before, AI coding assistance *mathematically cannot* make you 10x. `sarchertech` confirms from the result-chaser side: "maybe somewhere in the order of 10% all in."

**6. The ground truth from the trenches is damning**

`scuff3d`: "60k lines of code for something that should have been simple, and it's an absolute fucking mess. I'm gonna have to rip out most of it and start over." `kypro` watches colleagues who can't read code spit out thousands of lines daily, building separate mobile pages instead of responsive designs because Claude won't say no. `burningChrome` reports a massive healthcare company putting AI agents into billing and DevOps. The thread's boosters talk about what's possible; the practitioners talk about what's actually shipping.

**7. The LLM-voice meta-irony**

`furyofantares` calls out the article itself as having been run through an LLM. The author (`lmorchard`) admits using one for "clarity and tightening" but insists the voice is his own. `dang` weighs in with a broader observation: "It's increasingly clear that the LLMs leave more of a mark than authors realize... That's why readers end up reacting to the LLM imprints rather than the content." `furyofantares` compares the blog voice to lmorchard's HN comments: "In your comments it's clear someone writing it cares about things." A blog post about AI grief gets its emotional authenticity questioned because AI touched it — the irony is structural.

**8. The "ideas are worthless" bomb**

`kace91`: "If we end up in a place where the craft truly is dead, then congratulations, your value probably just dropped to zero. Everyone who's been around startup culture knows the running jokes about those 'I have a great idea, I just need someone to code it' guys. Now you're one." This is the argument the result-chasers never engage with. If directing AI is easy, then the director is as replaceable as the coder.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "It's not a binary — I'm both" | Strong | Thread consensus; article's framing is too clean |
| "The real divide is quality standards, not motivation" | Strong | `rudedogg`, `sarchertech`, `kalalakaka` converge here |
| "10x claims have no evidence" | Strong | Nobody produces measurable macro-outcomes |
| "Craft just moved up a level" | Medium | Breaks on the determinism objection (`umanwizard`) |
| "AI code is fine with good docs/process" | Medium | CharlieDigital's system is impressive but unfalsified |
| "AI is ethically bankrupt, refuse it" | Weak-to-Medium | `jaredcwhite` argues this passionately but it's a moral stance, not an analytical one |

### What the Thread Misses

- **Nobody discusses what happens to taste when nobody reads code anymore.** CharlieDigital's system assumes future humans will still be able to judge AI output. But taste atrophies. If juniors never develop deep code-reading skills, who writes the .md files in 2035?

- **The economic argument cuts the other way too.** If AI makes coding trivially cheap, it also makes *bad* coding trivially cheap. The flood of low-quality software may actually *increase* demand for people who can debug, audit, and fix — exactly the craft skills supposedly being mourned. `antonvs` and `scuff3d` hint at this but nobody follows the thread to its conclusion.

- **The "open web" grief and the "craft" grief are connected.** lmorchard separates them but they share a root cause: concentration of power. The same economics that let a few companies scrape the commons to train models also let them commoditize the labor that built the commons. The craft grief is downstream of the ecosystem grief, not parallel to it.

- **Nobody mentions what happens to open source.** If contributing is now "let my agent submit a PR," and reviewing is now a bottleneck manned by exhausted humans, the production model of open source breaks before the consumption model does.

### Verdict

The thread circles but never names the actual mechanism: AI coding doesn't split craft-lovers from result-chasers — it splits people who have *legible taste* from people who don't. The real question isn't whether you enjoy writing code; it's whether you can recognize when software is good, explain why, and encode that judgment in a form machines can follow. That's what CharlieDigital is actually building, what `kypro` is watching erode in real time, and what the mourners are afraid of losing the capacity to develop. The grief isn't about code. It's about the slow-motion loss of the ability to know when something is wrong — and the dawning suspicion that once that's gone, nobody will notice.
