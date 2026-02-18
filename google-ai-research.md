# Google AI / LLM Research
_Last updated: 2026-02-17_

---

## 🏆 Google's Latest & Best LLM (Early 2026)

### Gemini 3 Pro — Current Flagship

Released November 2025 by **Google DeepMind**.

| Feature | Detail |
|---|---|
| Context Window | **1 million tokens** |
| Parameters | Over 1 trillion |
| API Pricing | $2.00/M input · $12.00/M output |
| LM Arena Rank | **#1** (score 1490, 27,827+ user votes) |
| Multimodal | Text, images, audio, video, code |

**Why it's the best:**
- 🥇 #1 on LM Arena — beats GPT-5.x and Grok in overall human preference
- Tops Epoch Capabilities Index, Artificial Analysis Intelligence Index, and Coding Index
- Excels at STEM, creative writing, coding, multimodal reasoning, and agentic tasks
- 1M token context window — best-in-class for long document analysis

**Known weaknesses (user reports):**
- Occasional conversation history bugs (forgets context mid-session)
- Can be overly literal — may not make inferential leaps like GPT
- Early stability issues post-launch

---

### Gemini Model Family Overview

| Model | Speed | Use Case |
|---|---|---|
| **Gemini 3 Pro** | Slow | Best overall, complex tasks, STEM, coding |
| **Gemini 3 Flash** | Fast | Default in Google Search/app, quick tasks |
| **Gemini 2.5 Pro** | Medium | Previous gen, still strong, cheaper than 3 Pro |
| **Gemini 2.5 Flash** | Fast | Free tier workhorse, 1M context + thinking |
| **Gemini 2.5 Flash-Lite** | Fastest | Ultra-cheap, simple tasks |

---

### How Gemini 3 Pro Stacks Up vs. Competition (Early 2026)

| Model | Developer | LM Arena Rank | Strengths |
|---|---|---|---|
| **Gemini 3 Pro** | Google | **#1** (1490) | Best overall, reasoning, multimodal |
| Grok 4.1 Thinking | xAI | #2 (1477) | Real-time web, live data |
| Claude Opus 4.5 | Anthropic | #4–#5 | Best at coding (#1 code rank 1510) |
| GPT-5.1 | OpenAI | #9 (1458) | Math, science, reasoning |

---

## 🔑 Gemini API Key — Free Tier Analysis

**Key location:** `~/.zshrc` as `GEMINI_API_KEY`

**Key status:** ✅ Valid — no authentication error

**Root issue:** Several models have `free_tier_requests limit: 0` — not a rate limit
you can wait out, but zero free quota permanently.

---

### 🚫 Paid-Only / Blocked Models (limit: 0 on this key)

| Model | Notes |
|---|---|
| `gemini-2.5-pro` | Globally documented as free (100 RPD), but **consistently `limit: 0` on this key** — likely project-level restriction from Dec 2025 crackdown |
| `gemini-3-pro-preview` | Newest gen Pro — paid only |
| `gemini-2.0-flash` | Was free, removed from free tier |
| `gemini-2.0-flash-lite` | Paid only |
| `gemini-exp-1206` | Experimental — paid only |

> **`gemini-2.5-pro` note:** Multiple Feb 2026 sources (laozhang.ai, aifreeapi.com) confirm 100 RPD free globally. However, two separate live tests on 2026-02-17 returned `limit: 0` consistently for this key. This is a **per-project restriction**, not a transient error. May be due to regional block (EU/EEA/UK/CH) or project flagged during Dec 2025 abuse crackdown. Do not use with this key.

---

### ✅ Free Tier Models (confirmed working on this key)

| Model | RPM | RPD | Context | Notes |
|---|---|---|---|---|
| **`gemini-2.5-flash`** ⭐ | 10 | 250 | 1,048,576 / 65,536 | 🧠 Thinking · **Best workhorse** |
| `gemini-2.5-flash-lite` | 15 | 1,000 | 1,048,576 / 65,536 | 🧠 Thinking · High-volume/cheap |
| `gemma-3-27b-it` | — | — | 131,072 / 8,192 | Open weights |
| `gemma-3-12b-it` | — | — | 32,768 / 8,192 | Open weights |
| `gemma-3-4b-it` | — | — | 32,768 / 8,192 | Open weights |
| `gemma-3-1b-it` | — | — | 32,768 / 8,192 | Open weights · Tiny/fast |

---

### ⚠️ Deprecated Models

| Model | Status |
|---|---|
| `gemini-2.5-flash-preview-09-2025` | 404 — officially deprecated, use `gemini-2.5-flash` |

---

### 💡 Recommendations

- **Best free model (this key):** `gemini-2.5-flash` — 1M context, thinking mode, strong performance
- **High-volume cheap:** `gemini-2.5-flash-lite` — 1,000 req/day, still thinking-capable
- **Need Pro-level:** Enable billing at https://aistudio.google.com — or create a fresh project/key to try getting 2.5-pro free access
- **Full model list API:** `GET https://generativelanguage.googleapis.com/v1beta/models?key=YOUR_KEY`
- **Rate limit monitor:** https://ai.dev/rate-limit

---

### Total Models Accessible with Key

**45 models** returned by the API (includes text, image, video, audio, embedding models).
