# LLM Models & Pricing

← [Index](../README.md)

## Current Decisions

- **Primary:** Claude Opus 4.6 via Anthropic API (with Pi — gets native KV cache, prompt caching, signed reasoning blobs)
- **Free backup:** Gemini 2.5 Flash — 250 RPD, 1M context, thinking mode. Best free model available.
- **Free high-volume:** Gemini 2.5 Flash-Lite — 1,000 RPD, still thinking-capable
- **Not using:** Gemini 2.5 Pro (blocked on this key, `limit: 0`), any Gemini 3 Pro (paid only)
- **Removed from pi config:** All Google models — free tier quality too low for coding agent use

## Gemini Free Tier

Google's free tier is the most generous in the industry (no credit card, 1M context, commercial use).

| Model | RPM | RPD | Status on this key |
|---|---|---|---|
| **gemini-2.5-flash** ⭐ | 10 | 250 | ✅ Working |
| gemini-2.5-flash-lite | 15 | 1,000 | ✅ Working |
| gemini-2.5-pro | 5 | 100 | ❌ `limit: 0` — per-project block |

**Key lesson:** Live API test (`limit: 0`) is more reliable than blog posts for per-key availability. `limit: 0` means zero quota allocation, not a transient error.

⚠️ Google cut free tier limits 50-92% in Dec 2025 with no notice. Don't build production on free tier without a fallback.

## Model Landscape (Early 2026)

| Model | Developer | LM Arena Rank | Strengths |
|---|---|---|---|
| **Gemini 3 Pro** | Google | #1 (1490) | Best overall, reasoning, multimodal |
| Grok 4.1 Thinking | xAI | #2 (1477) | Real-time web, live data |
| Claude Opus 4.5 | Anthropic | #4–#5 | Best at coding (#1 code rank 1510) |
| **Claude Sonnet 4.6** | Anthropic | — | New mid-tier default, $3/$15, 1M context beta |
| GPT-5.1 | OpenAI | #9 (1458) | Math, science, reasoning |

**Sonnet 4.6** (Feb 17, 2026): Now default for all free/Pro users on claude.ai and Cowork. Named 4.6 (not 5) — refinement of 4.x architecture. 1M context in API beta. Key concern: extended thinking multiplies cost significantly (thinking tokens billed at output rate). Adaptive thinking mode is new.

## Deep Research

- [Gemini API Key — What Works](../research/google-gemini-api-key.md) — per-key limits, blocked models, deprecated models, operational reference
- [Gemini Market Research](../research/google-gemini-market.md) — pricing tiers, cost comparisons, consumer plans, competitor analysis, Dec 2025 incident
- [Sonnet 4.6 Analysis](../research/sonnet-4-6-analysis.md) — benchmarks, cost trap, thinking modes, community reception
