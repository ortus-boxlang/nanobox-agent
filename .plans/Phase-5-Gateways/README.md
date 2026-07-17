# Phase 5 — Gateways

**Objective:** All 8 messaging gateways operational with HITL support.

**Dependencies:** Phase 4 must be complete with all tests passing.

## Tasks (as-built 2026-07-17)

| # | Task | Test | Depends On | Status |
|---|------|------|------------|--------|
| 1 | BaseGateway | `tests/unit/BaseGatewayTest.bx` | Phase 1 | ✅ Complete — lives at `models/gateway/BaseGateway.bx` |
| 2 | GatewayRegistry | `tests/unit/GatewayRegistryTest.bx` | 1 | ✅ Complete — lives at `models/gateway/GatewayRegistry.bx` |
| 3 | TelegramGateway | `tests/integration/TelegramGatewayTest.bx` | 1, 2 | ✅ Complete — lives at `models/gateway/TelegramGateway.bx` |
| 4 | EmailGateway | `tests/integration/EmailGatewayTest.bx` | 1, 2 | ✅ Complete — lives at `models/gateway/EmailGateway.bx` |
| 5 | DiscordGateway | `tests/integration/DiscordGatewayTest.bx` | 1, 2 | ✅ Complete — lives at `models/gateway/DiscordGateway.bx` |
| 6 | SlackGateway | `tests/integration/SlackGatewayTest.bx` | 1, 2 | ✅ Complete — lives at `models/gateway/SlackGateway.bx` |
| 7 | WhatsAppGateway | `tests/integration/WhatsAppGatewayTest.bx` | 1, 2 | ✅ Complete — lives at `models/gateway/WhatsAppGateway.bx` |
| 8 | WhatsAppBusinessGateway | `tests/integration/WhatsAppBusinessGatewayTest.bx` | 1, 2 | ✅ Complete — lives at `models/gateway/WhatsAppBusinessGateway.bx` |
| 9 | SignalGateway | `tests/integration/SignalGatewayTest.bx` | 1, 2 | ✅ Complete — lives at `models/gateway/SignalGateway.bx` |
| 10 | SMSGateway | `tests/integration/SMSGatewayTest.bx` | 1, 2 | ✅ Complete — lives at `models/gateway/SMSGateway.bx` |
| 11 | GatewayCommand | `tests/unit/GatewayCommandTest.bx` | 1-10 | ✅ Complete — lives at `cli/commands/GatewayCommand.bx` |

## Acceptance (verified 2026-07-17)

```bash
$ nanobox gateway status
# → BROKEN: import paths in CommandRuntime reference non-existent cli.X classes
```

**Ready for v0.1.0?** ❌ No — all 8 gateway classes + registry + command exist and are implemented, but the CLI runtime can't reach them due to broken imports (Task 4). Once fixed, verify end-to-end (Task 6).
