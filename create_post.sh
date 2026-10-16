#!/usr/bin/env bash

# Create an unpublished Jekyll post. Set published: true after writing it.
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$repo_dir"

yaml_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

open_in_editor() {
  if [[ -t 0 ]] && command -v code >/dev/null 2>&1; then
    code "$1"
  fi
}

get_post_details() {
  read -r -p "Post title: " title
  read -r -p "Short description: " description
  read -r -p "Tags (space-separated, optional): " tags
  read -r -p "Category (e.g. projects, optional): " category
  read -r -p "Enable Giscus comments? (y/N): " giscus_input
  read -r -p "Show related posts? (y/N): " related_input

  if [[ -z "${title//[[:space:]]/}" || -z "${description//[[:space:]]/}" ]]; then
    printf '%s\n' "Title and description are required." >&2
    return 1
  fi

  slug=$(printf '%s' "$title" | LC_ALL=C tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')
  if [[ -z "$slug" ]]; then
    printf '%s\n' "The title needs at least one ASCII letter or number for its URL." >&2
    return 1
  fi

  post_date=$(date '+%Y-%m-%d')
  post_timestamp=$(date '+%Y-%m-%d %H:%M:%S %z')
  post_file="_posts/${post_date}-${slug}.md"
  if [[ -e "$post_file" ]]; then
    printf 'Post already exists: %s\n' "$post_file" >&2
    return 1
  fi

  title_yaml=$(yaml_escape "$title")
  description_yaml=$(yaml_escape "$description")
  tags_yaml=$(yaml_escape "$tags")
  category_yaml=$(yaml_escape "$category")
  giscus=false
  related=false
  if [[ "$giscus_input" == [yY] ]]; then giscus=true; fi
  if [[ "$related_input" == [yY] ]]; then related=true; fi
}

write_front_matter() {
  printf '%s\n' '---'
  printf '%s\n' 'published: false'
  printf '%s\n' 'layout: post'
  printf 'title: "%s"\n' "$title_yaml"
  printf 'date: %s\n' "$post_timestamp"
  printf 'description: "%s"\n' "$description_yaml"
  printf 'tags: "%s"\n' "$tags_yaml"
  printf 'categories: "%s"\n' "$category_yaml"
  printf 'giscus_comments: %s\n' "$giscus"
  printf 'related_posts: %s\n' "$related"
}

create_post() {
  local kind=$1
  get_post_details

  if [[ "$kind" == toc ]]; then
    read -r -p "Table of contents sidebar (left/right) [left]: " toc_side
    toc_side=${toc_side:-left}
    if [[ "$toc_side" != left && "$toc_side" != right ]]; then
      printf '%s\n' "Choose left or right for the sidebar." >&2
      return 1
    fi
  fi

  if [[ "$kind" == notebook ]]; then
    read -r -p "Notebook filename in assets/jupyter/ (e.g. analysis.ipynb): " notebook_name
    if [[ ! "$notebook_name" =~ ^[A-Za-z0-9._-]+\.ipynb$ ]]; then
      printf '%s\n' "Enter a .ipynb filename without a directory path." >&2
      return 1
    fi
  fi

  mkdir -p _posts
  {
    write_front_matter
    if [[ "$kind" == toc ]]; then
      printf 'toc:\n  sidebar: %s\n' "$toc_side"
    fi
    printf '%s\n\n' '---'

    case "$kind" in
      standard)
        printf '%s\n' 'Write your introduction here.'
        ;;
      toc)
        printf '%s\n\n%s\n' 'Write your introduction here.' '## First section'
        ;;
      notebook)
        printf '%s\n\n' 'Write your introduction here.'
        printf '%s\n' '{::nomarkdown}'
        printf "{%% assign jupyter_path = 'assets/jupyter/%s' | relative_url %%}\n" "$notebook_name"
        printf '{%% capture notebook_exists %%}{%% file_exists assets/jupyter/%s %%}{%% endcapture %%}\n' "$notebook_name"
        printf '%s\n' "{% if notebook_exists == 'true' %}" '  {% jupyter_notebook jupyter_path %}' '{% else %}'
        printf '  <p>Notebook not found: assets/jupyter/%s</p>\n' "$notebook_name"
        printf '%s\n' '{% endif %}' '{:/nomarkdown}'
        ;;
    esac
  } > "$post_file"

  if [[ "$kind" == notebook ]]; then
    mkdir -p assets/jupyter
    printf 'Place the notebook at assets/jupyter/%s\n' "$notebook_name"
  fi
  printf 'Created %s as a draft. Set published: true when ready.\n' "$post_file"
  open_in_editor "$post_file"
}

while true; do
  printf '%s\n' 'Select the type of blog post to create:' '1. Standard post' '2. Post with table of contents' '3. Post with Jupyter notebook' '4. Exit'
  read -r -p "Choice (1/2/3/4): " choice
  case "$choice" in
    1) create_post standard; break ;;
    2) create_post toc; break ;;
    3) create_post notebook; break ;;
    4) exit 0 ;;
    *) printf '%s\n' 'Choose 1, 2, 3, or 4.' ;;
  esac
done
