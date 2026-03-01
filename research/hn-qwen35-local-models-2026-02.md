← [Index](../README.md)

## HN Thread Distillation: "Qwen3.5 122B and 35B models offer Sonnet 4.5 performance on local computers"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47199781) (277 points, 178 comments) · [VentureBeat article](https://venturebeat.com/technology/alibabas-new-open-source-qwen3-5-medium-models-offer-sonnet-4-5-performance) · 2026-02-28

**Article summary:** VentureBeat PR piece for Alibaba's Qwen3.5 model family — a 35B MoE (3B active), 122B MoE (10B active), and 27B dense model — claiming near-Sonnet 4.5 benchmark performance, long context on consumer GPUs, and aggressive API pricing. The article includes a pricing comparison table that doubles as an ad for Alibaba Cloud.

### Dominant Sentiment: Impressed but deeply skeptical

The thread splits cleanly: enthusiasm for the *trajectory* of open models, near-unanimous rejection of the headline claim. Nobody who has actually used both Qwen3.5 and Sonnet 4.5 says they're equivalent.

### Key Insights

**1. The benchmark credibility crisis is now structural, not episodic**

This isn't "some benchmarks are gamed" — the thread treats *all* static benchmarks as compromised by default. `Aurornis` sets the frame early: "All of the open source models are playing benchmark optimization games. Every new open weight model comes with promises of being as good as something SOTA from a few months ago then they always disappoint in actual use." `TrainedMonkey` sharpens it: "there is tremendous reputational and financial pressure to make benchmark number go up. So you add specific problems to training data... the benchmarks overstate the progress." Even the submitter `lostmsu` concedes the title is misleading, admitting "I failed to find more neutral source." The only benchmarks anyone trusts are private ones like [APEX Testing](https://www.apex-testing.org/), where Qwen models don't appear in the top tier at all.

**2. The MoE naming convention is actively misleading users**

"Qwen3.5-35B-A3B" sounds like a 35B model. It activates 3B parameters per forward pass. Multiple users ran it expecting 35B-class intelligence and got 3B-class output. `Paddyz` explains: "You're essentially running a 3B-class model for inference quality while paying the memory cost of loading 35B parameters." `jbellis` is blunt: "35b is shit. fast shit, but shit." Meanwhile, the 27B *dense* model and the 122B MoE (10B active) get genuine praise. The naming is not just confusing — it's causing people to have bad first experiences and write off the entire family.

**3. The real story is the routing frontier, not benchmark parity**

`Paddyz` delivers the thread's most actionable insight: "the cost-performance frontier has shifted enough that a thoughtful routing strategy (cheap/local model for 70% of tasks, frontier API for the 30% that actually needs it) is now viable in a way it wasn't even 6 months ago." This reframes the narrative from "open = closed" to "open is now good enough for the fat middle." Structured output, classification, code completion — open models at 30B+ are genuinely competitive. Complex reasoning, long-horizon planning, deep domain knowledge — frontier closed models still win by a significant margin. The binary "is it as good as Sonnet?" framing misses this entirely.

**4. Local inference is a minefield of confounds**

Users are getting wildly different results from the *same model* due to: Ollama bugs with Qwen3.5 templates (`xmddmx` documents specific looping issues), quantization choices (unsloth dynamic vs. standard GGUF), sampling parameters (repeat/presence penalties causing reasoning loops), missing system prompts (the model enters "weird planning mode" without a long system prompt — `lachiflippi` demonstrates this concretely), and thermal throttling on laptops. `syntaxing` nails it: "there's so many knobs to LLM inferencing and any can make the experience worse. It's not always the model's fault." The gap between "model capability" and "what users experience" is enormous and mostly tooling-shaped.

**5. The 27B dense model is the sleeper hit**

While the headline pushes the 35B MoE and 122B MoE, multiple experienced users converge on the 27B dense model as the real winner for local use. `jbellis` (promising Monday benchmarks): "27b is the smartest local-sized model in the world by a wide wide margin." `CamperBob2` recommends it over the 35B MoE. `dimgl`: "This is the first time I am seriously blown away by coding performance on a local model." The 27B fits comfortably on a single 24GB GPU at decent quantization with meaningful context — the practical sweet spot the headline models don't actually occupy.

**6. "Sonnet 4.5 performance" is a moving target that flatters the claim**

The submitter's own link shows Qwen3.5 landing "somewhere between Haiku 4.5 and Sonnet 4.5." `CharlesW` points out the absurdity: "That's like saying 'somewhere between Eliza and Haiku 4.5'." `aspenmartin` notes "opus 4.6 is night and day compared to sonnet 4.5" — the claim benchmarks against a model that's already two generations behind. `throwdbaaway` offers a more honest calibration: "27B matches with Sonnet 4.0, while 397B A17B matches with Opus 4.1." The headline exploits the fact that "Sonnet 4.5" sounds frontier when it's actually the floor of acceptable.

**7. Local models have found their niche — and it's not general intelligence**

`vunderba` describes a production setup: Qwen3-VL for image captioning, Gemma3 for translation, Llama3.1 for sentiment analysis. `tempest_` captures the consensus: "good for in line IDE integration or operating on small functions or library code but I don't think you will get too far with one shot feature implementation." `__mharrison__` got a working Polars PCA implementation in 10 minutes — impressive for a constrained, well-defined task. The pattern: local models excel at structured, bounded tasks where you can verify output. They fail at open-ended reasoning where you're trusting the model's judgment.

**8. The hardware conversation has matured significantly**

The thread doubles as a useful hardware buying guide. Key signal: RTX 6000 Pro Blackwell (96GB) is the serious option; used 3090s are the budget entry point; Strix Halo boxes are the AMD dark horse; Apple Silicon (M4/M5 Max 128GB) is convenient but thermally constrained for sustained loads. `wolvoleo` reports 30% performance gains from pinning server fans to 100%. Multiple users warn against laptops for sustained LLM inference — even high-end MBPs will thermal throttle within minutes.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Benchmarks are gamed / training data contaminated | Strong | Near-universal agreement, well-argued with mechanism |
| MoE active params ≠ model intelligence | Strong | Directly explains user disappointment with 35B-A3B |
| Laptop thermals kill sustained inference | Medium | Real but overstated — many users get acceptable results |
| Chinese models can't be trusted | Weak | Conflates model provenance with deployment location; open weights are auditable |
| Local models are fundamentally inferior | Medium | True for general intelligence, false for constrained tasks |

### What the Thread Misses

- **Nobody discusses the training data question seriously.** If Qwen3.5 benchmarks well on public benchmarks, how much of that is training on benchmark solutions vs. genuine capability? The thread asserts gaming but nobody tries to measure the gap or propose methodology.
- **The agentic scaffolding gap.** Claude Code, Cursor, Codex all have model-specific optimizations. Open models running through generic harnesses face a systematic disadvantage that has nothing to do with model quality. `airstrike` hints at this but gets dismissed.
- **Cost of local inference is never honestly calculated.** Hardware depreciation, electricity, time spent debugging tooling — the "free" local model isn't free. Nobody compares the true cost per useful token against a $20/month API subscription.
- **The geopolitical subtext is barely scratched.** A few comments about Chinese models, but nobody engages with the strategic implications of the best open models being Chinese while the best closed models are American. One European commenter (`shell0x`) trusts China more than America — a sentiment likely more common outside the US tech bubble than HN represents.

### Deep Dive: Qwen3.5-27B Dense — The Sleeper Hit

The HN thread's convergence on the 27B dense model as the real winner is well-supported by benchmarks and community experience, but the picture is more nuanced than "27B > everything else in the family."

**Why 27B punches above its weight**

All 27B parameters active on every forward pass — no routing, no sparsity tricks. This makes it the most predictable and deployment-friendly model in the lineup. The benchmarks back this up decisively:

| Metric | 27B Dense | 35B-A3B (3B active) | 122B-A10B | GPT-5-mini |
|--------|-----------|---------------------|-----------|------------|
| SWE-bench Verified | **72.4** | 69.2 | 72.0 | 72.0 |
| LiveCodeBench v6 | **80.7** | 74.6 | 78.9 | 80.5 |
| IFEval (instruction following) | **95.0** | 91.9 | 93.4 | 93.9 |
| HMMT (math) | **92.0** | 89.0 | 91.4 | 89.2 |
| VITA-Bench (video) | **41.9** | 31.9 | 33.6 | 13.9 |
| TAU2-Bench (agent) | 79.0 | **81.2** | 79.5 | 69.8 |

Source: [AwesomeAgents model card](https://awesomeagents.ai/models/qwen-3-5-27b/), Qwen team benchmarks.

The 27B leads the family on coding, instruction following, math, and video understanding. The 35B-A3B only wins on agent tasks (TAU2-Bench) — likely because agentic benchmarks reward speed and iteration count, where 3B active params at 100 t/s beats 27B active at 20 t/s.

**The effective intelligence gap is massive**

r/LocalLLaMA has converged on a rule of thumb: for MoE models, effective intelligence ≈ sqrt(total × active). For the 35B-A3B: sqrt(35 × 3) ≈ 10B equivalent. The 27B dense model has nearly **3× the effective intelligence** of the 35B-A3B. Users report it "feels like a heavyweight champion in reasoning" while the 35B-A3B "sits somewhere between a 7B and 14B model in terms of wisdom." The naming is genuinely misleading — people expect 35B > 27B, but the opposite is true for quality.

**The speed tradeoff is real though**

This is where the "sleeper" narrative has a caveat. On an RTX 3090:

- **35B-A3B:** 60-100+ t/s generation (3B active compute per token)
- **27B dense:** 15-25 t/s generation (27B active compute per token)

That's 3-5× slower. For agentic coding workflows where the model iterates in a loop — try something, check, retry — the 35B-A3B's speed advantage is significant. One Reddit poster ran their recruitment coding test: the 35B-A3B completed it in ~10 minutes at 100 t/s. The 27B would take 3-5× longer on the same hardware. Several r/LocalLLaMA users prefer the 35B-A3B specifically for agentic use despite lower per-token quality, because iteration speed compounds.

**Hardware fit is the deciding factor**

| Setup | Best choice | Why |
|-------|-------------|-----|
| 16GB VRAM (RTX 4070 Ti) | 27B at Q4 (~14GB) | Fits with room for context; 35B-A3B Q4 exceeds 16GB |
| 24GB VRAM (RTX 3090/4090) | Either — 27B at Q6/Q8 or 35B-A3B at Q8 | 27B for quality, 35B for speed |
| 48GB+ VRAM (A6000, dual GPUs) | 27B at Q8/BF16 | Full quality, no quantization loss |
| 128GB unified (Mac M4 Max) | 122B-A10B at Q4-Q6 | Can fit the bigger model; 27B is "wasting" available memory |

Unsloth recommends: "Between 27B and 35B-A3B, use 27B if you want slightly more accurate results. Go for 35B-A3B if you want much faster inference."

**Critical deployment notes**

1. **Sampling parameters matter enormously.** Thinking mode needs: temp 0.6, top_p 0.95, top_k 20, min_p 0.0. For precise coding: temp 1.0, top_p 0.95, presence_penalty 1.5. Wrong settings cause reasoning loops.
2. **System prompt required.** Without a long system prompt, Qwen3.5 enters a pathological planning mode — reasoning for minutes about formatting before doing anything. Claude's or Gemini's system prompts both work well.
3. **Use Unsloth Dynamic quants.** They upcast important layers to 8/16-bit even in 4-bit overall — measurably better than standard GGUF quants. Feb 27 update fixed tool-calling chat templates; re-download recommended.
4. **Ollama has active bugs** with Qwen3.5 template handling. llama.cpp directly is more reliable as of late Feb 2026.
5. **Dense models are more quantization-tolerant.** No expert routing means no sparse activation sensitivity. Standard inference engines handle them more maturely than MoE models.

**Bottom line**

The 27B is the best *quality-per-VRAM* model in the Qwen3.5 family and arguably the best local model available at its size class — `jbellis` calls it "the smartest local-sized model in the world by a wide wide margin." But calling it the universal winner oversimplifies: for agentic workflows where you're in a tight code-test-iterate loop, the 35B-A3B's 3-5× speed advantage can matter more than per-token quality. The right choice depends on whether your bottleneck is model intelligence or iteration speed.

### Verdict

The thread correctly identifies that the headline is marketing — Qwen3.5 doesn't match Sonnet 4.5 in practice — but then mostly argues about the wrong thing. The interesting development isn't benchmark parity; it's that open models have crossed a *utility threshold* for constrained tasks that makes hybrid local/cloud architectures economically rational for the first time. The thread circles this insight repeatedly without stating it as the paradigm shift it is. Meanwhile, the local inference tooling ecosystem (Ollama, llama.cpp, MLX) is introducing enough variance that model-to-model comparisons are nearly meaningless without controlling for runtime — a confound that will only get worse as the models themselves converge.
