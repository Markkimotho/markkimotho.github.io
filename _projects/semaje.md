---
published: true
layout: page
title: Semaje
redirect: https://github.com/semajehq/semaje
description: Self-hosted speech-to-text and text-to-speech across 1,600+ languages
importance: 18
category: open-source
---

Semaje is an open-source speech platform for transcription, dictation, captions, and read-aloud. It runs on your own infrastructure and brings speech recognition and synthesis together across a large range of languages, including many low-resource African languages.

## What changed from Voxail

Voxail was built around Gemini-based transcription. Semaje is the current project: a self-hosted platform using open models, with separate services for recognition, synthesis, the web app, and the browser extension. This page replaces the older Voxail description so the portfolio reflects the work as it stands now.

## How it is built

The platform coordinates uploads, background jobs, live transcription, and a searchable transcript library. Its speech-to-text services use Whisper and Omnilingual ASR; text-to-speech uses Piper, with optional MMS-TTS voices. A browser extension adds dictation, captions, and read-aloud where people are already working.

The code is split across the [Semaje organization](https://github.com/semajehq): the [platform](https://github.com/semajehq/semaje), [speech recognition](https://github.com/semajehq/semaje-stt), [speech synthesis](https://github.com/semajehq/semaje-tts), [web app](https://github.com/semajehq/semaje-web), and [browser extension](https://github.com/semajehq/semaje-extension). The platform README documents the setup and model choices.

## Why it matters

Language coverage is a design constraint, not an afterthought. The project routes speech to the recognition engine suited to that language, keeps processing on infrastructure you control, and lets users work with transcripts after the first pass.
