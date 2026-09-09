---
title: "Skill Telemetry"
order: 15
description: "How NanoBox records patch and update activity for skills."
---

# Skill patch telemetry

NanoBox records patch/update activity in:

```text
.agents/skills-custom/<name>/.usage.json
```

Patch events include:

```text
registry installation
registry refresh/update replacement
explicit recordPatch() calls
```

Fields:

```text
patchCount
activityCount
lastPatchedAt
lastActivityAt
```

Public manager APIs:

```boxlang
skillManager.recordUse( "skill-name" )
skillManager.recordPatch( "skill-name" )
```

Tests:

```text
tests/specs/SkillPatchTelemetrySpec.bx
tests/specs/SkillUseTelemetrySpec.bx
tests/specs/SkillTelemetrySpec.bx
```
