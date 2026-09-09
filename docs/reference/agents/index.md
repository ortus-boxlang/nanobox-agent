---
title: "Agents"
order: 2
description: "How agent definitions are stored, the built-in agents, and how to create custom and sub-agents."
icon: "phosphor-duotone:robot"
---

# Agents

Agent definitions live in `~/.nanobox/agents/` as markdown files with YAML frontmatter.

## Built-in Agents

| Agent | Description | Model |
|-------|-------------|-------|
| orchestrator | Main agent — dispatches tasks to sub-agents | gpt-4o (configurable) |
| coder | Writes and reviews BoxLang/Java code | gpt-4o |
| researcher | Deep research with web search + vault | claude-sonnet-4 |
| planner | Breaks down complex tasks into steps | gpt-4o |

## Creating Agents

```bash
nanobox agent create
# Interactive: name, description, model, tools, instructions
```

Or create a markdown file manually:

```markdown
---
name: my-agent
description: "My custom agent"
model: gpt-4o
temperature: 0.3
tools:
  - webSearch@bxai
  - file_read
memory: hybrid
---

You are my custom agent. Your job is to...
```

## Sub-Agents

The orchestrator uses sub-agents for specialized tasks. Agent definitions can reference other agents via the `subAgents` frontmatter field.
