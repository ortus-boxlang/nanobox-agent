---
title: "Tools"
order: 17
description: "Manage AI function-calling tools from bx-ai, NanoBox-shipped, and user-installed sources."
---

# NanoBox Tool CLI

> Manage AI function-calling tools from bx-ai, NanoBox-shipped, and user-installed sources.

## Overview

The `tool` namespace manages **all tools available to NanoBox agents**. Tools are registered in three sources:

| Source | Count | Description |
|--------|-------|-------------|
| bx-ai built-in | 9 | Auto-registered: `now@bxai`, `print@bxai`, `webSearch@bxai`, `speak@bxai`, etc. |
| NanoBox shipped | 12 | Under `cli/tools/`: vault, skill, session, system, file*, config tools |
| bx-ai FileSystemTools | 19 | Auto-registered with path guards (CWD + NanoBox home) |
| User-installed | ? | In `~/.nanobox/tools/*.bx` |

Tools are **enabled by default**. Use these commands to turn them on or off for agent use.

## Commands

### `nanobox tool list`

Show all tools with name, description, source, and enabled/disabled status.

```
$ nanobox tool list

Key                          Name           Source    Enabled  Description
──────────────────────────────────────────────────────────────────────────
now@bxai                     now            bxai      ✓        Current date/time
print@bxai                   print          bxai      ✓        Print to console
webSearch@bxai               webSearch      bxai      ✓        Search the web
speak@bxai                   speak          bxai      ✗        Text to speech
vault_search@nanobox         vault_search   nanobox   ✓        Vault knowledge search
session_search@nanobox       session_search nanobox   ✓        Past session search
system_exec@nanobox          system_exec    nanobox   ✓        Run any command
```

### `nanobox tool show <key>`

Show detailed information about a specific tool.

```
$ nanobox tool show now@bxai

Key:         now@bxai
Name:        now
Description: Returns the current date and time in ISO 8601 format
Module:      bxai
Enabled:     ✓
```

### `nanobox tool enable <key>`

Enable a tool so agents can use it.

```
$ nanobox tool enable speak@bxai
✓ Tool enabled: speak@bxai
```

### `nanobox tool disable <key>`

Disable a tool. Agents will no longer have access to it.

```
$ nanobox tool disable print@bxai
✓ Tool disabled: print@bxai
```

### `nanobox tool status`

Show summary of total, enabled, and disabled tools.

```
$ nanobox tool status
31 total · 15 enabled · 16 disabled
```

### `nanobox tool refresh`

Re-scan all sources and rebuild the tool index on disk.

## Disk Index

The tool manifest is stored at `~/.nanobox/tools-index.json`. This is the single source of truth consumed by the CLI, the web UI (future), and agent runtimes.

## Agent Integration

Agents automatically use only the **enabled** tools. When you run `nanobox agent run <name>`, the agent receives only the tool keys you've enabled. To give an agent access to specific tools:

1. Enable the tool: `nanobox tool enable vault_search@nanobox`
2. Run the agent: `nanobox agent run my_agent`
3. The agent sees `vault_search@nanobox` as an available tool

## Creating Custom Tools

Place `.bx` files with `@AITool` annotations in `~/.nanobox/tools/`:

```java
// ~/.nanobox/tools/my_calculator.bx
class {
    @AITool( "Calculate the result of a math expression" )
    public numeric function calculate( required string expression ) {
        return evaluate( arguments.expression )
    }
}
```

Run `nanobox tool refresh` to register them, then enable with `nanobox tool enable calculate@user`.

## Tests

```text
tests/specs/ToolCommandSpec.bx
```

Coverage includes ToolManager lifecycle (list/show/enable/disable/status/refresh), ToolCommand dispatch for all 6 actions, error paths for nonexistent keys, and unknown action rejection.