# Task 1.4 — PrettyCli

**File:** `cli/PrettyCli.bx`

## Description

Build a comprehensive terminal output toolkit. Inspired by OpenCode and Pi. Wraps BoxLang's `ColorPrint` and `MiniConsole` Java classes.

## Requirements

### Colors & Styles
- [ ] `red()`, `green()`, `yellow()`, `blue()`, `dim()`, `bold()` methods
- [ ] `color( text, colorName )` for any named color
- [ ] Auto-detects piped output → disables colors

### Status Indicators
- [ ] `success( message )` — ✅ in green
- [ ] `error( message )` — ❌ in red
- [ ] `warn( message )` — ⚠️ in yellow
- [ ] `info( message )` — ℹ️ in blue
- [ ] `muted( message )` — dim/gray
- [ ] Raw icon methods: `checkmark()`, `cross()`, `warning()`, `arrow()`, `bullet()`

### Tables
- [ ] `table( headers, rows, options )` — formatted table with borders
- [ ] Auto-column-width based on content
- [ ] `kvTable( data, options )` — key-value table for config display
- [ ] Options: `border`, `headerStyle`, `maxWidth`, `align`, `wrap`

### Boxes & Dividers
- [ ] `box( text, options )` — draws Unicode box around content
- [ ] `section( title )` — section header with divider
- [ ] `divider( char )` — horizontal rule

### Spinner & Progress
- [ ] `spinner( message )` — animated spinner for async operations
- [ ] `spinner.stop( message )` — stop spinner with success
- [ ] `spinner.fail( message )` — stop spinner with failure
- [ ] `progressBar( total, label )` — determinate progress bar

### Prompts
- [ ] `prompt( question, default, validate )` — text input
- [ ] `confirm( question, default )` — Y/N prompt
- [ ] `select( question, choices )` — single select from list
- [ ] `multiselect( question, choices )` — checkbox multi-select
- [ ] All prompts use `MiniConsole` for arrow-key navigation + history

### Trees
- [ ] `tree( data, options )` — hierarchical display with Unicode branches

### Task List
- [ ] `taskList( tasks )` — sequential steps with status updates
- [ ] Shows checkmark on success, X on failure, elapsed time per task

### Misc
- [ ] `link( url, label )` — clickable terminal hyperlinks (OSC 8)
- [ ] `markdown( text )` — basic inline formatting
- [ ] `columns( items, colCount )` — multi-column layout
- [ ] `indent( text, level )` — indentation
- [ ] `wrap( text, maxWidth )` — word wrap
- [ ] `truncate( text, maxWidth )` — truncate with ellipsis
- [ ] `clear()` — clear screen
- [ ] `statusBar( left, right )` — persistent bottom bar
- [ ] `clearStatus()` — clear status bar

## Test — As-Built 2026-07-17

**File:** `tests/unit/PrettyCliTest.bx` (exists in tests/specs/)

```boxlang
# Current state: models/util/PrettyCli.bx exists with full feature set.
# Location moved from cli/PrettyCli.bx to models/util/PrettyCli.bx during refactoring.
```

**Status:** ✅ Complete — all requirements met, lives at correct path now.

## Depends On

- 1.3 Main class
