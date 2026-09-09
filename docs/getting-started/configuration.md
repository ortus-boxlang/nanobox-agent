---
title: "Configuration"
order: 4
description: "Provider API keys, the runtime config files, and the config CLI namespace."
icon: "⚙️"
---

# Configuration

## Provider API keys

NanoBox reads provider credentials from environment variables. Copy
`.env.example` to `.env` and fill in the keys you need:

```bash
cp .env.example .env
```

```dotenv
BOXLANG_CONFIG=./config/boxlang.json

OPENAI_API_KEY=your-api-key
DEEPSEEK_API_KEY=your-api-key
GEMINI_API_KEY=your-api-key
GROK_API_KEY=your-api-key
GROQ_API_KEY=your-api-key
PERPLEXITY_API_KEY=your-api-key
CLAUDE_API_KEY=your-api-key
OPENROUTER_API_KEY=your-api-key
MISTRAL_API_KEY=your-api-key
HUGGINGFACE_API_KEY=your-api-key
VOYAGE_API_KEY=your-api-key
COHERE_API_KEY=your-api-key

AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
AWS_SESSION_TOKEN=your-session-token  # Only needed with AWS SSO
AWS_REGION=your-test-region
```

You only need to set the keys for the providers you plan to use.

## The `config` CLI namespace

```bash
nanobox config show [--json]           # Show current config
nanobox config get <key>               # Get a config value
nanobox config set <key> <value>       # Set a config value
nanobox config unset <key>             # Remove a config value

nanobox config provider list           # List providers
nanobox config provider set <name>     # Set default provider
nanobox config provider add <name>     # Add a provider

nanobox config model list              # List models
nanobox config model set <model>       # Set default model
```

See [Config](../reference/cli/config.md) and
[Providers and Named Models](../reference/cli/models.md) for the full reference.

## Runtime config files

| File | Purpose |
|---|---|
| `config/boxlang.json` | BoxLang compiler config -- mappings, module paths, the `nanobox` SQLite datasource |
| `config/nanobox.json` | Default NanoBox config -- security, web UI, worker, cron, sessions, and TUI settings |

`config/nanobox.json` covers the platform defaults:

```json
{
  "nanobox": {
    "security": { "enabled": true, "autoDisable": true },
    "web": { "enabled": true, "host": "127.0.0.1", "port": 8080 },
    "worker": { "enabled": true, "debug": false },
    "cron": { "enabled": true, "maxJobs": 50 },
    "sessions": { "maxSessions": 1000, "enabled": true, "pruneAfterDays": 90 },
    "tui": { "theme": "boxlang", "streaming": true, "wordWrap": true }
  },
  "bx-ai": {
    "defaultModel": "",
    "defaultProvider": "",
    "providers": {}
  }
}
```

User-level configuration (set via `nanobox config set` or the setup wizard)
lives under `~/.nanobox/config/` and is never touched by updates -- see
[Architecture](../architecture/index.md) for the full directory layout.
