# Substack feed sync

GitHub-hosted runners get HTTP 403 from `https://ktinega.substack.com/feed`.
The Mac fetches the feed daily at 06:20 local time and on login. If the public
post index changes, `sync_substack_feed.rb` updates
`_data/external_feed_fallbacks.yml` through the GitHub API. That commit triggers
the existing site deployment workflow. CI builds read the committed index and
never request the Substack feed.

The Mac must be on and connected, and `gh auth status` must show the Markkimotho
account with repository write access. A failed attempt is logged and retried at
the next scheduled run. No commit is created when the feed is unchanged.

After changing either script or the launch agent, run
`sh scripts/install_substack_sync.sh` to refresh the installed copy. Check
`~/Library/Logs/substack-sync.log` and
`~/Library/Logs/substack-sync-error.log` for the last run. Run
`ruby scripts/sync_substack_feed.rb --dry-run` to inspect the feed without
writing to GitHub.
