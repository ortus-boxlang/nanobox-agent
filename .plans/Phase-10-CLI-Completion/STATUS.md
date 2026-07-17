# Phase 10 — CLI Namespace Completion Status (as-built 2026-07-17)

## Per-Namespace Matrix

| Namespace | Documented Actions | Implemented Classes | Import Paths Fixed? | End-to-End Verified? | Blocker |
|-----------|-------------------|---------------------|---------------------|----------------------|---------|
| **Core lifecycle** (`start`, `stop`, `status`, `restart`, `doctor`) | 5 actions | `CoreLifecycleCommand.bx` exists | ❌ No — `cli/nanobox.bx` + `CommandRuntime.bx` reference non-existent `cli.X` classes | ❌ No | Task 4 (import paths) |
| **AI** (`chat`, `model`) | 2 namespaces | `ChatCommand.bx`, `ModelCommand.bx` exist | ❌ No | ❌ No | Task 4 (import paths) |
| **Config & persistence** (`config`, `session`, `tokens`) | 3 namespaces | `ConfigCommand.bx`, `SessionCommand.bx`, `TokenCommand.bx` exist | ❌ No | ❌ No | Task 4 (import paths) |
| **Content & security** (`agent`, `tool`, `skill`, `vault`, `security`) | 5 namespaces | All command classes exist in `cli/commands/` | ❌ No | ❌ No | Task 4 (import paths) |
| **Automation & processes** (`cron`, `web`, `worker`, `mcp`, `script`) | 5 namespaces | All command classes exist; Scheduler is a stub | ❌ No | ❌ No | Task 4 (import paths) + Task 5 (worker move) |
| **Operations & gateways** (`backup`, `update`, `gateway`) | 3 namespaces | All command classes exist | ❌ No | ❌ No | Task 4 (import paths) |

## Summary

- **All command classes exist** — every documented namespace has a corresponding `*Command.bx` file in `cli/commands/`.
- **No namespace works end-to-end** — the CLI runtime (`cli/CommandRuntime.bx`) and entry point (`cli/nanobox.bx`) reference `cli.X` import paths that don't exist. The actual managers live in `models.X`.
- **Scheduler is a stub** — `models/scheduling/Scheduler.bx` only tracks a boolean; no real `boxlang schedule` integration.
- **Worker not yet consolidated** — `worker/` directory is empty; scheduler + WorkerCommand need to be moved there (Task 5).

**Ready for v0.1.0?** ❌ No — fix import paths (Task 4), consolidate worker (Task 5), verify every namespace end-to-end (Task 6).
