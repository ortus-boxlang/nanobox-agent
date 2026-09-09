---
title: "Security"
order: 9
description: "NanoBox's three layers of security: the BoxLang runtime sandbox, SecurityMiddleware, and the scheduled SecurityCzar scanner."
icon: "phosphor-duotone:shield-check"
---

# Security

## Overview

NanoBox has three layers of security:

1. **BoxLang runtime** — `disallowedBIFs`, `disallowedImports`, `disallowedComponents` in `boxlang.json`
2. **SecurityMiddleware** — Real-time interception of every agent run (prompt injection, secret leakage, dangerous tool calls)
3. **SecurityCzar** — Scheduled scanning of skills, agents, tools, and memory for threats

## Middleware

The `SecurityMiddleware` intercepts:

- **beforeToolCall** — Checks if tool is blocked, validates arguments for dangerous patterns
- **beforeLLMCall** — Checks for prompt injection in system prompt and messages
- **afterAgentRun** — Checks for secret leakage in responses

HITL is provided by bx-ai's standardized `HumanInTheLoopMiddleware`, not by the transport gateways. Gateways advertise presentation capabilities only. For example, a gateway can advertise `hitlModes: [ "web" ]`, while bx-ai owns the approval lifecycle: `suspend()` → `approve()`/`reject()`/`cancel()` → `agent.resume()`.

## OS Tool Safety

The `OsToolMiddleware` wraps `systemExecute()` calls with a human-in-the-loop prompt:

```
⚠️  The agent wants to run: git push origin main --force
Allow? [once] [session] [always] [deny]
```

The allowlist is stored in `~/.nanobox/config/allowlist.json`.

## SecurityCzar

A scheduled task that runs every 60 minutes:

- Scans skills for injected prompts
- Scans agent definitions for jailbreak attempts
- Scans memory facts for secrets (API keys, tokens)
- Scans cron jobs for unsafe patterns
- Scans user tools for dangerous callbacks
- Generates daily and weekly security reports to the vault

## Quarantine

When a threat is detected at `error` or `critical` level:

1. The original is copied to `~/.nanobox/quarantine/{type}/{name}-{timestamp}.bak`
2. The original is disabled (skill renamed, cron paused, fact flagged)
3. An alert is logged to `nanobox-security.log`
4. If configured, a notification is sent

## CLI

```bash
nanobox security scan
nanobox security report
nanobox security quarantine list
nanobox security quarantine restore <name>
nanobox security log
nanobox security status
```
