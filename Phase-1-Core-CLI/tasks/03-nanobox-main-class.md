# Task 1.3 — Main Class

**File:** `nanobox.bx`

## Description

Create the main entry point class with `main()` method. Parses CLI args, initializes ConfigManager and PrettyCli, dispatches to CommandDispatcher.

## Requirements

- [ ] Class has `main( args = [] )` method (BoxLang convention)
- [ ] Uses `CLIGetArgs()` for argument parsing
- [ ] Initializes `ConfigManager` on startup
- [ ] Initializes `PrettyCli` on startup
- [ ] Dispatches to `CommandDispatcher`
- [ ] No args → shows help and exits
- [ ] `--help`, `-h` → shows help and exits
- [ ] `--version`, `-v` → shows version and exits
- [ ] Unknown command → shows "Unknown command" message and exits non-zero
- [ ] Global `--debug` flag enables debug output
- [ ] Uses BoxLang's `server` scope for persistence across calls

## Test

**File:** `tests/unit/MainClassTest.bx`

```boxlang
class extends="testbox.system.BaseSpec" {

    function run() {
        describe( "nanobox main class", () => {
            it( "parses --help flag", () => {
                // ...
            })
            it( "parses --version flag", () => {
                // ...
            })
            it( "dispatches to correct command", () => {
                // ...
            })
            it( "shows help when no args provided", () => {
                // ...
            })
        })
    }

}
```

## Depends On

- 1.1 Install script (directory structure)
- 1.2 Wrapper scripts (invocation path)
