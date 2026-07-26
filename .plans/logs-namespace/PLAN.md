# Plan: `nanobox logs` Namespace

> **Status:** Draft
> **Effort:** Small (2-3 hours)
> **Depends on:** Phase 0 completion (done), BoxLang log infrastructure (existing)

---

## Why

NanoBox and bx-ai write to multiple named loggers (`nanobox-security`, `nanobox-backup`, `ai`, etc.) but there's no CLI to view, search, or tail them. Users currently have to find the BoxLang logs directory and grep manually.

## BoxLang Logging Background

- `writeLog( text, type, log, application )` — BIF that writes to `{boxlang-home}/logs/{logname}.log`
- Default logs directory: `${boxlang-home}/logs` (typically `~/.boxlang/logs/` via config or `~/.nanobox/` when overridden)
- NanoBox uses named loggers: `nanobox-security`, `nanobox-backup`, `ai` (bx-ai), plus bx-ai internal loggers
- BoxLang uses rolling file appenders (auto-rotates)
- Log entries are plain text with timestamps; no structured format

## Design

### CLI Command Tree

```
nanobox logs [action] [options]

Actions:
  list                          Show all available log files
  show <name> [options]         Display log entries (default: last 50)
  tail <name>                   Follow log in real-time
  search <query> [options]      Search across log entries
  path                          Show the logs directory path
  clear <name>                  Truncate/clear a log file
```

### Sub-action Details

#### `nanobox logs list`
Lists all `.log` files in the BoxLang logs directory.

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

**Backend:** `LogManager.list()` — scans `{boxlang-home}/logs/*.log`, returns name + size + last modified.

#### `nanobox logs show <name>` (default action)
Shows recent log entries from a named log.

```
$ nanobox logs show nanobox-security
📋 nanobox-security.log — last 20 lines
═══════════════════════════════════════════════════════
[2026-07-26 09:15:22] [information] Security scan tick starting — scope=skills
[2026-07-26 09:15:23] [warning] Security scan found 2 threats in skills
[2026-07-26 09:15:23] [information] Security scan tick complete — threats=2, duration=1s
...
```

Options:
- `--lines` / `-n` — number of lines to show (default 50, 0 = all)
- `--level` / `-l` — filter by level (information, warning, error, debug)
- `--follow` / `-f` — same as `tail` sub-action

**Backend:** `LogManager.show( name, lines, level )` — reads file, applies filters, returns entries.

#### `nanobox logs tail <name>`
Follows a log file in real-time (like `tail -f`).

```
$ nanobox logs tail nanobox-security
⏳ Tailing nanobox-security.log — Ctrl+C to stop
[2026-07-26 09:16:01] [information] Security scan tick starting
[2026-07-26 09:16:02] [warning] Security scan found 1 threat
...
```

**Implementation:** Uses a polling loop with `fileRead()` comparing file size/position, or BoxLang file watcher. Default poll interval: 1 second. Exit on Ctrl+C.

#### `nanobox logs search <query>`
Searches across log files for matching entries.

```
$ nanobox logs search "threat" --level warning
🔍 Searching logs for "threat" (level: warning)
═══════════════════════════════════════════════════════
nanobox-security.log:
  [2026-07-26 09:15:23] [warning] Security scan found 2 threats in skills
  [2026-07-26 09:16:02] [warning] Security scan found 1 threat
ai.log:
  [2026-07-26 08:30:00] [error] API rate limit exceeded
```

Options:
- `--log` / `-l` — restrict to a specific log file
- `--level` — filter by severity
- `--before` / `--after` — date/time range
- `--limit` — max results (default 50)

**Backend:** `LogManager.search( query, log, level, before, after, limit )` — greps across files with filters.

#### `nanobox logs path`
Prints the absolute path to the BoxLang logs directory.

#### `nanobox logs clear <name>`
Truncates a log file to zero bytes (with confirmation for files > 1MB).

---

## Implementation

### Files

| File | Purpose |
|------|---------|
| `cli/commands/LogCommand.bx` | CLI command class with action dispatch |
| `models/system/LogManager.bx` | Backend: reads, searches, tails log files |
| `cli/CommandRuntime.bx` | Wire `case "logs"` dispatch (1 line) |

### LogManager API

```boxlang
class {
    function init( string logsDir = "" )  // defaults to {boxlang-home}/logs
    array function list()                 // [{name, size, lastModified}, ...]
    struct function show( name, lines=50, level="" )  // {name, entries:[], total, showing}
    array function search( query, log="", level="", before="", after="", limit=50 )
    string function getPath()             // absolute logs directory path
    boolean function clear( name )        // truncate file to 0 bytes
}
```

### LogCommand Dispatch

```boxlang
switch ( lCase( action ) ) {
    case "list":   return listAction()
    case "show":   return showAction( args )
    case "tail":   return tailAction( args )
    case "search": return searchAction( args )
    case "path":   return { success: true, path: manager.getPath() }
    case "clear":  return clearAction( args )
    default:       return showAction( { name: action, lines: args.lines ?: 50 } )  // treat bare name as "show"
}
```

### Wire in CommandRuntime.bx

```boxlang
case "logs": return new "cli.commands.LogCommand"( new "models.system.LogManager"() ).execute( action ?: "list", args )
```

### Rendering

Use the existing `SetupOnboarding` renderer or `PrettyCli` for:
- Log file listings with size formatting (KB/MB)
- Colored log levels (`error` → red, `warning` → yellow, `info` → green)
- Box borders for file headers
- Rainbow divider on search results

---

## Testing

| Test | What it verifies |
|------|-----------------|
| `LogManagerListSpec.bx` | Scans logs dir, returns valid entries |
| `LogManagerShowSpec.bx` | Reads file, respects --lines and --level, handles missing file |
| `LogManagerSearchSpec.bx` | Regex search, multi-file, level/date filters |
| `LogManagerClearSpec.bx` | Truncation with confirmation |
| `LogCommandSpec.bx` | All actions dispatch correctly |
| `LogActiveCliSpec.bx` | End-to-end through CLI |

---

## Future Enhancements (v0.2+)

- **Structured log format** — JSON log entries with machine-readable fields
- **Log rotation management** — configure max size, retention
- **Remote log aggregation** — ship logs to external services
- **Dashboard** — real-time log viewer in web UI
