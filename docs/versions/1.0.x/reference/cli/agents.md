---
title: "Agents"
order: 8
description: "NanoBox agents are persistent bx-ai agent definitions stored as Markdown files."
---

# Agents Namespace

NanoBox agents are persistent bx-ai agent definitions stored as Markdown files.

## Commands

```bash
nanobox agent list
nanobox agent create <name>
nanobox agent show <name>
nanobox agent update <name>
nanobox agent delete <name>
nanobox agent run <name> --query="..."
```

## Storage

Agents are stored under:

```text
$NANOBOX_HOME/agents/
```

Default:

```text
~/.nanobox/agents/
```

Each agent is a Markdown file with front matter:

```markdown
---
name: coder
description: Writes clean BoxLang code
model: qwen/qwen3.6-35b-a3b
options: {"temperature":0.2}
---

Write production-quality BoxLang code and include tests.
```

## Create

```bash
nanobox agent create coder \
  --description="Writes clean BoxLang code" \
  --model=qwen/qwen3.6-35b-a3b \
  --instructions="Write production-quality BoxLang code and include tests."
```

Names may contain only letters, numbers, hyphens, and underscores. Duplicate names are rejected.

## List

```bash
nanobox agent list
```

Lists all definitions and parsed metadata.

## Show

```bash
nanobox agent show coder
```

Shows the file path, metadata, model, options, and instructions.

## Update

```bash
nanobox agent update coder \
  --description="Reviews BoxLang code" \
  --instructions="Review code for correctness and security."
```

## Delete

```bash
nanobox agent delete coder
```

Deletes the definition file.

## Run

```bash
nanobox agent run coder --query="Review this BoxLang class"
```

Execution uses bx-ai's `aiAgent()` and `aiModel()`:

1. Load the Markdown definition.
2. Resolve the configured NanoBox provider.
3. Normalize OpenAI-compatible providers to the bx-ai `openai-compatible` service.
4. Pass provider options, including `baseURL`, into `aiModel()`.
5. Build `aiAgent()` with name, description, instructions, model, and parameters.
6. Run the query.

For LM Studio, configure the provider first:

```bash
nanobox config provider add lmstudio \
  --type=openai-compatible \
  --baseURL=http://localhost:1234/v1
nanobox config provider set lmstudio
```

## Failure behavior

Missing or invalid operations return structured errors and exit non-zero:

```bash
nanobox agent show missing
nanobox agent run missing --query="hello"
nanobox agent create "bad name"
nanobox agent unknown
```

## Tests

```text
tests/specs/AgentCommandSpec.bx
tests/specs/AgentNamespaceSpec.bx
tests/specs/AgentActiveCliSpec.bx
tests/specs/AgentExecutionSpec.bx
```

Coverage includes lifecycle operations, validation, failure paths, active runtime dispatch, and a real LM Studio bx-ai agent execution.
