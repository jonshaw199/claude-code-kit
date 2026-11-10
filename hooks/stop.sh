#!/usr/bin/env bash
# Stop — fires when Claude finishes a turn. Enforces the RESPONSE RULE (brevity)
# that a prompt stamp alone can't: if the reply is a wall of text, BLOCK and make
# Claude rewrite it shorter. stdin JSON: { transcript_path, stop_hook_active, ... }
input=$(cat)

# PERSISTENCE teeth: an active "keep working until X" directive. While the deadline
# file exists and hasn't passed, BLOCK the stop so Claude can't yield early — this
# deliberately runs BEFORE the stop_hook_active guard so it overrides the single-bounce.
deadline_file="${CLAUDE_PROJECT_DIR:-.}/.claude/state/keep-working-until"
if [ -f "$deadline_file" ]; then
  deadline=$(tr -dc '0-9' < "$deadline_file")
  now=$(date +%s)
  if [ -n "$deadline" ] && [ "$now" -lt "$deadline" ]; then
    remain=$(( (deadline - now) / 60 ))
    reason="PERSISTENCE RULE: active keep-working directive — ~${remain} min left. Do NOT yield; keep working (real tool calls / tests), do not emit an interim status or hand back control. This overrides stop_hook_active. The deadline auto-clears when it passes."
    printf '{"decision":"block","reason":%s}\n' "$(printf '%s' "$reason" | jq -Rs .)"
    exit 0
  fi
  rm -f "$deadline_file"
fi

# Avoid loops: if we're already continuing from a prior Stop block, let it through.
[ "$(printf '%s' "$input" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0

transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
[ -z "$transcript" ] && exit 0
[ ! -f "$transcript" ] && exit 0

# Last assistant text message.
last_text=$(jq -rs '
  [ .[] | select(.message.role == "assistant") ] | last
  | (.message.content // []) | map(select(.type == "text") | .text) | join("\n")
' "$transcript" 2>/dev/null)
[ -z "$last_text" ] && exit 0

# Escape hatch: the user explicitly asked for length.
last_user=$(jq -rs '
  [ .[] | select(.message.role == "user") ] | last | (.message.content // "")
  | if type == "array" then (map(.text? // "") | join(" ")) else tostring end
' "$transcript" 2>/dev/null)
printf '%s' "$last_user" | grep -qiE 'go long|be thorough|full (survey|writeup|detail)|long answer|don.t truncate|give me everything' && exit 0

chars=$(printf '%s' "$last_text" | wc -c | tr -d ' ')
lines=$(printf '%s\n' "$last_text" | grep -c '')

if [ "$chars" -gt 1000 ] || [ "$lines" -gt 14 ]; then
  reason="RESPONSE RULE violation: your reply is ${lines} lines / ${chars} chars. HARD CAP is <=14 lines and <=1000 chars unless the user asked to 'go long'. Rewrite it: lead with the one-line answer, then cut everything that wasn't asked for — survey dumps, options menus, caveats, process narration, restating prior context. Keep only the direct answer."
  printf '{"decision":"block","reason":%s}\n' "$(printf '%s' "$reason" | jq -Rs .)"
  exit 0
fi
exit 0
