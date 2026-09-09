---
title: "Installation"
order: 2
description: "Clone NanoBox and install it locally for development or globally for everyday use."
icon: "phosphor-duotone:package"
---

# Installation

```bash
git clone https://github.com/ortus-boxlang/nanobox-agent.git
cd nanobox-agent
```

`install.sh` checks for the BoxLang runtime and offers to install it via the
BoxLang quick installer if it's missing, then installs the required BoxLang
modules (`bx-ai`, `bx-sqlite`, `testbox`).

## Local development install

Installs in-project, with user data kept in `.nanobox/` alongside the source:

```bash
./install.sh --local

# Run the local dev wrapper
./nanobox-dev doctor
./nanobox-dev status
./nanobox-dev chat -q "Hello"
```

## Global install

Installs to `~/.nanobox` with a `nanobox` wrapper on your `PATH`:

```bash
./install.sh

# Ensure ~/.local/bin is in PATH
export PATH="$HOME/.local/bin:$PATH"

# Verify
nanobox --version
nanobox doctor
```

## Installer options

```
./install.sh [options]

Options:
  --help, -h          Show this help
  --version, -v       Show the version being installed
  --local             Install in-project (data in .nanobox/, run from source)
  --uninstall         Remove NanoBox installation
  --prefix=PATH       Install to a custom prefix (e.g. /opt/nanobox)
  --ci                Non-interactive; fail fast on missing dependencies

Environment:
  NANOBOX_HOME        Override installation data directory
  NANOBOX_BIN         Override wrapper directory (default: ~/.local/bin)
  NANOBOX_VERSION     Version label (default: 0.1.0)
  BOXLANG             Explicit path to the boxlang binary
```

## Uninstalling

```bash
./install.sh --uninstall
```

## Windows

Native launchers are provided for Windows shells:

- `nanobox.bat` (Command Prompt)
- `nanobox.ps1` (PowerShell)
