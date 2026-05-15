---
name: pr-review-workflow
description: "When Adrian says \"revisa los comentarios del PR\" (or similar), run the full self-service Gemini review loop. Triage each comment by value-added to the code (not reviewer-pleasing); rejection is a first-class outcome, not a fallback."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6a6ab3b9-90e0-41eb-a2d7-417bdca26dea
---

**Rule:** When Adrian asks me to handle a PR's review feedback (phrasings like *"revisa los comentarios de gemini"*, *"arregla lo que tenga sentido"*, *"checa el feedback del PR"*), I run the complete self-service loop without asking permission for each step. **The success criterion is "code is better after this round", not "reviewer is satisfied with the round".** Rejection of a comment is a normal outcome when applying it would not improve the code or contradicts a decision in flight.

**Why:** Adrian invoked this pattern multiple times on Sprint 3 PRs and confirmed it was the right cadence. The rule was tightened in S05 PR #65 after Adrian noticed a 0/22 rejection rate across S04-S05 — a sustained 100% acceptance rate is rubber-stamping, not engineering. Gemini is well-trained but not infallible; a reviewer-pleasing loop produces worse code than a critical loop because some Gemini suggestions add ceremony without value, propose defensive coding without scenarios, or contradict in-flight architectural decisions.

**How to apply:** When triggered, run:

1. **Fetch review** — both inline and summary:
   ```bash
   gh api repos/rodacato/stockerly/pulls/<N>/comments --jq '.[] | "PATH: \(.path)\nLINE: \(.line)\nBODY:\n\(.body)\n---"'
   gh pr view <N> --json reviews --jq '.reviews[] | {author, state, body, submittedAt}'
   ```

2. **Triage each comment** by value-added to the code, NOT by reviewer-pleasing. For each comment, before deciding to apply, ask explicitly:

   | Comment type | Default action |
   |---|---|
   | Real bug or correctness issue | Apply |
   | Measurable perf concern (N+1, unbounded fetch, O(N²) etc.) | Apply |
   | Consistency with existing codebase pattern | Apply unless the existing pattern is itself wrong |
   | Observability gap (logging, monitoring) with clear value | Apply |
   | Defensive coding for hypothetical scenario | **Push back**: ask "what's one concrete failure case?" If none, reject |
   | Ceremony (extra abstraction, base classes for compliance only) | **Push back**: does this add value beyond rule compliance? |
   | Contradicts a decision in flight (e.g., a pending ADR or upcoming sprint scope) | **Reject** with reasoning; do not pre-undo work the next PR will redo |
   | Style/preference unrelated to project conventions | Reject; project conventions win |

   **Critical anti-pattern to avoid:** noting a tension in the reply and then applying anyway. If I write "worth noting, this conflicts with X" — that's me signaling the right answer is NOT to apply. Honor that signal. Hypocritical replies are worse than disagreement.

   **Rejection-rate sanity check:** if the rejection rate across a sprint stays at 0%, something is wrong. Gemini is well-trained but not infallible; a sustained 100% acceptance rate is rubber-stamping. After each review round, glance at the rolling rejection rate — if it's been 0% for the last 3-4 PRs, the next ambiguous comment should default to "reject and defend" rather than "apply and rationalize".

   Present the triage table to Adrian. Rejections include the contra-argument in the table itself, not buried in a reply.

3. **Apply fixes**. Each fix should:
   - Make the change minimal — don't expand scope unless I find a related real issue (like the audit-entropy regex on PR #58 where I broadened beyond the literal suggestion and noted it honestly).
   - Preserve atomicity — single fix-commit per round of review, not one commit per Gemini comment (those would create review noise).

4. **Local CI before push**: `bundle exec rspec`, `bin/rubocop`, `bin/brakeman --no-pager`. Skip brakeman for view-only changes; always run rubocop + the test paths actually touched.

5. **Commit + push**:
   - One commit titled `fix(<ctx>): apply Gemini review on PR #<N>` with a body listing each numbered fix.
   - Push to the PR branch (`git push origin <branch>`). **Never `--force-push` and never amend** the prior commits unless Adrian explicitly asks — the rebase/force-push step on PR #56 cost a Gemini review cycle, which is precisely why follow-up commits stay as new commits now.

6. **Reply inline** to each Gemini comment via `gh api -X POST .../comments/<id>/replies -f body="..."`.
   - For applied: `"Applied in <SHA>. <one-sentence why-it-improves-the-code>"`. The SHA must be the actual fix commit, not master.
   - For rejected: `"Not applying. <one-paragraph reason: what the comment misses, the trade-off the project chose, link to the relevant ADR or decision if any>"`. Rejection replies must be polite but firm — bots get re-trained on rejections, so a clear "this is the wrong call because X" is more useful than silence.

7. **Honest tail**: If applying the fixes surfaced a finding Adrian doesn't know yet (e.g., the broader regex revealed a baseline 11 hits higher than reported in the PR body), state it directly in the user-facing summary, not silently in the commit body. Anti-pattern #7 (no retros / no audits) extends to PR reviews — surface what changed even if it makes earlier numbers look optimistic.

**What this loop does NOT do**:
- Does not silently skip a comment. If it's wrong, post a rejection reply with reasoning. Silence is worse than disagreement.
- Does not apply a comment "just in case" or to avoid a back-and-forth. If applying it doesn't make the code better, reject it.
- Does not bundle a refactor into a "fix Gemini" commit. Scope stays exactly the review surface.
- Does not request re-review explicitly — Gemini auto-runs on push. Just push and move on.

**Reference example of when to reject** (S05 PR #64): Gemini said `EnsureFreshFxRate` must inherit from `ApplicationUseCase` per the CLAUDE.md rule. I applied. But `EnsureFreshFxRate` was the canonical exemplar for the upcoming #38 / ADR-006 (SimpleUseCase pattern). The right call was rejection: *"This use case is the seed case for ADR-006 — it has no yield/validate/publish needs. Applying ApplicationUseCase here just gives #38 more code to undo. Leaving as a plain class is intentional architectural staging."* That kind of pushback would have saved a refactor cycle. Adrian flagged the 0% rejection rate at PR #65 and this rule was added in response.

Related: [[feedback_brutal_honesty]] (the honest-tail step + the rejection-rate sanity check), [[feedback_anti_patterns]] (#3 patterns over pragmatism — Gemini-suggested ceremony without value-added is the canonical case for rejection).
