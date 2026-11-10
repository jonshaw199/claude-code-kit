# sync

Instructions for the daily job that promotes **new, generalizable learnings** from your
local setup into this kit. A headless agent makes the generic-vs-private and PII call —
**org-specific content is never synced**. This directory is just the prompt; the engine
that schedules and runs it is [cron-claude](https://github.com/jonshaw199/cron-claude).

- [`PROMPT.md`](PROMPT.md) — what the agent does each run (classify, scrub, commit, push).

## Running it

Define a [cron-claude](https://github.com/jonshaw199/cron-claude) job that points at this
prompt, with the kit as the working dir and your source dirs as readable dirs:

```sh
# jobs/kit-sync.job.sh  (local, gitignored)
JOB_NAME="kit-sync"
PROMPT_FILE="/path/to/claude-code-kit/sync/PROMPT.md"
WORKING_DIR="/path/to/claude-code-kit"
ADD_DIRS=( "$HOME/.claude" )          # your live hooks/skills/rules, memory, etc.
ALLOWED_TOOLS="Read Edit Write Grep Glob Bash"
GIT_OUTCOME=1                          # report what actually got committed
```

```bash
DRY_RUN=1 cron-claude run kit-sync     # preview
cron-claude install kit-sync           # schedule daily
```

## Safety

The agent promotes only what it judges generic and non-identifying, and is told that
when unsure it must leave a learning out rather than risk a leak. Keep the kit repo
**private** as a backstop.
