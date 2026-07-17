# Phase 11 — Interactive Chat Surfaces (as-built 2026-07-17)

## Objective

Provide NanoBox with three complete chat surfaces:

1. `nanobox chat --query` — one-shot structured response
2. `nanobox -z` — one-shot response text only for scripts/pipelines
3. `nanobox chat` — persistent interactive Pi-style terminal chat

## Hermes-inspired parity

The interactive chat will support the core Hermes session commands:

```text
/help
/model
/model <name>
/new
/clear
/retry
/undo
/title <name>
/usage
/status
/sessions
/resume <id>
/compress
/quit
/exit
```

NanoBox-specific behavior remains BoxLang/bx-ai based.

## Scope

- Persistent SQLite sessions and messages
- Default and named model selection
- Session resume and title management
- One-shot output modes
- ANSI-aware terminal renderer
- Tool/assistant activity presentation
- Safe non-interactive behavior
- TestBox and live LM Studio verification

## Current State (2026-07-17)

- **`InteractiveChat.bx` exists** at `cli/InteractiveChat.bx` — implements the REPL loop, slash-command parsing, session management.
- **`InteractiveChatRenderer.bx` exists** at `cli/InteractiveChatRenderer.bx` — renders assistant responses, command help, status bars.
- **Slash-commands partially wired** — `/help`, `/model`, `/new`, `/clear`, `/quit`, `/exit` are implemented; others (`/retry`, `/undo`, `/title`, `/usage`, `/status`, `/sessions`, `/resume`, `/compress`) need verification.
- **No namespace works end-to-end** — blocked by import-path breakage in `CommandRuntime.bx` (Task 4).

The full interactive surface is not complete until each command is wired through the active `nanobox.bx` entry point and verified with a real terminal smoke test.

**Ready for v0.1.0?** ❌ No — foundations exist but blocked by import paths (Task 4); verify all slash-commands end-to-end (Task 6).