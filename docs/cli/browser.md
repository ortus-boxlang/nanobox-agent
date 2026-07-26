# Browser Namespace

Playwright-based browser automation for research and content extraction.

## Commands

```bash
nanobox browser status                      # Check Node.js + Playwright availability
nanobox browser open <url>                  # Open URL, return metadata
nanobox browser screenshot <url>            # Capture screenshot (PNG/JPEG)
nanobox browser text <url>                  # Extract visible text
nanobox browser html <url>                  # Extract raw HTML
nanobox browser pdf <url>                   # Generate PDF from page
nanobox browser close                       # Close browser session
nanobox browser install                     # Install Playwright browsers
```

## Examples

### Check Status

```bash
nanobox browser status
```

Returns Node.js version, Playwright installation status, and available browser binaries.

### Open a Page

```bash
nanobox browser open https://example.com
```

Returns page title, description, and HTTP status code.

### Capture Screenshot

```bash
nanobox browser screenshot https://example.com
nanobox browser screenshot https://example.com --output=/tmp/page.png
nanobox browser screenshot https://example.com --full-page --format=jpeg
```

Screenshots are saved to `~/Pictures/nanobox/browser/` by default.

### Extract Text

```bash
nanobox browser text https://example.com
nanobox browser text https://example.com --selector="article"
```

Extracts visible text content, optionally scoped to a CSS selector.

### Extract HTML

```bash
nanobox browser html https://example.com
nanobox browser html https://example.com --selector="main"
```

Returns raw HTML, optionally scoped to a CSS selector.

### Generate PDF

```bash
nanobox browser pdf https://example.com
nanobox browser pdf https://example.com --output=/tmp/report.pdf
```

Generates a PDF from the rendered page.

### Install Browsers

```bash
nanobox browser install
```

Downloads Chromium, Firefox, and WebKit binaries via `npx playwright install`.

## Architecture

BrowserCommand delegates to a Node.js helper script (`scripts/browser-helper.js`) that wraps Playwright's Node API. The helper handles:

- Browser lifecycle (launch/close)
- Page navigation with timeout
- Content extraction (text, HTML, metadata)
- Screenshot and PDF generation
- CSS selector scoping

All output files are saved to `~/Pictures/nanobox/browser/` unless `--output` is specified.

## Dependencies

- Node.js 18+ (must be on PATH)
- Playwright npm package (installed via `npx playwright install`)
- Browser binaries (Chromium, Firefox, WebKit)

Run `nanobox browser install` to set up Playwright and download browsers.

## Failure Modes

Missing dependencies return structured errors:

```bash
nanobox browser screenshot https://example.com
# Error: Node.js not found. Install Node.js 18+ to use the browser tool.

nanobox browser open https://example.com
# Error: Browser helper script not found at /path/to/scripts/browser-helper.js

nanobox browser unknown
# Error: Unknown browser action: unknown
```

Network timeouts, invalid URLs, and Playwright failures are captured and returned as error messages.

## Output Paths

All generated files (screenshots, PDFs) default to:

```text
$NANOBOX_HOME/Pictures/nanobox/browser/
```

Override with `--output=<path>`. Parent directories are created automatically.

## Tests

```text
tests/specs/BrowserCommandSpec.bx
```

Coverage includes status checks, URL validation, missing dependencies, and action dispatch.

## Implementation Notes

- **Helper script**: `scripts/browser-helper.js` wraps Playwright and outputs JSON for BoxLang to parse
- **Process execution**: Uses `java.lang.ProcessBuilder` for cross-platform subprocess control
- **Timeout handling**: Default 30s per operation, configurable via `--timeout`
- **URL normalisation**: Adds `https://` prefix if scheme is missing
- **Exit codes**: Non-zero exit from helper script triggers error response
