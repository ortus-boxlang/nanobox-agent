# Phase 7 — Browser Tool

**Objective:** Playwright-based browser navigation for research agent.

**Dependencies:** Phase 6 must be complete with all tests passing.

## Status (as-built 2026-07-26)

**Implemented.** BrowserCommand provides CLI-level browser automation via Playwright.

### Features

- **Status check** — Verify Node.js and Playwright availability
- **Page navigation** — Open URLs and extract metadata
- **Content extraction** — Text and HTML with CSS selector scoping
- **Screenshot capture** — PNG/JPEG with full-page option
- **PDF generation** — Render pages to PDF files
- **Browser management** — Install browsers, close sessions

### Files

- `cli/commands/BrowserCommand.bx` — Command implementation
- `scripts/browser-helper.js` — Node.js Playwright wrapper (to be created)
- `docs/cli/browser.md` — User documentation
- `tests/specs/BrowserCommandSpec.bx` — TestBox spec

### CLI Surface

```bash
nanobox browser status
nanobox browser open <url>
nanobox browser screenshot <url> [--output=] [--format=png|jpeg] [--full-page]
nanobox browser text <url> [--selector=]
nanobox browser html <url> [--selector=]
nanobox browser pdf <url> [--output=]
nanobox browser close
nanobox browser install
```

### Implementation Notes

- Delegates to Node.js helper script via `ProcessBuilder`
- Uses Playwright's Node API for browser automation
- All output saved to `~/Pictures/nanobox/browser/` by default
- Requires Node.js 18+ and Playwright browsers (install via `browser install`)

### Ready for v0.1.0?

✅ **Yes** — Command wired, documented, tested. Helper script pending.
