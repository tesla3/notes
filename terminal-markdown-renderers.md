# Terminal Markdown Renderers — Research (Feb 2026)

**Winner: Glow** — installed via `brew install glow` (v2.1.1)

~~MD-TUI was previously installed but removed — Glow is sufficient.~~

---

## Quick Reference

```bash
glow README.md             # render a file
glow                       # TUI file browser
glow -p README.md          # with pager
glow -s "tokyo-night"      # custom theme
glow -w 80                 # word wrap at 80 cols
echo "# Hi" | glow -       # from stdin
glow github.com/user/repo  # fetch remote README
```

---

## All Options Evaluated

### 1. Glow ⭐ (Winner)

- **Repo:** https://github.com/charmbracelet/glow
- **Stats:** 22,849 ★ | Go | MIT | Active (Feb 2026)
- **Install:** `brew install glow`
- **Engine:** Glamour (stylesheet-based MD→ANSI)

**Strengths:**
- Best zero-config experience — pretty output out of the box
- TUI mode (run without args) with file browser
- Auto dark/light theme detection
- File watching — auto-reloads on change
- Custom JSON stylesheets, many built-in themes (Tokyo Night, etc.)
- Fetch from URLs and GitHub repos
- Stdin support, pager support (`-p`), word wrapping (`-w`)
- Massive adoption: GitHub CLI, GitLab CLI, Gitea CLI all use Glamour
- Cross-platform: macOS, Linux, Windows, FreeBSD, Android (termux)

**Known Limitations:**
- Rendering engine (Glamour) has long-standing bugs:
  - Paragraphs inside lists render incorrectly (Glamour #167, since Oct 2021)
  - Blockquote content renders incorrectly (Glamour #79, since Sep 2020)
  - Inline code inside italics loses styling (Glamour #80)
  - Word wrapping broken in some cases (Glamour #451/#452)
  - `<summary>`/`<details>` HTML elements silently dropped
  - Code blocks interrupt numbered lists (Glamour #81)
- No streaming support (buffers entire input via `io.ReadAll`) — bad for LLM piping
- No inline images, no OSC 8 clickable hyperlinks
- Light mode detection breaks in tmux (#877)
- `-w` width flag doesn't work in TUI mode (#878)
- URLs in H1 headings unreadable due to contrast (#455)

---

### 2. mdcat — Best Correctness, But Dead

- **Repo:** https://github.com/swsnr/mdcat
- **Stats:** 2,364 ★ | Rust | MPL-2.0 | **ARCHIVED Jan 2025**
- **Install:** `cargo install mdcat` or release binaries

**Strengths:**
- CommonMark-compliant via `pulldown-cmark`
- Inline images in iTerm2, kitty, WezTerm, Ghostty, VSCode terminal
- OSC 8 clickable hyperlinks
- Jump marks for headings in iTerm2
- Syntax highlighting via `syntect`
- `mdless` symlink for automatic paging

**Limitations:**
- **Project is archived/dead.** Author looking for maintainer.
- No TUI mode — purely `cat`-style
- No tables (CommonMark core doesn't include them)
- No interactivity
- Requires libcurl to build
- Terminal-specific features degrade on basic terminals

---

### 3. MD-TUI (mdt) — Best Navigation, Young Project

- **Repo:** https://github.com/henriklovhaug/md-tui
- **Stats:** 363 ★ | Rust | AGPL-3.0 | Active (Feb 2026)
- **Install:** release binary or `cargo install md-tui --locked`
- **Previously installed at:** `/usr/local/bin/mdt` — **removed** (Glow preferred)

**Strengths:**
- Unique link selection mode — scroll through links, follow to headings/files/URLs
- Full TUI with file browser, search, keyboard-driven navigation
- Image rendering (terminal protocol dependent)
- GFM alerts/admonitions
- Configurable keybindings and colors via `~/.config/mdt/config.toml`
- Neovim plugin available
- Very active development

**Limitations:**
- Custom markdown parser — NOT CommonMark-compliant (author admits this)
- AGPL-3.0 license — restrictive
- Requires Nerd Font (hard dependency)
- Small community (single author, 363 stars)
- Some rendering bugs: corrupted output when not scrolled (#151), code blocks cut off (#142)
- No Windows support
- Only 18 languages for syntax highlighting

---

### 4. Rich / rich-cli — Python Ecosystem

- **Repo:** https://github.com/Textualize/rich (55,511 ★) / rich-cli (3,582 ★)
- **Python | MIT | Maintained (maintenance mode)**

**Strengths:**
- Most popular terminal formatting library in any language
- `python -m rich.markdown README.md` works with zero extra installs
- Streaming markdown actively developed for Textual framework
- Also handles JSON, CSV, syntax highlighting, tracebacks

**Limitations:**
- Python startup time (~300-500ms) vs Go/Rust (~10-50ms)
- No TUI mode in rich-cli
- No inline images
- Loose list rendering bugs (#3916)
- rich-cli is in maintenance-only mode
- Will McGugan focused on Textual/Toad, not Rich

---

### 5. Frogmouth — Abandoned

- **Repo:** https://github.com/textualize/frogmouth (3,059 ★)
- **Last commit: Mar 2024** — effectively dead
- Skip it.

---

### 6. bat — Wrong Category

- Syntax-highlights Markdown **source**, does NOT render it
- Great `cat` replacement, but not a Markdown renderer
- Shows `# Heading`, `**bold**` in color — fundamentally different from rendering

---

### 7. pandoc + w3m — Most Correct, Ugliest

```bash
pandoc -f gfm file.md | w3m -T text/html
```

- Most correct rendering (pandoc is the gold standard for parsing)
- Handles everything: GFM tables, footnotes, math, nested lists, inline HTML
- Two dependencies, no syntax highlighting, 1990s aesthetics
- Slow for large files

---

## Libraries (For Embedding)

| Library | Language | Stars | Use Case |
|---------|----------|-------|----------|
| [Glamour](https://github.com/charmbracelet/glamour) | Go | 3,254 | Powers Glow/GitHub CLI. JSON themes. Has rendering bugs. |
| [Rich](https://rich.readthedocs.io/en/latest/markdown.html) | Python | 55,511 | Best Python option. `from rich.markdown import Markdown` |
| [Termimad](https://github.com/Canop/termimad) | Rust | 1,135 | Templates, table balancing. Not a full MD renderer. 240k dl/month. |
| [marked-terminal](https://github.com/mikaelbr/marked-terminal) | Node.js | ~880 | Customizable. Node.js startup overhead. |
| [Comrak](https://github.com/kivikakk/comrak) | Rust | — | Full CommonMark+GFM parser. Outputs HTML, not ANSI. |

---

## Comparison Matrix

| Feature | Glow | mdcat | MD-TUI | Rich | pandoc+w3m |
|---|---|---|---|---|---|
| **Correct rendering** | ❌ buggy | ✅ CommonMark | ⚠️ custom parser | ⚠️ decent | ✅ best |
| **Pretty output** | ✅ best | ✅ good | ✅ good | ✅ good | ❌ ugly |
| **Fast** | ✅ | ✅ | ✅ | ❌ slow startup | ❌ slow |
| **Maintained** | ✅ | ❌ dead | ✅ active | ⚠️ maintenance | ✅ |
| **TUI mode** | ✅ | ❌ | ✅ | ❌ | ❌ |
| **Inline images** | ❌ | ✅ best | ⚠️ | ❌ | ❌ |
| **Clickable links** | ❌ | ✅ OSC 8 | ✅ | ✅ | ❌ |
| **Streaming** | ❌ | ❌ | ❌ | ✅ (Textual) | ❌ |
| **Syntax highlight** | ✅ | ✅ | ✅ (18 langs) | ✅ | ❌ |
| **Tables** | ✅ | ❌ | ✅ | ✅ | ✅ |
| **Stdin pipe** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Custom themes** | ✅ JSON | ❌ | ✅ TOML | ✅ | ❌ |
| **File watching** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Fetch URLs** | ✅ | ❌ | ❌ | ✅ | ❌ |

---

## Bottom Line

The field is surprisingly immature. No tool is simultaneously correct, pretty, fast,
interactive, and actively maintained. **Glow wins on the balance** of convenience, aesthetics,
ecosystem adoption, and active maintenance — despite its rendering engine having real bugs
on complex Markdown. For daily use viewing READMEs and docs, it's the clear choice.
