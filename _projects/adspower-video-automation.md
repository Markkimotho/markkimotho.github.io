---
published: true
layout: page
title: Video Publishing Automation
description: A private tool for scheduling and uploading videos across social platforms
importance: 2
category: work
---

This tool processes prepared video lists for TikTok, Instagram, YouTube, and Pinterest through configured AdsPower browser profiles.

## How it works

Each profile has a platform, an upload mode, and a CSV file of videos. The runner starts that browser profile through AdsPower's local API, connects Playwright to the live browser, waits for an optional scheduled time, and hands the CSV rows to a platform-specific upload routine. It records the result and closes the profile when the run finishes.

## The system

A Python command-line runner coordinates profiles with a bounded worker pool. Shared locks space out browser launches and API calls; connection retries and per-profile error handling keep one failed upload from stopping the remaining profiles. Logs make each run inspectable.

The repository is private. This page leaves out client configuration and does not link to source code.
