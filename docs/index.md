---
title: "Home"
order: 1
description: "NanoBox is a BoxLang-based autonomous agent CLI platform: chat, agents, tools, memory, and messaging gateways from a single binary."
icon: "⚡"
toc: false
---

# NanoBox

NanoBox is a BoxLang-based autonomous agent CLI platform. It gives you a single
`nanobox` command for AI chat, persistent agents, custom tools, MCP servers,
a long-term knowledge vault, and messaging gateways (Telegram, Slack, Discord,
email, and more) -- all backed by SQLite and driven by
[bx-ai](https://boxlang.io).

## Where to start

- **[Getting Started](getting-started/index.md)** -- install NanoBox and run your first chat.
- **[Architecture](architecture/index.md)** -- how the CLI, worker, and web UI fit together.
- **[Reference](reference/index.md)** -- every CLI namespace and subsystem, documented.
- **[Contributing](contributing/index.md)** -- development setup, testing, and coding standards.

## What NanoBox does

| Capability | Description |
|---|---|
| Chat | Interactive REPL or one-shot queries against any configured provider/model |
| Agents | Persistent, markdown-defined agents with tools, memory, and sub-agents |
| Tools | bx-ai built-ins, auto-discovered MCP tools, and custom user tools |
| Vault | A searchable long-term knowledge base (FTS5 + vector search) |
| Gateways | Talk to NanoBox from Telegram, Slack, Discord, Email, WhatsApp, Signal, and SMS |
| Cron | Scheduled agent runs, backups, and security scans on the built-in worker |
| Security | A sandboxed runtime, real-time middleware, and a scheduled threat scanner |

## Three entry points

```
nanobox              # CLI -- terminal interface for all operations
boxlang schedule     # Worker -- gateways, cron, security, and learning (background)
boxlang-miniserver   # Web UI -- ColdBox dashboard + REST API
```

See [Architecture](architecture/index.md) for the full process model and stack layers.
