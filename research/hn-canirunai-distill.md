## HN Thread Distillation: "Can I run AI locally?"

**Article summary:** canirun.ai is an interactive web tool that auto-detects (via WebGL) your GPU/CPU and estimates which open-weight LLMs you can run locally, grading them S through F based on estimated tokens/second. It pulls model data from Ollama and presents a dark-themed dashboard with hardware dropdowns.

### Dominant Sentiment: Enthusiastic but trust-eroded

The thread is overwhelmingly positive on the *concept* — everyone wants this tool to exist — but rapidly sours on the *execution*. Nearly every technical user who cross-checked the estimates against their real hardware found the numbers wrong, often by 2-10×.

### Key Insights

**1. The site's core estimation is broken for MoE models, and MoE is where local AI actually lives now.**

The most substantive technical critique: canirun.ai estimates tok/s using `model_size / memory_bandwidth`, which is correct for dense models but wildly wrong for Mixture-of-Experts architectures (GPT-OSS, Qwen3.5-122B-A10B, etc.) where only a fraction of parameters are active per token. `meatmanek` explains: *"GPT-OSS-20B has 3.6B active parameters, so it should perform similarly to a 3-4B dense model, while requiring enough VRAM to fit the whole 20B model."* `lambda` confirms the estimates align with real-world only after inflating bandwidth by ~10× to compensate. This isn't a minor gap — MoE models are the dominant architecture for local inference right now, and the tool effectively tells users they can't run models they're already running.

**2. Qwen 3.5 9B is the thread's consensus sweet-spot model, but for a surprising reason.**

Multiple experienced users (`mark_l_watson`, `sdrinf`, `steve_adams_86`) converge on Qwen 3.5 9B as the standout local model — not because it's the smartest, but because of a specific architectural innovation: 75% of its attention uses a linear KV cache, meaning ~100K context costs only ~1.5GB VRAM. This breaks the old "small model = tiny context" constraint. `sdrinf`: *"for the first time you can do extremely long conversations / document processing with eg a 3060."* The practical implication: local models are no longer just for toy demos; they can handle real document-scale workloads on consumer hardware.

**3. The "local vs. API" economic debate has a hidden variable: cached reads.**

`pants2` makes the classic economic argument: *"To generate $3k worth of output tokens on my local Mac at that pricing it would have to run 10 years continuously."* But `throwdbaaway` fires back with a point the thread mostly ignores: *"90% of what you pay in agentic coding is for cached reads, which are free with local inference serving one user."* In agentic workflows, the model re-reads the same context repeatedly. API pricing charges for this; local doesn't. The break-even math shifts dramatically for agent-heavy usage patterns, and almost nobody in the thread runs these numbers.

**4. The Strix Halo laptop is quietly becoming the price/performance king for local inference.**

Buried in a setup guide, `the_pwner224` describes running 120GB of dynamic VRAM on a $2,800 128GB Asus ROG Flow Z13 tablet with AMD Strix Halo — Arch Linux, two kernel params, done. *"I can't believe this machine is still going for $2,800 with 128GB. It's an incredible value."* Multiple users confirm Apple-like unified memory behavior on Linux with trivial configuration. The thread's Apple-centric framing (M4/M5 discussions dominate) obscures that AMD has shipped a competitive unified-memory platform at half the price, with full Linux support and none of Apple's RAM upgrade tax.

**5. Browser hardware fingerprinting catches users off-guard.**

`torginus`: *"I never knew my browser just volunteers my exact hardware specs to any website."* The site uses WebGL to detect GPU model and estimate memory — standard fingerprinting vectors. `DanielHB` notes this is *"used a lot in browser fingerprinting for tracking."* LibreWolf prompts for permission; mainstream browsers don't. The irony: a tool aimed at privacy-conscious users (running models *locally* to avoid cloud data sharing) achieves hardware detection through the same APIs used for surveillance-grade tracking.

**6. The site silently presents quantized models as full models.**

`rahimnathwani` delivers the sharpest factual critique: *"The model this site calls 'Llama 3.1 8B' is actually a 4-bit quantized version (Q4_K_M)."* The full Llama 3.1 8B weights are 16GB+; the site lists 4.1GB. It also mislabels distilled models — "DeepSeek R1 1.5B" is actually a Qwen2 1.5B finetuned on R1 outputs. `zargon` traces this to blindly importing Ollama's naming conventions. For newcomers, this conflation of model identity with a specific quant is actively misleading about both capability and requirements.

**7. `llmfit` (CLI tool) steals the thread from the submission itself.**

`twampss` links [llmfit](https://github.com/AlexsJones/llmfit), a Rust CLI that detects your actual hardware, scores models across quality/speed/fit/context, and recommends quantization levels — essentially everything canirun.ai tries to do, but grounded in real system detection rather than WebGL estimation. `deanc`: *"llmfit is far more useful as it detects your system resources."* `Someone1234` correctly notes the two serve different audiences: llmfit for people who *have* hardware, canirun.ai for people *shopping* for it.

**8. The "vibe-coded dashboard" pattern is reaching saturation.**

`bearjaws`: *"So many people have vibe coded these websites, they are posted to Reddit near daily."* `mkagenius` literally built the same app two weeks prior. `hatthew`, on another clone's UI: *"I find it appealing, [but] I also strongly associate it with 'vibe coded webapp of dubious quality.'"* `tkfoss` is blunter: *"Nice UI, but crap data, probably llm generated."* The pattern — slick dark dashboard, estimated numbers, no real benchmarks — has become its own genre, and the thread is developing antibodies against it.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Numbers are wrong for my hardware" | **Strong** | Dozens of users report 2-10× discrepancies, especially MoE models and AMD hardware |
| "Missing my GPU/CPU" | **Medium** | RTX Pro 6000, 5060 Ti, Strix Halo, Tensor chips, many mobile GPUs absent — but it's a data completeness issue, not a design flaw |
| "Why no quality/benchmark scores?" | **Strong** | Multiple users want model intelligence ranked, not just speed — tok/s without quality is meaningless |
| "Dark theme is unreadable" | **Medium** | 5+ independent complaints about low-contrast grey-on-black; accessibility issue |
| "Local models aren't worth the hassle" | **Weak/Misapplied** | The economic argument ignores cached-read costs, privacy requirements, and the "I already own the hardware" framing |

### What the Thread Misses

- **No one asks who's behind the site or what the business model is.** A tool that fingerprints your exact GPU and ties it to model preferences is a goldmine for hardware recommendation affiliate links or targeted advertising. Zero scrutiny.
- **The quality/benchmark gap is solvable and someone should just do it.** Multiple users beg for it, nobody proposes wiring in existing benchmark data (MMLU, HumanEval, etc.) which is freely available. The data exists; the integration doesn't.
- **Quantization isn't a single knob.** The thread treats Q4/Q8 as binary choices, but modern quantization (Unsloth's UD quants, mixed-precision K_XL, imatrix calibration) is a spectrum. `azmenak` hints at this — *"Nemotron 3 Super using Unsloth's UD Q4_K_XL quant"* — but nobody explores how quantization strategy now matters more than model selection for local inference quality.
- **The "100 hours configuring" admission goes unchallenged.** `mark_l_watson` (top comment, 100+ points) cheerfully admits spending 100 hours on local model setup and says *"I don't recommend it for others"* — and then the entire thread proceeds to recommend it for others.

### Verdict

The thread reveals that local AI inference has crossed a usability threshold — Qwen 3.5 models on Apple Silicon or Strix Halo genuinely work for real tasks — but the tooling to *discover* what works remains embarrassingly bad. canirun.ai is a pretty interface over unreliable estimates, and the community knows it. The real signal is in what people are actually running: MoE models at aggressive quantizations with enormous context windows, a configuration space that no existing tool navigates well. The gap between "local models exist" and "I know which one to run on my hardware for my task" is the actual unsolved problem, and this site doesn't solve it — it just makes the question feel answered.
