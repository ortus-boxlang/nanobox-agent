---
title: "Curator Scheduling"
order: 12
description: "Curator runs from the existing NanoBox worker lifecycle rather than a separate process."
---

# Worker-owned curator scheduling

Curator now runs from the existing NanoBox worker lifecycle.

```text
worker starts
→ scheduler starts
→ curator tick executes
→ worker repeats lifecycle tick
```

No standalone curator daemon is created.

## Controls

```text
curator.enabled
curator.paused
curator.intervalHours
curator.staleAfterDays
curator.archiveAfterDays
```

The lifecycle skips when:

- Curator is disabled
- Curator is paused
- The configured interval has not elapsed

Reports are generated only for an executed curator run, not interval/paused skips.

## Tests

```text
tests/specs/CuratorWorkerLifecycleSpec.bx
tests/specs/CuratorLifecycleSpec.bx
```
