# Retro — Sprint S02 (truth-foundation)

> Honest post-mortem. Without retro, the sprint does NOT close (hard rule of the protocol).
>
> **Close date:** 2026-05-14
> **Actual duration:** ~30 Claude session-hours, 1 calendar day (high-intensity paired session)
> **Estimated duration:** 20–25 session-hours
> **Goal:** *"Stockerly stops lying about currency — captured at the data source — and removes dishonest public surfaces."*

---

## What worked?

- **Splitting #27 into 5 sub-issues at sprint opening.** What was framed as a single P0 in the audit became #41–#45, each mergeable independently. Each had its own discovery card, its own PR, its own Gemini review pass. The blast radius of a regression in one was contained.
- **Pragmatic-over-dogmatic DoD reconciliation.** Twice during execution (in #42 and #44) the DoD assumed infrastructure that didn't exist (`FxRate` as time-series, `BanxicoGateway` FX endpoint). Surfacing the gap immediately and choosing "Option A: FX-at-record-time" honestly let us ship JTBD value now instead of expanding scope. The choice is documented in code comments, PR bodies, and the brand decision record — future-self will know what was decided and why.
- **Single source of truth via `Trading::Domain::FxRateResolver`.** #44 extracted the 6-branch resolution logic from `ExecuteTrade` into a shared service. The rake task became a thin consumer; future calculator refactor (#28) can reuse the same resolver. Avoided what would have been a copy-paste pair.
- **Gemini code review was productive, not noise.** Real bugs caught on multiple PRs: BigDecimal precision on FX rate (PR #49), `country IN ('US','USA')` redundancy with `limit: 2` (PR #46), the regex backreference case-mismatch in `audit-entropy.sh` (PR #46), `delegate :currency, allow_nil:` (PR #50), Modal/AlertToast missing from catalog (PR #54). Each was a fix worth making. The cycle "Gemini reviews → respond inline + commit fix → re-push → verify CI green" became the standard PR loop.
- **Renata sub-agent invocation for #34.** Spawning Renata as a preliminary reviewer of the brand catalog produced 6 hard findings (AlertToast carve-out, mobile DataTable pattern, KpiCard stale/partial states, glyph prefix on gain/loss, ThemeToggle radio semantics, Modal deferral) — none of which were in my v1 catalog. The pattern of "spawn an expert for *complementary* preliminary input, not gatekeeping review" is worth replicating.
- **Two parallel housekeeping PRs (#47 Claude workflows, #48 dependency refresh) consolidated mid-sprint.** Rather than letting noise (12 Dependabot PRs, a failing `claude-review` check) pollute every other PR, two small focused PRs cleared the surface and let the rest of the sprint stay on-topic. Pattern: when the same source of CI noise hits 3+ feature PRs, branch off a separate housekeeping PR.
- **Session-hours metric switched mid-sprint per Adrian's feedback.** "2 weeks calendar" was incoherent for our paired-session pace. The new "~20–25 session-hours" estimate was concrete, comparable across sprints, and immediately useful for the retro calibration below. Memory rule `project_working_method.md` updated to lock it in.
- **`script/audit-entropy.sh` baseline tracking worked.** Hardcoded `"USD"` literals dropped 11→8, ADR-001 violations 8→1 (false positive), cross-context leaks held at 10. Numbers told the truth about progress and surface area for S5 architectural work.
- **The Sprint 1 retro's instruction to "open Sprint 2 in a new session" paid off.** Discovery in S2 opening was fresh — no leftover context, no shortcuts pulled from memory. Forced re-reading of the audit and the issue bodies.
- **Honest gap-flagging.** Multiple times this sprint, I surfaced "DoD assumes X but reality is Y, here are 3 options" instead of either silently fudging or expanding scope. Adrian got real decisions to make. The pattern showed up most explicitly in #42's FX historical decision and #34's logo design tooling prompt.

## What didn't work?

- **Several PRs needed force-push for in-PR scope creep.** Notably:
  - PR #46 force-pushed after Gemini review (USA-redundancy + audit-entropy regex fix).
  - PR #49 force-pushed after Gemini review (BigDecimal precision fix).
  - PR #50 added a follow-up commit for the same kind of review-driven scope expansion.
  - This is *fine* (small PRs, surgical fixes) but it slows down the "review → merge" cadence. Adrian's flow is: read Gemini, ping me, I push fix, wait for CI, then merge. Three round-trips minimum.
- **Initial PR #46 had a stale base.** Adrian had 18 unpushed master commits when the PR was opened, so the diff initially showed 18+1 commits instead of just the new work. The fix (rebase + force-push) was simple but the confusion cost ~15 min of investigation. **Cause:** I didn't verify `origin/master == master` before branching for the first feature work.
- **DoD assumptions vs code reality, twice.** Both #42 and #44 had DoDs that referenced FX historical data infrastructure that didn't exist. The split happened during Sprint 2 opening, but the DoDs were written without a code-state audit. The reconciliation cost was ~20 min each — small individually, but a signal that **the discovery card must be paired with a code-state audit, not just a feature audit.**
- **`audit-entropy.sh` shipped with bugs.** The comment-filter regex didn't match the grep output format (prefix-stripping mistake), so the cross-context leak count was inflated by ~24 false positives at sprint open. Caught during PR #54 review (I noticed during a delta check, not Gemini). The baseline I recorded in `log.md` (33 leaks) was wrong; the real baseline was 9. **Lesson:** entropy/audit scripts need their own test pass before being declared a baseline.
- **`components.md` is large — flirts with anti-pattern #4 (doc bloat).** Including Renata's full appendix it's ~780 lines. JUSTIFIED for a component catalog (it's the canonical reference for the visual migration), but exactly the kind of doc that gets cited once and never re-read. Watch in S3 retro: if no one references §A.2 or §A.7 during implementation, trim aggressively at sprint close.
- **Brand prompt iteration was sequential.** Generating 3 palette mockups + 3 logo concepts + final brand kit happened in 3 round-trips with Adrian using Claude Design externally. Sprint 1 used 4 parallel sub-agents for the audit and finished in ~3 minutes calendar. For Brand Discovery I should have parallelized: 3 separate prompts (one per palette), 3 logo concept prompts, all in parallel for Adrian to render simultaneously. Lesson: when output is independent renders, parallelize the prompt generation.
- **Estimated 20–25 session-hours, actual ~30.** Calibration: about **+43%** vs the midpoint of the estimate. Main overhead: Gemini review cycles (legit fixes, but multiple round-trips per PR), DoD reconciliation surprises, brand kit doc volume. Calibration for S3: assume PRs cost 1.5× the implementation estimate because Gemini will find real issues most of the time.
- **Memory file edits not always carried in their natural commit.** The `feedback_readable_code.md` rule landed during #34 work but was committed by itself as a small follow-up — fine, but illustrates that I sometimes batch memory updates separately from the work that produced them. Cleaner: commit memory updates inline with the work that motivated them, in the same PR.

## What to change for the next sprint?

- [ ] **Sprint opening checklist update:** before assigning a sub-issue to a sprint, run a 5-min "code-state audit" alongside the discovery audit. Confirm the infrastructure the DoD references actually exists. Surface gaps before the issue is committed to the milestone, not during implementation.
- [ ] **Standard PR flow:** verify `origin/master == master` before branching from master. Adopt `git fetch && git status` as the first command of every new feature branch.
- [ ] **Parallel sub-agent prompts for design discovery.** When the output is 3+ independent renders (palettes, logo concepts, screen mockups), generate the prompts in parallel and present them simultaneously. Reuse the Sprint 1 pattern.
- [ ] **Memory updates ride with their PR.** When a feedback rule emerges during work on issue X, commit the memory file in the same PR that produced the rule. Avoid the "small follow-up memory commit" anti-pattern.
- [ ] **Calibration: PR estimates × 1.5 for Gemini cycles.** When estimating an issue's session-hours, add 50% for the review-fix-merge loop. Sprint 1 didn't have this overhead because there were no PRs; Sprint 2 had it on every PR; Sprint 3 will be the same.
- [ ] **`audit-entropy.sh` smoke test at sprint open.** Run the script + spot-check 5 hits to confirm the metrics are real before recording them as a baseline.
- [ ] **Open #28 in Sprint 3 with the Renata Appendix A as input.** Renata's hard findings (AlertToast, mobile DataTable, KpiCard stale states, glyph prefix, ThemeToggle ARIA, Modal placeholder) should be treated as part of the calculator/UI refactor scope. Don't lose them.
- [ ] **Trim doc bloat candidate.** Re-read `docs/research/experts.md` (flagged in S1 retro) AND `components.md` Appendix A at the S3 retro. If unused, trim aggressively.

---

## Vision alignment — state of the 6 axes

| # | Axis | Before (S2 open) | After (S2 close) | Notes |
|---|---|---|---|---|
| 1 | Every feature maps to a JTBD | 30% | 50% | Foundation for JTBD #1, #2, #5 is in place (Asset.currency, Trade.fx_rate, Position cleanup, admin currency capture, public-surface cleanup). Calculator refactor (#28) in S3 closes the loop end-to-end. |
| 2 | Zero prescriptive copy in code | 15% | 75% | #31 removed 7 of 8 ADR-001 violations from views. Brand kit phrasebook in `brand.md §9.1` formalizes es-MX voice. The remaining "1" is a false positive (legal disclaimer). |
| 3 | Zero aspirational fake copy | 10% | 90% | #31 removed all fake stats ("$4.2B Assets Tracked"), invented institutions, fake testimonials. Only the footer tagline "Open Source Market Intelligence Platform" survives — borderline marketing, not actively false. Candidate for an S3 trim. |
| 4 | Dashboard arithmetic truthful for MXN+USD | 5% | 40% | The DATA is now captured correctly (currency + FX rate at execution). The CALCULATORS still lie (8 of them, per Lucía's audit). #28 in S3 closes this — the foundation here is necessary but not sufficient. |
| 5 | Architecture without cross-context leaks | 25% | 30% | Net minimal change. Added a leak (`Trading::Domain::FxRateResolver` → `MarketData::Gateways::FxRatesGateway`), removed one (`Administration::SearchTicker` → `AlphaVantageGateway` direct), refined the admin path to go through a `MarketData::UseCases::SearchTickers` use case. Sprint 5 (`2026-S05-architectural`) owns the bulk reduction via ADR-002. |
| 6 | Docs reflect current code | 80% | 90% | Brand kit complete (3 docs + 3 SVGs + decision record). Sprint log + qa + retro maintained. Old `docs/branding/` cleaned up. CLAUDE.md / docs/README.md updated. Memory rules added. The 10% still-pending: `docs/research/experts.md` is still 430 lines (S1 retro flagged); `components.md` is large (S2 retro flags). |

**Synthesis:** Axis #2 and #3 jumped sharply (the "public surfaces" sub-goal of the sprint goal closed). Axis #4 jumped foundationally (the "data source" sub-goal closed) — but the user-visible payoff is in S3. Axis #5 is the architectural sprint's job. Axis #6 holds steady at high state.

---

## Anti-patterns I committed (if any)

Reviewed against [`.claude/memory/feedback_anti_patterns.md`](../../.claude/memory/feedback_anti_patterns.md).

- **#1 (Next phase = next thing to build) — NOT violated.** Each issue had explicit discovery + DoD + JTBD mapping. The "what to build next" decision was always driven by the sprint goal, not by what was easy.
- **#2 (PRD as gospel) — NOT violated.** The old PRD is archived; the live source-of-truth is `docs/vision/`.
- **#3 (Patterns over pragmatism) — NOT violated.** Multiple times this sprint we chose pragmatism explicitly: FX-at-record-time over Banxico FIX (#42), current-FX backfill over historical FX storage (#44), thin `MarketData::UseCases::SearchTickers` wrapper over a fuller anti-corruption layer (#45). Each was documented as a deferred future enhancement, not silently shipped as final.
- **#4 (Doc bloat) — MARGINALLY violated.** `components.md` plus Renata's Appendix A is ~780 lines. JUSTIFIED as a catalog reference (one of the few docs that genuinely benefits from being exhaustive), but on the edge. The §16 "When to add a new component" rule and §17 "When to invoke Renata" criteria help control growth, but watch in S3.
- **#5 (Skipping foundational checks) — MARGINALLY violated.** Twice the DoD assumed infrastructure that didn't exist (`FxRate` time-series, `BanxicoGateway` FX endpoint). Both surfaced during implementation, not at sprint open. Added "code-state audit alongside discovery audit" to the change list for next sprint.
- **#6 (Fragmenting redesigns without closing) — NOT violated.** Brand Discovery (#34) shipped as a complete v1 — palette, logo, tokens, components, decision record, all in one PR. The "visual migration" (S3-S6) is explicitly the next phase, not a fragment.
- **#7 (No retros / no audits) — ACTIVELY RESPECTED.** This file is the retro.

**Score:** 0 of 7 anti-patterns hard-violated; 2 marginally (#4 and #5). Acceptable; calibrate.

---

## Real vs estimated time

| Issue / Step | Estimated | Real | Reason for deviation |
|---|---|---|---|
| Sprint opening (split #27, write log, baseline entropy) | 2 h | ~3 h | Splitting #27 surfaced 2 DoD-vs-reality gaps in the sub-issues, which needed reconciliation conversations with Adrian. |
| #41 (S2-A — Asset.currency + backfill) | 2 h | ~3 h | Gemini review (`country IN ('US','USA')` redundancy + audit-entropy regex bug). |
| #47 (housekeeping: Claude workflows removal) | 0.5 h | ~0.5 h | OK. |
| #48 (housekeeping: dependency consolidation + close 12 Dependabot PRs) | 1 h | ~1.5 h | `bundle outdated` audit + curating safe-vs-deferred updates took longer than expected. |
| #42 (S2-B — Trade.fx_rate + ExecuteTrade) | 3 h | ~4 h | DoD-vs-reality gap (FxRate not time-series) required reconciliation. Plus Gemini review (BigDecimal precision). |
| #43 (S2-C — Position cleanup + delegate) | 2 h | ~3 h | Caller audit + spec migration to delete domestic/international value methods. Plus Gemini review (Position.delegate nil-safety, migration model isolation). |
| #44 (S2-D — Backfill rake + FxRateResolver extraction) | 3 h | ~4 h | DoD-vs-reality gap (same FxRate constraint surfaced again — should have been caught at sprint open with code-state audit). Plus Gemini review (currency normalization + private_class_method). |
| #45 (S2-E — Admin ticker currency capture) | 2.5 h | ~3 h | Discovered the gateway parser was already discarding the `"8. currency"` field — fix was small but the symbol-convention doc + entropy script bug fix added scope. |
| #31 (Remove public surfaces) | 2 h | ~3 h | Deeper than expected — auth pages had fake-marketing sidebars that needed removal, not just the listed lines. Multiple specs needed updates after the route changed. |
| #34 (Brand Discovery v1) | 3 h | ~5 h | Three palette proposals + three logo concept prompts + final brand kit integration + Renata sub-agent + Gemini review (Modal/Dialog gap, ThemeToggle ARIA, etc.). Plus wordmark crop after merge. |
| **Total** | **21 h** | **~30 h** | **+43% over estimate.** Main overhead: Gemini PR review cycles, DoD-vs-reality reconciliations. |

**Calibration for Sprint 3:** PR-driven sprints cost ~1.5× the raw implementation estimate. For #28 (calculator refactor across 8 calculators), if the raw implementation is 8 h, plan for ~12 session-hours including review cycles.

---

## Registered decisions (link to ADRs if applicable)

No new ADRs written this sprint. Reinforced ADR-001 (descriptive language) via #31 and the brand kit phrasebook.

### Informal decisions (no ADR but registered for posterity)

- **FX-at-record-time pragmatic choice (#42).** Capture the current FX rate when the trade is *recorded*, not historical FX at `executed_at`. The `FxRate` schema only stores latest per pair; building historical FX storage (Banxico FIX series or time-series table) is deferred until beta usage demonstrates real need.
- **`Position.currency` deleted, delegated to `Asset.currency` (#43).** Source-of-truth simplification. Migration is reversible (`down` rebuilds the column and backfills from asset).
- **`MarketData::UseCases::SearchTickers` wrapper (#45).** Thin anti-corruption layer for the admin → MarketData boundary. Sets the precedent for the broader Trading↔MarketData boundary refactor in ADR-002 (Sprint 5).
- **Symbol convention: data-provider canonical (#45).** Stockerly stores the data provider's verbatim symbol — `.MX` suffix for BMV, plain for US, plain for crypto. Documented in [`docs/design/brand.md`](../../design/brand.md) (via the asset rules) and used by `Administration::SearchTicker`.
- **Lumen palette + Focal-frame logo (#34).** Decision record in [`docs/design/brand.md §11`](../../design/brand.md). Cipher and Bourse palettes considered + rejected; Geometric-monogram and Wordmark+Mark logo concepts considered + rejected.
- **Sprint metric: Claude session-hours, not calendar days.** Codified in [`.claude/memory/project_working_method.md`](../../../.claude/memory/project_working_method.md). Sprint 1 took ~10–12 h, Sprint 2 took ~30 h.
- **Repo-language English rule.** Carried forward from S1 retro and applied to all S2 artifacts (PRs, commits, docs). Brand kit's es-MX phrasebook is the explicit exception — it documents the *content* of UI copy that will appear in views, not the docs themselves.
- **`feedback_readable_code` memory rule added** during #34 work — minimal comments, self-explanatory code first.

### Candidate ADRs identified but NOT written (carried into future sprints)

- **ADR-002 — Trading + MarketData boundary** (blocks #33, formalized in S5). Pattern set in #45.
- **ADR-003 — Sync vs async event handlers** (S5).
- **ADR-004 — Notifications: BC vs library** (S5).
- **ADR-005 — Cross-BC event ownership** (S5).
- **ADR-006 — When NOT to use `ApplicationUseCase`** (blocks #38, S5).
- **ADR-007 — Administration BC or admin layer** (S5).

---

## Issues open at close

None. All 8 issues in the milestone are closed.

| # | Title | Disposition |
|---|---|---|
| #27 | [Epic] Multi-currency phase 1 | Closed manually after sub-issues completed. |
| #31 | Remove fake public surfaces | Merged via PR #53. |
| #34 | Brand Discovery v1 | Merged via PR #54. |
| #39 | Close abandoned designs | Closed as stale at sprint open (commit `2bc6515` already addressed). |
| #41 | S2-A Asset.currency | Merged via PR #46. |
| #42 | S2-B Trade.fx_rate_at_execution | Merged via PR #49. |
| #43 | S2-C Position USA-centric cleanup | Merged via PR #50. |
| #44 | S2-D Historical trades backfill rake | Merged via PR #51. |
| #45 | S2-E Admin ticker currency capture | Merged via PR #52. |

Two housekeeping PRs (#47 Claude workflows removal, #48 Dependabot consolidation) shipped mid-sprint and aren't tied to a milestone issue. Logged in `qa.md §additional notes`.

---

## Brutal quote of the sprint

> *"Sprint 2 captured truth at the data source. The dashboard still lies — but it now lies on top of correct data, which is the only kind of lie a calculator refactor can fix. Sprint 3's #28 turns honest data into honest numbers; without S2's foundation, that refactor would have been theatre."*
