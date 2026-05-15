# QA Pass — Sprint S03 (jtbd-alignment)

> Mandatory checklist BEFORE writing `retro.md` and closing the sprint.
> If an item isn't met → either document why in `retro.md`, or the sprint does NOT close.

**QA pass date:** 2026-05-15

---

## Goal & scope

- [x] **Sprint goal achieved** — every feature in code maps to a canonical JTBD; ~25% of non-JTBD code deleted; calculators are honest for MXN+USD.
- [x] **All main scope issues closed:** #32, #30, #28 all closed via PR merges (#55, #56, #57).
- [x] **Parallel issue progressed:** #37 stays open as the multi-sprint tracking issue; its S3 slice landed via PR #58 (`_kpi_card` unification). Subsequent slices reassigned to S4 / S5 / S6.
- [x] **Unclosed issues decided:** #37 remains open under no milestone (tracking issue); a sub-issue for the S4 slice will be opened when that sprint opens.

## Code health

- [x] `bundle exec rspec` green — 2082 examples, 0 failures (down from 2149 pre-sprint; 67 specs removed alongside the deleted features in #30 + #32).
- [x] `bin/rubocop` clean — 768 files inspected, 0 offenses.
- [x] `bin/brakeman --no-pager` clean — 0 warnings.
- [x] `bin/bundler-audit` clean — no vulnerabilities.
- [x] CI on GitHub Actions green — all four merged PRs (#55, #56, #57, #58) passed before merge.
- [x] Working tree clean, no forgotten commits — only the memory-system update (`feedback_pr_review_workflow.md`) sits on master after the last merge, intentionally.

## Vision compliance

- [x] **Manual view-copy audit** — no new ADR-001 violations introduced. The lone remaining violation in `audit-entropy.sh` is the legal disclaimer string flagged by the false-positive `smart` keyword match.
- [x] **Manual scope audit** — no new features violate non-goals. The PR set is overwhelmingly deletion (#30 + #32 removed Phase 22 LLM + non-JTBD analytics) plus a refactor (#28) and a design-system slice (#37). Nothing new entered scope.
- [x] **JTBD mapping** —
  - #28 maps to JTBDs #1 (MXN consolidation), #2 (drawdown from MXN cost), #6 (notable observations need correct cost basis).
  - #30 + #32 are cleanup (no direct JTBD) but justified by the audit-driven principle "every line serves a JTBD or has an ADR".
  - #37 has no JTBD (design-system enabler), explicit in its discovery card.
- [x] **Each issue's discovery card DoD checklist** — fulfilled or documented:
  - #28: PortfolioSnapshot.currency column added, all 5 surviving calculators currency-aware, mixed MXN+USD fixtures + regression specs.
  - #30: All Phase 22 LLM files deleted (gateway, contracts, model, table, 4 user-facing surfaces, admin section, news-article sentiment columns).
  - #32: PortfolioRiskCalculator + TimeWeightedReturn + ConcentrationAnalyzer + sentiment alerts + concentration_risk alert all deleted; AlertRule enum cleaned + orphan-row migration.
  - #37: 2 components migrated (the S3 slice committed in the discovery card); audit-entropy.sh now tracks hardcoded color classes as the cross-sprint scoreboard.

## Documentation

- [x] **No new ADR needed** — all four PRs were within established architecture. ADR-002 (Trading↔MarketData boundary) stays in S5 scope; the per-PR notes about FxRate dependency are pragmatic and don't warrant a formal ADR yet.
- [x] **No vision update** — audience and scope unchanged.
- [x] **Design docs unchanged** — `docs/design/brand.md` and `docs/design/components.md` already document the tokens and KpiCard anatomy from S2 #34; this sprint consumed those specs, not extended them.
- [ ] **Screenshots regenerated** — NOT done. Visual changes are minor (the unified kpi_card, the gain pill colors via semantic tokens) and the existing `docs/screenshots/` directory doesn't have a kept reference set for the dashboard yet. Deferred — flagged for S4 if reviewer wants visuals.
- [x] **Memory updated** — `feedback_pr_review_workflow.md` added (PR-review loop codified after 3 invocations in this sprint).

## GitHub hygiene

- [x] **Closed issues have terminal state** — #28, #30, #32 closed. #37 intentionally open (tracking).
- [x] **Milestone ready to close** — all main-scope issues in terminal state.
- [x] **No orphan issues** — every issue assigned to S3 milestone either closed or is the tracking #37.

## Usage metric (post-close verification)

| JTBD | Expected metric | State |
|---|---|---|
| #1 — MXN-consolidated portfolio view | "Total Portfolio Value on /dashboard renders the same MXN total Adrian computes by hand from a CETES+AAPL mix" | ⚠️ pending — Adrian will exercise the post-merge dashboard in real use; cannot mark verified until first beta-invite session. |
| #2 — Honest gain/loss in MXN | "Day Gain pill on /dashboard reflects principal FX gain/loss (the regression test in spec/integration/multi_currency_portfolio_spec.rb is the codified version of this metric)" | ✅ verified — locked in by the "reports an FX-only loss when the asset price has not moved" spec, exactly the case Gemini flagged. |
| #6 — Notable observations need correct cost basis | "Weekly Insight on /dashboard uses base-currency snapshots, not mixed-currency totals" | ⚠️ pending — code is correct; need a user-session to confirm the insight text reads honestly for a CETES-heavy week. |

## Sprint metric snapshot (entropy)

```
                                Open S3   Close S3   Delta
Cross-context leaks (greps):       10        9        -1   (PortfoliosController stopped reaching into Alerts::UseCases::EvaluateConcentrationRules)
Hardcoded "USD" literals in app/:   8        8         0   (out of scope — S2 closed this axis at the data layer)
ADR-001 violations in views:        1        1         0   (false positive in legal disclaimer)
Bloated docs (>200 lines):         12       12         0   (docs trim is anti-pattern #4 watchlist for S4 retro)
TODO/FIXME/XXX markers:             2        2         0
Hardcoded color classes in views:  --      194         —   (new metric introduced this sprint; baseline for S4-S6 slices of #37)
```

The `hardcoded_color_classes_in_views` metric was added mid-sprint after Gemini's PR #58 review caught that the original `emerald|rose|amber|violet|blue` regex missed `red` (50 hits) and several smaller palettes. Real baseline is 194 once the regex was generalized.

## Additional notes

- **Two PRs needed Gemini-cycle fixes** (#57 with 5 issues, #58 with 4) — both were resolved in single follow-up commits per the PR review workflow. Net signal: Gemini reliably catches real issues; budget 1 review cycle per PR going forward.
- **Memory rule added mid-sprint** (`feedback_pr_review_workflow.md`) — codifies the Gemini review loop after Adrian explicitly invoked it three times.
- **Calendar-clock vs session-hour metric** holds up from S2 retro — this sprint also tracked session-hours as the duration metric (see retro for the calibration).
