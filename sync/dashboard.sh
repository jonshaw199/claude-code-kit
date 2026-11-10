#!/usr/bin/env bash
# Serve the one-page dashboard locally against the LIVE status dir, so its 30s refresh
# reflects new syncs. Ctrl-C to stop.
set -euo pipefail
CONFIG="${CLAUDE_KIT_SYNC_CONFIG:-$HOME/.config/claude-kit-sync/config.sh}"
[ -f "$CONFIG" ] && . "$CONFIG"
: "${STATUS_JSON:=$HOME/.local/state/claude-kit-sync/status.json}"
: "${DASHBOARD_PORT:=4320}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

state_dir="$(dirname "$STATUS_JSON")"
mkdir -p "$state_dir"
cp "$HERE/dashboard/index.html" "$state_dir/index.html"
[ -f "$STATUS_JSON" ] || echo '{}' > "$STATUS_JSON"
echo "Dashboard: http://localhost:$DASHBOARD_PORT  (Ctrl-C to stop)"
cd "$state_dir" && exec python3 -m http.server "$DASHBOARD_PORT"
