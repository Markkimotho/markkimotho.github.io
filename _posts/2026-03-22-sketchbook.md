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

Sketchbook is a self-hosted, real-time collaborative drawing app. You run it yourself, you own the data, and you can share a link with anyone to draw together on the same canvas.

Here is what it supports right now: pencil, ink pen, brush, calligraphy, eraser, line, shapes, and a text tool. It has stylus and Apple Pencil support with real pressure sensitivity, and palm rejection so your hand resting on the iPad does not leave marks. There are multiple canvas surfaces — aged paper, kraft, watercolour, newsprint, old parchment, blackboard — plus ruled lines, grid, and dot grid overlays. It has layers, version history, and a chat panel for collaborating while drawing. It works on iPad, Android tablets, laptops, MacBooks, and phones.

The whole thing runs on Next.js with a Socket.io server for real-time sync and SQLite for storage. No external database to configure, no cloud dependencies. Set it up on any machine in a few minutes.

## Getting started

Everything you need is on [GitHub](https://github.com/Markkimotho/digital-art-collaboration). Clone the repo, install dependencies, and start drawing:

```bash
git clone https://github.com/Markkimotho/digital-art-collaboration.git
cd digital-art-collaboration
npm install
npm run dev
```

Open the [app locally](http://localhost:3000) in your browser and you are good to go.

## Running it with Docker

If you do not want to deal with Node.js installs, Docker is the cleaner option. The image is built on Node 22 Alpine and everything is bundled inside — dependencies, the Next.js build, Prisma client, and the server. Canvas data persists in a Docker volume so it survives restarts.

```bash
# build the image
docker build -t sketchbook:latest .

# run it
docker compose up
```

That is it. The app is at `http://localhost:3000`.

## Sharing it publicly

Running it on your own machine is fine for personal use but if you want to share a link with someone on the internet you have a few options.

The fastest is [ngrok](https://ngrok.com). While the container is running, open a second terminal and run:

```bash
ngrok http 3000
```

ngrok hands you a public HTTPS link immediately, something like `https://abc123.ngrok-free.app`. Send that to anyone and they can open it in a browser and join your canvas. No domain, no server, no setup. Works well for sessions where you just want to draw with someone right now.

For a permanent link you need a server. Spin up a cheap VPS — Hetzner, DigitalOcean, Linode, any of them work — install Docker, clone the repo, and run `docker compose up -d`. Point a domain at the server IP and put [Caddy](https://caddyserver.com) in front of it for automatic HTTPS:

```
sketchbook.yourdomain.com {
    reverse_proxy localhost:3000
}
```

Your public link becomes `https://sketchbook.yourdomain.com`. Anyone can open it, create a room, and share the room URL with collaborators.

For a more production setup there are Kubernetes manifests in the repo. They cover the deployment, a persistent volume for the database, a ClusterIP service, nginx ingress with WebSocket headers, and cert-manager for automatic TLS certificates from Let's Encrypt. You update the domain in the ingress file, push your image to a registry, apply the manifests with `kubectl apply -f k8s/`, and the cluster handles the rest.

## How to use it

When you open the app you land on the lobby. Hit New Canvas and you get a fresh room. The URL in your browser is your room link — copy it and send it to whoever you want to draw with. They open the link and they are in the same canvas, live.

The toolbar sits at the top on desktop and on the left side on mobile. Your tools are grouped into three sections: drawing tools, shapes, and utility tools. Pick a tool, pick a color from the color swatch or use the color picker for anything custom, adjust the stroke size, and start drawing. If you are on an iPad or a tablet with a stylus, pressure sensitivity works out of the box — no setup needed. Press lightly for thin strokes, press harder for thick ones.

On the right side there is a panel with four tabs. Layers lets you add, rename, lock, and hide layers. Each layer is independent so you can sketch on one and ink on another without touching your base drawing. History is where you save named versions of your canvas. If you want to checkpoint your work before making big changes, save a version. If something goes wrong you can revert to any saved point and everyone in the room sees the canvas restore instantly.

Canvas is where you change the surface and grid. You can switch between aged paper, kraft, watercolour paper, newsprint, old parchment, and blackboard. Underneath that you can toggle ruled lines, a square grid, or a dot grid — useful if you are doing anything that needs alignment. Chat is a simple message panel. Useful when you are collaborating and need to say something without leaving the canvas.

The crosshair button at the bottom right of the canvas resets your view and fits everything you have drawn back into the screen. If you pan too far away and lose your work, that button brings you back. To pan around the canvas use the hand tool or two fingers on touch. To zoom, pinch on touch or scroll on desktop.

If you have ideas or want to contribute, open a pull request. It is completely free and open. If you need help getting a hosted version running, reach out through [GitHub](https://github.com/Markkimotho/digital-art-collaboration).
