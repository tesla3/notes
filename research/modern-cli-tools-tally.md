← [Index](../README.md)

# Modern CLI Tools: Comprehensive Tally

*March 2026 · Compiled from GitHub awesome lists, Reddit threads, curated blogs, and community consensus.*

---

## I. Direct Replacements for Classic Unix Commands

### File Listing & Navigation

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **eza** | `ls` | Rust | Icons, colors, Git integration, tree view. Fork of unmaintained `exa`. Community standard. |
| **lsd** | `ls` | Rust | Nerd Font icons, colors. Alternative to eza — pick one. |
| **zoxide** | `cd` | Rust | Learns directory frequency. `z foo` jumps to most-used match. Must-have. |
| **broot** | `tree` / dir navigation | Rust | Interactive tree view, fuzzy search, dir navigation. |
| **yazi** | `ranger` / file managers | Rust | Fast TUI file manager. Vim bindings, image preview, backgrounding. Hot in 2025-26. |
| **lf** | `ranger` | Go | Lighter file manager. Ranger-inspired. |
| **nnn** | file managers | C | Ultra-minimal, zero-config, fast. |
| **xplr** | file managers | Rust | Hackable, minimal TUI file explorer. |
| **tere** | `cd` + `ls` | Rust | Faster alternative to cd+ls combo. |
| **walk** | `cd` / dir navigation | Go | Walk directories interactively. |

### File Viewing & Editing

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **bat** | `cat` | Rust | Syntax highlighting, line numbers, Git-aware. Alias to `cat` safely. |
| **mdcat** | `cat` (markdown) | Rust | Renders markdown in terminal with formatting. |
| **glow** | markdown viewer | Go | Styled markdown rendering with pager. |
| **hexyl** | `xxd` / `hexdump` | Rust | Colored hex viewer. |
| **helix** | `vim` | Rust | Modal editor. Built-in LSP, tree-sitter, fuzzy finder. No plugins needed. |
| **neovim** | `vim` | C/Lua | The modern vim. Extensible via Lua. |
| **micro** | `nano` | Go | Modern, intuitive terminal text editor. |
| **kakoune** | `vim` | C++ | Modal editor, multiple cursors first. |

### Search & Find

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **ripgrep** (`rg`) | `grep` | Rust | Fast recursive search. Respects `.gitignore`. Used inside VS Code. Community consensus #1. |
| **fd** | `find` | Rust | Simpler syntax, faster, respects `.gitignore`. |
| **fzf** | `ctrl+r` / interactive filter | Go | Fuzzy finder for anything — files, history, processes, git commits. Composable. |
| **skim** (`sk`) | `fzf` | Rust | fzf alternative written in Rust. |
| **television** | `fzf` | Rust | Newer fuzzy finder. Neat alternative, gaining traction 2025. |
| **ag** (The Silver Searcher) | `ack` / `grep` | C | Fast code search. Predecessor to ripgrep. |
| **ast-grep** | code search / linting | Rust | Tree-sitter powered structural code search. |
| **fselect** | `find` | Rust | Find files with SQL-like queries. |
| **ripgrep-all** (`rga`) | `grep` (in archives) | Rust | Wraps ripgrep to search PDFs, zips, Office docs, etc. |

### Text Processing

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **sd** | `sed` | Rust | Sane find-and-replace syntax. No escape hell. |
| **choose** | `cut` / `awk` | Rust | Human-friendly field selection. |
| **jq** | JSON processing | C | The standard. Pipe-friendly JSON processor. |
| **yq** | YAML/JSON/XML processing | Go | `jq` but for YAML, JSON, XML, TOML. |
| **dasel** | `jq`/`yq` combined | Go | Single tool for JSON, YAML, TOML, XML, CSV. |
| **fx** | JSON viewing | Go | Interactive JSON viewer. |
| **jless** | JSON viewing | Rust | Command-line JSON viewer/explorer. |
| **gron** | JSON processing | Go | Makes JSON greppable — flattens to assignment statements. |
| **htmlq** | HTML extraction | Rust | Like `jq` but for HTML, using CSS selectors. |
| **xsv** / **qsv** | CSV processing | Rust | Fast CSV toolkit. `qsv` is maintained fork of `xsv`. |
| **csvlens** | CSV viewing | Rust | Interactive CSV viewer in terminal. |
| **miller** (`mlr`) | `awk`/`sed` for structured data | C | CSV/JSON/tabular data Swiss army knife. |
| **grex** | regex writing | Rust | Generates regex from test cases. |
| **sad** | `sed` (interactive) | Rust | Preview-first find-and-replace. Safer batch edits. |

### Diff & Version Control

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **delta** | `diff` / `git diff` | Rust | Syntax-highlighted git diffs. Beautiful. |
| **difftastic** | `diff` | Rust | Syntax-aware structural diff. Understands code, not just lines. |
| **lazygit** | git CLI | Go | TUI for git. Interactive staging, rebasing, log browsing. Very popular. |
| **gitui** | git CLI | Rust | Blazing fast TUI for git. Alternative to lazygit. |
| **tig** | `git log` | C | Text-mode interface for git. |
| **jujutsu** (`jj`) | `git` | Rust | Git-compatible VCS. No index/stage. Detached HEAD by default. Rising fast 2025-26. |
| **git-cliff** | changelog generation | Rust | Auto-generates changelogs from conventional commits. |
| **onefetch** | project info | Rust | Displays Git project info in terminal (like neofetch for repos). |

### System Monitoring & Process Management

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **btop** | `top` / `htop` | C++ | Beautiful resource monitor. CPU, memory, disk, network. |
| **bottom** (`btm`) | `top` / `htop` | Rust | Cross-platform graphical process/system monitor. |
| **glances** | `top` | Python | Eye on your system. Web UI option. |
| **procs** | `ps` | Rust | Modern ps with color, human-readable output. |
| **dust** | `du` | Rust | Intuitive disk usage. Visual bar charts. |
| **duf** | `df` | Go | Disk free with readable, colored table output. |
| **ncdu** | `du` | Zig | Interactive disk usage analyzer. TUI. |
| **dua** (`dua-cli`) | `du` | Rust | Disk usage analyzer. Parallel, fast. Interactive delete option. |
| **gdu** | `du` / `ncdu` | Go | Fast disk usage analyzer. Faster than ncdu. |
| **bandwhich** | network monitoring | Rust | Terminal bandwidth utilization per-process. |
| **gping** | `ping` | Rust | Ping with a graph. |
| **trippy** | `traceroute` + `ping` | Rust | Network diagnostics with TUI visualization. |
| **doggo** | `dig` | Go | Modern DNS client. DoH, DoT, DoQ support. Pretty output. |
| **mtr** | `traceroute` + `ping` | C | Classic combo tool, still relevant. |

### Shell & Prompt

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **fish** | `bash` / `zsh` | Rust (3.x+) | Friendly interactive shell. Autosuggestions, syntax highlighting OOTB. Not POSIX. |
| **nushell** (`nu`) | `bash` / shell | Rust | Structured data shell. Pipelines return tables, not text. |
| **starship** | shell prompts | Rust | Fast, customizable prompt for any shell. Cross-shell. |
| **atuin** | `ctrl+r` / shell history | Rust | Shell history in SQLite. Search by directory, session, host. Sync across machines. |
| **mcfly** | `ctrl+r` / shell history | Rust | Neural-network-ranked history search. Tracks cwd, exit status. |
| **carapace** | tab completion | Go | Multi-shell completion engine. |
| **zsh-autosuggestions** | — | Zsh | Fish-like autosuggestions for zsh. |
| **thefuck** | typo correction | Python | Auto-corrects mistyped commands. |

### Terminal Multiplexers & Emulators

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **zellij** | `tmux` / `screen` | Rust | Modern multiplexer. Discoverable keybindings, plugin system, floating panes. |
| **tmux** | `screen` | C | The classic. Still dominant. |
| **alacritty** | terminal emulators | Rust | GPU-accelerated, cross-platform. Fast. |
| **wezterm** | terminal emulators | Rust | GPU-accelerated, multiplexer built-in. Lua config. |
| **ghostty** | terminal emulators | Zig | Modern, fast. Native platform integration. Hot in 2025-26. |
| **kitty** | terminal emulators | C/Python | GPU-accelerated, image protocol, extensible. |

### HTTP & Networking

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **xh** | `curl` | Rust | Friendly HTTP requests. Colored output, JSON support. |
| **httpie** | `curl` | Python | Human-friendly HTTP client. The original modern curl replacement. |
| **curlie** | `curl` | Go | HTTPie-like syntax, curl-like reliability. |
| **aria2** | `wget` / download managers | C++ | Multi-protocol, multi-source download utility. Resumable. |
| **posting** | API clients (Postman) | Python | TUI API client for the terminal. |
| **hurl** | `curl` (testing) | Rust | Run and test HTTP requests defined in plain text. |
| **oha** | load testing | Rust | HTTP load generator. |
| **miniserve** | `python -m http.server` | Rust | Serve files over HTTP from CLI. |

### Docs & Help

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **tldr** / **tealdeer** | `man` | Varies/Rust | Community-maintained simplified man pages with examples. `tealdeer` is the fast Rust client. |
| **navi** | cheat sheets | Rust | Interactive cheat sheet navigator. |
| **cheat** | `man` | Go | Personal cheat sheets for commands. |

### Compression & File Operations

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **ouch** | `tar`/`zip`/`gzip` | Rust | Painless compression/decompression. Auto-detects format. No flag memorization. |
| **rip** | `rm` | Rust | Safe rm — moves to graveyard instead of deleting. |
| **trash-cli** | `rm` | JS | Move to trash instead of permanent delete. |
| **xcp** | `cp` | Rust | Extended cp with progress bars. |

### Task Running & Automation

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **just** | `make` | Rust | Command runner. Sane syntax, no tab issues, great error messages. |
| **watchexec** | `inotifywait` / file watchers | Rust | Run commands on file changes. |
| **entr** | file watchers | C | Run arbitrary commands when files change. Lightweight. |
| **topgrade** | system updater | Rust | Detects all package managers, upgrades everything. |
| **mise** | `nvm`/`pyenv`/`rbenv` | Rust | Universal runtime/version manager. Also handles env vars per directory. |

### Benchmarking & Code Metrics

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **hyperfine** | `time` | Rust | Statistical benchmarking. Multiple runs, warmup, export. |
| **tokei** | `cloc` / `wc -l` | Rust | Fast lines-of-code counter by language. |
| **scc** | `cloc` | Go | Lines of code with complexity and cost estimates. Very fast. |

### Dotfiles & System Info

| Tool | Replaces | Language | Notes |
|------|----------|----------|-------|
| **chezmoi** | dotfile management | Go | Manage dotfiles across machines. Templating, encryption. |
| **fastfetch** | `neofetch` | C | System info display. Fast. Active replacement for unmaintained neofetch. |
| **macchina** | `neofetch` | Rust | Minimal, customizable system info. |

### Git-Aware Colors

| Tool | What It Does | Language |
|------|-------------|----------|
| **vivid** | LS_COLORS generator | Rust | Generates themed `LS_COLORS` for file type coloring. |
| **pastel** | Color manipulation | Rust | Generate, analyze, convert colors from CLI. |

---

## II. Notably New / Rising (2025–2026)

| Tool | Category | Why Notable |
|------|----------|-------------|
| **television** | Fuzzy finder | Newer fzf alternative, gaining traction |
| **yazi** | File manager | Fastest TUI file manager, hot in the community |
| **jujutsu** (`jj`) | VCS | Git-compatible, radically simpler model. Serious momentum |
| **ghostty** | Terminal emulator | Zig-based, fast, modern. By Mitchell Hashimoto |
| **atuin** | Shell history | SQLite-backed, cross-machine sync. Rapidly adopted |
| **mise** | Runtime manager | Replacing asdf, nvm, pyenv in one tool |
| **nushell** | Shell | Structured data pipelines. Growing community |
| **sad** | Find-and-replace | Preview-first workflow. Safer than sed |
| **ast-grep** | Code search | Tree-sitter structural search. Powerful for refactoring |
| **biff** | Date/time swiss knife | Tagged data pipelines for datetime manipulation |

---

## III. Community Consensus: The "Must Install" Tier

Based on frequency of mentions across Reddit threads, blog posts, and dotfiles repos (2024-2026):

**Tier 1 — Install everywhere** (mentioned by nearly everyone):
- `ripgrep` (`rg`), `fd`, `bat`, `eza`, `fzf`, `zoxide`, `delta`, `starship`

**Tier 2 — Very popular, install if relevant**:
- `lazygit`, `atuin`, `dust`, `jq`, `tldr`/`tealdeer`, `hyperfine`, `just`, `btop`

**Tier 3 — Power user favorites**:
- `sd`, `procs`, `yazi`, `zellij`, `helix`, `difftastic`, `tokei`, `xh`, `duf`, `ouch`

**Tier 4 — Niche but loved**:
- `nushell`, `jujutsu`, `grex`, `pastel`, `hexyl`, `bandwhich`, `gping`, `vivid`, `csvlens`

---

## IV. The Yazelix Stack (Terminal IDE Pattern)

An emerging pattern combining tools into a terminal IDE:

```
Yazi (file manager) + Zellij (multiplexer) + Helix (editor) = Yazelix
+ fzf/television (fuzzy finding)
+ zoxide (navigation)
+ starship (prompt)
+ lazygit (git)
+ atuin (history)
+ ripgrep + fd (search)
```

This is the 2025-26 alternative to VS Code / Cursor for terminal-native developers.

---

## Sources

| Source | Type |
|--------|------|
| [github.com/ibraheemdev/modern-unix](https://github.com/ibraheemdev/modern-unix) | Curated list (canonical) |
| [Rust CLI utilities gist (sts10)](https://gist.github.com/sts10/daadbc2f403bdffad1b6d33aff016c0a) | Curated list |
| [r/rust "top 5 CLI tools 2025"](https://www.reddit.com/r/rust/comments/1m4obxf/) | Community poll |
| [r/rust "Looking for shiny new UNIX tools"](https://www.reddit.com/r/rust/comments/1o0cie9/) | Community discussion |
| [pashynskykh.com/articles/cli-tools](https://www.pashynskykh.com/articles/cli-tools/) | Maintained list (updated Feb 2026) |
| [awesome-cli-apps (agarrharr)](https://github.com/agarrharr/awesome-cli-apps) | Comprehensive curated list |
| [dev.to/lissy93 "CLI tools you can't live without"](https://dev.to/lissy93/cli-tools-you-cant-live-without-57f6) | Blog (50 tools) |
| [blog.ayjc.net "Modern CLI 2026"](https://blog.ayjc.net/posts/modern-cli-2026/) | Blog (Feb 2026) |
| [blog.raylu.net "New CLI Tools"](https://blog.raylu.net/2025/07/07/cli_tools.html) | Blog (Jul 2025) |
| [Yazelix](https://github.com/luccahuguet/yazelix) | Terminal IDE integration |
