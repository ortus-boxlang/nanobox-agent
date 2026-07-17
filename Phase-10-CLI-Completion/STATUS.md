# Phase 10 — CLI Namespace Completion Status

## Completed namespace

### Core lifecycle

```text
start
stop
status
restart
doctor
```

Implemented through `CoreLifecycleCommand.bx` with real process state, web/worker selection, and doctor checks.

### AI

```text
chat
model
```

Chat uses `ChatCommand` and preserves OpenAI-compatible provider/baseURL routing. Model operations use `ModelCommand` and `aiService().listModels()`.

## Remaining namespaces

1. `config`, `session`, `tokens`
2. `agent`, `tool`, `skill`, `vault`, `security`
3. `cron`, `web`, `worker`, `mcp`, `script`
4. `backup`, `update`, `gateway`

Each namespace must be completed through the active `nanobox.bx` runtime, not only direct class tests.
