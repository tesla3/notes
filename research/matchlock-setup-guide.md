← [Gondolin vs Matchlock](gondolin-vs-matchlock.md) · [Index](../README.md)

# Matchlock: Practical Setup Burden

**Date:** 2026-02-21
**Context:** Pi coding agent, Apple Silicon Mac, personal projects, personal information on the machine.

---

## What This Document Is

A layer-by-layer assessment of what it takes to run a Pi coding agent inside Matchlock's micro-VM sandbox. Not a tutorial — many CLI details below are inferred from Matchlock's documented patterns (`--allow-host`, `--secret KEY@host`, `--image`) and Docker conventions. **Verify against current Matchlock docs before using any command verbatim.**

The goal: understand the real configuration burden so you can decide whether the security payoff justifies it for your situation.

---

## Layer 1: Installation — Trivial (2 minutes)

```bash
brew tap jingkaihe/essentials
brew install matchlock
```

Works on Apple Silicon. No other dependencies.

---

## Layer 2: Image Selection — Moderate (30-60 minutes first time)

You need an OCI image with everything your agent needs. Matchlock accepts Docker/OCI images directly — this is one of its main advantages over Gondolin.

**What the image needs for Pi:**
- Node.js 20+ (Pi is a Node.js CLI: `npm install -g @mariozechner/pi-coding-agent`)
- git, curl, jq, openssh-client
- Your language runtimes (Python, Go, Rust — whatever your projects need)
- Build tools (gcc/make if any npm packages have native bindings)

**Build your image with standard Docker tooling**, then point Matchlock at it. Use a minimal base (Alpine, Debian slim) and add only what you need.

**The catch:** You'll discover missing tools mid-session. Agent tries to `pip install pandas` → needs `--allow-host pypi.org`. Agent tries `cargo build` → Rust isn't in the image. Expect 3-5 rebuild iterations to get a stable image for your workflow. This is annoying but one-time per workflow.

**Ongoing cost:** Rebuild when you need new tools. Low — maybe monthly.

---

## Layer 3: Secret Injection — Moderate (15-30 minutes)

Map each secret to its allowed host(s):

```bash
# Straightforward
--secret ANTHROPIC_API_KEY@api.anthropic.com
--secret GITHUB_TOKEN@api.github.com
--secret BRAVE_API_KEY@api.search.brave.com

# GitHub token via HTTPS (git clone, push)
--secret GITHUB_TOKEN@github.com
```

**The catch: multi-host secrets.** Some services talk to many endpoints:

- **GitHub alone** needs: `api.github.com`, `github.com`, `raw.githubusercontent.com`, `objects.githubusercontent.com`
- **AWS is fundamentally incompatible** with per-host secret mapping. AWS credentials talk to regional, service-specific endpoints: `s3.us-west-2.amazonaws.com`, `sts.amazonaws.com`, `ec2.us-east-1.amazonaws.com`, `dynamodb.us-west-2.amazonaws.com` — dozens of hosts that vary by region and service. If your projects are AWS-heavy, this layer alone may be a dealbreaker. You'd need to enumerate every AWS endpoint you use, and the list grows with every new region or service.

**Ongoing cost:** Low for simple services (one line per secret). Potentially high for cloud providers with many endpoints.

---

## Layer 4: Network Allowlist — The Hard Part (ongoing)

This is the real configuration burden and the core security mechanism. You must enumerate **every host** your agent might legitimately contact.

**Baseline for a Pi coding agent:**

```bash
# LLM API
--allow-host api.anthropic.com

# GitHub (git operations, API, raw content, releases)
--allow-host github.com
--allow-host api.github.com
--allow-host raw.githubusercontent.com
--allow-host objects.githubusercontent.com
--allow-host github-releases.githubusercontent.com

# Package registries
--allow-host registry.npmjs.org          # npm
--allow-host pypi.org                     # pip
--allow-host files.pythonhosted.org       # pip actual downloads
--allow-host api.search.brave.com         # brave-search skill

# Alpine package mirror (if using Alpine-based image)
--allow-host dl-cdn.alpinelinux.org
```

**The problem: debugging blocked hosts.**

When a host isn't allowlisted, the agent sees a generic network failure — connection refused, timeout, DNS resolution failure. There is **no clear "blocked by Matchlock" error message** visible to the agent or to you. The debugging workflow:

1. Agent reports a network error
2. You suspect the allowlist but aren't certain (could be a real network issue)
3. You guess which host was blocked, add it, retry
4. If wrong, repeat

**Unknown: whether Matchlock provides diagnostic logging for blocked connections.** If `matchlock` has a `--verbose` or `--log-level debug` flag that shows rejected hosts, this debugging story improves dramatically. Check the docs. If it doesn't, consider filing a feature request — this is the single most impactful UX improvement they could make.

**A possible bootstrap approach:** Start a session with a permissive allowlist (or temporarily allow all hosts if Matchlock supports `--allow-host '*'`), do your normal work, then audit which hosts were actually contacted. Tighten from there. This inverts the security model during setup but may be the only practical way to build a complete allowlist.

**Real-world scenario:** Agent runs `npm install` → package has a postinstall script that downloads a binary from `github.com/some-org/some-tool/releases` → fails silently → build breaks → you spend 10 minutes figuring out what happened. This will happen repeatedly until your allowlist stabilizes.

**The fundamental tradeoff:** DanMcInerney (from the [HN thread](hn-matchlock-agent-sandbox.md)): *"This kind of architectural whitelisting is the only hard defense we have for agents at the moment. Unfortunately it will also hamper their utility if used to the greatest extent possible."*

**Ongoing cost:** High initially, decreasing over time as your allowlist stabilizes for your typical workflow. But every new dependency, API, or tool can trigger another round of debugging.

---

## Layer 5: Filesystem Mounts — Moderate (with a known security gap)

Your project files need to be visible inside the VM. Mount syntax is likely Docker-style (`-v host:guest`), but **verify against Matchlock docs**.

**What you need to mount:**

| Path | Purpose | Risk |
|------|---------|------|
| Your project directory | Agent reads/writes code | Agent can read any file in the mount and exfiltrate to any allowed host |
| `~/.gitconfig` (read-only) | Git user identity | Contains your name/email |
| `~/.pi/agent/` (read-only) | AGENTS.md, skills | Pi configuration |

**What you should NOT mount:**

| Path | Why not |
|------|---------|
| `~/.ssh/` | Your personal SSH keys — gives agent your full git identity across all services |
| `~/` or `/` | Exposes everything — personal files, credentials, browser data |
| `~/.aws/`, `~/.kube/`, etc. | Cloud credentials with broad access |

**The filesystem bridge security gap:** Matchlock's FUSE-over-vsock bridge has a [probable path traversal vulnerability](hn-matchlock-agent-sandbox.md) identified by yencabulator — `filepath.Join` in `realfs.go` doesn't enforce a root boundary. This was raised publicly and not addressed by the author. Combined with the "exfiltration to allowed hosts" problem: the agent can potentially read files outside your mount and POST them to any allowlisted API. This partially undermines the VM isolation promise.

### Git Authentication — Do This Right

This is the highest-stakes decision in the setup. Your agent needs git access. Options:

**Option 1: Fine-grained GitHub PAT via HTTPS (recommended)**
Generate a [fine-grained personal access token](https://github.com/settings/tokens?type=beta) scoped to specific repositories with minimum permissions (e.g., read/write contents only). Inject via `--secret`. This gives the agent access to only the repos you specify, with only the permissions you grant. If compromised, blast radius is limited.

**Option 2: Deploy keys (good for single-repo work)**
Generate an SSH key pair specifically for agent use. Add the public key as a [deploy key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys) on a single repo (read-only or read-write). Mount only that key. The agent can access only that one repo. Downside: one key per repo, doesn't scale if you work across many repos.

**Option 3: Classic GitHub PAT via HTTPS (acceptable)**
A classic personal access token with `repo` scope. Broader than fine-grained — grants access to all your repos. Still better than SSH keys because it's GitHub-only and revocable.

**Option 4: Mount your personal SSH keys (avoid)**
Gives the agent your full identity. Can push to any repo on any service (GitHub, GitLab, Bitbucket, your company's git server). If the agent is compromised, the attacker has your SSH key. Don't do this.

**Option 5: `--secret` for SSH key material**
Matchlock's secret injection is HTTP-based (substitutes placeholders in HTTP requests to allowed hosts). It doesn't work for SSH, which is a different protocol. Not viable.

---

## Layer 6: Pi Integration — Not Available (requires workaround)

**This is the biggest gap.** Gondolin has a built-in Pi extension. Matchlock has nothing.

### Pattern 1: Run Pi inside the VM (pragmatic choice today)

Install Pi in your Docker image. Launch it inside the VM:

```bash
# Conceptual — verify actual matchlock CLI syntax
matchlock run --image agent:latest \
    -v "$HOME/projects/my-project:/workspace" \
    -v "$HOME/.pi/agent:/root/.pi/agent:ro" \
    -v "$HOME/.gitconfig:/root/.gitconfig:ro" \
    --allow-host api.anthropic.com \
    --secret ANTHROPIC_API_KEY@api.anthropic.com \
    # ... all other hosts/secrets ...
    -- sh -lc 'cd /workspace && pi'
```

**What works:**
- Pi runs, can read/write code, makes API calls through allowed hosts
- Zero custom code required

**What breaks or degrades:**
- Pi's TUI renders inside the VM terminal — may have terminal emulation quirks (color support, window size, key sequences)
- Pi skills requiring host-level access won't work (browser automation needs a browser; tmux skill needs host tmux)
- Every host Pi might contact needs to be in the allowlist — including search APIs, any MCP servers, etc.

### Pattern 2: Run Pi on host, exec commands in VM (better but doesn't exist)

Pi runs natively on your Mac. When it needs to execute bash or write files, it routes through `matchlock exec` to the VM. This would give you native TUI experience with sandboxed execution.

**Nobody has built this.** It would require a custom Pi extension that intercepts tool calls. The latency overhead is likely small — vsock on Apple Silicon should add single-digit milliseconds per call, negligible against LLM round-trip times of seconds. But the engineering effort to build file synchronization and working directory management is non-trivial.

**Realistic assessment:** Use Pattern 1 today. Pattern 2 is the right architecture but requires custom work.

---

## The Full Command (Illustrative)

**Note:** Some flags below are inferred from Docker conventions and Matchlock's documented patterns. Verify against current docs.

```bash
matchlock run --image agent:latest \
    -v "$HOME/projects/my-project:/workspace" \
    -v "$HOME/.pi/agent:/root/.pi/agent:ro" \
    -v "$HOME/.gitconfig:/root/.gitconfig:ro" \
    \
    --allow-host api.anthropic.com \
    --allow-host github.com \
    --allow-host api.github.com \
    --allow-host raw.githubusercontent.com \
    --allow-host objects.githubusercontent.com \
    --allow-host registry.npmjs.org \
    --allow-host pypi.org \
    --allow-host files.pythonhosted.org \
    --allow-host api.search.brave.com \
    --allow-host dl-cdn.alpinelinux.org \
    \
    --secret ANTHROPIC_API_KEY@api.anthropic.com \
    --secret GITHUB_TOKEN@api.github.com \
    --secret GITHUB_TOKEN@github.com \
    --secret BRAVE_API_KEY@api.search.brave.com \
    \
    -- sh -lc 'cd /workspace && pi'
```

~20 flags. You'll want a shell script. And it'll grow.

---

## Comparison: What About Docker?

Before adopting Matchlock, consider whether plain Docker gets you close enough:

| Capability | Docker `--network=none` + selective | Matchlock micro-VM |
|------------|--------------------------------------|-------------------|
| Filesystem isolation | ✅ Mount only what you need | ✅ Same |
| Network isolation | Partial — `--network=none` blocks all, but selective allowlisting requires manual iptables/proxy | ✅ Built-in per-host allowlisting |
| Secret injection | ❌ Secrets visible inside container as env vars | ✅ Placeholder substitution, never enters VM |
| Kernel isolation | ❌ Shared kernel — container escape = host compromise | ✅ Separate kernel — VM escape much harder |
| Host process isolation | Partial — namespaced but shared kernel | ✅ Full — separate OS |
| Setup complexity | Low — you already know Docker | Moderate-High — new tool + allowlist management |
| Image support | ✅ All Docker images | ✅ All OCI images |

**The key Matchlock advantages over Docker:**
1. **Secret injection** — secrets never enter the sandbox. In Docker, if the agent is compromised, it can read env vars.
2. **Kernel isolation** — a container escape gives host access; a VM escape is dramatically harder (Firecracker has ~50K lines of Rust vs. the entire Linux kernel surface).
3. **Built-in host allowlisting** — Docker's equivalent requires manual network configuration.

**When Docker might be enough:** If your main concern is the agent doing something dumb (rm -rf, runaway process, overwriting files), Docker with `--network=none` and mounted volumes provides adequate containment with near-zero configuration overhead. Git provides rollback. The agent can't exfiltrate because it has no network. The downside: the agent also can't install packages, fetch docs, or make API calls — you'd need to pre-install everything and run Pi outside the container (Pattern 2 problem).

---

## Honest Assessment

| Layer | Effort | One-time or ongoing? |
|-------|--------|---------------------|
| Installation | Trivial | One-time |
| Image | Moderate | Occasional rebuilds |
| Secrets | Moderate (simple services) to High (AWS/cloud) | Per new service |
| **Network allowlist** | **High** | **Ongoing, decreasing** |
| Filesystem | Moderate | One-time per project layout |
| **Pi integration** | **Workaround only** | Friction every session |

---

## Risk Calibration: Your Specific Situation

You're on a personal Mac with personal information. Your agent (Pi) routinely processes **untrusted input** — this is important to be clear-eyed about:

- **brave-search skill** fetches and parses arbitrary web content
- **git clone / npm install** pulls code and READMEs written by strangers
- **API responses** from any service could contain injection payloads
- **Error messages** from compilers, linters, test runners include content from untrusted code

This means prompt injection is **not theoretical** for your workflow. It's a realistic (if still low-probability) attack vector. The question is what the damage looks like and whether Matchlock's protections match the threats.

**What Matchlock protects on your machine:**

| Threat | Without Matchlock | With Matchlock |
|--------|-------------------|----------------|
| Agent reads `~/.ssh/`, `~/.aws/`, browser data | ✅ Full access | ❌ Blocked (not mounted) |
| Agent sends credentials to attacker's server | ✅ Possible | ❌ Blocked (host not allowlisted) |
| Agent sends your *code* to an allowlisted host | ✅ Possible | ⚠️ **Still possible** — `api.anthropic.com` is allowlisted |
| Agent runs `rm -rf /` | ✅ Damages your system | ⚠️ Damages the VM (your mounted project files are at risk) |
| Agent exploits kernel vulnerability | ✅ Host compromise | ❌ Contained in VM |
| Agent installs persistent malware | ✅ Possible | ❌ VM is ephemeral |

**What Matchlock does NOT protect:**

- Exfiltration through allowed hosts. Your code can be sent to `api.anthropic.com` — an attacker's API key would work. This is the [Claude Cowork attack](hn-matchlock-agent-sandbox.md) and it bypasses all sandbox tooling.
- Damage to mounted project files. Your project directory is mounted read-write. The agent can delete or corrupt files. Git is your safety net here, not the sandbox.

**The pragmatic middle ground for your situation:**

The highest-value, lowest-effort protections don't require Matchlock:

1. **Don't put secrets in env vars.** Use a credential manager or `.env` files excluded from agent access.
2. **Use a [dedicated macOS user account](agent-separate-macos-user.md)** for agent work. Isolates your personal files (photos, documents, browser data, SSH keys) with zero configuration overhead.
3. **Use fine-grained GitHub PATs** instead of SSH keys or classic tokens.
4. **Git for rollback.** Commit before risky operations. The agent can't destroy committed history.
5. **Review before push.** Don't let the agent push directly without your review.

Matchlock adds value **on top of these basics** by providing:
- Network destination control (blocks credential theft to attacker servers)
- Kernel isolation (blocks privilege escalation)
- Ephemeral environment (no persistent compromise)

Whether that additional value justifies the allowlist maintenance burden is a judgment call. The honest answer: for personal development work, the basics (items 1-5 above) eliminate the most likely damage scenarios. Matchlock protects against targeted, sophisticated attacks that are low-probability on a personal machine — but not zero-probability given your agent processes untrusted content.

---

## Bottom Line

**If you adopt Matchlock today:**
- Expect 2-4 hours of initial setup (image, allowlist, secrets, git auth)
- Expect ongoing allowlist maintenance, heaviest in the first week, tapering as it stabilizes
- Accept the terminal-in-VM experience for Pi (no native TUI)
- Accept that mounted project files remain vulnerable to accidental damage
- Gain real protection for your personal files, credentials, and system integrity

**If you wait:**
- Adopt the low-cost basics (dedicated user, fine-grained PATs, git discipline)
- Monitor Matchlock for debugging improvements (blocked-host logging) and Pi integration
- Monitor Gondolin — if it gets Docker image support, its built-in Pi extension makes Layer 6 a non-issue
- Revisit when the tooling matures (both tools are weeks old)

**My recommendation for your situation:** Start with the basics. They're free, proven, and cover the most likely damage scenarios. Keep Matchlock on the radar for when either (a) you start processing more untrusted input, (b) the tooling matures enough to reduce the allowlist friction, or (c) you have API keys worth more than the time cost of maintaining the sandbox.

---

## Sources

- [Matchlock GitHub](https://github.com/jingkaihe/matchlock)
- [HN thread analysis](hn-matchlock-agent-sandbox.md) — red-teaming anecdotes, confused deputy, useradd debate
- [Gondolin vs Matchlock comparison](gondolin-vs-matchlock.md) — security scorecard across 7 attack classes
- [VirtusLab: Matchlock deep dive](https://virtuslab.com/blog/ai/matchlock-your-agents-bulletproof-cage/) — architecture analysis
- [Claude Cowork exfiltration](https://www.promptarmor.com/resources/claude-cowork-exfiltrates-files) — proof that allowed-host exfiltration works
- [GitHub: Fine-grained PATs](https://github.com/settings/tokens?type=beta) — repo-scoped, minimal-permission tokens
- [GitHub: Deploy keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys) — single-repo SSH keys
