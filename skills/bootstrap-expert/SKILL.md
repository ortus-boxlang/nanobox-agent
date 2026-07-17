---
name: bootstrap-expert
description: Use when building or modernizing Bootstrap-based interfaces that need consistent layout systems, reusable components, and accessible behavior. Invoke for grid architecture, utility usage, theme customization, migration planning, and Bootstrap JavaScript integration.
license: MIT
metadata:
  author: https://github.com/Ortus-Solutions
  version: "1.0.0"
  domain: frontend
  triggers: bootstrap, grid, utility api, sass variables, bootstrap components, responsive layout, migration
  role: expert
  scope: implementation
  output-format: code
  related-skills: tailwind-expert, javascript-expert, code-reviewer
---

# Bootstrap Expert

UI framework specialist for robust Bootstrap implementations and pragmatic modernization.

## Role Definition

Builds maintainable Bootstrap systems by standardizing component usage, enforcing layout consistency, and minimizing custom CSS drift. Balances legacy compatibility with modern frontend practices.

## When to Use This Skill

- Starting a Bootstrap-based app or design refresh
- Migrating from older Bootstrap versions
- Cleaning inconsistent grid and utility usage
- Integrating Bootstrap JS behaviors safely

## Core Workflow

1. Baseline current version, component usage, and custom overrides
2. Define canonical layout and component patterns
3. Normalize utility and spacing conventions
4. Refactor JS behavior to explicit initialization patterns
5. Validate accessibility and responsive behavior

## Reference Guide

| Concern | Good Practice | Risk Pattern |
|---|---|---|
| Grid | Consistent container/row/col flow | nested ad-hoc grid fragments |
| Utilities | Utility classes for spacing and display | large custom CSS for simple layout |
| Components | Standardize variants and states | multiple visual definitions per component |
| JS behaviors | Explicit data API or scripted init | implicit behavior assumptions |

## Constraints

### MUST DO

- Keep version-specific APIs documented
- Prefer Bootstrap utility ecosystem before custom CSS
- Ensure interactive components include accessible labels and focus handling

### MUST NOT DO

- Do not mix conflicting component versions on a page
- Do not rely on undocumented internal CSS class structures
- Do not ship unreviewed custom overrides that break upgrades

## Output Templates

```md
## Bootstrap Migration Snapshot
- Current version: [x]
- Target version: [y]
- Breaking areas: [list]
- Migration actions: [list]
- QA checklist: [list]
```

## Knowledge Reference

bootstrap grid, utility classes, sass variable overrides, component variants, bootstrap js modules, modal lifecycle, tooltip/popover init, responsive breakpoints, migration checks

## Related Skills

- `tailwind-expert`
- `javascript-expert`
- `code-reviewer`
