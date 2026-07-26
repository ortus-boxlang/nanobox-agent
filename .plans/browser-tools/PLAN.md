# Plan: Download Manager + Browser Tools (Java Playwright)

> **Status:** Draft
> **Effort:** Medium (5-8 hours)
> **Depends on:** `lib/java/` directory, `http()` BIF, Java Playwright JAR

---

## Phase 1 — Download Manager

### Why

NanoBox needs to download JARs, browser binaries, and potentially other assets. A reusable `DownloadManager` provides progress bars, resume support, and consistent error handling.

### `models/system/DownloadManager.bx`

```boxlang
class {
    /**
     * @downloadsDir  Directory to save downloaded files (default: ~/.nanobox/downloads/)
     */
    function init( string downloadsDir = "" )

    /**
     * Downloads a file from a URL with a live progress bar.
     *
     * @url       Source URL
     * @dest      Destination file path
     * @label     Display label for the progress bar (e.g. "Playwright JAR")
     * @expectedSize  Expected total bytes (for progress calculation)
     * @return     Struct with success, path, size, and elapsed keys
     */
    struct function download( url, dest, label = "", expectedSize = 0 )

    /**
     * Downloads from Maven Central by Maven coordinates.
     *
     * @group     Group ID (e.g. "com.microsoft.playwright")
     * @artifact  Artifact ID (e.g. "playwright")
     * @version   Version (e.g. "1.49.0")
     * @dest      Destination file path
     * @return    Result of download()
     */
    struct function downloadMavenArtifact( group, artifact, version, dest )
}
```

### Progress Bar Rendering

Styled like `SetupOnboarding` boxes but for downloads:

```
  ┌─ Downloading Playwright JAR ──────────────────────────┐
  │  ████████████████░░░░░░░░░░░░░░░░░░  45%  (2.1/4.7 MB) │
  │  Speed: 1.2 MB/s  •  ETA: 2s                          │
  └────────────────────────────────────────────────────────┘
```

Implementation uses:
- `http( url ).timeout( 0 ).send()` to stream the response
- `fileWrite( dest, chunk, "append" )` to write in chunks
- `CLIRead()` in non-blocking mode? No — use a spinner/bar via `systemOutput()` with `char(13)` to rewrite the same line
- Track downloaded bytes vs expected (from `Content-Length` header)

### `http()` BIF Usage

```boxlang
var response = http( url )
    .timeout( 300 )
    .header( "Accept", "*/*" )
    .send()

// For binary downloads, the response body is in response.fileContent
// or we can stream via response.getData()
```

---

## Phase 2 — Java Playwright Integration

### Directory Setup

```
lib/java/          ← JARs go here (added to boxlang.json classpath)
  playwright-1.49.0.jar
  (transitive deps if any)
```

### `config/boxlang.json`

```json
{
    "classPaths": [
        "${user-dir}/lib/java"
    ],
    // ... existing config
}
```

This makes every JAR in `lib/java/` available to `createObject("java", ...)`.

### JAR Acquisition

Playwright Java coordinates: `com.microsoft.playwright:playwright:1.49.0`

The DownloadManager downloads from Maven Central:
```
https://repo1.maven.org/maven2/com/microsoft/playwright/playwright/1.49.0/playwright-1.49.0.jar
```

**Browser binary strategy:**
1. First check if Chrome/Chromium is already installed on the system
2. If found, use `setExecutablePath()` to point Playwright at it — **no extra download**
3. If not found, download a portable Chromium to `~/.nanobox/browser/chromium/`

This means most users need only the ~1.5 MB JAR, not the full ~150 MB Chromium bundle.

---

## Phase 3 — Browser Tools

### File Plan

| File | Purpose |
|------|---------|
| `models/system/DownloadManager.bx` | Download files with progress bars |
| `models/tools/BrowserManager.bx` | Java Playwright wrapper |
| `cli/commands/BrowserCommand.bx` | CLI dispatch (11 actions) |
| `cli/CommandRuntime.bx` | Wire `case "browser"` |
| `cli/commands/BrowserInstallCommand.bx` | Install browser deps |
| `config/boxlang.json` | Add `classPaths` |
| `docs/cli/browser.md` | Documentation |

### `models/tools/BrowserManager.bx`

```boxlang
class {
    function init()
    struct function launch( boolean headless )     // Start Playwright + Chromium
    struct function close()                       // Close browser + Playwright
    struct function navigate( url )               // Navigate to URL
    struct function snapshot( boolean full )      // Get page snapshot (accessibility tree)
    struct function screenshot( path )            // Take screenshot
    struct function click( selector )             // Click element
    struct function type( selector, text )        // Type into element
    struct function scroll( direction )           // Scroll page
    array  function consoleLog()                  // Get console messages
    any    function eval( js )                    // Execute JavaScript
    struct function getImages()                   // Get image URLs from page
}
```

### Java Playwright in BoxLang

```boxlang
// Launch browser
var playwright = createObject( "java", "com.microsoft.playwright.Playwright" ).create()
var launchOpts = createObject( "java", "com.microsoft.playwright.BrowserType$LaunchOptions" )
    .setHeadless( true )
var browser = playwright.chromium().launch( launchOpts )
var page = browser.newPage()

// Navigate
page.navigate( "https://example.com" )

// Get page info
var title = page.title()
var content = page.content()

// Screenshot
page.screenshot( { path: "/tmp/shot.png", fullPage: true } )

// Click
page.click( "#mybutton" )

// Type
page.fill( "#search", "hello" )

// JavaScript eval
var result = page.evaluate( "document.title" )

// Close
browser.close()
playwright.close()
```

### `cli/commands/BrowserCommand.bx`

```
nanobox browser install              → Download Playwright JAR + find/install Chrome
nanobox browser start [--headless]   → Launch browser process
nanobox browser stop                 → Close browser
nanobox browser status               → Check browser state
nanobox browser navigate <url>       → Go to URL + return snapshot
nanobox browser snapshot [--full]    → Accessibility tree snapshot
nanobox browser screenshot           → Save screenshot
nanobox browser click <selector>     → Click element (CSS or ref ID)
nanobox browser type <selector> text  → Fill input
nanobox browser scroll <direction>   → Scroll
nanobox browser console              → Console log output
nanobox browser eval <js>            → Run JavaScript
nanobox browser images               → List page images
```

### `nanobox browser install`

The install command:
1. Downloads Playwright Java JAR to `lib/java/`
2. Checks for Chrome/Chromium on the system
3. If not found, offers to download Chromium to `~/.nanobox/browser/`
4. Verifies the setup works

```
$ nanobox browser install
┌─ Installing Browser Tools ──────────────────────────┐
│                                                     │
│  Step 1: Download Playwright JAR                    │
│  ┌─ Downloading Playwright JAR ────────────────────┐│
│  │  ████████████████████████████████████  100%      ││
│  │  1.5 MB in 0.3s                                 ││
│  └─────────────────────────────────────────────────┘│
│  ✅ Playwright 1.49.0 installed                     │
│                                                     │
│  Step 2: Detecting Chrome...                        │
│  ✅ Found at /Applications/Chromium.app              │
│                                                     │
│  No download needed — using system Chrome.          │
│                                                     │
│  ✅ Browser tools ready!                            │
│  Try: nanobox browser navigate https://example.com  │
└─────────────────────────────────────────────────────┘
```

---

## CLI Integration

### Wire in CommandRuntime.bx

```boxlang
case "browser": return new "cli.commands.BrowserCommand"( variables.config ).execute( action ?: "status", args )
```

### Setup Integration

During `nanobox setup`, add a step or prompt:

```
❓ Configure browser automation tools?
   Requires downloading ~1.5 MB Playwright Java library.
   [Y/n]: y
```

---

## Edge Cases & Failures

| Scenario | Behavior |
|----------|----------|
| No Chrome/Chromium | Offer to download portable Chromium (~150 MB) |
| Download interrupted | Retry with resume (check Content-Range) |
| JAR download fails | Show clear error with manual download URL |
| Playwright launch fails | Verify JAR exists, classpath is correct, Chrome binary is valid |
| WebSocket connection lost | Auto-restart browser on next command |
| Page timeout (slow sites) | Default 30s timeout, configurable via `--timeout` |

---

## Future Enhancements

- **Download cache** — verify checksums before re-downloading
- **Multiple browser types** — support Firefox, WebKit via Playwright
- **Browser pool** — reuse browser instance across CLI calls (like Hermes supervisor)
- **Vision/QA** — screenshot + LLM vision for automated visual testing
- **Network intercept** — mock API responses, block resources

---

## Effort Summary

| Component | Files | Est. Time |
|-----------|-------|-----------|
| DownloadManager | 1 | 1-2 hours |
| boxlang.json + JAR setup | 1 | 30 min |
| BrowserManager | 1 | 2-3 hours |
| BrowserCommand + dispatch | 2 | 1-2 hours |
| Browser install step | 1 | 1 hour |
| Docs + tests | 3 | 1-2 hours |
| **Total** | **~9 files** | **5-8 hours** |
