---
published: true
layout: page
title: Batch Image Generator
description: A desktop app that turns spreadsheet prompts into batches of generated images
importance: 3
category: work
---

This desktop application turns spreadsheet rows into image-generation jobs. It supports cloud providers, a local model, and an optional browser mode.

## How it works

The Excel reader extracts a prompt, tags, filename, aspect ratio, and optional reference image from each row. A batch runner builds the final prompt, selects the provider, and saves each generated image to an output folder. Existing output files can be skipped when a batch is resumed.

## The system

A Tkinter interface collects files and generation settings, then runs the batch outside the UI thread. Provider-specific clients handle Gemini, ChatGPT image generation, local Stable Diffusion, or browser-based generation. Progress, pause, and stop controls feed back into the runner so a long batch remains manageable.

The source is in a private repository under a collaborator's account, so this page does not link to it or expose prompts and generated files.
