---
title: "CLI Reference"
order: 1
description: "Full command reference for the nanobox CLI, organized by namespace, with global flags."
icon: "⌨️"
---

# CLI Reference

## Usage

```
nanobox <command> [options]
```

## Global Flags

| Flag | Description |
|------|-------------|
| `--help`, `-h` | Show help |
| `--version`, `-v` | Show version |
| `--debug` | Enable debug output |
| `--json` | JSON output (where supported) |

## Commands

### Server Lifecycle

| Command | Description |
|---------|-------------|
| `start` | Start web UI + worker |
| `stop` | Stop web UI + worker |
| `status [--json]` | Show running processes |
| `restart` | Restart both processes |

### Subprocess Control

| Command | Description |
|---------|-------------|
| `web start [--port=] [--debug]` | Start web UI only |
| `web stop` | Stop web UI only |
| `web status [--json]` | Web UI status |
| `worker start [--debug]` | Start worker only |
| `worker stop` | Stop worker only |
| `worker status [--json]` | Worker status |

### AI Chat

| Command | Description |
|---------|-------------|
| `chat` | Interactive chat session |
| `chat -q "query"` | One-shot query |
| `chat --agent=researcher` | Use specific agent |
| `chat --model=gpt-4o` | Override model |
| `chat --session=<id>` | Resume existing session |

### Configuration

| Command | Description |
|---------|-------------|
| `config show [--json]` | Show current config |
| `config get <key>` | Get config value |
| `config set <key> <value>` | Set config value |
| `config unset <key>` | Remove config value |
| `config provider list` | List providers |
| `config provider set <name>` | Set default provider |
| `config provider add <name>` | Add provider |
| `config model list` | List models |
| `config model set <model>` | Set default model |

### Sessions

| Command | Description |
|---------|-------------|
| `session list [--limit=N]` | Recent sessions |
| `session show <id>` | Session transcript |
| `session search <query>` | Search sessions |
| `session prune [--older-than=N]` | Clean old sessions |

### Token Tracking

| Command | Description |
|---------|-------------|
| `tokens [--period=]` | Usage by period (today, this-week, this-month) |
| `tokens --by=provider` | Per-provider breakdown |
| `tokens --by=agent` | Per-agent breakdown |
| `tokens --top` | Top sessions by token count |
| `tokens [--json]` | Machine-readable output |

### Agents

| Command | Description |
|---------|-------------|
| `agent list` | List agents |
| `agent show <name>` | Show agent definition |
| `agent create` | Create agent (interactive) |
| `agent run <name> -q "query"` | Run agent |

### Tools

| Command | Description |
|---------|-------------|
| `tool list` | List registered tools |
| `tool show <name>` | Show tool definition |
| `tool create` | Create tool (interactive) |

### MCP

| Command | Description |
|---------|-------------|
| `mcp list` | List MCP servers |
| `mcp add` | Add MCP server (interactive) |
| `mcp remove <name>` | Remove MCP server |
| `mcp test <name>` | Test connection |

### Vault

| Command | Description |
|---------|-------------|
| `vault list [--category=]` | List vault documents |
| `vault show <path>` | Show document content |
| `vault search <query>` | Search vault (FTS5 + vector) |
| `vault import <path> [--tag=]` | Import document |
| `vault export <path>` | Export document |

### Cron

| Command | Description |
|---------|-------------|
| `cron list [--group=]` | List jobs |
| `cron create <name>` | Create job |
| `cron show <name>` | Job details |
| `cron pause <name>` | Pause job |
| `cron resume <name>` | Resume job |
| `cron run <name>` | Run now |
| `cron delete <name>` | Remove job |
| `cron stats [--json]` | Execution stats |

### Gateway

| Command | Description |
|---------|-------------|
| `gateway status` | Gateway status |
| `gateway test --platform=` | Test connection |
| `gateway log [--lines=]` | View gateway log |

### Security

| Command | Description |
|---------|-------------|
| `security scan [--full]` | Run security scan |
| `security report [--today]` | View security report |
| `security quarantine list` | List quarantined items |
| `security quarantine restore <n>` | Restore from quarantine |
| `security log [--lines=]` | View security log |
| `security status` | Security posture |

### Logs

| Command | Description |
|---------|-------------|
| `logs list` | List available log files |
| `logs show <name> [--lines=N] [--level=]` | View log entries |
| `logs tail <name>` | Follow log in real-time |
| `logs search <query> [--log=] [--level=]` | Search across logs |
| `logs path` | Show logs directory path |
| `logs clear <name>` | Truncate a log file |

### Memory

| Command | Description |
|---------|-------------|
| `memory list [--category=]` | List memory entries |
| `memory show <id>` | View a memory entry |
| `memory add <topic> <entry> [--category=]` | Save a fact |
| `memory delete <id>` | Remove memory entry |
| `memory search <query>` | Search memories |
| `memory clear [--category=]` | Clear all or by category |
| `memory export` | Dump all memories |

### Image Generation

| Command | Description |
|---------|-------------|
| `image <prompt> [--size=] [--quality=]` | Generate an AI image |
| `image <prompt> [--style=] [--n=N]` | With optional parameters |
| `image <prompt> [--output=<path>]` | Save to custom path |

### Text-to-Speech

| Command | Description |
|---------|-------------|
| `speak <text> [--voice=] [--speed=]` | Synthesise speech |
| `speak <text> [--format=mp3|wav|flac]` | Choose output format |
| `speak <text> [--output=<path>]` | Save to custom path |
| `tts <text>` | Alias for `speak` |

### Browser Automation

| Command | Description |
|---------|-------------|
| `browser status` | Check browser state + JAR availability |
| `browser start [--headless]` | Launch Chromium |
| `browser stop` | Close browser |
| `browser navigate <url>` | Go to URL |
| `browser snapshot [--full]` | Page text content |
| `browser screenshot [--path=]` | Save screenshot |
| `browser click <selector>` | Click element |
| `browser type <selector> <text>` | Fill input |
| `browser scroll up|down` | Scroll |
| `browser console` | Get console messages |
| `browser eval <js>` | Execute JavaScript |
| `browser images` | List page images |
| `browser install` | Download Playwright JARs + browser |

### Backup

| Command | Description |
|---------|-------------|
| `backup run` | Run backup now |
| `backup list` | Available backups |
| `backup restore <timestamp>` | Restore from backup |
| `backup status` | Last backup info |

### Setup Wizard

| Command | Description |
|---------|-------------|
| `setup` | Run interactive setup wizard |
| `setup --force` | Re-run setup wizard |

### System & Management

| Command | Description |
|---------|-------------|
| `doctor` | Health checks |
| `update [--to=]` | Update NanoBox |
| `update --list` | Available versions |
| `update --rollback` | Rollback to previous |
| `script list` | Registered scripts |
| `script run <name>` | Execute script |
| `script create` | Create script |
