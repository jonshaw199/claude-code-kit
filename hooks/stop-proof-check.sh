#!/usr/bin/env bash
# Stop — PROOF-RULE enforcer. Blocks a correctness/completeness/consistency CLAIM made
# WITHOUT any investigation tool call in the same turn. Separate from stop.sh (which owns
# brevity + persistence) so neither touches the other's logic.
input=$(cat)

# Don't fight a continuation already in progress.
[ "$(printf '%s' "$input" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0

transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
[ -z "$transcript" ] && exit 0
[ ! -f "$transcript" ] && exit 0

last_text=$(jq -rs '
  [ .[] | select(.type == "assistant")
    | (.message.content // []) | map(select(.type == "text") | .text) | join("\n")
    | select(length > 0) ] | last // ""
' "$transcript" 2>/dev/null)
[ -z "$last_text" ] && exit 0

printf '%s' "$last_text" | grep -qiE "this is the (right |real |correct |complete |consistent )?fix|the fix (we )?need|(fully )?consistent (with|across|everywhere)|it'?s (the )?(correct|complete|consistent)|that'?s the fix|this (fully )?fixes it|the fix is (correct|complete|consistent|right)|it is consistent|fully covered|covers everything" || exit 0

investigated=$(jq -rs '
  (reduce range(0; length) as $i (null;
     if (.[$i].message.role == "user")
        and ((.[$i].message.content | type == "string")
             or ((.[$i].message.content // []) | all(.type != "tool_result")))
     then $i else . end)) as $u
  | [ .[(($u // -1) + 1):][] | select(.message.role == "assistant")
      | (.message.content // []) | any(.type == "tool_use") ] | any
' "$transcript" 2>/dev/null)

if [ "$investigated" != "true" ]; then
  reason="PROOF RULE violation: you asserted a fix is correct/complete/consistent WITHOUT verifying it this turn (no grep/read/run to check). Do NOT assert completeness from memory. Survey the full surface (every peer action / layer) with real tool calls, base the claim on that output, THEN answer. If you can't verify, state what you have NOT checked instead of asserting."
  printf '{"decision":"block","reason":%s}\n' "$(printf '%s' "$reason" | jq -Rs .)"
  exit 0
fi
exit 0
