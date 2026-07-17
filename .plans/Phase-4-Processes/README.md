# Phase 4 — Processes

**Objective:** Background web + worker processes with PID tracking. The worker owns and executes the scheduler; there is no standalone scheduler process or scheduler CLI command.

**Dependencies:** Phase 3 must be complete with all tests passing.

## Tasks (as-built 2026-07-17)

| # | Task | Test | Depends On | Status |
|---|------|------|------------|--------|
| 1 | ProcessManager | `tests/unit/ProcessManagerTest.bx` | Phase 1 | ✅ Complete — lives at `models/system/ProcessManager.bx` |
| 2 | WebCommand | `tests/integration/WebCommandTest.bx` | 1 | ✅ Complete — lives at `cli/commands/WebCommand.bx` |
| 3 | WorkerCommand | `tests/integration/WorkerCommandTest.bx` | 1 | 🟡 Exists at `cli/commands/WorkerCommand.bx` but will be moved to `worker/cli/WorkerCommand.bx` (Task 5) |
| 4 | Worker-owned Scheduler | Manual | 1, 2, 3 | ❌ Stub only — `models/scheduling/Scheduler.bx` is a boolean stub; real implementation needed in `worker/core/Scheduler.bx` (Task 5) |
| 5 | LearningEngine | `tests/unit/LearningEngineTest.bx` | Phase 1 | ⬜ Not found in codebase — may have been removed or renamed |
| 6 | SecurityCzar | `tests/integration/SecurityCzarTest.bx` | Phase 2.4 | ✅ Complete — lives at `models/security/SecurityCzar.bx` |

## Acceptance (verified 2026-07-17)

```bash
$ nanobox start
# → BROKEN: import paths in CommandRuntime reference non-existent cli.X classes

$ nanobox status
# → BROKEN: same issue

$ nanobox stop
# → BROKEN: same issue
```

**Ready for v0.1.0?** ❌ No — ProcessManager and commands exist, but the scheduler is a stub and needs to be moved into `worker/` with a real implementation (Task 5). Import paths also need fixing (Task 4).
