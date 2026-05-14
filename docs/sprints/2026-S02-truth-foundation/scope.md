# Scope — Sprint S02 (truth-foundation)

> Issues assigned to this sprint. State-ful work lives in GitHub (Milestone + Project); here just the initial snapshot + brief reason per issue.

**Opened:** 2026-05-14
**Milestone:** [`2026-S02-truth-foundation`](https://github.com/rodacato/stockerly/milestone/1)

---

## Main work — multi-currency truth foundation (epic #27)

Multi-currency phase 1 was split from the original #27 into 5 sub-issues per Sprint 1 retro decision. #27 remains as the tracking epic. Calculator refactor (#28) is **deferred to Sprint 3**.

| # | Title | JTBD / ADR | Discovery card OK? |
|---|---|---|---|
| #41 | **S2-A**: Add `Asset.currency` column + country-based backfill | JTBD #1, #5 (foundation) | ✅ |
| #42 | **S2-B**: `Trade.fx_rate_at_execution` + ExecuteTrade currency-aware | JTBD #1, #2, #5 | ✅ |
| #43 | **S2-C**: Remove Position USA-centric scopes + derive currency from Asset | JTBD #1 cleanup | ✅ |
| #44 | **S2-D**: Historical trades `fx_rate_at_execution` backfill rake | Prepares #28 (S3) | ✅ |
| #45 | **S2-E**: Admin ticker creation captures currency + symbol convention doc | JTBD #1 + ADR-002 candidate | ✅ |
| #31 | Remove public surfaces with fake stats and prescriptive marketing | Non-goal compliance, ADR-001 | ✅ |

**Dependency order:**
```
#41 (S2-A) ──┬── #42 (S2-B) ── #44 (S2-D)
             ├── #43 (S2-C)
             └── #45 (S2-E)

#31 is independent (no dependency on currency chain)
```

## Parallel work (max 30% effort)

| # | Title | Parallel axis | Discovery card OK? |
|---|---|---|---|
| #34 | Brand Discovery: palette + theme + tokens v2 | Design system (enabler for S3-S6) | ✅ |

#34 produces docs-only output (`docs/design/brand.md`, `tokens.md`, `components.md`). Zero code changes in `app/` per its own DoD. This keeps the design axis alive without contending for the multi-currency work surface.

---

## Rules verified at opening

- [x] Each issue has a complete discovery card (no `discovery-needed` label)
- [x] Total `In Progress` issues ≤ 7 (hard rule) — 7 issues in scope, started incrementally
- [x] Parallel ≤ 30% of total estimated effort — #34 is ~1-2 days docs vs ~10-12 days main work; well under 30%
- [x] `GOAL.md` goal is covered by the selected issues
- [x] `blocked` issues have their dependency identified — none currently blocked (S2-A is the root; downstream issues will be `blocked` once work starts until S2-A closes)

## Closed during opening

- #39 — closed as already addressed by commit `2bc6515` (`designs/` folder eliminated)

## Deferred

- #28 (Multi-currency phase 2: calculator refactor) — moved to Sprint 3 per dependency on this sprint's schema work
