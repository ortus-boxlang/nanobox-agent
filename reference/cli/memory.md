---
title: "Memory"
order: 20
description: "Durable storage for facts, preferences, and user information, persisted in SQLite."
---

# Memory Namespace

NanoBox user memory provides durable storage for facts, preferences, and user information. Memory entries persist in SQLite and can be recalled by the AI or accessed via CLI.

## Commands

```bash
nanobox memory list [--category=<name>]
nanobox memory show <id>
nanobox memory add <topic> <entry> [--category=<name>]
nanobox memory delete <id>
nanobox memory search <query>
nanobox memory export
```

## Categories

Memory entries are organized by category:

- `user` — Personal information about the user (name, role, preferences)
- `memory` — General facts and context (default category)
- `preference` — User settings and workflow preferences
- Custom categories are supported

## Add

```bash
nanobox memory add "favorite-language" "BoxLang" --category=user
nanobox memory add "project-deadline" "Q3 2026 release"
```

The `add` action creates a new memory entry or updates an existing one with the same category and topic combination.

## List

```bash
nanobox memory list
nanobox memory list --category=user
```

Returns all memory entries, optionally filtered by category. Each entry includes:

- ID
- Category
- Topic
- Entry content
- Created timestamp
- Updated timestamp

## Show

```bash
nanobox memory show <id>
```

Returns a single memory entry with all fields.

## Search

```bash
nanobox memory search "BoxLang"
```

Searches across category, topic, and entry content. Returns matching entries ordered by most recently updated.

## Delete

```bash
nanobox memory delete <id>
```

Removes a memory entry by ID.

## Export

```bash
nanobox memory export
```

Exports all memory entries as an array of structs.

## AI Tools

The memory system exposes three AI-callable tools via the `MemoryTools` class:

### memory_save

Saves a durable fact to user memory.

**Parameters:**
- `category` — Memory category (e.g., "user", "memory", "preference")
- `topic` — Memory topic key (shorthand identifier)
- `entry` — Memory content (the fact to remember)

**Returns:** The saved memory struct with id, category, topic, entry, created_at, and updated_at keys.

**Example:**
```boxlang
memory_save( category="user", topic="favorite-language", entry="BoxLang" )
```

### memory_recall

Retrieves memories from user memory.

**Parameters:**
- `category` — Optional category filter (empty returns all)
- `topic` — Optional topic search term (searches topic and entry content)

**Returns:** Array of matching memory structs.

**Example:**
```boxlang
memory_recall( category="user" )
memory_recall( topic="language" )
```

### memory_remove

Removes a memory entry by ID.

**Parameters:**
- `id` — Memory UUID to delete

**Returns:** Struct with deleted (boolean) and id keys.

**Example:**
```boxlang
memory_remove( id="550e8400-e29b-41d4-a716-446655440000" )
```

## Storage

Memory entries are stored in the `nanobox_user_memory` table in SQLite:

```text
nanobox → SQLite → ~/.nanobox/data/nanobox.db
```

Schema:

```sql
CREATE TABLE nanobox_user_memory (
    id VARCHAR(36) PRIMARY KEY,
    category VARCHAR(64) NOT NULL,
    topic VARCHAR(255) NOT NULL,
    entry TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

Indexes:

```sql
CREATE INDEX idx_memory_category ON nanobox_user_memory(category)
CREATE INDEX idx_memory_topic ON nanobox_user_memory(topic)
```

## Use Cases

**User Preferences:**
```bash
nanobox memory add "editor" "VS Code" --category=preference
nanobox memory add "theme" "dark" --category=preference
```

**Project Context:**
```bash
nanobox memory add "current-sprint" "Sprint 23 - Authentication"
nanobox memory add "team-size" "5 developers"
```

**Technical Decisions:**
```bash
nanobox memory add "db-choice" "PostgreSQL for production, SQLite for dev"
nanobox memory add "auth-strategy" "JWT with refresh tokens"
```

**Personal Information:**
```bash
nanobox memory add "name" "Jane Developer" --category=user
nanobox memory add "role" "Senior Backend Engineer" --category=user
```

## Upsert Behavior

When you save a memory with a category and topic combination that already exists, the entry is updated in place (upsert). This allows you to refine memories without creating duplicates:

```bash
nanobox memory add "project-status" "Phase 1 complete"
nanobox memory add "project-status" "Phase 2 in progress"  # Updates existing entry
```

## Tests

Memory coverage includes:

```text
tests/specs/MemoryManagerSpec.bx
```

Tests cover CRUD operations, category filtering, search, upsert behavior, export, and error handling.
