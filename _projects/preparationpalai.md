---
published: true
layout: page
title: PreparationPalAI - Local RAG Study Assistant
redirect: https://github.com/Markkimotho/PreparationPalAI
description: A privacy-first study assistant with document RAG, quizzes, flashcards, and local LLMs
importance: 17
category: open-source
---

## Overview

**PreparationPalAI** is a local-first study assistant for learning from your own documents. It combines retrieval-augmented generation with quizzes, flashcards, web scraping, and programming help so learners can turn notes and reference material into an interactive study workflow.

The application runs with a React frontend and FastAPI backend, using LangChain, LangGraph, ChromaDB, and Ollama. Documents stay on your machine by default, and the local model setup needs no paid API key.

## Highlights

- **Document Q&A** with retrieved source context and citations
- **Quiz preparation** with generated questions, answers, and feedback
- **Flashcards** for active recall and spaced study sessions
- **Local models** through Ollama, with optional cloud-provider integrations
- **Multiple orchestration modes** using LangChain and LangGraph
- **Monitoring stack** with Prometheus, Loki, and Grafana configuration

## Getting Started

```bash
git clone https://github.com/Markkimotho/PreparationPalAI.git
cd PreparationPalAI
pip install -r requirements.txt

ollama pull llama3.2:1b
ollama pull nomic-embed-text
streamlit run app/ui.py
```

The project also includes Docker Compose configuration for running the application and its supporting services together.

## Technology Stack

| Component        | Technology                |
| ---------------- | ------------------------- |
| Frontend         | React, TypeScript, Vite   |
| Backend          | FastAPI, Python           |
| AI orchestration | LangChain, LangGraph      |
| Vector store     | ChromaDB                  |
| Local models     | Ollama                    |
| Observability    | Prometheus, Loki, Grafana |

[View on GitHub](https://github.com/Markkimotho/PreparationPalAI)
