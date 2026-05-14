# Log — Sprint S02 (truth-foundation)

> NON-trivial notes during execution. **Not a daily journal.** Only what you'd want to remember when reviewing this sprint in 6 months.
>
> What goes here:
> - Mid-sprint decisions (non-trivial)
> - Experts consulted and what they said
> - Problems discovered that weren't in discovery
> - New issues opened during the sprint and why
> - Scope changes (with reason)
>
> What does NOT go here:
> - "I did commit X today"
> - List of commits (that's already in `git log`)
> - Implementation details (those live in the code)

---

## 2026-05-14 — Sprint opening: #27 split into 5 sub-issues

Sprint 1 retro mandated splitting the original #27 P0 (multi-currency phase 1). Discovery on opening revealed:

1. **`Asset` already has a `country` column.** Audit recommendation was symbol-pattern backfill (`CETES_*` → MXN, etc.). DB inspection showed the cleaner rule is country-based. Backfill now: `country = 'MX' OR asset_type = fixed_income OR symbol LIKE 'CETE%' OR symbol = 'IPC'` → MXN; `country IN ('US', 'USA') OR asset_type = crypto OR symbol IN ('VIX','SPX','NDX','DJI','UKX')` → USD. Cleaner, scales naturally when admin creates new MX assets.

2. **Symbol convention question surfaced.** Adrian initially said "símbolo plano", but seeds actually use `.MX` suffix (`GENIUSSACV.MX`, `IVVPESO.MX`). After confirming, the canonical rule is: **use the data provider's verbatim symbol** (`.MX` for BMV per Yahoo/Alpha Vantage convention, plain for US/crypto). Not a personal convention — industry standard. Documented in #45 / S2-E.

3. **Sub-issue split (5 instead of original 2):**
   - #41 — S2-A: Asset.currency + backfill (foundation)
   - #42 — S2-B: Trade.fx_rate_at_execution + ExecuteTrade
   - #43 — S2-C: Position scopes + currency derivation
   - #44 — S2-D: Historical trades backfill rake
   - #45 — S2-E: Admin ticker creation captures currency

Original #27 reshaped as **tracking epic** with checklist linking to #41-#45.

## 2026-05-14 — #39 closed as stale

The "close abandoned designs" issue was made obsolete by commit `2bc6515` (already deleted the `designs/` folder). Closed during sprint opening with explanatory comment. Frees a scope slot, doesn't change the goal.

## 2026-05-14 — Scope confirmed; Sprint 2 opened formally

Final scope: 6 issues (5 sub-issues of #27 + #31). Parallel: #34. Epic #27 tracks. #28 deferred to S3. Brand Discovery is docs-only so it doesn't fight for code surface with the multi-currency work.

## 2026-05-14 — Entropy baseline captured

`script/audit-entropy.sh` created and run at sprint opening. Baseline:

| Metric | Baseline (S2 open) | Target (S2 close) |
|---|---|---|
| Cross-context leaks (grep) | 33 | -1 (#45) |
| Hardcoded "USD" in app/ | 11 | ~0 (after #41+#42+#43) |
| ADR-001 violations in views | 8 | ~0 (after #31) |
| Bloated docs (>200 lines) | 10 | unchanged (most are `docs/archive/`; `docs/research/experts.md` watched) |
| TODO/FIXME markers | 2 | ≤2 |

The grep-based metrics are directional, not literal. False positives expected; trend matters more than absolute number.
