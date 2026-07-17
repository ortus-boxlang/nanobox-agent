# MCP (Model Context Protocol)

NanoBox supports MCP servers for extending agent capabilities. MCP servers are registered in `~/.nanobox/mcp-servers/registry.json`.

## Configuration

```json
{
  "servers": [
    {
      "name": "github",
      "url": "http://localhost:3001",
      "token": "${GITHUB_TOKEN}",
      "toolNames": ["*"],
      "enabled": true
    }
  ]
}
```

## CLI

```bash
nanobox mcp list
nanobox mcp add
nanobox mcp remove github
nanobox mcp test github
```

## How It Works

When the orchestrator agent starts, it loads all enabled MCP servers via the `mcpServers` parameter of `aiAgent()`. Tools from MCP servers are auto-discovered and merged with the local tool registry.
