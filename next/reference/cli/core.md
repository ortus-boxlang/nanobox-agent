---
title: "Core Commands"
order: 2
description: "Lifecycle commands that control NanoBox's web UI and worker processes."
---

# Core CLI Commands

The core namespace controls NanoBox's web and worker processes.

## Commands

```bash
nanobox start
nanobox stop
nanobox status
nanobox restart
nanobox doctor
```

## Start

Starts both managed processes:

```bash
nanobox start
```

Start only one process:

```bash
nanobox start --web-only
nanobox start --worker-only
```

Additional options:

```bash
nanobox start --debug
nanobox start --port=8080
nanobox start --host=127.0.0.1
```

The shared `ProcessManager` owns process state at:

```text
~/.nanobox/run/processes.json
```

## Stop

```bash
nanobox stop
nanobox stop --web-only
nanobox stop --worker-only
```

Stopping an already-stopped process is safe and returns a successful stopped result.

## Status

```bash
nanobox status
```

Returns the currently running managed processes, including:

- Process name
- PID
- Start timestamp
- Executable
- Runtime state

Machine-readable output is always JSON while the CLI runtime is being finalized. The planned `--json` flag remains reserved for the human/table renderer.

## Restart

```bash
nanobox restart
nanobox restart --web-only
nanobox restart --worker-only
```

Restart performs a stop followed by a start using the same process-selection options.

## Doctor

```bash
nanobox doctor
```

Checks:

- NanoBox home directory
- Root configuration file
- Process state file
- Required local modules
- Managed process status

## Ownership

```text
nanobox start/stop/restart/status
    → CoreLifecycleCommand
        → ProcessManager
            ├── boxlang-miniserver (web)
            └── nanobox-worker.bx (worker)
```

The worker owns scheduler execution. There is no standalone scheduler process or scheduler command.

## Exit behavior

- `0`: command completed successfully
- `1`: command returned `{ success: false }` or failed validation
- Process details are returned in structured JSON
