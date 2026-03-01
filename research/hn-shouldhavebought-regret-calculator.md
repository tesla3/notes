← [Index](../README.md)

## HN Thread Distillation: "Show HN: Quantifying opportunity cost with a deliberately 'simple' web app"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47138631) (27 points, 54 comments) · [shouldhavebought.com](https://shouldhavebought.com/)

**Article summary:** A Show HN for a retro-terminal-styled calculator that computes what your money would be worth if you'd invested it in a given asset at a given date. The creator (a trading platform developer who never traded) frames it as part dark humor, part meditation on web complexity. The post's real pitch is a "look how much infrastructure a simple page needs" argument, but the emotional hook — $60k → tens of millions in NVIDIA — is doing the actual work.

### Dominant Sentiment: Polite dismissal dressed as wisdom

The thread is overwhelmingly "hindsight is 20/20" — nearly every top-level comment makes some version of this point. Nobody is hostile, but nobody engages seriously with the technical questions the creator actually asked. The stack-complexity angle gets almost zero traction.

### Key Insights

**1. The thread converges on a single framework and refuses to leave it**

Every major commenter independently arrives at the same two-part objection: (a) you couldn't have known, and (b) you wouldn't have held. This is correct but so obvious it crowds out anything interesting. `nothrabannosir` states it most precisely: *"If you didn't buy at $2, you wouldn't have held at $4. If you didn't buy at $300, you wouldn't have held at $600."* The creator himself agrees — *"I would have sold it when I made X2"* — which undercuts his own project's premise in a way nobody follows up on. The calculator assumes diamond hands; the entire thread proves nobody has them.

**2. The creator is more self-aware than the thread gives him credit for**

Most commenters respond as if OP genuinely needs therapy for regret. But his replies are consistently self-deprecating and humor-oriented — *"Think of it as art. It's an interactive museum of missed opportunities."* When `Propelloni` pushes back with "What's the point of knowing last week's lottery numbers?", the exchange resolves elegantly: *"Art needs no justification. So, well done ;)"*. The thread largely misreads the tone, treating a joke project as a cry for help.

**3. The "Bullet Dodged" mode is the more interesting product and nobody explores it**

OP mentions a reverse mode that shows how much you saved by *not* buying before a crash. `hsbauauvhabzb` briefly touches survivorship bias, but the thread never seriously engages with the asymmetry: regret over missed gains is psychologically dominant, but relief from avoided losses is the more actionable framing. The calculator supports both, but the brand ("Wall of Pain") guarantees only the masochistic mode gets attention.

**4. The technical "complexity" pitch is self-defeating**

OP lists Alpine.js, Laravel, WebSockets, OG image generation, cron jobs, and caching as evidence that "simple" web apps are deceptively complex. But this is a solved problem space — the thread ignores it because the answer is obvious: yes, you could do this with a static site and an API call. `Garlef` and `endymion-light` ask implementation questions, but nobody engages with the philosophical framing because most HN readers have built things like this and don't find the stack notable. The infrastructure list reads less like a meditation on web complexity and more like a junior engineer discovering backend development.

**5. The "reverse mode" idea from `jbjbjbjb` is genuinely clever**

*"How much would you have needed to invest to make $1M?"* flips the calculator from emotional torture to something approaching useful — it reveals whether the bet was even plausible given your capital at the time. OP calls it "brilliant" and it is: it reframes "I missed out on millions" as "I would have needed to invest $47k in a meme coin I'd never heard of" — which is far more therapeutic than a raw regret number.

**6. The one authentic emotional moment gets buried**

OP drops a quietly devastating line in an otherwise jokey thread: *"I spent 20 years of my adult life on a cold and calculating lifestyle... one morning I woke up and realized that everything that had been acquired was lost due to circumstances beyond my control."* This is far more interesting than the calculator itself — it's the actual story of someone who optimized for financial discipline and still lost. Nobody follows up. The thread is too busy relitigating whether Bitcoin was predictable in 2015.

**7. The subscription-cancellation angle is the real product opportunity**

`Bishonen88` shares a feature from their own life-planning app: simulate cutting subscriptions and redirecting the savings to investments. The example — €60/month at 8% = €11,048 in 10 years — is forward-looking rather than backward-looking, actionable rather than masochistic. OP acknowledges this but worries it would kill the "fun spirit." He's right about tone, wrong about value. The market for "show me what my Netflix subscription costs me in retirement" is orders of magnitude larger than "show me how much NVIDIA I missed."

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Hindsight bias makes this meaningless | Strong but obvious | Correct, universal, and the creator already knows this |
| You wouldn't have held anyway | Strong | Creator agrees, which the thread doesn't notice undermines the tool |
| Survivorship bias — what about WeWork? | Medium | Valid but already addressed by "Bullet Dodged" mode |
| Stack is overengineered | Weak (implied) | Nobody says this directly but nobody engages with the tech questions either, which is the same signal |

### What the Thread Misses

- **The calculator is emotionally asymmetric by design.** "Missed gains" triggers loss aversion (Kahneman); "bullet dodged" triggers relief, which is neurologically weaker. The branding guarantees engagement but also guarantees the tool is psychologically harmful. Nobody names this.
- **The real audience isn't investors — it's social media shareability.** The OG image generation and "Wall of Pain" feed are the actual product. This is a content generator for Twitter/X posts about regret, not a financial tool. OP built a meme factory and framed it as a calculator.
- **Nobody asks about data accuracy.** Split-adjusted historical pricing, weekend/gap handling, the actual API sources — for a tool that outputs a "receipt," the accuracy of the receipt matters. One commenter flags missing pre-2014 BTC data; nobody else questions the numbers.
- **The "20 years lost to circumstances beyond my control" story is the article this should have been.** A trading-platform developer who never traded, practiced extreme discipline, and still lost everything is a far more compelling narrative than "I made a retro calculator."

### Verdict

The thread performs collective financial wisdom — "you can't predict the future, you wouldn't have held" — so uniformly that it becomes its own form of hindsight bias: everyone is certain they know why regret is irrational, which is itself a suspiciously convenient belief. The calculator works not because it's financially meaningful but because it weaponizes loss aversion for social sharing. OP built a viral content engine and accidentally revealed a much more interesting personal story that neither he nor the thread wanted to sit with.
