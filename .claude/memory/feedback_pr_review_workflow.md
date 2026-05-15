---
name: pr-review-workflow
description: "When Adrian says \"revisa los comentarios del PR y arregla lo que tenga sentido\" (or similar), run the full self-service Gemini review loop without asking for steps. Workflow validated across PRs"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6a6ab3b9-90e0-41eb-a2d7-417bdca26dea
---

**Rule:** When Adrian asks me to handle a PR's review feedback (phrasings like *"revisa los comentarios de gemini"*, *"arregla lo que tenga sentido"*, *"checa el feedback del PR"*), I run the complete self-service loop without asking permission for each step. The current PR is the most recently opened branch (or the one in the running todo context).

**Why:** Adrian invoked this pattern three times on Sprint 3 PRs (#56, #57, #58) and confirmed it was the right cadence each time. Asking "should I fix X first or Y?" once the pattern is established just adds latency. The loop is also the same shape every time, so codifying it removes interpretation drift.

**How to apply:** When triggered, run:

1. **Fetch review** — both inline and summary:
   ```bash
   gh api repos/rodacato/stockerly/pulls/<N>/comments --jq '.[] | "PATH: \(.path)\nLINE: \(.line)\nBODY:\n\(.body)\n---"'
   gh pr view <N> --json reviews --jq '.reviews[] | {author, state, body, submittedAt}'
   ```

2. **Triage each comment in a brief table** to the user: severity (HIGH/MEDIUM/LOW per Gemini's badge), file:line, summary, decision (fix / skip + reason). I make the judgment call; I do not ask permission for each comment unless something genuinely uncertain comes up (e.g., scope creep, contradicts brand kit, requires a product decision).

3. **Apply fixes**. Each fix should:
   - Make the change minimal — don't expand scope unless I find a related real issue (like the audit-entropy regex on PR #58 where I broadened beyond the literal suggestion and noted it honestly).
   - Preserve atomicity — single fix-commit per round of review, not one commit per Gemini comment (those would create review noise).

4. **Local CI before push**: `bundle exec rspec`, `bin/rubocop`, `bin/brakeman --no-pager`. Skip brakeman for view-only changes; always run rubocop + the test paths actually touched.

5. **Commit + push**:
   - One commit titled `fix(<ctx>): apply Gemini review on PR #<N>` with a body listing each numbered fix.
   - Push to the PR branch (`git push origin <branch>`). **Never `--force-push` and never amend** the prior commits unless Adrian explicitly asks — the rebase/force-push step on PR #56 cost a Gemini review cycle, which is precisely why follow-up commits stay as new commits now.

6. **Reply inline** to each Gemini comment via `gh api -X POST .../comments/<id>/replies -f body="Fixed in <SHA>. <one sentence>"`. The SHA must be the actual fix commit, not the last commit on master. Comment IDs come from step 1.

7. **Honest tail**: If applying the fixes surfaced a finding Adrian doesn't know yet (e.g., the broader regex revealed a baseline 11 hits higher than reported in the PR body), state it directly in the user-facing summary, not silently in the commit body. Anti-pattern #7 (no retros / no audits) extends to PR reviews — surface what changed even if it makes earlier numbers look optimistic.

**What this loop does NOT do**:
- Does not skip a Gemini comment just because it's annoying. If a comment is wrong, push back with reasoning, don't silently ignore.
- Does not bundle a refactor into a "fix Gemini" commit. Scope stays exactly the review surface.
- Does not request re-review explicitly — Gemini auto-runs on push. Just push and move on.

Related: [[feedback_brutal_honesty]] (the honest-tail step), [[feedback_anti_patterns]] (#3 patterns over pragmatism — if a Gemini suggestion proposes ceremony that doesn't match the codebase, choose pragmatism and document why).
