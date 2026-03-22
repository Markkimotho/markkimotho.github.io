---
layout: post
title: "Sketchbook: My Self-Hosted Drawing App"
date: 2026-03-22 10:00:00
description: A self-hosted, real-time collaborative drawing app built for artists who miss the feel of old paper.
tags: projects art collaboration open-source
categories: projects
giscus_comments: true
related_posts: true
---

I have loved art since I was young. Pencils, crayons, whatever I could get my hands on. I most especially loved drawing on old paper — notebooks, margins of textbooks, any blank surface available. As I got older that love shifted toward digital art. Layers, undo, infinite color. I spent a lot of time exploring what was possible.

I was not very satisfied with the tools I came across though. So I decided to make my own. One that has that unbeatable look of old paper, rustic, and albeit being on a screen you can almost feel the roughness of the paper.

It has taken a good while to get here. I have been working on it steadily, refining how the tools feel, getting the real-time collaboration solid, and making sure it holds up across different devices.

## What is Sketchbook?

Sketchbook is a self-hosted, real-time collaborative drawing app. You run it yourself, you own the data, and you can share a link with anyone to draw together on the same canvas.

## Features

### Drawing tools

- Pencil, ink pen, brush, calligraphy, eraser
- Line and shape tools
- Text tool
- Stylus and Apple Pencil support with real pressure sensitivity
- Palm rejection so your hand resting on the iPad does not leave marks

### Canvas surfaces

One of the things I cared about most was getting the surfaces right. Sketchbook ships with:

- Aged paper
- Kraft paper
- Watercolour paper
- Newsprint
- Old parchment
- Blackboard

Each one has its own texture and character. You pick the one that fits the mood of what you are making.

### Overlays

- Ruled lines
- Grid
- Dot grid

### Collaboration

- Real-time drawing with anyone you share a link with
- Layers
- Version history
- Built-in chat panel for communicating while drawing

### Device support

Works on iPad, Android tablets, laptops, MacBooks, and phones. If it has a browser, it runs.

## Under the hood

The stack is straightforward:

- **Next.js** for the frontend and server
- **Socket.io** for real-time sync between collaborators
- **SQLite** for lightweight, file-based storage

No external database to configure, no cloud dependencies. Set it up on any machine in a few minutes.

## Getting started

Everything you need is on GitHub:

[https://github.com/Markkimotho/digital-art-collaboration](https://github.com/Markkimotho/digital-art-collaboration)

Clone the repo, install dependencies, and start drawing:

```bash
git clone https://github.com/Markkimotho/digital-art-collaboration.git
cd digital-art-collaboration
npm install
npm run dev
```

That is it. Open the app in your browser and you are drawing.

## Contributing

If you have ideas or want to contribute, open a pull request. The project is completely free and open source. If you need help getting a hosted version running, reach out through GitHub.
