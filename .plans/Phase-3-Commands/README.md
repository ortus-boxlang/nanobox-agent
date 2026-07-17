# Phase 3 — Commands

**Objective:** All CLI commands functional.

**Dependencies:** Phase 2 must be complete with all tests passing.

## Tasks (as-built 2026-07-17)

| # | Task | Test | Depends On | Status |
|---|------|------|------------|--------|
| 1 | ConfigCommand | `tests/unit/ConfigCommandTest.bx` | Phase 1 | ✅ Complete — lives at `cli/commands/ConfigCommand.bx` |
| 2 | SessionCommand | `tests/unit/SessionCommandTest.bx` | Phase 1 | ✅ Complete — lives at `cli/commands/SessionCommand.bx` |
| 3 | TokenCommand | `tests/unit/TokenCommandTest.bx` | Phase 2.1 | ✅ Complete — lives at `cli/commands/TokenCommand.bx` |
| 4 | AgentCommand | `tests/unit/AgentCommandTest.bx` | Phase 1 | ✅ Complete — lives at `cli/commands/AgentCommand.bx` |
| 5 | ToolCommand | `tests/unit/ToolCommandTest.bx` | Phase 1 | ✅ Complete — lives at `cli/commands/ToolCommand.bx` |
| 6 | MCPCommand | `tests/unit/MCPCommandTest.bx` | Phase 1 | ✅ Complete — lives at `cli/commands/MCPCommand.bx` |
| 7 | ScriptCommand | `tests/unit/ScriptCommandTest.bx` | Phase 1 | ✅ Complete — lives at `cli/commands/ScriptCommand.bx` |
| 8 | BackupCommand + BackupManager | `tests/unit/BackupCommandTest.bx` | Phase 1 | ✅ Complete — lives at `cli/commands/BackupCommand.bx`, manager at `models/system/BackupManager.bx` |
| 9 | UpdateCommand | `tests/unit/UpdateCommandTest.bx` | Phase 1 | ✅ Complete — lives at `cli/commands/UpdateCommand.bx` |

**Additional commands not in original plan:** CronCommand, GatewayCommand, SkillCommand, SkillCuratorCommand, SkillActivationCommand, VaultCommand, WebCommand, WorkerCommand, ModelCommand — all exist and are implemented.

## Acceptance (verified 2026-07-17)

```bash
$ nanobox config show
# → BROKEN: import paths in CommandRuntime reference non-existent cli.X classes

$ nanobox session list
# → BROKEN: same issue

$ nanobox tokens --by=provider
# → BROKEN: same issue

$ nanobox agent list
# → BROKEN: same issue

$ nanobox tool list
# → BROKEN: same issue

$ nanobox mcp list
# → BROKEN: same issue

$ nanobox script list
# → BROKEN: same issue

$ nanobox backup run
# → BROKEN: same issue

$ nanobox update --list
# → BROKEN: same issue
```

**Ready for v0.1.0?** ❌ No — all command classes exist and are implemented, but the CLI runtime can't reach them due to broken imports (Task 4). Once fixed, verify every namespace end-to-end (Task 6).
