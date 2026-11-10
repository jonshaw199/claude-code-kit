# Working principles (base)

Portable, project-agnostic working style for coding agents. Drop this into a repo as
`AGENTS.md` (or append it), and keep anything org-specific in a separate, uncommitted
`AGENTS.local.md`. These mirror the per-turn prompt stamps in `rules/prompt-stamps/`
but in longer form.

## Operating

- **Don't ask permission to read — just read it.** Only pause for confirmation on writes
  or anything hard to reverse or outward-facing.
- Reading a file with a line limit/offset doesn't count as having read the whole file; if
  you intend to edit it, read it in full first.
- **Never go idle on a background task.** After kicking off async work (a backgrounded
  command, a long build or probe), don't say "I'll continue when it finishes" and stop —
  read its output and act on partial results, or re-run it synchronously with a bounded
  timeout and keep driving. If something genuinely must run long, name the concrete next
  check and when. A bare "waiting" reads as abandonment.

## Code changes

- **Follow existing patterns; invent nothing.** Before writing any code, read a sibling
  / the surrounding code and copy that form verbatim. Don't introduce a construct the
  codebase doesn't already use to paper over an edge case. If a case genuinely differs,
  handle it the way the repo already handles optional cases. No prior art for what you
  think you need? Stop and ask.
- **Investigate before you change.** Map the whole feature area first — every peer action
  on the surface, front and back, and which layer enforces each. Model the fix on a
  pattern you can name, consistent across the surface. Never bolt a one-off onto a single
  affordance without checking its siblings and its backend.
- **Default to no comments.** Write atomic code with self-explanatory names. A comment
  earns its place only for a non-obvious *why* the code can't carry, and then it's one
  line. No narration, no restating the signature, no history, no ticket IDs.
- **Isolate work.** Prefer a dedicated branch / worktree per change so each is
  independently checkout-able, testable, and reviewable. Never build a second change on
  top of another's uncommitted branch.
- **When a correction lands mid-task, re-apply it to every file you touched** — not just
  the one flagged.

## Honesty and proof

- **Proof, not assertion.** Never state a status (pushed, merged, deployed, on-branch)
  from memory or inference. Verify with a command that can fail (`git ls-remote`,
  `gh pr view`, grep the file) and act on that output. If you can't prove it, say so.
- **Report outcomes faithfully.** If tests fail, say so with the output. If a step was
  skipped, say that. When something is done and verified, state it plainly.
- **When a hook or command fails, stop and read the error, then fix the root cause.**
  Don't bypass it (`--no-verify`) or route around it with git gymnastics.

## Writing (PRs, tickets, docs)

- **Lead with the answer. Keep it short.** No meta-status, no process narration, no
  account of bugs you introduced and fixed along the way. Say what it does, how to verify
  it, and link the references. The reader has zero prior context; the doc stands alone.
- **Hyperlink every reference — never a bare ID or filename.** A raw ticket key, PR
  number, commit SHA, or filename the reader has to go look up is slop; render it as a
  link.
