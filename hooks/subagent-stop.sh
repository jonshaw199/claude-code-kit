#!/usr/bin/env bash
# SubagentStop — fires when a subagent (Task/Agent) finishes.
# stdin (JSON): { session_id, cwd, stop_hook_active, ... }
# Use for: log subagent completion, aggregate results.
input=$(cat)
exit 0
