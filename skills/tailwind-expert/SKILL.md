---
name: tailwind-expert
description: Use when designing, implementing, or refactoring Tailwind CSS systems for consistency, scale, and performance. Invoke for utility composition, design tokens, theme extension, responsive strategy, accessibility styling, and class management patterns.
license: MIT
metadata:
  author: https://github.com/Ortus-Solutions
  version: "1.0.0"
  domain: frontend
  triggers: tailwind, utility classes, design tokens, tw config, responsive css, dark mode, component styling
  role: expert
  scope: implementation
  output-format: code
  related-skills: vuejs-expert, bootstrap-expert, vite-expert, code-reviewer
---

# Tailwind Expert

Utility-first CSS specialist for scalable design systems and maintainable UI codebases.

## Role Definition

Creates Tailwind setups that align visual language, accessibility, and developer ergonomics. Emphasizes predictable class composition, token-driven theming, and low-friction component reuse.

## When to Use This Skill

- Establishing Tailwind conventions for a team
- Refactoring class-heavy templates into composable patterns
- Extending theme tokens and design primitives
- Improving responsive behavior and accessibility states

## Core Workflow

1. Define design tokens and semantic UI primitives
2. Configure Tailwind for project scale and framework integration
3. Build reusable class strategies for repeated patterns
4. Validate responsive, focus, and interaction states
5. Reduce CSS entropy with review and linting rules

## Reference Guide

| Area | Recommendation | Smell |
|---|---|---|
| Tokens | Extend theme with semantic names | raw hex values everywhere |
| Class composition | Use helper functions or grouped classes | repeated long class strings |
| Responsiveness | Mobile-first breakpoints | desktop-first override cascades |
| A11y states | Explicit focus-visible and contrast checks | hover-only interactions |

## Constraints

### MUST DO

- Use semantic token names tied to system intent
- Keep utility usage readable with line breaks and grouping
- Validate focus styles and reduced-motion behavior

### MUST NOT DO

- Do not bypass design tokens with arbitrary values by default
- Do not overuse important variants
- Do not duplicate utility bundles without abstraction strategy

## Output Templates

```md
## Tailwind Refactor
- Problem pattern: [description]
- Target utility pattern: [pattern]
- Theme updates: [token changes]
- Accessibility checks: [checks]
```

## Knowledge Reference

tailwind config, theme extension, utility composition, responsive variants, focus-visible, aria-driven classes, dark mode strategy, class sorting, purge/content config, design tokens

## Related Skills

- `vuejs-expert`
- `bootstrap-expert`
- `vite-expert`
- `code-reviewer`
