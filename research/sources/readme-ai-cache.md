# Source: Pi AI README.md — Cache Retention Section
# Package: @mariozechner/pi-ai v0.52.12
# URL: https://github.com/badlogic/pi-mono/blob/main/packages/ai/README.md (lines ~934-943)
# Retrieved: 2026-02-17

## Cache Retention Table

| Provider  | Default    | With PI_CACHE_RETENTION=long |
|-----------|------------|------------------------------|
| Anthropic | 5 minutes  | 1 hour                       |
| OpenAI    | in-memory  | 24 hours                     |

> "This only affects direct API calls to api.anthropic.com and api.openai.com. Proxies and other providers are unaffected."

> "Extended cache retention may increase costs for Anthropic (cache writes are charged at a higher rate). OpenAI's 24h retention has no additional cost."

## Source: CHANGELOG entries

From packages/ai/CHANGELOG.md:
> "Added PI_CACHE_RETENTION environment variable to control cache TTL for Anthropic (5m vs 1h) and OpenAI (in-memory vs 24h). Set to `long` for extended retention. Only applies to direct API calls (api.anthropic.com, api.openai.com). (#967)"

From packages/coding-agent/CHANGELOG.md:
> "Extended prompt caching: PI_CACHE_RETENTION=long enables 1-hour caching for Anthropic (vs 5min default) and 24-hour for OpenAI (vs in-memory default). Only applies to direct API calls."
