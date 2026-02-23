← [LLM World Models Thread](hn-llm-world-models-adversarial-reasoning.md) · [Index](../README.md)

# robh78's Cognition/Decision Split

Source: [HN #46936920](https://news.ycombinator.com/item?id=46936920), comment by robh78, Feb 2026. In response to Latent Space article "Experts Have World Models. LLMs Have Word Models."

## The argument

robh78 arrives late in a thread where two camps have been fighting for dozens of comments about whether LLMs have world models or merely word models. The structure:

1. **Both camps are right about different things.** "Word model" camp is right: LLMs lack autonomous grounding, don't perceive or test hypotheses against reality. "World model" camp is right: LLMs encode far richer internal structure than token statistics—entities, roles, temporal order, causal regularities, counterfactuals, social dynamics.

2. **They're arguing past each other because "model" is overloaded.** One side means "representational structure" (does the model encode world-relevant patterns?). The other means "authoritative access to reality" (can the model make grounded claims?). These are different capabilities.

3. **The actual split:**
   - **Cognition**: exploring possibilities, tracking constraints, simulating implications, holding multiple interpretations.
   - **Decision**: collapsing that space into a single claim about what is true, what matters, what should happen.

4. **LLMs are good at cognition, not entitled to decision.** The failure mode isn't "models lack structure"—it's "models or users quietly treat cognition as decision." Four substitutions that break things:
   - coherence → truth
   - explanation → diagnosis
   - simulation → fact
   - "sounds right" → "is settled"

5. **Reframe:** Stop asking "does it understand the world?" Start asking "when, and under what conditions, should its outputs be treated as authoritative?"

> "These systems build rich internal representations that are often world-relevant, but they do not have autonomous authority to turn those representations into claims without external grounding or explicit human commitment." —robh78

## Why this is good

### Dissolves the thread's most exhausting debate

D-Machine and famouswaffles fought for dozens of comments about whether LLMs model the world or model text about the world. robh78 shows they're arguing about different layers of the same system. D-Machine is right that LLMs lack grounding (they can't make authoritative decisions). famouswaffles is right that LLMs encode rich structure (they do genuine cognition). The fight was over whether "model" means "represents" or "has authority over." Once you disambiguate, there's nothing left to argue about.

### Explains the IanCal counter-example perfectly

When a user asks ChatGPT to "write a Slack message," the output is *treated as a decision*—this is what I should send. The user collapses the model's generation into action. When IanCal says "review," he explicitly requests *cognition*—explore the possibility space of how this message might land. The model can do both. The failure isn't capability but frame: generation mode produces outputs that *look like* decisions (a complete, sendable message), which users naturally treat as decisions, even though the model has no grounding to warrant that treatment.

This is why "just say review" works but isn't a real fix. The user who needs the review most—the one who doesn't know the situation is strategic—is precisely the one who'll treat the first output as a decision.

### Connects to Pluribus unexpectedly

The article says Pluribus wins at poker by being unreadable—it doesn't just produce reasonable-looking bets, it calibrates for unexploitability. In robh78's frame: Pluribus was trained to make *decisions* (actions grounded in game-theoretic optimality), not just *cognitions* (explorations of what a reasonable bet looks like). LLMs are trained for cognition and users mistake it for decision. Pluribus is trained for decision and outsiders mistake it for cognition ("the bets look reasonable"). The visible surface is the same; the grounding is completely different.

### Makes the governance question tractable

"Does the model understand the world?" is intractable philosophy. "Under what conditions should this model's outputs be treated as authoritative?" is engineering with concrete answers we already partially know. Domains with cheap verification (code compilation, math proofs, chess) can safely grant authority because you can check. Domains without verification (strategy, design, law) can't.

## Why it's incomplete

### 1. The split doesn't hold in agentic deployment

robh78's framework assumes a human mediator between LLM output and real-world action. The human sees the cognition, applies judgment, and decides whether to grant it authority. This works for ChatGPT-in-a-browser.

But the industry trajectory is toward agents that *act*. When an LLM agent sends the procurement email, files the legal brief, or responds to the vendor's counteroffer, generation IS decision. There's no separate step where someone decides whether to treat the output as authoritative—the agent treats its own output as authoritative by construction. The cognition/decision split collapses the moment you remove the human from the loop.

Descriptively correct for today's human-in-the-loop usage. Prescriptively inadequate for tomorrow's agentic deployment—which is exactly the deployment the article is concerned with.

### 2. Knowing when to withhold authority requires the authority you're trying to withhold

"When should outputs be treated as authoritative?" sounds tractable, but answering it requires domain expertise—the same expertise you need the LLM to replace. A junior developer can't tell when the model's architectural suggestion should be treated as a decision vs. an exploration, because they don't know enough to evaluate it. An expert can, but the expert doesn't need the model as much.

Dunning-Kruger applied to AI delegation: the people most likely to treat cognition as decision are the people least equipped to know the difference. And they're the model's largest user base.

### 3. It doesn't address the adversarial case

robh78's framework is about epistemic authority—when should you *believe* the model? The article's concern is about strategic robustness—does the model's *behavior* survive contact with a self-interested opponent? These are different problems.

Even if you perfectly distinguish cognition from decision, an adversary probing your LLM agent doesn't care about your epistemological framework. They exploit behavioral patterns in the model's outputs regardless of whether anyone treats those outputs as authoritative. The model's cooperative bias, accommodation anchoring, and charitable ambiguity resolution are strategic vulnerabilities that exist independent of authority governance.

The cognition/decision split helps consumers of LLM output. It doesn't help builders deploying LLMs into adversarial environments.

### 4. "Cognition" may be too generous a label

robh78 says LLMs do genuine cognition: "exploring possibilities, tracking constraints, simulating implications, holding multiple interpretations." But is what LLMs do *actually* exploration of a possibility space, or is it generation of text that *looks like* exploration?

Real cognition has a property LLM generation might lack: *sensitivity to discovered constraints*. When a human explores a possibility space and encounters a contradiction, that contradiction *changes the exploration*—you backtrack, revise, abandon branches. LLMs in a single forward pass can't do this; they commit to each token. Chain-of-thought approximates it, but breaks on problems where the contradiction only becomes visible late in the reasoning chain, after tokens are committed.

If what LLMs do is closer to "generating text that resembles cognition" than "actual cognition," robh78's framework gives too much credit to the first half while correctly skepticizing the second.

## Connection to existing insights

The cognition/decision split is remarkably consonant with several existing insights—almost a unifying meta-frame:

| Insight | Cognition/Decision mapping |
|---------|---------------------------|
| **Facts Without Judgment** | Facts = cognition; judgment = decision. Same split, different words. |
| **Verification Gate** | Verification is what licenses treating cognition as decision. Domains with cheap verification can safely grant authority. |
| **Broken Abstraction Contract** | Treating cognition as decision IS the broken contract—assuming the output has guarantees it doesn't carry. |
| **Steering ∝ Theory** | Steering is the human supplying the decision component—the theory that converts LLM cognition into action. |
| **Theory Formation Threshold** | The real capability gap is whether the model can form theories coherent enough to ground decisions, not whether it has world models. |

The cognition/decision split is essentially [Facts Without Judgment](../insights.md#facts-without-judgment) restated at a higher level of abstraction. Tools give facts (cognition); judgment (decision) requires grounding the tools can't provide. robh78 extends it from tool-augmented LLMs to LLMs generally.

The practical upshot: if this frame is right, the industry's obsession with "does the model understand?" is a red herring. The question is purely about governance infrastructure—when and how do you license an LLM to act? And the answer tracks domain verifiability, not model capability.
