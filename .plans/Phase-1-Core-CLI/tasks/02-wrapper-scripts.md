# Task 1.2 — Wrapper Scripts

**Files:** `nanobox`, `nanobox.bat`, `nanobox.ps1`

## Description

Create thin shell wrappers that resolve the BoxLang binary and delegate to `nanobox.bx`.

## Requirements

- [ ] Bash wrapper (`nanobox`) works on macOS + Linux
- [ ] Windows Batch wrapper (`nanobox.bat`) works on Windows
- [ ] PowerShell wrapper (`nanobox.ps1`) works on Windows
- [ ] All wrappers resolve `boxlang` binary from PATH
- [ ] All wrappers fall back to common install locations
- [ ] All wrappers resolve `NANOBOX_HOME` (default: `~/.nanobox`)
- [ ] All wrappers find `nanobox.bx` at `$NANOBOX_HOME/current/nanobox.bx`
- [ ] All arguments are passed through to `nanobox.bx`
- [ ] Exit code from `nanobox.bx` is propagated
- [ ] Bash wrapper uses `exec` (no subshell)
- [ ] Wrappers are thin: no logic beyond binary + path resolution
- [ ] `nanobox --help` shows NanoBox help (not BoxLang help)

## Implementation Notes

Wrappers should be **thinnest possible** — they just find things and delegate. No PID management, no config parsing.

```bash
#!/usr/bin/env bash
NANOBOX_HOME="${NANOBOX_HOME:-$HOME/.nanobox}"
exec boxlang "$NANOBOX_HOME/current/nanobox.bx" "$@"
```

## Test (Manual) — As-Built 2026-07-17

```bash
# Bash wrapper
./nanobox --help
./nanobox --version
# → Both work, exit code propagates correctly

# Verify exit codes propagate
./nanobox nonexistent-command
echo $?  # → Non-zero (1)
```

**Status:** ✅ Complete — all three wrappers (bash, bat, ps1) resolve BoxLang and nanobox.bx correctly. No changes needed.

## Depends On

None.
