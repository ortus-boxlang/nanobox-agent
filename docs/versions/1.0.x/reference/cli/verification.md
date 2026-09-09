---
title: "Namespace Verification"
order: 25
description: "The current NanoBox CLI namespace matrix and the commands used to validate each namespace."
---

# CLI Namespace Verification

This document records the current NanoBox CLI namespace matrix and the commands used to validate each namespace through the active `nanobox.bx` entry point.

## Global

```bash
nanobox --help
nanobox --version
```

## Core lifecycle

```bash
nanobox status
nanobox doctor
nanobox start --web-only --port=18992
nanobox status
nanobox restart --web-only --port=18993
nanobox status
nanobox stop --web-only
nanobox status
nanobox start --worker-only
nanobox status
nanobox stop --worker-only
nanobox status
```

## AI and models

```bash
nanobox model current
nanobox model status
nanobox model status --provider=lmstudio
nanobox model refresh --provider=lmstudio
nanobox model set qwen/qwen3.6-35b-a3b --provider=lmstudio
nanobox model add local-coder --provider=lmstudio --model=qwen/qwen3.6-35b-a3b --default
nanobox model set --named-model=local-coder
nanobox model remove local-coder
nanobox chat --query="Reply with exactly: NanoBox CLI works"
```

## Provider configuration

```bash
nanobox config provider list
nanobox config provider status
nanobox config provider add lmstudio --type=openai-compatible --baseURL=http://localhost:1234/v1
nanobox config provider set lmstudio
nanobox config provider remove lmstudio
```

## Configuration and persistence

```bash
nanobox config show
nanobox config get bx-ai.defaultProvider
nanobox config set cli.validation value
nanobox config unset cli.validation
nanobox config path
nanobox session create
nanobox session list
nanobox session show <id>
nanobox session search <query>
nanobox session prune
nanobox tokens
nanobox tokens --period=today --by=provider
```

## Content and security

```bash
nanobox agent list
nanobox agent create <name>
nanobox agent show <name>
nanobox agent run <name> --query="test"
nanobox tool list
nanobox tool create <name>
nanobox tool show <name>
nanobox skill list
nanobox skill search <query>
nanobox skill show <name>
nanobox vault list
nanobox vault search <query>
nanobox vault index
nanobox security status
nanobox security scan
```

## Automation and processes

```bash
nanobox cron list
nanobox cron create <name> --schedule="every 1h" --prompt="test"
nanobox cron show <name>
nanobox cron pause <name>
nanobox cron resume <name>
nanobox cron run <name>
nanobox cron stats
nanobox cron delete <name>
nanobox web start
nanobox web status
nanobox web stop
nanobox worker start
nanobox worker status
nanobox worker stop
nanobox mcp list
nanobox mcp add <name> --url=<url>
nanobox mcp test <name>
nanobox mcp remove <name>
nanobox script list
nanobox script create <name>
nanobox script show <name>
nanobox script run <name>
```

## Operations and gateways

```bash
nanobox backup status
nanobox backup list
nanobox backup run
nanobox update status
nanobox update list
nanobox gateway status
nanobox gateway log --lines=50
nanobox gateway test <name>
nanobox gateway send <name> <recipient> <message>
```

For every command, record combined output and exit code. Any documented command that returns only a handler name, prompts unexpectedly in a non-interactive invocation, leaks a secret, or returns success for an invalid operation is not complete.
