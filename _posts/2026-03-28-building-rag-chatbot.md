---
layout: post
title: "Building a Local RAG Chatbot to Actually Understand How AI Reads Documents"
date: 2026-03-28 10:00:00
last_updated: 2026-11-06
description: How PreparationPalAI uses FastAPI, React, Ollama, LangChain, and ChromaDB for local document chat, exam practice, and technical interview preparation.
tags: projects ai llm rag langchain chromadb ollama python fastapi react
categories: projects
giscus_comments: true
related_posts: true
---

I kept using AI tools to summarise documents without really understanding what was happening. I would upload a PDF, ask a question, and get an answer. It felt like magic. And I do not like magic I cannot explain.

So I built my own.

Not because the existing tools are bad. But because the only way I was going to understand how retrieval-augmented generation works, how a language model uses a local database to answer questions, and how a chatbot remembers what you said two messages ago — was to build it from scratch myself.

This is that project.

It has since grown into [PreparationPalAI](https://github.com/Markkimotho/PreparationPalAI), a study tool for document questions, exam practice, technical interviews, and revision. The current application uses a React frontend and a FastAPI backend. I have updated the setup instructions below to match it.

## Why I Built It

I was already comfortable using AI APIs. But I had surface-level understanding of what was happening between me asking a question and getting an answer back. I knew roughly: the model reads text, then responds. But what text? How does it know which parts of a 200-page report are relevant? Why does it sometimes forget what I asked three questions ago?

I wanted answers to those questions. Real answers. Not blog posts summarising other blog posts, but the kind of understanding you only get by writing the code yourself and watching it fail in ways that teach you something.

The other motivation was privacy. Uploading documents to a hosted AI service means sending them to someone else's infrastructure. For personal notes, work reports, or anything sensitive, that matters. I wanted the document store and inference to run on my own computer, without a paid AI API.

Both problems pointed to the same solution: build a local RAG system from scratch.

## What RAG Actually Is

Before I built this, I thought RAG sounded complicated. It is not. The idea is straightforward once you see it laid out:

1. You have documents. The system reads them and stores the content in a searchable database.
2. You ask a question. The system searches that database for the most relevant pieces of text.
3. Those pieces get handed to the language model alongside your question.
4. The model is instructed to answer from those excerpts and identify its sources.

That last part is the key insight. The model is not being retrained on your documents. It receives relevant excerpts at the time you ask. This lets it use material written after its training cutoff, but it can still mix in unsupported claims. Retrieval gives it evidence; it does not guarantee that the answer is correct.

The "augmented" part of retrieval-augmented generation is simply that: you are augmenting the model's context with retrieved text.

## The Local Stack

The default setup runs the application, model service, and document store locally. Initial installation and model downloads need internet access. Web search contacts external services when enabled, and configuring a remote Ollama endpoint sends inference requests to that endpoint.

**Ollama** handles local model inference. The current default chat model is `qwen2.5:7b`. The model picker discovers installed models and includes configurable GLM and DeepSeek choices alongside other local models. A catalogue entry does not mean the model is installed or that its answer quality has been evaluated. Each model also has its own licence and hardware requirements.

Ollama also handles embeddings, using `nomic-embed-text` by default. An embedding turns text into a numerical vector that represents aspects of its meaning. Comparing those vectors lets the retriever find passages with related concepts, even when the wording differs.

**ChromaDB** is the vector database. This is where all the embedded chunks of your documents live. When you ask a question, that question gets turned into numbers (embedded) and ChromaDB finds the stored chunks with the closest numbers. Those chunks are what gets passed to the language model as context.

**LangChain** provides the glue. It connects the retriever, the memory, the prompts, and the model into a coherent pipeline. I also built an alternative pipeline using **LangGraph**, which models the same process as a graph of steps — useful for understanding how stateful AI workflows are structured.

**FastAPI** serves the API and, in the production build, the compiled frontend. It handles model requests, ingestion jobs, quizzes, saved study sessions, and exports.

**React and Vite** provide the browser interface. The workspace has a model picker, knowledge-base controls, document chat, quiz practice, flashcards, and a preparation coach. During development, Vite runs separately and proxies API requests to FastAPI. In the Docker setup, you open the app on port 8000.

## How Documents Get Into the System

When you upload a PDF, a few things happen in sequence.

First, an ingestion job extracts the text page by page, keeping the source and page number with it. The app also supports image uploads and OCR. That does not mean every handwritten equation or diagram will be read correctly.

Second, the text gets split into chunks. A chunk is typically around 1000 characters with 200 characters of overlap with the adjacent chunk. The overlap is important — it means that a sentence sitting near a chunk boundary does not get cut in half and lose its context. If a key fact spans the end of one chunk and the beginning of the next, both chunks carry enough of it to be useful.

Third, each chunk gets embedded into a numerical vector.

Fourth, the chunks and their embeddings get stored in ChromaDB. Uploaded chunks get deterministic IDs that include the source, page, position, and content. Identical chunks can be skipped on re-upload instead of being embedded again.

That is the whole ingestion process. After it runs, your document is searchable.

## How Questions Get Answered

When you type a question, the system does not just hand it directly to the language model. There is a step first.

If you have been having a conversation, your question might be a follow-up. "What about the risks?" does not mean much on its own. So the system first rewrites your question to be self-contained, using the conversation history. "What about the risks?" becomes "What are the risks identified in the financial report?" before it ever hits the search.

That rewritten question then gets embedded and searched against ChromaDB. The default retrieval count is five, though different study tasks can request a different number. The retriever also applies a conservative topic-term check to reduce unrelated results. That check can miss synonyms, so fewer results do not necessarily mean the subject is absent from the documents.

Those chunks, your question, and the conversation history get assembled into a prompt. Source-backed answers should identify the supporting file and page. Input and output safety checks run around inference, and grounded answers receive a separate review before they are shown. If a check fails, the app withholds the response and asks for a retry or relevant material.

These checks add time and can make mistakes themselves. A source name in an answer is still something to verify, not proof that the claim came from that source.

## The Memory Problem

One of the things I most wanted to understand was how a chatbot remembers things.

The answer is simpler and more limited than I expected: it does not really remember. It just receives more text.

Each time you send a message, the system packages up some number of previous exchanges and includes them in what the model reads. The model is not maintaining an internal state. It is reading the recent history every single time, as if it is encountering it fresh. The "memory" is just a sliding window of previous messages.

The tradeoff is real. A larger window means the model has more context and can follow longer threads. But every message in that window takes up space in the model's context limit. The bigger the history you send, the less room there is for retrieved document chunks. I set the default window at ten exchanges, which is a reasonable balance for most conversations.

The project implements this two ways. The LangChain mode keeps an in-memory buffer per session, truncated to the configured window. The LangGraph mode uses `MemorySaver` to hold graph state per thread while the process is running. Neither is durable chat storage across a server restart. Saved coach sessions and flashcard decks use separate persistent stores.

Building both and being able to switch between them taught me more about memory handling than any article I had read.

## From Document Chat to Study Practice

PreparationPalAI now uses the same document and model pipeline for more than chat. Preparation Coach has recap, exam practice, technical interview, and weak-area review modes. Quiz Prep and flashcards provide shorter practice sessions. Sessions using retrieved material list their sources; sessions without relevant material are labelled as general model knowledge.

Questions can be downloaded as fillable PDF exams, written worksheets, or revision checklists. Reference answers are kept in a separate export. The [user guide](https://markkimotho.github.io/PreparationPalAI/) explains these workflows; the [contributor handbook](https://markkimotho.github.io/PreparationPalAI/contribute/) covers the implementation separately.

For visual questions, an embedded Excalidraw workspace supports diagrams, graphs, labels, and freehand work. Drawings can be saved and submitted for human review. The AI review path requires an installed vision-capable model. The default `qwen2.5:7b` is text-only and cannot inspect a drawing. Live diagram-feedback quality remains an [open evaluation task](https://github.com/Markkimotho/PreparationPalAI/issues/18), covering both multimodal models and classical computer vision.

Switching models is useful, but a confident explanation or a neatly formatted answer is not a quality measure. The project keeps separate evaluation reports rather than treating a model's presence in the picker as evidence that it performs well across every subject.

## What I Actually Learned

**RAG is a retrieval problem as much as a generation problem.** The quality of the answer depends heavily on whether the right chunks came back from the search. If the retrieval fails — wrong chunks, not enough chunks, chunks that are too small to carry meaning — the model has nothing useful to work with. I spent more time thinking about chunking strategy and top-K values than I expected to.

**Embeddings are geometry.** The retriever compares vectors to find related passages. That is useful, but the nearest passage can still be irrelevant when the document collection does not cover the question. Checking what was retrieved matters as much as checking the final response.

**Memory has a cost.** Adding more history to the context does not just help. It takes up space that could have been retrieval results, it slows down the model, and it can confuse it if the history is long enough. Understanding the tradeoff changed how I think about context windows in general.

**Two ways to build the same pipeline teaches you both.** Having LangChain and LangGraph as switchable implementations of the same workflow made the architectural differences obvious. LangChain reads like a chain of function calls. LangGraph reads like a flow diagram. Both produce the same result. But LangGraph makes the state explicit, which matters when you start thinking about more complex workflows with branching or conditional steps.

**Local inference makes the tradeoffs visible.** Model size, context length, output limits, and review passes all affect response time and memory use. A model that works for conversation may struggle with structured quiz output or tool calls. Those are behaviours to test, not capabilities to assume from the model's name.

## Running It

The simplest installation uses Docker with Compose:

```bash
git clone https://github.com/Markkimotho/PreparationPalAI.git
cd PreparationPalAI
docker compose up --build
```

Open `http://localhost:8000` when startup finishes. The initial setup builds the app and downloads `qwen2.5:7b` and `nomic-embed-text`, so allow time and several gigabytes of free storage. Later starts reuse the model files.

For development, install Python 3.11+, Node.js 22.12+, and Ollama. Start Ollama, then run the backend:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
ollama pull qwen2.5:7b
ollama pull nomic-embed-text
uvicorn app.api:app --reload
```

In a second terminal, from the repository root:

```bash
cd frontend
npm ci
npm run dev
```

Open `http://localhost:5173` for the development UI. Vite proxies API requests to port 8000. To serve the frontend through FastAPI instead, run `npm run build` in `frontend` and open `http://localhost:8000/prepare`.

The [installation guide](https://markkimotho.github.io/PreparationPalAI/start/access/) covers personal setup. Use the [development instructions](https://markkimotho.github.io/PreparationPalAI/contribute/development/) for platform notes and OCR dependencies, and the deployment runbook before exposing a workspace to other people.

## Wrap Up

I understand how RAG works now. Not just the concept but the mechanics. How text becomes vectors. How vectors become search results. How search results become context. How context becomes an answer. How previous answers become memory for the next question.

I built this for myself, to learn. It is not the most polished tool out there. But it is mine and I understand every part of it.

If you want to understand these things too, build one. Do not just use the abstractions. Drop into the code and see what is actually happening. The understanding you get from watching a chunking strategy produce worse search results than you expected, or from seeing memory overflow degrade a conversation, is worth more than any number of articles about it.

The code is on [GitHub](https://github.com/Markkimotho/PreparationPalAI). Clone it, break it, change it. That is the point.
