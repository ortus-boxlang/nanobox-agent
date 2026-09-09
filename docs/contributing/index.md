---
title: "Contributing"
order: 5
description: "Development setup, project structure, testing, build phases, and coding standards for NanoBox contributors."
icon: "phosphor-duotone:handshake"
---

# Contributing

## Development Setup

```bash
git clone https://github.com/ortus-boxlang/nanobox-agent.git
cd nanobox-agent
./install.sh --local
```

## Project Structure

See [Architecture](../architecture/index.md) for the full layout.

## Testing

All tests use TestBox. Run tests with:

```bash
./testbox/run
```

A task cannot proceed to the next phase until all tests in the current phase pass.

## Build Phases

See [PLAN.md](https://github.com/ortus-boxlang/nanobox-agent/blob/main/.plans/PLAN.md) for the full build plan.

## Coding Standards

- Use Ortus Coding Standards (tabs, spaces inside parens, K&R braces)
- No semicolons on statements
- Classes with `main()` for CLI entry points
- `.bx` for classes, `.bxs` for scripts
- Always include TestBox specs for new code
