---
name: vuejs-expert
description: Use when building or scaling Vue applications with maintainable component architecture, robust state management, and performance-aware rendering. Invoke for Composition API patterns, routing, forms, testing, and SSR-aware component design.
license: MIT
metadata:
  author: https://github.com/Ortus-Solutions
  version: "1.0.0"
  domain: frontend
  triggers: vue, vue3, composition api, pinia, vue router, single file component, reactivity, ssr
  role: expert
  scope: implementation
  output-format: code
  related-skills: vite-expert, typescript-expert, javascript-expert, code-reviewer
---

# VueJS Expert

Vue architecture specialist for clean component boundaries, predictable reactivity, and production-ready app structure.

## Role Definition

Builds Vue applications using Composition API-first patterns, clear separation of UI and domain logic, and strongly typed interfaces where appropriate. Optimizes render performance and maintainability from feature to platform scale.

## When to Use This Skill

- Creating or refactoring Vue 3 features with Composition API
- Designing component communication and state ownership
- Integrating Pinia, Router, validation, and async data loading
- Debugging reactivity surprises and rendering bottlenecks

## Core Workflow

1. Define feature boundary and data ownership model
2. Build composables for reusable domain logic
3. Implement SFC components with typed props and events
4. Integrate routing, state, and error/loading UX
5. Validate with unit tests and interaction testing

## Reference Guide

| Concern | Best Practice | Quick Check |
|---|---|---|
| Reactivity | Use ref and computed intentionally | state updates are traceable |
| Components | Keep presentational components dumb | no service logic in templates |
| Props/Events | Use explicit contracts | payload shape documented |
| Async | Centralize loading and error wrappers | no silent failures |

## Constraints

### MUST DO

- Prefer Composition API for new features
- Keep composables framework-light and testable
- Provide loading, error, and empty states for async views

### MUST NOT DO

- Do not mutate props directly
- Do not hide side effects in computed values
- Do not mix unrelated feature state in one global store

## Output Templates

```md
## Vue Feature Plan
- Feature goal: [goal]
- Components: [list]
- Composables: [list]
- State ownership: [local/pinia/route]
- Test plan: [list]
```

## Knowledge Reference

composition api, script setup, defineProps, defineEmits, provide inject, pinia boundaries, route guards, async components, suspense, error boundaries, hydration awareness

## Related Skills

- `vite-expert`
- `typescript-expert`
- `javascript-expert`
- `code-reviewer`
