# NanoBox Speak (TTS) Namespace

> Synthesise text to speech using AI providers via `aiSpeak()` BIF.

## Overview

The `speak` command (aliased as `tts`) wraps bx-ai's `aiSpeak()` BIF, supporting OpenAI TTS and other providers. Audio files are saved to disk by default.

## Commands

### `nanobox speak <text>`

Synthesise speech from text. Default save directory: `~/Audio/nanobox/`.

```
$ nanobox speak "Hello, welcome to NanoBox!" --voice nova
🔊 Speech Generated
═══════════════════════════════════
  Provider:   openai (tts-1)
  Voice:      nova
  Format:     mp3
  Saved to:   ~/Audio/nanobox/20260726_091522.mp3
```

### `nanobox tts <text>`

Alias for `speak`.

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--voice, -v <name>` | Voice: `alloy`, `echo`, `fable`, `nova`, `shimmer`, `coral` | Provider default |
| `--speed, -S <float>` | Playback speed (0.25–4.0) | 1.0 |
| `--format, -f <name>` | Output format: `mp3`, `wav`, `flac`, `opus`, `pcm` | mp3 |
| `--output, -o <path>` | Custom save path | `~/Audio/nanobox/<timestamp>.mp3` |
| `--provider, -p <name>` | AI provider override | Config default |
| `--model, -m <name>` | TTS model override | Config default |
| `--timeout <sec>` | HTTP request timeout | 30 |

## Examples

Custom voice and speed:

```bash
nanobox speak "The quick brown fox" --voice alloy --speed 1.2
```

Choose output format:

```bash
nanobox speak "Welcome to NanoBox" --format wav --output ~/Desktop/welcome.wav
```

Use a specific model:

```bash
nanobox speak "High quality speech" --model tts-1-hd --voice nova
```

## Model Resolution Order

1. `--named-model=<name>` — named model config
2. `--provider=<name>` / `--model=<name>` — explicit override
3. Config defaults (`bx-ai.defaultProvider` / falls back to `openai`)

## Supported Providers

| Provider | Model | TTS Support |
|----------|-------|-------------|
| openai | tts-1, tts-1-hd | ✅ Native |
| mistral | (varies) | ✅ |
| gemini | (varies) | ✅ |
| grok | (varies) | ✅ |

## Storage

Default output directory: `~/Audio/nanobox/` (auto-created on first use).

## Tests

```
tests/specs/SpeakCommandSpec.bx
```
