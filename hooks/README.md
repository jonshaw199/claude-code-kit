# Claude Code hook stubs

One stub per hook event. Each reads the event JSON on stdin and is a **no-op** until you edit it.
Inline comments explain the stdin fields and how to block/inject/modify for that event.

## Wiring them up

Hooks are activated in a `hooks` key in settings, not by the files existing. Add this block to:

- `.claude/settings.json` — shared with the team (checked in), this workspace only
- `.claude/settings.local.json` — just you (gitignored), this workspace only
- `~/.claude/settings.json` — you, every workspace (global)

```json
{
  "hooks": {
    "PreToolUse":       [{ "matcher": "Bash|Edit|Write", "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/pre-tool-use.sh" }] }],
    "PostToolUse":      [{ "matcher": "Edit|Write",       "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/post-tool-use.sh" }] }],
    "UserPromptSubmit": [{ "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/user-prompt-submit.sh" }] }],
    "Stop":             [{ "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/stop.sh" },
                                     { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/stop-proof-check.sh" }] }],
    "SubagentStop":     [{ "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/subagent-stop.sh" }] }],
    "Notification":     [{ "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/notification.sh" }] }],
    "PreCompact":       [{ "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/pre-compact.sh" }] }],
    "SessionStart":     [{ "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh" }] }],
    "SessionEnd":       [{ "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-end.sh" }] }]
  }
}
```

Only `PreToolUse` / `PostToolUse` use `matcher` (a regex on tool name; drop it to match all). The rest ignore it.

Any event can run **multiple** hooks — above, `Stop` runs both `stop.sh` (brevity + persistence) and `stop-proof-check.sh` (blocks a correctness/completeness claim made with no investigation tool call that turn). They're separate files so neither touches the other's logic; list only the ones you want.

## Conventions

- stdin is JSON; parse with `jq`.
- Exit codes: `0` = ok, `2` = block (stderr is shown to Claude or you, depending on event), anything else = non-blocking error.
- For richer control (allow/deny/ask, injecting context), print the event's `hookSpecificOutput` JSON to stdout, see each stub's header.
- Keep them fast; they run synchronously on the hot path.

Reference: https://docs.claude.com/en/docs/claude-code/hooks
