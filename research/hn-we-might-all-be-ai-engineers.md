← [Insights](../insights.md) · [Index](../README.md)

## HN Thread Distillation: "We might all be AI engineers now"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47272734) (187 pts, 303 comments, 178 unique authors) · [Article](https://yasint.dev/we-might-all-be-ai-engineers-now/)

**Article summary:** A developer argues that AI has shifted the core skill of software engineering from writing code to knowing what to build and how it should work. With strong fundamentals, AI becomes a force multiplier — running multiple agents, shipping in hours what took days. Without that foundation, you just make bad decisions faster.

### Dominant Sentiment: Exhausted ambivalence masking a legitimacy crisis

The thread is split roughly 40/30/30 between cautious adopters, enthusiastic converts, and people who find the entire trajectory depressing. What's notable is not the disagreement but the *emotional register* — even the optimists sound defensive, and the skeptics sound less angry than resigned. The dominant feeling isn't "AI bad" or "AI good" but "I'm not sure I signed up for this version of the profession."

### Key Insights

**1. The article is its own best counterargument**

Multiple commenters flagged the post as AI-written. `jascha_eng` reported it to the mods, cataloguing tells: relentless "not X, but Y" pivots, zero tangential thoughts, every sentence trying to hit harder than the last. The author (`sn0wflak3s`) insists they wrote it themselves and added a post-edit clarification. The meta-irony is perfect: an article about how AI executes while humans provide taste and judgment... triggers a legitimacy crisis about whether a human actually wrote it. If your authentic voice is indistinguishable from LLM output, the "I designed it, the AI executed it" claim loses its rhetorical foundation. The thread noticed this before the author did.

**2. The "scope heuristic" is the thread's real contribution**

Buried in the comments, `sn0wflak3s` articulated a cleaner framework than the article itself: *"If the context you'd need to provide is larger than the task itself, just do it. If the task is well-defined and the output is easy to verify, let the agent rip."* This is the line the article dances around but never crisply states. Several experienced commenters (`overgard`, `JBorrow`, `kif`) converge on the same insight independently — AI is locally competent but globally incoherent, great at well-scoped functions but architecturally adrift.

**3. The cognitive load inversion nobody admits**

`kif`: *"LLM use leads to faster burnout and higher cognitive load. You're not just coding anymore, you're thinking about what needs to be done, and then reviewing it as if someone else wrote the code."* This reframes the "multiplier" thesis as a job redesign, not a productivity gain. You've traded the satisfying flow of writing code for the draining work of reviewing someone else's reasonable-but-not-quite-right output. `scott_s` names it precisely: *"AI effectively makes all of us tech leads."* The irony is that most engineers became engineers specifically to avoid being tech leads.

**4. The K-shaped workforce is already here**

`noemit`'s framing — that AI creates a K-shaped split between curious and incurious engineers — drew the sharpest responses. `_dwt` pushed back hard: *"It is very glib, and people will find it offensive and obnoxious, to implicitly round off all resistance or skepticism to incuriosity."* They enumerate reasons for resistance that aren't incuriosity: discomfort with the changed nature of work, fear of automation complacency, concern that learning from AI is ephemeral. The real K-split isn't curiosity — it's between people whose jobs happen to decompose into AI-suitable tasks and people whose work requires deep, persistent context that can't be serialized into a prompt.

**5. The "how do you actually know you're faster?" challenge**

`bryanrasmussen` asked the question the thread couldn't answer: *"Given all the studies showing that it doesn't make you faster, how are you so sure it does?"* The responses were revealing — `peteforde` got frustrated and essentially said "it's obvious, and if you can't see it you're incurious," which is circular. `prescriptivist` gave the most credible response: as a principal engineer on the same codebase for 10 years, they're finally chipping away at the nice-to-have backlog. But they also flagged: *"We are approaching a breaking point for code review volume"* — the multiplied output is creating a downstream bottleneck in the one process that can't be automated without undermining quality. The acceleration creates its own drag.

**6. The industrial revolution analogy cuts both ways**

`lll-o-lll`: *"We are this generation's highly skilled artisans, facing our own industrial revolution... just as the skilled textile workers were correct when they argued this new automated product was vastly inferior, it matters not at all."* `archagon` takes the opposite lesson: *"Agentic programming isn't engineering: it's a weird form of management where your workers don't grow or learn and nobody really understands the system you're building."* The thread wants the Luddite analogy to be either vindicating or cautionary, but it's actually both — the Luddites were right about quality *and* lost anyway. Nobody in the thread sat with that uncomfortable conclusion.

**7. The training pipeline problem remains unsolved**

`bambax` posed the sharpest structural question: *"How do you develop those instincts when you're starting up, now that AI is a better junior coder than most junior coders?"* `sn0wflak3s` admitted having no clean answer. `jinko-niwashi` argued AI is a "brutal mirror" that compresses learning. `godelski` demolished this: *"There's this belief that there are shortcuts to learning. That's a big mistake... It's exactly the same thing that leads people to conspiracy theories. They have such 'swiss cheese knowledge.'"* `jstanley` invoked the compiler analogy — people worried about this with assembly too. `bambax` dismantled that: a compiler is deterministic and validates input; AI transforms vague input into vague output nondeterministically. The compiler analogy is the thread's most popular cope and its weakest argument.

**8. The "I just don't want to do this" camp is larger than anyone admits**

`nabbed`: *"I'm glad I am no longer in tech because I just don't want to do this... that's the stuff I like doing."* `TRiG_Ireland` was made redundant and is looking for entirely new careers. `nbvkappowqpeop`: *"The recent AI developments have just taken the most fun part away from me."* `archagon`: *"It sounds like a hellish, pointless career and it's not what I got into the field to do."* This isn't Luddism — it's a preference shift. These are skilled practitioners who find the new workflow genuinely less enjoyable. The thread treats this as a feeling to be overcome rather than information about whether the new equilibrium is actually good.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| AI output is only locally good, globally incoherent | **Strong** | Multiple experienced devs converge here independently |
| Studies show no actual productivity gain | **Strong** | Nobody had a convincing rebuttal beyond "it's obvious to me" |
| Compiler analogy validates AI transition | **Weak** | Compilers are deterministic and validate; AI is neither |
| Environmental impact is disqualifying | **Misapplied** | Thread devolved into rebound-effect tangents; real but orthogonal |
| Professional licensure will save us | **Medium** | `_dwt` and `v3xro` argue for strict liability; plausible but slow |
| "Future of programming is English" | **Weak** | `red_hare`'s claim that code stops being relevant; `skydhash` correctly notes people are terrible at precise specification |

### What the Thread Misses

- **The review bottleneck is the real story.** If AI multiplies code output 5x but review capacity stays flat, the constraint just moved. `prescriptivist` touched this but nobody followed up. The profession isn't being automated — it's being restructured around the review function, which is harder, less fun, and doesn't scale.

- **Nobody discussed what happens to open source.** `20k` mentioned it once in a list. If AI makes code cheap to produce but review expensive, and open source depends on volunteer review, the ecosystem that trained the models is the first thing that degrades.

- **The enjoyment data is being ignored as soft.** Multiple experienced engineers said the work is less fun now. In a field with chronic burnout and where intrinsic motivation historically drove quality, this is a leading indicator, not a feeling to dismiss.

- **Nobody asked why the article needed an edit.** The author added a clarifying section after the thread pushed back — but the edit reads more like damage control than genuine reflection. The original article was maximalist; the edit walks it back to a moderate position that the *comments* constructed, not the author.

### Verdict

The thread circles a conclusion it can't quite state: AI coding tools have changed the *job description* of software engineering more than they've changed its *output*. The work is shifting from writing code to reviewing code, from flow-state problem-solving to managerial oversight of probabilistic systems. The people who love this transition are people who always wanted to be architects; the people who hate it are people who became engineers because they liked engineering. The article frames this as evolution. The thread, taken honestly, frames it as a loss — one that might be economically necessary but is being marketed as liberation.

The deepest irony: an article celebrating that "the skill is knowing what to build" was itself widely perceived as something that didn't know what it wanted to say — bouncing between celebration and hedging, eventually needing its own comment section to construct its actual thesis.
