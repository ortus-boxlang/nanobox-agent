---
title: "Backup"
order: 10
description: "What NanoBox backs up, on what schedule, the backup CLI, and retention policy."
icon: "💾"
---

# Backup

NanoBox automatically backs up user data on a configurable schedule (default: daily at 4 AM).

## What's Backed Up

| Path | Why |
|------|-----|
| `config/` | User configuration |
| `agents/` | Agent definitions |
| `tools/` | Custom tools |
| `mcp-servers/` | MCP registry |
| `user-scripts/` | Scripts |
| `skills/` | Skills |
| `vault/` | Knowledge base |
| `memory.db` | Sessions + facts + tokens |
| `.env` | Secrets (encrypted if remote) |

## CLI

```bash
nanobox backup run              # Run backup now
nanobox backup list             # Available backups
nanobox backup restore 2026-07-14_04-00-01  # Restore
nanobox backup status           # Last backup info
```

## Retention

| Backup Type | Retention |
|-------------|-----------|
| Daily | 7 days |
| Weekly | 4 weeks |
| Monthly | 3 months |
