← [Index](../README.md)

## HN Thread Distillation: "Tailscale Peer Relays is now generally available"

### Background: What Tailscale Is and What Peer Relays Do

Tailscale is a mesh VPN — it lets all your devices (laptop, phone, home server, cloud VM) talk to each other as if they're on the same private network, no matter where they are. It uses WireGuard encryption under the hood but handles all the painful stuff (NAT traversal, key exchange, routing) automatically.

**The problem Peer Relays solves:** When two devices can't connect directly (because of strict firewalls, CGNAT, cloud NAT rules), Tailscale falls back to **DERP servers** — relay servers run by Tailscale. DERP has two big limitations: (1) **TCP only**, which adds latency, and (2) **every node must reach every DERP server** — if one node can't reach a DERP server, you get "netsplits" where parts of your network can't talk to each other.

Peer Relays flip this: now **any device on your Tailscale network** can act as a relay for other devices. It uses UDP (faster), and the rule is just "if any pair of nodes can reach any relay, it works." You run `tailscale set --relay-server` on a box with good connectivity and it helps everyone else.

**Why people care:** Home users behind CGNAT (increasingly common — ISPs sharing one public IP across many customers) get much better performance. Enterprise users in AWS/cloud private subnets where direct WireGuard tunnels are impossible get a production-grade path without managing custom DERP infrastructure. And it reduces dependence on Tailscale's centralized servers.

**Why half the thread is arguing about business models:** Tailscale is VC-funded and has a generous free tier (3 users, 100 devices). HN's perennial worry: will they enshittify? The math says no for now — free users cost less than what traditional customer acquisition would cost, and the PLG flywheel (dev uses it at home → recommends it at work → company pays $18/user/month) is working. But it's VC-backed with IPO ambitions, so the anxiety isn't irrational.

---

**Article summary:** Tailscale's Peer Relays feature has reached GA, letting any Tailscale node act as a relay for other nodes. It replaces the centralized DERP-only relay model with a decentralized, UDP-capable alternative that works in restrictive NAT/cloud environments, supports static endpoints behind load balancers, and exposes Prometheus-compatible metrics. Available on all plans including free.

### Dominant Sentiment: Enthusiastic but trust-anxious

The thread loves the product but can't stop worrying about the business model. Roughly half the discussion is about Peer Relays; the other half is a recurring HN liturgy about free tiers, enshittification, and open source purity. Tailscale employees (apenwarr, alexktz, raggi, kabirx, dblohm7) showed up in force and gave substantive technical answers, which is notable.

### Key Insights

**1. Peer Relays solve the DERP pain point cleanly**

The key architectural shift: DERP servers required every node to reach every DERP server (creating netsplit risk), while Peer Relays only need *any pair of nodes* to share *any* relay. Apenwarr: "deploying one is always a performance and reliability improvement." They also support UDP (DERP was TCP-only), which matters for latency-sensitive use cases. Real user tda reports ping dropping from 16→10ms and bandwidth tripling for game streaming.

**2. The free tier debate is settled — by math, not morality**

Tailscale's own blog post explains it: the cost of running free users is lower than what customer acquisition would cost without them. riknos314 nails it: "As long as these economics continue to hold they'd be stupid to discontinue the free tier." The PLG (product-led growth) flywheel — dev uses it at home → evangelizes at work → company pays $18/user/month — is working. This is the Cloudflare playbook. The anxiety is real but economically unfounded for now.

**3. The logging/telemetry controversy is overblown but has a real kernel**

Lammy raised alarm about `log.tailscale.com` streaming connection metadata. The thread partially debunked this — jzelinskie found zero DNS requests to that host in his logs, and network logging appears to require a Premium plan. But the real issue is legitimate: mobile clients (iOS/Android) can't opt out of client logging, and a PR to add the opt-out flag to Android has languished unmerged. The `TS_NO_LOGS_NO_SUPPORT` flag exists for desktop but the name is deliberately chilling. Lammy's point about metadata being "as good as data" is the strongest argument — NTP hosts, captive portal timing, and weather API patterns can reveal behavior even from connection logs alone.

**4. The open source situation is nuanced, not damning**

Only the GUIs on some platforms are closed source; the core client/daemon is open (BSD-licensed). dblohm7 (Tailscaler): "OSS operating systems get OSS GUIs." The Android client is fully open source. The macOS CLI can be compiled from source. The closed macOS GUI and iOS app are the sore spots, and Tailscale's justification ("if you're comfortable with a closed OS, you should be comfortable with a closed GUI on it") is philosophically weak but practically irrelevant for most users.

**5. The alternatives landscape is wide but nothing matches Tailscale's polish**

Mentioned: Headscale (open source control server, works but lacks some features), Netbird (full-stack open alternative, good but has peer-dropout bugs), ZeroTier (layer 2, harder to self-host), Nebula, Tinc, OpenZiti, Netmaker. The recurring pattern: alternatives exist at every point on the control-vs-convenience spectrum, but none match Tailscale's "it just works" quality. Multiple commenters who tried alternatives came back.

**6. Tailscale's Linux networking integration is heroically complex**

raggi's comment about the Linux client is a standout technical deep-dive: rule-based routing with high-priority rules, systemd-resolved integration with fallback to /etc/resolv.conf, both iptables and nftables support, custom SSH daemon implementation across distro variations, 1280-byte inner MTU for IPv6 compatibility. The linked blog post on Linux DNS client hell (`sisyphean-dns-client-linux`) contextualizes why "magic" networking is hard to document. This is the honest engineering answer to "what is Tailscale actually doing under the hood."

**7. AWS/cloud NAT is a bigger driver than home users realize**

kabirx and alexktz from Tailscale revealed that enterprise customers in restrictive cloud environments (AWS being the common example) are a major use case. Static endpoints behind NLBs, private subnets with no direct peer discovery — this is where Peer Relays replace subnet routers and unlock full-mesh deployments. The feature is positioned as home-user-friendly but clearly enterprise-motivated.

**8. The "just use WireGuard" crowd underestimates the coordination problem**

iso1631's comment is the best rebuttal: with 10 devices you need 90 tunnels, adding one device means updating all others, and NAT traversal using birthday-paradox port matching isn't something you configure by hand. The coordination layer *is* the product.

### What the Thread Misses

- **No discussion of Peer Relay security model.** If any node can become a relay, what's the attack surface of a compromised relay node? The article says traffic remains E2E encrypted, but nobody probed this.
- **No comparison with Cloudflare Tunnel / WARP.** Cloudflare's zero-trust networking is a direct competitor in the enterprise space and wasn't mentioned once.
- **Performance benchmarks are anecdotal.** One user reported 3x bandwidth improvement. No systematic comparison of DERP vs Peer Relay latency/throughput was offered or requested.
- **IPO trajectory implications.** Tailscale raised a $230M CAD Series C and is on an IPO track. Nobody connected this to what happens to the free tier post-IPO when growth metrics matter more than unit economics.

### Verdict

Peer Relays is a genuine architectural improvement — moving from "all nodes must reach all DERP servers" to "any relay path works" is more resilient by design, and adding UDP support fixes DERP's fundamental latency penalty. The real story in this thread, though, is Tailscale's increasingly comfortable position as the de facto mesh VPN: technically excellent, well-documented, responsive team, viable free tier — and an alternative ecosystem that's always one step behind. The trust anxiety is the tax you pay for depending on a VC-backed company for infrastructure, but Tailscale is doing more than most to earn that trust.
