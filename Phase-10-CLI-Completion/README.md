# Phase 10 — Fully Functional CLI

**Objective:** Make every documented NanoBox CLI namespace fully functional through the active `nanobox.bx` entry point, with complete command parsing, real execution, structured output, actionable errors, and end-to-end TestBox coverage.

**Reference:** Inspect `/Users/lmajano/Sites/projects/boxlings/BoxLings.bx` and its CLI exercises before changing parsing or command architecture.

**Rule:** Complete one namespace entirely before moving to the next. A namespace is complete only when every documented action works through the real CLI, not merely by direct class invocation.

## Namespace order

1. Core lifecycle: `start`, `stop`, `status`, `restart`, `doctor`
2. AI: `chat`, `model`
3. Configuration and persistence: `config`, `session`, `tokens`
4. Content and security: `agent`, `tool`, `skill`, `vault`, `security`
5. Automation and processes: `cron`, `web`, `worker`, `mcp`, `script`
6. Operations and gateways: `backup`, `update`, `gateway`

## Universal acceptance criteria

Every namespace must provide:

- `--help` or namespace help output
- Positional and option parsing
- Structured JSON output mode
- Human-readable output mode
- Non-zero exit codes for invalid actions and failed operations
- No placeholder handler-name output
- No unimplemented documented commands
- No secret leakage
- Direct command-class tests
- Active `nanobox.bx` end-to-end tests
- Documentation matching the actual command tree

## Per-namespace workflow

For each namespace:

1. Inspect BoxLings patterns and current NanoBox implementation.
2. Inventory documented actions and options.
3. Write failing direct and end-to-end specs.
4. Implement the smallest complete behavior.
5. Verify positional and option forms.
6. Verify success and failure exit codes.
7. Update help and documentation.
8. Run the namespace suite.
9. Only then proceed to the next namespace.

## Phase 10 completion

The phase is complete only when an exhaustive CLI matrix passes for all namespaces and the full TestBox suite is green.
