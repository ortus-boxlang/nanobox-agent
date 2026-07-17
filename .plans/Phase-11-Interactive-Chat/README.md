# Phase 11 — Interactive Chat Surfaces

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

The full interactive surface is not complete until each command is wired through the active `nanobox.bx` entry point and verified with a real terminal smoke test.