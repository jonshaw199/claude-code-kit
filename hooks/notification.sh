#!/usr/bin/env bash
# Notification — fires when Claude Code sends a notification
# (e.g. awaiting your input, or a permission prompt).
# stdin (JSON): { session_id, cwd, message, ... }
# Use for: route notifications to Slack/desktop/sound.
input=$(cat)
# msg=$(printf '%s' "$input" | jq -r '.message')
exit 0
