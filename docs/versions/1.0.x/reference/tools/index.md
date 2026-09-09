---
title: "Tools"
order: 4
description: "The three layers of NanoBox tools -- bx-ai built-ins, MCP tools, and user-defined tools -- and how to author custom tools."
icon: "phosphor-duotone:wrench"
---

# Tools

NanoBox has three layers of tools:

1. **bx-ai built-in tools** — `webSearch@bxai`, `imageGen@bxai`, etc. Pre-registered in the tool registry
2. **MCP server tools** — Tools exposed by configured MCP servers, auto-discovered
3. **User tools** — Custom tools in `~/.nanobox/tools/`

## Tool Registry

```bash
nanobox tool list
# Shows all registered tools from all sources

nanobox tool show webSearch@bxai
# Shows tool definition

nanobox tool create
# Interactive wizard to create a custom tool
```

## Custom Tools

Custom tools are defined as markdown files in `~/.nanobox/tools/`:

```markdown
---
name: summarize_page
description: "Fetch and summarize any web page"
parameters:
  - name: url
    type: string
    description: "The URL to summarize"
    required: true
---

(url, maxLength = 200) => {
    var content = bxai_webExtract(url)
    return aiChat("Summarize this in #maxLength# words: #content#")
}
```
