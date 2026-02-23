← [Index](../README.md)

# HN Thread Distillation: "Web Components: The Framework-Free Renaissance"

- **HN thread:** https://news.ycombinator.com/item?id=47085370
- **Article:** https://www.caimito.net/en/blog/2026/02/17/web-components-the-framework-free-renaissance.html
- **Score:** 204 | **Comments:** 148 | **Date:** 2026-02-20

**Article summary:** A blog post arguing that modern browsers now support everything needed to build sophisticated UIs without React/Vue/Angular, via custom elements, shadow DOM, and native events. Pushes web components as stable, framework-free, and AI-learnable. Notably omits reactivity entirely and includes an XSS-vulnerable code example.

## Dominant Sentiment: Experienced skepticism, not hostility

The thread is dominated by practitioners who *have used* web components — some for nearly a decade — and whose experience leads them to a narrower endorsement than the article makes. The loudest critics aren't framework partisans; they're web component users explaining where the abstraction breaks down. This is more damning than outside dismissal.

## Key Insights

### 1. The article ignores the actual reason frameworks exist

The thread converges hard on one omission: reactivity. Web components provide `attributeChangedCallback` and that's it — no data binding, no declarative state-to-DOM synchronization, no efficient DOM diffing. This is the *central* value proposition of every major framework since Knockout. Multiple experienced voices call this out independently. **foobarbecue**: *"they don't provide reactivity; you have to write that yourself. Reactivity was the feature that launched modern js frameworks so I think the article really overstates the case."* **pier25** (WC user since 2016): *"The biggest problem frameworks solve is data binding and reactivity. Until there's a native solution to that, WCs will need some framework for anything non trivial."* The article hand-waves this by showing a trivial `innerHTML` assignment — which, as **lukax** points out, is an XSS vulnerability. This isn't a minor gap; it's the load-bearing wall.

### 2. The thread converges on a framework: distribution vs. building

The sharpest mental model comes from **skrebbel**: *"Web Components are amazing for distributing frontend libraries. But they're awful as building blocks to replace a framework... the term 'Web Components' is ridiculous. If only they'd stuck with 'custom elements', none of this confusion would've happened."* This distribution-vs-building distinction resolves most of the thread's apparent contradictions. Home Assistant (balloob) succeeds because it uses WCs as the *output format* for a Lit-authored codebase. Heff's Media Chrome works because it's a self-contained widget dropped into arbitrary pages. The failures occur when people try to use WCs as the *authoring* primitive for complex apps — and the article is selling exactly that failed use case.

### 3. Even the strongest success story concedes the point

**balloob** (Home Assistant founder, 13 years, the thread's strongest WC advocate) says: *"We currently use Lit for the framework on top (you do need one, that's fine)."* This single parenthetical demolishes the article's thesis. The person with the most successful web component deployment in the thread explicitly says you need a framework. The "framework-free" framing isn't just overstated — it's contradicted by its own best example.

### 4. Shadow DOM: the feature everyone is supposed to want but practitioners avoid

The article presents shadow DOM encapsulation as a major benefit. The thread reveals a split: experienced WC users increasingly prefer the "light DOM" approach. **WorldMaker**: *"I'm certainly feeling like Shadow DOM is the new iframe... for me the sweet spot is keeping all of a Web Component in the 'Light' DOM, let CSS do its cascading job."* **mikebelanger** notes that shadow DOM causes FOUC (flash of unstyled content) and that the encapsulation is overstated. **lelandfe** points out that CSS custom properties and inherited styles pierce shadow DOM anyway, making the article's claim that "global styles don't leak in" factually wrong. **psygn89** reports accessibility issues: *"arrow keys not always working... overlays acting strangely."* Shadow DOM's encapsulation model is simultaneously too aggressive (breaking forms, accessibility, overlays) and too leaky (CSS variables, inheritance) — the worst of both worlds for most use cases.

### 5. The Polymer→Lit churn exposes a meta-irony

A revealing subthread between **troupo** and **spankalee** (apparently on the Lit team) crystallizes a key tension. The WC pitch is "no upgrade treadmill," but the *authoring* side has already churned through Polymer → lit-html → Lit 2 → Lit 3 with breaking changes at each step. spankalee argues the *output* (standard web components) remains interoperable, which is technically true. troupo's counterpoint is devastating: *"you keep pretending that authoring web components is an insignificant part of what people do."* The upgrade treadmill didn't disappear; it just moved one layer down where advocates can pretend it doesn't exist.

### 6. Apple's LSP-based refusal fractures the spec

**hackrmn** surfaces a rarely-discussed fundamental issue: Safari refuses to implement `is=""` (customized built-in elements) because it violates the Liskov Substitution Principle. This means you cannot extend native elements like `<table>` or `<details>` with custom behavior in Safari. The spec is fractured at the browser level on a core feature, with well-reasoned technical objections on both sides. This makes "web standards are forever" claims ring hollow when the standards themselves are incomplete and disputed.

### 7. The WC community's relationship with framework authors is genuinely toxic

**troupo** provides specific citations: Alex Russell's dismissive Mastodon posts, Lea Verou calling framework authors' technical critique "hate," the 2022 Web Components CG report that acknowledged most of the problems framework authors raised for years — then went nowhere (no updates since). **unlog** adds: *"they claim you are free to participate only to be shushed away."* The linked Ryan Carniato article (SolidJS creator, 7 years of production WC use) makes the most technically sophisticated critique — Elements ≠ Components, DOM intermediation adds overhead, SSR/hydration is fundamentally harder — and the community response was hostility rather than engagement. This isn't just interpersonal drama; it explains why WC specs keep accumulating (20+ to patch holes) rather than being redesigned.

### 8. The article is likely AI-generated, which undermines its own AI pitch

**foobarbecue**: *"The 'AI makes it easy!' part of the article makes me want to hurl as usual. And I'll stop short of an accusation but I will say there were some suspicious em dash comparison clauses in there."* **benterix**: *"the fact that it was output by an LLM by itself makes it less trustworthy."* The article has classic AI tells: florid pull quotes that say nothing ("The DOM has always been an event bus. We just forgot how to use it"), balanced hedging in every section, and the XSS vulnerability in the code example that a practitioner would catch. An AI-generated article about how AI helps you learn web components — while demonstrating that the AI doesn't understand basic security — is the thread's richest irony.

## Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "WCs lack reactivity, so you end up needing a framework anyway" | Strong | Near-universal agreement from practitioners, including WC advocates |
| "Shadow DOM causes more problems than it solves" | Strong | Accessibility, FOUC, overlay breakage, CSS leaks — documented by users |
| "The 'no upgrade treadmill' claim is false (Polymer→Lit)" | Medium | Output interop is real, but authoring churn is real too |
| "Apple's `is=""` refusal breaks the spec" | Strong | Fundamental, unresolved, technical objection with merit |
| "Frameworks solve organizational problems WCs don't address" | Medium | True but somewhat tangential to the technical debate |
| "WCs are fine for embedded widgets / microfrontends" | Strong | The consensus "correct" use case |

## What the Thread Misses

- **TC39 Signals proposal** could close the reactivity gap natively. **KostblLb** mentions it in passing but nobody explores the implications. If signals ship in browsers, the equation changes fundamentally — but that's a 3-5 year timeline at best.
- **The compiler revolution is moving away from WCs, not toward them.** Svelte 5, Solid, and Million.js all optimize by *removing* component abstractions at build time. WCs are a runtime construct that can't be compiled away. The trend line points in the opposite direction from what the article claims.
- **Nobody asks why WCs haven't won after 13 years.** The technology shipped. The browsers support it. The evangelism has been constant. And yet adoption remains niche. The thread debates whether WCs are good enough but doesn't confront the revealed preference of millions of developers who had the option and chose otherwise. Network effects and ecosystem depth aren't bugs — they're the actual product.

## Verdict

The thread settles a question the article refuses to ask: web components are a *distribution format*, not an *application architecture*. They solve the "drop a widget into any page" problem well and the "build a complex app" problem poorly. The article's "framework-free renaissance" framing is not just wrong but actively harmful — it lures developers into rediscovering why Redux, virtual DOMs, and reactive state management were invented in the first place. The real story isn't a renaissance; it's a technology that found its niche (embeddable widgets, design system distribution) years ago and keeps being oversold as something bigger by advocates who mistake the output format for the authoring model.
