# Plan: `nanobox image` and `nanobox speak` Namespaces

> **Status:** Draft
> **Effort:** Small (3-4 hours total)
> **Depends on:** bx-ai module (aiImage, aiSpeak BIFs)

---

## Why

bx-ai already supports `aiImage()` and `aiSpeak()` BIFs with full provider support (OpenAI, Gemini, OpenRouter, etc.). NanoBox needs CLI commands to expose these — users shouldn't have to write BoxLang code to generate an image or synthesize speech.

## Background

### aiImage() BIF
```
aiImage( prompt, params, options )
```
- `params`: model, n, size, quality, style, output_format
- `options`: provider, apiKey, outputFile, outputFormat, timeout, logging
- Returns: `AiImageResponse` (has `.saveToFile(path)`) or file path string when `outputFile` is set
- Default save dir: `~/Pictures/nanobox/` (auto-created)

### aiSpeak() BIF
```
aiSpeak( text, params, options )
```
- `params`: model, voice, speed, response_format
- `options`: provider, apiKey, outputFile, outputFormat (mp3, opus, aac, flac, wav), returnFormat
- Returns: `AiSpeechResponse` (has `.saveToFile(path)`) or file path string when `outputFile` is set
- Default save dir: `~/Audio/nanobox/` (auto-created)

---

## Design

### `nanobox image` — Generate Images

```
nanobox image <prompt> [options]

Options:
  --output, -o <path>     Save path (default: ~/Pictures/nanobox/<timestamp>.png)
  --provider, -p <name>   AI provider (default: config default)
  --model, -m <name>      Model name
  --size, -s <dim>        Image size (e.g. 1024x1024, 1792x1024, 1024x1792)
  --quality, -q <name>    Quality: standard, hd, high
  --style, -S <name>      Style: vivid, natural
  --n <count>             Number of images (default: 1)
```

Output:
```
$ nanobox image "a cat riding a bicycle on the moon" --size 1024x1024
🎨 Image Generated
═══════════════════════════════════
  Provider:   openai (dall-e-3)
  Size:       1024×1024
  Quality:    hd
  Saved to:   ~/Pictures/nanobox/2026-07-26_091522.png
  Revised:    A whimsical illustration of a gray tabby...
```

### `nanobox speak` — Text-to-Speech

```
nanobox speak <text> [options]

Options:
  --output, -o <path>     Save path (default: ~/Audio/nanobox/<timestamp>.mp3)
  --provider, -p <name>   AI provider (default: config default)
  --model, -m <name>      Model name
  --voice, -v <name>      Voice: alloy, echo, fable, nova, shimmer, coral
  --speed, -S <float>     Speed (0.25 to 4.0, default 1.0)
  --format, -f <name>     Format: mp3, opus, aac, flac, wav
```

Output:
```
$ nanobox speak "Hello, welcome to NanoBox!" --voice nova --format mp3
🔊 Speech Generated
═══════════════════════════════════
  Provider:   openai (tts-1)
  Voice:      nova
  Duration:   2.4s
  Format:     mp3
  Saved to:   ~/Audio/nanobox/2026-07-26_091522.mp3
```

---

## Implementation

### Files

| File | Purpose |
|------|---------|
| `cli/commands/ImageCommand.bx` | `nanobox image` — resolves provider, calls aiImage(), saves output |
| `cli/commands/SpeakCommand.bx` | `nanobox speak` — resolves provider, calls aiSpeak(), saves output |
| `cli/CommandRuntime.bx` | Wire both commands (2 lines) |
| `tests/specs/ImageCommandSpec.bx` | Test image command dispatch |
| `tests/specs/SpeakCommandSpec.bx` | Test speak command dispatch |

### Command Pattern (follow ChatCommand.bx)

```boxlang
class {
    property configManager;

    function init( required any configManager ) {
        variables.configManager = arguments.configManager
        return this
    }

    struct function execute( required string action, struct args = {} ) {
        // Resolve provider/model from args or config defaults
        // Call aiImage() / aiSpeak() with the prompt/text and params
        // Save to default dir or specified output path
        // Return success struct with metadata
    }
}
```

### Wire in CommandRuntime.bx

```boxlang
case "image": return new "cli.commands.ImageCommand"( variables.config ).execute( action ?: "generate", args )
case "speak":
case "tts":   return new "cli.commands.SpeakCommand"( variables.config ).execute( action ?: "say", args )
```

### Provider/Model Resolution
Follow the same pattern as `ChatCommand.resolveModel()`:
1. Check for explicit `--provider` / `--model` in args
2. Check for `--named-model` in args
3. Fall back to `bx-ai.defaultProvider` / `bx-ai.defaultModel` from config

### Output File Management
- Default output directory: `~/Pictures/nanobox/` for images, `~/Audio/nanobox/` for speech
- Auto-create directories with `directoryCreate( path, true )`
- Filename format: `{timestamp}_{slugified-prompt-trunc}.{ext}`
- When `--output` is specified, use that path exactly

---

## Testing

| Test | What it verifies |
|------|-----------------|
| `ImageCommandSpec.bx` | Resolves provider, calls aiImage(), handles output path, missing provider |
| `SpeakCommandSpec.bx` | Resolves provider, calls aiSpeak(), handles output path, missing provider |

---

## Future (v0.2+)
- `nanobox image batch <file>` — generate from a file of prompts
- `nanobox transcribe <audio>` — speech-to-text (aiTranscribe BIF)
- `nanobox translate <text>` — translation (aiTranslate BIF)
