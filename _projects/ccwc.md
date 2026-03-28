---
published: true
layout: page
title: ccwc - Custom File Statistics Tool
description: A command-line utility providing file statistics similar to Unix wc
img:
importance: 10
category: open-source
---

## Overview

**ccwc** is a command-line utility that provides various statistics about a given file, similar to the Unix `wc` tool. It counts the number of bytes, lines, words, and characters (including multibyte characters) in the specified file.

## Features

- **Byte Count**: Use the `-c` option to count the number of bytes in a file
- **Line Count**: Use the `-l` option to count the number of lines in a file
- **Word Count**: Use the `-w` option to count the number of words in a file
- **Character Count**: Use the `-m` option to count the number of characters (including multibyte characters) in a file
- **Default Behavior**: Run without options to get all statistics

## Usage

```bash
ccwc [OPTION] [FILE]
```

### Options

| Option | Description                                          |
| ------ | ---------------------------------------------------- |
| `-c`   | Count the number of bytes                            |
| `-l`   | Count the number of lines                            |
| `-w`   | Count the number of words                            |
| `-m`   | Count the number of characters (including multibyte) |

### Examples

```bash
# Count bytes
./ccwc -c myfile.txt

# Count lines
./ccwc -l myfile.txt

# Count words
./ccwc -w myfile.txt

# Count characters
./ccwc -m myfile.txt

# Get all statistics
./ccwc myfile.txt
```

## Getting Started

### Installation

Clone the repository:

```bash
git clone https://github.com/Markkimotho/ccwc.git
cd ccwc/
```

Compile using gcc:

```bash
gcc ccwc.c -o ccwc
```

Or using make:

```bash
make
```

## Technical Details

- **Language**: C
- **Dependencies**: None (uses standard C libraries)
- **Build System**: Makefile included

## Acknowledgments

The ccwc utility is based on the [Coding Challenges](https://codingchallenges.fyi/) by John Cricket. Test data obtained from Project Gutenberg.

## Repository

[View on GitHub](https://github.com/Markkimotho/ccwc)
