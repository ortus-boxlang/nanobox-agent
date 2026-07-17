# NanoBox — Build Plan

> AI Agent Platform for BoxLang
> v0.1.0

---

## Architecture Overview

NanoBox is built in sequential phases. Phase 10 is the current pre-web gate: the entire CLI must be fully functional before the project proceeds to the web foundation.

## Phase Status (as-built 2026-07-17)

| Phase | Area | As-Built State | Delta to v0.1.0 |
|---:|---|---|---|
| 1 | Core CLI foundation | ✅ Complete — install.sh, wrappers, nanobox.bx, PrettyCli, ConfigManager, CommandDispatcher all exist; **critical import-path break** in `cli/nanobox.bx` + `CommandRuntime.bx` referencing non-existent `cli.X` classes | Fix import paths (Task 4); add `--local`/`--uninstall` to installer (Task 3) |
| 2 | AI foundation | ✅ Complete — TokenTracker, OsToolMiddleware, ChatCommand, SecurityMiddleware, VaultManager all exist in `models.{util,middleware,system,vault}` | Verify end-to-end through fixed runtime (Task 6) |
| 3 | Command classes | ✅ Complete as class-level foundations — all 19 commands exist in `cli/commands/` | Wire every namespace through real CLI (Task 6) |
| 4 | Processes | 🟡 Foundations only — ProcessManager, WebCommand, WorkerCommand exist; Scheduler is a stub; worker-owned scheduler not yet moved to `worker/` | Move scheduler into `worker/` (Task 5); implement real `boxlang schedule` integration |
| 5 | Gateways | ✅ Contract/CLI foundations — BaseGateway, GatewayRegistry, all 8 gateway classes exist in `models/gateway/`; GatewayCommand wired | Verify end-to-end through real CLI (Task 6) |
| 6 | Web foundation | ⏸️ Blocked until Phase 10 — ColdBox scaffold planned but not started | Start after Task 6 completes |
| 7 | Browser tool | ⏸️ Blocked until Phase 10 — Playwright setup planned but not started | Start after Task 6 completes |
| 8 | Packaging | ⏸️ Blocked until Phase 10 — release tarball script planned but not started | Start after Task 6 completes |
| 9 | Web UI | ⏸️ Merged into Phase 6 — no separate phase file exists | Start after Task 6 completes |
| 10 | CLI completion | 🟡 In progress — core lifecycle + chat/model marked complete in STATUS.md but broken by import paths | Fix imports (Task 4), finish remaining namespaces (Task 6) |
| 11 | Interactive chat | 🟡 Foundations — InteractiveChat + InteractiveChatRenderer exist; slash-commands partially wired | Finish all slash-commands through real CLI (Task 6) |

## Major Refactors Since Plan Creation

1. **Domain layer consolidation** — All system services (`ConfigManager`, `ProcessManager`, `BackupManager`, `ScriptManager`, `UpdateManager`) live in `models/system/`, not `cli/util/`. Utility classes (`PrettyCli`, `TokenTracker`) live in `models/util/`. This was done for clean separation but the CLI entry/runtime were never updated to match.
2. **Import-path contract** — The architectural rule going forward is: `cli/` is the interface layer (commands, dispatcher, runtime, renderer); `models/<package>/` is the domain layer. Class resolution is `models.<package>.<Class>` from BoxLang. No more `cli.X` for non-UI classes.
3. **Worker/scheduler split** — The scheduler is currently a stub in `models/scheduling/Scheduler.bx`. It will be moved into a new top-level `worker/` directory with a real implementation (Task 5).
4. **Phase 9 merged** — There is no separate `Phase-9-Web-UI/README.md`; web UI work is deferred inside Phase 6.