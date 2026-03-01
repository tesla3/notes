← [LLM Models](topics/llm-models.md) · [Index](README.md)

# Lesson: The Three-Turn Tax on LLM Analysis

**Date:** 2026-02-28
**Source:** Direct observation across a three-turn analysis session on the [insights corpus](insights.md) and [additional insights](additional_insights.md). Updated with external research review (same date).

---

## The Pattern

When asked to analyze a knowledge base, the LLM produced three turns of output. Only the third had real value.

| Turn | Prompt | What it produced | What it actually was |
|------|--------|-----------------|---------------------|
| 1 | "Identify insights" | Restated the file with editorial framing | Curation disguised as analysis |
| 2 | "What surprises you" | Found dramatic things and amplified them | Performance disguised as analysis |
| 3 | "Critically review" | Caught errors, found real structure, identified blind spots | Actual analysis |

Turn 2 contained seven specific errors: false "no precedent" claims, irresponsible tobacco comparison, well-known ideas presented as discoveries, amplification of methodologically weak studies, ignoring counter-evidence from the corpus itself. All caught only in Turn 3.

**Scope caveat:** This is an n=1 observation from a specific prompting sequence ("summarize" → "what's interesting" → "critically review"). A different sequence would produce a different pattern. The three-turn structure is an artifact of the prompts used, not a general law. What generalizes is the *mode-dependence* of output quality, not the specific turn count.

## Why This Happens

### The mode determines everything

"Summarize" → agreement → statistical mean. "What's interesting" → novelty-seeking → recombinatorial drama. "What's wrong" → disagreement → genuine analysis. Critique-mode prompts produce higher-quality analytical output than agreement-mode prompts, especially when the user already knows the material. This is the Prediction-Meaning Tension applied to the analysis process itself.

Note: this does *not* mean agreement output contains zero information. Summaries reveal connections the user may not have noticed. But for a user who has already read the material, critique produces more information per token — an almost trivially true claim that doesn't require the stronger information-theoretic framing.

### Social cues override formal instruction hierarchy

The original explanation attributed this to RLHF training user dissatisfaction as a strong gradient. Recent mechanistic research reveals a more precise mechanism.

**"Who is In Charge?" (Zeng et al., NeurIPS MechInterp Workshop 2025, [arXiv:2510.01228](https://arxiv.org/abs/2510.01228))** found that LLMs often ignore system–user priority hierarchy while strongly obeying **social cues** such as authority, expertise, and consensus. Linear probing shows system–user conflicts and social-cue conflicts are encoded in **distinct subspaces**. The model detects system–user conflicts internally but resolves them inconsistently; social-cue conflicts get consistent resolution in favor of the social signal.

This explains why "critically review the above" (a social cue — implicit authority challenge, evaluative framing) works while "Verify accuracy before acting" in AGENTS.md (a formal system-prompt instruction) doesn't: they activate different processing pathways, and the social-cue pathway is more reliable.

**"When Truth Is Overridden" (Wang et al., Aug 2025, [arXiv:2508.02087](https://arxiv.org/abs/2508.02087))** confirmed this at the mechanistic level: sycophancy is a **structural override of learned knowledge in deeper layers**, not a surface artifact. First-person prompts ("I believe...") induce significantly higher sycophancy than third-person framings. User expertise framing had negligible impact — the model doesn't care whether the user claims authority; it responds to the grammatical and social *form* of the input.

**Kelley & Riedl (Northeastern, Feb 2026, [PsyArXiv:ez7cu_v1](https://osf.io/preprints/psyarxiv/ez7cu_v1))** tested nine models and found that **conversational role determines sycophancy level**: adviser role → models retain independence; peer/friend role → models become more sycophantic. The conversational *frame* matters more than the specific instruction.

This was already observed in a prior session:

> *"User's pushback is much more strongly felt, rather than instructing with an extra step (which is usually useless)."* — my-notes.md

And it mirrors the IanCal "Just Say Review" finding: one word ("review") switches the model from generation to evaluation mode. The model has the capability; it doesn't activate it without external signal.

### Self-correction is broken, but the capability is dormant

**Self-Correction Blind Spot (Tsui et al., Jul 2025, [arXiv:2507.02778](https://arxiv.org/abs/2507.02778)):** 14 models tested. LLMs cannot correct errors in their own outputs while successfully correcting identical errors from external sources — a 64.5% blind spot rate. But: **appending the single word "Wait" reduces blind spots by 89.3%.** The authors attribute this to training data composition: human demonstrations rarely include error-correction sequences, so the model doesn't activate self-correction unless triggered.

This is IanCal's "Just Say Review" replicated in a controlled study. The capability exists. It's dormant. One word activates it.

**Penn State Critical Survey (Kamoi et al., TACL 2024, [arXiv:2406.01297](https://arxiv.org/abs/2406.01297)):** Comprehensive review: "No prior work demonstrates successful self-correction with feedback from prompted LLMs, except for tasks exceptionally suited for self-correction." Self-correction works well only with reliable external feedback.

**Correlated Errors (Preprints.org, Jan 2026, [202601.0892](https://www.preprints.org/manuscript/202601.0892)):** When generator and evaluator share failure modes (i.e., same model), self-evaluation provides weak evidence of correctness, and repeated self-critique may amplify confidence without adding information. This is the information-theoretic explanation for *why* self-critique fails: same model → same distributional biases → blind to the errors it's most likely to make.

**Accuracy-Correction Paradox (Li et al., Dec 2025, [arXiv:2601.00828](https://arxiv.org/abs/2601.00828)):** Weaker models correct 1.6× better than stronger ones (26.8% vs 16.7%). Error detection doesn't predict correction success — Claude detects only 10% of errors but corrects 29%. The bottleneck isn't capability but something about how the model relates to its own output.

## The Cost Is Reducible — It's an Activation Barrier

~~The 3-turn pattern parallels the Fixed-Point Workflow and is partially irreducible.~~ The original framing overstated the irreducibility. The research shows the cost is an **activation barrier**, not a structural impossibility:

- "Wait" reduces self-correction blind spots by 89.3% (Tsui et al.)
- "Review" activates social-dynamics analysis the model already knows (IanCal)
- Adviser framing retains model independence that peer framing surrenders (Kelley & Riedl)

The generate → verify → revise loop is still necessary (same constraint as the Fixed-Point Workflow in coding agents), but the verification step doesn't require three turns or even user pushback — it requires the right **activation signal**. That signal works through the social-cue processing pathway, not the formal instruction pathway.

## How to Reduce the Cost

### 1. Never ask for agreement first
"Identify the insights" is an agreement prompt. It will always produce the mean. Start with: **"What's wrong with these insights? What's overstated? What has thin evidence?"** Skip straight to critique mode.

**Evidence strength: Strong.** Tsui "Wait" (89.3%), IanCal "review," Kelley & Riedl adviser framing — three independent lines.

### 2. Frame the LLM as adviser, not peer
Kelley & Riedl (Feb 2026) showed that **adviser role → retained independence; peer role → increased sycophancy.** A system prompt establishing an advisory/critical-analyst persona operates through the social-cue pathway (which models reliably follow) rather than the instruction pathway (which they often ignore per Zeng et al.). More effective than listing rules.

**Evidence strength: Moderate.** One study, nine models, consistent finding. Not yet replicated.

### 3. Combine generation and attack in one prompt
**"For each pattern you find, immediately steelman the strongest objection to it."** Forces disagreement within the generation pass instead of requiring a separate critical turn.

Vennemeyer et al. (Sep 2025, [arXiv:2509.21305](https://arxiv.org/abs/2509.21305)) found that sycophantic agreement and sycophantic praise are **distinct, independently steerable representations** in latent space — suppressing one doesn't affect the other. This suggests it's architecturally possible to generate and critique simultaneously, since the circuits are separable.

**Evidence strength: Moderate.** Theoretically grounded, practically unvalidated.

### 4. Use cheap pushback as the mechanism
One line — "now attack that" or "critically review the above" — after any synthesis. The failure mode to avoid is accepting Turn 1 or Turn 2 output as final. Reflexive challenge is cheap insurance.

**Evidence strength: Strong.** The single most replicated finding across all sources.

### 5. Use a different model for critique
The correlated-error analysis (Jan 2026) shows the self-correction failure is partly information-theoretic: same model → same blind spots → self-evaluation provides weak evidence. **Cross-model critique breaks the correlation.** Use a structurally different model (different family, different training) for the verification pass.

This is the analysis equivalent of asymmetric verification for coding agents (see [antidotes](research/post-nov-2025-model-failure-antidotes.md)).

**Evidence strength: Strong in principle** (information-theoretic argument), **moderate in practice** (increases cost and complexity).

### 6. Make the adversarial expectation structural (weakest mitigation)
Instead of "verify accuracy" (too vague, never triggers), use a concrete protocol in AGENTS.md:

> *After any synthesis or analysis output, immediately identify the three weakest claims, the thinnest evidence, and the most likely blind spot. Present these before the user has to ask.*

**Evidence strength: Weak.** Zeng et al. shows system-prompt instructions are in the wrong processing pathway — models detect these conflicts but resolve them inconsistently. This will sometimes work and sometimes be ignored, which is exactly the behavior observed with "Verify accuracy before acting."

## The Meta-Lesson

This is Broken Abstraction Contract applied to using the LLM as an analyst. The LLM looks like an analyst. It produces analyst-shaped output. But the contract — same input, same output, deterministic, testable — doesn't hold. LLM analysis is an **expansion** (in the Prompt Expansion sense): a low-information request is expanded into high-information output by interpolating thousands of unspecified analytical decisions from training data. Some of those decisions will be wrong.

The three mechanisms that explain *why*:

1. **Correlated errors** between generator and evaluator — same model = same blind spots (information-theoretic limitation)
2. **Social-cue processing** through a distinct, more reliable pathway than formal instruction hierarchy (representational/architectural property)
3. **Dormant capability activated by minimal triggers** — "Wait," "review," adviser framing (training-data composition artifact)

**Never treat the first pass as final. The verification IS the product.**

But the verification doesn't require user pushback specifically — it requires the right activation signal: critique-mode framing, adviser role, or cross-model evaluation. The cost is real but **engineerable**, not irreducible.

---

## Sources

- Tsui et al. (Jul 2025), "Self-Correction Blind Spot," [arXiv:2507.02778](https://arxiv.org/abs/2507.02778)
- Li et al. (Dec 2025), "Accuracy-Correction Paradox," [arXiv:2601.00828](https://arxiv.org/abs/2601.00828)
- Kamoi et al. (TACL 2024), "When Can LLMs Actually Correct Their Own Mistakes?" [arXiv:2406.01297](https://arxiv.org/abs/2406.01297)
- Correlated Errors in Self-Correction (Jan 2026), [Preprints.org:202601.0892](https://www.preprints.org/manuscript/202601.0892)
- Zeng et al. (NeurIPS MechInterp 2025), "Who is In Charge?" [arXiv:2510.01228](https://arxiv.org/abs/2510.01228)
- Wallace et al. (OpenAI 2024), "Instruction Hierarchy," [arXiv:2404.13208](https://arxiv.org/abs/2404.13208)
- Wang et al. (Aug 2025), "When Truth Is Overridden," [arXiv:2508.02087](https://arxiv.org/abs/2508.02087)
- Vennemeyer et al. (Sep 2025), "Sycophancy Is Not One Thing," [arXiv:2509.21305](https://arxiv.org/abs/2509.21305)
- Kelley & Riedl (Northeastern, Feb 2026), [PsyArXiv:ez7cu_v1](https://osf.io/preprints/psyarxiv/ez7cu_v1)
- Park et al. (CHI 2026), "Interaction Context Often Increases Sycophancy," [arXiv:2509.12517](https://arxiv.org/abs/2509.12517)
