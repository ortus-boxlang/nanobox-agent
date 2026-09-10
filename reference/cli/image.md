---
title: "Image Generation"
order: 21
description: "Generate images from text prompts using AI providers via the aiImage() BIF."
---

# NanoBox Image Namespace

> Generate images from text prompts using AI providers via `aiImage()` BIF.

## Overview

The `image` command wraps bx-ai's `aiImage()` BIF, supporting OpenAI (DALL-E 3), Google Gemini (Imagen), OpenRouter, and any OpenAI-compatible provider. Images are saved to disk by default.

## Commands

### `nanobox image <prompt>`

Generate an image from a text description. Default save directory: `~/Pictures/nanobox/`.

```
$ nanobox image "a cat riding a bicycle on the moon" --size 1024x1024
🎨 Image Generated
═══════════════════════════════════
  Provider:   openai (dall-e-3)
  Size:       1024×1024
  Saved to:   ~/Pictures/nanobox/20260726_091522.png
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--size, -s` | Image dimensions (e.g. `1024x1024`, `1792x1024`, `1024x1792`) | Provider default |
| `--quality, -q` | Quality: `standard`, `hd`, `high` | Provider default |
| `--style, -S` | Style: `vivid`, `natural` | Provider default |
| `--n <count>` | Number of images to generate | 1 |
| `--output, -o <path>` | Custom save path | `~/Pictures/nanobox/<timestamp>.png` |
| `--provider, -p <name>` | AI provider override | Config default |
| `--model, -m <name>` | Model override | Config default |

## Examples

Generate with specific size and quality:

```bash
nanobox image "futuristic cityscape" --size 1792x1024 --quality hd
```

Use a specific provider:

```bash
nanobox image "a fox in an autumn forest" --provider gemini --size 1792x1024
```

Save to a custom path:

```bash
nanobox image "coffee shop interior" --output ~/Desktop/coffee.png
```

## Model Resolution Order

1. `--named-model=<name>` — named model config
2. `--provider=<name>` / `--model=<name>` — explicit override
3. Config defaults (`bx-ai.defaultProvider` / `bx-ai.defaultModel`)

## Supported Providers

| Provider | Model | Image Support |
|----------|-------|---------------|
| openai | dall-e-3 | ✅ Native |
| gemini | imagen | ✅ Native |
| openrouter | various | ✅ Via FLUX etc. |

## Storage

Default output directory: `~/Pictures/nanobox/` (auto-created on first use).

## Tests

```
tests/specs/ImageCommandSpec.bx
```
