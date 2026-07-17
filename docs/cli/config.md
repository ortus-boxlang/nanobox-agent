# Config Namespace

The config namespace is fully wired through the active `nanobox.bx` entry point.

## Core config commands

```bash
nanobox config show
nanobox config get <key>
nanobox config set <key> <value>
nanobox config unset <key>
nanobox config path
```

Examples:

```bash
nanobox config get bx-ai.defaultProvider
nanobox config set nanobox.web.port 8080
nanobox config unset nanobox.web.port
nanobox config path
```

## Provider commands

```bash
nanobox config provider list
nanobox config provider status
nanobox config provider current
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

Provider credentials are persisted as environment-variable references and are not printed in configuration output.

## Model compatibility aliases

The config namespace also accepts model subcommands for compatibility with the documented CLI:

```bash
nanobox config model list
nanobox config model current
nanobox config model set <model>
nanobox config model refresh
```

The canonical model namespace is:

```bash
nanobox model ...
```

## Configuration storage

Default path:

```text
~/.nanobox/config/nanobox.json
```

The root `ConfigManager` owns:

- Defaults
- Nested dot-path reads/writes
- Unset operations
- Environment reference resolution
- Configuration directory creation
- Preferences storage

## Security

`config show` recursively redacts secret-shaped keys:

```text
apiKey
 token
password
secret
```

Output uses:

```text
[REDACTED]
```

## Failure behavior

Missing required values and unknown actions return a structured failure and the active CLI exits non-zero:

```bash
nanobox config get
nanobox config set
nanobox config unknown
```

## Verification

The config namespace is covered by:

```text
tests/specs/ConfigCommandSpec.bx
tests/specs/ConfigNamespaceSpec.bx
tests/specs/ConfigActiveCliSpec.bx
```

Coverage includes direct command behavior, active runtime dispatch, positional arguments, missing-key failures, unknown-action failures, persistence, path reporting, nested configuration, and secret redaction.
