← [Index](../README.md)

## HN Thread Distillation: "Show HN: Agent Skills Leaderboard"

**Source:** [skills.sh](https://skills.sh) — Vercel-built leaderboard ranking "agent skills" (markdown instruction files for coding agents like Claude Code, Codex, Cursor) by download count from their own `npx skills` CLI. [HN thread](https://news.ycombinator.com/item?id=46697908), 135 points, 44 comments.

**Article summary:** skills.sh is a leaderboard that ranks agent skills by weekly installs via Vercel's `npx skills add` CLI. The tool supports 40+ agents and uses symlinks to install SKILL.md files into agent-specific directories. Top-ranked skills are dominated by Vercel's own repos and Anthropic's official skills, with Vercel's `react-best-practices` at #1.

### Dominant Sentiment: Skeptical interest, fragmentation fatigue

The thread is cautiously engaged but deeply suspicious of the self-promotional dynamics and frustrated by the emerging "wild west" of skill distribution. Multiple experienced users report that skills don't reliably activate, which undercuts the entire value proposition.

### Key Insights

**1. Skills have a reliability crisis that nobody's solving with leaderboards**

The most consequential dynamic in the thread isn't about distribution — it's that skills frequently don't work. Multiple users report LLMs simply ignoring skill instructions. `rudedogg`: "I'm having issues with the LLMs ignoring the skills content... it's put a damper in my dream of constraining them with well crafted skills." `KingMob` echoes: "I'm still trying to figure out why some skills are used every day, while others are constantly ignored." A leaderboard ranked by download count measures distribution, not efficacy — and the gap between "installed" and "actually used by the model" is the real problem.

**2. The hooks workaround reveals skills are a premature abstraction**

The star subthread: `testfrequency` had a 1,900-line CLAUDE.md and skills that were never invoked. `chewz` gave the fix: "Create a hook that would ask Claude Code to evaluate all skills in the project and decide which are applicable to the current task at hand. Forget Claude.md." testfrequency dropped to 150 lines + skills + hooks and reported dramatically better results with fewer tokens. The mechanism matters: skills are *supposed* to be lazy-loaded based on description matching (the model reads the index and decides what to load). But current models aren't reliable at this autonomous selection step — so you need a hook (essentially a pre-prompt injection) to force evaluation. This is a workaround for a model capability gap that skills proponents aren't acknowledging.

**3. Vercel is building a package manager and calling it a leaderboard**

Multiple commenters (`saberience`, `straydusk`, `toledocavani`, `embedding-shape`) independently notice the same thing: Vercel's skills top the leaderboard because rankings are based on installs from Vercel's own CLI, and Vercel launched the CLI bundled with their own skills. `embedding-shape` is blunt: "By npm weekly installs (??). Famously good signal for quality. Edit: Not even npm, their own tools download count..." The Vercel team (`andrewqu`, `techwraith`) responds defensively — pointing to docs and claiming their skills are "popularly installed" — but never address the circular bootstrapping problem. This is a land-grab for the package-manager layer of the agent skills ecosystem, dressed up as a neutral community resource.

**4. The fragmentation is real and accelerating**

The thread surfaces at least 5 competing skill directories: skills.sh, claudemarketplaces.com (1900+ skills), skillsmp.com (77K+ indexed from GitHub), skillregistry.io, openskills.space, noriskillsets.dev, plus enact.tools. `dave1010uk` notes there isn't even consensus on *where skills go*: ".agent/skills/, .agents/skills/ and just skills/" — three generic paths before you count agent-specific ones (16+ detected by `add-skill`). This is the early-npm phase where the community simultaneously needs a standard and can't agree on one, complicated by the fact that every agent vendor (Anthropic, Vercel, Google, Cursor) has their own convention.

**5. The "why not just --help" question nobody answered well**

`laborcontract` asks the sharpest question in the thread: for skills that are essentially CLI documentation — why not just have the agent run `tool --help`? The responses are weak: `zbyforgotp` says "the point is for the agent to have an index" (which doesn't explain why a skill is better than a README), and `solumunus` says you can "trim down and contextualise" (which is what any documentation does). The honest answer is that skills bundle *opinionated workflow instructions* along with tool docs — they encode how to use a tool in a particular way, not just what the tool does. But the thread never lands on this, partly because many skills on the leaderboard really *are* just reformatted docs.

**6. Short and opinionated beats long and comprehensive**

`amadeuswoo` names the practical lesson: "I get better luck with shorter, more opinionated skills that front-load the key constraints vs. comprehensive docs that get diluted." `SOLAR_FIELDS` confirms that injection at session start is the most reliable path. `theshrike79` adds that skills with attached scripts (not just markdown) — like code analysis tools using tree-sitter — deliver the most value. The emerging pattern: skills that are *just prose* compete with everything else in the context window and lose. Skills that trigger executable tools or are under ~500 tokens of concentrated instructions actually change behavior.

**7. The curation gap is the real opportunity**

`theahura` gets closest to the actual market need: "I think the 'collect a bunch of random skills' approach just isn't it. You need versioning, linking between skills, an easy install client...basically a full package manager." `m-hodges` hammers on the basics: "Why do none of these 'npm for Skills' document any way to do basic package management things like updates, version-pinning, or even uninstalls?" The leaderboard has 200 entries; skillsmp.com has 77K indexed from GitHub. Nobody is solving quality. `flwi`'s actual success story — running ML evaluation procedures across 5 Claude instances — is buried, while generic "react-best-practices" tops the chart.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Vercel self-promotion via rankings | Strong | Circular: their CLI's installs determine rankings, they launched CLI with their skills bundled |
| No versioning/updates/uninstalls | Medium | `m-hodges` raises valid concern, though the CLI does have `check`/`update`/`remove` commands — poorly documented at the time. No version pinning exists, however. |
| Skills get ignored by LLMs | Strong | Multiple independent reports; the hooks workaround confirms this is a real problem, not user error |
| Just use --help | Medium | Valid for tool-wrapping skills, but misses that the best skills encode workflows, not just tool docs |
| Nix is better for this | Weak-to-Medium | `arianvanp`'s Nix approach is principled but has an audience of ~50 people; doesn't solve the discovery/curation problem |

### What the Thread Misses

- **The training data feedback loop.** If Anthropic and Vercel publish official skills, those skills (and the pattern of using them) enter training data. Future models will be better at using *those specific skills* — creating a winner-take-all dynamic where first-mover skills become self-reinforcing standards regardless of quality.
- **Skills are prompt engineering frozen in amber.** What works for Claude 3.5 Sonnet may actively hurt Claude 4. Nobody discusses skill versioning against *model versions*, only against tool versions. The entire ecosystem assumes stable model behavior, which is false.
- **The labor economics.** Skills are currently written by enthusiasts and companies with distribution motives. There's no mechanism for skill authors to capture value from widely-used skills, which means quality will either come from vendor investment (Anthropic, Vercel) or will stagnate at hobby-project levels.

### Verdict

The thread circles around but never names the core tension: skills are a *distribution format* looking for a *runtime* that doesn't exist yet. The format is simple (markdown files with descriptions), the install tooling is proliferating, and the leaderboard is live — but the models themselves can't reliably decide when to load a skill, which means the entire lazy-loading premise is aspirational. The actual working pattern — hooks that force skill evaluation at session start — is essentially reimplementing system prompts with extra steps. Skills will matter when models can autonomously select and compose them mid-task; until then, the real value accrues to whoever controls the package manager layer, which is exactly what Vercel is positioning for.
