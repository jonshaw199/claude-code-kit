---
name: jira-ticket-quality
description: Audit, draft, create, or revise Jira tickets and backlogs using evidence-backed, concise scope and testable acceptance criteria. Apply whenever work concerns Jira issue quality, necessity, decomposition, or wording.
---

# Jira Ticket Quality

Use these rules for every Jira ticket audit, draft, creation, or edit.

## Authorization

- Reading, auditing, or proposing tickets does not authorize Jira mutations.
- Before creating, editing, moving, or deleting issues, show the proposed changes unless the user explicitly authorized those exact mutations.
- Never create a batch of tickets when the user authorized only review or one example.

## Necessity

- Prove that each ticket represents necessary, non-duplicate work.
- Search the parent initiative, sibling epics, existing tickets, completed work, linked PRs, current documentation, and source code before recommending a ticket.
- For an existing backlog, give each ticket a `keep`, `merge`, `delete`, or `rewrite` verdict with evidence.
- Do not create a spike merely because implementation is complicated. A spike is justified only by a concrete unresolved decision that cannot be answered from existing evidence.

## Consistency across an epic / batch

- Tickets that are siblings under one epic (or any batch of similar tickets) are peers, so they MUST follow the same shape: same section layout (summary / scope / acceptance criteria), same granularity, same title pattern. Fix the template once and apply it to every sibling; when you add or edit one, re-align the rest. Divergent structure across siblings reads as sloppy, check it before creating/sharing. (Same rule applies to parallel sections within one doc.)

## Context and tone

- Open every ticket with a one-line, plain-English context lead: what this ticket does and the feature/epic it belongs to. Assume the reader has zero context; never drop them straight into rationale.
- Use simple language. Hyperlinks supply supporting detail, they do not replace a plain explanation: a reader should understand the ticket without opening a single link.
- Describe, don't argue. State what is true matter-of-factly; don't build a case or try to persuade the reader. Avoid defensive phrasing ("direct evidence, not theory", "as proven", over-justifying a claim).
- Don't name the rationale section "evidence"; call it Why or Background. Keep the linking discipline below without the courtroom tone.

## Evidence

- Hyperlink every supporting Jira issue, PR, source file, design/RFC, Slack thread, API document, runbook, and other reference. Never leave a bare identifier for the reader to hunt down.
- Support factual claims with primary evidence. Prefer current source code and merged PRs over planning prose.
- Distinguish clearly among:
  - **Confirmed:** directly supported by linked evidence.
  - **Inference:** conclusion drawn from linked evidence.
  - **Open question / TODO:** not yet established.
- Never use definitive words such as “only,” “all,” “always,” or “no callers” without an exhaustive, linked check that proves the claim.
- Call out stale or conflicting evidence instead of silently choosing whichever source fits the ticket.

## Scope and implementation detail

- State the problem, required outcome, constraints, and known dependencies.
- Do not prescribe implementation details unless the evidence makes them necessary and reliable.
- Do not present a speculative implementation as the plan. Leave uncertain implementation choices as explicit TODOs to resolve during implementation or in a justified spike.
- Include enough context to make the ticket executable, but do not write a design document inside Jira.

## Concision

- Prefer short bullets and direct language.
- Remove narrative history, repeated context, speculative edge cases, and implementation tutorials.
- Link to source material instead of reproducing it.
- Open with a one-line context lead (see Context and tone), then use only the sections the ticket needs. A typical ticket is:
  - **Context** (the one-line lead)
  - **Why** (or **Background**)
  - **Scope**
  - **Acceptance criteria**
  - **Out of scope / dependencies** when needed
  - **References**

## Acceptance criteria

- Make every criterion observable and testable.
- Cover the user-visible or system outcome, relevant failure behavior, compatibility requirements, and proof that the old dependency/path is gone when applicable.
- Avoid vague criteria such as “works,” “handled,” “supports,” “migrated,” or “verified” without saying what evidence demonstrates success.
- Do not encode an unproven implementation choice in acceptance criteria.

## Final check

Before proposing or mutating a ticket, verify:

- It is necessary and not already covered.
- Every material factual claim has a hyperlink.
- Facts, inferences, and open questions are separated.
- The ticket is concise.
- Scope boundaries and dependencies are explicit.
- Acceptance criteria are clear and testable.
- The requested Jira mutation is explicitly authorized.
