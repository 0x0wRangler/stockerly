# Sprint Goal

> A single sentence. Non-negotiable during the sprint.
> If the goal needs to be revised mid-sprint, close this sprint early with retro and open a new one.

**Goal:** Every feature in code maps to a canonical JTBD — calculators become honest for MXN+USD, and ~25% of non-JTBD code (Phase 22 LLM layer + Risk/TWR/HHI/sentiment alerts) is deleted.

**Sprint period:** 2026-05-14 → ~2026-05-16 (estimated ~25–30 session-hours per Sprint 2 calibration)

**Sprint number / milestone:** S03 — `2026-S03-jtbd-alignment`

---

## Why this goal and not another

Sprint 2 captured truth at the **data source** (Asset.currency, Trade.fx_rate_at_execution, Position cleanup, admin currency capture). The dashboard now lies *on top of correct data* — every calculator still sums MXN + USD as if they were the same number. Until #28 lands, the beta is **not invitable**: the first thing any friend will see is a wrong Total Portfolio Value. This is the literal beta-blocker tagged on issue #28.

Parallel to closing the multi-currency loop, Esther's scope audit identified ~13% of the codebase that serves no canonical JTBD: the entire Phase 22 LLM layer (~134 specs, built because "AI is the next wave") and the Risk/TWR/HHI quant-flavored analytics (~80–100 specs, built to "look pro"). Removing both in the same sprint sends a coherent product signal: **Stockerly observes, it doesn't predict; it serves a personal investor, not a portfolio manager.** Doing the deletion *before* refactoring (#32 → #28) means we don't waste effort making code multi-currency-aware that we're about to delete.

The parallel design work (#37) keeps the brand migration axis alive without absorbing main effort — limited to 2 core components per S2 retro discipline.

References: [JTBDs #1–#6](../../vision/jobs-to-be-done.md), [code audit 2026-05](../../research/code-audit-2026-05/diagnosis.md), [Sprint 2 retro](../2026-S02-truth-foundation/retro.md).

---

## What's NOT in this sprint (anti-scope)

- **No new features.** Pure refactor + deletion + parallel design migration. No JTBD #3 (CETES maturity) — that's S4. No JTBD #6 (Notable Observations surface) — that's S4.
- **No historical FX storage.** S2 explicitly deferred Banxico FIX time-series; the calculator refactor uses `FxRate.current` + per-trade `fx_rate_at_execution`. If the calculators need historical FX, document the gap and defer — do not expand scope here.
- **No ADR-002 (Trading ↔ MarketData boundary).** That's the architectural sprint (S5). The `MarketData::UseCases::SearchTickers` precedent set in S2 is enough for now.
- **No full brand migration.** Only 2 core components in #37 (likely `_stat_card` + `_admin_kpi_card` → unified `_kpi_card`). The rest stays for S4/S5/S6.
- **No `PortfolioSnapshot` time-series multi-currency rewrite.** If snapshots need a currency column, add it as a thin migration (column + default = user base currency) — do not redesign the snapshot strategy.
- **No prescriptive copy rewrite.** That's S6 (#36 — "Strong/Parabolic" → score buckets, "Upside/Downside" → Target Δ%).
- **No screenshot regeneration as a goal in itself.** Regenerate only views that visibly changed.
