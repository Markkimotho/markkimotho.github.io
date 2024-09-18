#!/bin/bash

# Prompt the user to enter the post title.
echo "Enter the post title:"
read title

# Convert the post title to a URL-friendly format:
# 1. Convert all uppercase letters to lowercase.
# 2. Replace spaces with hyphens.
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Get the current date in YYYY-MM-DD format for use in the filename and front matter.
date=$(date +"%Y-%m-%d")

# Prompt the user to enter tags for the post, comma-separated.
echo "Enter tags (comma-separated):"
read tags

# Format the tags for YAML compatibility:
# Convert comma-separated tags to a space-separated list.
tags_formatted=$(echo "$tags" | tr ',' ' ')

# Define the file path for the new markdown post using the current date and URL-friendly slug.
file="_posts/$date-$slug.md"

# Create the new markdown file and insert the front matter with the following details:
# - layout: specifies the layout to use for the post.
# - title: the title of the post.
# - date: the date the post is created.
# - tags: the tags associated with the post.
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

# Notify the user that the new post has been created and provide the file path.
echo "New post created: $file"

# Open the newly created file in the default text editor.
# Replace `code` with the command for your preferred editor (e.g., `nano`, `vim`).
code $file
