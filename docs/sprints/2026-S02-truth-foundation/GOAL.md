# Sprint Goal

> A single sentence. Non-negotiable during the sprint.
> If the goal needs to be revised mid-sprint, close this sprint early with retro and open a new one.

**Goal:** Stockerly stops lying about currency — captured at the data source — and removes dishonest public surfaces.

**Estimated effort:** ~20-25 Claude session-hours (calibrate in retro vs real)
**Calendar target:** 2026-05-14 → 2026-05-28 (orientativo, not a contract)
**Close trigger:** QA pass + retro, not the calendar date

**Sprint number / milestone:** S02 — `2026-S02-truth-foundation`

---

## Why this goal and not another

The Sprint 1 reset diagnosed two kinds of dishonesty in the codebase:

1. **Arithmetic dishonesty** — the entire portfolio core silently assumes single-currency USD. `Asset` has no `currency` column, `Trade.fx_rate_at_execution` doesn't exist, `Position#scope :domestic` is hardcoded to USD. For a Mexican investor with MXN+USD instruments, this is **mathematical fiction** at every dashboard number. Until the schema captures currency at the source, every calculator above it inherits the lie.

2. **Marketing dishonesty** — the public landing page invents institutions ("Trusted by GlobalBank/DataCore/..."), fabricates stats ("$4.2B Assets Tracked / 50K+ Active Traders"), and includes fake testimonials. For a project with a closed beta of ≤20 friends and no public traffic goal, this is **direct damage to credibility** — both to invited beta users and to anyone (recruiter, peer) viewing the GitHub repo.

Sprint 2 closes both lies at the foundation. It does **not** fix the 8 currency-naive calculators (#28 → Sprint 3) — that's the next layer up, dependent on what Sprint 2 lands. The sprint also runs Brand Discovery (#34) in parallel: a docs-only deliverable that produces the design tokens / palette / component catalog needed by Sprints 3-6 incremental visual migration.

This sprint unblocks:
- **JTBD #1** (Consolidated MXN patrimony) — structural prerequisite landed
- **JTBD #5** (Trade capture <30s) — trade capture stops persisting wrong currency data (the mechanic worked before, the data was lying)
- **JTBD #2** (Drawdown from MXN cost basis) — cost basis preserved with fx_rate at execution
- All future Sprint 3-6 visual work (Brand Discovery defines the target)

---

## What's NOT in this sprint (anti-scope)

- **Calculator refactor for multi-currency** (#28) — Sprint 3. The 8 calculators that lie mathematically. Blocked on this sprint's schema work landing first.
- **Removing the LLM layer** (Phase 22, 134 specs) — backlog, no canonical JTBD but not actively harmful.
- **Cross-context architectural cleanup** (Trading↔MarketData boundary, Administration BC dissolution) — Sprint 5. We only touch one micro-leak here (#45 / S2-E, admin ticker creation).
- **Visual implementation** — Sprint 3 onward, only after Brand Discovery (#34) closes.
- **CETES position-level `maturity_date` + JTBD #3 alerts** (P0.3 in audit, tracked as [#29](https://github.com/rodacato/stockerly/issues/29)) — Adrian has CETES in his portfolio but they auto-reinvest (no immediate value loss). Deferred to Sprint 4 (`2026-S04-jtbd-gap-fill`). **Not** silently dropped; conscious decision after weighing urgency 2026-05-14.
- **Multi-currency support beyond USD/MXN** — beta audience is MX-focused friends with MXN+USD instruments per [`docs/vision/audience.md`](../../vision/audience.md). Other currencies expand if the audience composition changes.
- **Invite system / beta onboarding flow** — Sprint 7.
