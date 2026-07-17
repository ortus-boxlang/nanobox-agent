# Task 1.5 — ConfigManager

**File:** `cli/util/ConfigManager.bx`

## Description

Reads and writes NanoBox configuration files. Supports JSON config, .env files, and preferences.

## Requirements

- [ ] `load()` — loads `nanobox.json` from `NANOBOX_HOME/config/nanobox.json`
- [ ] `save()` — writes `nanobox.json` back to disk
- [ ] `get( key, default )` — get config value by dot-notation key (`nanobox.web.port`)
- [ ] `set( key, value )` — set config value and persist
- [ ] `unset( key )` — remove config key and persist
- [ ] `loadEnv()` — loads `~/.nanobox/.env` into system properties
- [ ] `loadPreferences()` — loads `preferences.json`
- [ ] `savePreferences()` — writes `preferences.json`
- [ ] `getConfigPath()` — returns resolved config path
- [ ] `getNanoboxHome()` — returns `NANOBOX_HOME` or `~/.nanobox`
- [ ] Creates default files if they don't exist on load
- [ ] Supports `${ENV_VAR}` placeholder resolution in config values
- [ ] Returns default struct if config file is missing (no crash)
- [ ] Validates JSON on load — reports parse errors via PrettyCli.warn()
- [ ] `--json` flag on `config show` outputs raw JSON

## Test — As-Built 2026-07-17

**File:** `tests/unit/ConfigManagerTest.bx` (exists in tests/specs/)

```boxlang
# Current state: models/system/ConfigManager.bx exists with full feature set.
# Location moved from cli/util/ConfigManager.bx to models/system/ConfigManager.bx during refactoring.
```

**Status:** ✅ Complete — all requirements met, lives at correct path now.

## Depends On

- 1.3 Main class
