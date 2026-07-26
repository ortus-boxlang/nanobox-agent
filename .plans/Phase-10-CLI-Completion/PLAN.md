# NanoBox — CLI Completion Plan

> **Date:** 2026-07-24
> **Status:** Draft — awaiting approval
> **Scope:** Complete all gaps identified in the CLI codebase analysis (2026-07-24 git pull)
> **Prerequisite:** All 19 CLI commands are fully implemented (0 stubs). This plan addresses the **gaps** between CLI interface and backend functionality.

---

## Executive Summary

All 19 CLI command files and 6 CLI core files are fully implemented with no stubs. The gaps are **integration issues** — features exist in the model layer but are not wired into execution paths, or model-layer methods always return errors.

| Metric | Value |
|---|---|
| CLI command files | 19 (all implemented, 0 stubs) |
| CLI core files | 6 (all complete) |
| Model-layer classes | 20+ (all have real logic) |
| Test spec files | 63 |
| **Critical gaps** | 5 (middleware, tokens, tool paths, security handler, chat context) |
| **Medium gaps** | 3 (update/rollback, learning engine CLI, /compress stub) |
| **Low gaps** | 7 (gateway stubs) |

---

## Phase 0 — Quick Wins (Fix Integration Gaps)

These are low-effort fixes that unlock existing functionality. Estimated: **2-3 hours total**.

### Task 0.1 — Wire Middleware into Chat/Agent Flows

**Problem:** `SecurityMiddleware` and `OsToolMiddleware` are fully implemented but never instantiated or registered in `ChatCommand`, `AgentManager.run()`, or `InteractiveChat`. They have tests but are orphan code.

**Files affected:**
- `cli/commands/ChatCommand.bx`
- `cli/InteractiveChat.bx`
- `models/agents/AgentManager.bx`

**Steps:**
1. In `ChatCommand.init()`, instantiate `SecurityMiddleware` and `OsToolMiddleware` (read `models/middleware/SecurityMiddleware.bx` and `models/middleware/OsToolMiddleware.bx` for constructor signatures).
2. In `ChatCommand.execute()`, call middleware validation before `aiChat()` — run `SecurityMiddleware.scan(query)` and `OsToolMiddleware.check(query)` to validate input.
3. In `InteractiveChat`, register middleware in the slash-command handler so each REPL message is validated.
4. In `AgentManager.run()`, apply the same middleware chain before delegating to the bx-ai agent loop.
5. Add a test: `tests/specs/MiddlewareIntegrationSpec.bx` that verifies middleware blocks a query with a blocked tool reference.

**Acceptance:** A chat query containing a blocked tool name is rejected by SecurityMiddleware before reaching the LLM. A query triggering a dangerous OS command triggers OsToolMiddleware's HITL approval flow.

---

### Task 0.2 — Wire TokenTracker.record() in ChatCommand

**Problem:** `ChatCommand.execute()` returns `usage: {}` (empty struct) at line 50. Token tracking is never actually invoked after `aiChat()` calls.

**Files affected:**
- `cli/commands/ChatCommand.bx` (line ~50)
- `models/util/TokenTracker.bx`

**Steps:**
1. In `ChatCommand.execute()`, after `aiChat()` returns, extract the `usage` struct from the response.
2. Call `variables.tokenTracker.record(query, response, usage)` to persist the token event.
3. Return the usage struct to the CLI output so users see token consumption.
4. Add a test: `tests/specs/TokenRecordingSpec.bx` that verifies token events are persisted after a chat call.

**Acceptance:** After `nanobox chat --query="hello"`, running `nanobox token` shows the recorded event with correct query/response/token counts.

---

### Task 0.3 — Fix ToolManager.refresh() Path Mismatch

**Problem:** Line 41 of `ToolManager.bx` scans `/cli/tools` via `expandPath("/cli")` but tools live under `models/tools/`. The `coreDir` path is wrong; only `bxai` FileSystemTools gets registered.

**Files affected:**
- `models/tools/ToolManager.bx` (line ~41)

**Steps:**
1. Change `expandPath("/cli")` to `expandPath("/models/tools")` in `ToolManager.refresh()`.
2. Verify all tool source directories are scanned: `bxai`, `nanobox` (from models/tools/), and user-installed tools.
3. Add a test: `tests/specs/ToolManagerRefreshSpec.bx` that verifies all tool sources are discovered after `refresh()`.

**Acceptance:** `nanobox tool refresh` discovers tools from all three sources (bxai, nanobox, user) instead of only bxai.

---

### Task 0.4 — Add `security` CLI Command Handler

**Problem:** `CommandRuntime` dispatches `security` to a private `security()` method (lines 203-207), but there's no `SecurityCommand.bx` in `cli/commands/`. This works but doesn't follow the established pattern.

**Files affected:**
- `cli/CommandRuntime.bx` (lines 203-207)
- New file: `cli/commands/SecurityCommand.bx`

**Steps:**
1. Create `cli/commands/SecurityCommand.bx` with actions: `scan`, `report`, `status`.
2. Wire it to `SecurityCzar` — `scan` triggers a tick, `report` returns the latest scan report, `status` shows policy summary.
3. Update `CommandRuntime.bx` to dispatch `security` to `SecurityCommand` instead of the private method (or remove the private method).
4. Add a test: `tests/specs/SecurityCommandSpec.bx`.

**Acceptance:** `nanobox security scan` runs a security scan, `nanobox security report` shows the latest report, `nanobox security status` shows policy summary.

---

### Task 0.5 — Wire Session Message History to LLM

**Problem:** `ChatCommand` calls `aiChat(query)` with the raw query string. It doesn't load previous messages from `SessionManager` to build conversation context. Each chat turn is a fresh request.

**Files affected:**
- `cli/commands/ChatCommand.bx`
- `models/sessions/SessionManager.bx`

**Steps:**
1. In `ChatCommand.execute()`, after getting the query, call `SessionManager.loadMessages(sessionId)` to retrieve conversation history.
2. Build a message array: `[...previousMessages, { role: "user", content: query }]`.
3. Pass the message array to `aiChat()` instead of a raw string.
4. After `aiChat()` returns, save the assistant response back to `SessionManager`.
5. Add a test: `tests/specs/ChatConversationSpec.bx` that verifies multi-turn context is sent to the LLM.

**Acceptance:** `nanobox chat --query="What's my name?"` followed by `nanobox chat --query="Where do I live?"` correctly sends both messages as conversation context to the LLM.

---

## Phase 1 — Medium-Priority Features

These add new CLI capabilities or complete partial implementations. Estimated: **4-6 hours total**.

### Task 1.1 — Implement UpdateManager.update() and rollback()

**Problem:** Lines 85-99 of `UpdateManager.bx` always return errors. No release artifact download/apply logic exists.

**Files affected:**
- `models/system/UpdateManager.bx`

**Steps:**
1. Implement `update(version)`:
   - Download the release tarball from GitHub API (`assets[].browser_download_url` filtered by OS/arch).
   - Extract to a version directory under `~/.nanobox/versions/<version>/`.
   - Atomically update the `~/.nanobox/current` symlink to point to the new version.
   - Verify the new version works with a dry-run check.
   - On success, update the symlink; on failure, keep the old version.
2. Implement `rollback()`:
   - Find the previous version from `listLocal()`.
   - Atomically update the `~/.nanobox/current` symlink.
   - Verify the rolled-back version works.
3. Add atomic symlink swap (read current symlink, write new symlink, verify, rollback on failure).
4. Add a test: `tests/specs/UpdateManagerSpec.bx` that mocks the GitHub API and verifies update/rollback.

**Acceptance:** `nanobox update --version=0.2.0` downloads, extracts, and activates a new version. `nanobox rollback` reverts to the previous version. Both are atomic and safe.

---

### Task 1.2 — Create LearningEngine CLI Command

**Problem:** `models/skills/LearningEngine.bx` provides `observe()` and `consolidate()` but there is no `LearningCommand.bx` in `cli/commands/` to expose it.

**Files affected:**
- New file: `cli/commands/LearningCommand.bx`
- `models/skills/LearningEngine.bx` (already exists)

**Steps:**
1. Create `cli/commands/LearningCommand.bx` with actions:
   - `status` — show learning engine state (observations count, last consolidate time, skill count).
   - `observe` — manually trigger observation of recent sessions/skills.
   - `consolidate` — run the consolidation algorithm to extract reusable patterns.
   - `report` — show extracted skills and patterns.
2. Wire to `LearningEngine` instance in `CommandRuntime`.
3. Add a test: `tests/specs/LearningCommandSpec.bx`.

**Acceptance:** `nanobox learning status` shows engine state, `nanobox learning consolidate` extracts patterns, `nanobox learning report` shows extracted skills.

---

### Task 1.3 — Implement InteractiveChat /compress

**Problem:** Returns a fixed message "Context compression is not required for this session" (line 128) with no actual implementation.

**Files affected:**
- `cli/InteractiveChat.bx` (line ~128)

**Steps:**
1. Implement `/compress` to:
   - Count total tokens in the current session.
   - If over a threshold (e.g., 80% of model context window), compress conversation history.
   - Compression strategy: summarize older messages, keep recent messages intact.
   - Replace compressed history in the session store.
2. Return a message indicating compression status (compressed or not needed).
3. Add a test: `tests/specs/InteractiveChatCompressSpec.bx`.

**Acceptance:** `/compress` in a long session summarizes older messages and returns the compressed token count. In a short session, it reports "no compression needed."

---

## Phase 2 — Gateway Implementations (Lower Priority)

These are the 7 gateway stubs. Each requires API integration work. Estimated: **8-12 hours per gateway**.

### Task 2.1 — Implement Remaining Gateways

**Problem:** Only Telegram has real API integration. The other 7 gateways inherit `BaseGateway`'s no-op `connect()` and `send()`.

**Gateways to implement:**

| Gateway | API | Complexity | Priority |
|---|---|---|---|
| DiscordGateway | Discord REST + WebSocket | Medium | High (popular) |
| EmailGateway | SMTP (BoxLang `cfmail` equivalent) | Low | High (essential) |
| SlackGateway | Slack API (Bolt framework) | Medium | Medium |
| WhatsAppGateway | WhatsApp Cloud API | Medium | Medium |
| WhatsAppBusinessGateway | WhatsApp Business API | High | Low |
| SignalGateway | Signal API (libsignal) | High | Low |
| SMSGateway | Twilio/Plivo API | Low | Medium |

**Steps (per gateway):**
1. Read `models/gateway/BaseGateway.bx` for the interface contract.
2. Implement `connect()` — authenticate with the API, establish connection.
3. Implement `send()` — deliver a message to a recipient.
4. Implement `getUpdates()` — receive incoming messages (for Telegram-like gateways).
5. Implement `disconnect()` — clean up connection.
6. Add a test: `tests/specs/<GatewayName>Spec.bx`.

**Acceptance:** Each gateway passes its spec tests with a valid configuration (API key/token).

---

## Phase 3 — Documentation & Testing

### Task 3.1 — Update CLI Documentation

**Steps:**
1. Update `docs/cli/` documentation for all commands that changed in Phase 0/1.
2. Add documentation for new commands: `security`, `learning`.
3. Add integration test documentation.

### Task 3.2 — Add Integration Test Suite

**Steps:**
1. Create `tests/specs/CLIFullIntegrationSpec.bx` — end-to-end tests covering:
   - Config → Chat → Token tracking flow
   - Session creation → multi-turn chat → session show
   - Skill install → agent run → skill activation
   - Cron create → cron run → cron stats
2. Create `tests/specs/GatewayIntegrationSpec.bx` — tests for all 8 gateways.

---

## Implementation Order (Recommended)

Execute in this order, respecting dependencies:

```
Phase 0 (Quick Wins):
  0.1  Wire Middleware into Chat/Agent Flows
  0.2  Wire TokenTracker.record() in ChatCommand
  0.3  Fix ToolManager.refresh() Path Mismatch
  0.4  Add `security` CLI Command Handler
  0.5  Wire Session Message History to LLM

Phase 1 (Medium Priority):
  1.1  Implement UpdateManager.update() and rollback()
  1.2  Create LearningEngine CLI Command
  1.3  Implement InteractiveChat /compress

Phase 2 (Gateways — Optional):
  2.1  Implement DiscordGateway
  2.2  Implement EmailGateway
  2.3  Implement SlackGateway
  2.4  Implement WhatsAppGateway
  2.5  Implement WhatsAppBusinessGateway
  2.6  Implement SignalGateway
  2.7  Implement SMSGateway

Phase 3 (Documentation & Testing):
  3.1  Update CLI Documentation
  3.2  Add Integration Test Suite
```

---

## Risk Assessment

| Risk | Likelihood | Mitigation |
|---|---|---|
| Gateway API rate limits during testing | Medium | Use mock/stub gateways for CI tests |
| UpdateManager atomic symlink swap on macOS | Low | Test on target OS; use `symlink()` BIF |
| LearningEngine consolidation produces low-quality output | Medium | Start with simple pattern extraction; iterate |
| Middleware integration breaks existing chat behavior | Medium | Extensive regression tests before merge |

---

## Acceptance Criteria for v0.1.0

When all Phase 0 and Phase 1 tasks are complete:

1. **All 19 CLI commands** work end-to-end with real backend integration
2. **Middleware** is active in all chat/agent execution paths
3. **Token tracking** records and displays token usage
4. **Tool discovery** finds tools from all sources (bxai, nanobox, user)
5. **Security scanning** is accessible via CLI
6. **Chat context** is preserved across turns
7. **Updates** can be downloaded and applied atomically
8. **Learning engine** is accessible via CLI
9. **Interactive chat** supports context compression
10. **All 63 existing tests** pass

---

## Notes

- This plan assumes the user prefers **one phase at a time** with implementation, tests, documentation, real CLI verification, and explicit approval before proceeding.
- Phase 2 (gateways) is optional and can be deferred indefinitely — Telegram is the only fully wired gateway and may be sufficient for the v0.1.0 release.
- The `boxlang schedule` integration in `WorkerCommand` and `WorkerSupervisor` is already complete (from the git pull) — no additional work needed there.
