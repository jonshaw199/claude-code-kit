#!/usr/bin/env bash
# Generic once-a-day syncer. A headless Claude agent promotes new, generalizable
# learnings from your local source dirs into the kit repo; org-specific content is
# never synced. The result is derived from the kit's git HEAD (before/after), written
# to status.json, and surfaced as a desktop notification. Config supplies all paths.
set -euo pipefail

CONFIG="${CLAUDE_KIT_SYNC_CONFIG:-$HOME/.config/claude-kit-sync/config.sh}"
[ -f "$CONFIG" ] || { echo "No config at $CONFIG (copy sync/config.example.sh there)"; exit 1; }
# shellcheck disable=SC1090
. "$CONFIG"

: "${KIT_REPO:?set KIT_REPO in config}"
: "${LOG:=$HOME/.local/state/claude-kit-sync/sync.log}"
: "${STATUS_JSON:=$HOME/.local/state/claude-kit-sync/status.json}"
: "${NOTIFY:=1}"
mkdir -p "$(dirname "$LOG")" "$(dirname "$STATUS_JSON")"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NOTE_FILE="$(dirname "$STATUS_JSON")/last-note.txt"
: > "$NOTE_FILE"

notify() { # title, message
  [ "$NOTIFY" = "1" ] || return 0
  if command -v terminal-notifier >/dev/null 2>&1; then
    terminal-notifier -title "$1" -message "$2" >/dev/null 2>&1 || true
  else
    osascript -e "display notification \"$2\" with title \"$1\"" >/dev/null 2>&1 || true
  fi
}

# Build --add-dir args + a human context block naming this run's paths.
# The state dir is included so the agent can write its outcome note.
add_dirs=(--add-dir "$KIT_REPO" --add-dir "$(dirname "$STATUS_JSON")")
ctx="Target kit repo (generic, shareable): $KIT_REPO
Write your one-line outcome summary to: $NOTE_FILE
Local source dirs to scan for new learnings:"
for d in "${SOURCE_DIRS[@]}"; do add_dirs+=(--add-dir "$d"); ctx="$ctx
  - $d"; done

prompt="$(cat "$HERE/PROMPT.md")

## Context (this run)
$ctx"
if [ "${DRY_RUN:-0}" = "1" ]; then
  prompt="$prompt

## DRY RUN
Do NOT commit or push. Report what you WOULD change and why."
fi

cd "$KIT_REPO"
before="$(git rev-parse HEAD 2>/dev/null || echo none)"
echo "===== $(date) sync start (dry=${DRY_RUN:-0}) =====" >> "$LOG"

claude -p "$prompt" "${add_dirs[@]}" \
  --allowedTools Read Edit Write Grep Glob 'Bash(git:*)' 'Bash(gh:*)' 'Bash(grep:*)' 'Bash(cat:*)' 'Bash(ls:*)' 'Bash(find:*)' 'Bash(diff:*)' 'Bash(shasum:*)' \
  >> "$LOG" 2>&1 || echo "(agent exited non-zero)" >> "$LOG"

after="$(git rev-parse HEAD 2>/dev/null || echo none)"
note="$(tr -d '\r' < "$NOTE_FILE" | head -1)"
if [ "$before" != "$after" ]; then
  changed="$(git diff --name-only "$before" "$after" 2>/dev/null | paste -sd, -)"
  n="$(git diff --name-only "$before" "$after" 2>/dev/null | grep -c . || echo 0)"
  result="synced"; headline="Synced $n file(s)"
else
  changed=""; n=0; result="nothing"; headline="${note:-Nothing new}"
fi

# status.json — the dashboard reads this. Hand-rolled JSON (values are safe/simple).
cat > "$STATUS_JSON" <<EOF
{
  "last_run": "$(date '+%Y-%m-%d %H:%M:%S %Z')",
  "result": "$result",
  "headline": "$(printf '%s' "$headline" | sed 's/"/\\"/g')",
  "changed_count": $n,
  "changed_files": "$(printf '%s' "$changed" | sed 's/"/\\"/g')",
  "note": "$(printf '%s' "$note" | sed 's/"/\\"/g')",
  "head": "$after"
}
EOF

echo "===== $(date) sync done: $result ($n) =====" >> "$LOG"
notify "claude-kit-sync" "$headline"
