#!/usr/bin/env bash
# PreCompact — fires before context compaction (auto or manual /compact).
# stdin (JSON): { session_id, cwd, trigger: "auto"|"manual", custom_instructions, ... }
# Use for: snapshot/transcript backup before context is summarized.
input=$(cat)
exit 0
