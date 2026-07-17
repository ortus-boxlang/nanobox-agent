# Phase 5 — Gateways

**Objective:** All 8 messaging gateways operational with HITL support.

**Dependencies:** Phase 4 must be complete with all tests passing.

## Tasks

| # | Task | Test | Depends On |
|---|------|------|------------|
| 1 | BaseGateway | `tests/unit/BaseGatewayTest.bx` | Phase 1 |
| 2 | GatewayRegistry | `tests/unit/GatewayRegistryTest.bx` | 1 |
| 3 | TelegramGateway | `tests/integration/TelegramGatewayTest.bx` | 1, 2 |
| 4 | EmailGateway | `tests/integration/EmailGatewayTest.bx` | 1, 2 |
| 5 | DiscordGateway | `tests/integration/DiscordGatewayTest.bx` | 1, 2 |
| 6 | SlackGateway | `tests/integration/SlackGatewayTest.bx` | 1, 2 |
| 7 | WhatsAppGateway | `tests/integration/WhatsAppGatewayTest.bx` | 1, 2 |
| 8 | WhatsAppBusinessGateway | `tests/integration/WhatsAppBusinessGatewayTest.bx` | 1, 2 |
| 9 | SignalGateway | `tests/integration/SignalGatewayTest.bx` | 1, 2 |
| 10 | SMSGateway | `tests/integration/SMSGatewayTest.bx` | 1, 2 |
| 11 | GatewayCommand | `tests/unit/GatewayCommandTest.bx` | 1-10 |

## Acceptance

```
$ nanobox gateway status
┌─────────────┬─────────┬────────────────────┬──────────────────┐
│ Platform    │ Status  │ Connected Since    │ Messages Today   │
├─────────────┼─────────┼────────────────────┼──────────────────┤
│ telegram    │ ✅ running │ 2026-07-14 09:00 │ 23               │
│ email       │ ⚪ disabled│ —                  │ —                │
│ discord     │ ⚪ disabled│ —                  │ —                │
│ whatsapp    │ ❌ error │ —                  │ Auth failed      │
└─────────────┴─────────┴────────────────────┴──────────────────┘
```
