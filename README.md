# claude-code-kit

A portable, reusable [Claude Code](https://docs.claude.com/en/docs/claude-code) setup:
event hooks that enforce working discipline, a file-driven rule-stamping system, skills,
and a base `AGENTS.md`. Org-specific and private bits stay out of git by convention, so
the kit is safe to share and carry between projects.

## What's inside

| Path | What it is |
| --- | --- |
| `hooks/` | One script per Claude Code hook event. Pure machinery — no project data. |
| `rules/prompt-stamps/` | Per-turn rules as **data files**, stamped into context by the `UserPromptSubmit` hook. |
| `skills/` | Reusable skills (e.g. Jira-ticket and decision-doc quality). |
| `AGENTS.base.md` | Project-agnostic working principles to drop into a repo. |
| `settings.example.json` | Wiring that activates the hooks. |
| `sync/` | The prompt for a daily job that promotes new generalizable learnings into this kit (run via [cron-claude](https://github.com/jonshaw199/cron-claude)). See [`sync/README.md`](sync/README.md). |

## Design

- **Separation of concerns.** Hooks are mechanism; rules are content. The
  `UserPromptSubmit` hook doesn't hardcode any rule text — it concatenates every numbered
  file in `rules/prompt-stamps/`.
- **Open/closed.** Add, remove, or reorder a rule by dropping/renaming a file. No script
  edit, nothing to re-wire.
- **Generic/local split.** Committed `NN-*.md` stamps are generic and shareable.
  Private or org-specific stamps go in gitignored `NN-*.local.md` files and load the same
  way. Same idea for docs: commit `AGENTS.base.md`, keep an uncommitted `AGENTS.local.md`.

### The hooks

- `user-prompt-submit.sh` — stamps the prompt-rules into context every turn.
- `stop.sh` — enforces brevity (blocks wall-of-text replies) and a persistence deadline
  (blocks early yield while a "keep working until X" directive is active).
- `pre-tool-use.sh` — gates `gh pr comment/review` writes so a human's thread is never
  replied to automatically.
- `pre-code-edit.sh` — investigate-first checkpoint: denies an implementation edit unless
  the preceding message named the prior-art pattern being copied.
- The rest (`post-tool-use`, `notification`, `pre-compact`, `session-start`,
  `session-end`, `subagent-stop`) are documented no-op stubs to extend.

## Install

```bash
# Copy (or symlink) the kit into a project or your home Claude dir so hooks/ and
# rules/ stay siblings:
cp -R claude-code-kit/hooks claude-code-kit/rules ~/.claude/
cp -R claude-code-kit/skills/* ~/.claude/skills/   # optional

# Activate the hooks: merge settings.example.json into
# ~/.claude/settings.json (global) or .claude/settings.json (per project).
```

Add your private rules as `rules/prompt-stamps/NN-*.local.md` (gitignored). See
[`rules/prompt-stamps/README.md`](rules/prompt-stamps/README.md).

## Secret guard

A `.githooks/pre-commit` hook blocks any commit that introduces a likely secret or PII —
the structural backstop for the automated [sync](sync/). Enable it per clone:

```bash
git config core.hooksPath .githooks
```

## License

Personal tooling, provided as-is.

