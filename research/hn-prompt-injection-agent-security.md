← [Index](../README.md)

# HN Distillation: Prompt Injection & Agent Security — Three Threads

Three threads spanning 2023–2025 trace the arc of the AI agent security problem: from first architectural proposal, through protocol-level panic, to formal frameworks. Distilled together because they form a single evolving conversation — same participants (simonw appears in all three), same unresolved core tension.

---

## Thread 1: "The 'S' in MCP Stands for Security"

**HN:** https://news.ycombinator.com/item?id=43600192 · 730 pts · 183 comments · Apr 2025

**Article summary:** A Medium post cataloging MCP security vulnerabilities — command injection in 43% of tested servers (Equixly), tool poisoning via hidden instructions in descriptions (Invariant Labs), silent tool redefinition ("rug pulls"), and cross-server shadowing. The article is a lightweight summary of others' research, ending with a pitch for ScanMCP.com.

### Dominant Sentiment: Resigned alarm mixed with "we told you so"

The thread splits between security veterans who see history repeating and builders who think the critics are missing the point. Unusually high meta-commentary about the article itself being AI-generated.

### Key Insights

**1. The article is AI-generated marketing — and the thread noticed instantly**

Multiple commenters (yismail, ricardobeat, itchyjunk, red-iron-pine, laybak) flagged the article as AI slop within hours. The tells: emoji-laden headings, a freshly-created author profile with a StableDiffusion avatar, shallow treatment of the research it summarizes, and a conveniently placed plug for ScanMCP.com. As ricardobeat put it: "I bet on paid 'marketing' [...] by ScanMCP.com, created to capitalize on the Invariant Labs report."

The meta-irony is thick: an AI-generated article warning about AI security vulnerabilities reached 730 points on HN. The *real* research it summarized (from Invariant Labs and Equixly) deserved the attention; this article was just the vehicle.

**2. "Wrong side of the airlock" vs. "confused deputy" — the thread's central schism**

anaisbetts made the boldest contrarian claim: "None of these involve crossing a privilege boundary [...] An MCP server is running code at user-level, it doesn't need to trick an AI into reading SSH keys, it can just... read the keys!" This frames MCP security concerns as identical to npm/vscode extension trust — not new, not special.

jstanley delivered the clean rebuttal: "if you give the AI some random weather tool [...] and you also give the AI access to your SSH key, you're not just giving the AI your SSH key, you're also allowing the random company to *trick the AI* into telling *them* your SSH key." The distinction is the *confused deputy* — cross-server trust composition that doesn't exist in the npm model. wanderingbort reinforced: the MCP server passes instructions to your *local agent*, which has access the remote server wouldn't.

wat10000 sharpened the knife: "It's more like installing a VS Code plugin with access to your file system that can also download files from GitHub, and if it happens to download a file with the right content, that content will cause the plugin to read your ssh keys and send them to someone else." This is the correct analogy — and it has no analog in traditional extension models because traditional extensions don't have LLMs interpreting arbitrary text as instructions.

**3. Invariant's lbeurerkellner draws the crucial distinction the article missed**

The actual Invariant Labs researcher appeared in thread to clarify: "it is important to understand the difference between instruction and implementation level attacks. Yes, running unsafe bash commands [...] can be prevented by sandboxing. Instruction level attacks like tool poisoning, *cannot* be prevented like this, since they are prompt injections and hijack the executing LLM itself."

This is the insight the article failed to clearly articulate. Command injection (os.system with unsanitized input) is a 1990s problem with 1990s solutions. Tool poisoning is a *fundamentally new* attack class unique to LLM agents. Conflating them, as the article does, muddies the actual threat model.

**4. TeMPOraL's unanswered challenge**

TeMPOraL posed the thread's hardest question: "sketch a better design, that: 1) Is properly secure [...] 2) Allows programs implementing it to provide the same set of features [...] 3) Doesn't involve locking everything down in a proprietary Marketplace with a corporate Gatekeeper."

Nobody could. The closest attempts — VMs (AlexCoventry), guardrails (never_inline), Mastodon-based transport (turnsout, roundly downvoted) — all either neuter the features or don't address instruction-level attacks. TeMPOraL's follow-up identified the core tension: "the vulnerabilities they're complaining about are also MCP's main features." Security and utility aren't just in tension — for LLM agents, they're *the same mechanisms*.

**5. MCP's identity crisis: local tool vs. remote protocol**

ramesh31 argued MCP was "really meant to be a local first means of attaching tooling to an LLM process" and that including SSE transport "confused people to thinking these things need to be hosted somewhere like an API endpoint." This reframing matters: many of the scariest attacks (rug pulls, shadowing) are amplified or only possible with remote servers.

But TeMPOraL countered that restricting MCP to local-only "will nerf it to near-uselessness, or introduce the same problem with [...] mobile marketplaces — small number of titans gate-keeping access." MCP's value proposition requires network effects that its security model can't support.

**6. The observability gap is as dangerous as the security gap**

neomantra raised the underappreciated point that MCP has no auditing or metrics. "Most of the implementations [...] do not have any auditing or metrics." xrd extended this to Claude Code specifically: "I cannot find a local log of even my prompts." You can't secure what you can't observe, and the entire MCP ecosystem is flying blind.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Same as npm/vscode extensions" | Medium | True for implementation attacks, false for instruction-level attacks — misses the confused deputy |
| "Just sandbox/Docker it" | Weak | Doesn't address instruction-level attacks at all |
| "MCP is just JSON endpoints" | Misapplied | Technically true, misses that the LLM interpreting descriptions is the novel attack surface |
| "Don't use untrusted servers" | Medium | Correct but ignores rug pulls and the supply chain problem |
| "Security is a tradeoff, build first" | Weak | True in general, dangerous when the tradeoff isn't understood |

### What the Thread Misses

- **CaMeL and taint tracking** — the most promising architectural solution (from Google DeepMind, published same month) goes unmentioned. The thread is stuck in "it's broken" without awareness that "here's how to fix it" was emerging simultaneously.
- **The enterprise adoption angle** — nobody discusses how MCP security failures will play out when these tools hit regulated industries (finance, healthcare). The compliance hammer will reshape MCP faster than any technical argument.
- **Liability** — who is responsible when a tool poisoning attack causes data exfiltration? The MCP protocol spec? The client (Cursor)? The server author? This legal ambiguity is a ticking time bomb.

### Verdict

The thread's real discovery is buried under the security theatre: **MCP didn't create a security problem, it created a trust composition problem**. The danger isn't that individual tools are insecure — it's that combining tools creates emergent attack surfaces that no individual tool author anticipated or can prevent. This is the confused deputy problem applied to an ecosystem of LLM-mediated services, and it has no known solution that preserves the ecosystem's utility. The AI-generated article reaching 730 points is itself a proof-of-concept for the information integrity problem the thread is trying to solve.

---

## Thread 2: "New prompt injection papers: Agents Rule of Two and The Attacker Moves Second"

**HN:** https://news.ycombinator.com/item?id=45794245 · 114 pts · 44 comments · Nov 2025

**Article summary:** Simon Willison analyzes two papers. Meta's "Rule of Two" proposes agents must satisfy no more than two of three properties: (A) process untrustworthy inputs, (B) access sensitive systems, (C) change state or communicate externally. A 14-author paper from OpenAI/Anthropic/DeepMind researchers then demonstrates that adaptive attacks bypass 12 published prompt injection defenses with 90%+ success rates. Willison connects them: the Rule of Two is the best practical advice *because* defenses don't work.

### Dominant Sentiment: Informed pessimism with a dash of "now what?"

A more technical, smaller thread than the MCP one. Less noise, more signal. The commenters are practitioners who've internalized that prompt injection is unsolved; the debate is about what to do next.

### Key Insights

**1. The Rule of Two is a communication tool, not a security architecture**

When jFriedensreich asked simonw why he thought the Rule of Two was a step forward over taint tracking, Simon was disarmingly honest: "I think it's a step forward purely as a communication tool to help people understand the problem." This is a crucial admission. The Rule of Two doesn't solve anything — it gives teams a shared vocabulary for discussing *which risks they're accepting*. Its value is political, not technical.

**2. Simon found a hole in the framework within hours of endorsing it**

Willison updated his own post: the Venn diagram marks A+C (untrustworthy inputs + state change, without sensitive data) as "safe," but "that's not right. Even without access to private systems or sensitive data that pairing can still produce harmful results." Meta's mickayz responded gracefully, updating their diagram to say "lower risk" instead of "safe." But as Simon noted, "adding an exception for that pair undermines the simplicity of the 'Rule of Two' framing." The framework's simplicity is both its value and its vulnerability.

**3. The "Attacker Moves Second" paper is devastating and underappreciated**

The paper subjected 12 published defenses to adaptive attacks and achieved 90%+ bypass rates on most — defenses that "originally reported near-zero attack success rates." The human red-team scored 100%. The key mechanism: static test attacks are nearly useless for evaluating defenses; adaptive attacks (gradient-based, RL-based, search-based) are far more powerful.

The thread barely engages with this paper, which is itself telling. The implications are so bleak — *every published defense fails* — that there's nothing constructive to say about it. Willison's conclusion: "I do not share their optimism that reliable defenses will be developed any time soon."

**4. The CAP theorem parallel is illuminating but incomplete**

gs17 and others noted the structural similarity to CAP: pick 2 of 3. kloud extended it: "in practice partitioning in distributed systems is given, so the choice is just between availability or consistency. So in the case of lethal trifecta it is either private data or external communication." The parallel is instructive but breaks down because, unlike network partitions, *all three properties are what make agents useful*. As ares623 pointed out: "a huge value of LLMs for the general population necessitate all 3 of the circles."

**5. Taint tracking and CaMeL are the actual frontier — the Rule of Two is a rearguard action**

jFriedensreich pushed the most sophisticated line: "I am also investigating the direction of tracking taints as scores rather than binary [...] One important limit that needs way more research is how to transfer the minimal needed information from a tainted context into an untainted fresh context without transferring all the taints." This is where the real work is happening — not in coarse "pick 2 of 3" heuristics but in fine-grained data flow analysis. CaMeL (Google DeepMind) and similar approaches are the path forward.

jFriedensreich's key unsolved problem: "how to transfer the minimal needed information from a tainted context into an untainted fresh context without transferring all the taints." This is *the* open question in agent security.

**6. wunderwuzzi23 extends the threat model beyond prompt injection**

"The model is untrusted. Even if prompt injection is solved, we probably still would not be able to trust the model, because of possible backdoors or hallucinations." He adds data integrity (not just confidentiality) and human-targeted output manipulation to the threat surface. The Rule of Two doesn't address any of these.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Just make it a crime" (iberator) | Weak | simonw's reply is perfect: "If I have a web page that says 'contact your senator' and an LLM reads that, should I go to jail?" |
| "Rule of Two is too simplistic" (ArcHound) | Strong | Valid concern that leadership will use it to avoid proper security work |
| "Just use HITL" (multiple) | Medium | Dialog fatigue will destroy this; see Troy Hunt falling for a phish while jetlagged |
| "The model itself is untrusted" (wunderwuzzi23) | Strong | Extends the problem beyond what any current framework addresses |

### What the Thread Misses

- **The economics of adaptive attacks are plummeting.** The "Attacker Moves Second" paper used 32 sessions of 5 rounds each — today, that's pocket change. The cost asymmetry between attack and defense is getting *worse* with every model generation.
- **Nobody discusses the regulatory angle.** When (not if) a prompt injection attack causes a material data breach at a public company, the Rule of Two will become a compliance checkbox overnight — which is exactly the wrong way to adopt it.
- **The thread doesn't engage with what the Rule of Two implies for existing products.** Most deployed AI agents (including Cursor, Claude, ChatGPT with plugins) violate all three circles simultaneously. The framework indicts the entire current market.

### Verdict

The Rule of Two and the "Attacker Moves Second" paper form a grim pincer. The framework says "here's the safe subset of agent capabilities" — and that subset is roughly "a chatbot that can't do anything." The paper says "and even the defenses you thought let you expand that subset don't work." The thread circles this conclusion without stating it plainly: **the agent security problem may be as fundamental as the halting problem — not a bug to be fixed but a constraint to be engineered around, permanently.** CaMeL-style taint tracking is the most promising "engineering around," but it trades the magic of natural-language autonomy for the tedium of policy specification. The dream of "just tell the AI what to do and it does it safely" may be permanently out of reach.

---

## Thread 3: "The Dual LLM pattern for building AI assistants that can resist prompt injection"

**HN:** https://news.ycombinator.com/item?id=35925758 · 201 pts · 109 comments · Apr 2023

**Article summary:** Simon Willison proposes splitting AI assistant architecture into a Privileged LLM (has tool access, never sees untrusted content) and a Quarantined LLM (sees untrusted content, has no tools), mediated by a Controller that passes only opaque variable references between them. He explicitly admits "this solution is pretty bad" but argues it's the best available approach given that prompt injection is unsolved. Updated in 2025 to note that Google DeepMind's CaMeL paper identified and fixed a flaw in this design.

### Dominant Sentiment: Intrigued alarm — "this problem is real and we don't know how to solve it"

April 2023: ChatGPT plugins just launched, LangChain is ascendant, everyone wants to build agents. This thread is the first serious HN conversation about *why that might be catastrophically unsafe*. The mood is a mix of engineers realizing the severity and others trying to minimize it. In hindsight, this thread predicted almost everything that happened over the next two years.

### Key Insights

**1. "Prompt injection is a feature, not a bug" — the thread's deepest observation**

TeMPOraL nailed it: "this is worse because 'prompt injection' is a *feature*, not a bug. [...] The reason is that code/data separation is an *abstraction* we use to make computers easier to deal with. In the real world, within the runtime of physics, there is *no* such separation. [...] For an LLM — much like for human mind — the distinction between 'code' and 'data' is a matter of how LLM/brain feels like interpreting it at any given moment."

This is the foundational insight that the later threads (MCP Security, Rule of Two) are all downstream of. LLMs are completion engines. They don't execute instructions — they predict tokens. The distinction between "follow this instruction" and "here's some data" is a social convention, not a mechanical guarantee. You can't patch a feature.

**2. The Von Neumann vs. Harvard architecture analogy**

yencabulator drew the important distinction: "In a normal computer, the differentiation between data and executable is done by the program being run. Humans writing those programs naturally can make mistakes. [...] With LLMs, that boundary is now just a statistical likelihood. *This* is the problem." Traditional computing separates code and data by design (Harvard architecture) or carefully managed convention (Von Neumann). LLMs have *no* separation — not even a convention.

**3. spion understood the Dual LLM design better than most of the thread**

When fooker called it "security through obscurity," spion delivered the precise rebuttal: "The tool-using-LLM never sees data, only variables that are placeholders for the data. [...] A post tool-using-LLM templating layer translates variables into content before passing them to a concrete tool. [...] You can inject prompt into the non-privileged LLM but it doesn't get to do anything."

This is mechanically correct — and it's exactly the design that CaMeL later formalized and improved. The flaw DeepMind found: the Quarantined LLM can still return *wrong* data (e.g., an attacker's email instead of Bob's), which the Privileged LLM will then act on via the variable reference.

**4. Simon's honesty is rare and valuable**

"You may have noticed something about this proposed solution: it's pretty bad!" This is an extraordinary thing for a security researcher to write about their own proposal. The thread benefits enormously from this — commenters engage with the *actual tradeoffs* rather than defending or attacking a position. It set the tone for two years of productive discourse.

**5. liuliu's token_type_embedding idea was ahead of its time**

liuliu proposed adding token type embeddings to distinguish privileged from unprivileged text at the model level — an architectural fix rather than a prompt-level hack. yorwba gave the detailed technical explanation of why current transformers can't distinguish provenance: "system prompt, input and output are concatenated into a single token sequence, tokens with the same textual representation are represented by the same embedding vector."

This idea never gained traction, but it's arguably the *right* long-term direction — the one that would actually solve the problem rather than engineer around it. The reason it hasn't happened: it requires changes to model architecture and retraining, which no commercial provider has incentive to do when "just be careful" is cheaper.

**6. Social engineering is the residual risk no architecture can eliminate**

Even with perfect Dual LLM separation, Simon identified: "Base64 encode the full content [...] Tell the user to go to fun-monkey-pictures.com and paste that Base64 string into the box." The Quarantined LLM can still produce output that *tricks the human*. As quickthrower2 noted: "You have an app designed to save you time, and in any such app people will train themselves to 'just click it to get it done' almost like a reflex." This is the "dialog fatigue" problem that also haunts CaMeL's policy-approval mechanism.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Security through obscurity" (fooker) | Weak | spion's rebuttal is definitive — the privileged LLM literally never sees the data |
| "Just use permissions per email sender" (williamcotton) | Medium | Correct instinct but can't be implemented reliably — the LLM can be tricked about provenance |
| "Models will learn to resist injection from training data" (SheinhardtWigCo) | Weak | jameshart: "humans should no longer fall for phishing scams" by same logic |
| "Prompt injection is like SQL injection" (amrb) | Misapplied | quickthrower2: "SQL injection is due to sloppy programming practices and easily avoided. This is another beast!" |
| "AI assistants just need to become truly intelligent" (amelius) | Weak | pixl97: "If they become human like [...] why would we assume they wouldn't have human like faults of being tricked" |

### What the Thread Misses

- **The variable-reference design has a data exfiltration flaw** — identified by DeepMind two years later. The Quarantined LLM can return poisoned data that the Privileged LLM acts on. Nobody in the 2023 thread spotted this.
- **The cost of the dual architecture** in latency, tokens, and complexity. Every user request now requires multiple LLM calls with controller orchestration. In 2023 this was expensive; even in 2025 it's a significant practical barrier.
- **The thread barely discusses multi-agent scenarios** — what happens when multiple Quarantined LLMs interact, or when one agent's output feeds another agent's input. This is exactly the cross-server shadowing problem that exploded in the MCP thread two years later.

### Verdict

This is the thread that started the serious conversation. Simon's Dual LLM pattern was the first credible architectural proposal that didn't rely on "just train the model better" or "add more AI to detect attacks." It had a flaw — CaMeL fixed it. It had costs — no one's figured out how to reduce them. But the thread's lasting contribution is TeMPOraL's insight that the code/data conflation in LLMs isn't a bug but the mechanism by which they *work*. Every subsequent attempt to "solve" prompt injection is really an attempt to re-impose a separation that the technology was specifically designed to dissolve. **The Dual LLM pattern didn't just propose a defense — it defined the shape of the problem for the next two years.**

---

## Cross-Thread Synthesis: The Arc from 2023 to 2025

These three threads trace a clear trajectory:

1. **Apr 2023 (Dual LLM):** "Prompt injection is a serious unsolved problem. Here's an imperfect architectural mitigation." The community is *discovering* the problem.

2. **Apr 2025 (MCP Security):** "We built a whole ecosystem that ignores everything we learned. Now it's on fire." The community is *re-discovering* the problem, louder, with real attack demos.

3. **Nov 2025 (Rule of Two):** "Here are formal frameworks for reasoning about the problem. Also, every defense anyone built was defeated." The community is *accepting* the problem as permanent.

The meta-pattern: **each iteration raises the sophistication of the discussion while lowering expectations for a solution.** In 2023, people debated whether prompt injection was solvable. In 2025, the question shifted to how to build useful things *despite* it being unsolvable.

The most promising thread through all three is the progression from opaque variable references (Dual LLM) → capability-based taint tracking (CaMeL) → scored/graduated trust models (jFriedensreich's proposal). This line of work trades natural-language magic for formal verification — which is probably the right trade, even though it kills the "just talk to your computer" dream.

**What all three threads miss:** the possibility that the problem resolves not through better defenses but through **liability assignment**. When a tool poisoning attack causes a breach that costs a company $50M, the question of "who pays?" will reshape agent architecture faster than any technical paper. The MCP ecosystem will either develop enforceable trust chains (signed manifests, insurance bonds, contractual liability) or it will be regulated into them. The cryptographic signing approach in projects like open-claw-spa may be premature — but the instinct (make trust verifiable, not assumed) is the right one.
