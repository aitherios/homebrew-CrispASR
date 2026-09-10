# Homebrew tap for CrispASR

Homebrew tap for [CrispASR](https://github.com/CrispStrobe/CrispASR), a C++
ggml runtime for multilingual ASR and TTS.

## Install

```bash
brew install aitherios/crispasr/crispasr
```

## Usage

This is a simple example, please refer to [CrispASR](https://github.com/CrispStrobe/CrispASR) for the full documentation.

```bash
# Download a model (e.g. VibeVoice ASR Q4)
hf download cstr/vibevoice-asr-GGUF vibevoice-asr-q4_k.gguf

# Transcribe a file
crispasr --model vibevoice-asr-q4_k.gguf --file audio.wav --backend vibevoice

# Live microphone transcription
crispasr --mic --model vibevoice-asr-q4_k.gguf
```
