# Phase 1 — Core CLI

**Objective:** Working CLI skeleton with wrappers, beautiful output, config management, and command routing.

**Dependencies:** None (foundation phase)

**Tests must pass before Phase 2 can start.**

## Tasks (as-built 2026-07-17)

| # | Task | File | Test | Status |
|---|------|------|------|--------|
| 1 | Install script | `01-install-script.md` | Manual | ✅ Complete — idempotent, creates all directories, writes defaults; needs `--local`/`--uninstall` flags (Task 3) |
| 2 | Wrapper scripts | `02-wrapper-scripts.md` | Manual | ✅ Complete — bash, bat, ps1 all resolve BoxLang + nanobox.bx correctly |
| 3 | Main class | `03-nanobox-main-class.md` | `tests/unit/MainClassTest.bx` | 🟡 Exists but broken — references `cli.util.ConfigManager` and `cli.PrettyCli` which don't exist (should be `models.system.ConfigManager`, `models.util.PrettyCli`) |
| 4 | PrettyCli | `04-PrettyCli.md` | `tests/unit/PrettyCliTest.bx` | ✅ Complete — lives at `models/util/PrettyCli.bx`; full feature set implemented |
| 5 | ConfigManager | `05-ConfigManager.md` | `tests/unit/ConfigManagerTest.bx` | ✅ Complete — lives at `models/system/ConfigManager.bx`; dot-notation, env resolution, defaults all work |
| 6 | CommandDispatcher | `06-CommandDispatcher.md` | `tests/unit/DispatcherTest.bx` | 🟡 Exists but incomplete — handler map missing several namespaces (`backup`, `update`, `web`, `worker`, `mcp`, `script`, `vault`, `security`); delegates to `CommandRuntime` for most |

## Acceptance (verified 2026-07-17)

```bash
$ ./install.sh --help
# → Shows usage with --version flag only; needs --local/--uninstall/--prefix added

$ ./nanobox --version
# → "NanoBox v0.1.0" (works through wrapper)

$ ./nanobox doctor
# → BROKEN: import paths in cli/nanobox.bx reference non-existent cli.X classes
```

**Ready for v0.1.0?** ❌ No — import-path breakage must be fixed (Task 4), installer needs local mode (Task 3).
