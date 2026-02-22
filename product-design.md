← [Index](README.md)

# Product Design Observations

Novel implementation patterns, UX choices, and product architecture insights observed in the wild. Concrete and specific — not opinions about what *should* work, but observations of what *did* land.

---

## SSH as management plane

shellbox.dev (messh/skariel), [HN #46638629](https://news.ycombinator.com/item?id=46638629), Feb 2026

Entire product lifecycle managed through SSH commands — no web console, no CLI tool to install, no API keys. Account creation, VM provisioning, billing, fund top-ups (via text-mode QR code rendered in terminal), refunds, and teardown all happen through `ssh shellbox.dev <command>`. File transfer via standard `scp`/`sftp`.

The thread's reaction was telling: the billing UX drew more admiration than the actual VM product. [bks]: "What a brilliant billing and account interaction interface. I legitimately wanted to build something like this for a transactional SMS provider." [exabrial]: "No 'command line tools' to install. No absurd over-complicated web APIs."

Stack: Python + AsyncSSH server as the management plane, Firecracker VMs, Paddle for payments, Caddy for TLS.

**What's novel:** Not SSH access to servers (ancient), but SSH as the *sole* interface for the entire business — billing, provisioning, account management. Zero browser dependency. The pattern is transferable to any developer-facing service where the customer already has a terminal open.

([source](research/hn-shellbox-dev.md))
