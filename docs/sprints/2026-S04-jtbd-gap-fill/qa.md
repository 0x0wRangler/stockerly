# QA Pass — Sprint S04

> Mandatory checklist BEFORE writing `retro.md` and closing the sprint.
> If an item isn't met → either document why in `retro.md`, or the sprint does NOT close.

---

## Goal & scope

- [x] **Sprint goal achieved** — both JTBD #3 (CETES maturity) and JTBD #6 (Notable Observations) now have verifiable surfaces in product; ADR-002 written and #33 unblocked for S05. All 6 canonical JTBDs map to features in code.
- [x] **All `main` scope issues** closed — #29 (PR #61) + #40 (PR #62)
- [x] **Parallel issues** closed — #37 S04 slice (PR #63) + #59 ADR-002 draft (PR #60)
- [x] **No unclosed issues** at sprint boundary. #37 remains open by design (tracking issue spans S3-S6).

## Code health

- [x] `bundle exec rspec` green — **2174 examples, 0 failures**
- [x] `bin/rubocop` no offenses — 786 files inspected
- [x] `bin/brakeman` no new warnings — 0 errors, 0 security warnings
- [x] `bin/bundler-audit` no vulnerabilities
- [x] CI on GitHub Actions green (PRs #60, #61, #62, #63 all merged with green checks)
- [x] Working tree clean, no forgotten commits

## Vision compliance

- [x] **Manual audit of new copy** — no ADR-001 violations. Both #29 and #40 introduced new user-facing strings; both pinned by request specs with explicit imperative-verb regex guards:
  - `CETES_28D expires in 5 days` (#29) — descriptive
  - `AAPL entered oversold zone (RSI(14) below 30)` (#40) — descriptive
- [x] **Manual scope audit** — no non-goal violations. No fiscal computation, no public audience features, no investment recommendations. #29's maturity reminder describes the event; #40's observations describe technical state.
- [x] **JTBD mapping** — #29 → JTBD #3; #40 → JTBD #6; #37 S04 slice → architectural enabler (no JTBD by design, design-system axis); #59 → ADR (no JTBD by design).
- [x] **Each issue's discovery card** fulfilled. DoD deviations for #29 (asset_type `:fixed_income` vs `'cetes'`, handler home `Trading::UseCases` vs `Alerts::Handlers`) were logged in `log.md` 2026-05-15 before commit per S03 retro discipline.

## Documentation

- [x] **New ADR** written — ADR-002 (Trading↔MarketData boundary) committed as `docs/architecture/adr/0002-trading-marketdata-boundary.md`. Decision: customer/supplier pattern with formalized read API.
- [x] **Vision** unchanged — no audience or scope shift this sprint.
- [x] **Design docs** — `app/assets/tailwind/application.css` `@theme` gained `-fg` semantic tokens (success-fg / warning-fg / error-fg / info-fg) for WCAG AA contrast. Decision documented in PR #63 round-2 Gemini fix commit.
- [ ] **Screenshots regenerated** — deferred to S07 (beta-prep). Carry-over from S03 retro was opened, evaluated 2/2 sprints in a row, deferred 2/2 — the rule is not being followed. Retro flags it for removal.
- [x] **Memory** updated — cool-off rule dropped from `project_working_method.md` per the 2/2 override pattern (S2→S3 + S3→S4). Captured during S04 close.

## GitHub hygiene

- [x] **Closed issues** all show terminal state on GitHub (#29, #40, #59 CLOSED)
- [x] **Milestone ready to close** — all main scope + parallel scope issues in terminal state. #37 stays in milestone as a tracking-issue artifact spanning S3-S6 (S04 slice closed; S5/S6 slices remain).
- [x] **No orphan issues** in the sprint without a status

## Usage metric (post-close verification)

| JTBD | Expected metric | State |
|---|---|---|
| #3 — CETE maturity reminder | Adrian gets exactly 1 notification at 7d/3d/1d for each CETES held; reinvests or explicitly dismisses within 48h | ❌ not yet applicable (no live CETES position in dev seed; verifies once beta starts) |
| #6 — Notable technical observations | Adrian opens ≥1 asset detail per week from a surfaced observation; observations/week 2-8; dismiss rate <50% | ❌ not yet applicable (detector hasn't run on real data; verifies once daily job runs in S07 prep) |

Both metrics measure beta-cohort behavior. Pre-beta, code-correctness is the proxy: specs + manual smoke tests cover the path.

## Audit-entropy delta

| Metric | S03 close | S04 close | Direction |
|---|---|---|---|
| Cross-context leaks | 9 | 9 | Flat — S05 territory (#33 unblocked, lands there) |
| Hardcoded USD literals | 8 | 8 | Flat |
| ADR-001 violations | 1 | 1 | Flat — S06 territory (#36) |
| Bloated docs (>200 lines) | 12 | 12 | Flat — `components.md` still 821 lines, watchlist for S05 |
| TODO/FIXME markers | 2 | 2 | Flat |
| Hardcoded color classes | 194 | **160** | -34 ✅ (target was ≤170) |

The brand-migration axis is the only metric moving this sprint, which matches the scope (#37 S04 slice).

---

## Additional notes

- **a11y discovery**: PR #63 round 1 collapsed `text-X-700 dark:text-X-400` into a single `text-X`, which Gemini correctly flagged as failing WCAG AA (2.2:1 to 4.0:1 vs. required 4.5:1). Fix introduced `-fg` variant tokens to @theme. This is a brand-system precedent for S5/S6 slices — future migrations must use the `text-X-fg dark:text-X` pattern.
- **DoD-vs-reality reconciliations**: 2 logged in `log.md` 2026-05-15 (CETES asset_type; maturity handler home). Both were caught at sprint open via the code-state audit, before any code was written. The S03 retro action item ("code-state audit before commit") held up — 2 deviations surfaced and resolved with logged reasons, 0 mid-sprint surprises.
