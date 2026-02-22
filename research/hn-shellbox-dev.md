← [Index](../README.md)

## HN Thread Distillation: "Linux boxes via SSH: suspended when disconnected"

**Source:** [shellbox.dev](https://shellbox.dev/) — [HN thread](https://news.ycombinator.com/item?id=46638629) (316 points, 159 comments, 91 unique authors)

**Article summary:** Shellbox is a service offering Firecracker-backed Linux VMs managed entirely via SSH. No web console, no signup form — just `ssh shellbox.dev create`. VMs suspend on disconnect and resume on reconnect. Per-minute billing at $0.02/hr running, $0.005/hr suspended. Built on Python/AsyncSSH, Hetzner auction bare metal, Paddle for payments, Caddy for TLS. Creator is Argentine (messh/skariel).

### Dominant Sentiment: Charmed by UX, killed by pricing

The thread loves the idea and execution but collectively demolishes the business case. 90%+ of substantive comments point to the same fatal math.

### Key Insights

**1. The suspend premium inverts the value proposition**

The core pitch — "pay less when you're not using it" — collapses when the suspended rate ($3.60/mo) matches an always-on Hetzner VPS ($4.09/mo). Multiple commenters arrive at this independently. [Egor3f]: "$36/mo for 2/4/50 VPS without public IP... The same config in Hetzner is just $4.09/mo for 24/7 working VPS." [wolvoleo] hammers it: "my vpses cost as much as this one does while suspended. With unlimited data traffic." The creator (messh) acknowledges this in-thread: "That is a good point actually. The suspended price has to be significantly lower than the alternative. I'll revise it." The fact that the founder conceded on pricing mid-launch suggests this wasn't stress-tested against competitor math before going live.

**2. The "SSH-only" UX is the real product, not suspension**

Commenters who are positive focus almost entirely on the interface, not the infrastructure. [exabrial]: "No 'command line tools' to install. No absurd over-complicated web APIs." [bks] calls the billing interface "brilliant" and wants to build something similar. [HPsquared] loves the text-mode QR code. The emotional resonance is with the *aesthetic* of managing infra through SSH — a throwback to the tilde/SDF era that [ValdikSS] explicitly connects by listing tilde.town, sdf.org, etc. The actual compute underneath is commodity; the shell-native management experience is the differentiator nobody else has nailed at this polish level.

**3. Three-way market forming: shellbox vs sprites.dev vs exe.dev**

The thread maps a nascent competitive landscape. Sprites (Fly.io) bills on actual CPU/memory usage from cgroup counters — true consumption pricing that could be dramatically cheaper for bursty workloads. Exe.dev is subscription ($20/mo). Shellbox reserves capacity and bills per time slot. [nine_k] does the comparison: sprites costs less idle, more when active. The thread reveals that these three products have launched within weeks of each other, suggesting the "SSH dev box" category hit some kind of trigger point — likely AI coding agents needing sandboxed execution environments, though nobody in the thread says this explicitly.

**4. Hetzner dependency is a structural risk nobody fully explores**

Messh confirms using Hetzner auction servers (bare metal). Multiple commenters flag Hetzner's strict TOS enforcement. [qingcharles] got flagged for running a DHT scraper. [Trufa] directly asks: "How will you handle if someone uses this for crypto stuff that's against TOS?" [Imustaskforhelp] pushes: "hetzner requires you to respond in hours... did you talk to hetzner people?" The creator never gives a clear answer on this. Running multi-tenant arbitrary-code VMs on Hetzner bare metal is a business continuity risk that scales with success — the more users you have, the higher the probability someone violates Hetzner's TOS and the entire platform gets flagged.

**5. The use case gap is real and unsolved**

[krick] asks directly: "does anyone have a legit use-case for this?" The thread's best answers are thin: [LevkaDev] suggests "long-lived but infrequently accessed sessions" for debugging; [rolymath] says GPU instances where you forget to turn them off; [Nora23] mentions staging environments; [ronsor] suggests learning environments. Nobody describes actually using a service like this. The strongest pitch — "I keep forgetting to turn off my expensive GPU box" — is one the creator seizes on ("Excellent point") but shellbox doesn't currently offer GPU instances. The product exists in an awkward gap: too expensive to beat commodity VPS on cost, too simple to compete with full cloud platforms on features.

**6. FOSS alternatives make the moat paper-thin**

[w7] reveals they built a functional MVP of the same concept two years ago using a Go SSH proxy + kata containers on Kubernetes. [zackify] claims you can replicate this with "2 commands to install and setup lxd." [theykk] built an alternative in Rust last week (github.com/TheYkk/agentman). [abbbi] links github.com/abbbi/sshcont. [indigodaddy] just started shelley-lxc. The barrier to building this is visibly low — the thread functions as a live demonstration that the technical moat doesn't exist. What remains is operational excellence and UX polish.

**7. The billing design is ahead of the infrastructure**

The SSH-based account management (adding funds via QR code in terminal, checking balance, requesting refunds — all through SSH commands) draws more admiration than the actual VM product. [bks] wants to replicate the pattern for an SMS provider. This is the underappreciated insight: messh may have built the wrong product around the right interface. The SSH-as-management-plane pattern has broader applicability than ephemeral dev boxes.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Hetzner VPS is cheaper running 24/7 than shellbox suspended | **Strong** | Creator conceded; math is unambiguous |
| No clear use case vs existing VPS | **Strong** | Thread never surfaces a compelling one beyond GPU (which shellbox lacks) |
| Hetzner TOS risk for multi-tenant | **Medium** | Real but manageable with provider diversification |
| "Just self-host with LXD/containers" | **Medium** | True technically, but ignores the UX; still undermines pricing power |
| Security/abuse concerns | **Medium** | Unaddressed; Paddle 5% cut means no crypto-anon users, which partially self-selects |
| $5 balance cutoff is weird | **Weak** | Minor UX nit, easily fixable |

### What the Thread Misses

- **AI agent sandboxes are the real market.** Sprites explicitly pitches to "AI agents like Claude Code." Nobody in the thread connects this to shellbox, but the timing of three SSH-box products launching simultaneously almost certainly correlates with the explosion of AI coding agents needing secure execution environments. The human-SSH-session use case may be a red herring; the API-driven agent use case is where the volume is.

- **The Firecracker choice enables something nobody discusses.** Firecracker's <125ms boot time means shellbox could offer "wake on HTTP request" (which it does) at near-zero latency. This is architecturally different from a suspended VPS — it's closer to serverless with state. The thread treats it as "just a VPS with extra steps" and misses the architectural distinction.

- **Paddle's 5% is actually a feature, not a cost.** [nh2] is the only one who catches this: Paddle handles international VAT collection and payment. For a solo founder selling $10 minimum prepaid balances globally, the alternative to Paddle isn't "saving 5%" — it's "building or outsourcing international tax compliance," which is a business-ending amount of complexity for a one-person operation.

### Verdict

Shellbox is a beautifully executed answer to a question nobody is urgently asking. The thread circles this but never states it plainly: the product's real innovation is the SSH-native management interface, not the suspend/resume VM underneath. The creator has built what amounts to a prototype for "infrastructure-as-SSH-commands" and wrapped it around commodity compute where pricing headroom doesn't exist. The path forward is either (a) offer hardware that justifies per-minute billing (GPUs), (b) pivot the SSH management plane into a layer on top of existing providers, or (c) chase the AI agent sandbox market that sprites.dev is already explicitly targeting. The current positioning — slightly-more-expensive Hetzner VPS with a nicer shell — is a compliment trap: lots of HN love, few paying customers.
