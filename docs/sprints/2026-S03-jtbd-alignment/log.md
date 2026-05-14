# Log — Sprint S03 (jtbd-alignment)

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

## 2026-05-14 — Sprint opening: hard rule "24h pause" skipped, recorded

Sprint 2 retro was committed at 22:17 UTC on 2026-05-14. Sprint 3 opening began ~30 min later in the same day (new conversation session, but well under the protocol's 24h cool-off window in `docs/sprints/README.md` §3).

**Decision:** Adrian explicitly chose to skip the rule and open S3 immediately. Recorded as a conscious deviation, not a slip. Rationale: the calculator refactor (#28) is the literal beta-blocker; postponing 24h adds calendar drag without information gain since the multi-currency context is fresh from S2.

**Risk acknowledged:** normalizing hard-rule skips erodes protocol utility. Mitigation: this is a one-time deviation, not a precedent. The 24h rule remains intact in `docs/sprints/README.md` and will be respected at the S3→S4 boundary unless the same explicit override is invoked.

This entry is the audit trail.

---

## 2026-05-14 — Code-state audit at opening (S2 retro change-list applied)

Per the S2 retro action item *"before assigning a sub-issue to a sprint, run a 5-min code-state audit alongside the discovery audit"*, audited all 4 issues against current code state. Findings:

**#28 (calculator refactor):**
- 7 calculators exist in `app/contexts/trading/domain/`: `concentration_analyzer`, `period_returns_calculator`, `portfolio_risk_calculator`, `portfolio_summary`, `time_weighted_return`, `upcoming_dividends_presenter`, `weekly_insight_calculator`. Discovery card says 8 — the extra is `PortfolioSummary` which the DoD doesn't list. Add it.
- `Portfolio` model has `total_value`, `total_unrealized_gain`, `allocation_by_sector`, `allocation_by_asset_type` as DoD describes.
- `PortfolioSnapshot` does NOT have a `currency` column. DoD anticipates this (*"add `currency` column or document convention"*). Action: add column + migration as part of #28.

**#30 (Phase 22 LLM deprecation):**
- `llm_gateway.rb` is at `app/contexts/market_data/gateways/`, not `app/contexts/market_data/domain/` as DoD states. Minor — DoD will follow actual path.
- Handler is `analyze_news_sentiment.rb`, not `analyze_news_sentiment_on_publish.rb`. DoD said "verify exact name" — verified.
- Table is `portfolio_insights`, not `ai_insights` as DoD speculated. DoD allowed both.
- 5 contracts exist (`health_check_response_contract`, `insight_response_contract`, `llm_response_contract`, `narrative_response_contract`, `sentiment_response_contract`) — all to delete.

**#32 (non-JTBD analytics archive):**
- All 3 calculator files exist (`portfolio_risk_calculator`, `time_weighted_return`, `concentration_analyzer`).
- `shared/domain/risk_metrics.rb` exists (used by `PortfolioRiskCalculator`).
- `AlertRule` enum has `sentiment_above: 5`, `sentiment_below: 6`, `concentration_risk: 8` — all to remove.
- Handler `evaluate_sentiment_alerts.rb` exists in Alerts context.

**#37 (semantic tokens migration):**
- Discovery card baseline (884 `text-slate-*`, 189 hardcoded `text-emerald/rose/amber/violet`) is stale. Real numbers today (2026-05-14, after S2's #31 + #34 lands): **827 `text-slate-*` + 144 hardcoded color classes**. Sprint 2 already moved the needle. Recording the new baseline here so S3 close has a clean delta.

**Audit-entropy.sh smoke-test (also from S2 retro action item):** ran fresh — current baseline at S3 open:
```
Cross-context leaks (greps):        10
Hardcoded "USD" literals in app/:   8
ADR-001 violations in views:        1
Bloated docs (>200 lines):          12
TODO/FIXME/XXX markers:             2
```
The "8 hardcoded USD literals" is the spot to watch as #28 lands — calculators that hardcode `"USD"` are the bug.

---

## 2026-05-14 — Execution order decision: #32 before #28

**Tension:** #28's DoD says refactor `PortfolioRiskCalculator`, `TimeWeightedReturn`, `ConcentrationAnalyzer` to be currency-aware. #32's DoD says **delete** the same three.

**Decision:** Execute #32 first. Then #28's scope shrinks from 7 calculators to 4 (`PortfolioSummary`, `WeeklyInsightCalculator`, `UpcomingDividendsPresenter`, `PeriodReturnsCalculator`) + `Portfolio` aggregates + `PortfolioSnapshot.currency` migration.

**Why:** explicitly anticipated in #28's discovery card notes (*"If P1 audit archives Risk Metrics / TWR / HHI, this issue reduces to only Portfolio aggregates + dividends presenter + weekly insight"*). Refactoring code we're about to delete is anti-pattern fuel — wasted PR cycles and Gemini-review overhead.

**Order:** #32 → #30 (independent) → #28 → #37 (parallel slice). #30 can run in parallel with #28 since they touch different bounded contexts (MarketData vs Trading).
