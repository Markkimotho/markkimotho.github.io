#!/usr/bin/env bash

# Every news item has a title and a local detail page linked from /news/.
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

next_announcement_file() {
  local file number max=0
  for file in _news/announcement_*.md; do
    [[ -e "$file" ]] || continue
    if [[ "$file" =~ ^_news/announcement_([0-9]+)\.md$ ]]; then
      number=${BASH_REMATCH[1]}
      if (( number > max )); then max=$number; fi
    fi
  done
  printf '_news/announcement_%s.md' "$((max + 1))"
}

create_news() {
  local kind=$1
  local title summary details source_url title_yaml news_file

  read -r -p "Announcement title: " title
  read -r -p "Summary for its detail page: " summary
  if [[ -z "${title//[[:space:]]/}" || -z "${summary//[[:space:]]/}" ]]; then
    printf '%s\n' "Title and summary are required." >&2
    return 1
  fi

  if [[ "$kind" == detailed ]]; then
    read -r -p "Additional details (one paragraph): " details
    if [[ -z "${details//[[:space:]]/}" ]]; then
      printf '%s\n' "Additional details are required for a detailed announcement." >&2
      return 1
    fi
  fi

  read -r -p "Original or related URL (optional): " source_url
  if [[ -n "$source_url" && ! "$source_url" =~ ^https?://[^[:space:]]+$ ]]; then
    printf '%s\n' "Use an http:// or https:// URL, or leave it blank." >&2
    return 1
  fi

  title_yaml=$(yaml_escape "$title")
  news_file=$(next_announcement_file)
  if [[ -e "$news_file" ]]; then
    printf 'Announcement already exists: %s\n' "$news_file" >&2
    return 1
  fi

  mkdir -p _news
  {
    printf '%s\n' '---' 'layout: post'
    printf 'title: "%s"\n' "$title_yaml"
    printf 'date: %s\n' "$(date '+%Y-%m-%d %H:%M:%S %z')"
    printf '%s\n' 'inline: false' 'related_posts: false' '---'
    printf '\n'
    printf '%s\n' "$summary"
    if [[ "$kind" == detailed ]]; then
      printf '\n%s\n' "$details"
    fi
    if [[ -n "$source_url" ]]; then
      printf '\n[Read the original](%s).\n' "$source_url"
    fi
  } > "$news_file"

  printf 'Created %s. It will be linked from the homepage and /news/.\n' "$news_file"
  open_in_editor "$news_file"
}

while true; do
  printf '%s\n' 'Select the type of announcement to create:' '1. Short announcement' '2. Detailed announcement' '3. Exit'
  read -r -p "Choice (1/2/3): " choice
  case "$choice" in
    1) create_news short; break ;;
    2) create_news detailed; break ;;
    3) exit 0 ;;
    *) printf '%s\n' 'Choose 1, 2, or 3.' ;;
  esac
done
