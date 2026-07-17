# Sessions Namespace

NanoBox sessions are persisted in SQLite through the `nanobox` datasource.

## Commands

```bash
nanobox session create [title]
nanobox session list [--limit=<n>] [--offset=<n>]
nanobox session show <session-id>
nanobox session rename <session-id> <title>
nanobox session search <query>
nanobox session delete <session-id>
nanobox session export <session-id> [--output=<file>]
nanobox session prune [--older-than=<days>] [--dry-run]
nanobox session stats
```

## Create

```bash
nanobox session create "BoxLang gateway work"
```

Interactive `create` prompts for a title when no title or non-interactive flag is supplied. The active CLI positional path treats a supplied title as non-interactive and never prompts.

## List

```bash
nanobox session list
nanobox session list --limit=50 --offset=0
```

Each record includes:

- ID
- Title
- Provider
- Model
- Created timestamp
- Updated timestamp
- Message count

## Show transcript

```bash
nanobox session show <session-id>
```

Returns session metadata and all messages ordered by creation time.

## Rename

```bash
nanobox session rename <session-id> "New session title"
```

Titles persist in SQLite and are used by interactive chat sessions.

## Search

```bash
nanobox session search "gateway"
```

Searches:

- Session titles
- Session IDs
- Message content

Quoted multi-word queries are supported.

## Delete

```bash
nanobox session delete <session-id>
```

Deletes the session and its messages.

## Export

```bash
nanobox session export <session-id>
nanobox session export <session-id> --output=/tmp/session.jsonl
```

The export contains JSON Lines records for the session and its messages.

## Prune

Preview candidates without deleting:

```bash
nanobox session prune --older-than=90 --dry-run
```

Delete candidates:

```bash
nanobox session prune --older-than=90
```

## Statistics

```bash
nanobox session stats
```

Reports total sessions, total messages, and message counts by role.

## Interactive chat integration

Interactive `nanobox chat` sessions use this namespace for:

- Session creation
- First-question title generation using BoxLang `slugify()`
- Manual `/title` persistence
- User/assistant message persistence
- `/sessions` listing
- `/resume <id>` lookup

## Storage

The runtime datasource is declared in root `config/boxlang.json`:

```text
nanobox → SQLite → ~/.nanobox/data/nanobox.db
```

The schema contains:

```text
nanobox_sessions
nanobox_messages
```

## Tests

Session coverage includes:

```text
tests/specs/SessionCommandSpec.bx
tests/specs/SessionNamespaceSpec.bx
tests/specs/SessionActiveCliSpec.bx
```

Tests cover direct commands, persistence, message transcripts, rename, search, export, stats, delete, prune dry-run, missing IDs, unknown actions, and active runtime routing.
