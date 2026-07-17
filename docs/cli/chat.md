# NanoBox Chat Namespace

## Commands

```bash
nanobox chat --query="Your question"
nanobox chat -q "Your question"
```

Optional model selection:

```bash
nanobox chat --query="Write BoxLang" --provider=lmstudio --model=qwen/qwen3.6-35b-a3b
nanobox chat --query="Write BoxLang" --named-model=local-coder
```

Optional generation parameters:

```bash
nanobox chat \
  --query="Write a concise BoxLang class" \
  --temperature=0.2 \
  --max_tokens=4096
```

## Model resolution order

Chat resolves the model in this order:

1. `--named-model=<name>`
2. The configured `bx-ai.defaultNamedModel`
3. Explicit `--provider` and `--model`
4. `bx-ai.defaultProvider` and `bx-ai.defaultModel`
5. If no provider/model is available, setup is required.

## Automatic setup behavior

If chat is launched without a configured provider/model:

```bash
nanobox chat --query="Hello"
```

NanoBox routes the user to the model setup flow instead of sending an invalid AI request:

```text
No AI provider configured. Run nanobox model setup.
```

For non-interactive automation, configure the model first:

```bash
nanobox model setup lmstudio \
  --type=openai-compatible \
  --baseURL=http://localhost:1234/v1 \
  --model=qwen/qwen3.6-35b-a3b \
  --non-interactive
```

## Named models

Named models include:

```text
name
provider
model
options
```

Example:

```bash
nanobox model add local-coder \
  --provider=lmstudio \
  --model=qwen/qwen3.6-35b-a3b \
  --default
```

Use it:

```bash
nanobox chat \
  --query="Write a BoxLang class" \
  --named-model=local-coder
```

The named model's options are merged into the request parameters. CLI flags such as `--temperature` override named-model options.

## Provider routing

For an OpenAI-compatible logical provider such as LM Studio:

```text
logical provider: lmstudio
bx-ai service:     openai-compatible
base URL:          http://localhost:1234/v1
```

NanoBox always passes the configured base URL explicitly to `aiChat()`.

## Token tracking

Chat records provider, model, operation, session ID, and normalized usage data through `TokenTracker` when the provider returns usage information.

## Verification

Chat model selection was tested for:

- Configured default model
- Explicit named model
- Missing model/provider failure
- OpenAI-compatible LM Studio routing
- Token tracker integration

The active `nanobox.bx` path uses `CommandRuntime` and the same selection logic as direct command execution.
