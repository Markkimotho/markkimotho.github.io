---
layout: post
title: "Building a Local RAG Chatbot to Actually Understand How AI Reads Documents"
date: 2026-03-28 10:00:00
description: A fully local, privacy-first document chatbot built with LangChain, Ollama, and ChromaDB to learn how LLMs, retrieval-augmented generation, vector databases, and conversation memory actually work under the hood.
tags: projects ai llm rag langchain chromadb ollama python streamlit
categories: projects
giscus_comments: true
related_posts: true
---

I kept using AI tools to summarise documents without really understanding what was happening. I would upload a PDF, ask a question, and get an answer. It felt like magic. And I do not like magic I cannot explain.

So I built my own.

Not because the existing tools are bad. But because the only way I was going to understand how retrieval-augmented generation works, how a language model uses a local database to answer questions, and how a chatbot remembers what you said two messages ago — was to build it from scratch myself.

This is that project.

## Why I Built It

I was already comfortable using AI APIs. But I had surface-level understanding of what was happening between me asking a question and getting an answer back. I knew roughly: the model reads text, then responds. But what text? How does it know which parts of a 200-page report are relevant? Why does it sometimes forget what I asked three questions ago?

I wanted answers to those questions. Real answers. Not blog posts summarising other blog posts, but the kind of understanding you only get by writing the code yourself and watching it fail in ways that teach you something.

The other motivation was privacy. Every time you upload a document to a hosted AI tool, that document leaves your machine. For personal notes, work reports, or anything sensitive, that matters. I wanted a chatbot that ran entirely on my own computer. No API keys. No data leaving. No monthly bill.

Both problems pointed to the same solution: build a local RAG system from scratch.

## What RAG Actually Is

Before I built this, I thought RAG sounded complicated. It is not. The idea is straightforward once you see it laid out:

1. You have documents. The system reads them and stores the content in a searchable database.
2. You ask a question. The system searches that database for the most relevant pieces of text.
3. Those pieces get handed to the language model alongside your question.
4. The model answers based on what it was just shown, not from its own training data.

That last part is the key insight. The model is not memorising your documents. It is reading relevant excerpts in the moment and responding to them. This is why it can answer questions about documents that existed after the model was trained. It never needs to learn from them. It just reads them on demand.

The "augmented" part of retrieval-augmented generation is simply that: you are augmenting the model's context with retrieved text.

## The Local Stack

Everything in this project runs on your own machine. No external services.

**Ollama** handles the language models. It is a tool that lets you download and run open-source models locally — the same way you might install any other program. I used `llama3.2:1b` as the default because it is fast on modest hardware, but the chatbot supports `llama3.2`, `mistral`, and `gemma2:2b` too. You can switch between them in the UI at runtime and compare how each one answers the same question.

Ollama also handles the embeddings. An embedding is how you turn text into numbers — specifically a list of 768 numbers — in a way that captures meaning. Similar sentences end up with similar numbers. This is what makes the search actually semantic rather than just keyword matching. The model doing this is called `nomic-embed-text` and it runs locally through Ollama as well.

**ChromaDB** is the vector database. This is where all the embedded chunks of your documents live. When you ask a question, that question gets turned into numbers (embedded) and ChromaDB finds the stored chunks with the closest numbers. Those chunks are what gets passed to the language model as context.

**LangChain** provides the glue. It connects the retriever, the memory, the prompts, and the model into a coherent pipeline. I also built an alternative pipeline using **LangGraph**, which models the same process as a graph of steps — useful for understanding how stateful AI workflows are structured.

**Streamlit** is the interface. It gives you a chat panel, a sidebar for settings, and a way to upload PDFs directly in the browser.

## How Documents Get Into the System

When you upload a PDF, a few things happen in sequence.

First, the text is extracted page by page. Each page knows which file it came from and what page number it is.

Second, the text gets split into chunks. A chunk is typically around 1000 characters with 200 characters of overlap with the adjacent chunk. The overlap is important — it means that a sentence sitting near a chunk boundary does not get cut in half and lose its context. If a key fact spans the end of one chunk and the beginning of the next, both chunks carry enough of it to be useful.

Third, each chunk gets embedded — converted into those 768 numbers that capture its meaning.

Fourth, the chunks and their embeddings get stored in ChromaDB. Each chunk also gets a deterministic ID based on the filename, page number, and its position in the file. This means if you re-upload the same PDF, it overwrites the existing chunks rather than creating duplicates.

That is the whole ingestion process. After it runs, your document is searchable.

## How Questions Get Answered

When you type a question, the system does not just hand it directly to the language model. There is a step first.

If you have been having a conversation, your question might be a follow-up. "What about the risks?" does not mean much on its own. So the system first rewrites your question to be self-contained, using the conversation history. "What about the risks?" becomes "What are the risks identified in the financial report?" before it ever hits the search.

That rewritten question then gets embedded and searched against ChromaDB. The top five most relevant chunks come back — by default five, though you can adjust this.

Those chunks, plus your original question, plus the conversation history, get assembled into a prompt. The language model reads all of it and produces an answer. The answer includes citations: which file, which page. If the documents do not contain anything relevant, the model says so rather than making something up.

## The Memory Problem

One of the things I most wanted to understand was how a chatbot remembers things.

The answer is simpler and more limited than I expected: it does not really remember. It just receives more text.

Each time you send a message, the system packages up some number of previous exchanges and includes them in what the model reads. The model is not maintaining an internal state. It is reading the recent history every single time, as if it is encountering it fresh. The "memory" is just a sliding window of previous messages.

The tradeoff is real. A larger window means the model has more context and can follow longer threads. But every message in that window takes up space in the model's context limit. The bigger the history you send, the less room there is for retrieved document chunks. I set the default window at ten exchanges, which is a reasonable balance for most conversations.

The project implements this two ways. The LangChain mode keeps a simple in-memory buffer per session — a list of messages that gets truncated to the window size. The LangGraph mode uses a checkpointer called `MemorySaver`, which persists the entire conversation graph state per thread. The LangGraph approach is more structured and closer to how production AI systems manage state.

Building both and being able to switch between them taught me more about memory handling than any article I had read.

## Comparing Models Side by Side

One of the later features I added is a multi-model analysis tab. You write a question, select multiple models, and it runs them all in parallel against your documents and shows you each answer side by side.

This turned out to be more revealing than I expected. Different models emphasise different things. One model might pull out specific numbers from a report while another gives a better narrative summary. One might be more cautious and hedge its claims; another will be more assertive. Seeing them respond to the same context simultaneously makes the differences concrete in a way that comparing them separately never does.

Each response also gets a rough quality score based on things like word count, whether it used bullet points or headers, and whether it included specific numbers or dates. This is a heuristic, not a real quality measure, but it gives a quick signal for which answer to read first.

## What I Actually Learned

**RAG is a retrieval problem as much as a generation problem.** The quality of the answer depends heavily on whether the right chunks came back from the search. If the retrieval fails — wrong chunks, not enough chunks, chunks that are too small to carry meaning — the model has nothing useful to work with. I spent more time thinking about chunking strategy and top-K values than I expected to.

**Embeddings are not magic, they are geometry.** When you embed a question and search for nearby vectors, you are doing geometry in 768-dimensional space. The intuition of "similar meaning = similar direction" is real and testable. You can see it working when a vague question still returns the right document section because the concepts overlap even if the words do not.

**Memory has a cost.** Adding more history to the context does not just help. It takes up space that could have been retrieval results, it slows down the model, and it can confuse it if the history is long enough. Understanding the tradeoff changed how I think about context windows in general.

**Two ways to build the same pipeline teaches you both.** Having LangChain and LangGraph as switchable implementations of the same workflow made the architectural differences obvious. LangChain reads like a chain of function calls. LangGraph reads like a flow diagram. Both produce the same result. But LangGraph makes the state explicit, which matters when you start thinking about more complex workflows with branching or conditional steps.

**Local models are genuinely capable now.** Running `llama3.2:1b` locally on a laptop and getting coherent, cited answers from uploaded PDFs in a few seconds was not the experience I had expected. The smaller models are fast. The larger ones are slower but noticeably better at following complex instructions and synthesising information across multiple sources.

## Running It

Everything runs locally. You need Python, Ollama installed, and the models pulled.

```bash
git clone <repo-url>
cd rag-ai-chat-bot-with-langchain
pip install -r requirements.txt

# Pull the models (Ollama must be running)
ollama pull llama3.2:1b
ollama pull nomic-embed-text

# Start the UI
streamlit run app/ui.py
```

Open `http://localhost:8501`, upload a PDF from the sidebar, and ask questions about it. That is the whole setup.

If you want Docker:

```bash
docker-compose up --build
```

No environment variables required to get started. All defaults work out of the box.

## Wrap Up

I understand how RAG works now. Not just the concept but the mechanics. How text becomes vectors. How vectors become search results. How search results become context. How context becomes an answer. How previous answers become memory for the next question.

I built this for myself, to learn. It is not the most polished tool out there. But it is mine and I understand every part of it.

If you want to understand these things too, build one. Do not just use the abstractions. Drop into the code and see what is actually happening. The understanding you get from watching a chunking strategy produce worse search results than you expected, or from seeing memory overflow degrade a conversation, is worth more than any number of articles about it.

The code is on GitHub. Clone it, break it, change it. That is the point.
