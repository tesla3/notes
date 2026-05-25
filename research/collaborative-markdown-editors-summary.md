# Collaborative Markdown Editors — Distilled Comparison

Source: quip-alternatives-2026.md, research-collaborative-markdown-editors.md | Distilled 2026-04-02

## The Gap

No tool nails all five of: **simple, robust, self-hosted, real-time collaborative, raw Markdown**. You pick 4 out of 5.

## Head-to-Head

| | HackMD | HedgeDoc | Outline | Docmost | Wiki.js | SilverBullet |
|---|---|---|---|---|---|---|
| **Category** | SaaS editor | Self-hosted editor | Self-hosted wiki | Self-hosted wiki | Self-hosted wiki | Self-hosted PKM |
| **Raw Markdown** | ✅ native | ✅ native | ❌ rich editor (MD shortcuts) | ❌ rich editor | ✅ has raw MD mode | ✅ `.md` on disk |
| **Real-time collab** | ✅ live cursors | ✅ live cursors | ✅ | ✅ | ❌ edit-save-publish | ❌ single-user |
| **Inline comments** | ✅ | ❌ major gap | ✅ | ✅ | ❌ | ❌ |
| **Self-hostable** | ❌ SaaS only (enterprise exception) | ✅ AGPL | ⚠️ BSL 1.1 (not true OSS) | ✅ AGPL | ✅ AGPL | ✅ MIT |
| **Infra complexity** | N/A | 🟢 2 services (app + PG) | 🔴 5 services (PG, Redis, S3, OIDC, proxy) | 🟢 3 services (PG, Redis, app) | 🟢 2 services | 🟢 1 service |
| **Horizontal scaling** | ✅ (their problem) | ❌ single-process only | ✅ | unknown | ✅ | N/A |
| **Structured wiki** | ⚠️ tags only, no hierarchy | ❌ flat list | ✅ document tree | ✅ | ✅ | ✅ vault/folders |
| **Git sync** | ✅ GitHub/GitLab | ❌ | ❌ | ❌ | ✅ `.md` in repo | ✅ (it IS the filesystem) |
| **Search** | ⚠️ mediocre on free | basic | ✅ excellent full-text | ✅ | ✅ | ✅ |
| **API** | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Auth** | built-in + SSO | LDAP, OAuth (fragile upgrades) | ❌ no local auth, requires OIDC | ✅ built-in + OAuth | ✅ local, LDAP, OAuth, SAML | N/A |
| **Security** | managed | ⚠️ steady XSS/CSRF CVEs, no audit | ✅ Doyensec audit 2025 | ⚠️ no audit, pre-v1 | mature | — |
| **Project health** | commercial, stable | ⚠️ v2 rewrite stalled since 2024, v1 maintained by 2-3 people | 37.8k★, monthly releases, BDFL risk (tommoor ~90% commits) | 19.6k★, exploding growth, pre-v1.0 | 28k★, mature, v3 promised but not shipped | 4.9k★ |
| **Pricing** | Free (public), $5/user/mo (private) | Free | Free (self-host), $10/user/mo cloud | Free | Free | Free |
| **Best for** | Team collab, zero ops | Ephemeral sessions, small teams | Polished team wiki | Simpler Outline alternative | MD wiki, no real-time needed | Solo PKM |

## Critical Insights

| Insight | Detail |
|---|---|
| **HedgeDoc v2 is a zombie** | Announced 2021, last alpha Sep 2024, repos archived. You're betting on a legacy 1.x codebase with no architectural future. |
| **HedgeDoc can't scale** | Single-process, stateful. Official FAQ confirms no multi-instance. 100% CPU / memory leak reports under load. |
| **HedgeDoc XSS surface** | MD rendering + file uploads + UGC = large attack surface. 6+ CVEs, no formal audit, ~35 contributors playing whack-a-mole. |
| **Outline isn't really markdown** | Stores MD internally but no raw source view (issue #787 open since 2021). Copy-paste loses MD formatting. |
| **Outline license is BSL** | Can't compete with their cloud offering. Not true open source. |
| **Wiki.js v3 is also stalled** | Promised real-time collab, years in dev, still not shipped. Current v2 is edit-save only. |
| **No internal Amazon adoption** | Zero internal deployments of HedgeDoc, HackMD, or Outline. HackMD blocked by AGPL. Teams use Quip or homegrown hacks (Pippin, CRUX+Tampermonkey, LinkDown). |
| **CRUX markdown ≠ Quip replacement** | Great for reviewing `.md` in code reviews, not for authoring or real-time collab. Different problem. |

## Decision Matrix

| Need | Pick | Accept |
|---|---|---|
| SaaS, zero setup, team collab | **HackMD** ($5/user private) | No self-hosting, vendor dependency |
| Self-hosted real-time MD collab | **HedgeDoc** | No comments, no scale, security risk, dead v2 |
| Self-hosted polished wiki | **Outline** (infra) or **Docmost** (simpler) | Not raw markdown, BSL (Outline) or immature (Docmost) |
| Self-hosted MD wiki, async OK | **Wiki.js** | No real-time editing |
| Personal, no collab | **Obsidian** or **SilverBullet** | Single-user only |
| Pragmatic hybrid | **HedgeDoc → git commit** | Two-tool workflow, manual sync step |

## Verdict

**HackMD** is the closest to "Quip but markdown" — real-time collab, inline comments, raw `.md`, GitHub sync. Trade-off: SaaS only.

**Self-hosted?** Nothing is good enough yet. The least-bad option is **HedgeDoc as ephemeral scratchpad → git as canonical source**, accepting its limits. Watch **Docmost** — if it matures and adds raw MD mode, it could be the answer.
