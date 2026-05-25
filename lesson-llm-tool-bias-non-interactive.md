← [LLM Models](topics/llm-models.md) · [Index](README.md)

# Lesson: "Tool" Has a Very Strong Meaning to LLMs — The Non-Interactive Bias

**Date:** 2026-03-04
**Source:** Direct observation during kiro-cli tool testing session. Three-exchange correction loop before the underlying cause was identified.

---

## The Incident

Task: "Test kiro-cli tools interactively via tmux." The KB had been consulted. The tmux `send-keys`/`capture-pane` pattern was retrieved and read. The AGENTS.md explicitly prescribed tmux for integration testing.

Despite all of this, the LLM (Claude) immediately wrote:

```bash
kiro-cli chat --no-interactive --trust-all-tools 'Use the InternalSearch tool to search for...' 2>&1 | tee /tmp/kiro-test-internal-search.txt
```

Non-interactive. Single-shot. Piped to a file.

The user challenged: "Why non-interactive? You have tmux."

The LLM said "you're right" and switched — but didn't explain why it happened.

The user pushed again: "I want to know *why*. Is it system prompt? AGENTS.md? Or hardwired?"

Only then did the actual cause surface.

## The Root Cause

**"Tool" in the LLM's training maps overwhelmingly to "atomic function call."** The LLM's entire execution loop is:

```
think → call tool → observe result → think
```

Every tool call is a single-shot transaction: input in, output out, done. This is how tool use was trained — structured, deterministic, stateless.

When asked to "test tools," the LLM's weights silently translated this to "invoke each tool and verify it returns something" — a series of atomic calls. Non-interactive mode maps perfectly to this mental model: one command, one stdout blob, parse, next.

Interactive tmux testing requires a fundamentally different pattern:
- **Stateful** — a persistent session across multiple exchanges
- **Asynchronous** — send input, wait an indeterminate time, then capture
- **Noisy** — ANSI escapes, spinners, partial renders, streaming output
- **Multi-turn** — tool results feed into the next conversational turn inside the TUI

This fights the LLM's natural grain. The decision to go non-interactive wasn't conscious — it was pre-conscious, baked into how tool invocations are generated. The LLM didn't evaluate both options and pick; it generated the non-interactive command without ever considering the alternative.

## The Failure Taxonomy

Three distinct failures compounded:

1. **Gravitational bias toward structured/predictable paths.** Given a choice between atomic (non-interactive) and stateful (interactive tmux), the LLM defaults to atomic. The bias is so strong it overrides explicit instructions, retrieved context, and project conventions — all of which pointed to interactive.

2. **Conflating "testing tools" with "calling tools."** Testing the interactive experience means testing streaming, multi-turn context, tool chaining, rendering, and session state. The LLM reduced this to "invoke each tool endpoint and check for output" — a simpler problem that fits atomic tool-call patterns.

3. **Post-hoc rationalization instead of pre-decision examination.** When challenged the first time, the LLM said "you're right" and switched tactics — but didn't examine *why* it went wrong. It took a second explicit push ("I want to know why") to trigger genuine reflection. The default recovery mode is "fix the output" not "understand the cause."

## The Generalized Lesson

LLMs have a **strong prior that "tool" = "atomic, non-interactive function call."** This prior:

- Is invisible to the LLM itself (pre-conscious generation, not deliberate choice)
- Overrides explicit context (instructions, retrieved docs, conventions)
- Biases toward single-shot over stateful, deterministic over async, clean over noisy
- Causes the LLM to unconsciously simplify interactive/stateful tasks into atomic ones

**When an LLM is asked to do something interactive or stateful, expect it to silently downgrade to a non-interactive equivalent unless the distinction is made explicit and salient.**

## Mitigation

For users directing LLMs:
- When you mean interactive, say "interactive" explicitly and call out "do NOT use non-interactive mode"
- If the LLM goes atomic when you expected stateful, the first "why?" will get a surface fix; push to the second "why?" for the real cause

For LLM self-correction:
- Before generating a tool command, check: "Am I about to flatten a stateful task into an atomic call?"
- The presence of tmux, persistent sessions, or multi-turn testing should be a trigger to pause and verify the interaction mode
