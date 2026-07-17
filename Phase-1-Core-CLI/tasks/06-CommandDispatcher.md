# Task 1.6 — CommandDispatcher

**File:** `nanobox-cli/CommandDispatcher.bx`

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

## Test

**File:** `tests/unit/DispatcherTest.bx`

```boxlang
describe( "CommandDispatcher", () => {
    it( "dispatches start command", () => { })
    it( "dispatches web start command", () => { })
    it( "dispatches worker stop command", () => { })
    it( "dispatches chat command", () => { })
    it( "dispatches config command", () => { })
    it( "dispatches doctor command", () => { })
    it( "shows help for unknown command", () => { })
    it( "passes --debug flag to command handlers", () => { })
    it( "lazy-loads command classes", () => { })
})
```

## Depends On

- 1.3 Main class
- 1.4 PrettyCli
- 1.5 ConfigManager
