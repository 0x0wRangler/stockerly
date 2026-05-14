# Scope — Sprint S03 (jtbd-alignment)

> Issues assigned to this sprint. State-ful work lives in GitHub (Milestone + Project); here just the initial snapshot + brief reason per issue.

---

## Main work

| # | Title | JTBD / ADR | Discovery card OK? |
|---|---|---|---|
| **#32** | [P1] Archive non-JTBD advanced analytics (Risk, TWR, HHI, sentiment alerts) | Cleanup — no JTBD (justification: every code line must serve a JTBD or have an ADR) | ✅ |
| **#30** | [P1] Deprecate Phase 22 LLM intelligence layer (~134 specs) | Cleanup — no JTBD (justification: same; Phase 22 was anti-pattern #1 "next phase = next thing to build") | ✅ |
| **#28** | [P0] Multi-currency phase 2: refactor calculators currency-aware | JTBD #1 (consolidated MXN), #2 (drawdown from MXN cost), #6 (notable observations need correct cost basis) | ✅ (PortfolioSnapshot.currency column needed — DoD anticipates it) |

## Parallel work (max 30% effort)

| # | Title | Parallel axis | Discovery card OK? |
|---|---|---|---|
| **#37** | [refactor] Adopt semantic color tokens from @theme (migration parallel S3-S6) | Design system (brand migration) | ✅ (baseline numbers stale: real is 827 `text-slate-*` + 144 hardcoded color classes, not the 884/189 from discovery — log.md records refreshed baseline) |

S3 slice of #37: migrate 2 core components only (likely `_stat_card` + `_admin_kpi_card` → unified `_kpi_card` with variants). Per Sprint 2 retro (Renata's Appendix A): incorporate the KpiCard stale/partial states finding.

---

## Execution order (decided at opening — see log.md 2026-05-14)

1. **#32 first** (delete Risk/TWR/HHI/sentiment-alerts) — shrinks #28's surface.
2. **#30** (delete Phase 22 LLM layer) — independent of #28/#32, can also run after #32 or in parallel sub-agent style.
3. **#28** (refactor surviving calculators currency-aware) — reduced scope: `Portfolio` aggregates + `WeeklyInsightCalculator` + `UpcomingDividendsPresenter` + `PeriodReturnsCalculator` + `PortfolioSummary` + `PortfolioSnapshot.currency` migration. `PortfolioRiskCalculator` / `TimeWeightedReturn` / `ConcentrationAnalyzer` are deleted in #32, not refactored.
4. **#37** (S3 slice) — runs alongside main work, 2 components.

---

## Estimated effort

| # | Estimate (session-hours, raw) | × 1.5 Gemini factor (per S2 retro) | Notes |
|---|---|---|---|
| #32 | 4 h | 6 h | File deletes + spec deletes + AlertRule enum cleanup + view cleanup |
| #30 | 5 h | 7.5 h | ~134 specs to remove + migration drop_table + admin panel cleanup |
| #28 | 6 h (reduced from 10 h after #32) | 9 h | Portfolio aggregates + 4 surviving calculators + PortfolioSnapshot.currency migration + mixed-currency fixtures |
| #37 (S3 slice) | 2 h | 3 h | 2 components + audit script run |
| **Total** | **17 h raw** | **~25.5 h** | Inside the 25–30 h calibration band |

Parallel effort (#37) = 3h / 25.5h ≈ **12% ≤ 30%** ✅

---

## Rules verified at opening

- [x] Each issue has a complete discovery card (no `discovery-needed` label) — all 4 verified with `ready` label
- [x] Total `In Progress` issues ≤ 7 (hard rule) — will open ≤ 2 at a time
- [x] Parallel ≤ 30% of total estimated effort — 12%, well within
- [x] `GOAL.md` goal is covered by the selected issues
- [x] `blocked` issues have their dependency identified — none labeled `blocked`
- [x] Code-state audit completed at opening (S2 retro change-list) — see log.md for findings
