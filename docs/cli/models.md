# NanoBox Providers and Named Models

NanoBox separates three concepts:

1. **Provider configuration** — how bx-ai connects to a provider.
2. **Discovered/configured models** — models exposed by that provider.
3. **Named models** — reusable user-defined aliases with a provider and options.

This follows Hermes' convenient model-selection workflow while retaining bx-ai's provider abstraction.

## Supported provider catalog

NanoBox recognizes the bx-ai provider services:

```text
openrouter
openai
anthropic
gemini
deepseek
grok
groq
mistral
minimax
ollama
openai-compatible
huggingface
cohere
perplexity
bedrock
voyage
docker
elevenlabs
```

Providers are configured by logical name. A logical alias can use a different bx-ai service type:

```text
lmstudio → type=openai-compatible → bx-ai service=openai-compatible
```

## Provider commands

```bash
nanobox config provider list
nanobox config provider status
nanobox config provider add <name>
nanobox config provider set <name>
nanobox config provider remove <name>
```

Example:

```bash
nanobox config provider add lmstudio \
  --type=openai-compatible \
  --baseURL=http://localhost:1234/v1 \
  --credential-env=LMSTUDIO_API_KEY
```

Credentials are stored as environment references and never printed as values:

```json
{
  "type": "openai-compatible",
  "baseURL": "http://localhost:1234/v1",
  "apiKey": "${LMSTUDIO_API_KEY}"
}
```

Provider status reports configured providers, credential source, and defaults without exposing secrets:

```bash
nanobox config provider status
```

## Interactive model setup

```bash
nanobox model setup
```

The flow configures the provider and model together:

1. Choose or enter a logical provider name.
2. Choose the provider service type.
3. Enter the base URL for OpenAI-compatible services.
4. Enter a credential environment-variable name.
5. Discover available models through bx-ai.
6. Select the default model.
7. Persist provider and default model settings.

LM Studio example:

```bash
nanobox model setup lmstudio
```

Default URL:

```text
http://localhost:1234/v1
```

Non-interactive setup:

```bash
nanobox model setup lmstudio \
  --type=openai-compatible \
  --baseURL=http://localhost:1234/v1 \
  --model=qwen/qwen3.6-35b-a3b \
  --token-env=LMSTUDIO_API_KEY \
  --non-interactive
```

## Configured model status

```bash
nanobox model status
nanobox model status --provider=lmstudio
```

Status shows:

- Default provider
- Default model
- Named default model
- Every discovered/configured model grouped by provider
- Every named model and its options
- Provider configuration with secrets redacted

## Discovery

```bash
nanobox model list --provider=lmstudio
nanobox model refresh --provider=lmstudio
```

For OpenAI-compatible providers, NanoBox always passes the configured `baseURL` to bx-ai:

```text
aiService("openai-compatible", { baseURL: configuredBaseURL })
    → listModels()
```

## Named models

A named model is a reusable alias with:

- `name`
- `provider`
- `model`
- `options`

Create one:

```bash
nanobox model add local-coder \
  --provider=lmstudio \
  --model=qwen/qwen3.6-35b-a3b \
  --options='{"temperature":0.2,"max_tokens":4096}'
```

Set it as the default:

```bash
nanobox model add local-coder \
  --provider=lmstudio \
  --model=qwen/qwen3.6-35b-a3b \
  --default
```

Remove it:

```bash
nanobox model remove local-coder
```

Named model configuration:

```json
{
  "name": "local-coder",
  "provider": "lmstudio",
  "model": "qwen/qwen3.6-35b-a3b",
  "options": {
    "temperature": 0.2,
    "max_tokens": 4096
  }
}
```

Use a named model from chat:

```bash
nanobox chat --query="Write a BoxLang class" --named-model=local-coder
```

## Current selection

```bash
nanobox model current
```

Returns the selected provider, model, and named-model alias.
