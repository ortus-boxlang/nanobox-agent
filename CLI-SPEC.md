# NanoBox CLI Specification

## Entry Point

The `nanobox` command is a shell wrapper that delegates to the active `nanobox.bx` class.

| OS | File | Mechanism |
|----|------|-----------|
| macOS / Linux | `nanobox` (bash) | Resolves `~/.nanobox/current/nanobox.bx` |
| Windows | `nanobox.bat` | Resolves the active `nanobox.bx` |
| Windows | `nanobox.ps1` | Resolves the active `nanobox.bx` |

The actual logic lives in `nanobox.bx` — a BoxLang class that uses `CLIGetArgs()` for argument parsing.

---

## Command Tree

```
nanobox
├── start [--web-only] [--worker-only] [--debug]
├── stop [--web-only] [--worker-only]
├── status [--json]
├── restart [--web-only] [--worker-only]
├── doctor
│
├── chat
│   ├── (interactive)          ── REPL-like chat loop
│   └── -q, --query "..."      ── One-shot query
│
├── session
│   ├── list [--limit=N]       ── Recent sessions
│   ├── show <id>              ── Session transcript
│   ├── search <query>         ── FTS5 search
│   └── prune [--older-than=N] ── Clean old sessions
│
├── cron
│   ├── list [--group=]        ── List scheduled jobs
│   ├── create <name>          ── Create a cron job (interactive)
│   │   --schedule=<cron>
│   │   --prompt="..."
│   │   --skills=<skills>
│   │   --group=<group>
│   ├── show <name>            ── Show job details + stats
│   ├── pause <name>           ── Pause a job
│   ├── resume <name>          ── Resume a job
│   ├── run <name>             ── Run immediately
│   ├── delete <name>          ── Remove a job
│   └── stats [--json]         ── Job execution stats
│
├── config
│   ├── show [--json]          ── Show current config
│   ├── get <key>              ── Get a config value
│   ├── set <key> <value>      ── Set a config value
│   ├── unset <key>            ── Remove a config value
│   ├── provider               ── Provider sub-commands
│   │   ├── list               ── List configured providers
│   │   ├── set <name>         ── Set default provider
│   │   └── add <name>         ── Add/configure a provider (interactive)
│   └── model                  ── Model sub-commands
│       ├── list               ── List discovered/configured models
│       ├── current            ── Show active provider and model
│       ├── set <model>        ── Set default model
│       └── refresh             ── Rediscover models from providers
│
├── agent
│   ├── list                   ── List available agent templates
│   ├── create <name>          ── Create a new agent
│   ├── show <name>            ── Show agent config
│   └── run <name>             ── Run a configured agent
│
├── skill
│   ├── list                   ── List loaded skills
│   ├── show <name>            ── Show skill content
│   └── search <query>         ── Search skills
│
├── tool
│   ├── list                   ── List all tools with enabled/disabled status
│   ├── show <key>             ── Show tool details
│   ├── enable <key>           ── Enable a tool for agents
│   ├── disable <key>          ── Disable a tool
│   ├── status                 ── Summary: total/enabled/disabled
│   └── refresh                ── Re-scan sources, rebuild disk index
│
nanobox gateway
├── setup [--platform=] [--token-env=] [--non-interactive]
├── list|status
├── connect <name>
├── disconnect <name>
├── enable <name>
├── disable <name>
├── restart <name>
├── test|health <name>
├── log [--lines=50]
├── clear-log
├── remove <name>
├── send <name> <recipient> <message>
└── broadcast <recipient> <message>
│
├── --help, -h                 ── Show help
├── --version, -v              ── Show version
└── --debug                    ── Enable debug output
```

---

## Global Options

These can appear anywhere on the command line:

| Option | Description |
|--------|-------------|
| `--debug` | Enable debug output |
| `-h, --help` | Show help |
| `-v, --version` | Show version |

---

## Detailed Command Specs

### `nanobox start`

Starts the background processes. Default: starts both.

```
nanobox start [--web-only] [--worker-only] [--debug]
```

- `--web-only` — Start only the MiniServer web UI
- `--worker-only` — Start only the scheduler worker (gateway + cron)
- `--debug` — Start processes in debug mode

**Behavior:**
1. Checks PID files in `~/.nanobox/run/` for existing processes
2. Launches `boxlang-miniserver` as background process (web)
3. Launches `boxlang schedule` as background process (worker)
4. Writes PID files and reports status

**Exit codes:** `0` = started, `1` = already running, `2` = error

---

### `nanobox stop`

Stops background processes gracefully.

```
nanobox stop [--web-only] [--worker-only]
```

- Uses PID files and sends SIGTERM (Unix) / taskkill (Windows)
- Waits up to 10s for graceful shutdown, then SIGKILL

**Exit codes:** `0` = stopped, `1` = not running, `2` = error

---

### `nanobox status`

Reports running processes.

```
nanobox status [--json]
```

| Platform | Output |
|----------|--------|
| Default | Table with PID, uptime, memory |
| `--json` | Machine-readable JSON |

---

### `nanobox restart`

Stops then starts.

```
nanobox restart [--web-only] [--worker-only]
```

---

### `nanobox doctor`

Runs health checks on the NanoBox installation.

```
nanobox doctor
```

Checks:
- ✅ boxlang binary found
- ✅ BoxLang version meets minimum
- ✅ nanobox.json config exists and is valid
- ✅ nanobox.bx can be parsed
- ✅ Required modules installed (bx-ai, bx-sqlite)
- ✅ SQLite session DB accessible
- ✅ API keys configured for at least one provider
- ✅ Pid directory writable
- ✅ Web UI reachable (if running)
- ✅ Worker task stats (if running)

---

## Core lifecycle

```bash
nanobox start [--web-only|--worker-only] [--debug] [--host=HOST] [--port=PORT]
nanobox stop [--web-only|--worker-only]
nanobox status
nanobox restart [--web-only|--worker-only] [--debug]
nanobox doctor
```

See `docs/cli/core.md` for process ownership, JSON output, and exit behavior.

---

### `nanobox chat`

Chat uses the configured default model or an explicit named model. See `docs/cli/chat.md`.

```bash
nanobox chat --query="Your question"
nanobox chat -q "Your question"
nanobox chat --query="Your question" --named-model=<name>
nanobox chat --query="Your question" --provider=<provider> --model=<model>
```

### `nanobox model`

Interactive provider/model setup and discovery. See `docs/cli/models.md`.

```bash
nanobox model current
nanobox model setup [provider]
nanobox model list [--provider=<name>]
nanobox model refresh [--provider=<name>]
nanobox model set <model> [--provider=<name>]
```

#### Interactive setup flow

Running `nanobox model` without arguments opens a guided flow:

1. Choose a provider type:
   - Built-in provider, such as OpenAI, Anthropic, Gemini, Ollama, or OpenRouter
   - OpenAI-compatible local/server endpoint
   - Custom compatible endpoint
2. Enter the endpoint URL when required, defaulting local providers to their standard URL.
3. Enter an API key when required. Local providers may use a harmless placeholder key when the server does not authenticate.
4. NanoBox calls the provider's model-list endpoint when available.
5. Display discovered models with provider, local/remote status, context/capabilities when available.
6. Select the default model interactively.
7. Test the selected provider/model with a non-destructive connection check.
8. Persist the provider configuration and selected model without storing secrets in the JSON file.

Example LM Studio flow:

```
$ nanobox model

Select a provider
❯ LM Studio (OpenAI-compatible)
  Ollama
  OpenAI
  Anthropic
  Custom OpenAI-compatible endpoint

Endpoint [http://localhost:1234/v1]:

Checking LM Studio ... connected
Discovering models ... 3 found

Select a model
❯ qwen2.5-coder-32b-instruct
  llama-3.3-70b-instruct
  mistral-small-24b-instruct

Default model set to lmstudio/qwen2.5-coder-32b-instruct
```

Provider discovery behavior:

- OpenAI-compatible endpoints use `GET {baseURL}/models` where supported.
- LM Studio uses its OpenAI-compatible `/v1/models` endpoint.
- Ollama uses its native model listing endpoint and normalizes the result.
- Providers that do not expose model discovery use a curated/default model list plus manual model entry.
- Discovery failures never erase existing configuration; the user can retry, enter a model manually, or cancel.
- Results are cached with a timestamp and refreshed with `model refresh`.
- API keys, authorization headers, and secret-bearing error bodies are never printed.

Model identifiers are normalized as `provider/model`; provider model IDs containing slashes remain intact after the first separator.

Resolution order for a chat or agent run:

1. CLI `--provider`/`--model` override
2. Agent-specific provider/model
3. Session-specific provider/model
4. Global `bx-ai.defaultProvider`/`defaultModel`
5. Provider-defined default

**Acceptance:** A fresh installation can select LM Studio, discover its locally loaded models, choose one, persist it, display it with `nanobox model current`, and use it with `nanobox chat` without manually editing JSON.

---

### `nanobox session`

See `docs/cli/sessions.md` for the complete session lifecycle, transcript, search, export, prune, statistics, and interactive-chat integration.

---

### `nanobox cron`

Manage scheduled agent tasks (cron jobs) via BoxLang's scheduler.

```
nanobox cron list [--group=<group>] [--json]
nanobox cron create <name>
    --schedule=<cron|every|at>
    --prompt="..."
    [--skills=<comma-separated>]
    [--group=<group>]
    [--model=<model>]
    [--tools=<comma-separated>]
nanobox cron show <name>
nanobox cron pause <name>
nanobox cron resume <name>
nanobox cron run <name>
nanobox cron delete <name>
nanobox cron stats [--json]
```

**`create`** interactive fields (when not provided via flags):
1. Task name
2. Schedule (cron expression or `every X [seconds|minutes|hours|days]`)
3. Prompt to execute
4. Skills to load (comma-separated)
5. Group (default: "default")
6. Model override (optional)
7. Tools to enable (comma-separated, optional)

**`stats`** shows execution metrics for all jobs:

```
NAME                      GROUP     RUNS  FAILURES  LAST RUN    DURATION
────                      ─────     ────  ────────  ────────    ────────
boxlang-ai-article        cron      3     0          09:02:15    45s
telegram-poll             gateway   15234 2          09:03:01    120ms
```

---

## Config namespace

See `docs/cli/config.md` for the complete, verified command set, provider/model compatibility aliases, storage, redaction, and failure behavior.

### `nanobox config`

Read/write NanoBox configuration (`nanobox.json`).

```
nanobox config show [--json]
nanobox config get <key>
nanobox config set <key> <value>
nanobox config unset <key>
nanobox config provider list
nanobox config provider set <name>
nanobox config provider add <name>
nanobox config model list
nanobox config model current
nanobox config model set <model>
nanobox config model refresh
```

Config file: `~/.nanobox/nanobox.json` (or `./nanobox.json` project-level)

**Config structure:**
```json
{
  "bx-ai": {
    "defaultProvider": "lmstudio",
    "defaultModel": "local-model-name",
    "providers": {
      "lmstudio": {
        "type": "openai-compatible",
        "baseURL": "http://localhost:1234/v1",
        "apiKey": "lm-studio",
        "model": "local-model-name"
      },
      "openai": { "apiKey": "...", "model": "gpt-4o" },
      "claude": { "apiKey": "...", "model": "claude-sonnet-4" }
    }
  },
  "nanobox": {
    "web": {
      "port": 8080,
      "host": "127.0.0.1",
      "webroot": "./public"
    },
    "sessions": {
      "maxSessions": 1000,
      "pruneAfterDays": 90
    },
    "cron": {
      "enabled": true,
      "maxJobs": 50
    },
    "gateway": {
      "telegram": { "token": "..." }
    }
  }
}
```

---

### `nanobox agent`

See `docs/cli/agents.md` for the complete agent definition lifecycle and bx-ai execution behavior.

---

### `nanobox skill`

See `docs/cli/skill-curator.md` for Hermes-aligned custom-skill maintenance, activation modes, dry-runs, pinning, archive/restore, backup/rollback, and tests.

---

### `nanobox tool`

List, inspect, and manage AI function-calling tools from all sources (bx-ai built-in, NanoBox shipped, user-installed).

```
nanobox tool list
nanobox tool show <key>
nanobox tool enable <key>
nanobox tool disable <key>
nanobox tool status
nanobox tool refresh
```

---

### `nanobox gateway`

Manage configured messaging gateways. `setup` is interactive by default and stores only non-secret configuration; credentials use environment-variable references.

```bash
nanobox gateway setup [--platform=telegram] [--token-env=TELEGRAM_BOT_TOKEN]
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

Gateway log: `~/.nanobox/logs/gateways.log`.

---

### `nanobox doctor` — Health Check

Runs a full diagnostic:

```
✅ boxlang binary: /usr/local/bin/boxlang
✅ BoxLang version: 1.15.0
✅ Config: ~/.nanobox/nanobox.json (valid)
✅ bx-ai module: installed
✅ bx-sqlite module: installed
✅ Provider: openai (gpt-4o) — API key: configured
✅ Provider: claude (claude-sonnet-4) — API key: missing
⚠️  Web UI: not running
✅ Worker: running (pid 45231, uptime 2h 13m)
```

---

## PID File Convention

Background processes store PID files in `~/.nanobox/run/`:

```
~/.nanobox/run/
├── web.pid      ← MiniServer PID
└── worker.pid   ← Scheduler PID
```

---

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error / already running / not found |
| 2 | Config error (missing, invalid) |
| 3 | Process error (failed to start/stop) |
| 4 | Dependency error (missing binary, module) |

---

## Environment Variables

| Variable | Description |
|----------|-------------|
| `NANOBOX_HOME` | Override config directory (default: `~/.nanobox`) |
| `NANOBOX_DEBUG` | Enable debug mode |
| `NANOBOX_WEB_PORT` | Override web UI port |
| `NANOBOX_WEB_HOST` | Override web UI host |
| `NANOBOX_CONFIG` | Override config file path |

BoxLang `.env` files are also loaded automatically:
- `~/.box.env` — user-level
- `.env` — project-level (in cwd)

---

## Output Conventions

- **Tables**: Pretty-printed with column alignment via `printTable()` or manual formatting
- **JSON**: `--json` flag switches any command to JSON output for scripting
- **Colors**: Auto-detected; use colors for interactive, plain for piped
- **Errors**: Always go to stderr, never stdout
- **Progress**: Spinner or dots for long operations (use `CLIClear()` for spinner)