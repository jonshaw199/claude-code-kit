#!/usr/bin/env bash
# PostToolUse — fires AFTER a tool completes successfully.
# stdin (JSON): { session_id, cwd, tool_name, tool_input, tool_response, ... }
# Use for: auto-format/lint after Edit|Write, run tests after a change, log activity.
# exit 0 = ok; exit 2 = feed stderr back to Claude as a problem to address.
input=$(cat)
# example: prettier a file after it's edited
# f=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty'); [[ "$f" == *.ts ]] && npx prettier --write "$f" 2>/dev/null
exit 0
