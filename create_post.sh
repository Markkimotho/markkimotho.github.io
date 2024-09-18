#!/bin/bash

# Get post title from the user
echo "Enter the post title:"
read title

# Format the title to be URL-friendly (lowercase and spaces to hyphens)
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Get the current date in YYYY-MM-DD format
date=$(date +"%Y-%m-%d")

# Prompt for tags
echo "Enter tags (comma-separated):"
read tags

# Convert tags to a YAML-compatible format (comma-separated with spaces)
tags_formatted=$(echo "$tags" | tr ',' ' ')

# Set the file path for the new post
file="_posts/$date-$slug.md"

# Create the file and insert the front matter
cat <<EOL > $file
---
layout: post
title: "$title"
date: $date
tags: [$tags_formatted]
---

## $title

Your content goes here.

EOL

# Notify the user and open the file for editing
echo "New post created: $file"
code $file  # This opens the file with VSCode. Replace `code` with your editor of choice, e.g., `nano` or `vim`.
