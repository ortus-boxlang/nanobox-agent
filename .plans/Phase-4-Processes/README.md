# Phase 4 — Processes

**Objective:** Background web + worker processes with PID tracking. The worker owns and executes the scheduler; there is no standalone scheduler process or scheduler CLI command.

**Dependencies:** Phase 3 must be complete with all tests passing.

## Tasks

| # | Task | Test | Depends On |
|---|------|------|------------|
| 1 | ProcessManager | `tests/unit/ProcessManagerTest.bx` | Phase 1 |
| 2 | WebCommand | `tests/integration/WebCommandTest.bx` | 1 |
| 3 | WorkerCommand | `tests/integration/WorkerCommandTest.bx` | 1 |
| 4 | Worker-owned Scheduler | Manual | 1, 2, 3 |
| 5 | LearningEngine | `tests/unit/LearningEngineTest.bx` | Phase 1 |
| 6 | SecurityCzar | `tests/integration/SecurityCzarTest.bx` | Phase 2.4 |

## Acceptance

```
$ nanobox start
✅ Web UI started (pid 45231)
✅ Worker started (pid 45232)

$ nanobox status
✅ Web UI    running (pid 45231, uptime 2h 13m)
✅ Worker    running (pid 45232, uptime 2h 13m)

$ nanobox stop
✅ Web UI stopped
✅ Worker stopped
```
