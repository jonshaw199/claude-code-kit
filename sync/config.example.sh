# claude-kit-sync config — copy to ~/.config/claude-kit-sync/config.sh and edit.
# This file is LOCAL ONLY: it holds machine paths, never commit it anywhere.

# The generic kit repo to sync INTO (where generalizable learnings land).
KIT_REPO="$HOME/code/claude-code-kit"

# Local dirs to scan for new learnings (your live hooks/skills/rules, memory, etc.).
SOURCE_DIRS=(
  "$HOME/.claude"
)
# Add more as needed, e.g. a project's memory dir:
# SOURCE_DIRS+=("$HOME/.claude/projects/<project>/memory")

# Schedule (24h local time) for the once-a-day launchd run.
SCHEDULE_HOUR=9
SCHEDULE_MINUTE=0

# launchd label + where state/logs go. Defaults are fine.
LABEL="com.$(id -un).claude-kit-sync"
LOG="$HOME/.local/state/claude-kit-sync/sync.log"
STATUS_JSON="$HOME/.local/state/claude-kit-sync/status.json"

# Desktop notification after each run: 1 = on, 0 = off.
NOTIFY=1
