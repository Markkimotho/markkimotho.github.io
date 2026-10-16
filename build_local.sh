#!/usr/bin/env bash

# Build the Jekyll site outside the repository; optionally serve the built files.
set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
temp_root=${TMPDIR:-/tmp}
temp_root=${temp_root%/}
[[ -n "$temp_root" ]] || temp_root=/tmp
build_dir="$temp_root/mark-portfolio-preview"
port=4000
serve=false

usage() {
  printf '%s\n' \
    'Usage: ./build_local.sh [--serve] [--port NUMBER]' \
    '' \
    'Build the site into a temporary preview directory.' \
    'Add --serve to preview it at http://127.0.0.1:4000/.' \
    'Rerunning --serve replaces an earlier preview from this script on the same port.' \
    'The server serves the completed build; rerun the script after editing.'
}

while (( $# > 0 )); do
  case "$1" in
    --serve)
      serve=true
      shift
      ;;
    --port)
      if (( $# < 2 )) || [[ ! "$2" =~ ^[0-9]+$ ]]; then
        printf '%s\n' '--port needs a number.' >&2
        exit 2
      fi
      port=$2
      if (( 10#$port < 1 || 10#$port > 65535 )); then
        printf '%s\n' '--port must be between 1 and 65535.' >&2
        exit 2
      fi
      serve=true
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
done

if ! command -v bundle >/dev/null 2>&1; then
  printf '%s\n' 'Bundler is not installed. Install the Ruby dependencies first.' >&2
  exit 1
fi

if [[ "$serve" == true ]]; then
  if ! command -v python3 >/dev/null 2>&1; then
    printf '%s\n' 'Python 3 is needed to serve the built site.' >&2
    exit 1
  fi
  if command -v lsof >/dev/null 2>&1; then
    listeners=()
    while IFS= read -r pid; do
      [[ -n "$pid" ]] && listeners+=("$pid")
    done < <(lsof -nP -t -iTCP:"$port" -sTCP:LISTEN)

    # Only reclaim a preview started by this script, serving this build directory.
    for pid in "${listeners[@]}"; do
      owner=$(ps -p "$pid" -o uid= | tr -d ' ')
      command_line=$(ps -ww -p "$pid" -o args=)
      if [[ "$owner" != "$(id -u)" || "$command_line" != *" -m http.server $port --bind 127.0.0.1 --directory $build_dir" ]]; then
        printf 'Port %s is in use by another process (PID %s); refusing to stop it. Choose another with --port.\n' "$port" "$pid" >&2
        exit 1
      fi
    done

    if (( ${#listeners[@]} > 0 )); then
      printf 'Stopping previous portfolio preview on port %s.\n' "$port"
      for pid in "${listeners[@]}"; do
        kill -TERM "$pid"
      done
      for (( attempt=0; attempt<25; attempt++ )); do
        if ! lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
          break
        fi
        sleep 0.2
      done
      if lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
        printf 'Port %s did not clear after stopping the previous preview.\n' "$port" >&2
        exit 1
      fi
    fi
  fi
fi

cd "$repo_dir"
if command -v rbenv >/dev/null 2>&1; then
  jekyll=(rbenv exec bundle exec jekyll)
else
  jekyll=(bundle exec jekyll)
fi

# The CV plugin writes into assets/pdf during a build. Keep the source PDF as it was.
pdf_path="$repo_dir/assets/pdf/Mark K Tinega's_Resume.pdf"
backup_dir=$(mktemp -d "$temp_root/portfolio-cv.XXXXXX")
if [[ -f "$pdf_path" ]]; then
  cp -p "$pdf_path" "$backup_dir/resume.pdf"
fi

restore_pdf() {
  if [[ -f "$backup_dir/resume.pdf" ]]; then
    cp -p "$backup_dir/resume.pdf" "$pdf_path"
  fi
  rm -f "$backup_dir/resume.pdf"
  rmdir "$backup_dir"
}
trap restore_pdf EXIT

printf 'Building site in %s\n' "$build_dir"
JEKYLL_ENV=development "${jekyll[@]}" build --destination "$build_dir" --quiet
restore_pdf
trap - EXIT

printf 'Build complete: %s\n' "$build_dir"
if [[ "$serve" == true ]]; then
  printf 'Preview: http://127.0.0.1:%s/ (Ctrl-C to stop)\n' "$port"
  exec python3 -m http.server "$port" --bind 127.0.0.1 --directory "$build_dir"
fi
