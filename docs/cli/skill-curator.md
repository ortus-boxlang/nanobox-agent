# Skill Curator Phase

The NanoBox skill curator follows Hermes' safety model and bx-ai's two skill pools.

## Current scope

Curator-managed skills:

```text
.agents/skills-custom/
```

Registry skills under `.agents/skills/` are not modified by curator operations.

## Commands

```bash
nanobox skill curator status
nanobox skill curator run
nanobox skill curator run --dry-run
nanobox skill curator prune
nanobox skill curator pin <name>
nanobox skill curator unpin <name>
nanobox skill curator mode <name> lazy
nanobox skill curator mode <name> always-on
nanobox skill curator archive <name>
nanobox skill curator restore <name>
nanobox skill curator backup
nanobox skill curator rollback
nanobox skill curator pause
nanobox skill curator resume
```

## bx-ai activation modes

```text
lazy       → aiAgent( availableSkills: [...] )
always-on  → aiAgent( skills: [...] )
```

Activation is global, not platform-specific.

## Lifecycle

```text
active → stale → archived
```

Pinned skills bypass automatic transitions. Archives are recoverable and are never silently deleted.

## Storage

```text
.agents/skills/             Registry-installed skills
.agents/skills-custom/      Custom/agent-created skills
.agents/skills-archive/     Archived custom skills
.agents/skills-backups/     Curator backups
.agents/skills-curator.json Curator state
```

## Hermes alignment

Implemented safety boundaries:

- Registry-installed skills are read-only to curator.
- Custom skills are curator-managed.
- Pinned skills cannot be archived.
- Dry-run performs no mutations.
- Archive is recoverable.
- Backup and rollback are available.
- Pause/resume state persists.

Deferred from Hermes:

- Auxiliary-model consolidation pass
- Automatic background scheduling
- Cron-aware skill protection
- Full usage telemetry integration
- Human-readable curator reports

Those require mature activation telemetry and are planned as follow-up work.

## Tests

```text
tests/specs/SkillCuratorSpec.bx
```

Verified behaviors:

- Status counts
- Lazy/always-on mode metadata
- Pin protection
- Archive/restore
- Backup
- Rollback support
- Pause/resume
- Dry-run safety
