---
title: "Skills"
order: 9
description: "NanoBox skills are local SKILL.md instruction packages, supporting custom and registry-managed skills."
---

# Skills Namespace

NanoBox skills are local `SKILL.md` instruction packages. The namespace supports custom skills and registry-managed skills from `skills.boxlang.io`.

## Commands

### Local skills

```bash
nanobox skill list
nanobox skill show <name>
nanobox skill search <query>
nanobox skill create <name> --description="..." --content="..."
nanobox skill remove <name>
```

Custom skills are stored under:

```text
~/.nanobox/skills-custom/<name>/SKILL.md
```

Registry-managed skills are stored under:

```text
~/.nanobox/skills/<name>/SKILL.md
```

### Remote registry

```bash
nanobox skill find
nanobox skill find <query>
nanobox skill find --category=boxlang-developer
nanobox skill install <owner>/<repo>/<slug>
nanobox skill install <owner>/<repo>/<slug> --force
nanobox skill refresh
```

The default registry is:

```text
https://skills.boxlang.io
```

The live catalog endpoint is:

```text
GET /api/skills/ortus-boxlang/skills
```

Registry responses are normalized from the envelope:

```json
{
    "data": {
        "pagination": {},
        "data": []
    }
}
```

Installation uses:

```text
POST /api/install
```

with `owner`, `repo`, and `skill` form fields.

### Installation metadata

Installed registry skills are recorded in:

```text
~/.nanobox/skills-manifest.json
```

Manifest records include:

```text
name
owner
repo
slug
sha
audit_status
installedAt
```

Custom skills are excluded from registry refresh operations.

## Security behavior

- Registry requests have structured failure results.
- An install is rejected if no `SKILL.md` content is returned.
- Existing registry skills require `--force` before replacement.
- Custom skills are kept separate from downloaded skills.
- Registry audit metadata is preserved when supplied.
- Skill credentials are not required or stored.

## ColdBox CLI reference

The workflow is based on the existing ColdBox CLI implementation at:

```text
/Users/lmajano/Sites/projects/commandbox-modules/coldbox-cli
```

Relevant reference operations:

```text
find
install
list
refresh
remove
create
```

## Tests

Focused specs:

```text
tests/specs/SkillsRegistryLiveSpec.bx
tests/specs/SkillsRegistryInstallSpec.bx
tests/specs/SkillsVaultNamespaceSpec.bx
tests/specs/SkillsVaultActiveCliSpec.bx
```

Run:

```bash
BOXLANG_CONFIG="$PWD/config/boxlang.json" \
./testbox/run \
  --bundles=tests.specs.SkillsRegistryLiveSpec,tests.specs.SkillsRegistryInstallSpec,tests.specs.SkillsVaultNamespaceSpec,tests.specs.SkillsVaultActiveCliSpec \
  --write-report=false \
  --properties-summary=false
```
