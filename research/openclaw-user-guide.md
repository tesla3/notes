← [OpenClaw Architecture](openclaw-architecture.md) · [Index](../README.md)

# OpenClaw — User Guide for Non-Technical Users

## What Is OpenClaw?

OpenClaw is a **personal AI assistant** that you run on your own computer. You message it through apps you already use — WhatsApp, Telegram, iMessage, Discord, Slack, Signal, and others — and it replies right there in the conversation, just like texting a friend who happens to be very smart.

It can also answer you through a simple web page in your browser, speak to you on a Mac or phone, and do things on your computer like look up information or manage files.

The mascot is a space lobster named **Molty**. 🦞

### How is this different from ChatGPT?

- **ChatGPT** lives on OpenAI's website. You go to it. **OpenClaw** comes to you — it answers in your existing chat apps.
- **ChatGPT** is a standalone tool. **OpenClaw** can also run tasks on your computer, browse the web, and work on a schedule.
- **Conversation history** is stored on your computer, not on someone else's server.

### What's the catch?

Be upfront with yourself about these tradeoffs:

- **Your messages are still sent to an AI provider** (Anthropic or OpenAI) for processing. The AI company sees what you send. What stays local is the conversation *log* — the saved record of your chats.
- **Your computer must stay on** for the assistant to work. If your Mac sleeps or you shut down your PC, the assistant goes offline on all your chat apps until the computer wakes up again.
- **It requires some Terminal use.** Installation and occasional maintenance involve typing commands. The guide walks you through it, but this isn't a pure point-and-click experience.
- **The assistant has powerful access to your computer.** In your direct chat with it, it can read files, run commands, and make changes on your machine. This is what makes it useful — but also means you should understand the security model (covered below).

---

## What Can It Do?

### Works out of the box

- **Answer questions and have conversations** — anything you'd ask ChatGPT
- **Understand images** — send a photo and ask "what's in this picture?"
- **Understand voice messages** — send an audio clip and it transcribes and responds
- **Understand video** — send a short clip and ask questions about it

### Works if browser control is enabled

These features require browser control (the wizard offers to enable it during setup):

- **Browse the web** — "look up flights to Tokyo next week"
- **Read articles** — "summarize this article" (paste a URL)
- **Fill out forms** — interact with websites on your behalf
- **Check real-time information** — weather, news, prices (the AI has no live data on its own)

### Works if scheduled tasks are configured

- **Recurring tasks** — "check my email every morning at 8am" or "summarize the news daily"
- **Reminders** — "remind me about my medication at 9am and 9pm"

> **Important:** Scheduled tasks only run while your computer is on and the Gateway is running. If your Mac is asleep at 8am, the 8am task won't fire.

### Works with companion apps (advanced)

These require the macOS, iOS, or Android companion apps (see "Companion Apps" below):

- **Voice conversations** — talk to the assistant out loud, it speaks back
- **"Hey Molty" wake word** — hands-free activation
- **Visual Canvas** — interactive charts, mini-apps, visual explanations
- **Phone camera** — assistant can snap photos or record your screen

---

## What It Costs

OpenClaw itself is **free and open source**. You pay for the AI brain that powers it:

| What | Cost | Required? |
|---|---|---|
| **OpenClaw** | Free | Yes |
| **AI subscription** (Anthropic or OpenAI) | $20–$200/month | Yes — need at least one |
| **ElevenLabs** (for voice replies) | ~$5–$22/month | Only if you want Talk Mode |
| **Computer running 24/7** | Your electricity bill | Only if you want always-on availability |

**Anthropic Claude Pro ($20/month) or Max ($100–$200/month)** is recommended. It handles complex tasks and long conversations better than alternatives.

**Alternative: API keys.** Instead of a monthly subscription, you can use pay-per-use API keys from Anthropic or OpenAI. You're charged per message based on length. This can be cheaper if you use it lightly, more expensive if you use it heavily. The wizard supports both options.

---

## What You Need Before Starting

### Required

1. **A Mac or Linux computer** (Windows works too, but requires WSL2 — a one-time setup that needs a tech-savvy friend to help with)

2. **Node.js version 22 or newer** — this is the engine that runs OpenClaw.
   - Go to [nodejs.org](https://nodejs.org)
   - Click the big green **"LTS"** button (not "Current")
   - Download and run the installer for your system
   - To verify it worked, open Terminal and type `node --version` — you should see a number like `v22.x.x`

3. **An Anthropic or OpenAI account** — the wizard will guide you through connecting it

### Optional

- **Chrome or Chromium browser** — needed for browser control features
- **Companion apps** — for voice mode and canvas (see "Companion Apps" section)

---

## Installation — Step by Step

### Step 1: Open Terminal

- **Mac:** Press Cmd+Space, type "Terminal", hit Enter
- **Linux:** Open your terminal emulator (usually Ctrl+Alt+T)
- **Windows:** Open your WSL terminal

### Step 2: Install OpenClaw

Type this and press Enter:

```
npm install -g openclaw@latest
```

This downloads and installs OpenClaw. It takes 1–5 minutes depending on your internet speed.

**If you see errors** about "sharp" or "node-pty" failing to build, try:
```
npm install -g openclaw@latest --ignore-scripts
```
Then run `openclaw doctor` to check if anything critical is missing. If you're stuck, the [Discord community](https://discord.gg/clawd) is very helpful with install issues.

**If you see "npm: command not found"**, Node.js isn't installed or isn't on your PATH. Go back to the Node.js step above.

### Step 3: Run the Onboarding Wizard

```
openclaw onboard --install-daemon
```

The wizard walks you through everything interactively:

1. **AI model setup** — it opens a link in your browser to log in to Anthropic or OpenAI. Sign in, and the wizard picks up the connection automatically.
2. **Workspace setup** — creates a folder where the assistant keeps its notes.
3. **Channel setup** — connects your messaging apps. For WhatsApp, you scan a QR code (just like WhatsApp Web). For Telegram or Discord, you paste in a bot token (the wizard explains how).
4. **Browser control** — optionally enables web browsing (recommended — many useful features depend on it).
5. **Background service** — the `--install-daemon` part sets the assistant to start automatically when your computer boots. Without this, you'd have to start it manually each time.

> **Tip:** If you just want to try it out quickly, skip all the channel setup and use **WebChat** first (see next section). You can add WhatsApp, Telegram, etc. later by running `openclaw onboard` again.

**If the wizard fails partway through**, you can safely re-run `openclaw onboard` — it picks up where it left off.

### Step 4: Try It Out

The fastest way to talk to your assistant — no channel setup needed:

1. Open your web browser
2. Go to **http://localhost:18789**
3. You'll see the **Control UI** — OpenClaw's web dashboard
4. Click **WebChat** to open a chat window
5. Type a message and hit Send

That's it. You're talking to your assistant. WebChat works immediately — no QR codes, no bot tokens, no extra apps.

---

## The Control UI (Web Dashboard)

OpenClaw includes a **web dashboard** you can open in any browser at:

```
http://localhost:18789
```

From here you can:

- **Chat via WebChat** — talk to your assistant in the browser
- **See connected channels** — which chat apps are online
- **View active sessions** — all ongoing conversations
- **Check system health** — is everything running properly?

This is the easiest way to manage OpenClaw without using Terminal commands. Bookmark it.

---

## Daily Usage

### Talking to Your Assistant

**Send a message** in any connected chat app (or WebChat). That's it. Type a question, send a photo, send a voice message — the assistant responds right in the conversation.

**Setting expectations on speed:** Simple questions get a reply in a few seconds. Complex tasks (browsing the web, writing code, working with files) can take 30 seconds to a minute or more. You'll see a typing indicator while it works.

### Chat Commands

Type these as messages in any connected chat. They control the assistant's behavior:

| Command | What It Does |
|---|---|
| `/status` | Shows current AI model, memory usage, and session info |
| `/new` or `/reset` | Starts a fresh conversation (clears memory of this chat) |
| `/compact` | Summarizes conversation history to free up memory without losing context |
| `/think high` | Deep thinking mode — slower but better for complex problems |
| `/think off` | Back to normal speed |
| `/verbose on` | Shows detailed info about what the assistant is doing |
| `/verbose off` | Concise replies (default) |
| `/usage full` | Shows token count and cost after each reply |
| `/restart` | Restarts the Gateway (owner-only) |

### Using It in Group Chats

OpenClaw can participate in group chats. By default, it only responds when you **@mention it** (e.g., "@Molty what do you think?"). This prevents it from replying to every message.

**Note:** Group chats usually need to be allowlisted in the configuration before the assistant will respond. The onboarding wizard can set this up, or see the [group docs](https://docs.openclaw.ai/concepts/groups).

Toggle group behavior:
```
/activation always    — respond to every message
/activation mention   — respond only when mentioned (default)
```

---

## Connecting Chat Apps (Channels)

### WebChat (Easiest — no setup needed)

Open **http://localhost:18789** in your browser and click WebChat. Works immediately after installation. Best starting point.

### WhatsApp

The wizard handles this during onboarding. To reconnect later:

```
openclaw channels login
```

It shows a QR code in your Terminal. Open WhatsApp on your phone → Settings → Linked Devices → Link a Device → scan the QR code.

**Good to know:**
- By default, strangers who message your bot get a pairing code. They can't use it unless you approve them (see Security section).
- WhatsApp integration uses an unofficial library (Baileys). While widely used and generally reliable, there is a small risk that WhatsApp could flag your account. Most users have no issues, but it's worth knowing.

### Telegram

1. Open Telegram and message **@BotFather**
2. Send `/newbot` and follow his instructions to name your bot
3. BotFather gives you a **bot token** (a long string of numbers and letters)
4. Paste the token into the onboarding wizard, or set it in config

Your bot appears as a separate Telegram contact. Message it to talk to your assistant.

### Discord

Setting up a Discord bot involves several steps on the [Discord Developer Portal](https://discord.com/developers/applications). The process takes 10–15 minutes:

1. Create a new Application
2. Go to the Bot section, create a bot, and copy the **bot token**
3. Under Privileged Gateway Intents, enable **Message Content Intent**
4. Go to OAuth2 → URL Generator, select `bot` scope and the permissions your bot needs (at minimum: Send Messages, Read Message History)
5. Open the generated URL to invite the bot to your server
6. Paste the bot token into the onboarding wizard or your config

The [official Discord channel docs](https://docs.openclaw.ai/channels/discord) have step-by-step screenshots.

### iMessage (Mac only)

iMessage integration uses **BlueBubbles**, a free app. The catch: BlueBubbles itself runs as a server on a Mac that stays on and is signed into Messages. If you already have a Mac running 24/7 (as your Gateway host), this works naturally. Otherwise it means dedicating a Mac to this purpose.

Setup: [BlueBubbles docs](https://docs.openclaw.ai/channels/bluebubbles)

### Slack

Slack requires creating a Slack App with specific OAuth scopes and Socket Mode enabled. It's a multi-step process:

1. Create an app at [api.slack.com/apps](https://api.slack.com/apps)
2. Enable Socket Mode and get an App-Level Token
3. Configure bot scopes (chat:write, channels:history, etc.)
4. Install the app to your workspace and get the Bot Token
5. Add both tokens to your config

Full guide: [Slack channel docs](https://docs.openclaw.ai/channels/slack)

### Others (Signal, Microsoft Teams, Matrix, Google Chat…)

Each platform has its own setup requirements. See the [channel docs](https://docs.openclaw.ai/channels) for step-by-step guides. The onboarding wizard (`openclaw onboard`) can also walk you through the most common ones.

---

## Personalizing Your Assistant

You can customize how your assistant behaves by editing text files in its workspace folder (`~/.openclaw/workspace/`):

### SOUL.md — Personality and Identity

This file defines who your assistant *is*. Edit it to change personality, name, language, or tone:

- "You are a concise, professional assistant. Never use emoji."
- "You are a friendly cooking coach. Always suggest recipes when relevant."
- "Respond in Spanish unless the user writes in another language."
- "Your name is Jarvis."

### AGENTS.md — Instructions and Rules

This file defines what the assistant should *do* and how it should work. Add project-specific instructions, preferred tools, or behavioral rules.

### How to edit these files

Open them in any text editor:
- **Mac:** `open ~/.openclaw/workspace/SOUL.md` (opens in TextEdit)
- **Any system:** `nano ~/.openclaw/workspace/SOUL.md` (edit in Terminal)

Changes take effect on the next message — no restart needed.

---

## Security & Privacy — Read This

### What stays local, what doesn't

| What | Where It Goes |
|---|---|
| Conversation logs (saved history) | Your computer (`~/.openclaw/`) |
| Your configuration and credentials | Your computer (`~/.openclaw/`) |
| Each message you send for a reply | Anthropic or OpenAI servers (for AI processing) |
| WhatsApp messages | Meta's servers (that's how WhatsApp works) |
| Telegram messages | Telegram's servers |
| Other channel messages | That channel's servers |

**Bottom line:** OpenClaw doesn't have its own servers. But your messages travel through the AI provider and through whichever messaging platform you're using. The conversation *log* stays on your machine.

### The assistant has full access to your computer

In your direct (1:1) chat, the assistant can:
- Read any file on your computer
- Run any command in the terminal
- Create, edit, and delete files
- Install software
- Control a web browser

**This is by design** — it's what makes it a powerful assistant rather than just a chatbot. But it means you should treat it like giving someone remote access to your machine.

**Safety defaults:**
- Only **you** (approved senders) can trigger these capabilities
- Group chats and unapproved users can optionally run in a **sandbox** (isolated Docker container) with limited access
- The pairing system prevents strangers from using your bot

### Who can message your assistant?

By default, **DM pairing** is on: if an unknown person messages your bot, they receive a short code and the assistant ignores them. You approve people like this:

```
openclaw pairing approve whatsapp ABC123
```

To check your security setup:
```
openclaw doctor
```

---

## Voice Mode

### What you need

- A **companion app** (macOS, iOS, or Android — see below)
- An **ElevenLabs account** for natural voice replies (~$5–$22/month, [elevenlabs.io](https://elevenlabs.io))
- Voice features are configured during onboarding or in the config file

### How it works

- **"Hey Molty"** (Voice Wake) — say the wake word and start talking. The assistant listens, processes, and speaks its reply through your speaker.
- **Talk Mode** — press a button to start a continuous voice conversation. Push-to-talk or hands-free.

Without ElevenLabs, the assistant can still listen (voice-to-text), but its replies will be text-only.

---

## The Canvas

The Canvas is a visual workspace your assistant can control — like a screen it can draw on. Ask it to:

- "Show me a chart of my monthly expenses"
- "Build a simple timer app"
- "Create a visual explanation of how solar panels work"

The assistant generates interactive HTML content and pushes it to the Canvas. You see it in the macOS app, iOS app, or Android app.

**To try it:** Send your assistant a message like "Create a canvas with a simple calculator" (requires a companion app to view).

---

## Browser Control

When browser control is enabled, the assistant can open a dedicated Chrome/Chromium window and interact with websites. It won't touch your personal browser or bookmarks.

**To enable:** The onboarding wizard offers this. Or add to your config:
```json
{ "browser": { "enabled": true } }
```

**Requires:** Chrome or Chromium installed on your machine.

---

## Companion Apps (macOS, iOS, Android)

The companion apps add voice, canvas, and device features (camera, screen recording).

### Current availability

As of early 2026, companion apps are primarily **built from source** — this means you need Xcode (Mac/iOS) or Android Studio (Android) to compile them yourself. This is a developer-level task.

- **macOS app:** May also be available as a downloadable `.dmg` from [GitHub releases](https://github.com/openclaw/openclaw/releases). Check there first.
- **iOS / Android:** Build from source only. Requires developer tools.

If you're not comfortable building apps from source code, you can skip companion apps entirely. WebChat, messaging channels, and all text-based features work without them.

---

## Your Computer Must Stay On

This is the most important operational reality: **OpenClaw runs on your computer.** If your computer is off or asleep:

- The assistant doesn't respond on any channel
- Scheduled tasks don't fire
- Messages sent to your bot queue up and arrive when the Gateway restarts

### Options for always-on availability

1. **Keep your Mac/PC awake** — adjust Energy Saver / Power settings to prevent sleep. Simple but uses electricity.
2. **Run on a small Linux server** — a $5–10/month cloud server (DigitalOcean, Hetzner, Fly.io) runs the Gateway 24/7. Your phone and Mac can still connect as nodes for voice and camera. See [remote access docs](https://docs.openclaw.ai/gateway/remote).
3. **Accept downtime** — if you mainly chat during the day while your computer is on, this is fine. Queued messages arrive when you wake up.

---

## Limitations and Expectations

Be realistic about what OpenClaw can and can't do:

- **It's single-user.** Designed for you personally. Not a family assistant or team bot (though others can message it if you approve them — they each get isolated sessions).
- **AI still hallucinates.** It will occasionally make things up confidently. Verify important facts.
- **Long conversations lose context.** After extensive back-and-forth, older messages get summarized (compacted) to fit the AI's context window. Use `/compact` proactively, or `/new` to start fresh.
- **Rate limits apply.** Your AI provider (Anthropic/OpenAI) limits how many messages you can send per hour/day, especially on cheaper plans. If you hit limits, the assistant will tell you.
- **Complex tasks take time.** Browsing the web, running multi-step tasks, or working with large files can take 30–60+ seconds.
- **Channel-specific quirks.** Message formatting looks slightly different across WhatsApp vs Telegram vs Discord. Long replies get split into chunks. Some channels support reactions and buttons, others don't.

---

## Backing Up Your Data

Everything lives in **`~/.openclaw/`** on your computer:

- `~/.openclaw/openclaw.json` — your configuration
- `~/.openclaw/credentials/` — channel login credentials (WhatsApp session, tokens)
- `~/.openclaw/agents/` — conversation history and session data
- `~/.openclaw/workspace/` — your SOUL.md, AGENTS.md, skills

**Back this folder up regularly.** If your disk dies, you lose everything — conversations, config, credentials, and channel sessions (you'd need to re-scan QR codes, re-enter tokens, etc.).

Quick backup:
```
cp -r ~/.openclaw ~/openclaw-backup-$(date +%Y%m%d)
```

---

## Troubleshooting

### "The assistant isn't responding"

1. **Is the Gateway running?** Open http://localhost:18789 in your browser. If the page loads, the Gateway is up. If it doesn't:
   ```
   openclaw gateway --port 18789
   ```

2. **Is the channel connected?** Check the Control UI dashboard, or run:
   ```
   openclaw channels status
   ```

3. **Did your AI credits run out?** Check your Anthropic or OpenAI account for billing/usage limits.

### "WhatsApp disconnected"

This happens occasionally (phone restarts, WhatsApp updates). Reconnect:
```
openclaw channels login
```
Scan the QR code again from your phone.

### "Replies are very slow"

- Check `/status` — if you're in `/think high` mode, switch back: `/think off`
- Your AI provider may be under heavy load. Try again in a few minutes.
- Complex tasks (browsing, file operations) naturally take longer than simple Q&A.

### "I'm getting rate-limited"

Your AI subscription has usage limits. Options:
- Wait for the limit to reset (usually hourly or daily)
- Upgrade your subscription tier
- Use `/compact` to reduce token usage in long conversations

### "Something feels broken"

Run the doctor:
```
openclaw doctor
```
It scans your entire setup and suggests fixes.

### Getting Help

- **Official docs:** [docs.openclaw.ai](https://docs.openclaw.ai)
- **Community Discord:** [discord.gg/clawd](https://discord.gg/clawd) — active community, very helpful with setup issues
- **FAQ:** [docs.openclaw.ai/start/faq](https://docs.openclaw.ai/start/faq)

---

## Updating OpenClaw

```
npm install -g openclaw@latest
```

The daemon automatically restarts after an update. Then run:
```
openclaw doctor
```

This checks for any configuration changes needed by the new version.

---

## Stopping or Uninstalling

### Stop the assistant temporarily

```
openclaw gateway stop
```

### Remove the background service

```
openclaw daemon uninstall
```

### Uninstall completely

```
npm uninstall -g openclaw
```

Your data stays in `~/.openclaw/` until you delete it manually:
```
rm -rf ~/.openclaw
```

---

## Glossary

| Term | What It Means |
|---|---|
| **Terminal** | The text-based command window on your computer (Mac: Terminal.app, Linux: terminal emulator) |
| **Gateway** | The "brain server" running on your computer. Everything connects to it. Accessible at http://localhost:18789 |
| **Channel** | A messaging app connected to your assistant (WhatsApp, Telegram, Discord, etc.) |
| **WebChat** | Chat with your assistant in a web browser — no messaging app needed |
| **Control UI** | The web dashboard at http://localhost:18789 for managing OpenClaw |
| **Session** | A conversation thread. Each chat gets its own session with separate memory. |
| **Node** | A connected device (iPhone, Android, Mac) that can take photos, record screen, play voice |
| **Skill** | An add-on ability for the assistant (like a plugin). Some are built in, others you install from ClawHub. |
| **Canvas** | A visual workspace the assistant can draw on (in companion apps) |
| **Model** | The AI brain powering the assistant (e.g., Claude Opus 4.6). Different models have different strengths. |
| **Daemon** | A background process that keeps the Gateway running even when Terminal is closed |
| **Allowlist** | The list of people approved to message your assistant |
| **Pairing** | The approval process for new people to use your assistant |
| **Compaction** | When the assistant summarizes old conversation to free up memory |
| **Talk Mode** | Voice conversation mode (requires companion app + ElevenLabs) |
| **Voice Wake** | "Hey Molty" — hands-free activation (requires companion app) |
| **API key** | A secret password-like code that lets OpenClaw connect to an AI provider |
| **Token** | A unit of text the AI processes. Longer messages = more tokens = more cost. |
| **Config file** | `~/.openclaw/openclaw.json` — the settings file where all configuration lives |
| **ClawHub** | A marketplace for skills you can add to your assistant (clawhub.com) |

---

## Quick Reference Card

```
INSTALL & SETUP
  npm install -g openclaw@latest
  openclaw onboard --install-daemon

DAILY USE
  http://localhost:18789          — web dashboard + WebChat
  openclaw channels status        — check channel connections
  openclaw doctor                 — health check + fix suggestions

MAINTENANCE
  npm install -g openclaw@latest  — update to latest version
  openclaw doctor                 — run after every update
  cp -r ~/.openclaw ~/backup      — back up your data

STOPPING
  openclaw gateway stop           — stop the assistant
  openclaw daemon uninstall       — remove background service
  npm uninstall -g openclaw       — uninstall

CHAT COMMANDS (type in any connected chat)
  /status           — model + memory info
  /new or /reset    — fresh conversation
  /compact          — summarize to save memory
  /think high       — deep thinking (slower, better)
  /think off        — normal speed
  /verbose on|off   — detail level
  /usage full       — show cost per reply
  /restart          — restart Gateway
```
