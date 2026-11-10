#!/usr/bin/env bash
# UserPromptSubmit — fires when you submit a prompt, BEFORE Claude sees it.
# stdin (JSON): { session_id, cwd, prompt, ... }
# Anything printed to stdout is injected into Claude's context for this turn.
# exit 2 = block the prompt entirely (stderr shown to you).
#
# This hook is pure machinery: it stamps every numbered rule file under
# rules/prompt-stamps/ (lexically sorted) so the rules are DATA, not code. Add a
# rule by dropping an NN-*.md file; no script edit. Keep private/org-specific rules
# in a gitignored NN-*.local.md and they load the same way (README.md and *.example
# are skipped by the numeric-prefix glob). See rules/prompt-stamps/.
input=$(cat)
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
stamps="$here/../rules/prompt-stamps"
for f in "$stamps"/[0-9]*.md; do
  [ -f "$f" ] || continue
  cat "$f"
  echo
done
exit 0
