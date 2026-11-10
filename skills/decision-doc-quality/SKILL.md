---
name: decision-doc-quality
description: Draft, structure, and revise engineering decision/spike/options docs (e.g. in Notion) that propose options and a recommendation, using plain language, collapsible per-option detail, and evidence-backed claims. Apply whenever writing or editing a doc that lays out options, trade-offs, or a recommendation for the team to review.
---

# Decision / Options Doc Quality

Use these rules for every engineering decision, spike, or options doc that proposes choices and a recommendation. The reader is a busy teammate with zero context; the doc must be skimmable, plain, and provable.

## Audience: assume zero context

- Assume the reader knows none of the tribal knowledge. Gloss or hyperlink every term, acronym, service name, tool, and pattern on use (e.g. CDC, Debezium, Kafka, SNS, SQS, outbox, logical replication, Temporal). "Nobody knows what any of this means."
- Explain what a thing *is* and *does* in plain words before relying on it. Prefer a plain phrase + a link over jargon alone.
- Don't add a separate glossary section unless asked; link terms inline instead.

## Writing style

- Lead with the point (BLUF). State the main takeaway first, then detail.
- Short. One-liners beat paragraphs. If a section reads as a wall of text, cut it. Nobody reads long docs.
- Plain language. No AI-slop, no filler that "sounds good," no narration of the doc's own evolution, no defending your reasoning inside the doc (e.g. never "direct evidence, not theory").
- No em dashes anywhere. No ALL-CAPS for emphasis (use bold). No decorative numbering or middot separators that read as machine-generated.
- "We" for the work the team would do; "I" for the author's opinion/lean. Keep them distinct.

## Structure

- **Recommendation / TL;DR up front.** A few lines: the lean, the key reasons (as bullets), framed as an initial take on a living doc that will change after team input. Make indifference and flexibility explicit when they're real; still state a preference and why.
- **One collapsible block (toggle) per option.** The collapsed line shows a short label + a one-line plain-English gist. Inside: a simple diagram, How it works, what's reused (with proof links), what's net-new, scale/trade-off, and a small code or config sketch. Keep the surface scannable.
- **Keep peer sections parallel (consistency is not optional).** Options/tools/candidates are siblings, so every one MUST follow the same template: the same subsection headings in the same order, the same presence of diagram / media / code sketch, the same depth. Fix the template once (from the strongest section) and apply it to all; when you add or edit one section, re-align the others. Never let each section drift into its own shape, divergent structure reads as sloppy and defeats the whole point (easy side-by-side comparison). This is a recurring failure mode: check it before sharing.
- **Group options by a single clean axis** (e.g. *when* something happens, or *how*). Never conflate two axes into one grouping or create false-peer categories that overlap. If a thing is an implementation detail of another option (a runner, a landing location), fold it in, don't list it as a peer.
- **Illustrate the shared/hardest core**, not just the options, with its own sketch (handle the full lifecycle, e.g. create/update *and* delete).
- **Diagrams** (mermaid) for illustration; keep them accurate (don't draw a table as a separate DB, etc.).
- **End with an invitation** for feedback ("Other ideas?"); never end abruptly.
- Keep metadata minimal, only what's wanted (often just the ticket link). Drop status/boilerplate lines the author doesn't care about.

## Comprehensiveness of options

- List options exhaustively, not the usual two or three. Real problems have many; include the clearly-bad ones too so the whole field is visible (label them as weak/baseline).
- Always acknowledge the "do nothing" baseline and state its consequence.
- Research real sources (docs, Stack Overflow, Reddit, vendor/pattern references) to find options and the correct terminology. Wikipedia alone is the lazy default; find the relevant primary source.
- Name established design patterns correctly and link them; do not misapply a pattern name. Verify the pattern actually fits before citing it.

## Evidence (the core rule)

- Every claim about what the system already has is backed by a hyperlink to the proof (source file + line, infra config, ticket). No assumptions, no hand-waving.
- If a claim can't be proven with a link, mark it unverified rather than stating it as fact.
- Verify by reading the actual file/infra yourself. Do not assert a subagent's finding as fact without reading it; distinguish "I read it" from "an agent reported it," and state confidence when it matters.
- Never flip-flop silently. When a check changes a prior claim, say what was wrong and why, and correct it.
- Challenge the premise and your own conclusions when pushed; re-verify instead of defending.
- Hyperlink every identifier, filename, ticket, PR, and reference; never leave a bare id for the reader to hunt.

## Options doc content

- Separate the hard shared core (the work that's needed no matter which option) from the wrappers/mechanisms around it, and say which is the real effort and risk.
- Give pros and cons, grounded. Don't overclaim ("most of the work and nearly all the risk" → soften to what's accurate).
- Note what each option reuses (that already exists) vs. what is net-new.

## Process

- Make minimal, targeted edits. Don't rewrite the whole doc for a small change.
- For sensitive wording, show the draft in chat and iterate before applying.
- For an accompanying review/Slack message: keep it incredibly short and genuinely inviting (people are busy and won't want to read it); don't claim it's urgent or not-urgent unless asked; prime reviewers with the single most useful framing.

## Final check

Before sharing a doc, verify:

- The main point / recommendation is up front and short.
- Every "what we have" claim has a proof link; unverified claims are labeled.
- Jargon is glossed or linked; a no-context reader can follow it.
- Options are grouped on one clean axis, each collapsible with a plain one-line summary.
- No em dashes, no ALL-CAPS emphasis, no self-narration, no AI-slop.
- "We" vs "I" used correctly; lean stated but flexibility clear.
- The doc invites feedback and doesn't end abruptly.
