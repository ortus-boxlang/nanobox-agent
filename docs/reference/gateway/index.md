---
title: "Gateways"
order: 8
description: "Supported messaging platforms, gateway CLI commands, configuration, and human-in-the-loop behavior."
icon: "phosphor-duotone:broadcast"
---

# Gateways

NanoBox uses one shared `IGateway` contract and one worker-owned gateway runtime. Gateways do not create independent processes; the worker owns polling, inbound dispatch, and lifecycle execution.

## Supported Platforms

| Platform | Protocol | Dependencies |
|---|---|---|
| Telegram | Bot API (long polling) | `bx:http` |
| Email | IMAP + SMTP | `bx-mail` |
| Discord | REST + Gateway Intents | `bx:http` |
| Slack | Web API | `bx:http` |
| WhatsApp | Cloud API (Meta) | `bx:http` |
| WhatsApp Business | Business API | `bx:http` |
| Signal | signal-cli daemon | `signal-cli` |
| SMS | Twilio API | `bx:http` |

## CLI

```bash
nanobox gateway setup
nanobox gateway list
nanobox gateway status
nanobox gateway connect <name>
nanobox gateway disconnect <name>
nanobox gateway enable <name>
nanobox gateway disable <name>
nanobox gateway restart <name>
nanobox gateway test <name>
nanobox gateway health <name>
nanobox gateway log [--lines=50]
nanobox gateway clear-log
nanobox gateway remove <name>
nanobox gateway send <name> <recipient> <message>
nanobox gateway broadcast <recipient> <message>
```

Gateway logs are written through BoxLang's `LoggingService` to:

```text
~/.nanobox/logs/gateways.log
```

## Configuration

Interactive setup persists non-secret configuration under the NanoBox config and stores credentials as environment-variable references:

```json
{
  "gateways": {
    "telegram": {
      "type": "telegram",
      "enabled": true,
      "config": {
        "botToken": "${TELEGRAM_BOT_TOKEN}"
      }
    }
  }
}
```

## Human-in-the-Loop

HITL lifecycle belongs to bx-ai's standardized `HumanInTheLoopMiddleware`. Gateways only advertise presentation capabilities such as `hitlModes: [ "web" ]`; they do not duplicate approval state or resume logic.
