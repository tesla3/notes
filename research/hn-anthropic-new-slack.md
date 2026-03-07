← [Index](../README.md)

## HN Thread Distillation: "Anthropic, please make a new Slack"

**Source:** [HN](https://news.ycombinator.com/item?id=47280200) · [Article](https://www.fivetran.com/blog/anthropic-please-make-a-new-slack) · 234 points · 216 comments · 2026-03-06

**Article summary:** Fivetran CEO George Fraser argues Anthropic should build a Slack replacement because (1) Claude lacks group conversations, (2) Slack's data access policies lock out AI agents, and (3) Slack's network effects are weaker than assumed. He envisions "NewSlack" bundled with Claude seats, with a commitment to open data access and interoperability.

### Dominant Sentiment: Annoyed skepticism, correctly targeted

The thread largely rejects the premise — not because people love Slack, but because the ask is transparently self-serving and the Anthropic framing is a non-sequitur. The few supporters are drowned out by people who spotted the real game.

### Key Insights

**1. The article is a data pipeline company lobbying for data access, dressed as a product manifesto**

The sharpest read comes from [6thbit]: *"Sounds like fivetran, that does data pipelines, wants a Slack API to get access to 'the unfiltered, real-time stream of how your company actually operates' but slack keeps saying 'No.' ... Mentioning anthropic here just feels buzzwordy and in vogue enough to get traction."* This is the correct frame for the entire article. Fraser's company literally sells connectors that pipe data between SaaS products. Slack's closed API is a direct business problem for Fivetran. The Anthropic wrapper is marketing. [sanilnz] twists the knife: Fivetran itself jacked a customer's bill from $30K to $180K for syncing Google Sheets after acquiring Census — "So question why do we need Fivetran by same argument?"

**2. Anthropic's interoperability record directly contradicts the article's thesis**

Fraser claims Anthropic has a "demonstrated track record of standing by their principles" and would commit to open data access. [coder543] dismantles this comprehensively: Anthropic refuses to adopt the industry-standard OpenAI API format, won't support AGENTS.md (3000+ upvotes on the issue), and Claude Code is one of the only agentic coding CLIs that isn't open source. The article's central premise — that Anthropic is uniquely positioned to champion openness — is contradicted by Anthropic's actual behavior in its own market.

**3. The "chat is easy" paradox reveals capital structure, not engineering difficulty**

Multiple commenters insist chat is trivial, yet can't explain why Slack has no real competitor at scale. [hunterpayne] provides the best explanation: *"It's not hard. It's capital intensive with a low profit margin. So it doesn't attract a lot of competition because you can make more money in other ways that have moats."* You need massive marketing spend for network effects, heavy infrastructure costs, and you get only a few dollars per user. Quality software doesn't even register as a competitive factor. [bandrami]'s Chesterton's Fence observation — "everyone hates Slack and nobody has built a better group chat" should give people pause — is the thread's wisest single line.

**4. "Just vibe code it" exists simultaneously as sincere advice and reductio ad absurdum**

[kennywinker] names this perfectly: *"It's hilarious to see half the 'just vibe code it yourself!' comments are sarcastic, and the other half are serious…"* [empath75] genuinely suggests Claude can write a Trello clone in 15 minutes so why bother with SaaS. [vdfs] delivers the parody version: 10K agents, $20K in tokens, missing search and permissions, security figured out later, "it's 80% done, how hard can that 20% be?" This is the 2026 version of "how hard can it be?" and the thread can't tell its own sincerity apart.

**5. The real product gap is narrower than the article claims**

[cush] correctly diagnoses that the article is really asking for group chats with Claude — not a Slack replacement. [lukev] notes you could "vibe code a Slack plugin to make this work in like 15 minutes." [causal] points out these plugins already exist. [probabletrain] says their company already has AI agents as first-class Slack participants with search access. The article dramatically overstates the problem to justify a dramatic solution. The CEO even admits in comments that his real frustration is with Slack's API rate limits on `conversations.history` — which [sometdog] confirms was throttled to 1 request/minute last May.

**6. Slack's "data moat" cuts both ways**

[bandrami] makes the underappreciated point: *"Slack's data policy being 'no' is a big reason companies are willing to use it."* The article frames data lockdown as pure villainy, but enterprises choose Slack partly because it doesn't casually expose their internal communications to third parties. [troupo] is blunter: millions of private chats by people who didn't consent to AI access. The article's framing of "open data access" as an unambiguous good ignores that one company's "data liberation" is another company's compliance nightmare.

**7. Alternatives exist; adoption doesn't**

Zulip, Mattermost, Matrix, Google Chat, XMPP — they all get mentioned. [tabbott] (Zulip's actual lead) shows up to personally address a crash complaint. [EdNutting] reports easy Slack-to-Zulip migration. [conception] says Mattermost is "90% of Slack" and migrated in hours. The thread proves the problem isn't lack of alternatives — it's that nobody with organizational authority cares enough to switch. The article's premise that a new entrant would succeed where these haven't requires explaining what's different this time, and "it has Claude" isn't sufficient when Claude already integrates with Slack.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Wrong company — Anthropic builds models, not collaboration tools | **Strong** | [xemoka]'s power-company-building-trains analogy dominated the thread. Rebutted only weakly by Google analogies. |
| Chat is easy, just build it | **Weak** | Contradicted by the complete absence of successful Slack replacements despite decades of chat protocols. |
| Slack's data policy protects enterprises | **Strong** | [bandrami], [troupo] — the article treats this as a bug when it's a feature for buyers. |
| Self-serving ask from a data pipeline CEO | **Strong** | [6thbit], [sp1nningaway], [sanilnz] — the most devastating and well-evidenced criticism. |
| Claude already works in Slack | **Medium** | Technically true, but the API rate limits are real constraints for bulk access. |

### Astroturf / Spam

[autojunjie] posted the identical Chorus/OpenClaw pitch **four times** in the thread, complete with the same bullet-pointed "3-person startup" anecdote. Classic spam pattern. Nobody engaged meaningfully with any of the copies.

### What the Thread Misses

- **Salesforce's strategic position.** [dzhiurgis] hints at it in one late comment, but nobody develops it: Salesforce owns Slack *and* the CRM data. If anyone is positioned to open Slack's data to AI — on their own terms, within their own ecosystem — it's Salesforce, not Anthropic. The article's framing erases the actual owner of the product.
- **The rate-limit change is the real story.** Slack throttling `conversations.history` to 1 req/min (May 2025) is a concrete, recent policy decision that specifically targets data extraction use cases. This is what actually broke Fivetran's workflow, but the article buries it under grand rhetoric about "the Waterloo of closed data."
- **Enterprise procurement inertia.** Nobody addresses why Slack wins deals despite being expensive: it's already in the procurement stack, already SOC 2 certified, already approved by legal. A Slack replacement from an AI company with no enterprise collaboration track record faces years of compliance qualification before a Fortune 500 would touch it.
- **The bundling economics are backwards.** Fraser proposes bundling Claude seats with "NewSlack" to subsidize casual AI users. But Anthropic already can't meet demand for compute — why would they subsidize seats? The economics only work if chat is nearly free to run (it isn't) or if AI margins are enormous (they aren't yet).

### Verdict

The article is a CEO using the Anthropic brand as a battering ram against Slack's API restrictions that directly impede his company's product. The thread correctly identifies this but spends too much energy on the wrong debate ("should Anthropic build apps?") instead of the right one: Slack's post-2025 API lockdown is a real inflection point for enterprise data access, and the question isn't who builds a competitor — it's whether the market will force Salesforce to reverse course. The answer to "Anthropic, please make a new Slack" is the same answer as always with chat: the technology is trivial, the business is brutal, and the moat is procurement, not product.
