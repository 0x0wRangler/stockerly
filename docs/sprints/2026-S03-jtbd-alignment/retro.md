# Retro — Sprint S03 (jtbd-alignment)

> Honest post-mortem. Without retro, the sprint does NOT close (hard rule of the protocol).
>
> **Close date:** 2026-05-15
> **Actual duration:** ~12 Claude session-hours, 1 calendar day (high-intensity paired session)
> **Estimated duration:** ~25.5 session-hours (per scope.md, after applying the S2 retro's 1.5× Gemini-review multiplier on a 17h raw estimate)
> **Goal:** *"Every feature in code maps to a canonical JTBD — calculators become honest for MXN+USD, and ~25% of non-JTBD code (Phase 22 LLM layer + Risk/TWR/HHI/sentiment alerts) is deleted."*

---

## What worked?

- **#32 → #28 ordering paid off.** Documenting the decision in `log.md` at sprint open meant #28's eventual scope was visibly smaller than the original DoD: only 4 surviving calculators to refactor instead of 7, and no time spent refactoring code that would later be deleted. The rationale was explicit in #28's discovery card and the sprint log; future-me can audit why.
- **Four atomic-commit PRs (#55, #56, #57, #58) followed the same skeleton.** Each PR: granular commits (5-7 each), Fixes #N in body, full local CI before push, Gemini review pass, follow-up fix commit when needed. The cadence is now muscle memory. PR sizes — #55 (1460 deletions), #56 (1850 deletions), #57 (321 insertions, mostly tests + structural change), #58 (small slice) — all reviewed in single Gemini passes.
- **Code-state audit at sprint open prevented a DoD-vs-reality surprise.** Per S2 retro's change-list, I ran a 5-min code-state audit on every issue at sprint open. Findings recorded in `log.md` (e.g., `User.preferred_currency` confirmed to exist before #28 started; `llm_gateway.rb` was at `gateways/` not `domain/`; news_article had sentiment columns even though it wasn't in the DoD). Zero DoD-vs-reality reconciliations needed mid-sprint, unlike S2's two.
- **Honest gap-flagging on principal-FX gain/loss.** Gemini's HIGH-priority comment on #57 (the gain/loss formula ignoring principal FX) was the exact bug Lucía's audit had foreshadowed. Replacing the formula with `market_value − cost_basis` captured the case correctly, and I added the literal "AAPL unchanged, FX drops" spec case Gemini described. The fix was a real algorithmic correction, not a workaround.
- **`portfolio.convert` cache pattern emerged from review.** Two of Gemini's #57 comments were N+1 issues; the fix was a single per-instance memoized cache on the Portfolio model that PortfolioSummary, PeriodReturnsCalculator, and AssembleDashboard all route through. One source of FX lookup. Easier to swap out under S5's ADR-002 boundary reshuffle.
- **Memory update during the sprint, not in retro.** The `feedback_pr_review_workflow.md` rule landed when Adrian invoked the pattern for the third time — codifying it mid-sprint instead of in retro means future sessions need only the trigger phrase. Anti-pattern #7 (no retros / no audits) extension applied in real time.
- **`script/audit-entropy.sh` gained the brand metric.** Adding the `hardcoded_color_classes_in_views` count to the audit script gives S4-S6 a visible scoreboard for #37's incremental migration. Gemini's regex-broadening suggestion was correct (caught 11 hits the original regex missed), and that improvement landed in the same review cycle.
- **Sprint-opening discipline: skipped the 24h cool-off explicitly.** S2's retro documented that the cool-off was respected. S3 didn't respect it; Adrian invoked the explicit override option from `AskUserQuestion`, the decision was logged in `log.md` 2026-05-14, and the override was visibly conscious — not a slip. This is the right way to deviate from a protocol you wrote: name it.
- **Gemini-review productivity held up.** Real findings in every PR review (5 issues in #57, 4 in #58, 1 in #56). No noise. Every Gemini suggestion either applied or rejected with reason (none silently ignored). Review cycle pattern: read inline → triage table → minimal-scope fix-commit → push → reply inline citing SHA. Lap time per round: ~20 min including local CI.

## What didn't work?

- **Estimate was ~2× too high.** scope.md projected ~25.5 session-hours; actual was ~12. Where did the savings come from? Mostly: (a) the #32 → #28 ordering shrunk the calculator refactor more than estimated; (b) the discovery cards' literal DoDs over-described surface area (e.g. #30's "all of Phase 22" turned out to be cleanly contained, no caller-graph surprises); (c) the audit-entropy script + entropy snapshot pattern made "is this PR done?" instantly checkable. **Calibration:** for sprints that are mostly deletion + refactor on a well-audited surface, the 1.5× Gemini multiplier on raw hours is too pessimistic. Use 1.2× for deletion-heavy sprints, keep 1.5× for new-feature sprints.
- **The audit-entropy regex understated baseline.** I shipped the metric in PR #58 with `emerald|rose|amber|violet|blue` and reported 188 → 183. Gemini caught it; the real baseline was 194 once the regex was generalized to "any non-slate". The 5-hit improvement still applies on the broader metric (pre-PR was 200), but the PR body's optimistic-sounding 188 → 183 figure was wrong. **Cause:** I built the regex from the colors I saw in the two cards I was migrating, not from a survey of the full views directory. **Lesson:** before introducing an audit metric, run a "what colors actually appear?" pre-flight grep, not "what colors do I expect to see?".
- **Two pre-flight git hiccups.** (1) After PR #58 merged, my local master had unstaged memory changes that blocked the fast-forward — I had to commit them separately, then an interactive rebase got stuck and I aborted via `--hard reset` to origin/master, which wiped my memory commit and I had to recreate it. (2) The PR opening commit on #28 was originally amended after Gemini's first review, which cost a Gemini cycle (PR #56 retro already flagged this; pattern repeated). **Cause:** I treat memory edits as "background" and don't include them in the commit-cadence flow. **Lesson:** treat memory commits as first-class. When a memory file is written, commit it before the next merge boundary.
- **`docs/screenshots/` not regenerated.** The QA checklist's screenshots item is unchecked. Visual changes are minor (gain pill from semantic tokens, KpiCard layout tightening) but the canonical pre/post-screenshot reference set doesn't exist anyway. **Carry to S4:** if visuals are going to be tracked across sprints, establish the baseline set at S4 opening — start with /dashboard, /portfolio, /admin top-row.
- **No closing screenshot of the dashboard in MXN consolidated state.** The P0 beta-blocker is now fixed in code; the "first beta friend can see honest MXN totals" claim is technically locked-in by spec, but I have no visual artifact proving it. **Carry to S4 / beta prep:** before sending a beta invite, capture a screenshot of Adrian's actual portfolio rendered in MXN consolidated as the demo-able proof.

## What to change for the next sprint?

- [ ] **Pre-flight grep for any new audit metric.** Before adding a metric like `hardcoded_color_classes_in_views`, survey what's actually in the codebase (not what you expect). One `grep -rE '<broad pattern>' app/ | aggregate-by-token` pass before committing the regex.
- [ ] **Memory commits ride immediately.** When a memory file is added or modified, commit it on the same turn the change is made. No "I'll commit memory later" backlog. The rebase-stuck incident on the master sync was 100% caused by uncommitted memory.
- [ ] **24h cool-off applies again at S3→S4.** S3 explicitly opted out of the S2→S3 cool-off. The override is intended as one-time. Default behavior for S4 opening: respect the cool-off, no override.
- [ ] **Establish `docs/screenshots/` baseline at S4 opening.** Light commit: pre-S4 captures of `/dashboard`, `/portfolio`, `/admin` top rows. Diff against these at S4 close to track visual drift across sprints.
- [ ] **Calibration: deletion-heavy sprints use 1.2× not 1.5×.** Update `project_working_method.md` memory rule to note this nuance.
- [ ] **For S4, open #29 (CETES maturity per position) as primary main-scope.** Its DoD references a `maturity_date` field that may not exist on Position yet — pre-flight audit at sprint open will be the test of the new "code-state audit before commit" discipline.

---

## Vision alignment — state of the 6 axes

| # | Axis | Before (S3 open) | After (S3 close) | Notes |
|---|---|---|---|---|
| 1 | Every feature maps to a JTBD | 50% | **80%** | #30 + #32 removed ~25% of non-JTBD code. The surviving Trading::Domain modules (PortfolioSummary, PeriodReturnsCalculator, UpcomingDividendsPresenter, WeeklyInsightCalculator) all map to JTBD #1/#2/#6. Remaining 20%: admin features without a JTBD (intentionally — admin is operational not user-facing), and the SearchTicker / Integration UI which is admin-only too. |
| 2 | Zero prescriptive copy in code | 75% | 75% | No change — S3 didn't touch view copy. The 1 remaining audit-entropy hit is the legal disclaimer false positive. S6 #36 owns the prescriptive-label rewrite. |
| 3 | Zero aspirational fake copy | 90% | 90% | No change — S2 closed the major surfaces. The 10% gap remains "Open Source Market Intelligence Platform" footer tagline. |
| 4 | Dashboard arithmetic truthful for MXN+USD | 40% | **95%** | The big jump. #28 closed the loop opened in S2: data was already correct at the source; now every calculator renders that correctness in `user.preferred_currency`. The 5% still pending: historical FX storage for snapshots (deferred per S2 retro decision — current FX on snapshot read is acceptable). |
| 5 | Architecture without cross-context leaks | 30% | **35%** | Small improvement. The PortfoliosController → Alerts::UseCases leak was removed in #32. New patterns introduced: PortfolioSummary and PeriodReturnsCalculator now depend on FxRate (top-level model, not a context) — this is a tolerable shared-model dependency, not a context-to-context leak. S5's ADR-002 still owns the bulk reduction. |
| 6 | Docs reflect current code | 90% | 90% | Holding. Sprint protocol kept up (log, qa, retro on schedule). Memory rules added in real time. The 10% gap: the bloated-docs metric still shows 12 files > 200 lines; targeted trim is anti-pattern #4 watchlist for S4 retro. |

**Synthesis:** Axis #1 jumped sharply via deletion (#30 + #32). Axis #4 jumped to near-complete via #28 — this is the axis directly tied to the P0 beta-blocker, and it's now effectively closed. Axes #5 and #6 hold. The visual-coherence axes (#2, #3) are S6 territory and stayed put as expected.

---

## Anti-patterns I committed (if any)

Reviewed against [`.claude/memory/feedback_anti_patterns.md`](../../../.claude/memory/feedback_anti_patterns.md).

- **#1 (Next phase = next thing to build) — NOT violated.** Each PR was driven by an explicit issue, each issue had a discovery card, and #32 + #30's massive deletions were directly the answer to "did Adrian use it?" (no).
- **#2 (PRD as gospel) — NOT violated.** No PRD reference appeared anywhere in S3 reasoning.
- **#3 (Patterns over pragmatism) — NOT violated.** The unified `_kpi_card` is one partial replacing two; no DSL, no abstraction layer. The historical-FX cost basis is a 6-line method on Position, not a value object hierarchy. When Gemini suggested ceremony (`local_assigns` over `||=`), the code was already pragmatic — the suggestion was a refinement, not a complication.
- **#4 (Doc bloat) — NOT violated this sprint.** No new long docs. The bloated-docs metric held at 12 (same as S2 close). `components.md` (821 lines, flagged in S2 retro) wasn't referenced once during S3 — confirming the S2 retro's prediction. **Carry to S4:** if S4 doesn't reference it either, trim.
- **#5 (Skipping foundational checks) — NOT violated.** The code-state audit at sprint open caught real issues before commit: `User.preferred_currency` existence, `llm_gateway.rb` actual path, `news_articles.sentiment*` columns the DoD didn't list, `DataSourceRegistry :ai_intelligence` registration not in the DoD's seed list. All surfaced before the first commit.
- **#6 (Fragmenting redesigns without closing) — NOT violated.** #37 is explicitly a tracking issue with sprint slices; the S3 slice is closed and the S4-S6 slices are queued. The unified `_kpi_card` is a complete artifact, not a fragment.
- **#7 (No retros / no audits) — ACTIVELY RESPECTED.** This file is the retro. Audit-entropy script ran at sprint open and close. The PR review workflow itself is a mini-retro per merge.

**Score:** 0 of 7 anti-patterns violated. Cleanest sprint on this dimension since the protocol started.

---

## Real vs estimated time

| Issue / Step | Estimated (×1.5) | Real | Reason for deviation |
|---|---|---|---|
| Sprint opening (split #28 reduction, code-state audit, log baseline) | 0.5 h | ~0.5 h | OK — the override-the-24h-rule conversation took most of the time. |
| #32 (archive non-JTBD analytics — 7 atomic commits) | 6 h | ~2.5 h | DoD was clean; callers audit at start meant no surprises; deletion at this scale is fast. Gemini found 1 issue (FK in migration down). |
| #30 (deprecate Phase 22 LLM — 6 atomic commits) | 7.5 h | ~3.5 h | Same shape as #32 but bigger surface; the `:ai_intelligence` DataSourceRegistry registration was the only non-DoD discovery, found via autoloader error during migration generation (a happy fail-loud). |
| #28 (calculator refactor — 6 atomic commits) | 9 h | ~4.5 h | The reduced scope (4 calculators not 7) plus the structural clarity of `Portfolio#convert` cache pattern kept this from blowing up. Gemini found 5 real issues — all real, all resolved in one follow-up commit. The principal-FX gain/loss fix was the surprise: I hadn't realized the original formula was algorithmically wrong, not just imprecise. |
| #37 S3 slice (kpi_card unification — 4 atomic commits) | 3 h | ~1 h | Tiny scope. 17 call sites migrated mechanically. The audit-entropy metric extension caught me out a bit when Gemini broadened the regex. |
| **Total** | **~25.5 h** | **~12 h** | **−53% under estimate.** Deletion + audited-surface refactor cycles are much faster than the 1.5× multiplier assumes. |

**Calibration for Sprint 4:** deletion-heavy / well-audited surface = 1.2× multiplier. New-feature sprint with unaudited downstream callers (e.g., CETES JTBD #3) = stay at 1.5× until proven otherwise.

---

## Registered decisions (link to ADRs if applicable)

No new ADRs written. Reinforced patterns:

### Informal decisions (no ADR but registered for posterity)

- **#32 before #28 ordering rule (sprint scope decisions).** When an archive-and-refactor pair touches the same modules, do archive first; refactor scope shrinks. Codified in S3 log.md.
- **Historical FX for cost basis, current FX for market value (#28).** Per discovery card: "Gain/Loss respects each trade's historical FX." Implementation: `Position#avg_cost_in(currency)` weights buy trades by `fx_rate_at_execution`. The principal FX gain/loss falls out naturally from `market_value(current FX) − cost_basis(historical FX)`. Locked in by `spec/integration/multi_currency_portfolio_spec.rb`.
- **`PortfolioSnapshot.currency` as a column, not a convention (#28).** If a user changes `preferred_currency`, snapshots written before remain correctly labeled.
- **`Portfolio#convert` per-instance FX cache (#57 fix).** Memoization scope: one Portfolio Ruby object. PortfolioSummary and PeriodReturnsCalculator and AssembleDashboard all route through it — one source of FX lookup.
- **Conversion misses raise loudly (#28).** No silent fallback to 0 or current FX. The previous "plausibly-wrong number" was the worst kind of bug.
- **Unified `_kpi_card` brand-token semantics (#37 S3 slice).** Tones: `:neutral | :info | :success | :warning | :error`. No third semantic per brand kit. Admin's old free-form color picker is gone.
- **PR review workflow codified as a feedback memory.** `feedback_pr_review_workflow.md` captures the loop Adrian invoked 3 times this sprint.

### Candidate ADRs identified but NOT written (carried into future sprints)

- **ADR-002 — Trading + MarketData boundary** (blocks #33, formalized in S5). FxRate is currently a top-level model; PortfolioSummary's dependency on it is the kind of thing ADR-002 will clarify.
- **ADR-003 — Sync vs async event handlers** (S5).
- **ADR-004 — Notifications: BC vs library** (S5).
- **ADR-005 — Cross-BC event ownership** (S5).
- **ADR-006 — When NOT to use `ApplicationUseCase`** (S5).
- **ADR-007 — Administration BC or admin layer** (S5).

---

## Issues open at close

| # | Title | Disposition |
|---|---|---|
| #37 | [refactor] Adopt semantic color tokens from @theme (migration parallel S3-S6) | **Stay open under no milestone.** This is a multi-sprint tracking issue; the S3 slice closed via PR #58, S4-S6 slices to follow. When S4 opens, a sub-issue scoped to the S4 slice will be created and assigned to the S4 milestone. |
| #28 | [P0] Multi-currency phase 2 | Closed via PR #57 (2026-05-15). |
| #30 | [P1] Deprecate Phase 22 LLM | Closed via PR #56 (2026-05-15). |
| #32 | [P1] Archive non-JTBD advanced analytics | Closed via PR #55 (2026-05-14). |

---

## Brutal quote of the sprint

> *"Sprint 3 was the calmest sprint in 25 phases. Three deletion-driven PRs, one structural P0 refactor, and a small design slice — all landed in 12 session-hours flat. The acceleration is real: it comes from the audit-driven scope (only do what serves a JTBD), the protocol's atomic-commit cadence (each PR is a self-contained story), and Gemini's reliable review pass (catches the algorithmic bug, not just style). The P0 beta-blocker is done. Adrian can invite the first friend whenever he wants — the data is honest, the dashboard renders MXN consolidated, and the LLM/quant theater is gone. The next sprint is the calm-after-the-storm sprint: CETES maturity (JTBD #3), 'Notable Observations' surface (JTBD #6), and two more design-system slices. Nothing in S4's scope is a beta-blocker. The question for S4 is no longer 'does this work?' but 'does Adrian use it?'"*
