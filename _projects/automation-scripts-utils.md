---
published: true
layout: page
title: Automation Scripts & Utils
redirect: https://markkimotho.github.io/automation-scripts-utils/
description: Reusable bash & Python automation for the everyday tasks developers repeat
importance: 9
category: open-source
---

## Overview

A toolkit of small, reusable scripts for the chores developers retype by hand:
creating, renaming and merging repos, untangling git conflicts, rebuilding
environments, auditing dependencies across languages, and more. Bash for
orchestration; Python the moment there's real parsing or logic.

Every script is self-contained, has `--help`, confirms before anything
outward-facing or destructive, runs non-interactively for CI, and works on
stock macOS bash 3.2.

## Highlights

- **Git & GitHub** — merge PRs, create/rename repos, enable Pages, open PRs,
  PR-status dashboards, releases, a rule-based conflict helper, safe checkout,
  branch cleanup, and one-command sync.
- **Cross-language dependency tooling** — outdated packages, unused deps,
  lockfile drift, vulnerability scans, and license audits across pip, npm,
  cargo, go, and bundler in one run.
- **Dev environment** — a `dev-doctor` tool check, project scaffolding,
  pre-commit setup, and virtualenv rebuilds.
- **Data & housekeeping** — CSV/JSON/YAML conversion, secret scanning, artifact
  cleanup, and timestamped snapshots.

## Documentation & source

- Docs: [markkimotho.github.io/automation-scripts-utils](https://markkimotho.github.io/automation-scripts-utils/)
- [View on GitHub](https://github.com/Markkimotho/automation-scripts-utils)
