# NanoBox Chat Surfaces

NanoBox provides three chat modes.

## One-shot structured chat

```bash
nanobox chat --query="Explain BoxLang"
nanobox chat -q "Explain BoxLang"
```

Returns structured JSON containing:

- Response content
- Provider
- bx-ai service provider
- Model
- Named model, when used
- Success/error status

## `-z` response-only mode

```bash
nanobox -z "Explain BoxLang"
```

`-z` is intended for shell scripts and pipelines. It prints only the assistant response text:

```bash
answer=$(nanobox -z "Summarize this file")
printf '%s\n' "$answer"
```

It does not print JSON, banners, model metadata, or status lines. Errors still return a non-zero exit code.

The explicit equivalent is also supported:

```bash
nanobox chat -z "Explain BoxLang"
```

## Interactive chat

```bash
nanobox chat
```

NanoBox opens a persistent terminal session with:

```text
┌─ NanoBox Chat ─────────────────────────────────────────────┐
│ Session: <id>                                             │
│ Type /help for commands, /exit to quit                    │
└────────────────────────────────────────────────────────────┘

You ›
```

Regular messages are sent to bx-ai and both user and assistant messages are persisted in the SQLite session store.

## Interactive slash commands

```text
/help
/model
/model <named-model>
/model <model>
/new
/clear
/retry
/undo
/title <name>
/usage
/status
/sessions
/resume <session-id>
/compress
/quit
/exit
```

### `/model`

Shows the current provider, model, and named model.

```text
/model local-coder
```

Selects a configured named model. The active default selection is persisted through the model registry.

### Session commands

```text
/new                  Start a new SQLite-backed session
/title My project     Set the current session title
/status               Show session/model state
/sessions             List recent sessions
/resume <id>          Resume a stored session
/clear                Clear in-memory conversation display state
/retry                Send the previous user message again
/undo                 Remove the last in-memory exchange
```

## Model selection

Interactive chat uses the same model resolution as one-shot chat:

```text
explicit named model
→ configured default named model
→ explicit provider/model
→ configured default provider/model
```

Named models contain:

```text
name
provider
model
options
```

Use one from the command line:

```bash
nanobox chat --query="Write BoxLang" --named-model=local-coder
```

## Sessions

Every interactive session creates a SQLite-backed session record. Messages are stored in:

```text
nanobox datasource: nanobox
```

Inspect sessions with:

```bash
nanobox session list
nanobox session show <id>
nanobox session search <query>
```

## Hermes relationship

NanoBox follows Hermes' three chat surfaces:

```text
hermes
    → interactive chat
hermes chat -q "..."
    → one-shot structured CLI chat
hermes -z "..."
    → response-only scripting mode
```

NanoBox keeps the same user-facing separation while using BoxLang, bx-ai, `SessionManager`, and NanoBox's own terminal renderer.

The interactive renderer is intentionally being expanded toward a Pi-style experience with stronger streaming, tool activity, history navigation, and richer ANSI layout.
