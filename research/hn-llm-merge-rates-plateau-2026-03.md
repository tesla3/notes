← [Index](../README.md)

## HN Thread Distillation: "Are LLM merge rates not getting better?"

**Source:** [entropicthoughts.com](https://entropicthoughts.com/no-swe-bench-improvement) | [HN thread](https://news.ycombinator.com/item?id=47349334) (135 pts, 120 comments, 90 unique authors)

**Article summary:** Reanalyzing METR's data on LLM-generated PRs, the author (kqr) argues that merge rates (as opposed to test-pass rates) have been flat since early 2025. A constant function fits the data better (lower Brier score) than either a linear slope or step function. Provocative conclusion: "LLMs have not improved in their programming abilities for over a year."

### Dominant Sentiment: Vibes beat benchmarks, tooling is the real story

The thread overwhelmingly rejects the article's conclusion while simultaneously being unable to refute it with data. Almost everyone *feels* models have improved dramatically, but few can disentangle model quality from harness improvements. The tension is palpable.

### Key Insights

**1. The article's statistical analysis is weak and the thread knows it**

The top comment (wongarsu) identifies the core problem: METR's merge-rate metric is "a high standard even for humans," and lumping all labs together obscures per-model trajectories. There are only 5 data points across two labs with different architectures and harnesses. fluidcruft catches a methodological issue — the cross-validation approach is being applied to what is essentially ANOVA, and the claim that a constant function beats a two-parameter model is unsurprising with so few data points. kqr (the author, in the thread) defends the cross-validation but the statistical criticism is sound: you simply cannot draw trend lines through this data.

**2. The "model vs. harness" attribution problem is the real story**

This is the thread's gravitational center. A striking number of experienced practitioners report dramatic productivity gains but can't attribute them cleanly. As aerhardt puts it: "Two forces feel true simultaneously but in permanent tension... I still cannot make out my mind." The recurring pattern:

- idorozin: "raw 'one-shot intelligence' hasn't improved as dramatically... but the workflow around the models has improved massively"
- ryanackley: "The game changer are tools like Claude Code. Automatic agentic tool loops purpose built for coding."
- sigbottle: traces the real arc — test-time compute (late 2024) → tool calling (mid 2025) → agentic CLI (late 2025) → harness engineering (early 2026)

The thread converges on a framework: **raw model capability has hit diminishing returns, but capability-times-harness is still compounding.** Nobody states it this cleanly, but it's the synthesis.

**3. The "emergent abilities mirage" applies to merge rates**

yorwba makes the sharpest analytical comment: merge rate is a threshold metric where "a single mistake can cause a failure." You won't see improvement until *all* sources of error are nearly eliminated, then you get a sudden jump. This is the exact dynamic described in the emergent abilities paper (Schaeffer et al. 2023). The implication: continuous underlying improvement could produce exactly the flat-then-step pattern kqr found, making his conclusion ("no improvement") unfalsifiable from this metric alone.

**4. The Opus 4.5/4.6 consensus is real but the adoption-timing confound is unresolved**

Multiple commenters (reedf1, pnathan, varispeed, BloondAndDoom) report Opus 4.5/4.6 as a clear step change. roxolotl offers a counter-hypothesis: "I'm more inclined to believe that 4.5 was the point that people started using it after having given up on copy/pasting output in 2024. If you're going from chat to agentic level of interaction it's going to feel like a leap." jeremyjh adds historical pattern evidence: "'Drastic increases in capability have happened the last 3-6 months' have been a constant refrain" for three years — suggesting every cohort of new adopters reports a breakthrough.

But the thread contains natural experiments that push back. BloondAndDoom describes an accidental model switch within the same Claude Code session — "after like an hour I realized the model somehow switched to Sonnet, Opus 4.6 is crazy good" — same harness, same task, stark quality difference. eterm held the harness constant (Claude Code throughout) and reports "vastly more back-and-forth and correction of 'dumb' things" on Sonnet 4.0 vs. later models. On the other side, roxolotl has used Claude Code since launch and sees no step change; sumeno reports "quality of the code is not particularly better" since Sonnet 3.5 despite using many models across the same project.

The split may be domain-dependent: commenters working on mainstream stacks report clearer model improvement, while niche-stack users (QML, complex backtesting) and those focused on harder architectural tasks see less. Toutouxc captures this: "faster and cleaner-looking solutions for certain issues" but "not sure about the ability to solve the actual hard stuff, i.e. the stuff I'm paid for."

**5. Domain-specificity matters more than headlines suggest**

sho_hn's comment is a standout: they write C++ and QML (a niche declarative language), and Codex 5.3 was the *first* model to not "super botch" QML. "My neck of the woods only really came online in 2026." This reveals that aggregate benchmarks mask enormous variance across the long tail of languages and frameworks. Meanwhile rubymamis (also Qt/QML) reports Opus 4.6 is much better than Codex 5.3 for the same stack. The frontier is jagged and domain-dependent.

**6. The dwedge hypothesis: have developers degraded?**

dwedge raises an uncomfortable possibility: "there's also the possibility that you've gotten worse after enough time using them." Mond_ immediately dismisses this in favor of "you've gotten better at prompting," and mike_hearn (35 years experience) pushes back with concrete evidence — his review prompts find fewer problems now. But the question lingers. If developers increasingly accept LLM-style code without editing, the perceived improvement could partly reflect shifting standards. Nobody engages with this deeply.

**7. Trust, not capability, is the binding constraint**

jygg4 and marcuschong surface a structural issue that goes beyond coding benchmarks. marcuschong's startup compared consultant replies to GPT Pro — "quality is roughly the same... but how to convince our customers?" The accountability gap ("who is liable when the LLM produces rubbish?") is a market friction that capability improvements alone won't solve. This maps to the broader pattern where adoption lags capability by years due to institutional trust requirements.

**8. The data contamination concern is growing**

anonnon and juancn raise the ouroboros problem: LLMs trained on LLM-generated code may be hitting a quality ceiling. juancn: "LLMs tend to go for an average by their nature... getting them better without fundamental changes requires one to improve the training data on average too." anonnon adds a sharper edge: open-source contributors are effectively providing free training data that "will ultimately render [them] unemployable" while their license terms are ignored. The thread doesn't fully grapple with this, but it's a structural headwind for the "just scale more data" thesis.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Article omits Opus 4.5/4.6 and Gemini | Strong | Legitimate — the data ends before models many consider a step change |
| Only 5 data points, can't fit any model | Strong | Statistical criticism is correct; the article overreads sparse data |
| Merge rate is a threshold metric, hides continuous improvement | Strong | yorwba's emergent abilities argument is well-grounded |
| "I can feel it's better" / vibes | Medium | Widely shared but confounded by harness improvements and selection bias |
| Tooling matters more than models | Medium | True but doesn't address the article's specific claim about model capability |
| Code quality is still terrible | Weak-Medium | Offered as counterpoint to improvement claims, but "terrible" is doing a lot of work |

### What the Thread Misses

- **The economic incentive to *appear* to improve.** Labs are pre-IPO. Token cost optimization is reportedly a focus for financial optics (postflopclarity). If labs are optimizing for cost rather than capability, flat merge rates aren't surprising — they're the strategy. Nobody connects these dots.
- **Selection bias in who speaks up.** The thread is dominated by people who use LLMs daily for coding. The developers who tried and stopped are absent. Survivorship bias inflates the "it's clearly better" consensus.
- **What "merge rate" actually tests.** The METR study had 4 maintainers from 3 repos review 296 PRs. That's an absurdly small sample with massive reviewer-dependent variance. The thread treats this as ground truth rather than a noisy pilot study.
- **The compound effect of harness + model isn't separable, and that's fine.** The thread treats "is it the model or the harness?" as a meaningful question. But for users, the product is the system. The obsession with isolating model improvement is a category error for predicting practical impact.

### Verdict

The article is technically correct — you can't demonstrate statistically significant merge-rate improvement from this data — but draws an unsupportable strong conclusion from 5 data points.

The thread's real contribution is surfacing an **attribution crisis**: practitioners can't agree on what's making them faster, and the thread splits roughly into three camps of comparable size. ~12 commenters attribute gains primarily to tooling/harness (ryanackley, idorozin, jwpapi, Incipient, orwin, juancn, rustyhancock, sd9, thesz, sumeno, thomascgalvin, sunaurus). ~10 commenters insist models themselves got meaningfully better, often citing specific model jumps like Opus 4.5→4.6 or Codex 5.3 (pnathan, BloondAndDoom, varispeed, sho_hn, rubymamis, mike_hearn, mavamaarten, AussieWog93, Flavius, postflopclarity). And ~6 commenters explicitly say they can't separate the two (aerhardt, eterm, sd9, sigbottle, ordersofmag, bbatha).

The "models got better" camp is notably specific — they name particular models and describe concrete behavioral changes (less code duplication, better idiomatic output in niche languages, fewer "dumb" mistakes). The "tooling is the driver" camp tends to speak in generalities. But the "models" camp is also almost entirely using agentic harnesses (Claude Code, Codex), making clean attribution impossible.

What the thread circles but never states: **model improvement and harness improvement may not be separable categories.** bbatha comes closest: "reasoning models really upped the game — 'plan' mode wouldn't work well without them." The models are being fine-tuned *for* agentic use; the harnesses are designed *around* model capabilities. They co-evolve. The question "is it the model or the tooling?" may be a false dichotomy — but it's one the industry needs to resolve, because it determines whether the competitive moat is in training runs or in product engineering.
