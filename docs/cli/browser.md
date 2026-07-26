# Browser Namespace

Java Playwright–based browser automation for research, content extraction, and page interaction.

## Prerequisites

- Java Playwright JARs must be installed: `nanobox browser install`
- The JARs are fetched from Maven Central into `lib/java/` and loaded via the `classPaths` in `config/boxlang.json`

## Commands

```bash
nanobox browser status                        # Check browser state + JAR availability
nanobox browser start [--headless]            # Launch Chromium (headless by default)
nanobox browser stop                          # Close browser + free resources
nanobox browser navigate <url>                # Go to URL, return title + URL
nanobox browser snapshot [--full]             # Get page text content
nanobox browser screenshot [--path=<file>]    # Save screenshot (PNG)
nanobox browser click <selector>              # Click element by CSS selector
nanobox browser type <selector> <text>        # Fill input field
nanobox browser scroll up|down                # Scroll page
nanobox browser console                       # Get accumulated console messages
nanobox browser eval <js>                     # Execute JavaScript on page
nanobox browser images                        # List all image URLs on page
nanobox browser install                       # Download Playwright JARs + browser binaries
```

## Examples

### Check Status

```bash
nanobox browser status
```

Returns running state, Playwright JAR availability, and browser binary status.

### Navigate to a Page

```bash
nanobox browser navigate https://example.com
```

Returns the page title and final URL (after redirects).

### Read Page Content

```bash
nanobox browser navigate https://docs.ortusbooks.com
nanobox browser snapshot
```

Returns the visible text of the current page. Use `--full` for the complete content.

### Take a Screenshot

```bash
nanobox browser navigate https://example.com
nanobox browser screenshot --path=~/Desktop/shot.png
```

Saves a PNG screenshot to the specified path.

### Interact with a Page

```bash
nanobox browser navigate https://google.com
nanobox browser type "input[name=q]" "BoxLang"
nanobox browser click "input[type=submit]"
```

### Debug JavaScript

```bash
nanobox browser navigate https://example.com
nanobox browser eval "document.title"
nanobox browser console
```

### Install Browser Dependencies

```bash
nanobox browser install
```

Downloads the Playwright Java JAR and platform-specific driver from Maven Central,
then installs Chromium browser binaries (~280 MB total).

## AI Tools

The browser actions are also available as bx-ai tools:

| Tool | Description |
|------|-------------|
| `browser_navigate(url)` | Navigate to a URL |
| `browser_snapshot(full)` | Get page text content |
| `browser_screenshot(path, fullPage)` | Capture screenshot |
| `browser_click(selector)` | Click element |
| `browser_type(selector, text)` | Fill input |
| `browser_scroll(direction)` | Scroll page |
| `browser_console()` | Get console messages |
| `browser_eval(js)` | Execute JavaScript |
| `browser_images()` | List page images |
| `browser_status()` | Check if running |
| `browser_close()` | Close browser |

## Security

- The browser runs in headless mode by default
- Page content is isolated — no cookies or profiles are shared with your regular browser
- Screenshots are saved only to paths you specify
- JavaScript execution (`eval`) has full access to the page context
