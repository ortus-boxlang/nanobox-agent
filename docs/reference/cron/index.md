---
title: "Cron Jobs"
order: 7
description: "Scheduling background tasks on the NanoBox worker, plus the platform's built-in scheduled tasks."
icon: "⏰"
---

# Cron Jobs

NanoBox uses BoxLang's scheduler concepts for scheduling tasks. The long-running worker owns and executes the scheduler; it does not launch a separate scheduler process. The `cron` command manages task definitions consumed by that worker.

## CLI

```bash
nanobox cron list
nanobox cron create my-job --schedule="0 9 * * 1" --prompt="Write weekly article..."
nanobox cron show my-job
nanobox cron pause my-job
nanobox cron resume my-job
nanobox cron run my-job
nanobox cron delete my-job
nanobox cron stats
```

## Built-in Tasks

| Task | Schedule | Description |
|------|----------|-------------|
| Gateway polling | Every 1s | Poll messaging platforms for new messages |
| Security scan | Every 60m | Scan for threats |
| Learning consolidation | Every 60m | De-duplicate + consolidate facts |
| Backup | Daily at 4 AM | Backup config, agents, vault, memory |
| Learning prune | Daily at 3 AM | Remove stale facts |
| Security report | Weekly Monday 8 AM | Generate security report to vault |
