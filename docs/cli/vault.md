# NanoBox Vault CLI

> Import, search, manage, and export knowledge documents stored locally with SQLite indexing.

## Overview

The vault stores imported documents organized by category. Each document preserves its original content, metadata, and tags. Full-text search and metadata queries are backed by SQLite (`nanobox_vault_documents` table) via the project's `nanobox` datasource.

## Storage

Default directory: `~/.nanobox/vault/`

```
~/.nanobox/vault/
├── reports/
│   └── quarterly.md
├── research/
│   ├── boxlang-notes.md
│   └── ai-patterns.pdf
├── imported/
│   └── meeting-notes.md
└── manual/
```

Document metadata and content are stored in the SQLite `nanobox_vault_documents` table (defined in the project's `config/boxlang.json` datasource `nanobox`, file-backed at `data/nanobox.db`). The `index` command synchronises files on disk into the database.

## Commands

### `nanobox vault list`

List all documents, optionally filtered by category.

```
$ nanobox vault list

ID                                   Name              Category   Tags
────────────────────────────────────────────────────────────────────────
a1b2c3d4-...                         quarterly.md      reports
e5f6g7h8-...                         boxlang-notes.md  research   [boxlang]

$ nanobox vault list --category=research
```

### `nanobox vault import <path>`

Import a file into the vault. Copies the file to the vault directory and indexes its content in SQLite.

```
$ nanobox vault import ./notes.md --category=research --tags=boxlang,architecture
```

- `--category` — One of: `reports`, `research`, `imported`, `manual` (default: `imported`)
- `--tags` — Comma-separated tags for filtering

### `nanobox vault search <query>`

Full-text search across document names, categories, tags, and content in SQLite.

```
$ nanobox vault search boxlang
```

### `nanobox vault show <id>`

Show a document's metadata and content.

```
$ nanobox vault show a1b2c3d4-e5f6-...
```

### `nanobox vault index`

Re-scan files on disk and upsert each one into the SQLite `nanobox_vault_documents` table. Existing records are updated; new files are inserted.

```
$ nanobox vault index
```

### `nanobox vault remove <id>`

Delete a document from the vault (removes both the disk file and the SQLite row).

```
$ nanobox vault remove a1b2c3d4-e5f6-...
```

### `nanobox vault export <id>`

Export a document's content. Optionally write to a file.

```
$ nanobox vault export a1b2c3d4-e5f6-...
$ nanobox vault export a1b2c3d4-e5f6-... --output=~/exported.md
```

## Integration

Vault documents are searchable by NanoBox agents when the `vault_search@nanobox` tool is enabled:

```bash
nanobox tool enable vault_search@nanobox
nanobox tool enable vault_import@nanobox
```

## Tests

```text
tests/specs/VaultManagerSpec.bx
```

Coverage includes import, list, search, index, get, remove, and export — happy paths, missing-files, missing-ids, unmatched search, and VaultCommand dispatch for all 7 actions plus unknown action rejection.