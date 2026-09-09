---
title: "Skill Activation"
order: 10
description: "How NanoBox activation metadata controls which custom skills are passed to bx-ai agents."
---

# Skill activation

NanoBox activation metadata controls how custom skills are passed to bx-ai agents.

## Commands

```bash
nanobox skill activate enable <name>
nanobox skill activate disable <name>
nanobox skill curator mode <name> lazy
nanobox skill curator mode <name> always-on
```

## bx-ai mapping

```text
enabled + lazy
    → aiAgent( availableSkills: [...] )

enabled + always-on
    → aiAgent( skills: [...] )

disabled
    → excluded from both pools
```

Registry skills are available through the lazy pool by default. Custom skill activation metadata is stored beside each skill:

```text
.agents/skills-custom/<name>/.nanobox-skill.json
```

Example:

```json
{
    "name": "project-style",
    "enabled": true,
    "mode": "always-on"
}
```

Activation is global rather than platform-specific.

## Verification

```text
tests/specs/SkillActivationSpec.bx
```

The tests verify metadata persistence, enable/disable behavior, mode persistence, and active runtime routing.
