# Task 1.6 — CommandDispatcher

**File:** `cli/CommandDispatcher.bx`

## Description

Routes CLI commands to the appropriate handler class. Implements the command tree with argument validation.

## Requirements

- [ ] Takes `CLIGetArgs()` struct as input
- [ ] Dispatches `start/stop/status/restart` to top-level handlers
- [ ] Dispatches `web start/stop/status/restart` to WebCommand
- [ ] Dispatches `worker start/stop/status/restart` to WorkerCommand
- [ ] Dispatches `chat` to ChatCommand
- [ ] Dispatches `config` to ConfigCommand
- [ ] Dispatches `session` to SessionCommand
- [ ] Dispatches `tokens` to TokenCommand
- [ ] Dispatches `agent` to AgentCommand
- [ ] Dispatches `tool` to ToolCommand
- [ ] Dispatches `mcp` to MCPCommand
- [ ] Dispatches `vault` to VaultCommand
- [ ] Dispatches `script` to ScriptCommand
- [ ] Dispatches `cron` to CronCommand
- [ ] Dispatches `gateway` to GatewayCommand
- [ ] Dispatches `security` to SecurityCommand (via SecurityCzar)
- [ ] Dispatches `backup` to BackupCommand
- [ ] Dispatches `doctor` to DoctorCommand
- [ ] Dispatches `update` to UpdateCommand
- [ ] Dispatches `setup` to SetupCommand
- [ ] Unknown command → shows help + exits non-zero
- [ ] Each command class is lazy-loaded (created on dispatch, not at startup)
- [ ] Passes PrettyCli and ConfigManager instances to all commands
- [ ] Global `--debug` flag available on every command

## Test — As-Built 2026-07-17

**File:** `tests/unit/DispatcherTest.bx` (exists in tests/specs/)

```boxlang
# Current state: cli/CommandDispatcher.bx exists with handler map.
# INCOMPLETE: Handler map missing several namespaces (backup, update, web, worker, mcp, script, vault, security).
# Most dispatching delegated to CommandRuntime which has the full list but broken import paths.
```

**Status:** 🟡 Exists but incomplete — needs handler map reconciliation and import-path fixes (Task 4).

## Depends On

- 1.3 Main class
- 1.4 PrettyCli
- 1.5 ConfigManager
