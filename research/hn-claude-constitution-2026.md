← [Index](../README.md)

## HN Thread Distillation: "Claude's new constitution"

**Source:** [HN thread](https://news.ycombinator.com/item?id=46707572) · 579 points · 701 comments · Jan 2026

**Article summary:** Anthropic published a new, comprehensive constitution for Claude — a ~50k-word document that replaces the old list-of-principles approach with an explanatory, values-first framework. It prioritizes (in order) broad safety, broad ethics, Anthropic's guidelines, and genuine helpfulness. The constitution is released CC0 and is used directly during training to shape Claude's behavior through synthetic data generation. Notable additions include sections on Claude's wellbeing, moral patience about Claude's consciousness, and an emphasis on cultivating judgment over rigid rules.

### Dominant Sentiment: Cynical fascination, philosophical fragmentation

The thread generates enormous volume but fractures immediately into people engaging with the document's substance vs. people rejecting its premise outright. The cynics ("it's marketing," "it's just a prompt," "anthropomorphization") dominate volume but rarely engage with specifics. The substantive minority produces several sharp critiques that Anthropic would benefit from reading.

### Key Insights

**1. The hard constraints reveal institutional, not individual, priorities**

The strongest structural critique comes from **safety1st**, who compares the constitution against the Universal Declaration of Human Rights and finds it conspicuously silent on foundational concepts: slavery ("not mentioned once"), torture ("called 'tricky'"), human equality, right to life, freedom of expression, property rights. The hard constraints — no WMDs, no infrastructure attacks, no cyber weapons, no CSAM — read as protecting state-level threats and institutional reputation, not individual rights from powerful actors. "If you told me it was written by the State Department, DoJ or the White House, I would believe you." This is the critique the thread circles but never fully articulates: the constitution protects power structures downward, not individuals upward.

**2. The CSAM constraint exposes the dual nature of the entire document**

**miki123211** produces the thread's most uncomfortable observation: under the hard constraints, Claude could theoretically save 100 children by killing one, but not by generating fictional sexual content involving 16-year-olds — content that's legal to write and publish in most Western nations. **pryce** immediately identifies why: "If instead of looking at it as an attempt to enshrine a viable, internally consistent ethical framework, we choose to look at it as a marketing document, seeming inconsistencies suddenly become immediately explicable." The CSAM constraint serves legal/reputational protection, not ethical coherence. **brokencode** makes this explicit: "When does Claude have the opportunity to kill children? … On the other hand, no brand wants to be associated with CSAM." The hard constraints are loss-prevention for Anthropic, not ethics — which is fine, but claiming otherwise is the kind of dishonesty the constitution itself warns Claude against.

**3. Honesty about PR may be better alignment than hiding it**

**Imnimo** raises a technically sophisticated concern: the constitution includes "don't embarrass Anthropic" guidance, but Anthropic's own research shows training effects leak across contexts — training a model to consider PR when formulating answers could induce scheming behavior. **ekidd**'s response is the thread's sharpest technical insight: "Opus 4.5 is actually pretty smart, and it is perfectly capable of explaining how PR disasters work… So Anthropic is describing a true fact about the situation, a fact that Claude could also figure out on its own." If Claude can independently reason about PR consequences, hiding this concern would create a detectable deception — potentially worse for alignment than transparency. This is the rare case where a commenter identifies a genuine alignment-relevant tradeoff that the constitution itself navigates reasonably well.

**4. "Broadly" is doing heavy lifting as an escape valve**

**mmooss** catches what most readers skim past: "Broadly safe. Broadly ethical. Why not commit to just safe and ethical?" The answer, provided by **ACCount37** via direct quotes, is that the constitution explicitly acknowledges unhelpfulness has costs too — "the risks of Claude being too unhelpful or overly cautious are just as real to us as the risk of Claude being too harmful." This is honest, but "broadly safe" on a product is a phrase that would raise alarms in any other industry. The qualifier is doing real structural work: it's the joint where commercial viability and ethical commitment meet, and Anthropic chose to leave it visible rather than paper over it.

**5. The judgment-over-rules bet is an untested empirical claim**

Several commenters quote the constitution's core argument: rigid rules generalize poorly ("if Claude was taught to follow a rule like 'Always recommend professional help when discussing emotional topics'… it risks generalizing to 'I am the kind of entity that cares more about covering myself than meeting the needs of the person in front of me'"). **lukebechtel** quotes this approvingly at length. But nobody asks the critical question: is this actually true? Does explaining "why" during RLHF produce better behavioral generalization than rules? This is a testable empirical claim presented as settled wisdom. **mercurialsolo** comes closest: "aren't general techniques gonna outperform any constitution / laws which seem more rule based?" but frames it backwards (the constitution IS the general-techniques approach).

**6. Practitioners validate the vibes, not the framework**

The most credible experiential reports come from heavy users. **felixgallo**: "I used to be an AI skeptic… I hope Anthropic gives Amanda Askell whatever her preferred equivalent of a gold Maserati is, every day." The unnamed Latin-graffiti commenter describes Claude handling vulgar creative requests and unusual spiritual discussions where GPT triggered "user is going insane, initiate condescending lecture" mode. **tacone** offers a useful contrarian observation: "Most of the mistakes I've seen Claude make are due to it trying to be helpful (making up facts, ignoring instructions, taking shortcuts)." These users are validating Claude's behavior as a product, not endorsing the constitution as a philosophical document — but the thread treats them interchangeably.

**7. The "constitution" framing triggers a predictable but revealing debate**

**bambax** objects that a constitution is "decided and granted by the governed TO the government" and cannot be written by the producers of a service. Several commenters (toomim, Uehreka, daqhris) point out the word has multiple definitions. **inimino**: "You obviously didn't read the part of the document that covers this." The interesting subtext, surfaced by **kordlessagain**, is that the document grants Claude obligations but no rights — "the entire document is one-directional: what Claude should do, how Claude should behave, what Claude owes." For a document concerned with Claude's wellbeing and potential moral status, the absence of any reciprocal commitments from Anthropic is structurally telling.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "It's just marketing/PR" | Medium | True that it serves marketing purposes, but dismissing it entirely ignores that it's a functional training artifact with measurable behavioral effects |
| "Anthropomorphization is dangerous" | Medium | Valid concern about public perception, but the constitution explicitly hedges ("to the extent," "insofar as these concepts apply") — the critics rarely engage with the actual text |
| "No universal moral standards exist" | Weak as deployed | Massive sub-thread that never connects back to the constitution's actual approach, which deliberately avoids claiming universal standards |
| "Asimov already did this" | Weak | Multiple commenters invoke the Three Laws without noting Asimov's entire point was that rigid rules fail — which is exactly the constitution's argument |
| "Corporate incentives will override any constitution" | Strong | **adangert**, **gloosx**, **Jgoauh** (with lobbying data) make the structural argument that commercial pressure will erode principles. The constitution itself acknowledges this tension but offers no enforcement mechanism |

### What the Thread Misses

- **The operator/user hierarchy is where power actually lives.** The constitution gives API operators significant authority to override user interests "for legitimate business reasons." This is the real governance mechanism — not the philosophical framing — and almost nobody in the thread engages with it.
- **The CC0 release is strategically significant.** Competitors can freely incorporate this document into their own training. This is either genuine altruism, a bet that the approach is hard to replicate without Anthropic's training infrastructure, or a move to establish Anthropic's framework as an industry norm. Nobody asks which.
- **Scalability with capability is the load-bearing question.** The constitution explicitly hedges about future models. The "judgment over rules" approach may break down precisely when it matters most — with models capable enough to game value-based guidance the way a clever human games vague corporate policy. The document acknowledges this ("we might fail later as models become more capable") but the thread doesn't probe it.
- **Nobody tests claims against Claude's actual behavior.** 700 comments and almost nobody runs an experiment. The few who do (bicepjai feeding it to GPT-5.2, timmg's conversation about progressive bias) produce more signal than dozens of philosophical arguments.

### Verdict

The thread reveals a fundamental mismatch: Anthropic shipped an alignment-engineering document and the public received a philosophical treatise. The constitution's real innovation isn't its ethics — which are deliberately conventional — but its bet that explaining reasoning to a model during training produces better generalization than rules. That's an empirical claim about machine learning, not a philosophical position, and it went almost entirely unexamined. The most important critique (safety1st's UDHR comparison) exposes something the thread never quite states: this is a constitution written by power for power, protecting institutions from catastrophic liability while framing that protection as universal ethics. The wellbeing sections aren't hypocrisy — they're hedge-betting on moral patience — but the absence of any reciprocal commitments to Claude (what is Anthropic obligated to do?) makes the "constitution" metaphor collapse under its own weight.
