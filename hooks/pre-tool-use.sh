#!/usr/bin/env bash
# PreToolUse — fires BEFORE a tool runs. Can approve, block, or ask.
# stdin (JSON): { session_id, cwd, tool_name, tool_input, ... }
# To gate a tool, print JSON and exit 0:
#   {"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow|deny|ask","permissionDecisionReason":"..."}}
# Or: exit 0 = allow, exit 2 = block (stderr shown to Claude), other = non-blocking error.
# Matcher (in settings) restricts which tools this runs for, e.g. "Bash", "Edit|Write".
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

# PR COMMENT RULE: never let a PR comment/reply be POSTED without an explicit human decision.
# Replying to a HUMAN reviewer's comment is banned; bot replies are allowed only when the user asks.
# Gate WRITES only, never reads: `gh pr comment/review`, GraphQL add-mutations, or a `gh api`
# to .../comments|/replies that carries a write flag (-f/-F/--field/--input/-X POST/--method POST).
# A plain `gh api .../comments` read (GET, with -q/--jq) must pass through untouched.
is_write_api=false
if printf '%s' "$cmd" | grep -Eiq 'gh api[^|]*/(comments|replies)' \
   && printf '%s' "$cmd" | grep -Eiq -- '(-X[= ]*POST|--method[= ]*POST|-f |-F |--field|--raw-field|--input)'; then
  is_write_api=true
fi
if printf '%s' "$cmd" | grep -Eiq 'gh pr (comment|review)' \
   || printf '%s' "$cmd" | grep -Eiq 'gh api graphql.*(addComment|addPullRequestReview)' \
   || [ "$is_write_api" = true ]; then
  reason="PR COMMENT RULE: this command posts to a PR comment/thread. Claude can reply ONLY to bot comments; replying to a human comment is NEVER allowed. Confirm the target author is a BOT. If it is a human thread, DENY and surface the point to the user instead."
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":%s}}\n' "$(printf '%s' "$reason" | jq -Rs .)"
  exit 0
fi

exit 0
