## BoxLang Modules

NanoBox uses project-local BoxLang modules. Install them with the BoxLang module installer using `--local`:

```bash
install-bx-module bx-ai bx-sqlite --local
```

This creates:

```text
boxlang_modules/
├── bx-ai/
└── bx-sqlite/
```

The project runtime configuration includes `${user-dir}/boxlang_modules` in `modulesDirectory`, so running BoxLang from the NanoBox project root automatically discovers and loads these modules.

Verify installed local modules:

```bash
install-bx-module --list --local
```

The current required modules are:

| Module | Purpose |
|---|---|
| `bx-ai` | AI providers, models, agents, tools, memory, and streaming |
| `bx-sqlite` | SQLite persistence for sessions, facts, tokens, and audit data |

CommandBox may be used to install project dependencies such as TestBox. It is not required to execute the TestBox suite; tests run with the pure BoxLang runner:

```bash
./testbox/run
```
