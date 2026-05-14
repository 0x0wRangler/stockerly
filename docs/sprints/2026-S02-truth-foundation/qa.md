# QA Pass — Sprint S02 (truth-foundation)

> Pass completed 2026-05-14 before writing retro and closing the milestone.

---

## Goal & scope

- [x] **Sprint goal achieved.** *"Stockerly stops lying about currency — captured at the data source — and removes dishonest public surfaces."* Multi-currency phase 1 complete (Asset.currency, Trade.fx_rate_at_execution, ExecuteTrade currency-aware, historical backfill rake, admin ticker currency capture). Public surfaces with fake stats / testimonials / institutions removed. Calculator refactor (#28) is deferred to Sprint 3 by design — Sprint 2 was always the foundation, not the closure of dashboard-level truth.
- [x] **All `main` scope issues closed.** #41, #42, #43, #44, #45, #31 — all merged. Epic #27 closed manually after sub-issues completed.
- [x] **Parallel issues closed.** #34 (Brand Discovery) merged.
- [x] **Closed during opening.** #39 (close abandoned designs) closed as stale — already addressed by commit `2bc6515` before S2 opened.
- [x] **Unclosed issues:** none. Sprint 2 closes with 0 open issues in the milestone.

## Code health

- [x] `bundle exec rspec` — **2198 examples, 0 failures**, 94.51% line / 75.88% branch coverage.
- [x] `bin/rubocop` — **814 files inspected, 0 offenses.**
- [x] `bin/brakeman` — **0 security warnings.**
- [x] `bin/bundler-audit` — **No vulnerabilities found.**
- [x] CI on GitHub Actions green on every merged PR (#46, #47, #48, #49, #50, #51, #52, #53, #54).
- [x] Working tree clean after the wordmark crop commit. No forgotten changes.

## Vision compliance

- [x] **Manual audit of new copy.** Entropy script reports **1 ADR-001 violation** in views — `legal/risk_disclosure.html.erb:7` ("You should therefore carefully consider..."). False positive on the entropy regex; legitimate use of "You should" inside a legal risk disclaimer. Baseline before S2 was 8 violations; net real-violation count is now 0.
- [x] **Manual scope audit.** No new features violate non-goals. We *removed* features that did: public landing with fake social proof, public Trend Explorer, open_source page (all out per `docs/vision/non-goals.md` — "general public arriving via Google"). No fiscal additions. No prescriptive recommendations introduced.
- [x] **JTBD mapping.** Each merged issue references JTBDs or an ADR-driven cleanup:
  - #41, #42, #43, #44 → JTBD #1 (consolidated MXN), #2 (drawdown from MXN cost), #5 (trade capture)
  - #45 → JTBD #1 + ADR-002 candidate (Trading↔MarketData boundary)
  - #31 → Non-goal compliance + ADR-001
  - #34 → Brand foundation; enables JTBD-aligned visual migration in S3–S6
- [x] **Each issue's discovery card fulfilled.** DoD checklists from every issue were either completed or explicitly reconciled in the PR (notably #42 and #44 documented the FX-historical-data gap as a pragmatic Option A choice — documented in code comments + PR bodies).

## Documentation

- [x] **No new ADR** written. ADR-001 was *reinforced* through #31 (removed all flagged violations) and brand kit phrasebook. ADR-002 (Trading ↔ MarketData boundary) is still a Sprint 5 commitment per the Sprint 1 retro; #45 set the precedent without formalizing.
- [x] **No vision update** needed.
- [x] **Design docs created.** `docs/design/brand.md`, `tokens.md`, `components.md`, plus 3 logo SVGs. `docs/design/components.md` includes Renata's preliminary input as Appendix A (guidelines for S3+ implementation).
- [x] **Screenshots — N/A.** No visual changes shipped to `app/`. The visual migration is S3+; current views still render with pre-Lumen tokens.
- [x] **CLAUDE.md / docs/README.md / memory updated:** brand path consolidated to `docs/design/`; memory rules added (`feedback_readable_code.md`, `feedback_repo_language_english.md` carried forward; sprint metric switched from calendar to session-hours).

## GitHub hygiene

- [x] **Closed issues have terminal status.** All 8 issues closed via PR merge or explicit close-with-comment (#27 epic, #39 stale).
- [x] **Milestone ready to close.** 0 open issues, all sub-issues and parallel work done.
- [x] **No orphan issues.** Every issue in the milestone has a closed-by reference.

## Usage metric (post-close)

| JTBD | Expected metric | State |
|---|---|---|
| **#1 — Consolidated patrimony in MXN** | Adrian opens dashboard weekly and reads a number that reflects real MXN+USD exposure. | ⚠️ **Pending S3.** Data is now captured correctly (`Asset.currency`, `Trade.fx_rate_at_execution`), but the calculator refactor in #28 (S3) is required for the dashboard *number* to read correctly. Foundation in place. |
| **#2 — Drawdown from MXN cost basis** | Adrian gets an alert when a position drops X% from MXN-adjusted average cost. | ⚠️ **Pending S3.** Same as #1 — cost basis is correctly preserved per trade; calculator refactor (#28) computes the actual drawdown. |
| **#5 — Trade capture < 30 s** | Adrian records a trade end-to-end in under 30 s with correct currency + FX rate. | ⚠️ **Mechanically possible, UI pending.** `ExecuteTrade` now accepts the right inputs; the trade-entry view still uses pre-Lumen copy and lacks the explicit currency selector. Sprint 3 trade-entry work will close this. |
| **#6 — Notable observations** | Out of scope this sprint. | ❌ **Not yet applicable.** Scheduled for Sprint 4 (`#40`). |
| **Non-JTBD cleanup metrics** | Entropy script regression test. | ✅ **Measured.** ADR-001 violations 8→1 (false positive); hardcoded `"USD"` literals 11→8; total commits to master in S2: 13 PRs merged. |

---

## Additional notes

- The wordmark.svg viewBox was cropped post-#34 merge (commit `11564d7`) after a visual review on the rendered preview. Not strictly part of the sprint's scoped work but it's a brand asset that ships with the kit, and shipping with ~80 px of dead space would have been a small but real consistency violation.
- 2 housekeeping PRs (#47 remove Claude Code Review workflows, #48 consolidate Dependabot updates) were merged mid-sprint without being in the original scope. Both were surfaced by the work itself (Claude workflow failed on PR #46; 12 Dependabot PRs were noise). Logged here so they don't get lost from the sprint history.
- Renata Cifuentes (UX/UI expert from the panel) was invoked as a sub-agent during #34 for preliminary review. Pattern worth replicating in future design-heavy sprints — the input was complementary, not gatekeeping, and produced 6 hard findings worth flagging up front.
