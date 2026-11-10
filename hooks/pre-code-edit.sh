#!/usr/bin/env bash
# PreToolUse (Edit|Write|MultiEdit) — INVESTIGATE-FIRST checkpoint.
# Self-enforcing (no prompt to the user): DENY an implementation edit unless Claude's
# own preceding message named the prior-art pattern it is copying. If it did, allow.
# stdin JSON: { tool_name, tool_input: { file_path }, transcript_path }
input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
[ -z "$path" ] && exit 0

# Only gate IMPLEMENTATION source. Skip specs/tests, docs, config, generated schema.
case "$path" in
  *_spec.rb|*.test.*|*.spec.*|*.md|*.json|*.yml|*.yaml|*.lock|*/db/structure.sql|*/db/data_schema.rb) exit 0 ;;
esac
# Implementation source dirs — customize this regex for your repo layout.
printf '%s' "$path" | grep -qE '/(src|app|lib|packs)/' || exit 0

transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
[ -z "$transcript" ] || [ ! -f "$transcript" ] && exit 0

# Scan the last few assistant text messages (not just the immediate one): the pre-edit
# justification may not have flushed to the transcript the instant this hook fires.
last_text=$(jq -rs '
  [ .[] | select(.type == "assistant")
    | (.message.content // []) | map(select(.type == "text") | .text) | join("\n")
    | select(length > 0) ] | .[-3:] | join("\n")
' "$transcript" 2>/dev/null)

# Justified if the preceding message grounds the change in prior art / an existing pattern.
if printf '%s' "$last_text" | grep -qiE 'prior art|existing pattern|modeled on|same pattern as|grounded in|follows? the .* pattern|per the checkpoint'; then
  exit 0
fi

reason="INVESTIGATE-FIRST: this implementation edit was DENIED because your immediately preceding message did not name the PRIOR-ART pattern you are copying (nor the files surveyed / design principles it is grounded in). Do the investigation, state the pattern + principles in your next message, THEN make the edit. Do not ask the user to approve — justify it yourself first."
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":%s}}\n' "$(printf '%s' "$reason" | jq -Rs .)"
exit 0
