# Contributing

## Development Setup

```bash
git clone https://github.com/ortus-boxlang/nanobox.git
cd nanobox
./install.sh
```

## Project Structure

See [Architecture](../architecture/README.md) for the full layout.

## Testing

All tests use TestBox. Run tests with:

```bash
boxlang tests/runner.bx
```

A task cannot proceed to the next phase until all tests in the current phase pass.

## Build Phases

See [PLAN.md](../../PLAN.md) for the full build plan with 8 phases.

## Coding Standards

- Use Ortus Coding Standards (tabs, spaces inside parens, K&R braces)
- No semicolons on statements
- Classes with `main()` for CLI entry points
- `.bx` for classes, `.bxs` for scripts
- Always include TestBox specs for new code
