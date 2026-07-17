# Phase 2 — AI

**Objective:** Working AI chat with orchestrator agent, middleware stack, token tracking, vault, and OS tool safety.

**Dependencies:** Phase 1 must be complete with all tests passing.

## Tasks

| # | Task | Test | Depends On |
|---|------|------|------------|
| 1 | TokenTracker | `tests/unit/TokenTrackerTest.bx` | Phase 1 |
| 2 | OsToolMiddleware | `tests/unit/OsToolMiddlewareTest.bx` | Phase 1 |
| 3 | ChatCommand | `tests/integration/ChatCommandTest.bx` | 1, 2 |
| 4 | SecurityMiddleware | `tests/unit/SecurityMiddlewareTest.bx` | Phase 1 |
| 5 | VaultManager | `tests/integration/VaultManagerTest.bx` | Phase 1 |

## Acceptance

```
$ nanobox chat -q "What is BoxLang?"
🤖 BoxLang is a modern, dynamic JVM language...

$ nanobox vault search "scheduling"
Found 2 results in vault...

$ nanobox tokens
Today: 12,450 tokens used (prompt: 9,200 | completion: 3,250)
```
