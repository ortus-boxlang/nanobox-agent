---
title: "Scripts"
order: 24
description: "Manage and run BoxLang scripts stored in ~/.nanobox/scripts/."
---

# NanoBox Script CLI

> Manage and run BoxLang scripts stored in `~/.nanobox/scripts/`.

## Overview

The `script` namespace lets you create, inspect, and run BoxLang scripts (.bxs files) directly from the CLI. Scripts execute in an isolated process via `ProcessBuilder` and return stdout + exit code.

## Commands

### `nanobox script list`
List all registered scripts in the scripts directory.
```
nanobox script list
```
Returns an array of scripts with name, path, and size.

### `nanobox script show <name>`
Display the full source content of a script.
```
nanobox script show <name>
```
Returns the script name, file path, and full source content.

### `nanobox script create <name> [--content=]`
Create a new script file.
```
nanobox script create myScript --content="println( 'Hello from script' )"
```
Creates `~/.nanobox/scripts/<name>.bxs` with the given content.

### `nanobox script run <name> [args...]`
Execute a script in a subprocess.
```
nanobox script run myScript
```
```
nanobox script run myScript -- arg1 arg2
```
Returns stdout, stderr, and exit code. Errors in the script do not crash the CLI — exit code signals success/failure.

## Script Format

Scripts are plain `.bxs` files stored under `~/.nanobox/scripts/`. Any valid BoxLang script works:

```java
// ~/.nanobox/scripts/hello.bxs
var name = len( ARGS ) ? ARGS[ 1 ] : "World"
println( "Hello, #name#!" )
```

## Test Coverage

`tests/specs/ScriptCommandSpec.bx` covers the full CRUD lifecycle:
- create
- list
- show
- run (verifies real stdout output)