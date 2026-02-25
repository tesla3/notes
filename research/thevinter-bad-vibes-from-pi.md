← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# "Bad Vibes From Pi" — Critical Blog Review & Analysis

**Source:** [thevinter.com/blog/bad-vibes-from-pi](https://www.thevinter.com/blog/bad-vibes-from-pi)  
**Author:** Nikita Brancatisano (thevinter) — Software Engineer at Deloitte innoWake, Germany  
**Date reviewed:** February 23, 2026

---

## What This Is

A detailed, first-person account of trying to migrate from Claude Code to Pi, written by a practitioner who went in excited and came out disillusioned. The post starts as a migration diary and escalates into a broader critique of the Pi ecosystem, vibe-coded software culture, and OpenClaw's security foundation.

The author's requirements were reasonable and clearly stated:
1. Parallel subagents for context distillation (non-negotiable)
2. Basic security: file access restricted to CWD, bash commands allow-listed
3. Git/GitHub integrations

They failed on all three within the Pi ecosystem.

---

## Key Claims — Verified

### 1. Subagents don't exist in Pi core
**True.** Mario Zechner's stated position: "Using a sub-agent mid-session for context gathering is a sign you didn't plan ahead." Subagents are handled by community extension `pi-subagents` (by Nico Bailon). Armin Ronacher built his own `/control` extension for multi-agent but describes it as experimental.

### 2. `pi-subagents` ships 6 built-in agents you can't remove
**True per the npm package.** The extension bundles `scout`, `planner`, `worker`, `reviewer`, `context-builder`, `researcher` at lowest priority. Override requires creating a same-named user agent — technically a workaround, not a removal mechanism. The design choice is defensible (sensible defaults) but contradicts Pi's minimalist philosophy.

### 3. pi only supports `npm:` for package installation
**True.** The `pi install` command parses `npm:`, `git:`, and `ssh:` prefixes. Anything else (including `pnpm:`) is interpreted as a local file path. The author filed a PR to add pnpm support; PRs are not accepted externally and maintainers were on holiday.

### 4. `pi-extmgr` runs npm update check on every startup
**True per the author's debugging.** Setting auto-update to "never" didn't suppress the startup check. A ~10-second blocking npm call on every launch, with no bypass.

### 5. `@aliou/pi-guardrails` uses blocklist + regex matching
**True.** The npm page confirms: substring or regex matching, blocklist by default (everything allowed unless explicitly blocked). The `@aliou/sh` structural parser backing it is 3 weeks old at time of writing, built specifically for this extension.

### 6. The agent auto-created subagent definitions and overrode model choice
**Plausible but ambiguous.** The author reports finding `orchestration-designer.md` and `mcp-researcher.md` in their agents directory, set to `claude-haiku-4-5` despite configuring `kimi-coding/k2p5`. Could be: (a) Kimi model going off-rails, (b) `pi-subagents` builtin behavior, (c) LLM interpreting instructions creatively. The author themselves says they don't know the root cause. This is the kind of failure mode you'd expect from an unrestricted agent + poorly documented extension interaction.

### 7. Pi's YOLO security stance
**True and well-documented.** Direct Zechner quote: "If you look at the security measures in other coding agents, they're mostly security theater." Pi runs unrestricted by design. The author correctly identifies this as post-hoc rationalization for a convenience decision.

### 8. Peter Steinberger ships code he doesn't read
**True by his own admission.** The Pragmatic Engineer podcast interview (Jan 2026) is titled "The creator of Clawd: 'I ship code I don't read.'" His GitHub bio reads "Deep in vibe-coding mode." The blog's embedded screenshot (a GitHub note where the developer says they didn't read their project's code) maps to this pattern.

### 9. OpenClaw had a vibecoded DB vulnerability
**True.** 404 Media reported on Jan 31, 2026 that Moltbook (the AI-agent social network built on OpenClaw) had an unsecured database allowing anyone to commandeer any agent on the platform. This was one of multiple security incidents: 900+ exposed instances found via Shodan, 1.5M exposed API keys, 35K email addresses (per Wiz), 4,500+ globally exposed instances (per Straiker), and ~15% of ClawHub skills containing malicious payloads (per Cisco).

---

## The Author's Strongest Arguments

### Ecosystem quality problem
The core harness is fine. The ecosystem — which Pi *explicitly pushes you toward* for missing functionality — is consistently half-baked. Nice READMEs, broken implementations, undocumented config options, phantom features. The `interactive: true (parsed but not enforced in v1)` and `defaultProgress` examples are damning illustrations.

### Blocklist security is backwards
Claude Code does glob matching + allowlist + CWD restriction by default. Pi's ecosystem answer (`pi-guardrails`) does regex + blocklist. The author is correct that for security-adjacent features, allowlist is the only defensible default. A regex-based blocklist for bash commands is a losing proposition — bash is not a regular language.

### "Security is hard so don't bother" is lazy
The author precisely diagnoses the rhetorical structure of Zechner's security argument: misrepresent the opposing position (Simon Willison said the problem is hard *and needs solving*, not that it's impossible), appeal to common practice ("everyone runs YOLO"), and dress a convenience decision as philosophy. This tracks with our own [agent isolation analysis](agent-isolation-friction-rebuttal.md) and [security landscape research](agent-security-landscape-what-people-do.md).

### Vibecoded software as blind box
The concluding argument: treating vibecoded software as a black box and assuming it works because it superficially works is dangerous. OpenClaw's trajectory (viral growth → database exposure → malicious skills → acqui-hire) validates this empirically.

---

## The Author's Weaker Arguments

### Subagent philosophy critique
The author's framing of Zechner's position is slightly unfair. Zechner's actual objection is about *observability*, not about context savings. His argument is that subagents are invisible black boxes within sessions — you don't see what they did. The author acknowledges this ("that's a fair criticism!") but then brushes past it. For the specific use case of parallel knowledge-base exploration, the author is right that subagents are the correct tool. But Zechner's concern about opaque multi-agent sessions is legitimate and underexplored.

### NPM exclusivity is annoying but minor
Supporting only npm for package installation is annoying but not a fundamental design flaw. npm is the package registry; pnpm/yarn/bun are alternative clients for the same registry. The 30-minute PR sidequest, while illustrating ecosystem friction, is a contribution story, not a design indictment.

### Extension docs "written for LLMs"
This is subjective and not well-evidenced in the post. The author makes the claim but doesn't demonstrate it with specific examples beyond the subagents extension. Pi's core documentation and Zechner's blog posts are clearly human-authored. Some ecosystem extensions may have LLM-generated docs, but that's a community quality issue, not a Pi design problem.

---

## Connections to Existing Research

This post **strongly confirms** several patterns we've already documented:

1. **Pi's high skill floor** (topics/coding-agents.md) — The author is a competent engineer who was willing to put in work and still bounced. Pi's "build it yourself" philosophy has a real cost beyond the learning curve: the ecosystem you're directed to for missing pieces is unreliable.

2. **Security theater vs. YOLO is a false dichotomy** (research/agent-isolation-friction-rebuttal.md) — The blog independently reaches the same conclusion we did: the choice isn't between "perfect security" and "no security." Tiered access, CWD restriction, and allowlists are meaningful improvements over nothing. Zechner frames it as binary when it's a spectrum.

3. **Vibecoding supply chain risk** (research/openclaw-analysis.md) — The OpenClaw security incidents (Moltbook DB, malicious skills, exposed instances) are exactly the downstream consequences of the philosophy the author criticizes. Our existing research pegged ~15% of ClawHub skills as malicious; the Cisco Skill Scanner findings confirm this.

4. **Agent-created agents going off-rails** (research/hn-karpathy-claws-llm-agents.md) — The incident where the agent auto-created terrible subagent definitions and overrode model config is a concrete example of the autonomy-control tension Karpathy and others have flagged. Unrestricted agents in unrestricted environments will eventually do unexpected things.

5. **Pi's Armin Ronacher ceiling** (research/pi-practitioner-review.md) — Our practitioner review noted that Pi's strongest advocates are a very specific profile: terminal-native power users who *enjoy* building their own tools. The author is close to this profile but not quite — they wanted to build, but expected a baseline of working ecosystem components. Pi doesn't meet that middle ground.

---

## What's New Here

1. **First detailed migration failure diary.** Most Pi coverage is either enthusiastic adoption stories or abstract security criticism. This is the first source documenting a *specific, step-by-step* attempted migration with concrete failures at each stage.

2. **`pi-subagents` quality evidence.** The undocumented config options (`defaultProgress`, `interactive: true (parsed but not enforced in v1)`), the un-removable builtin agents, and the phantom model overrides are specific, verifiable quality signals we didn't have before.

3. **`pi-guardrails` design critique.** The regex+blocklist analysis is technically sound and wasn't in our existing security research, which focused on OS-level isolation (Gondolin, Matchlock, separate user) rather than extension-level permission systems.

4. **`pi-extmgr` startup performance.** Blocking npm update check on every launch with no disable mechanism is a concrete data point on ecosystem polish.

5. **Closed contribution model.** Pi doesn't accept external PRs. This is relevant context for ecosystem quality: if the community can't contribute fixes upstream, ecosystem quality depends entirely on a small core team.

---

## Verdict

A well-written, honest, technically grounded critique from someone who genuinely tried. The author isn't a hater — they opened two PRs, dug into source code, and spent hours trying to make things work. Their frustration is earned.

The post's strongest contribution is connecting Pi's philosophical choices (YOLO security, minimalism-as-ideology, npm-only) to their downstream ecosystem consequences. Individual decisions are defensible in isolation; in combination, they create a hostile experience for anyone who isn't already in the inner circle of power users who self-build everything.

The broader argument about vibecoded software quality is validated by the OpenClaw timeline: prototype→viral→security disasters→acqui-hire, all within ~3 months. The foundation being Pi doesn't indict Pi itself, but it does raise questions about what happens when a tool designed for careful, self-directed experts gets adopted as infrastructure by a viral consumer product.

**Reliability: High.** Claims are specific, verifiable, and consistent with our existing research. The author identifies their own uncertainty where appropriate (the model-override incident). Writing is clearly human — personal voice, self-deprecation, specific debugging stories, no AI prose markers.

**Novelty: Medium.** The security and philosophy critiques echo existing discourse, but the migration diary format and specific ecosystem quality evidence are new. The `pi-guardrails` regex/blocklist analysis is a genuinely useful technical contribution.
