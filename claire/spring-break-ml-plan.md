# Spring Break ML Plan for Claire

Created: 2026-03-22
Revised: 2026-03-22 (time budget, tone, checkpoints, Karpathy bonus, evening sessions)

## Context

- 10th grade, Bishop's School, 16.5yo
- Calc BC (honors), 1 year Python (coursework only, VS Code, no numpy/matplotlib)
- FTC robotics — auto-distancing is a real problem her team uses (13 real measurements)
- MacBook Air M3, RTX 3090 reachable via Tailscale SSH tunnel
- Expressed interest in learning ML, couldn't come up with a project idea
- Independent learner — doesn't want side-by-side coaching, will come to dad when stuck
- Minimal LLM experience (school prohibits; tried it, found "horrible for English, somewhat useful for history")
- Spring break: week of Mar 30. ~5-6 evenings for ML (AP Chem review during the day)
- Dad is ML expert, available evenings in the next room during her ML sessions
- She hasn't seen any of this planning. She knows: "I'll give you some ideas to explore."

## Goal

Find out if ML hooks her, and what specifically hooks her. Not a curriculum, not a competition pipeline — a week of guided exploration where she's the one making discoveries. If she walks away wanting more, we figure out what "more" means together. If she doesn't, that's fine.

**This plan supersedes the "backprop from scratch first" recommendation in `roblox-ml-projects-for-daughter.md`.** Rationale: discovery before rigor. If she's hooked, depth comes later with real motivation behind it.

## Before Spring Break (Dad, Not Claire)

### Environment (Mar 23 — together)

Set up her MacBook with:
- Python environment (micromamba), Jupyter notebook
- `numpy`, `matplotlib`, `scikit-learn`, `torch`, `torchvision`
- Walk through Jupyter basics together: cells, shift-enter, kernel, saving. 30 minutes.

**No Colab.** Local Jupyter is cleaner — no idle timeouts, she owns the files, persistent environment. Her M3 handles everything through Phase 2 easily (no GPU needed for polynomial regression or tiny neural nets).

**3090 on standby.** Set up SSH tunnel via Tailscale before spring break. Test it once. She won't need it unless she picks the LLM probing option in Phase 3. Don't mention it until then.

### Notebooks (Mar 23–29 — dad builds these)

Prepare **2–3 guided Jupyter notebooks** — her "lab manuals." Markdown cells with context, questions, suggestions. Empty code cells where she writes. Not a textbook, not a walkthrough — guided investigations where she's the scientist. Enough structure to not get lost, enough gaps to require thinking.

She's never used numpy or matplotlib — the notebooks should give her enough to get started (`import numpy as np`, basic array creation, `plt.plot()` examples) but NOT teach a numpy course. She'll search what she needs. The notebook's job is to make the *ML concepts* discoverable, not to teach Python libraries.

**Critical:** do NOT include the `auto_distancing.py` solutions. She arrives at the same conclusions through her own code.

---

## Phase 1 (Evenings 1–3): Your Robot's Data

**The pitch:** *"Your robot needs to shoot from any distance on the field. You measured power at 13 distances. How do you predict power for distances you didn't measure?"*

This is the core of the week. If she only finishes this phase and nothing else, she's learned real ML concepts from her own robot's data. That's a win.

**Notebook arc — suggestions, not a script:**

1. **Plot the data.** What shape is it? Eyeball a guess — linear? Curved? *(First time using matplotlib — expect 20-30 min just getting a plot to show up. That's fine.)*
2. **Fit a line** (degree 1) with `np.polyfit`. Plot it over the data. How bad is it? *(Introduce MSE as "average squared distance from the line." She knows what squaring does from calc.)*
3. **Fit degree 2.** Better? How much? Plot both. *"Which would you trust for a distance you haven't tested?"*
4. **Fit degree 5, then degree 10, then degree 12.** They pass through every point! Perfect score! *"But what does the degree-12 curve predict at distance 55, between two data points? Plot it. Does that look right?"*
5. **Pause and think.** *"You have 13 data points and a degree-12 polynomial that gets zero training error. But you wouldn't trust it. Why not? And if you can't trust zero error — how DO you choose the right model?"* Let her sit with this. She might figure out the answer.
6. **One idea: hide some data from yourself.** Hold out 3-4 points. Fit on the rest. Check error on the held-out points. Try degrees 1 through 6. Which wins on the data it hasn't seen?
7. **But the split was random.** Try a different split. Different answer. *"How do you make this less dependent on which points you happened to hold out?"*
8. **`cross_val_score` from sklearn.** She runs it, sees degree 2 wins consistently. *(Brief intro to sklearn — just enough to call one function.)*
9. **Final fit on all 13 points.** Plot it. *"This is what your robot could use during a match."*
10. **Optional/if curious:** *"Your polynomial minimizes squared error. That's an optimization problem — find the input (coefficients) that minimizes a function (total error). Sound familiar from calc?"*

**What she discovers (without being told the vocabulary first):** Regression. Overfitting. Train/test split. Cross-validation. Model selection. These concepts arrive as answers to *her* questions about *her* robot.

**Calc BC connection — let it emerge, don't force it.** If she asks "how does polyfit actually work?" — that's the opening to connect minimization and derivatives. If she doesn't ask, that's fine. The seed is planted.

### ☕ Checkpoint: Dinner after Evening 2 or 3

*"What's the most surprising thing you found?"*

If she talks about the degree-12 curve going haywire — she got it. If she talks about cross-validation — she got it deeply. If she's frustrated — find out where she's stuck and unstick her. No judgment either way.

**What to watch for (privately, not out loud):**
- Did she modify anything in the notebook on her own? Add experiments you didn't suggest?
- Did she keep working past when she planned to stop?
- Is she explaining it to you, or reporting back?

---

## Phase 2 (Evenings 3–4): What If Polynomials Aren't Enough?

> **⚠️ Superseded:** This section described a PyTorch-based notebook. The actual Notebook 2 (`02-what-if-polynomials-arent-enough.ipynb`) uses **micrograd** (Parts 1–2) and **raw numpy** (Part 3) instead — no PyTorch for model building. Better pedagogical choice: every line of the engine is readable. The notebook is the source of truth.

**Only start this if Phase 1 felt solid.** If Phase 1 took all 3 evenings and she's still working through it, let her finish. Phase 1 done well is worth more than Phases 1+2 done rushed.

**Bridge:** *"What you just did — fitting a function to data by minimizing error — that IS machine learning. Polynomial regression is the simplest ML model. But what if the relationship is too complicated for any polynomial?"*

**Notebook arc — split across two evenings if needed:**

**Evening 3 (or whenever she's ready):**

1. **Same 13 data points, new tool.** Build a tiny neural net in PyTorch (2 layers, ~10 neurons). The notebook provides the skeleton — she fills in pieces, runs it. Train on the same data. Plot alongside her degree-2 polynomial. *"For 13 data points and a smooth relationship — which approach would you trust more? Why?"* (The polynomial wins. This is the point.)
2. **A harder problem.** Give her a synthetic dataset with a shape no polynomial handles well (piecewise, or a sine wave with varying amplitude). Try her polynomial approach. It flails. The neural net handles it. *"So when is each tool the right one?"*

**Evening 4:**

3. **What's actually inside this thing?** Open the net up: weights, biases, ReLU. *"Each neuron computes `y = max(0, wx + b)`. The whole network is a stack of these. It learned the weights by doing the same thing as polyfit — minimizing error — but using the chain rule to figure out how each weight should change."*
4. **The chain rule connection.** Sketch (on paper or in a markdown cell) the computational graph for a 2-layer net. The gradient flows backward through the chain rule. *"This is called backpropagation. It's the chain rule from your calc class, applied to a chain of functions."* Don't belabor it. Plant the seed.

**What she discovers:** Neural nets as function approximators. Gradient descent. When simple models beat complex ones. Backprop as the chain rule — her math, applied to the thing everyone's talking about.

**Key design choice:** She does NOT implement backprop from scratch here. PyTorch handles it. The insight that it's the chain rule is enough for now. If she wants to go deeper later, she'll have real motivation.

**If she asks "how does loss.backward() actually work?" — don't answer fully.** Say: *"It's computing the chain rule through every operation in the network. There's a ~200-line Python file that implements ALL of GPT using nothing but that chain rule. Want to see it?"* → See bonus challenge below.

### 🧩 Bonus Challenge (End of Phase 2 Notebook)

At the bottom of the Phase 2 notebook, as the last cell:

> **Challenge — The Entire GPT Algorithm**
>
> Someone wrote all of GPT — the complete algorithm behind ChatGPT — in [~200 lines of pure Python](https://gist.github.com/karpathy/8627fe009c40f57531cb18360106ce95). No PyTorch. No numpy. Just Python and math. *"This file is the complete algorithm. Everything else is just efficiency."*
>
> You won't understand all of it yet. The attention mechanism uses linear algebra you haven't taken. Skip those parts.
>
> Your challenge: **how much of this can you read after what you learned this week?** Find the chain rule. Find the gradient descent. Find where it's doing the same thing as your polynomial regression — minimizing a loss by computing derivatives.
>
> You'll be surprised how much of GPT is math you already know.
>
> **Rabbit hole — if you want to understand backprop for real:**
>
> [CS231n Lecture 4: Backpropagation](https://www.youtube.com/watch?v=i94OvYb6noo) (~75 min) — Andrej Karpathy (ex-OpenAI/Tesla AI director) teaching at Stanford. He explains backprop using computational graphs and the chain rule. It's a lecture, not a coding tutorial — similar format to 3Blue1Brown, but at a Stanford undergrad level. You have Calc BC. You'll be fine.
>
> **If you want to build it yourself after that:** Karpathy's [micrograd video](https://www.youtube.com/watch?v=VMj-3S1tku0) (2.5 hrs) — he implements a neural net engine from scratch in Python, no libraries, using the chain rule to do backpropagation by hand. His pitch: *"If you know Python and have a vague recollection of taking some derivatives in high school, watch this and not understand backpropagation by the end, then I will eat a shoe."* You have Calc BC, not a vague recollection.
>
> *(If you've seen 3Blue1Brown's neural net series — that's the visual intuition. The Stanford lecture is the math. The micrograd video is the code. Same idea, three angles.)*

Don't mention any of this verbally. Don't sell it. Let the notebook do the work. If she opens it, she opens it. If she doesn't, she doesn't.

### ☕ Checkpoint: Dinner after Evening 4

*"What's the most surprising thing you found?"*

New question to add if the conversation flows: *"When would you use a polynomial and when would you use a neural net?"* If she has a crisp answer, Phase 2 landed.

**Watch for:**
- Did she open the Karpathy gist? If yes — implementation path is live.
- Did she ask about how `loss.backward()` works? → Wants to understand the mechanism.
- Did she ask about what neural nets are used for in the real world? → Application/curiosity path.
- Did she run extra experiments you didn't suggest? → Scientific instinct.

---

## Phase 3 (Evenings 5–6): Go Deeper — She Picks

**Only if Phase 2 is done and she has energy.** If she's still in Phase 2, or if she went deep on the Karpathy gist, let that be the week. Don't rush to Phase 3.

After Phases 1–2, she has real vocabulary: regression, overfitting, cross-validation, neural nets, gradient descent. Now she can apply it to something new. **Present these as options. She picks. If none grab her, that's a signal too.**

*"Here are a few things you could explore. Pick whichever sounds interesting — or come up with something else."*

### Option A: "AI Lie Detector" — Probe a Language Model

*"You said ChatGPT was horrible for English and somewhat useful for history. Can you figure out WHY?"*

- Run Llama 3.1 8B on the 3090 (dad sets up the tunnel). Ask it 30-40 questions from domains she knows well: Calc BC problems, AP Chem questions, FTC rules.
- Grade each answer: right, wrong, partially right, confidently wrong.
- Look for patterns: is it better at computation or concepts? Does it fail on recent information? Does it get worse when problems require multiple steps?
- *"You're building a map of where AI is reliable and where it isn't. Most adults don't have this map."*

**Why this one might fit:** Low-code, high-thinking. Connects directly to her own observation. Exercises evaluation and taxonomy skills. If it hooks her, it extends naturally into a longer project.

### Option B: "Fool Your Phone" — Adversarial Attacks

*"You learned that gradient descent changes the model to reduce error. What if you flip it — change the INPUT to increase error?"*

- Load a pretrained MobileNet. Classify objects around the house with her phone camera.
- Compute the gradient of the loss with respect to the input image.
- Add a tiny perturbation. Watch the classification flip. A banana becomes a toaster.
- *"The same chain rule that trains the network can break it. Same math, opposite direction."*

**Why this one might fit:** Visceral, visual, shareable. Good if she's drawn to the "break things" mindset. Makes a great demo.

### Option C: "See Like a Robot" — Image Classification for FTC

- Photograph game elements, field landmarks, robot positions (15-20 images per class is enough for fine-tuning).
- Fine-tune a pretrained model in PyTorch on her photos.
- Test it. Where does it fail? Lighting? Angle? Distance?
- *"This is how vision-based auto-aim works. Now you know why it fails when the lighting changes."*

**Why this one might fit:** Directly useful for her team next season. Tangible outcome.

### Option D: Something Else Entirely

If she has her own idea by this point — something she wants to try ML on — that's the best outcome. Don't steer her back to the menu.

### ☕ Checkpoint: Dinner after Evening 6 (or end of the week)

This is the big one. Two questions:

*"What's the most surprising thing you found this week?"*

*"Is there anything you want to keep exploring after break?"*

The answer to the second question tells you everything. Don't prompt with suggestions. Let her answer first. If it's "yes, I want to..." — listen to what follows. If it's "that was fun" with no pull toward more — that's a complete answer too.

---

## What This Plan Is NOT

- It's not a course. It's a set of investigations she can explore at her own pace.
- It's not the finished `auto_distancing.py`. She builds her own version.
- It's not comprehensive. It skips huge areas (NLP, generative models, RL) to go deep on one thread: **data → model → evaluate → understand**.
- It's not a commitment to anything beyond this week.

---

## Pacing Reality Check

She has ~5-6 evenings, maybe 2.5-3.5 hours each. That's **12-20 hours** of ML time. With no numpy experience and Jupyter being new, expect overhead.

| Phase | Evenings | Status |
|---|---|---|
| **Phase 1** (auto-distancing) | 2–3 | Must-have. If she only finishes this, the week was a success. |
| **Phase 2** (neural nets) | 1–2 | Stretch. Only if Phase 1 is solid. |
| **Bonus** (Karpathy gist) | — | Self-directed. She engages or doesn't. |
| **Phase 3** (mini-project) | 1–2 | Bonus. Only if Phase 2 is done and she has energy. |

**If Phase 1 takes all week:** That's fine. She learned regression, overfitting, cross-validation, and model selection from her own robot's data using tools she taught herself. That's more than most intro ML courses cover in a week.

**If she finishes Phase 2 and skips Phase 3 to deep-dive the Karpathy gist:** That's fine too. Let her follow whatever pulls her.

---

## After Spring Break — What to Watch For

Don't evaluate the week by whether she hit a specific milestone. Watch for behavioral signals:

| Signal | What it might mean |
|---|---|
| She brings up something from the week unprompted | It's still on her mind — strongest signal |
| She shows a friend or texts someone about a result | Identity forming ("I'm someone who does this") |
| She asks "but why does..." questions after the week ends | Conceptual curiosity is still active |
| She says "I want to understand how [X] works" | Implementation path — Karpathy micrograd video is the natural next step |
| She says "I want to test whether AI can do [Y]" | Evaluation path — the "Can GPT Do Calc BC?" project |
| She says "I want to build [Z] for the robot" | Application path — FTC-related ML project |
| She says "that was fun" and moves on | Genuine answer. Don't push. |

**Whatever direction she pulls, that's the direction to support.** The follow-up conversation happens naturally, not on a schedule. If she's still thinking about it in April, the longer project ideas (see `roblox-ml-projects-for-daughter.md`) become relevant. If not, she learned real things and has a foundation if she returns later.
