# Skills and Vault Namespaces

## Skills

NanoBox stores installed skills as directories containing `SKILL.md` files.

Default paths:

```text
~/.nanobox/skills/
~/.nanobox/skills-custom/
```

### Local commands

```bash
nanobox skill list
nanobox skill show <name>
nanobox skill search <query>
nanobox skill create <name>
nanobox skill remove <name>
```

Create a custom skill:

```bash
nanobox skill create boxlang-style \
  --description="BoxLang coding conventions" \
  --content="Use tabs and TestBox specifications."
```

Custom skills are stored separately from registry-managed skills so refresh operations do not overwrite them.

### Registry commands

NanoBox connects to:

```text
https://skills.boxlang.io
```

Commands:

```bash
nanobox skill find
nanobox skill find boxlang
nanobox skill find --owner=ortus-boxlang --repo=skills
nanobox skill install <owner>/<repo>/<skill>
nanobox skill install <owner>/<repo>/<skill> --force
nanobox skill refresh
```

Registry installation uses the ColdBox CLI-inspired API shape:

```text
POST /api/install
GET  /api/skills/<owner>/<repo>
```

Installed registry skills are tracked in:

```text
~/.nanobox/skills-manifest.json
```

The manifest records owner, repository, slug, SHA when supplied, and installation time.

### Skill metadata

Each skill provides:

```text
name
description
content
path
custom
```

Skills are compatible with bx-ai `aiAgent()` skill loading and can be used as agent knowledge assets.

## Vault

The vault stores imported local documents by category.

Default path:

```text
~/.nanobox/vault/
```

Categories:

```text
reports
research
imported
manual
```

### Vault commands

```bash
nanobox vault list
nanobox vault list --category=research
nanobox vault import <file>
nanobox vault search <query>
nanobox vault show <id>
nanobox vault index
nanobox vault export <id> [--output=<file>]
nanobox vault remove <id>
```

Import example:

```bash
nanobox vault import ./research.md \
  --category=research \
  --tags=boxlang,research
```

Vault metadata and content are indexed in the `nanobox` SQLite datasource (`nanobox_vault_documents` table, `data/nanobox.db`). `vault index` re-scans files on disk and upserts them into SQLite.

## Security and persistence

- Skill and vault paths are created automatically.
- Local custom skills are separate from remote skills.
- Vault documents preserve category and tags.
- Registry/API failures return structured errors.
- No credentials are required for the public skills registry.

## Reference

The remote skills workflow is inspired by the ColdBox CLI implementation at:

```text
/Users/lmajano/Sites/projects/commandbox-modules/coldbox-cli
```

The relevant ColdBox CLI operations are:

```text
skills find
skills install
skills list
skills refresh
skills remove
skills create
skills override
```

NanoBox uses a smaller native namespace while retaining the remote-first registry and local/custom separation.

## Tests

```text
tests/specs/SkillsVaultNamespaceSpec.bx
tests/specs/SkillsVaultActiveCliSpec.bx
tests/specs/VaultManagerSpec.bx
```
