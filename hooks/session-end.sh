#!/usr/bin/env bash
# SessionEnd — fires when the session ends.
# stdin (JSON): { session_id, cwd, reason, ... }
# Use for: cleanup, flush logs. Cannot block shutdown.
input=$(cat)
exit 0
