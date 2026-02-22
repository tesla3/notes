← [Index](../README.md)

## HN Thread Distillation: "AI uBlock Blacklist"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47098582) (218 points, 95 comments) · [GitHub repo](https://github.com/alvi-se/ai-ublock-blacklist)

**Article summary:** A manually curated uBlock Origin blocklist targeting AI content farms — sites that mass-generate SEO-optimized slop for ad revenue. Positions itself as a more focused alternative to the "HUGE AI Blocklist" which blocks anything AI-related including legitimate tools. The repo README included a combative "NAQ" (Never Asked Questions) section telling complainants to "cry about it," which was removed mid-thread after backlash.

### Dominant Sentiment: Sympathetic but governance-skeptical

The thread broadly agrees the problem is real and worsening, but the majority of substantive comments attack the project's fitness to solve it — not the goal itself. People want this to exist; they don't trust *this version* to be the one.

### Key Insights

**1. The NAQ removal is the story within the story**

The maintainer's "Cry about it" FAQ was deleted via [commit 7ebaa71](https://github.com/alvi-se/ai-ublock-blacklist/commit/7ebaa71) mid-HN-discussion, after [quiet35] flagged it as disqualifying. This reactive edit — removing antagonistic posture only when scale arrived — illustrates the fundamental tension: blocklist maintainers need the unaccountable freedom to move fast (you can't litigate every SEO grifter's appeal), but the moment a list gets popular, that same unaccountability becomes the attack surface. [well_ackshually] defended the original tone with "the sheer amount of mental denial of service that having to deal with SEO slopshitters opening issues" — an accurate description of the moderation burden, but one that doesn't survive the AP News problem (see below).

**2. AP News on a slop blocklist: the false positive that proves the critics right**

[lkm0] noticed apnews.com was on the list. [dgares] traced it to [commit f6ee8d7](https://github.com/alvi-se/ai-ublock-blacklist/commit/f6ee8d761d0cd30b75608acc4572fc3cf8d9aa82), which bulk-imported sites from an SEO company's internal spreadsheet. This is exactly the failure mode critics predicted: a maintainer who refuses appeals and bulk-imports from third-party sources will eventually block legitimate journalism. The manual curation claim in the README ("each entry is added manually") is already violated. This single data point does more damage to the project's credibility than any philosophical argument about governance.

**3. Blocklists are write-only reputational databases**

[dhayabaran] made the sharpest structural observation: "A blocklist with no removal process and a 'cry about it' attitude is basically a one-way reputational blackhole." [TonyTrapp] backed this with a concrete anecdote — his personal site landed on an unrelated PiHole list years ago, his removal request went unanswered, and it's still blocked. The asymmetry is stark: adding a domain costs one line of text; removing it requires discovering you've been blocked, finding the right repo, filing an issue, and hoping someone cares. Browser safe browsing lists re-check URLs periodically; community blocklists generally don't.

**4. The Grammarly-to-slop spectrum has no clean boundary**

[lifthrasiir] raised the Grammarly edge case and non-native speakers. [flkiwi] contributed the thread's most vivid anecdote: a highly capable but functionally illiterate coworker discovered Copilot email generation, and now sends "20-paragraph, bulleted, formatted OpenAI slop" instead of brief, correct, hard-to-parse emails — "like someone getting extraordinarily bad cosmetic surgery." [SpicyLemonZest] added that 10% of the time these AI-proxied communications contain confident assertions the person never intended. The dynamic here isn't AI replacing human writing — it's AI *replacing the signal that bad writing carried*. The terse, garbled email at least told you who wrote it and what they actually knew. The polished slop tells you nothing.

**5. "Check your adblocker" is the new "check your spam folder"**

[JamesLeonis] nailed the frame: HN regularly advocates blocking entire countries and IP ranges at the server level, then acts surprised when users apply the same logic client-side. The normalization of blocklists as personal infrastructure — not just for ads but for entire content categories — mirrors the evolution of email spam filtering from luxury to necessity. The question isn't whether people will curate their web; it's whether the curation layer becomes centralized (browser vendors, search engines) or fragmented (community lists with varying quality).

**6. The evolutionary arms race favors the slop**

[afcool83] raised the Borg metaphor: manual blocklists apply selection pressure for less-detectable AI content. [alansaber] pushed back — "it's actually rather difficult for SoTA models to shift tone without losing performance" — but this misses the point. The arms race isn't about model capability; it's about economics. Content farms don't need to fool experts; they need to fool Google's ranking algorithm long enough to harvest ad impressions. [mapontosevenths] cited Cory Doctorow's prescient story about spam bots evolving toward sentience through anti-spam selection pressure — a nice literary reference, but the practical reality is more mundane: the slop doesn't need to get *smart*, it just needs to get *slightly less detectable* per iteration, while blocklist maintainers burn out.

**7. Nobody wants the whitelist conversation**

[ramon156] proposed inverting the model: a whitelist of known-good sites with quality tags. [metalman] echoed this with "green(organic) lists." Both were basically ignored. This is telling — a whitelist is philosophically cleaner but operationally horrifying. It means accepting that the default web is untrusted, and only curated exceptions are safe. That's the logical endpoint of the current trajectory, and the thread flinched away from it. [amelius] joked "at least we're not yet in the phase where we have a whitelist for the internet" — but the app-store model that [papichulo2023] referenced *was* exactly that, and it nearly won.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Cry about it" attitude disqualifies the project | **Strong** | Validated by AP News false positive; maintainer partially conceded by removing the NAQ |
| Domains change hands, no expiry = permanent damage | **Strong** | [TonyTrapp]'s anecdote is concrete evidence; no one rebutted |
| This won't scale, AI will adapt | **Medium** | True long-term, but doesn't invalidate short-term utility; same argument applies to all spam filtering |
| Non-native speakers need AI writing help | **Misapplied** | The list targets content farms, not individuals; [rdmuser] and [jofzar] both clarified this |
| "Blacklist" terminology is offensive | **Weak** | Derailed into a predictable HN culture war; [charonn0] and [filldorns] talked past each other |

### What the Thread Misses

- **Search engines are the actual failure.** The entire blocklist ecosystem exists because Google's ranking algorithm rewards the content it should be demoting. Nobody asked why users need client-side tooling to fix a server-side problem. Google has the detection capability; it lacks the incentive.
- **Blocklist governance is a solved problem in other domains.** DNS blocklists (RBLs) for email spam went through this exact cycle in the early 2000s — combative maintainers, false positives, reputation damage, eventual professionalization. The thread could have learned from SORBS, MAPS, and Spamhaus instead of treating this as novel.
- **The "personal list" defense is incoherent at scale.** The README says "personal list," but it's published on GitHub with a subscribe link and accepts PRs. The maintainer wants community scale with personal-project accountability. This works at 50 subscribers; it doesn't work at 50,000.

### Verdict

The thread correctly identifies that this specific project has governance problems — the AP News inclusion alone is damning — but it mistakes the *project's* flaws for the *approach's* flaws. Manual, opinionated blocklists are exactly how email spam filtering started before it professionalized. What the thread circles but never states: the real product here isn't the list, it's the *curation methodology* in the README (the heuristics for identifying content farms). That's genuinely useful and transferable. The list itself is a throwaway artifact that will either professionalize or die — and given the maintainer's mid-thread retreat from "cry about it," the pressure toward professionalization is already working.
