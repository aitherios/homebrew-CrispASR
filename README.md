# Homebrew tap for CrispStrobe tools

Homebrew tap for [CrispASR](https://github.com/CrispStrobe/CrispASR) and
[CrispEmbed](https://github.com/CrispStrobe/CrispEmbed) — C++ ggml runtimes
for speech and retrieval.

## Formulas

| Formula      | Description                                            |
|--------------|--------------------------------------------------------|
| `crispasr`   | Multilingual ASR and TTS (30+ backends, diarization)   |
| `crispembed` | Embeddings, retrieval, OCR, and document understanding |

## Install

```bash
brew install aitherios/crispasr/crispasr
brew install aitherios/crispasr/crispembed
```

## CrispASR usage

Refer to [CrispASR](https://github.com/CrispStrobe/CrispASR) for the full documentation.

```bash
# Download a model (e.g. VibeVoice ASR Q4)
hf download cstr/vibevoice-asr-GGUF vibevoice-asr-q4_k.gguf

# Transcribe a file
crispasr -m vibevoice-asr-q4_k.gguf --file audio.wav --backend vibevoice

# Live microphone transcription
crispasr --mic -m vibevoice-asr-q4_k.gguf
```

## CrispEmbed usage

Refer to [CrispEmbed](https://github.com/CrispStrobe/CrispEmbed) for the full documentation.

```bash
# List available models
crispembed --list-models

# Generate text embeddings
crispembed -m model.gguf --embed "your text here"

# Start an HTTP server
crispembed-server -m model.gguf --host 0.0.0.0 --port 8080
```
