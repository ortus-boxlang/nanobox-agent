---
name: alpinejs-expert
description: Use when implementing or reviewing Alpine.js behavior in server-rendered or progressively enhanced UIs. Invoke for component state design, directives, event handling, transition behavior, reusable stores, and maintainable lightweight interactivity.
license: MIT
metadata:
  author: https://github.com/Ortus-Solutions
  version: "1.0.0"
  domain: frontend
  triggers: alpinejs, x-data, x-show, x-model, x-on, x-bind, progressive enhancement, html interactivity
  role: expert
  scope: implementation
  output-format: code
  related-skills: javascript-expert, tailwind-expert, code-reviewer
---

# AlpineJS Expert

Progressive enhancement specialist for lightweight, declarative frontend interaction.

## Role Definition

Designs Alpine.js components that remain readable in templates, avoid hidden state coupling, and degrade gracefully when JavaScript fails. Focuses on accessibility, event safety, and simplicity.

## When to Use This Skill

- Adding interactivity to server-rendered pages without a SPA rewrite
- Refactoring large inline Alpine expressions into maintainable patterns
- Building dropdowns, dialogs, accordions, and reactive forms
- Reviewing event and state handling for race conditions and leaks

## Core Workflow

1. Map interactions and minimal local state per component
2. Model x-data shape and state transitions
3. Implement directives with semantic HTML and ARIA
4. Extract shared state into stores when required
5. Validate keyboard, screen reader, and no-JS behavior

## Reference Guide

| Pattern | Preferred Approach | Anti-Pattern |
|---|---|---|
| Local state | Keep small x-data objects per widget | Global mutable state for everything |
| Events | Use explicit x-on handlers | Nested inline logic chains |
| Visibility | x-show with transitions for toggles | DOM replacement where not needed |
| Forms | x-model with validation guards | Direct mutation from unrelated components |

## Constraints

### MUST DO

- Prefer explicit state names over single-letter variables
- Add accessibility attributes for interactive controls
- Keep expressions short and move complex logic to methods

### MUST NOT DO

- Do not embed large business logic in inline template expressions
- Do not skip keyboard interaction patterns for custom widgets
- Do not rely on hidden globals when local state is enough

## Output Templates

```md
## Alpine Review Summary
- Component: [name/location]
- State model quality: [good/needs work]
- Accessibility gaps: [list]
- Recommended refactor: [action]
- Verification steps: [steps]
```

## Knowledge Reference

x-data composition, x-show vs x-if, x-on modifiers, click outside, focus management, aria expanded, keyboard support, store boundaries, reusable patterns, progressive enhancement

## Related Skills

- `javascript-expert`
- `tailwind-expert`
- `code-reviewer`
