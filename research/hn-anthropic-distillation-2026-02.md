← [Index](../README.md)

## HN Thread Distillation: "Anthropic announces proof of distillation at scale by MiniMax, DeepSeek, Moonshot"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47126614) (120 pts, 117 comments, 82 unique authors) · [Anthropic blog post](https://www.anthropic.com/news/detecting-and-preventing-distillation-attacks) · Feb 23, 2026

**Article summary:** Anthropic published a detailed blog post naming DeepSeek, Moonshot (Kimi), and MiniMax as having created ~24,000 fraudulent accounts generating 16M+ exchanges with Claude to extract capabilities via distillation. The post frames this as a national security threat, ties it to export control enforcement, and calls for coordinated industry/government response. It was published the same day Anthropic execs met with Pete Hegseth.

### Dominant Sentiment: Contemptuous, near-unanimous mockery

The thread is 90%+ hostile to Anthropic. Nearly every top-level comment invokes the hypocrisy of a company that trained on the internet's copyrighted output complaining about others training on *its* output. The few pro-Anthropic voices get ratio'd hard. This isn't a debate thread — it's a pile-on with a few substantive veins running through it.

### Key Insights

**1. Anthropic wrote this for Congress, not for Hacker News**

The blog post's audience is not the developer community — it's policymakers. `notatoad` nails the context: "this blog post should be read in the context of anthropic execs meeting with Pete Hegseth today — this isn't legal, it's political." The language ("national security risks," "Chinese Communist Party," "export controls") maps directly onto the No Adversarial AI Act bill introduced June 25, 2025. Anthropic is building a paper trail for regulatory capture disguised as a security disclosure. `NitpickLawyer`: "they're not writing for us, they're writing for 'the regulators.'" The thread sees through it instantly, but the thread isn't the target audience.

**2. The 16M sessions number is a self-own**

`falcor84` catches what Anthropic missed: "my main take away is that ~16 million sessions is enough to distill Claude. That's extremely doable." `snowhale` concurs: "the 16M session number is the real data point here. that's not a huge moat by any standard." By publishing exact figures, Anthropic inadvertently revealed that its competitive moat is thinner than anyone assumed. The blog post meant to say "look how aggressively we're being attacked"; the thread reads "look how cheaply you can be replicated." This is the central irony Anthropic's comms team apparently didn't model.

**3. The hypocrisy framing is dominant but hides a real monoculture risk**

The thread's consensus — that Anthropic has no standing to complain given its own training practices — is so overwhelming it drowns out `ashertrockman`'s genuinely important point: "I think it's bad if every model is downstream of a couple 'frontier' models. It's an issue of monoculture, like in cybersecurity more generally." If every Chinese open-weight model is fundamentally a distillation of Claude/GPT, the apparent diversity in the ecosystem is illusory. Failure modes, biases, and vulnerabilities would correlate. The thread barely engages with this because the hypocrisy narrative is too satisfying.

**4. The logicprog/ashertrockman exchange is the thread's intellectual core**

The longest and most substantive sub-thread features `logicprog` (pro-distillation, anti-IP) vs. `ashertrockman` (nuanced concern). Their exchange reveals a genuinely important reframing: the safety concern isn't traditional AI safety theater (bioweapons, etc.) — it's **agentic security**. `ashertrockman`: "now that people are actually using LLMs as agents to *do things*, and interact with the open web… the safety and security concerns make a lot more sense to me. I don't want my agent to read an HN post with a social-engineering-themed prompt injection attack and mail my passwords to someone." This is the real safety gap that distilled-then-de-safeguarded models widen, and it's orthogonal to the geopolitical framing Anthropic chose.

**5. Z.ai's absence from the accused is the dog that didn't bark**

`Imustaskforhelp` writes the thread's most detailed investigative comment, noting that Z.ai (GLM-5) and Qwen are conspicuously absent from Anthropic's accusations. If GLM-5 achieves comparable performance without distillation, it undermines Anthropic's implicit claim that distillation is the *primary* mechanism closing the gap. The commenter also notes Moonshot/Kimi's Alibaba backing and speculates about data sharing between Kimi and Qwen — a plausible vector Anthropic doesn't address. This is underexplored but significant: if non-distillation paths to frontier-adjacent performance exist, the entire regulatory argument collapses.

**6. Anthropic's "fraudulent accounts" framing is doing heavy legal lifting**

`devnonymous` asks the obvious: "What exactly makes these accounts fraudulent… did they not pay Anthropic for the service?" The blog post uses "fraudulent" 6+ times but the actual violation is TOS breach and regional access circumvention — not fraud in any legal sense. `paxys` catches the litigation risk: "This tweet is 100% going to show up in court… as an example of Anthropic accepting that copyright infringement and unauthorized use hurts their business as an IP holder." Anthropic's own distillation complaints become evidence *against* it in existing copyright suits. Legal apparently did not review this.

**7. The political lane problem: you can't be both insurgent and incumbent**

`bigyabai` identifies a structural messaging failure: "You don't get to wear the 'people's champion' and 'government sweetheart' hats at the same time… Are you a renegade success, or do you need the government's help?" Anthropic's brand has been the safety-conscious underdog making the best coding model. This blog post repositions them as a company lobbying for protectionism. The thread's hostility reflects the audience noticing the brand pivot in real time.

**8. The content creator angle gets one sharp voice**

`DamnInteresting` (a small independent creator) cuts through the abstract IP debate: "I've used copyright laws many times over the years to stop larger entities from raiding my catalog… Of course now Anthropic et al. are gobbling up such catalogs for indirect misappropriation, with no sign of consequences." This is the one comment that has standing to make the IP argument *against* both sides — and it's buried under the pile-on.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "You trained on our data first" (hypocrisy) | Medium | Valid moral point but doesn't address whether distillation *specifically* creates different harms. The thread treats all IP violations as equivalent when they may not be. |
| "This is regulatory capture" | Strong | Timing with Hegseth meeting and legislative activity is damning. The national security framing is transparently strategic. |
| "16M sessions = thin moat" | Strong | Anthropic published its own vulnerability. The math is straightforward. |
| "Chinese labs make AI affordable" | Medium | True but conflates consumer benefit with structural health of the ecosystem. |
| "Just a TOS violation, not fraud" | Strong | The legal language is overloaded and will backfire in court. |

### What the Thread Misses

- **The distillation arms race creates a ratchet toward closed models.** If Anthropic can't protect API outputs, the rational response is to stop offering API access — or to degrade it relative to internal models. `veselin` gestures at this ("they will not release some of their next models in the API") but nobody explores the downstream consequences: a world where frontier capabilities are only available through locked-down chat interfaces, killing the developer ecosystem that makes Claude valuable.

- **The "countermeasures" bullet in the blog post is the real threat.** Anthropic says it's "developing model-level safeguards designed to reduce the efficacy of model outputs for illicit distillation, without degrading the experience for legitimate customers." This is watermarking/poisoning for outputs. If deployed, it means every Claude API response may be subtly degraded to protect against distillation — a tax on all users to prevent a few bad actors.

- **Nobody asks whether distillation actually works as well as claimed.** `icedchai` notes "the output quality of open models still has a long way to go" and `ashertrockman` reports "significantly higher failure rates on simple instruction following." If distilled models are 70% of frontier rather than 90%, Anthropic's alarm is disproportionate.

### Verdict

Anthropic's blog post is a lobbying document that accidentally revealed its own moat is shallow, armed its litigation opponents, and alienated its core developer audience — all in service of a regulatory play whose target audience (Congress, DoD) will never read the HN comments. The thread's near-unanimous contempt is earned but also self-serving: developers who benefit from cheap distilled models aren't going to interrogate whether the distillation ecosystem is structurally parasitic. The question nobody in the thread or the blog post confronts honestly: if frontier model development costs hundreds of millions but can be replicated for thousands, who funds the next generation? "Someone else will" is not an answer — it's a prayer.
