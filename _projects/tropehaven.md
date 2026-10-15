---
published: true
layout: page
title: Tropehaven
description: A fiction wiki with article editing, discussion, and a draft-to-publication path
importance: 1
category: work
---

Tropehaven is a wiki for documenting works of fiction and the patterns inside them. The codebase also includes forums and a launchpad where proposed articles can be discussed before publication.

## How it works

Editors create or revise articles through Django forms. Articles keep their content in separate fields, such as description, quote, image, and short summary; a custom markup renderer formats text for the page. The codebase records edit history and supports search across article titles and descriptions.

The launchpad stores drafts, comments, and votes separately from published articles. A draft can then be launched as an article. Forum threads and posts provide a parallel space for discussion.

## The system

Django routes the wiki, forums, launchpad, accounts, and API into separate apps backed by PostgreSQL. Permission checks guard editing and moderation paths. The data model keeps article content, revisions, drafts, and discussion distinct rather than treating the whole site as one document store.

The repository is private, so this page describes the architecture without linking to source or exposing site data.
