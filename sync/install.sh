#!/usr/bin/env bash
# Install / manage the once-a-day launchd job.
#   ./install.sh install     render + load the launchd job from your config
#   ./install.sh uninstall   unload + remove it
#   ./install.sh run         run one sync now (foreground, honors DRY_RUN=1)
#   ./install.sh status      print the last sync status
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${CLAUDE_KIT_SYNC_CONFIG:-$HOME/.config/claude-kit-sync/config.sh}"
cmd="${1:-status}"

load_config() {
  [ -f "$CONFIG" ] || { echo "No config at $CONFIG — copy sync/config.example.sh there and edit it."; exit 1; }
  # shellcheck disable=SC1090
  . "$CONFIG"
  : "${LABEL:=com.$(id -un).claude-kit-sync}"
  : "${SCHEDULE_HOUR:=9}"; : "${SCHEDULE_MINUTE:=0}"
  : "${LOG:=$HOME/.local/state/claude-kit-sync/sync.log}"
  PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
}

case "$cmd" in
  install)
    load_config
    mkdir -p "$(dirname "$PLIST")" "$(dirname "$LOG")"
    sed -e "s#@LABEL@#$LABEL#g" -e "s#@CONFIG@#$CONFIG#g" -e "s#@SYNC_SH@#$HERE/sync.sh#g" \
        -e "s#@HOUR@#$SCHEDULE_HOUR#g" -e "s#@MINUTE@#$SCHEDULE_MINUTE#g" -e "s#@LOG@#$LOG#g" \
        "$HERE/launchd.plist.template" > "$PLIST"
    launchctl unload "$PLIST" 2>/dev/null || true
    launchctl load -w "$PLIST"
    echo "Installed $LABEL — runs daily at $(printf '%02d:%02d' "$SCHEDULE_HOUR" "$SCHEDULE_MINUTE")."
    ;;
  uninstall)
    load_config
    launchctl unload "$PLIST" 2>/dev/null || true
    rm -f "$PLIST"
    echo "Removed $LABEL."
    ;;
  run)
    load_config
    exec env CLAUDE_KIT_SYNC_CONFIG="$CONFIG" DRY_RUN="${DRY_RUN:-0}" "$HERE/sync.sh"
    ;;
  status)
    exec env CLAUDE_KIT_SYNC_CONFIG="$CONFIG" "$HERE/status.sh"
    ;;
  *)
    echo "usage: install.sh {install|uninstall|run|status}"; exit 1 ;;
esac
