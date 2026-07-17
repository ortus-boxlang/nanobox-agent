# Phase 3 — Commands

**Objective:** All CLI commands functional.

**Dependencies:** Phase 2 must be complete with all tests passing.

## Tasks

| # | Task | Test | Depends On |
|---|------|------|------------|
| 1 | ConfigCommand | `tests/unit/ConfigCommandTest.bx` | Phase 1 |
| 2 | SessionCommand | `tests/unit/SessionCommandTest.bx` | Phase 1 |
| 3 | TokenCommand | `tests/unit/TokenCommandTest.bx` | Phase 2.1 |
| 4 | AgentCommand | `tests/unit/AgentCommandTest.bx` | Phase 1 |
| 5 | ToolCommand | `tests/unit/ToolCommandTest.bx` | Phase 1 |
| 6 | MCPCommand | `tests/unit/MCPCommandTest.bx` | Phase 1 |
| 7 | ScriptCommand | `tests/unit/ScriptCommandTest.bx` | Phase 1 |
| 8 | BackupCommand + BackupManager | `tests/unit/BackupCommandTest.bx` | Phase 1 |
| 9 | UpdateCommand | `tests/unit/UpdateCommandTest.bx` | Phase 1 |

## Acceptance

```
$ nanobox config show
$ nanobox session list
$ nanobox tokens --by=provider
$ nanobox agent list
$ nanobox tool list
$ nanobox mcp list
$ nanobox script list
$ nanobox backup run
$ nanobox update --list
```
