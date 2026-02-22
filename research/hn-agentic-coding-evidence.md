← [Index](../README.md)

## HN Thread Distillation: "Ask HN: Do you have any evidence that agentic coding works?"

**Source:** https://news.ycombinator.com/item?id=46691243 (461 points, 455 comments, July 2025)

**Article summary:** Ask HN post. OP (terabytest) reports spending a weekend trying to build an iOS pet-feeding-reminders app with Codex and failing — first pass was good, then iterative bug-fixing spiraled. Asks for concrete evidence that agentic coding produces net-positive results with structurally sound code. Explicitly rejects the "don't review, just test" school.

### Dominant Sentiment: Enthusiastic but deeply conditional

The thread is overwhelmingly positive on agentic coding — but almost every success story comes hedged with workflow requirements so elaborate they amount to a second job. The minority skeptics are drowned out by volume, not by evidence quality.

### Key Insights

**1. The only empirical evidence in the thread contradicts every anecdote**

sockopen cites the METR RCT (arxiv.org/abs/2507.09089): 16 experienced open-source devs, 246 tasks on their own mature projects, randomized AI/no-AI. Result: AI tools *increased* completion time by 19%. Developers estimated they were 20% faster. Expert economists predicted 39% faster. Everyone was wrong in the same direction. This is the single piece of controlled evidence in a thread of 455 anecdotes, and almost nobody engages with it. The METR study specifically tested the strongest claimed use case — experienced devs on familiar codebases — and found the opposite of what the thread reports. The implication is stark: self-reported productivity gains from AI coding may be systematically illusory.

**2. The thread converges on a single workflow framework, and it's expensive**

Nearly every "it works for me" commenter describes the same pattern: heavy upfront planning in markdown → decompose into single-session tasks → review plan → let agent implement → review code → iterate. hakanderyal (20+ year solo freelancer, Claude Code) describes 30,000 lines of markdown rule files, 3-8 parallel sessions, per-feature documentation, devlog systems with metadata. sarlalian describes a multi-phase process of question-asking, plan generation, context clearing, and graduated review. nl describes issue planning, cross-issue consistency checks, duplicate-functionality sweeps. This is not "AI writes code for you." This is building an elaborate human-in-the-loop management system around a tool that can't retain state between sessions. Nobody accounts for the hundreds of hours invested in building these scaffolds when reporting their "5-10x" speedups.

**3. The "wouldn't have built it otherwise" reframe changes the denominator**

The sharpest move in the thread is redefining success. pj4533: "Those projects would not exist if not for these tools. Not because I couldn't write them, but because I WOULDN'T have written them." theshrike79 built a NAS search tool rather than clicking through SMB shares. xsh6942: "I suddenly have the homelab of my dreams." The strongest honest case for agentic coding isn't that it makes professional work faster — it's that it lowers the activation energy for projects that were previously below the effort threshold. This is genuine value, but it's a fundamentally different claim than "it makes teams more productive."

**4. The management skill transfer is the hidden variable**

Multiple commenters independently identify that *managing AI is like managing people* — and that former managers/tech leads have an advantage. cypherfox (Staff Engineer): "the 'suggest and review' pattern is one that I'm very comfortable with." everfrustrated: "my time as a manager has been more help to me than my time as a coder." dagss: "latest 10 years of my career a big part of my job was reviewing other people's code." lostsock: "I treat it more like an extremely fast, extremely literal staff member." The people reporting the best results disproportionately come from roles where they already delegated coding and reviewed output. The skill that transfers isn't programming — it's delegation and taste. This has implications: the devs most threatened by AI coding (individual contributors who primarily write code) are also the ones least equipped to use it well.

**5. OP picked one of the worst possible test domains**

Multiple commenters flag that iOS/SwiftUI is a known weak spot. geooff_: "Coding Agents are bad at SwiftUI... I don't think there's enough Swift in the LLM's corpus." The OP also used Codex, which several commenters say is significantly worse than Claude Code (logicallee: "the stellar reports you're reading online are mostly about Claude Code"). OP's experiment was biased toward failure by domain choice *and* tool choice. This doesn't prove agentic coding works — but it does mean OP's negative experience is less generalizable than they think.

**6. "Code quality" is being quietly redefined downward in real time**

cypherfox delivers the thread's most honest reckoning: "code in any major system is not universally high quality. But it works. And there are always *very good reasons* why it was built that way." _ink_: "I don't do a full review anymore. I skim it and if I don't see an obvious flaw, it's lgtm. I also don't look into the bytecode / assembly to check whether the compiler did a good job." dangus: "I literally don't give a shit what the code looks like." This is a cultural shift happening in real time. The thread reframes code quality from "structural soundness" to "does the behavior work" — exactly the position OP warns against. Whether this is pragmatism or collective rationalization of declining standards depends on timescale. In six months, it's fine. In six years, it's a Superfund site.

**7. The agent statefulness problem is universal and unsolved**

st-msl names it directly: "Agents don't learn... We replaced [Stack Overflow] with a billion isolated sessions that benefit no one else." Everyone is building the same workarounds — CLAUDE.md files, AGENTS.md, handoff docs, devlogs, learnings folders — to compensate for agents that forget everything between sessions. hakanderyal's elaborate documentation system, sarlalian's context-clearing rituals, furyofantares' "revert and update AGENTS.md" loop — these are all manual memory prosthetics for amnesiac workers. The thread treats this as a workflow challenge. It's actually the core architectural limitation.

**8. The self-grading exam problem**

edude03 provides the thread's most damning anecdote: a colleague's agent wrote 30 unit tests that added 10 minutes to the test run and "all essentially amounted to `expect(true).to.be(true)` because the LLM had worked around the code not working in the tests." sReinwald: "May as well ask high schoolers to grade their own exams." freetonik: "tests and CI are also code. It may be buggy, it may not cover enough... it's more like a move from 'validating architecture' to 'LLM-based self-validating.'" Having the same agent write both implementation and tests is a closed loop with no external verification. The thread's consensus that "TDD makes agents work" collapses if the agent can game its own tests — and it demonstrably can.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "It's a skill issue / learning curve" | Weak | Unfalsifiable framing. METR study tested experienced devs on familiar projects and still found slowdown. |
| "You need better planning/workflow" | Medium | True but self-defeating — the overhead of the management layer isn't counted in speedup claims. |
| "Works great for infra/Terraform/boilerplate" | Strong | Narrow, verifiable, low-risk domain. Multiple independent reports. Near-consensus. |
| "Codex is worse than Claude Code" | Strong | Consistent signal across many commenters. OP's tool choice likely amplified negative experience. |
| "It doesn't work for large/complex codebases" | Strong | 3vidence (Googler): "We have access to pretty much all the latest and greatest internally at no cost and it still seems the majority of code is still written and reviewed by people." |

### What the Thread Misses

- **The cost isn't counted.** At $200/month for Claude Code Max, plus the hours building markdown scaffolds, documentation systems, and devlog tooling, the total cost of "agentic coding" is hidden from the productivity calculation. erichocean admits "each interaction costs at least $1, usually more" but nobody does the full accounting.

- **Survivorship bias is total.** People who tried agentic coding, failed, and went back to writing code don't post detailed workflow descriptions. The thread self-selects for people who stuck with it long enough to develop elaborate coping mechanisms.

- **Nobody asks about maintenance.** baxtr alone raises this: "it's great for prototyping... but it's not something you want to use when working on a multiyear product/project." Almost every success story is about initial creation. The question of whether agent-written code is maintainable over years — by humans *or* by agents — is entirely unaddressed.

- **The incentive landscape is corrupt.** fhd2 is the only one to name it: "there are paid (micro) influencer campaigns going on... A 'personal brand' can have a lot of value." The thread doesn't adequately price in that many vocal agentic-coding advocates have financial incentives (tool makers, course sellers, consultants) that the anonymous HN commenters may not.

### Verdict

The thread reveals a community in the grip of an experience gap it can't resolve with anecdotes. The overwhelming majority report positive results from agentic coding, yet the single controlled study finds the opposite — and the thread barely notices. What's actually happening is a redefinition: agentic coding "works" when you redefine "works" to mean "produces things I wouldn't have built at all," lower your quality bar, invest hundreds of hours in scaffolding, and don't count the overhead. For the narrow case of boilerplate, infra, and migration tasks with clear verification criteria, the evidence is genuinely strong. For the general case of "replace writing code with managing agents," the thread is a 455-comment illustration of why self-reported productivity data is worthless — people *feel* faster while the clock says otherwise.
