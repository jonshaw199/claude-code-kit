# Prompt stamps

Every numbered `*.md` file here is concatenated to stdout by
`hooks/user-prompt-submit.sh` and injected into the model's context on every turn,
in lexical order. The loader only picks up files whose name starts with a digit
(`[0-9]*.md`), so the numeric prefix sets both load order and eligibility. Rules are
**data, not code** — add one by dropping a file here; no script edit, nothing to wire.

- `NN-*.md` — generic rules, committed and shared.
- `NN-*.local.md` — private / org-specific rules. **Gitignored**, loaded the same way.
- `*.example` and `README.md` — not matched by the glob, so never injected.

See `90-local.example` for how to add a private rule.
