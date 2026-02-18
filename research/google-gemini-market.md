← [LLM Models](../topics/llm-models.md) · [Index](../README.md)

# Google LLM Offering Research — February 2026

## Google's LLM Lineup (Gemini Family)

### Current Models (newest → oldest)

| Model | Input/1M tokens | Output/1M tokens | Context | Quality Tier |
|---|---|---|---|---|
| **Gemini 3 Pro Preview** | $2.00 | $12.00 | 1M (2M soon) | 🏆 Flagship |
| **Gemini 3 Flash Preview** | $0.50 | $3.00 | 1M | Frontier + Speed |
| **Gemini 2.5 Pro** | $1.25 | $10.00 | 1M | Best for coding |
| **Gemini 2.5 Flash** | $0.30 | $2.50 | 1M | Hybrid reasoning |
| **Gemini 2.5 Flash-Lite** | $0.10 | $0.40 | 1M | Cost-effective |
| **Gemini 2.0 Flash** | $0.10 | $0.40 | 1M | Balanced |
| **Gemini 2.0 Flash-Lite** | $0.08 | $0.30 | 1M | Fastest/cheapest |

### Cost Optimization Levers
- **Batch API**: 50% off all models (for async workloads)
- **Context Caching**: ~90% savings on repeated prompts/system messages
- **Long Context surcharge**: Pro models charge 2× for >200K token inputs

---

## 🆓 FREE TIER (Best Bang for Zero Bucks)

Google's free tier via **Google AI Studio** (aistudio.google.com) is the most generous free LLM API in the industry.

### Free Tier Rate Limits

| Model | RPM | Tokens/min | Requests/day |
|---|---|---|---|
| **Gemini 2.5 Pro** | 5 | 250K | 100 |
| **Gemini 2.5 Flash** | 10 | 250K | 250 |
| **Gemini 2.5 Flash-Lite** | 15 | 250K | 1,000 |

### Key Free Tier Facts
- ✅ **No credit card required** — just a Google account
- ✅ **1 million token context window** (8× GPT-4o's 128K, 5× Claude's 200K)
- ✅ **Commercial use allowed** (outside EU/EEA/UK/Switzerland)
- ✅ Access to Pro, Flash, and Flash-Lite models
- ✅ Google Search grounding: 500 requests/day free on Flash models
- ⚠️ Data may be used for model improvement (free tier only)
- ⚠️ Limits were cut 50-80% in December 2025 — can change without notice
- ❌ No free access for Gemini 3 Pro Preview (paid only)
- ❌ EU/EEA/UK/Switzerland blocked on free tier

### Free Tier vs. Competitors

| Feature | **Google Gemini** | OpenAI | Anthropic Claude |
|---|---|---|---|
| Free API access | ✅ Ongoing | $5 credit (expires 3mo) | ❌ None |
| Credit card needed | No | No (for trial) | Yes |
| Context window | **1M tokens** | 128K | 200K |
| Best free model | Gemini 2.5 Pro | GPT-4o mini | N/A |
| Daily requests | 100–1,000 | Credit-based | N/A |

**Google wins free tier hands down.** Nothing else comes close.

---

## 💰 Paid API — Best Bang for the Buck

### Cheapest Capable Models in the Industry

**Gemini 2.5 Flash-Lite** / **Gemini 2.0 Flash-Lite** at $0.08–$0.10 input / $0.30–$0.40 output per 1M tokens.

### Real-World Cost Comparison (Chatbot: 1,000 conversations/day)

| Model | Monthly Cost |
|---|---|
| Gemini Flash-Lite | **$9–$12/mo** |
| Gemini 2.5 Flash | $47/mo |
| Claude 4.5 Haiku | $132/mo |
| GPT-5 | $1,050/mo |

### Document Processing (1,000 docs/day, 10K tokens each, 1K output)

| Model | Monthly Cost |
|---|---|
| Gemini 3 Flash | **$42/mo** |
| Claude 4.5 Sonnet | $1,350/mo |
| GPT-5 | $3,900/mo |

---

## 💳 Consumer Subscription Plans

| Plan | Price | What You Get |
|---|---|---|
| **Gemini Free** | $0 | Gemini 3 Flash (Auto mode), limited Thinking (3 Pro), daily caps |
| **Google AI Plus** | $7.99/mo | New US-only tier, image gen, search grounding |
| **Google AI Pro** | $19.99/mo | Gemini 3 Pro, Deep Research, 2TB Drive, Workspace AI |
| **Google AI Ultra** | $249.99/mo | Highest model access, maximum limits |
| **Workspace Business** | $20/user/mo | AI in Gmail, Docs, Sheets, basic admin |
| **Workspace Enterprise** | $30/user/mo | Full Gemini 3 Pro, Meet AI, enterprise security |

---

## 🔧 Additional Models Available via API

Beyond text LLMs, the Gemini API also provides:
- **Nano Banana** (gemini-2.5-flash-image) — image generation via Flash
- **Nano Banana Pro** (gemini-3-pro-image-preview) — premium image gen ($0.134–$0.24/image)
- **Imagen 4** — standalone image generation ($0.02–$0.06/image)
- **Gemma 3** (1B, 4B, 12B, 27B) — open-weight models
- **TTS models** — text-to-speech
- **Deep Research Pro** — agentic deep research
- **Computer Use Preview** — computer interaction agent

---

## 🏆 Recommendations

1. **Absolute best free option**: Sign up at aistudio.google.com, use **Gemini 2.5 Flash** (250 req/day) or **Gemini 2.5 Pro** (100 req/day). No credit card, no expiring credits, 1M context window.

2. **Best paid value for developers**: **Gemini 2.5 Flash-Lite** at $0.10/$0.40 per 1M tokens — 10-100× cheaper than competing frontier models.

3. **Best quality-to-price ratio**: **Gemini 2.5 Flash** at $0.30/$2.50 per 1M tokens — strong reasoning with optional thinking mode.

4. **Smart routing strategy**: Simple tasks → Flash-Lite (cheapest), moderate → Flash, complex reasoning → 2.5 Pro. Spreads across separate free-tier quotas for ~3× effective capacity.

---

## Paid Tier Upgrade Path

- **Tier 1**: Add payment method → immediate upgrade, ~150-300 RPM for Flash
- **Tier 2**: $250 cumulative spend + 30 days → 1,000+ RPM
- **Tier 3**: Enterprise arrangement → 4,000+ RPM with SLAs

## December 2025 Rate Limit Incident

Google cut free tier limits by 50-92% on Dec 6-7, 2025 with no advance notice. Originally "only supposed to be available for a single weekend" but "inadvertently lingered for months." Cited "at scale fraud and abuse." Key lesson: don't build production on free tier without fallback strategy.

---

*Research date: February 17, 2026*
*Sources: Google AI Studio, costgoat.com, scriptbyai.com, laozhang.ai, sentisight.ai, zenvanriel.nl, futureagi.substack.com, dev.to, apidog.com*
