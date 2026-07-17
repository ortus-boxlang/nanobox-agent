# Curator lifecycle, models, telemetry, reports, and protection

## Curator model

Select a named model for curator work:

```bash
nanobox model curator <named-model>
```

The selected name is stored as:

```text
bx-ai.curatorModel
```

If unset, curator uses the normal configured default named model/provider/model.

## Worker lifecycle

Curator is owned by the worker. `nanobox-worker.bx` initializes the existing scheduler and performs a curator lifecycle tick. It does not create a standalone curator process.

The lifecycle checks:

- Enabled/paused state
- Configured interval
- Cron skill references
- Agent-definition skill references
- Custom versus registry ownership

## Cron and agent protection

Custom skills referenced by cron task `skills` arrays or agent frontmatter `skills` metadata are protected from automatic stale/archive transitions.

Registry skills are always protected from curator mutation.

## Telemetry

Per-skill telemetry is read from:

```text
.agents/skills-custom/<name>/.usage.json
```

Supported fields include:

```text
useCount
viewCount
patchCount
lastUsedAt
lastViewedAt
lastPatchedAt
lastActivityAt
createdBy
```

## Reports

Every curator lifecycle run produces:

```text
.agents/curator-reports/<run-id>/run.json
.agents/curator-reports/<run-id>/REPORT.md
```

The report is imported into the vault under:

```text
.nanobox/vault/reports/
```

with `curator` and run-id tags.

## Gateway delivery

Reports are persisted locally and in the vault. Gateway delivery remains an optional worker delivery step using the existing configured gateway send/broadcast contracts. No gateway credentials are written to reports.

## Tests

```text
tests/specs/CuratorLifecycleSpec.bx
tests/specs/CuratorModelReportSpec.bx
tests/specs/SkillCuratorSpec.bx
```
