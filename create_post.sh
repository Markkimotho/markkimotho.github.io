#!/bin/bash

# Function to display the menu and get the user's choice
display_menu() {
  echo "Select the type of blog post to create:"
  echo "1. Standard Post"
  echo "2. Post with Table of Contents"
  echo "3. Post with Jupyter Notebook"
  echo "4. Exit"
  read -p "Enter your choice (1/2/3/4): " choice
  echo
}

# Function to prompt for common post details
get_post_details() {
  read -p "Enter the post title: " title
  read -p "Enter a short description: " description
  read -p "Enter tags (space-separated, e.g., 'projects art open-source'): " tags
  read -p "Enter category (e.g., 'sample-posts', 'projects', 'external-services'): " category
  read -p "Enable giscus comments? (y/n): " giscus_input
  read -p "Show related posts? (y/n): " related_input

  if [ "$giscus_input" = "y" ]; then
    giscus="true"
  else
    giscus="false"
  fi

  if [ "$related_input" = "y" ]; then
    related="true"
  else
    related="false"
  fi

  # Generate date and slug
  post_date=$(date +%Y-%m-%d)
  post_time=$(date +%H:%M:%S)
  slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
  file_name="${post_date}-${slug}.md"
}

# Function to create a standard post
create_standard_post() {
  echo "Creating Standard Post..."
  get_post_details

  cat <<EOL > "_posts/$file_name"
---
layout: post
title: "$title"
date: $post_date $post_time
description: $description
tags: $tags
categories: $category
giscus_comments: $giscus
related_posts: $related
---

Write your post content here.
EOL

  code "_posts/$file_name"
  echo "Post '_posts/$file_name' created successfully."
  exit 0
}

# Function to create a post with table of contents
create_toc_post() {
  echo "Creating Post with Table of Contents..."
  get_post_details

  read -p "Sidebar TOC? (y/n): " toc_sidebar_input
  if [ "$toc_sidebar_input" = "y" ]; then
    toc_sidebar="true"
  else
    toc_sidebar="false"
  fi

  cat <<EOL > "_posts/$file_name"
---
layout: post
title: "$title"
date: $post_date $post_time
description: $description
tags: $tags
categories: $category
giscus_comments: $giscus
related_posts: $related
toc:
  sidebar: $toc_sidebar
---

## Section One

Write your content here.

## Section Two

Write your content here.

## Section Three

Write your content here.
EOL

  code "_posts/$file_name"
  echo "Post '_posts/$file_name' created successfully."
  exit 0
}

# Function to create a post with jupyter notebook
create_jupyter_post() {
  echo "Creating Post with Jupyter Notebook..."
  get_post_details

  read -p "Enter the notebook filename (e.g., 'my_notebook.ipynb'): " notebook_name

  # Create the notebook directory if it doesn't exist
  mkdir -p assets/jupyter

  cat <<EOL > "_posts/$file_name"
---
layout: post
title: "$title"
date: $post_date $post_time
description: $description
tags: $tags
categories: $category
giscus_comments: $giscus
related_posts: $related
---

Write your introduction here.

{::nomarkdown}
{% assign jupyter_path = 'assets/jupyter/$notebook_name' | relative_url %}
{% capture notebook_exists %}{% file_exists assets/jupyter/$notebook_name %}{% endcapture %}
{% if notebook_exists == 'true' %}
  {% jupyter_notebook jupyter_path %}
{% else %}
  <p>Notebook not found: assets/jupyter/$notebook_name</p>
{% endif %}
{:/nomarkdown}
EOL

  echo "NOTE: Place your notebook at assets/jupyter/$notebook_name"
  code "_posts/$file_name"
  echo "Post '_posts/$file_name' created successfully."
  exit 0
}

# Main loop
while true; do
  display_menu

  case $choice in
    1)
      create_standard_post
      ;;
    2)
      create_toc_post
      ;;
    3)
      create_jupyter_post
      ;;
    4)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice, please try again."
      ;;
  esac
done
