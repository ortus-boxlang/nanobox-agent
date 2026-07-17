# Task 1.3 — Main Class

**File:** `nanobox.bx`

## Description

Create the main entry point class with `main()` method. Parses CLI args, initializes ConfigManager and PrettyCli, dispatches to CommandDispatcher.

## Requirements

- [ ] Class has `main( args = [] )` method (BoxLang convention)
- [ ] Uses `CLIGetArgs()` for argument parsing
- [ ] Initializes `ConfigManager` on startup
- [ ] Initializes `PrettyCli` on startup
- [ ] Dispatches to `CommandDispatcher`
- [ ] No args → shows help and exits
- [ ] `--help`, `-h` → shows help and exits
- [ ] `--version`, `-v` → shows version and exits
- [ ] Unknown command → shows "Unknown command" message and exits non-zero
- [ ] Global `--debug` flag enables debug output
- [ ] Uses BoxLang's `server` scope for persistence across calls

## Test — As-Built 2026-07-17

**File:** `tests/unit/MainClassTest.bx` (exists but likely shares broken import paths)

```boxlang
# Current state: cli/nanobox.bx exists with main() method, CLIGetArgs parsing, version/help flags.
# BROKEN: References "cli.util.ConfigManager" and "cli.PrettyCli" which don't exist.
# FIX: Change to "models.system.ConfigManager" and "models.util.PrettyCli" (Task 4).
```

**Status:** 🟡 Exists but broken by import paths. Fix in Task 4.

## Depends On

- 1.1 Install script (directory structure)
- 1.2 Wrapper scripts (invocation path)
