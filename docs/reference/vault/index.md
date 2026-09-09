---
title: "Vault"
order: 6
description: "NanoBox's long-term knowledge base: directory structure, search, document import, and agent integration."
icon: "🗄️"
---

# Vault

The vault is NanoBox's long-term knowledge base. It stores documents, reports, research, and notes in `~/.nanobox/vault/`.

## Directory Structure

```
~/.nanobox/vault/
├── reports/              ← Auto-generated (security reports, cron output, briefings)
├── research/             ← Output from researcher agent
├── imported/             ← User-imported documents (PDF, DOCX, MD)
└── manual/               ← User's own notes (Obsidian-style)
```

## Search

Documents are indexed via:

- **FTS5** (SQLite) — keyword search across all vault content
- **Vector memory** (bx-ai) — semantic search via embeddings

`nanobox vault search <query>` searches both and returns ranked results.

## Import

```bash
nanobox vault import ~/documents/report.pdf --tag=quarterly,2026
```

Supports 30+ formats via bx-ai's `aiDocuments()`, including:
- Markdown (.md, .bxs, .bx)
- PDF (.pdf)
- Word (.docx)
- HTML (.htm, .html)
- Plain text (.txt, .csv, .json)
- Code files (.bx, .java, .py, .js)

## Agent Integration

The researcher agent automatically searches the vault for relevant context when answering questions. Generated reports and research are automatically saved to the vault.
