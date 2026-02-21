← [Index](../README.md)

## HN Thread Distillation: "Pi for Excel: AI sidebar add-in for Excel"

**Article summary:** Open-source (MIT) Excel sidebar add-in built on the Pi coding agent framework. Multi-model (Anthropic, OpenAI, Gemini, GitHub Copilot via API key or OAuth), 16 built-in spreadsheet tools, extension system, MCP gateway support, tmux/Python bridges. Solo developer project by Thomas Mustier.

### Dominant Sentiment: Quiet enthusiasm, "finally OSS"

Small thread (28 comments, 103 points) with a Show HN energy. The author is active and responsive. Genuine interest, no hostility, and a shared sense that someone finally built the open-source version of what a dozen startups are charging for.

### Key Insights

**1. Pi-the-framework is proving its thesis as a building block**

The real story isn't the Excel add-in — it's that one developer built a production-grade, multi-model agent for a complex host environment (Excel's Office.js API) by composing Pi's published packages: pi-agent-core for the tool loop, pi-ai for LLM abstraction, pi-web-ui for the interface. tmustier: "OG Pi is made to be extended & used as a building block so closer to say I wrapped it." The virtual filesystem approach for skills in a browser context is a pragmatic adaptation. This is the first non-trivial third-party product built on Pi's SDK that's gotten traction — it validates the "hackable agent framework" positioning.

**2. The gap between "AI in Excel" and "AI that builds Excel" remains wide**

conductr's question is the thread's most revealing moment: "Does this help actually build with excel or just analyze what data is in excel?" They want AI to construct Gantt charts, choose layouts, execute GUI actions — the way a human Excel power user would. jcmp tested it: the agent can create and format tables but can't create charts; it falls back to telling you what to click in the UI. conductr: "I suppose that's helpful but not too different than using Google." This is the frontier that Microsoft Copilot hasn't crossed either — the gap between *understanding* a spreadsheet and *authoring* one as a skilled practitioner would. The tool set (16 tools) is comprehensive for data manipulation but stops at the boundary where Office.js's charting API gets complex.

**3. Consumer OAuth token reuse is a quiet timebomb**

rahimnathwani noted the add-in works with "oauth tokens from consumer AI subscriptions, and even free ones like Antigravity." lm28469's reply was deadpan: "48 hours later on HN: 'Google just banned my 27 years old account for absolutely NO REASON.'" This is a real risk. Routing consumer subscription tokens through a third-party add-in proxy likely violates ToS for most providers. The author built a CORS proxy specifically to handle OAuth inside Excel's webview — clever engineering, but it means your auth tokens transit through localhost (or potentially a hosted endpoint). For API keys this is fine; for OAuth on consumer accounts, the user is accepting risk they probably don't understand.

**4. Office add-in distribution is still a miserable experience**

jweir's comment captures a structural problem Microsoft hasn't solved: sideloading is painful, the MS App Store is a headache, and there's no middle ground for distributing to customers. cygnusmove's suggestion (Integrated Apps via tenant admin) only works for same-tenant employees. For an open-source tool targeting individual power users, the distribution story is: download an XML manifest, figure out where to put it on your OS, and accept that on the web version it disappears after a week. This friction ceiling limits adoption of every non-Microsoft Excel add-in, regardless of quality.

**5. One-person agent products are now viable**

tmustier is juggling this with a new job, making changes daily, and has a working product with 16 tools, multi-model support, extension sandbox, session management, and workbook recovery. The enabling factor is composing existing agent infrastructure (Pi) rather than building from scratch. airstrike: "there are about a dozen startups doing variations of this right now. it's good to see an open source alternative pop up." The economics of AI-in-$APP startups just got harder — if one developer on nights-and-weekends can ship a credible open-source competitor, the moat for the funded versions has to be distribution and polish, not capability.

### What the Thread Misses

- **No security discussion.** An Excel add-in with 16 tools that can write cells, modify structure, and run Python via a localhost bridge is a significant attack surface. The repo has a security threat model doc, but nobody in the thread asked about it.
- **No comparison with Microsoft Copilot for Excel.** The obvious competitor wasn't mentioned once. How does a BYO-key open-source agent compare to the $30/user/month integrated offering? Is Copilot's chart creation actually better, or does it hit the same walls?
- **Extension system risks.** "The AI can generate and install extension code directly" running in an iframe sandbox — this is powerful but the trust model for AI-generated code executing in your Excel environment deserves scrutiny.
- **conductr's vision is the real product.** An AI that takes over the GUI and executes multi-step workflows as a skilled user would (Photoshop layers, Excel charts, animation rigs) — that's computer-use applied to professional tools. Nobody connected this to the existing computer-use work at Anthropic/OpenAI.

### Verdict

This is a small thread about a small project, but it reveals two dynamics worth tracking. First, composable agent frameworks (Pi specifically) are lowering the cost of building domain-specific AI tools to the point where one developer can compete with funded startups — the "WordPress moment" for AI agents may be approaching. Second, the thread's most interesting exchange (conductr asking for an AI that *builds* spreadsheets, not just reads them) identifies the gap that none of the current tools — commercial or open-source — have closed. The AI-in-Excel space is crowded with analyzers; what users want is an AI Excel *practitioner*. That requires computer-use-level tool integration, not just API wrappers, and nobody's there yet.
