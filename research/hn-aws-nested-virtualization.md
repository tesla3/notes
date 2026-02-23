← [Index](../README.md)

## HN Thread Distillation: "AWS Adds support for nested virtualization"

**Source:** [HN thread](https://news.ycombinator.com/item?id=46997133) (304 pts, 118 comments, 77 unique authors) — Feb 2026

**Article summary:** A one-line AWS SDK commit announcing nested virtualization on non-bare-metal EC2 instances, limited to 8th-gen Intel types (c8i, m8i, r8i). No blog post, no docs — the community is reverse-engineering the announcement from a Go SDK changelog.

### Dominant Sentiment: Vindicated relief, tempered by "finally"

The thread is roughly 60% celebration of a real pain point being resolved and 40% ribbing AWS for being 8+ years behind GCP and Azure. The ratio reflects how deeply the lack of nested virt has shaped workarounds across the ecosystem.

### Key Insights

**1. AWS's Firecracker irony is now resolved — but the scar tissue remains**

AWS built Firecracker, open-sourced it, and then didn't let customers run it on standard EC2 instances. The workarounds were extraordinary: alexellis documented building custom kernels with Ant Group's KVM-PVM patches, accepting 50-100% overhead on complex builds, just to run microVMs on regular cloud VMs. The cost gap was absurd — AWS bare metal at $3,500/mo vs Hetzner equivalent at $100/mo. This isn't just "late"; AWS created the demand, withheld the supply, and charged a 35x premium for the only alternative.

**2. The "just flip a bit" vs "cloud-scale engineering" debate has a clear winner — but both sides miss the real question**

`ssl-3` dismisses it as trivial ("I've been using it at home for years"), and `otterley` (former AWS EC2 Specialist SA) delivers the thread's star comment explaining why it's not: hardened VMM, VPC networking in nested VMs, Nitro's custom hardware stack, and security isolation guarantees that don't exist in a homelab. The rebuttal is technically correct. But `briffle` lands the counter-punch: "As do all the other cloud providers, that have had this for years." The real question neither side asks: was the delay a security engineering problem or a revenue protection problem? When bare-metal was the only option and cost 30x more, the incentive structure matters. `otterley` insists "there's no revenue protection here" — but that's about the *feature*, not about the *timing*.

**3. The instance restrictions reveal AWS's strategy: ship only where the hardware guarantees the SLA**

Limiting to 8th-gen Intel only (c8i/m8i/r8i) is the most technically informative detail. As `matheus-rr` notes, they're likely leveraging specific VMCS shadowing improvements in those chips. No Graviton support — ARM nested virt is a different beast. No older Intel generations where VMX errata could surface. This is AWS's standard playbook: ship narrow, expand later. The VSM auto-disable is another tell — they're not trying to solve every use case, just the microVM/sandbox one.

**4. Azure's "Direct Virtualization" is architecturally diverging from everyone else**

`whopdrizzard` (who works at Azure) describes "direct virtualization" — sibling VMs rather than nested ones. L2 VMs become technical siblings of L1, reducing context switches on VM exits and enabling hardware passthrough from L1 to L2. This isn't incremental. If it works at scale, it obsoletes the performance tax of traditional nesting entirely. AWS and GCP are converging on nested KVM; Azure is trying to leapfrog. This got minimal thread attention but is potentially the most consequential development mentioned.

**5. The microVM/sandbox market just consolidated around AWS**

Multiple companies surfaced their use cases: `sitole` (E2B — AI agent sandboxes), `sorenbs` (Prisma Postgres on Firecracker with 50ms cold starts from memory snapshots), `ushakov` (E2B again), `alexellisuk` (actuated — GitHub Actions runners). The common thread: all of these were either AWS-excluded or paying the bare-metal tax. `windsor` captures it perfectly: "Literally spent half a week planning a multi-quarter roadmap catering to working with bare metal. Half of that document is now deprecated LOL." The market was fragmenting across GCP/Azure/Hetzner specifically because of this gap. That fragmentation just stopped.

**6. The CI/CD use case is the quiet killer app**

`blaz0`: "This will make it easier to run automated tests in the Android emulator in CI." `paulfurtado`: "The place I've probably wanted it the most is in CI/CD systems." CI is the highest-volume, lowest-margin use of nested virt — and uniquely punished by AWS's gap. Unlike production microVM workloads that could justify bare-metal pricing, CI jobs are ephemeral and cost-sensitive. A $3,500/mo bare-metal instance to run Android emulator tests is obviously absurd. The result: GitHub Actions, GitLab CI, and other AWS-hosted CI platforms all had to document "nested virt not supported" caveats specifically because of AWS. That entire category of workarounds just evaporated.

**7. Performance tax is acceptable but not negligible**

`otterley` estimates 5-15%. alexellis's PVM workaround was 50-100% overhead. The alexellis blog shows bare-metal Firecracker adds only ~45% to a kernel build vs direct host, while PVM adds ~120%. So AWS's native nested virt should land somewhere between — a massive improvement over the PVM hack. `largbae` argues modern CPUs with hardware VMX support make the nested overhead minimal for pure compute; I/O is where it hurts.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "AWS is just late and lazy" | Medium | True on timing, but ignores Nitro's architectural differences. GCP and Azure had different starting points. |
| "Just use Hetzner/bare-metal" | Weak | Ignores enterprise procurement reality. Many orgs are contractually AWS-only. |
| "Cloud is too expensive, period" | Misapplied | `stoneforger`'s "perverse incentives" rant is sociologically interesting but doesn't help anyone making an actual infrastructure decision. |
| "This is trivial, works at home" | Weak | Demolished by otterley's response. Security at cloud scale ≠ libvirt on a homelab. |

### What the Thread Misses

- **No one asks about Graviton.** AWS's own ARM chips are conspicuously absent from the supported instance list. If this feature never comes to Graviton, it creates a permanent architectural split in AWS's own fleet between Intel (full-featured) and ARM (cost-optimized but limited). That would be a significant constraint on the Graviton migration story.
- **The VSM tradeoff is barely discussed.** Auto-disabling Virtual Secure Mode means nested virt and Windows security features are mutually exclusive. For anyone running Windows workloads with Credential Guard or VBS, this is a hard wall, not a footnote.
- **Pricing implications are unexamined.** Will AWS charge a premium for nested-virt-enabled instances? The 8th-gen Intel restriction could be a segmentation strategy, not just a technical one.
- **The Lambda/Fargate angle.** `raw_anon_1111` asks the right question — does AWS already run nested Firecracker internally? — but `wmf` and `otterley` both strongly hint they use bare metal for their own services. If AWS itself doesn't eat the nested virt tax at scale, that's informative about its real-world overhead.

### Verdict

The thread celebrates a genuine unlock while arguing about whether AWS deserves credit or blame. Both camps miss the structural story: AWS held the only cloud where you couldn't run the VM-based isolation model that *AWS itself invented and open-sourced*. That created a bizarre ecosystem distortion — an entire generation of microVM tooling was designed around AWS's absence. The feature ships not because AWS had a change of heart, but because the AI agent sandbox market (E2B, Prisma, etc.) made microVM-on-cloud a competitive requirement rather than a nice-to-have. The real signal isn't that nested virt arrived; it's that it arrived on only one CPU architecture, with security tradeoffs, on the newest hardware — which means AWS is still managing this as a controlled concession, not an enthusiastic embrace.
