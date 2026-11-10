# sync

A once-a-day job that promotes **new, generalizable learnings** from your local setup
into this kit. A headless Claude agent makes the generic-vs-private and PII call —
**org-specific content is never synced**. Runs via macOS `launchd` (no long-lived
daemon), notifies you after each run, and writes a `status.json` you can glance at.

## Setup

```bash
mkdir -p ~/.config/claude-kit-sync
cp sync/config.example.sh ~/.config/claude-kit-sync/config.sh
$EDITOR ~/.config/claude-kit-sync/config.sh   # set KIT_REPO + SOURCE_DIRS

sync/install.sh run        # DRY_RUN=1 sync/install.sh run  to preview first
sync/install.sh install    # schedule it (daily)
```

The config lives outside any repo and holds only machine paths — it is never committed.

## Commands

| Command | What it does |
| --- | --- |
| `sync/install.sh run` | Run one sync now (prefix `DRY_RUN=1` to preview with no commit). |
| `sync/install.sh install` | Render the launchd job from your config and load it. |
| `sync/install.sh uninstall` | Unload and remove it. |
| `sync/install.sh status` | Print the last sync status. |
| `sync/dashboard.sh` | Serve the one-page dashboard at `http://localhost:4320`. |

## How it decides what synced

The result is derived from the kit repo's git `HEAD` before and after the run (not from
the agent's self-report): if `HEAD` moved, those files were promoted; if not, nothing was.
The agent also leaves a one-line note (e.g. "skipped 1 private"). Both land in
`status.json`.

## Safety

- The agent promotes only what it judges generic and non-identifying, and is told that
  when unsure it must **leave a learning out** rather than risk a leak.
- It never force-pushes, rewrites history, or opens/comments on PRs.
- Keep your kit repo **private** as a backstop.
