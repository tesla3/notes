← [Index](../README.md)

## HN Thread Distillation: "A16Z partner says that the theory that we'll vibe code everything is 'wrong'"

**Article summary:** A16z GP Anish Acharya argues on the 20VC podcast that pointing the "innovation bazooka" at rebuilding payroll, ERP, or CRM is a misallocation — software is only 8-12% of company costs, so vibe-coding your own Salesforce saves ~10% at best while carrying risk. Companies should use AI on core business and the other 90% of costs. He adds that software stocks are oversold after last week's selloff.

### Dominant Sentiment: Everyone agrees but for incompatible reasons

Small thread (34 comments), but the interesting thing is that almost nobody defends "vibe code everything" — yet the commenters who agree with Acharya do so from mutually contradictory positions. The VC critics think he's talking his book. The engineering purists think vibe coding is fundamentally limited. The pragmatists think vibe coding is transformative but misunderstood. They're all nodding at the same headline while meaning completely different things.

### Key Insights

**1. The article's thesis and the thread's debate are about different things**

Acharya's actual argument is narrow and financial: software is 8-12% of company spend, so even if you vibe-code a replacement, the savings ceiling is low and the risk is real. This is a portfolio defense argument — he's saying software stocks are oversold because SaaS won't be disrupted as fast as the market priced in. The thread largely ignores this financial framing and instead debates the *engineering* question: can vibe coding produce good software? These are orthogonal. You can believe vibe coding works great technically and still agree that rebuilding SAP is a bad use of it.

**2. theturtletalks reframes vibe coding more accurately than the article does**

The sharpest reframe: nobody's prompting "make me my own Stripe." The real pattern is "look at Lago (open-source billing), understand how it works, adapt it to our stack and needs." This is AI-assisted customization of existing open-source, not greenfield generation — and it's a much more credible threat to SaaS vendors than the straw man Acharya attacks. nradov's reply identifies the moat: the value of enterprise SaaS isn't the app layer, it's the IaaS substrate (ops, backups, compliance, scale). Vibe coding the app is getting easier; running it reliably is not.

**3. packetlost's deployment scripts story is the thread's best empirical evidence**

packetlost describes inheriting vibe-coded deployment scripts: hardcoded Docker image tags, two incompatible deployment strategies (direct VM + GKE), documentation with "very low information density," and the only reason they could use it was pre-existing expertise with all the underlying tools. "Vibe coding consistently gives the illusion of progress by fixing an immediate problem at the expense of piling on crap that obscures what's actually going on." This is a first-hand account, not theory. It illustrates the core failure mode: vibe coding optimizes for the *creation* moment and externalizes the cost to the *maintenance* moment. dchuk's rebuttal ("if you can articulate the issues this clearly, it would take an hour to vibe-code them away") is telling — it implicitly concedes that vibe coding requires an expert to fix vibe-coded output, which undermines the "non-experts can build" premise.

**4. The Dijkstra vs. "here we are" exchange is the thread's real philosophical axis**

godelski invokes Dijkstra's *On the Foolishness of "Natural Language Programming"* — formal languages exist to eliminate ambiguity, natural language compounds it, and vibe coding inherits all the pathologies of natural language specifications. selridge pushes back: "Dijkstra also said no one should be debugging and yet here we are." godelski returns with the full Dijkstra quote about programmers who "derive satisfaction from not quite understanding what they are doing" — a passage that reads like it was written about vibe coding yesterday.

The exchange matters because it identifies the real question: is the ambiguity of natural language a *temporary* limitation (that better models will resolve) or a *fundamental* one (inherent to the medium)? godelski argues the latter — "You can't get it to resolve ambiguity if you aren't aware of the ambiguity" — and points to the legal system as the most serious human attempt at formalizing natural language, which still requires lawyers arguing all day. Neither commenter resolves this, but godelski has the stronger argument: the history of computing is the history of creating formal languages *because* natural language fails at precision. Reversing that arrow requires more than faster autocomplete.

**5. selridge's Google ISA migration claim checks out and reframes the debate**

selridge cites a real Google paper (arXiv:2510.14928): Google AI-assisted their x86→ARM migration across ~40K code commits. "Google would have let that sit forever because the labor economics of the problem were backwards." This is a genuinely different argument from "vibe code your own CRM." It's about AI making *previously infeasible* engineering work economical — not replacing existing software, but doing work that would never have been done at all. jrumbut notes this is how every previous software productivity improvement played out: more software gets built, not fewer engineers needed.

**6. The junior developer pipeline concern is real and under-discussed**

godelski: "There can be no wizards without noobs. So we have a real life tragedy of the commons situation staring us in the face." If companies cut junior/mid roles because vibe coding handles that tier of work, the pipeline of future senior engineers dries up. This is a collective action problem — each company individually benefits from cutting juniors, but the industry collectively suffers. shalmanese adds historical context: the argument that domain experts will code their own solutions "has been the argument since the 5PL movement in the 80s" — and what we keep discovering is that domain expertise and articulating domain expertise into systems are orthogonal skills.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Acharya is talking his book (software portfolio defense) | **Strong** | atomic128, duzer65657 — the financial incentive is obvious and unaddressed |
| Natural language is fundamentally unsuited for programming | **Medium** | godelski/Dijkstra — strong in principle but doesn't account for hybrid workflows where NL guides formal code |
| Vibe coding creates unmaintainable garbage | **Strong** | packetlost's empirical account; dchuk's "fix it with more vibe coding" reply implicitly concedes the problem |
| AI makes previously infeasible work possible | **Strong** | selridge/Google ISA paper — verified, and a genuinely different frame than "replace SaaS" |
| a16z has no credibility | **Medium** | Emotionally satisfying but this specific argument (narrow scope, financial framing) stands independent of the source |

### What the Thread Misses

- **Nobody mentioned the internal IT angle.** The most plausible "vibe code everything" scenario isn't replacing Salesforce — it's companies building internal tools, dashboards, and integrations that they currently buy low-end SaaS for. That $50/seat/month Retool alternative is exactly where vibe coding threatens SaaS.
- **The maintenance cost problem has an empirical answer available.** How are vibe-coded projects aging at 6/12/18 months? Someone with access to GitHub data could study this. Nobody asked.
- **No discussion of liability.** If you vibe-code your payroll system and it miscalculates taxes, who's responsible? The compliance and liability angle is the strongest argument *for* buying enterprise SaaS, and nobody raised it.
- **tombert's emotional honesty deserved more engagement.** "Writing software isn't fun anymore" and "I was wrong — I actually did enjoy writing code" is a real human cost of the transition that the thread acknowledged but didn't explore.

### Verdict

The thread converges on a framework nobody names explicitly: **vibe coding's value is inversely proportional to the consequences of being wrong.** Internal dashboards, prototypes, one-off scripts, migration grunt work — all benefit. Payroll, compliance, security-critical systems — all suffer from the maintenance debt and ambiguity compounding that packetlost and godelski describe. Acharya's actual argument (the financial ceiling of replacing enterprise software is low) is correct but boring; the thread's real contribution is identifying that the interesting frontier isn't "replace SaaS" or "code everything from scratch" — it's the expanding middle ground of AI-assisted customization of open-source, and making previously infeasible engineering economical. The thread circles this but only theturtletalks and selridge state it directly.
