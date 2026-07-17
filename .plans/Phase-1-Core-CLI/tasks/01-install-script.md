# Task 1.1 — Install Script

**File:** `install.sh`

## Description

Create the installation script that sets up NanoBox from a git clone or release tarball. This is the entry point for all users.

## Requirements

- [ ] Detects OS (macOS, Linux, Windows via Git Bash/WSL)
- [ ] Creates `~/.nanobox/versions/v0.1.0/` directory
- [ ] Copies core files (preserving directory structure)
- [ ] Creates `~/.nanobox/config/` with default templates on first install
- [ ] Creates `~/.nanobox/.env` with placeholder comments
- [ ] Creates `~/.nanobox/agents/` with built-in agent definitions
- [ ] Creates `~/.nanobox/tools/` (empty, ready for user tools)
- [ ] Creates `~/.nanobox/mcp-servers/` with default registry.json
- [ ] Creates `~/.nanobox/vault/` with subdirectories (reports, research, imported, manual)
- [ ] Creates `~/.nanobox/user-scripts/` with registry
- [ ] Creates `~/.nanobox/skills/` (empty)
- [ ] Creates `~/.nanobox/backups/` (empty)
- [ ] Creates `~/.nanobox/logs/` (empty)
- [ ] Creates `~/.nanobox/run/` (empty)
- [ ] Creates `~/.nanobox/quarantine/` (empty)
- [ ] Symlinks `~/.nanobox/current → versions/v0.1.0/`
- [ ] Installs wrapper script to `~/.local/bin/nanobox`
- [ ] Does NOT overwrite existing config on re-install
- [ ] Prints branded success message with next steps
- [ ] Exits with code 0 on success

## Implementation Notes

- Use `rsync` or `cp -r` for file copying
- Use `ln -sfn` for symlink (atomic swap)
- Check `~/.nanobox/config/` existence before creating defaults
- Respect `NANOBOX_HOME` env var override
- Support `--help` flag

## Test (Manual) — As-Built 2026-07-17

```bash
# Clean install
rm -rf ~/.nanobox
cd nanobox
./install.sh
# → Creates all directories, writes defaults, installs wrapper

# Re-install (should preserve config)
./install.sh
# → Config files unchanged (idempotent)

# Verify wrapper
~/.local/bin/nanobox --version
# → "NanoBox v0.1.0"
```

**Status:** ✅ Complete — all requirements met. **Needs enhancement:** `--local` mode for dev installs, `--uninstall` mode, `--prefix` for root installs (Task 3).

## Depends On

None.
