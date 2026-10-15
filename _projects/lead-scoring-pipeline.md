---
published: true
layout: page
title: Lead Scoring & Routing Pipeline
description: An internal workflow for evaluating prospect websites and routing qualified leads
importance: 16
category: work
---

This project assesses prospective clients' websites and helps decide which leads need follow-up. The repository is private, so this is a description of the workflow rather than a source-code link.

## How it works

The pipeline pulls lead records from Airtable, checks each company's website with BuiltWith and Google PageSpeed Insights, and combines technology and performance signals into a score. It writes the results back to Airtable and sends qualifying leads to Pipedrive with their assessment attached.

It supports dry runs and batch processing, making it possible to review scores before writing to the CRM or process a larger lead list in smaller groups.

## The system

The work connects several external services into one repeatable flow: data intake, website analysis, scoring, and CRM handoff. The dry-run option keeps the scoring step reviewable before records are changed.
