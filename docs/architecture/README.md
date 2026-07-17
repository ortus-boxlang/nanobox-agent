# Architecture

## Overview

NanoBox is an AI agent platform built on BoxLang. It consists of three entry points:

- **CLI** (`nanobox`) — Terminal interface for all operations
- **Worker** (`boxlang schedule`) — Background process for gateways, cron, security, and learning
- **Web UI** (`boxlang-miniserver`) — ColdBox dashboard + REST API

## Process Model

```
User Terminal
    │
    ├── nanobox start
    │   ├── ProcessBuilder → boxlang-miniserver (Web UI)
    │   └── ProcessBuilder → boxlang schedule (Worker)
    │
    ├── nanobox chat -q "..."
    │   └── aiAgent() runs directly in CLI process
    │
    └── nanobox status
        └── Reads PIDs from ~/.nanobox/run/

Worker Process (boxlang schedule)
    ├── Gateway polling (every 1s)
    ├── Cron jobs (scheduled)
    ├── Security scanning (every 60m)
    ├── Learning consolidation (every 60m)
    ├── Backup (daily)
    └── Security reports (weekly)
```

## Stack Layers

```
nanobox CLI / Web UI / Gateways
    │
    ├── NanoBox Platform Layer
    │   ├── PrettyCli — Terminal output
    │   ├── ConfigManager — Configuration
    │   ├── ProcessManager — Process lifecycle
    │   ├── TokenTracker — Usage tracking
    │   ├── SecurityCzar — Threat detection
    │   ├── LearningEngine — Knowledge consolidation
    │   └── BackupManager — Backup/restore
    │
    ├── bx-ai (BoxLang AI Module)
    │   ├── aiAgent() — Agent orchestration
    │   ├── aiChat() — Chat completions
    │   ├── aiModel() — Provider-agnostic models
    │   ├── aiMemory() — 10+ memory types
    │   ├── aiDocuments() — 30+ document formats
    │   ├── aiToolRegistry() — Tool management
    │   ├── MCP() / MCPServer() — MCP support
    │   └── Middleware — Logging, HITL, guardrails, etc.
    │
    └── BoxLang Runtime
        ├── Scheduler — Task scheduling
        ├── Logging — File + console logging
        ├── Executors — Thread pools
        ├── Java interop — Any Java library
        └── CLI scripting — boxlang command
```

## Directory Layout

```
~/.nanobox/
├── current -> versions/v0.1.0/       ← Core code
├── versions/v0.1.0/
├── config/                           ← USER config (never touched by updates)
├── agents/                           ← USER agent definitions
├── tools/                            ← USER tool definitions
├── mcp-servers/                      ← USER MCP registrations
├── vault/                            ← USER knowledge base
├── user-scripts/                     ← USER scripts
├── skills/                           ← USER skills
├── memory.db                         ← Sessions + facts + tokens
├── .env                              ← Secrets
├── backup/                           ← Auto-generated backups
├── logs/                             ← Log files
├── run/                              ← PID files
└── quarantine/                       ← Security threats
```
