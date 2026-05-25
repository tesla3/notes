← [Index](../README.md)

# Meeting Recording & Analysis — Minimum Friction Pipelines

How to go from "I'm in a meeting" to "I have useful analysis" with the least possible effort. Two tiers: text-only and beyond-text (tone, emotion, dynamics). Discreet throughout.

## The Insight That Simplifies Everything

iPhone Voice Memos (iOS 18+) already records and transcribes on-device. That's your capture layer — it's free, private, pre-installed, and nobody questions someone with their phone on the table. The real question is: **what do you do with the output?**

Two completely different problems:
1. **Text analysis** — what was said. Transcribe → feed to LLM. Solved, low friction.
2. **Beyond-text analysis** — how it was said. Requires the actual audio, not a transcript. Harder, but newly possible because GPT-4o and Gemini process audio natively.

---

## Tier 1: Text Analysis (Minimum Friction)

### Pipeline: 3 taps + 1 paste

1. **Record:** Open Voice Memos → tap the red button → place phone face-up on table (or in shirt pocket if being subtle)
2. **After meeting:** Open Voice Memos → tap the recording → view transcript (auto-generated, on-device)
3. **Analyze:** Copy the transcript → paste into Claude / ChatGPT → add your prompt

**Example prompt:**
> Analyze this meeting transcript. Identify: key decisions made, action items with owners, unresolved disagreements, topics that got the most pushback, and anything that was notably avoided or deflected.

**What you get:** Decisions, action items, summaries, sentiment from word choice, who talked most (if speakers are labeled), patterns of agreement/disagreement.

**What you don't get:** Anything about HOW things were said. Sarcasm, nervousness, fake enthusiasm, uncomfortable silences, vocal dominance — all invisible in text.

### Friction assessment

This is genuinely low friction. The bottleneck is **transcript quality from Voice Memos**. Apple's on-device transcription is good for clear audio but degrades with:
- Multiple overlapping speakers
- Background noise
- Accents or technical jargon
- Phone in pocket (muffled)

**If Voice Memos transcript quality isn't good enough:**
- Export the .m4a and run through Whisper (free, local, much better for messy audio)
- MacWhisper (Mac app, $30 one-time) makes this point-and-click: drop file → get transcript
- Or upload audio to ChatGPT — it transcribes internally before analyzing

### Even lower friction option

**Just upload the audio file directly to ChatGPT or Claude.** Both accept audio. You don't need the transcript step at all — the model transcribes and analyzes in one shot. Skip Voice Memos' transcript entirely, just use it as a recorder.

Share from Voice Memos → ChatGPT → "Analyze this meeting."

---

## Tier 2: Beyond-Text Analysis (Tone, Emotion, Dynamics)

This is the interesting one. You want to know not just what was said, but:
- Who was nervous, defensive, or evasive?
- Where did someone's tone shift?
- Who dominated and who got steamrolled?
- Were there uncomfortable pauses?
- Did someone say "yes" but sound like they meant "no"?
- Confidence levels, engagement, power dynamics

### Pipeline: Same recording, different destination

1. **Record:** Same as Tier 1. Voice Memos. Phone on the table is better than pocket — audio quality matters more here because you need the model to hear tone, not just words.
2. **After meeting:** Share the .m4a file (not the transcript)
3. **Upload audio to a model that processes audio natively:**
   - **Google AI Studio** (free tier, Gemini) — handles very long audio (hours) due to massive context window. Upload at aistudio.google.com.
   - **ChatGPT** (GPT-4o) — good audio understanding, paid tier for long files.

**Example prompt for beyond-text analysis:**
> Listen to this meeting recording carefully. Go beyond what was said — analyze HOW it was said. For each participant, assess:
> - Confidence level and shifts in confidence
> - Emotional tone (engaged, defensive, nervous, frustrated, performative)
> - Speaking patterns (who dominates, who gets interrupted, who defers)
> - Moments where tone contradicts words (saying "sure" reluctantly, forced agreement)
> - Uncomfortable silences or tension points
> - Power dynamics between participants
>
> Give me a per-person profile and a timeline of emotional/dynamic shifts.

### How good is this actually?

Honest assessment as of early 2026:

**What the models genuinely pick up on:**
- Obvious emotional shifts (raised voice, excitement, frustration)
- Speech pace changes (someone suddenly speaking faster or slower)
- Long pauses and hesitations
- Who talks more vs less (dominance)
- Laughter, sighs, audible discomfort
- Interruption patterns

**What they're mediocre at:**
- Subtle sarcasm or passive aggression
- Micro-expressions in voice (slight vocal fry, tiny pitch shifts)
- Distinguishing nervousness from excitement (similar physiological signals)
- Cultural/contextual tone norms (what's "rude" varies enormously)

**What they can't really do:**
- Reliable deception detection (no AI can, despite marketing claims)
- Subconscious leakage analysis (that's pop psychology, not science)
- Speaker identification without being told who's who

**Verdict:** Genuinely useful for catching things text analysis misses. Not a replacement for a perceptive human listener. Think of it as "a reasonably attentive colleague who was also in the room" — it'll catch the big stuff, miss the subtle stuff.

### Audio quality matters enormously

For beyond-text analysis, the model needs to actually *hear* the voices clearly:

| Placement | Text Analysis | Beyond-Text Analysis |
|---|---|---|
| Phone face-up on table | Excellent | Good — best option |
| Phone in shirt pocket | Good | Mediocre — muffled, your voice dominates |
| Phone in bag/pocket | Okay | Poor — too muffled for tone |
| Across a large room | Poor | Useless |

**If you want better audio and can't put phone on table**, a small clip-on or lapel mic plugged into the phone dramatically improves quality. But that's more conspicuous.

---

## The Discreet Angle

### Recording discreetly

- **Phone on table** — completely normal. Nobody questions it. Best audio quality.
- **Voice Memos is ideal** — it's a stock Apple app, not a suspicious "spy recorder." Start recording, lock screen, done. Records in background.
- **Apple Watch** — even more discreet. Voice Memos or Just Press Record app. Tap to start, tap to stop. Nobody notices. Audio quality is worse (further from speakers, tiny mic) but usable for text transcription.

### Processing discreetly

Where does the audio go?

| Method | Who sees your audio? |
|---|---|
| Voice Memos transcript only | Nobody — on-device processing |
| Whisper (local) | Nobody — runs on your computer |
| MacWhisper | Nobody — local processing |
| Upload to ChatGPT | OpenAI |
| Upload to Google AI Studio | Google |
| Upload to Claude | Anthropic |

**If privacy is paramount:** Record with Voice Memos → transfer to Mac → run Whisper locally for transcription → feed transcript (not audio) to LLM for text analysis. The audio never leaves your devices.

**For beyond-text analysis** there's no fully-local option that's both good and low-friction today. You have to send the audio to a model that understands audio natively, which means a cloud provider. Pick the one you trust most.

### Legal reality

Recording laws vary by jurisdiction. In many US states and most of Europe, **one-party consent** is sufficient — if you're in the meeting, you can record it. But some jurisdictions (California, Illinois, parts of EU) require **all-party consent**. Know your local law. This guide doesn't tell you to break it.

---

## Recommended Setups by Friction Level

### Ultra-low friction (text only)

**Record** with Voice Memos → **share audio** to ChatGPT → ask for analysis.

One recording step, one share step, one prompt. Done. Skip the transcript entirely — let the model handle it.

### Low friction (text + beyond-text)

**Record** with Voice Memos → **share .m4a to Google AI Studio** (free, handles long audio) → **two prompts:**

1. "Transcribe this meeting and analyze: decisions, action items, disagreements, key themes."
2. "Now analyze how things were said, not just what. Tone shifts, confidence, who dominated, tension points, moments where tone contradicted words."

Two prompts because you want both layers. Could combine into one but the analysis is richer when separated.

### Paranoid-private (text only, nothing leaves your devices)

**Record** with Voice Memos → **AirDrop .m4a to Mac** → **run through MacWhisper** (local Whisper) → copy transcript → paste into a local LLM (Ollama + Llama 3) or into Claude/ChatGPT if you're okay with the text (but not audio) going to cloud.

More friction, but the audio never leaves your hardware.

### If you want to go further

**Specialized tools** (more setup, more capability):

- **Otter.ai** — live transcription + speaker separation + auto-summaries. Designed for meetings. Cloud-based, paid ($17/mo). Good if you do this often and don't mind cloud processing.
- **Fireflies.ai** — similar to Otter, integrates with Zoom/Teams/Meet for automatic recording.
- **Hume AI** — specialized emotion detection from voice. API-based. Best-in-class for paralinguistic analysis but requires developer setup.
- **Granola** — Mac app, designed for meeting notes. Listens to system audio, generates notes. Slick but cloud-dependent.

These trade privacy for convenience. For occasional one-off analysis, the "Voice Memos + AI Studio" pipeline beats all of them on friction.

---

## What I'd Actually Do

**For most meetings:** Voice Memos, phone on table. After, share audio to ChatGPT or Gemini. One prompt combining both tiers: "Analyze this meeting — content, decisions, action items, and also the dynamics: tone, emotion, who dominated, tension points." Takes 2 minutes after the meeting ends.

**For sensitive meetings where the beyond-text matters most:** Same recording. Upload to Gemini (longer context window = handles 2+ hour meetings without truncation). Run the detailed beyond-text prompt separately. Compare the text-only analysis to the audio analysis — the delta is where the interesting stuff lives.

**For meetings where I need total privacy:** Voice Memos → AirDrop to Mac → MacWhisper for transcript → paste transcript into LLM. Accept that I lose the beyond-text layer (no good local option for that yet).
