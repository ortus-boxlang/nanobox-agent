---
title: "Logs"
order: 19
description: "View, search, and manage BoxLang log files from the CLI."
---

# NanoBox Logs Namespace

> View, search, and manage BoxLang log files from the CLI.

## Overview

NanoBox and bx-ai write to named loggers via `writeLog()` BIF. Log files live in the BoxLang logs directory (`~/.boxlang/logs/` by default). The `logs` namespace lets you browse, filter, search, and clear them without grepping for log file paths.

## Commands

### `nanobox logs list`

List all available log files with size and last-modified time.

```
$ nanobox logs list
📁 BoxLang Logs (~/.boxlang/logs/)
═══════════════════════════════════
  nanobox-security.log        1.2 MB
  nanobox-backup.log         340 KB
  ai.log                       4 MB
  scheduler.log              890 KB
  application.log            120 KB
```

### `nanobox logs show <name>`

Display recent log entries from a named logger (omit the `.log` extension).

```
$ nanobox logs show nanobox-security
📋 nanobox-security.log — last 50 lines
═══════════════════════════════════════════════════════
[2026-07-26 09:15:22] [information] Security scan tick starting
[2026-07-26 09:15:23] [warning] Security scan found 2 threats
[2026-07-26 09:15:23] [information] Scan complete — threats=2
```

Options:
- `--lines, -n <N>` — number of lines to show (default 50, 0 = all)
- `--level, -l <level>` — filter by level: `info`, `warn`, `error`, `debug`

Bare name as first positional is treated as `show`:

```
nanobox logs ai            # same as nanobox logs show ai
```

### `nanobox logs tail <name>`

Follow a log file in real-time (like `tail -f`). New lines appear as they're written. Press `Ctrl+C` to stop.

```
$ nanobox logs tail nanobox-security
⏳ Tailing nanobox-security.log — Ctrl+C to stop
[2026-07-26 09:16:01] [information] Security scan tick starting
[2026-07-26 09:16:02] [warning] Security scan found 1 threat
...
```

### `nanobox logs search <query>`

Search across all log files (or a specific one) for matching entries. Supports regex patterns.

```
$ nanobox logs search "threat" --level warning
🔍 Searching logs for "threat"
═══════════════════════════════════════════════════════
nanobox-security.log:
  [2026-07-26 09:15:23] [warning] Security scan found 2 threats
ai.log:
  [2026-07-26 08:30:00] [error] API rate limit exceeded
```

Options:
- `--log, -l <name>` — restrict to a specific log file
- `--level <level>` — filter by severity
- `--before <date>` — only entries before this date (YYYY-MM-DD)
- `--after <date>` — only entries after this date (YYYY-MM-DD)
- `--limit <N>` — max results (default 50)

### `nanobox logs path`

Print the absolute path to the logs directory.

```
$ nanobox logs path
~/.boxlang/logs
```

### `nanobox logs clear <name>`

Truncate a log file to zero bytes. Confirms before clearing files larger than 1 MB.

```
$ nanobox logs clear nanobox-security
⚠️  nanobox-security.log is 1.2 MB. Clear it? (y/N): y
✅ Cleared nanobox-security.log
```

## Log Level Colors

Output is colorized for readability:

| Level | Color |
|-------|-------|
| `error` | Red |
| `warn` / `warning` | Yellow |
| `info` / `information` | Green |
| `debug` / `trace` | Dim |

## Storage

Log files live in the BoxLang logs directory, configurable via:

```json
{
  "nanobox": {
    "logsDir": "~/.boxlang/logs"
  }
}
```

## Tests

```
tests/specs/LogManagerSpec.bx
tests/specs/LogCommandSpec.bx
```
