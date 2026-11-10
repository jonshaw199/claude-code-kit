#!/usr/bin/env bash
# Print the last sync status to the terminal (the no-frills dashboard).
set -euo pipefail
CONFIG="${CLAUDE_KIT_SYNC_CONFIG:-$HOME/.config/claude-kit-sync/config.sh}"
[ -f "$CONFIG" ] && . "$CONFIG"
: "${STATUS_JSON:=$HOME/.local/state/claude-kit-sync/status.json}"

[ -f "$STATUS_JSON" ] || { echo "No sync has run yet (no $STATUS_JSON)."; exit 0; }
if command -v jq >/dev/null 2>&1; then
  jq -r '"last sync : \(.last_run)\nresult    : \(.result) — \(.headline)\nchanged   : \(.changed_files // "-")\nnote      : \(.note // "-")"' "$STATUS_JSON"
else
  cat "$STATUS_JSON"
fi
