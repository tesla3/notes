← [Index](../README.md)

## HN Thread Distillation: "Show HN: A native macOS client for Hacker News, built with SwiftUI"

**Source:** [HN](https://news.ycombinator.com/item?id=47088166) (203 points, 142 comments, 76 unique authors) · [GitHub](https://github.com/IronsideXXVI/Hacker-News) · Feb 20, 2026

**Project summary:** A ~2,050-line SwiftUI app that wraps HN into a native macOS split-view layout: story sidebar on the left, article webview and comments on the right. Built-in ad blocking via WKContentRuleList, HN account login with Keychain-stored sessions, Algolia-powered search, Sparkle auto-updates. MIT licensed, signed and notarized, with a fully open-source GitHub Actions CI/CD pipeline for macOS distribution. The developer explicitly calls out the CI/CD pipeline as the hardest part of the project.

### Dominant Sentiment: Warm reception, polite skepticism

A friendly Show HN thread with genuine appreciation for shipping a native app, but a recurring undercurrent of "why do I need this when I have a browser?" The developer is unusually responsive — shipping multiple feature requests *during the thread itself*.

### Key Insights

**1. The developer shipped features faster than the thread could request them**

The most notable dynamic isn't the app — it's IronsideXXVI's real-time response cycle. Font size adjustment was requested by alsetmusic, Brajeshwar, aquir, yawniek, and gedy. Within hours, IronsideXXVI posted *"Just pushed an update allowing users to adjust text size"* — multiple times, replying to each requester individually. ckluis suggested split-pane article|comments layout; IronsideXXVI replied *"Ahh cool! I can add an option for that"* and then 45 minutes later: *"Added."* greedo asked for a dark mode override; IronsideXXVI responded and then *"Added"* within the hour. This is Claude Code's signature velocity — and the developer confirms it: *"I prefer the claude code cli, it super charges the amount of work i'm able to do."* The thread is watching a human-AI pair program a product roadmap in real time, and mostly doesn't remark on it.

**2. The "comments are a webview" reveal undermines the "native" pitch**

destroycom delivers the thread's sharpest observation: *"most of the app is a webview. The comments just have some additional CSS styling slapped on top of the hackernews website. So you still have an entire HackerNews site loaded at all times when reading comments anyway."* jovantho and elcritch both independently request native SwiftUI comment rendering. This matters because the core value proposition is "HN as a first-class citizen on macOS, not a website I visit" — but the comments (which many readers value more than the articles) *are* still a website. The article pane is also a webview by necessity. So the "native" part is essentially the sidebar, navigation chrome, and bookmarks. The app is a well-constructed browser frame around web content, which is honest engineering but dilutes the pitch.

**3. The "why not just use a browser" question has no killer answer — and that's fine**

luma asks the question directly: *"I've never understood the concept of an app wrapper for a link aggregator... Why would I want to browse the web in this app as opposed to a web browser?"* thewebguyd gives the best defense: *"I want to use my OS's native window management and app management instead of just shoving everything into a browser tab."* pazimzadeh extends this to Hammerspoon-style window management workflows. But cortesoft's rebuttal is clean: *"why don't you just disable tabs and have every link open a new browser window?"* The thread never resolves this because the honest answer is aesthetic preference, not functional necessity — and that's a perfectly legitimate reason to build and use software. The people who want this know who they are.

**4. Claude as a GitHub contributor is the new "Sent from my iPhone"**

WhitneyLand flags it: *"I think you should remove Claude as a contributor to your repo. It probably weaseled its way in on its own."* IronsideXXVI confirms: *"I believe that is from having claude debug some issues with the build pipeline on it's own."* destroycom offers the counterpoint: *"I actually really appreciate it when people do not hide their use of Claude code in their repo like that. It's usually the first thing I check on Show HN posts these days."* This is a small but culturally significant exchange. Claude Code's git integration auto-attributes commits, creating an accidental transparency signal. rickknowlton confirms the project was built in under a week with Claude Code CLI. The thread treats this as unremarkable — the norm has shifted from "did you use AI?" to "which AI did you use and how?"

**5. The CI/CD pipeline is the real contribution, and the thread knows it**

IronsideXXVI correctly identifies that *"Getting macOS code signing and notarization working in CI was honestly the hardest part of this project."* elcritch: *"That's actually the first thing I looked at in your Github Repo."* Klonoar shares their own experience: *"I'm thankful that it's largely a 'once it's working, it rarely breaks'. If it does break, it's usually because I have to sign in to the developer portal and accept some contract somewhere."* vanyle asks about cost and feasibility. The 467-line GitHub Actions workflow for build → codesign → notarize → DMG → Sparkle → deploy is more reusable and harder to produce than the app itself. In a world where Claude Code can scaffold a SwiftUI app in a day, the scarce knowledge is the macOS distribution plumbing.

**6. The ad blocking licensing tension is real and unsolved**

Octoth0rpe suggests piggybacking on uBlock Origin's filter lists. Someone immediately spots the problem: uBlock is GPLv3, the app is MIT. Octoth0rpe asks if the developer would switch to GPL; agg23 correctly pushes back that changing your entire project license for a secondary feature is a bad trade. soulofmischief raises the deeper concern: *"what keeps me in the browser is things like uBlock Origin + uMatrix... I don't necessarily have a ready solution to offer, but these are the obstacles."* Any native app that embeds web content inherits the ad blocking problem, and the browser ecosystem has a 15-year head start on solutions that no single developer can replicate.

### What the Thread Misses

- **The app's real competitor isn't the browser — it's RSS readers.** rcarmo and cadamsdotcom both note this, but nobody develops the comparison. NetNewsWire (which pazimzadeh references) already provides a native macOS split-view for reading web content from feeds. The HN-specific features (comments, upvoting, search) are the differentiator, but if comments are a webview, the differentiation narrows to login persistence and bookmarks.
- **Nobody asks about the security implications of Keychain-stored HN sessions and cookie injection.** The app stores your HN session in the macOS Keychain and injects cookies into WebViews. This is standard practice, but in the context of soulofmischief's concern about trusting new apps, it deserved more scrutiny.
- **The "built in a week with Claude Code" framing cuts both ways.** It's impressive velocity, but it also means the maintainability story is unproven. A solo developer who can ship features in an hour can also abandon the project in a week. The 121 commits and rapid feature churn suggest high energy right now; the question is whether the architecture supports sustained development or whether it's accumulating debt.

### Verdict

This thread is less about a Hacker News client and more about the new shape of solo development in 2026. A single developer with Claude Code ships a signed, notarized, auto-updating macOS app in under a week, then live-patches features into it while the Show HN thread is still active. The community receives this with mild appreciation rather than astonishment — which is itself the signal. What nobody in the thread says outright: the *app* is trivially reproducible (anyone with Claude Code could build an equivalent in a weekend), but the *distribution pipeline* and the *taste for what feels native* are the human contributions that still matter. The Show HN format is quietly shifting from "look what I built" to "look how fast I built it and how I ship it."
