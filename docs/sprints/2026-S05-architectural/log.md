# Log — Sprint S05 (architectural)

> NON-trivial notes during execution. **Not a daily journal.** Only what you'd want to remember when reviewing this sprint in 6 months.

---

## 2026-05-15 — Sprint opening (no cool-off rule per updated memory)

S04 closed earlier today. Per S04 retro decision (memorialized in `project_working_method.md`), sprint cadence is user-paced — no 24h cool-off default. Adrian requested opening S05 immediately. This time there's no "override" framing because the rule has been removed.

Estimate calibration changed mid-history: working_method memory now defines 1.2× / 1.3× / 1.5× multipliers (deletion / new-feature with pattern / greenfield). S05 is structural-refactor with patterns documented (ADR-002 drafted, SimpleUseCase has NotifyApproachingEarnings as precedent) → 1.3× applied.

---

## 2026-05-15 — Code-state audit at opening

Per S03 retro discipline. Findings for the three main-scope issues:

**#33 (ADR-002 implementation):**
- ✅ `Trading::UseCases::AssembleDashboard` still has all 4 cross-context model reads (lines 14, 16-22, 23, 25-32): `NewsArticle.recent`, `Asset.where(...)` for trending, `MarketIndex.major`, `MarketData::Domain::MarketSentiment.for_user`, `FearGreedReading.latest_*`.
- ✅ `Trading::Domain::FxRateResolver` (`fx_rate_resolver.rb:20`) still carries the "known leak" self-documenting comment — direct call to `MarketData::Gateways::FxRatesGateway.new`.
- ❌ `MarketData::Queries::*` namespace does NOT exist. New submodule + 4 query objects to create.
- ❌ CLAUDE.md "Cross-Context Communication" section still says "contexts communicate only via domain events" (unchanged from pre-ADR-002 state) — needs the customer/supplier nuance per ADR.

**#35 (zombie + ghost events):**
- ✅ All 5 ghost files still exist on disk: `trading/events/watchlist_item_added.rb`, `trading/events/position_opened.rb`, `trading/events/position_closed.rb`, `trading/events/portfolio_snapshot_taken.rb`, `alerts/events/alert_rule_created.rb`.
- Subscription file `config/initializers/event_subscriptions.rb` has 46 subscribe calls; 42 event class files exist. The "11 zombies + 4 ghosts" exact count from the discovery card pre-dates S03 deletions. **Recount required mid-sprint** — Phase 22 deletion + other S03 cleanups may have changed which events are zombies. Action: at #35 start, regenerate the zombie/ghost list from current state before deleting.

**#38 (SimpleUseCase + ADR-006):**
- ❌ ADR-006 does not exist (`docs/architecture/adr/0006-*.md`).
- ❌ `SimpleUseCase` base class does not exist.
- ✅ All 10 target use cases exist as listed in the discovery card. Spot-checked `Identity::UseCases::LoadProfile` and `Alerts::UseCases::ToggleRule` — both are 13-19 line scaffolds wrapping `update!` or `find_by` operations. Migration shape is what the audit predicted.
- ❌ `docs/architecture/conventions.md` does not exist; the DoD names it as a target file. Will be created with the SimpleUseCase doc.

**Zero blocking surprises.** All three issues' DoDs match the current code state at the surface I'll touch first. The #35 zombie-count recount is the only "verify mid-sprint" item.

---

## 2026-05-15 — S04 retro carry-overs that apply to S05

Per S04 retro's "What to change for the next sprint":

- [x] **Drop cool-off rule** — Already done in `project_working_method.md` memory before S05 open (commit `4655035`).
- [x] **Recalibrate multiplier** — Already done; 1.3× applied to S05 scope.
- [ ] **Add `db-query-counter` spec idiom** — Will land mid-sprint, likely when #33 touches AssembleDashboard (good test surface for N+1 detection).
- [ ] **Audit heatmap exception** — Resolves with the #37 S05 slice when picking the view to migrate.
- [ ] **Memorialize `-fg` token pattern** — Will land with the #37 S05 slice in `docs/design/tokens.md`.
