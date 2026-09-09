---
title: "Quick Start"
order: 3
description: "Verify your install, configure a provider, and run your first chat."
icon: "phosphor-duotone:flag-checkered"
---

# Quick Start

## 1. Check your environment

```bash
nanobox doctor
```

## 2. Configure a provider

Run the interactive setup wizard:

```bash
nanobox setup
```

Or configure providers directly:

```bash
nanobox config provider add openai
nanobox config provider set openai
nanobox config model set gpt-4o
```

See [Configuration](configuration.md) for the full list of supported provider
environment variables.

## 3. Chat

```bash
# Interactive session
nanobox chat

# One-shot query
nanobox chat -q "What can you help me with?"

# Use a specific agent or model
nanobox chat --agent=researcher
nanobox chat --model=gpt-4o
```

See [Chat](../reference/cli/chat.md) for the full command reference.

## 4. Start the platform

```bash
nanobox start     # Web UI + worker
nanobox status    # Show running processes
nanobox stop      # Stop both
```

The worker handles gateway polling, cron jobs, security scanning, and
backups in the background -- see [Architecture](../architecture/index.md).

## Where next

- **[Reference](../reference/index.md)** -- every namespace, in depth.
- **[Agents](../reference/agents/index.md)** -- create your own persistent agents.
- **[Vault](../reference/vault/index.md)** -- import documents into NanoBox's knowledge base.
