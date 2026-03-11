← [Index](../README.md)

# Susam's Blogroll — Evaluation

**Source:** [susam.net/roll.html](https://susam.net/roll.html) — a curated list of 10 blogs by Susam Pal, author of susam.net. The list is small and intentional (not a link dump), which itself signals taste. The blogroll tilts heavily toward: Lisp/functional programming, Emacs, systems programming, old-school web aesthetics, and people who build things for the joy of it. These are Susam's *favourites*, not a representative sample of the tech blogosphere.

---

## The Blogs

### 1. Alex Kladov (matklad) — matklad.github.io
**Verdict: ★★★★★ — Elite-tier technical blog. The strongest entry on this list.**

Creator of rust-analyzer, now at TigerBeetle. Prolific: 150+ posts from 2017–2026, with an *accelerating* pace (15+ posts in early 2026 alone). Topics span compilers, language design, systems programming, Zig, Rust, CI/CD, and software engineering philosophy.

**What makes it exceptional:**
- Deep technical substance on genuinely hard problems (incremental compilation, parser design, concurrency primitives, memory allocation strategies)
- Contrarian positions backed by experience, not posturing. "Against Query Based Compilers" is the kind of post only someone who *built* a query-based compiler (rust-analyzer) could write credibly
- The writing is crisp and opinionated but never inflammatory. Rare combination
- Consistent quality across years — no decline, no filler
- Posts like "Push Ifs Up And Fors Down", "Spinlocks Considered Harmful", and "Simple but Powerful Pratt Parsing" have become canonical references in their niches

**Weaknesses:** Nearly none for what it is. Could be criticized for being narrowly technical, but that's the point. The "Things I Have Learned About Life" post (2020) suggests depth beyond code but it's an outlier.

**Signal:** If you write systems software, this is required reading.

---

### 2. Peter Norvig — norvig.com
**Verdict: ★★★★★ — Canonical. Not a blog in the traditional sense — a monument.**

Distinguished Education Fellow at Stanford HAI, former Research Director at Google, co-author of *the* AI textbook. The site is a collection of essays, tutorials, and projects spanning decades.

**What makes it exceptional:**
- "Teach Yourself Programming in Ten Years" is one of the most-cited essays in programming culture
- The tutorials (Spelling Corrector in 21 lines, Sudoku solver, Lispy Scheme interpreter) are masterclasses in elegant problem decomposition
- "The Unreasonable Effectiveness of Data" (2009) was prescient about the direction AI actually took
- Writing has the rare quality of making hard things look easy without being reductive

**Weaknesses:** Update frequency is low — this is closer to a permanent reference library than an active blog. The site design is deliberately archaic (which fits the ethos but can feel like a museum). Not really a "weblog" in the conversational sense.

**Signal:** You've probably already read the key pieces. If you haven't, stop reading this and go do that.

---

### 3. Mickey Petersen — masteringemacs.org
**Verdict: ★★★★ — The authoritative Emacs resource. Niche but unmatched within it.**

Author of the *Mastering Emacs* book. The blog is essentially a companion/extension of the book — deep tutorials on Emacs features, workflows, and packages.

**What makes it exceptional:**
- Unparalleled depth on Emacs. Not "10 cool Emacs plugins" listicles but genuine explanations of how Emacs internals work and why they matter
- The Reading Guide page shows thoughtful curation — rare for a blog
- Has published custom Emacs packages (e.g., combobulate for structured editing)
- Writing is clear and authoritative without being gatekeeping

**Weaknesses:** Extremely narrow niche. If you don't use Emacs, this blog offers essentially nothing. The site is commercial (book sales funnel with modal popups), which creates friction. Update cadence is irregular.

**Signal:** If you use Emacs seriously, this is your first stop. Otherwise, you can skip it entirely.

---

### 4. Susam Pal — susam.net
**Verdict: ★★★★ — Understated, precise, delightful. A craftsman's blog.**

The blogroll curator himself. 74 posts covering mathematics, programming puzzles, Emacs, web design philosophy, and personal computing history.

**What makes it exceptional:**
- Posts are beautifully scoped. "Fizz Buzz in CSS" takes a toy problem and explores it with real rigor — counting selectors, discussing code golf constraints, linking to working examples. This is the platonic ideal of a short technical post
- "Twenty Five Years of Computing" is warm personal writing that doesn't descend into self-congratulation — the stories are about *other people*
- The site design practices what he preaches: lightweight, no JavaScript required, clean HTML, "Designed to Last"
- Mathematical posts (Finite Fields, Cosines Fizz Buzz) show genuine comfort with both theory and implementation

**Weaknesses:** Low volume (74 posts over 25 years). Some posts are quite short — more sketch than essay. The mathematical content, while excellent, appeals to a narrow audience.

**Signal:** Subscribe if you like mathematically-flavored programming writing with no filler. Every post earns its existence.

---

### 5. Artyom Bologov (aartaka) — aartaka.me
**Verdict: ★★★½ — Wild, creative, polarizing. The punk rock blog on this list.**

Self-described "ironic bipolar programmer." Prolific: 60+ posts in ~3 years. Topics: Common Lisp, Scheme, ed(1), Lambda Calculus, web standards, and deliberate provocations.

**What makes it exceptional:**
- Genuinely original voice. Collecting Reddit hate-comments as pull quotes is inspired
- The ed(1) series (using ed as a static site generator, syntax highlighting ed, metaprogramming ed) is legitimately fascinating — nobody else is exploring this territory
- "Against Markdown" makes real arguments (underspecification, non-semantic misuse of bold) rather than just being contrarian
- Lambda Calculus tutorial series is patient and well-structured
- Offers .txt, .7 (man page), and .tex versions of every post — commitment to the bit

**Weaknesses:** The "chaotic" persona can be self-indulgent. Some posts feel like they exist to be weird rather than to communicate ("Regex Pronouns?", "Making C Code Uglier"). The broken URLs (pages moved without redirects) suggest the chaos extends to maintenance. Writing quality is uneven — brilliant paragraphs next to sloppy ones. The CSS-only syntax highlighting and ed-as-SSG are impressive stunts but not practically useful.

**Signal:** Follow if you enjoy opinionated Lisp culture and don't mind sifting through provocations to find genuine insights. Skip if you want consistent, practical technical writing.

---

### 6. Terence Eden — shkspr.mobi
**Verdict: ★★★½ — Prolific generalist. The most "blog-shaped" blog on this list.**

Blogging since at least the 1990s (archive goes back to 1986/1987!). Topics span technology, book reviews, gadget teardowns, web standards, accessibility, politics, and random observations. Has an ISSN number for his blog, which is delightfully extra.

**What makes it exceptional:**
- Remarkable range and volume. Posts about firmware updates for cable testers sit next to book reviews sit next to beer price economics
- The beer/minimum-wage post is a perfect example of what blogging should be: a casual observation, actual data from ONS, a simple analysis, a clear conclusion, all in 450 words
- Theme switcher with options including "Drunk" and "Nude" (disables all CSS) shows personality
- Real engagement with commenters (Mastodon integration)
- Web standards work gives authority to his tech opinions

**Weaknesses:** Jack of all trades. Many posts are lightweight — book reviews that are a paragraph, gadget posts that are essentially unboxing notes. The sheer volume means signal-to-noise isn't great if you're looking for deep technical content specifically. The WordPress setup with its JS-heavy theme switcher is ironic given the indie web ethos.

**Signal:** Good general tech blog if you enjoy the UK tech commentator voice. Don't expect depth on any single topic.

---

### 7. Sacha Chua — sachachua.com
**Verdict: ★★★ — The Emacs community's newspaper. A blog unlike any other.**

8,283 posts (!). That's not a typo. Active since early 2000s. Former Emacs maintainer (Planner, Remember). Currently focused on childcare + Emacs hacking + speech recognition workflows.

**What makes it exceptional:**
- The weekly "Emacs News" roundups are genuinely useful community infrastructure — she's been curating links for the Emacs ecosystem for years
- The speech recognition + Emacs integration work is original and technically interesting (voice-activated yasnippet expansion)
- Radical transparency: posts include full Emacs Lisp code, workflow descriptions, and thinking-out-loud process

**Weaknesses:** Most posts are working notes, not essays. The 8,000+ post count reflects quantity-over-quality — many entries are fragmentary, personal task logs, or link dumps. The site has accessibility issues (404 on expected URLs like /about/). Sketchnotes are a signature feature but don't translate well to RSS. Very narrow focus: if you don't use Emacs and Org-mode, this blog is a foreign language.

**Signal:** Subscribe to the Emacs News weekly if you use Emacs. The personal posts are an acquired taste — impressive as a practice but not always rewarding to read.

---

### 8. Alex Alejandre — alexalejandre.com
**Verdict: ★★★ — Renaissance programmer. Interesting breadth, uneven execution.**

Software engineer writing about Lisp, Janet, finance/commodities, architecture, and literature (including poetry in multiple languages: German, French, Spanish, Russian, Persian).

**What makes it exceptional:**
- The interview series (Steve Klabnik, Bakpakin/Janet, Technomancy/Fennel) is genuinely valuable — thoughtful questions to important but under-covered figures in the programming world
- "Revolt of the Simple" and "Antikubernetes Propaganda" show willingness to push back on industry orthodoxy
- The philology/language interests create unexpected connections (linguistics → API design)
- Breadth is remarkable: commodity supercycles, Persian poetry, Rust, cloud architecture

**Weaknesses:** Broken URLs everywhere (many posts 404). The tag cloud on the homepage is chaotic (leaked JavaScript in the page body). Some posts are stubs or "commonplace book" notes that aren't fleshed out enough to stand alone. The finance/geopolitics content is generic compared to the programming content. The breadth that makes it interesting also makes it unfocused.

**Signal:** Worth checking the interviews and the opinionated architecture posts. The rest is hit-or-miss.

---

### 9. Thejesh GN — thejeshgn.com
**Verdict: ★★½ — Earnest personal blog. More diary than publication.**

Independent technologist, hacker, and open data/internet activist from Bangalore, India. Blogging regularly with weekly notes, travel logs, and occasional tech posts.

**What makes it exceptional:**
- Consistent weekly writing practice maintained over years
- Open data activism and civic hacking perspective is underrepresented in the English-language tech blogosphere
- Kannada-language content shows genuine commitment to local language web
- The "Independent Technologist" framing and civic hacking angle (InfoActivist) is admirable

**Weaknesses:** Most content is personal weekly logs (what I did, what I read) that don't offer much to outside readers. Tech posts lack the depth or novelty of the stronger blogs on this list. The site design is WordPress-heavy with search bars, complex menus, and JavaScript that contradicts the indie web spirit the blogroll otherwise embodies.

**Signal:** Interesting as a window into the Indian tech/civic hacking scene. Not a destination for technical content.

---

### 10. Max (maxwellito) — maxwellito.com
**Verdict: ★★★ — Not a blog. A portfolio. But a good one.**

London-based software engineer. The site showcases side projects: Vivus (SVG animation library, popular on HN), Minimator (minimalist graphics editor), BreakLock (puzzle game), Triangulart, and various creative coding projects.

**What makes it exceptional:**
- Vivus is a legitimate open-source success story (popular enough for Adobe plugin ripoffs and Chromium bug reports)
- The creative projects (Justice × IKEA light recreation, doodling, Tetris on Launchpad) show genuine creative range
- Writing about each project is honest and self-aware ("maker of the useless")
- Beautiful presentation — the portfolio itself is a design statement

**Weaknesses:** This isn't really a blog — there are no articles, no essays, no ongoing publication. It's a portfolio page. Inclusion in a "blogroll" is unusual. The projects, while clever, are mostly small creative experiments rather than tools or libraries others would use (Vivus being the exception).

**Signal:** Inspiring as a showcase of creative side projects. Not something you'd subscribe to via RSS for regular reading.

---

## Overall Assessment of the Blogroll

**What the list reveals about Susam's taste:**
- Strong preference for independent, self-hosted, lightweight web presence
- Lisp/Emacs/functional programming bias (at least 5/10 blogs have significant Lisp or Emacs content)
- Values craft, originality, and technical depth over popularity or career signaling
- Favors people who *build things* and write about it, not people who write about writing about things
- No Medium posts, no Substack, no corporate blogs — this is indie web to the core

**The tier list:**
- **Must-follow:** matklad, norvig
- **Strong follow (if in the niche):** masteringemacs, susam.net, aartaka
- **Casual follow:** shkspr.mobi, alexalejandre
- **Occasional check:** sachachua (for Emacs News), thejeshgn, maxwellito

**What's missing:**
The blogroll skews heavily toward a specific aesthetic: old-school, text-heavy, Lisp-adjacent, Emacs-using, indie web. There's no representation of systems programming outside the Rust/Zig axis (no kernel/embedded), no data engineering, no distributed systems (apart from matklad touching TigerBeetle), no security research, no ML/AI research blogs. This is a curated taste, not a survey — and that's fine. The omissions say as much as the inclusions.

**The OPML file** is available at the bottom of the blogroll page for import into feed readers like NetNewsWire. All 10 blogs have RSS feeds.
