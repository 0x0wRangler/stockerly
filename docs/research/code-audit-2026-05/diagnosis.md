# Code Audit — Categorized Diagnosis

> **Date:** 2026-05-14
> **Source:** Synthesis of 4 sub-agents (Hiroto/Lucía/Renata/Esther) plus cross-check with paths and lines.
> **Companion:** [`inventory.md`](./inventory.md) has the raw numbers. This file categorizes the findings by severity.

---

## 🔴 P0 — Beta blockers

They block honestly inviting the first friend.

### P0.1 — Multi-currency structural (not 2 lines)

The known P0 (`currency: "USD"` hardcoded in `execute_trade.rb:39,60`) is only the tip of the iceberg. **The entire arithmetic core of the portfolio assumes single-currency USD.**

**Affected sites:**

- `app/contexts/trading/use_cases/execute_trade.rb:39,60` — hardcoded `currency: "USD"` in two `create!` calls.
- `app/contexts/trading/contracts/execute_trade_contract.rb:1-26` — the contract **does not accept `currency` or `fx_rate_at_execution`** as input. Adrian literally cannot record a trade in MXN even if he wanted to.
- `app/models/position.rb:11-12` — `scope :domestic, -> { where(currency: "USD") }` and `:international` for `!= USD`. **USA-centric mentality hardcoded in the model** (Adrian is in Mexico: domestic for him = MXN).
- `db/schema.rb` — `"USD"` defaults on `positions.currency`, `trades.currency`, `dividends.currency`, `financial_statements.currency`, `users.preferred_currency`. The default drags USD into every new record.
- **`Asset` has NO `currency` column** — the instrument's native currency is implicit (no source of truth). CETES is MXN by symbol convention `CETES_*D`; AAPL is USD by assumption.
- **`Trade.fx_rate_at_execution`, `Position.cost_basis_mxn`, and `Position.cost_basis_usd` do not exist**. When Adrian buys AAPL via a Mexican broker in MXN, there's no way to capture that day's FX.
- `db/schema.rb` `portfolio_snapshots.total_value` and `invested_value` are `decimal` without a `currency` column — if tomorrow the report changes to MXN, historical snapshots become ambiguous.

**Idle infrastructure:** `app/models/fx_rate.rb` with `FxRate.convert` and `FxRatesGateway` exist, but `FxRate.convert` **is never invoked from domain code**. Data exists; no wiring.

**Mapping to JTBDs:** blocks #1 (Consolidated patrimony MXN) and #2 (Drawdown from MXN cost), weakens #5 (Trade capture — cannot capture correctly).

---

### P0.2 — Currency-naive calculators

8 calculators **lie mathematically** for a mixed MXN+USD portfolio:

| File | Sin | Consequence |
|---|---|---|
| `app/models/portfolio.rb:17-19` | `total_value` sums `shares * current_price` without conversion | Adds Mexican pesos of CETES with NYSE dollars as if they were the same currency. **The dashboard number is mathematically meaningless.** |
| `app/models/portfolio.rb:21-23` | `total_unrealized_gain` same root | Global P&L is arithmetic fiction |
| `app/models/portfolio.rb:25-37` | `allocation_by_sector`, `allocation_by_asset_type` group SQL `SUM(shares * current_price)` without FX | Allocation pies lie when mixed |
| `app/contexts/trading/domain/concentration_analyzer.rb:9-14` | HHI computed over `value = shares * current_price` without normalization | Reports nonexistent concentration: 1M MXN in CETES (~50K USD) vs 50K USD in AAPL — HHI says 99% in CETES because the number magnitudes are ~17x bigger |
| `app/contexts/trading/domain/portfolio_risk_calculator.rb:40-65` | Volatility, Sharpe, drawdown over `total_value.to_f` of snapshots | If snapshots mix currencies, the volatility includes **FX rate noise**, not portfolio volatility. Sharpe falsely high/low |
| `app/contexts/trading/domain/time_weighted_return.rb:46-56` | TWR over mixed `total_value` | Same problem. Cash flows also ignore currency |
| `app/contexts/trading/domain/period_returns_calculator.rb:18,56-58` | 1D/1M/YTD returns over mixed `total_value` | Comparing apples to apples-plus-oranges |
| `app/contexts/trading/domain/upcoming_dividends_presenter.rb:31` | `expected_total = shares * amount_per_share` without currency | USD dividend shown as a plain number; if user assumes MXN, error ~17x |
| `app/contexts/trading/domain/weekly_insight_calculator.rb:33-39` | `weekly_change` over mixed snapshots | "Your portfolio is up 8%" could be pure FX movement |

---

### P0.3 — CETES: maturity_date overwritten + JTBD #3 not implemented

**What CETES DOES work:**
- `app/contexts/market_data/domain/yield_calculator.rb` math correct for the Mexican 360-day convention
- `BanxicoGateway` reads the 4 series (28/91/182/364) with correct Banxico IDs
- `SyncCetes` upserts a `CETES_{term}D` asset with `face_value: 10.0` and `yield_rate`

**What's broken:**
- `app/contexts/market_data/use_cases/sync_cetes.rb:40` — `maturity_date: Date.current + days.days` **is overwritten on every sync**. It's a synthetic "rolling CETES", not a real instrument with a fixed maturity. If Adrian buys 28D CETES today, his position should have its own `maturity_date` frozen, not the asset's.
- **`Position` lacks `maturity_date` column** — for CETES this is structurally necessary.
- **No CETES maturity alerts exist** (`grep` in `app/contexts/alerts` for `maturity|cetes|fixed_income` → 0 results). **JTBD #3 from the PRD is not implemented.**
- `ExecuteTradeContract` doesn't capture `maturity_date`, term, or discount price.

---

## 🟠 P1 — Architectural leaks and miss-bounded contexts

### Confirmed cross-context leaks

1. **`trading/use_cases/assemble_dashboard.rb:24`** → calls `MarketData::Domain::MarketSentiment.for_user(user)` (direct cross-context to domain). Also lines 13, 15, 22, 27, 30, 44 access **models** of MarketData (`NewsArticle`, `Asset`, `MarketIndex`, `FearGreedReading`, `PortfolioInsight`) — model leak, not just domain leak.
2. **`market_data/use_cases/generate_portfolio_insight.rb:12`** → `Trading::Domain::ConcentrationAnalyzer.analyze`. Also line 8 iterates `portfolio.open_positions` (Trading model) and line 20 writes `PortfolioInsight` (which Trading's dashboard reads — bidirectional).
3. **`alerts/handlers/create_notification_on_alert.rb:14`** → directly invokes `Notifications::UseCases::CreateNotification` (not via event). This makes Notifications a **library**, not a BC.

### Newly detected leaks

4. **`administration/use_cases/assets/search_ticker.rb:32`** → directly instantiates `MarketData::Gateways::AlphaVantageGateway`. Administration coupled to MarketData's HTTP implementation.
5. **`administration/use_cases/users/suspend_user.rb:13`** (same for reactivate, delete) → Administration publishes events in the `Identity::Events::User*` namespace. A foreign BC publishing another BC's events.
6. **`administration/use_cases/assets/create_asset.rb:18`** (same for delete) → Administration publishes `MarketData::Events::AssetCreated/AssetDeleted`. Same pattern.

### Architectural verdict

- **Trading↔MarketData boundary is fiction.** Crosses both directions. Adding a dashboard widget means touching Trading, MarketData, and sometimes Alerts.
- **Administration isn't a real BC.** Publishes Identity and MarketData events, instantiates MarketData gateways. It's an *admin frontend* over the other BCs. Reassigning its use cases to the owning BCs would eliminate ~10 leaks and a namespace level.
- **Notifications is a library, not a BC.** It's invoked directly. Consider formally as a shared library in `app/shared/`.

---

## 🟡 P2 — Features without canonical JTBD

Of the previous 22 phases, ~25-28% of the code doesn't map to any canonical JTBD. Prioritized list:

### Top candidates for immediate deprecation

| Feature | Phase | Why out |
|---|---|---|
| **Entire LLM layer (Phase 22)** | 22.0-22.4 | InsightGenerator, NewsSentimentAnalyzer, FundamentalHealthCheck, EarningsNarrativeGenerator, LlmGateway, anonymizer, 4 views, contracts, ai_insights table+model. **134 specs, 12 commits.** No canonical JTBD asks for it. |
| **Public landing with "50K traders"** | PRD F-001 | Audience is 20 invitees. Copy is fake social proof (see Renata) |
| **`/trends` public Trend Explorer** | PRD F-003 | Explicit non-user in `docs/vision/non-goals.md` |
| **Risk Metrics + TWR benchmarking** | Phase 17, 18 | PM feature; weekly investor doesn't use it. And TWR vs S&P lies with the P0 currency bug |
| **Concentration alerts + HHI analyzer** | Phase 21.0 | Adrian with 5-15 holdings doesn't need HHI. No canonical JTBD. |
| **F&G historical chart + 7 CNN sub-indicators** | Phase 9.1, 18 | Basic F&G score is already tangential to JTBD #6; the chart and the 7 components are visual noise |
| **Sentiment-based alerts** | Phase 13.0 | Alerting "the market is greedy" doesn't fit JTBDs #1-#6 |
| **3-step onboarding wizard** | PRD F-017 | The 19 friends arrive via direct invitation, not via wizard |

### Features to "keep but rewrite copy" (ADR-001)

| Feature | Reason |
|---|---|
| `WeeklyInsightCalculator` + dashboard insight | If it survives, validate strictly observational tone |
| TrendScore tooltip / labels "Strongest/Strong/Moderate" | Change to descriptive numeric buckets |
| Basic F&G card | Remove action-oriented language, keep score as observable |

---

## 🟡 P2 — ADR-001 violations in frontend

Renata identified that the **Phase 22 backend complies with ADR-001 (system prompts with guardrails)** but the **frontend marketing copy violates it**.

### Top violations in views

| # | path:line | Text | Classification |
|---|---|---|---|
| 1 | `pages/landing.html.erb:19` | "Leverage advanced algorithms and proprietary AI indicators to **identify emerging opportunities before the crowd**" | Clear prescriptive |
| 2 | `pages/landing.html.erb:116` | "**Identify high-probability setups** with our proprietary AI indicators" | Prescriptive + probabilistic prediction (doubly forbidden) |
| 3 | `pages/landing.html.erb:161` | "**Gain a competitive edge**" | Prescriptive |
| 4 | `registrations/new.html.erb:12` | "Join thousands of traders using data-driven insights to **make smarter investment decisions**" | Prescriptive |
| 5 | `sessions/new.html.erb:24` | Fake testimonial "...Highly recommended" | Prescriptive + fake |
| 6 | `pages/landing.html.erb:83-100` | "Trusted by GlobalBank/DataCore/FinStream/PrimeInvest" | **Soft fraud** — invented clients |
| 7 | `pages/landing.html.erb:134-148` | "$4.2B Assets Tracked", "50K+ Active Traders", "99.9% Uptime" | **Soft fraud** — unsupported claims (beta ≤20) |
| 8 | `market/_listings_table.html.erb:14, 25-30` | Label "**Trend Strength: Parabolic / Strong / Weak**" | Gray zone → prescriptive (functions as implicit buy signal) |
| 9 | `market/_analyst_target.html.erb:33` | "**Upside / Downside +X%**" | Gray zone (directional vocabulary) |
| 10 | `news_sentiment_analyzer.rb:13` + `_news_card.html.erb:10-11` | Vocabulary drift: prompt emits "bullish/bearish/neutral", view accepts "bullish/bearish/positive/negative" | Type inconsistency + ADR-001 gray zone |

**Positive finding:** no literal "buy/sell/recommend" was found in views. The damage is in the landing marketing copy and in subtle prescriptive labels.

### Missing LLM output validation

ADR-001 implementation says "Add output validation against an action-verb blacklist". Only JSON structure is validated. **The system-prompt guardrail is hope, not guarantee.**

If the LLM layer survives the cleanup (action P1.4), add the validator. If the LLM layer is deprecated, this item disappears.

---

## 🟡 P2 — Design system drift

- **Design system exists in `tailwind/application.css` but views ignore it.** 0 use of `bg-success/error/warning/info`. 189 hardcoded instances of `text-emerald/rose/amber/violet`. 884 instances of `text-slate-*` (monochromatic saturation).
- **Plus Jakarta Sans loaded in `application.html.erb:34` but never applied via class** — the app renders with the default CSS font-stack, not the brand.
- **Duplicate components:** `_stat_card.html.erb` vs `_admin_kpi_card.html.erb` — almost identical logic, should be unified with a variant prop.
- **`_flash_message.html.erb`** uses `bg-green-50/bg-red-50` directly instead of `success/error` tokens from `@theme`.
- **`_trade_row.html.erb`** vs **`_edit_row.html.erb`** repeat structure; `_edit_row` lacks dark mode classes (inconsistent).
- **F&G cards** repeat hardcoded color-bucket hex twice (`#ef4444/#f97316/#f59e0b/#84cc16/#22c55e`) instead of using tokens.

---

## 🟡 P2 — Code anti-patterns

### Trivial use cases over scaffolding (10+)

Full list in [`inventory.md`](./inventory.md#trivial-use-cases-anti-pattern-3--top-10). All: 13-19 lines of `ApplicationUseCase` + `Success/Failure` for `update!` or `destroy!`. Could be a model scope/method or a direct call from the controller with 80% less code.

**Proposal:** introduce `SimpleUseCase` (without dry-monads) for trivial CRUD. Or eliminate UC and call from controller.

### 11 zombie + 4 ghost events

See [`inventory.md`](./inventory.md#event-subscriptions--health-check). Cleanup: delete the 4 ghosts (Trading::Events::WatchlistItemAdded/PositionOpened/PositionClosed/PortfolioSnapshotTaken + Alerts::Events::AlertRuleCreated); decide whether the published-without-subscribers are audit-only or dead.

### Abandoned designs without SPEC.md

4 folders in `designs/` that didn't follow the `PROCESSING.md` workflow:
- `aapl_statements_tab_-_stockerly/` — implemented, close
- `detalle_de_asset_-_aapl/` — partially implemented, close (diverged)
- `stockerly_-_adaptive_metrics/` — not implemented, decide
- `stockerly_-_tooltip_component_detail/` — not implemented, candidate to resume

---

## 🟢 What's good (don't touch)

- **DDD core architecture** — 6 BCs declared; leaks are localized and tractable, not systemic chaos
- **LLM system prompts** (if they survive cleanup) — the 4 Phase 22 generators have explicit guardrail **"Never recommend buying, selling, or any specific action"**. Better than industry average.
- **CETES yield math** — `YieldCalculator` correct for the Mexican 360-day convention
- **Empty states + skeleton components** — well designed, good coverage in listings
- **Shared components** — `_asset_badge`, `_sparkline`, `_donut_chart`, `_empty_state`, `_skeleton` well factored with `<%# Usage: ... %>` headers
- **Auth with `has_secure_password` + sessions** — Rails native, no Devise
- **Clean CI pipeline** — brakeman, bundler-audit, importmap audit
- **Regulatory disclaimer** — `market/_disclaimer.html.erb`, `legal/risk_disclosure.html.erb` serve their function
- **AuthenticatedController + Admin::BaseController hierarchy** — clear

---

## ADRs to write

From the architectural findings, ADRs pending (not urgent, write when addressing the corresponding problem):

1. **ADR-002** — Trading + MarketData boundary (how to resolve the `assemble_dashboard` leak)
2. **ADR-003** — Sync vs async event handler criterion
3. **ADR-004** — Notifications: own BC or shared library?
4. **ADR-005** — Cross-BC event ownership (who publishes `Identity::Events::UserSuspended`?)
5. **ADR-006** — When NOT to use ApplicationUseCase (criterion for SimpleUseCase or controller-direct)
6. **ADR-007** — Administration: own BC or cross-cutting admin layer?
