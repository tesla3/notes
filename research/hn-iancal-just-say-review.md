← [LLM World Models Thread](hn-llm-world-models-adversarial-reasoning.md) · [Index](../README.md)

# IanCal's "Just Say Review" Counter-Example

Source: [HN #46936920](https://news.ycombinator.com/item?id=46936920), comment by IanCal, Feb 2026. In response to Latent Space article "Experts Have World Models. LLMs Have Word Models."

## The article's setup

The article builds its thesis on a worked example. A new employee asks ChatGPT to draft a Slack message to Priya, the lead designer. ChatGPT writes a polite "no rush, whenever it fits your schedule" message. Two evaluations:

- **The outsider** (finance friend): "This is perfect. Polite, not pushy."
- **The expert** (coworker, 3 years tenure): "Don't send that. Priya triages by urgency signals. 'No rush' means you deprioritized yourself. 'Please take a look' is vague—she doesn't know if it's 10 minutes or 2 hours. Vague asks feel risky. She'll avoid it."

The article presents this as proof: the expert runs a *simulation* of Priya's mental model—workload, triage heuristics, ambiguity avoidance—while the LLM only evaluates text in isolation. World model vs. word model.

## What IanCal did

Fed the LLM-generated Slack message back to ChatGPT with one word: "review." Without even telling the model Priya is overloaded, ChatGPT produced:

1. **Diagnosis**: "Too passive and vague. In a busy work environment, saying 'no rush at all' or 'whenever' often leads to your request being buried at the bottom of a to-do list."
2. **Root cause analysis**: Missing link (makes recipient hunt for files), missing specificity ("any feedback" is mentally taxing), missing time signal (no deadline = no prioritization).
3. **Three alternative drafts** graded by scenario—balanced, respectful-of-time, quick-check—each demonstrating recipient-model reasoning.
4. **A practical checklist** the article's expert *didn't* think of: check file permissions, clean up scratchpad artboards.

Point 4 is subtle: the LLM's review didn't just match the expert—it *exceeded* it on practical dimensions. The expert focused on psychology; the model added logistics.

## Why this is devastating

The article's title is ontological: "LLMs Have Word Models" — the capability is *absent*, not dormant. But IanCal shows it's clearly present. The model:

- Models Priya's triage heuristics
- Understands cognitive cost of vagueness on the recipient
- Anticipates behavioral consequences (message sinks below things with deadlines)
- Proposes moves calibrated to different strategic contexts

This is exactly the "simulation of an ecosystem of agents" the article says lives "in heads, not in documents." But it came from a document-trained model with a one-word prompt change.

The article even concedes: "Steps 2–4 are possible with good prompting... **Step 1 is the problem**" (the model can't detect a situation is strategic). IanCal shows Step 1 is a one-word fix. That's not an architectural gap. It's a UX gap.

## Why it's less devastating than it looks

### 1. The easy scenario masks the hard scenario

A Slack message to a coworker is low-stakes, well-documented, extremely common. Training data is drowning in workplace communication advice. Of course the model can "review" this.

Now try: "Review this commercial lease clause for how opposing counsel will argue constructive eviction in 14 months given this specific judge's interpretation history in the Southern District." The adversarial knowledge here is qualitatively different—not in blog posts or self-help articles, but accumulated through decades of watching specific moves get exploited by specific opponents. "Just say review" works when adversarial patterns are well-documented in text. It fails when patterns were never written down—the article's deeper claim about "text as residue of action."

### 2. "Review" requires a human who already has the world model

IanCal knew to say "review" because *he* recognized the situation was strategic. The user in the article—three weeks into a new job—doesn't know what they don't know. They asked ChatGPT to write the message because they genuinely thought the task was "compose a polite request." The expert coworker intervened because they recognized the strategic dimension. IanCal played the role of the expert coworker.

This matters enormously for autonomous agents. When an LLM agent handles procurement negotiations or contract responses without human oversight, there's nobody to say "review." The agent encounters a strategically loaded situation, processes it as cooperative text generation, and fires off the message that leaks leverage. Step 1 failure in the wild has no one-word fix.

### 3. "Review" is mode-switching, not world-modeling

Saying "review" switches the model from *generation mode* (produce text that sounds good) to *evaluation mode* (find what's wrong). The model has been trained on enormous amounts of evaluative text—critiques, feedback, editing advice. It's very good at this mode.

But this isn't an integrated world model that *automatically* informs generation. A human expert doesn't write the polite email and then review it—they never write it in the first place. The world model is integrated into their generation process. The LLM requires an external loop: generate → review → regenerate. That loop works but requires someone to initiate it, and it's a workaround for missing integration, not evidence that integration exists.

## The real question

Is the gap between "review a Slack message for workplace dynamics" and "review a contract for adversarial exploitation by specific counterparties" a gap of **degree** or **kind**?

**If degree**: more data, better prompting, larger context, and agentic workflows with built-in review steps will close it incrementally. The article's prescribed RL revolution is unnecessary—we just need better scaffolding.

**If kind**: the Slack example is a parlor trick. The model retrieves well-documented social patterns and applies them on command. Adversarial domains where patterns were never documented—where knowledge exists only as embodied skill—require a fundamentally different training signal.

The honest answer: probably degree for some domains (workplace communication, common negotiations, standard social dynamics) and kind for others (novel adversarial scenarios, deliberately concealed strategies, domains with actively misleading training data). The article presents it as universally kind. IanCal shows it's clearly degree for the article's own chosen example—a self-inflicted wound in the argument.
