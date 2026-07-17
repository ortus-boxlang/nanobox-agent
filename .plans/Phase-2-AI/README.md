# Phase 2 — AI

**Objective:** Working AI chat with orchestrator agent, middleware stack, token tracking, vault, and OS tool safety.

**Dependencies:** Phase 1 must be complete with all tests passing.

## Tasks (as-built 2026-07-17)

| # | Task | Test | Depends On | Status |
|---|------|------|------------|--------|
| 1 | TokenTracker | `tests/unit/TokenTrackerTest.bx` | Phase 1 | ✅ Complete — lives at `models/util/TokenTracker.bx` |
| 2 | OsToolMiddleware | `tests/unit/OsToolMiddlewareTest.bx` | Phase 1 | ✅ Complete — lives at `models/middleware/OsToolMiddleware.bx` |
| 3 | ChatCommand | `tests/integration/ChatCommandTest.bx` | 1, 2 | ✅ Complete — lives at `cli/commands/ChatCommand.bx`, uses bx-ai |
| 4 | SecurityMiddleware | `tests/unit/SecurityMiddlewareTest.bx` | Phase 1 | ✅ Complete — lives at `models/middleware/SecurityMiddleware.bx` |
| 5 | VaultManager | `tests/integration/VaultManagerTest.bx` | Phase 1 | ✅ Complete — lives at `models/vault/VaultManager.bx` |

## Acceptance (verified 2026-07-17)

```bash
$ nanobox chat -q "What is BoxLang?"
# → BROKEN: import paths in CommandRuntime reference non-existent cli.X classes

$ nanobox vault search "scheduling"
# → BROKEN: same import-path issue

$ nanobox tokens
# → BROKEN: same import-path issue
```

**Ready for v0.1.0?** ❌ No — all classes exist and are implemented, but the CLI runtime can't reach them due to broken imports (Task 4). Once fixed, verify end-to-end (Task 6).
