---
name: feedback-readable-code
description: "Prefer self-explanatory code over comments; when comments are necessary, keep them brief and direct"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 65214d9c-72da-4180-bba0-8de68c2d0e4c
---

Write code that reads clearly on its own — favor good names, small functions, and obvious structure over inline explanations. Add a comment only when the *why* is non-obvious (hidden constraint, subtle invariant, workaround). When a comment is necessary, keep it to one short line: direct, no preamble, no narration of what the code does.

**Why:** Adrian's explicit preference (stated 2026-05-14). Aligns with his demand for brutal honesty — comments that restate code are noise, and noise hides the parts that actually matter.

**How to apply:**
- Default to zero comments in new code.
- Before writing a comment, ask: "Would a good name or extraction make this unnecessary?" If yes, refactor instead.
- If the comment survives that test, trim it: one line, no fluff, no "this method does X" — explain *why*, not *what*.
- Never add comments that reference the current task, ticket, or recent change (those belong in commits/PRs).
- Applies to all repo artifacts (Ruby, ERB, configs) — keep them in English per [[feedback-repo-language-english]].
