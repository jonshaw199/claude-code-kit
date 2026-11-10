#!/usr/bin/env bash
# SessionStart — fires at session start or resume.
# stdin (JSON): { session_id, cwd, source: "startup"|"resume"|"clear", ... }
# Anything printed to stdout is injected as context for the session.
# Use for: load env status, print branch/ticket, surface TODOs.
input=$(cat)
# echo "On branch: $(git -C "$(printf '%s' "$input" | jq -r .cwd)" branch --show-current 2>/dev/null)"
exit 0
