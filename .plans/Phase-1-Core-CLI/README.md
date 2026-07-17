# Phase 1 — Core CLI

**Objective:** Working CLI skeleton with wrappers, beautiful output, config management, and command routing.

**Dependencies:** None (foundation phase)

**Tests must pass before Phase 2 can start.**

## Tasks

| # | Task | File | Test | 
|---|------|------|------|
| 1 | Install script | `01-install-script.md` | Manual |
| 2 | Wrapper scripts | `02-wrapper-scripts.md` | Manual |
| 3 | Main class | `03-nanobox-main-class.md` | `tests/unit/MainClassTest.bx` |
| 4 | PrettyCli | `04-PrettyCli.md` | `tests/unit/PrettyCliTest.bx` |
| 5 | ConfigManager | `05-ConfigManager.md` | `tests/unit/ConfigManagerTest.bx` |
| 6 | CommandDispatcher | `06-CommandDispatcher.md` | `tests/unit/DispatcherTest.bx` |

## Acceptance

```
$ nanobox doctor
┌──────────────────────────────────────────────────────┐
│ 🩺 NanoBox Diagnostics                               │
├──────────────────────────────────────────────────────┤
│ ✅ boxlang binary: found (v1.15.0)                   │
│ ✅ Config: ~/.nanobox/config/nanobox.json             │
│ ⚠️  No API keys configured                           │
│ 📁 Vault: ~/.nanobox/vault/ (empty)                  │
│ 💾 Memory DB: ~/.nanobox/memory.db (initialized)     │
│ 📦 bx-ai module: installed                           │
│ 📦 bx-sqlite module: installed                       │
│ ⚪ Web UI: not running                                │
│ ⚪ Worker: not running                                │
└──────────────────────────────────────────────────────┘
```
