# NanoBox — Agent Operations Contract

> **Purpose:** NanoBox is a BoxLang-based autonomous agent CLI platform. This file defines how work happens here: architectural rules, layer responsibilities, build/test commands, documentation conventions, and release workflow. Every AI assistant, human contributor, and CI pipeline must read this file before making changes.

---

## Project Layout

```
nanobox/
│   ├── Application.bx              # Root app config (datasource definition)
│   ├── AGENTS.md                    # ← You are reading this
│   ├── box.json                     # BoxLang project manifest
│   ├── install.sh                   # Installation script
│   ├── nanobox                      # macOS/Linux launcher (bash)
│   ├── nanobox.bat                  # Windows launcher (batch)
│   ├── nanobox.ps1                  # Windows launcher (PowerShell)
│   │
│   ├── cli/                         # Interface layer — CLI surface only
│   │   ├── nanobox.bx               # Entry point (main class)
│   │   ├── CommandRuntime.bx        # Executes commands, manages state
│   │   ├── CoreLifecycleCommand.bx  # start/stop/status/restart/doctor
│   │   ├── InteractiveChat.bx       # REPL loop + slash-command parsing
│   │   ├── InteractiveChatRenderer.bx # Terminal rendering for chat
│   │   ├── SetupOnboarding.bx       # Terminal renderer for setup wizard
│   │   └── commands/                # One command class per CLI namespace
│   │       ├── AgentCommand.bx
│   │       ├── BackupCommand.bx
│   │       ├── BrowserCommand.bx    # Java Playwright automation
│   │       ├── ChatCommand.bx
│   │       ├── ConfigCommand.bx
│   │       ├── CronCommand.bx
│   │       ├── GatewayCommand.bx
│   │       ├── ImageCommand.bx      # aiImage() CLI wrapper
│   │       ├── LogCommand.bx        # Log file viewer
│   │       ├── MCPCommand.bx
│   │       ├── MemoryCommand.bx     # User memory CRUD
│   │       ├── ModelCommand.bx
│   │       ├── ScriptCommand.bx
│   │       ├── SecurityCommand.bx   # Security scan/report/status
│   │       ├── SessionCommand.bx
│   │       ├── SetupCommand.bx      # Interactive onboarding wizard
│   │       ├── SkillActivationCommand.bx
│   │       ├── SkillCommand.bx
│   │       ├── SkillCuratorCommand.bx
│   │       ├── SpeakCommand.bx      # aiSpeak() CLI wrapper (+ tts alias)
│   │       ├── TokenCommand.bx
│   │       ├── ToolCommand.bx
│   │       ├── UpdateCommand.bx
│   │       ├── VaultCommand.bx
│   │       ├── WebCommand.bx
│   │       └── WorkerCommand.bx
│   │
│   ├── models/                      # Domain layer — bounded contexts
│   │   ├── system/                  # Core system services
│   │   │   ├── BackupManager.bx
│   │   │   ├── ConfigManager.bx
│   │   │   ├── DownloadManager.bx   # HTTP downloads with progress bars
│   │   │   ├── LogManager.bx        # Log file listing/searching/clearing
│   │   │   ├── MemoryManager.bx     # SQLite-backed user memory CRUD
│   │   │   ├── ProcessManager.bx    # PID tracking, process lifecycle
│   │   │   ├── ScriptManager.bx
│   │   │   └── UpdateManager.bx
│   │   ├── util/
│   │   │   ├── PrettyCli.bx         # Terminal output toolkit
│   │   │   └── TokenTracker.bx      # LLM token usage (SQLite)
│   │   ├── agents/
│   │   │   ├── AgentManager.bx      # Agent templates, creation, execution
│   │   │   └── McpManager.bx        # MCP server registry
│   │   ├── gateway/                 # Messaging gateways
│   │   ├── scheduling/
│   │   │   └── CronManager.bx       # Cron job storage (SQLite)
│   │   ├── security/
│   │   │   └── SecurityCzar.bx      # File scanning, policy enforcement
│   │   ├── sessions/
│   │   │   ├── SessionManager.bx    # SQLite-backed session store
│   │   │   └── SessionSchema.bx     # DB schema initialisation
│   │   ├── skills/
│   │   │   ├── SkillManager.bx
│   │   │   ├── SkillCurator.bx
│   │   │   └── CuratorReportManager.bx
│   │   ├── tools/                   # Tool management + AI tool classes
│   │   │   ├── ToolManager.bx       # Tool enable/disable, disk index
│   │   │   ├── BrowserManager.bx    # Java Playwright wrapper
│   │   │   ├── BrowserTools.bx      # 11 @AITool browser actions
│   │   │   ├── ConfigTools.bx       # 2 @AITool config actions
│   │   │   ├── CronTools.bx         # 2 @AITool cron actions
│   │   │   ├── LogTools.bx          # 4 @AITool log actions
│   │   │   ├── MemoryTools.bx       # 4 @AITool memory actions
│   │   │   ├── SecurityTools.bx     # 1 @AITool security action
│   │   │   ├── SessionTools.bx      # 2 @AITool session actions
│   │   │   ├── SkillTools.bx        # 2 @AITool skill actions
│   │   │   ├── SystemTools.bx       # 1 @AITool system action
│   │   │   ├── TokenTools.bx        # 1 @AITool token action
│   │   │   └── VaultTools.bx        # 2 @AITool vault actions
│   │   ├── vault/
│   │   │   └── VaultManager.bx
│   │   ├── middleware/
│   │   │   ├── OsToolMiddleware.bx
│   │   │   └── SecurityMiddleware.bx
│   │   └── providers/
│   │       └── ProviderCommand.bx
│   │
│   ├── worker/                      # Long-running supervisor
│   │   ├── README.md
│   │   ├── nanobox-worker.bx
│   │   ├── core/
│   │   │   ├── WorkerSupervisor.bx
│   │   │   └── Scheduler.bx
│   │   ├── cli/
│   │   │   └── WorkerCommand.bx
│   │   └── tests/specs/
│   │       ├── WorkerSupervisorSpec.bx
│   │       └── SchedulerSpec.bx
│
├── tests/                       # TestBox specs
│   ├── Application.bx           # TestBox application bootstrap
│   └── specs/                   # All test specs
│       ├── *ActiveCli*Spec.bx   # End-to-end CLI tests through nanobox.bx
│       ├── *Namespace*Spec.bx   # Single-namespace integration tests
│       └── *Spec.bx             # Unit/integration tests
│
├── .plans/                      # Phase plans and audit docs
│   ├── PLAN.md                  # Top-level roadmap
│   ├── CLI-SPEC.md              # Canonical command tree
│   ├── CLI-AUDIT-2026-07-17.md  # Import-path breakage audit
│   ├── Phase-1-Core-CLI/        # Phase 1 tasks
│   ├── Phase-2-AI/              # Phase 2 tasks
│   ├── Phase-3-Commands/        # Phase 3 tasks
│   ├── Phase-4-Processes/       # Phase 4 tasks
│   ├── Phase-5-Gateways/        # Phase 5 tasks
│   ├── Phase-6-Web-UI/          # Blocked until Phase 10
│   ├── Phase-7-Browser-Tool/    # Blocked until Phase 10
│   ├── Phase-8-Packaging/       # Blocked until Phase 10
│   ├── Phase-10-CLI-Completion/ # Phase 10 status + README
│   └── Phase-11-Interactive-Chat/ # Phase 11 status
│
├── docs/                        # Documentation
│   ├── cli/                     # CLI namespace docs
│   │   ├── README.md            # CLI overview
│   │   ├── core.md              # Core lifecycle docs
│   │   ├── chat.md              # Chat command docs
│   │   ├── models.md            # Model/provider docs
│   │   ├── config.md            # Config namespace docs
│   │   ├── sessions.md          # Session management docs
│   │   ├── agents.md            # Agent docs
│   │   ├── skills.md            # Skill docs
│   │   ├── tools.md             # Tool docs
│   │   ├── vault.md             # Vault docs
│   │   ├── cron.md              # Cron docs
│   │   ├── gateway.md           # Gateway docs
│   │   └── ...                  # Other namespace docs
│   └── api/                     # Generated DocBox API docs (do not hand-edit)
│
├── lib/modules/                 # Third-party BoxLang modules
│   ├── bx-ai/                   # LLM provider abstraction
│   ├── bx-sqlite/               # SQLite database driver
│   └── testbox/                 # TestBox testing framework
│
├── web/                         # ColdBox web application (deferred to v0.2.0)
│
├── config/                      # Project-level config templates
│   ├── boxlang.json             # BoxLang compiler config
│   └── nanobox.json             # Default NanoBox config
│
└── .agents/                     # Agent customization files
    ├── skills/                  # Custom skills
    ├── skills-archive/          # Archived skills
    ├── skills-backups/          # Skill backups
    ├── skills-custom/           # User-defined skills
    ├── skills-manifest.json     # Skill registry
    └── curator-reports/         # Curator report outputs
```

---

## Architectural Rules

### Layer Contract (Pinned)

- **`cli/`** is the *interface layer*. Only CLI surface classes live here:
  - Entry point (`nanobox.bx`), dispatcher (`CommandDispatcher.bx`), runtime (`CommandRuntime.bx`)
  - Core lifecycle (`CoreLifecycleCommand.bx`), interactive chat (`InteractiveChat.bx`, `InteractiveChatRenderer.bx`)
  - Command classes (`cli/commands/*Command.bx`) — one per CLI namespace
- **`models/`** is the *domain layer*, partitioned by bounded context:
  - `models/system/` — core system services (ConfigManager, ProcessManager, etc.)
  - `models/util/` — shared utilities (PrettyCli, TokenTracker)
  - `models/{agents,gateway,scheduling,security,sessions,skills,tools,vault,middleware,providers}/` — domain-specific managers
- **`worker/`** — long-running supervisor (Scheduler, WorkerSupervisor, WorkerCommand). Populated in Task 5.
- **`lib/modules/`** — third-party BoxLang modules only (testbox, bx-ai, bx-sqlite). No custom code here.

### Import-Path Rule (Enforced from v0.1.0)

Instantiate domain classes as `models.<package>.<Class>`, **never** `cli.<Class>` for non-UI classes.

```boxlang
✅ new "models.system.ConfigManager"()
✅ new "models.sessions.SessionManager"()
✅ new "models.gateway.GatewayRegistry"()
❌ new "cli.SessionManager"()
❌ new "cli.util.ConfigManager"()
```

**Exception:** Command classes remain in `cli/commands/` and are instantiated as `cli.commands.*Command`. This is correct — they are part of the interface layer.

### No New Top-Level Folders

Do not create new top-level directories without explicit approval. The current layout is the canonical structure.

---

## Layer Responsibilities

| Layer | Owns | Examples |
|-------|------|----------|
| `cli/` | CLI surface, argument parsing, command routing, terminal rendering | `nanobox.bx`, `CommandDispatcher.bx`, `cli/commands/*Command.bx`, `InteractiveChat.bx` |
| `models/<pkg>/` | One bounded domain each | `models/system/ConfigManager.bx`, `models/gateway/GatewayRegistry.bx`, `models/sessions/SessionManager.bx` |
| `worker/` | Long-running supervisor, scheduler execution, gateway runtime | `worker/core/Scheduler.bx`, `worker/core/WorkerSupervisor.bx`, `worker/cli/WorkerCommand.bx` |
| `lib/modules/` | Third-party BoxLang modules | `bx-ai`, `bx-sqlite`, `testbox` |
| `.plans/` | Phase plans, audit docs, CLI spec | `PLAN.md`, `CLI-SPEC.md`, `Phase-*/README.md` |
| `docs/` | User-facing documentation, generated API docs | `docs/cli/*.md`, `docs/api/` (generated) |

---

## Build & Test

### Prerequisites

- **BoxLang** installed (via BVM or system package manager)
- **BoxLang modules** installed: `bx-ai`, `bx-sqlite`, `testbox` (auto-installed by `install.sh`)

### Local Development Install

```bash
# Install locally (creates .nanobox/ beside the project)
./install.sh --local

# Run the local dev wrapper
./nanobox-dev doctor
./nanobox-dev status
./nanobox-dev chat -q "Hello"
```

### Global Install

```bash
# Install to ~/.nanobox with wrapper in ~/.local/bin
./install.sh

# Ensure ~/.local/bin is in PATH
export PATH="$HOME/.local/bin:$PATH"

# Verify
nanobox --version
nanobox doctor
```

### Run Tests

```bash
# Run all tests
boxlang testbox/run --directory=tests.specs

# Run unit tests only
boxlang testbox/run --directory=tests.specs --bundles-pattern=*Spec*.bx

# Run a specific spec
boxlang testbox/run tests/specs/ConfigCommandSpec.bx
```

### Generate API Docs

```bash
# Generate DocBox API documentation
boxlang docbox generate --source cli/,models/,worker/ --output docs/api/

# View generated docs
open docs/api/index.html
```

### Smoke Test Harness

```bash
# Quick smoke test (after import-path fixes in Task 4)
boxlang bin/smoke-cli.bx
# → Runs nanobox --version, nanobox doctor, nanobox status
```

---

## Run Locally

### Start Processes

```bash
# Start both web UI and worker
nanobox start

# Start web UI only
nanobox start --web-only

# Start worker only (scheduler + gateways)
nanobox start --worker-only

# Start in debug mode
nanobox start --debug
```

### Stop Processes

```bash
# Stop both
nanobox stop

# Stop web UI only
nanobox stop --web-only

# Stop worker only
nanobox stop --worker-only
```

### Check Status

```bash
# Human-readable table
nanobox status

# Machine-readable JSON
nanobox status --json
```

### Doctor Check

```bash
# Run health checks
nanobox doctor
```

---

## DocBox Convention

Every public class **must** carry DocBox tags. Use this template:

```boxlang
/**
 * Component for managing user sessions with SQLite persistence.
 *
 * @autowire false
 * @singleton
 */
component {

    /**
     * The session storage path.
     *
     * @property
     */
    property name="storagePath";

    /**
     * Create a new session with the given title.
     *
     * @function
     * @param title The session title
     * @param provider Optional LLM provider override
     * @param model Optional LLM model override
     * @return Struct with session ID and metadata
     */
    struct function create( required string title, string provider = "", string model = "" ) {
        // ...
    }

}
```

### Required Tags

- **`@component`** — on every public class (with description)
- **`@function`** — on every public function (with description)
- **`@param`** — on every function parameter (name + description)
- **`@return`** — on every function that returns a value (type + description)
- **`@property`** — on every public property (with description)
- **`@throws`** — on functions that may throw exceptions (optional but recommended)

### Generation

```bash
# Generate API docs (CI gate — must exit 0 with no warnings)
boxlang docbox generate --source cli/,models/,worker/ --output docs/api/ --strict
```

The `--strict` flag fails if any public class/function is missing DocBox tags. This is a hard CI gate from v0.1.0 forward.

---

## Testing Convention

### Spec Location

All TestBox specs live at `tests/specs/**/*Spec.bx`.

### Spec Types

- **`*ActiveCli*Spec.bx`** — End-to-end tests through the full `nanobox.bx` runtime. These verify that a namespace works through the real CLI entry point.
- **`*Namespace*Spec.bx`** — Integration tests for a single CLI namespace (e.g., `config`, `session`, `agent`). These test the command class directly but still exercise the full command flow.
- **`*Spec.bx`** — Unit/integration tests for individual classes, managers, or utilities.

### Running Specs

```bash
# Run all specs
boxlang testbox/run --directory=tests.specs

# Run ActiveCli specs only (end-to-end)
boxlang testbox/run --directory=tests.specs --bundles-pattern=*ActiveCli*Spec.bx

# Run a specific namespace
boxlang testbox/run tests/specs/ConfigNamespaceSpec.bx
```

### Writing Specs

Use TestBox's BDD syntax:

```boxlang
component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "ConfigCommand", () => {
            beforeEach( () => {
                variables.config = new "models.system.ConfigManager"();
                variables.command = new "cli.commands.ConfigCommand"( variables.config );
            });

            it( "shows config as JSON", () => {
                var result = variables.command.execute( "show", { json: true } );
                expect( result.success ).toBeTrue();
                expect( result.config ).toBeStruct();
            });

            it( "gets a config value", () => {
                var result = variables.command.execute( "get", { key: "nanobox.web.port" } );
                expect( result.success ).toBeTrue();
                expect( result.value ).toBeNumeric();
            });
        });
    }

}
```

---

## Versioning & Release

### Semver

NanoBox follows [Semantic Versioning](https://semver.org/):

- **MAJOR** — Breaking changes to CLI API or config schema
- **MINOR** — New features, backward-compatible additions
- **PATCH** — Bug fixes, documentation updates

### Branch Model

- **`main`** — Released versions only. Tagged releases live here.
- **`development`** — In-flight work. All PRs merge here first.

### Release Workflow

1. Complete all tasks for the target version (e.g., Tasks 1-8 for v0.1.0)
2. Bump version in `box.json`, `install.sh`, and `cli/nanobox.bx`
3. Run smoke checklist (`docs/RELEASE-CHECKLIST.md`)
4. Open release PR: `development` → `main`
5. Merge PR after review
6. Tag release: `git tag -s v0.1.0 -m "NanoBox v0.1.0"`
7. Push tag: `git push origin v0.1.0`

---

## Glossary

| Term | Definition |
|------|------------|
| **Worker** | Long-running background process that owns the scheduler and gateway runtime. Lives in `worker/`. |
| **Curator** | Automated skill evaluation system that generates reports on skill quality, usage, and telemetry. Managed by `SkillCurator.bx`. |
| **Vault** | Knowledge base for storing documents, research notes, and imported content. Indexed for full-text search via `VaultManager.bx`. |
| **Gateway** | Messaging platform integration (Telegram, Slack, Discord, etc.). Each gateway implements the `IGateway` contract. |
| **Skill** | Reusable capability module that agents can load. Skills live in `.agents/skills/` and are managed by `SkillManager.bx`. |
| **Tool** | Function that agents can call during execution. Tools are enabled/disabled per agent via `ToolManager.bx`. |
| **Agent** | Configured AI assistant with specific instructions, skills, and tools. Agents are created and run via `AgentManager.bx`. |
| **Session** | Persistent chat conversation stored in SQLite. Sessions support resume, search, export, and prune via `SessionManager.bx`. |
| **Schedule** | Cron-like job that runs an agent prompt on a recurring basis. Managed by `CronManager.bx` and executed by the worker. |

---

## Do Not

- ❌ **No new top-level folders** — The current layout is canonical. Propose changes via PR.
- ❌ **No raw `bx-ai` calls outside the provider layer** — All LLM interactions go through `bx-ai`'s provider abstraction.
- ❌ **No `cli.X` for domain classes** — Use `models.<package>.<Class>` for all non-UI classes.
- ❌ **No silent error swallowing** — All errors must be logged and returned to the user with actionable messages.
- ❌ **No hand-editing `docs/api/`** — This directory is generated by `boxlang docbox`. Edit source code, then regenerate.
- ❌ **No secrets in JSON config** — API keys, tokens, and passwords live in `~/.nanobox/config/.env` (chmod 600), never in `nanobox.json`.
- ❌ **No blocking the main thread** — Long-running operations (chat, cron jobs, gateway connections) must be async or delegated to the worker.

---

## Further Reading

- **CLI Specification:** `.plans/CLI-SPEC.md` — Canonical command tree with all namespaces, actions, and options.
- **Phase Plans:** `.plans/Phase-*/README.md` — Detailed task lists for each development phase.
- **CLI Audit:** `.plans/CLI-AUDIT-2026-07-17.md` — Import-path breakage diagnosis and fix plan.
- **Architecture Memory:** `/memories/repo/architecture.md` — Pinned architectural contract (layer boundaries, import paths).
- **Session Plan:** `/memories/session/plan.md` — Current reset plan with 8 tasks leading to v0.1.0.
