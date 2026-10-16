#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
support_dir="$HOME/Library/Application Support/markkimotho-site"
agent_path="$HOME/Library/LaunchAgents/com.markkimotho.substack-sync.plist"
service="gui/$(id -u)/com.markkimotho.substack-sync"

mkdir -p "$support_dir" "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
install -m 700 "$script_dir/sync_substack_feed.rb" "$support_dir/sync_substack_feed.rb"

if launchctl print "$service" >/dev/null 2>&1; then
  launchctl bootout "$service"
fi

if [ -L "$agent_path" ]; then
  rm "$agent_path"
fi

install -m 644 "$script_dir/com.markkimotho.substack-sync.plist" "$agent_path"
launchctl bootstrap "gui/$(id -u)" "$agent_path"
echo "Installed daily Substack sync (06:20 local time, plus login)."
