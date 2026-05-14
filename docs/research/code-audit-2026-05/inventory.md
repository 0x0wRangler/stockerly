# Code Audit — Raw Inventory

> **Date:** 2026-05-14
> **Source:** sub-agent Hiroto (architecture) + manual grep.

---

## Bounded Contexts — inventory per BC

| BC | Use Cases | Events | Handlers | Contracts | Domain Services | Gateways | AR Models |
|---|---|---|---|---|---|---|---|
| **Identity** | 13 | 10 | 8 | 8 | 0 | — | `User`, `RememberToken`, `AuditLog` |
| **Trading** | 8 | 8 | 5 | 2 | 8 | — | `Portfolio`, `Position`, `Trade`, `PortfolioSnapshot`, `WatchlistItem`, `StockSplit` |
| **Alerts** | 9 | 2 | 4 | 1 | 1 | — | `AlertRule`, `AlertEvent`, `AlertPreference` |
| **MarketData** | 11 | 13 | 16 | 5 | 12 | 14 | `Asset`, `AssetPriceHistory`, `AssetFundamental`, `Dividend`, `EarningsEvent`, `NewsArticle`, `FearGreedReading`, `MarketIndex`, `FinancialStatement`, `FxRate`, `TrendScore`, `PortfolioInsight` |
| **Administration** | 23 | 8 | 10 | 6 | 1 | — | `Integration`, `ApiKeyPool`, `SystemLog`, `SiteConfig` |
| **Notifications** | 3 | 1 | 1 | 0 | 0 | — | `Notification` |
| **Totals** | **67** | **42** | **44** | **22** | **22** | **14** | **23** |

### Inventory observations

- **Identity has 0 domain services** — logic lives in the `User` model and in use cases. Inconsistent with the other BCs (anti-pattern of "fat model" or "fat use case").
- **Administration has 23 use cases** — more than any other BC. Suspicious: is it a BC with its own domain, or a cross-cutting admin layer over the others? See diagnosis.md.
- **MarketData is the richest BC** — 11 UCs, 13 events, 16 handlers, 12 domain services, 14 gateways. It's the heart of the product.
- **Notifications is minimal** — 3 UCs, 1 event, 1 handler, 0 contracts. Is it a real BC or a library? See diagnosis.md.

---

## Event subscriptions — health check

**State:** 42 events declared, 37 subscriptions wired in `config/initializers/event_subscriptions.rb`.

### Zombie events (published without subscribers) — 7

1. `Identity::Events::ProfileUpdated` (published in `update_info.rb:8`)
2. `Identity::Events::EmailVerified` (published in `verify_email.rb:8`)
3. `MarketData::Events::AssetDeleted` (published in `delete_asset.rb:12`)
4. `MarketData::Events::FxRatesRefreshed` (published in `refresh_fx_rates_job.rb:15`)
5. `Administration::Events::AssetUpdated` (published, nobody listens)
6. `Administration::Events::CsvExported` (published, ignored)
7. `Alerts::Events::AlertRuleCreated` (neither published nor subscribed — phantom class)

### Ghost events (class declared, never published or subscribed) — 4

1. `Trading::Events::WatchlistItemAdded`
2. `Trading::Events::PositionOpened`
3. `Trading::Events::PositionClosed`
4. `Trading::Events::PortfolioSnapshotTaken`

### Hot events (≥4 subscribers) — 2

- `MarketData::Events::AssetPriceUpdated` → 4 handlers (EvaluateAlerts, Broadcast, RecordPriceHistory, RecalculateTrendScore). Any slow handler blocks or multiplies latency; verify `async?` per handler.
- `Identity::Events::UserRegistered` → 4 handlers. Order matters (Portfolio before AlertPreferences) and isn't guaranteed.

**Total to clean up:** **11 events** (7 zombie + 4 ghost).

---

## Trivial use cases (anti-pattern #3) — top 10

All: `ApplicationUseCase` scaffolding + `Success/Failure` for 2-5 real lines.

| # | Path | Lines | Real operation |
|---|---|---|---|
| 1 | `identity/use_cases/load_asset_catalog.rb` | 13 | `Asset.where(...).order.limit` — 1 query |
| 2 | `identity/use_cases/load_progress.rb` | 13 | `user.watchlist_items.count` |
| 3 | `identity/use_cases/load_profile.rb` | 15 | `user.watchlist_items.includes(...).order` |
| 4 | `notifications/use_cases/list_recent.rb` | 15 | 2 scopes |
| 5 | `trading/use_cases/load_asset_trend.rb` | 15 | 1 `find_by` + 2 reads |
| 6 | `alerts/use_cases/update_preferences.rb` | 14 | `pref.update!(params.slice(...))` |
| 7 | `alerts/use_cases/toggle_rule.rb` | 19 | enum flip + `update!` |
| 8 | `alerts/use_cases/destroy_rule.rb` | 19 | `find_by` + `destroy!` |
| 9 | `trading/use_cases/remove_from_watchlist.rb` | 19 | `find_by` + `destroy!` |
| 10 | `administration/use_cases/assets/toggle_status.rb` | 17 | enum flip + `update!` |

Bonus: `notifications/use_cases/mark_as_read.rb` (18L), `administration/use_cases/integrations/refresh_sync.rb:10` (enqueue 1 job), `identity/use_cases/global_search.rb` (3 ILIKE queries).

---

## User-visible features grouped by surface

### Dashboard (`/dashboard`)
- Total Patrimony KPI, Buying Power, Day Gain/Loss, Market Sentiment
- Watchlist Performance table
- Upcoming events (CETES + earnings)
- Weekly Insight card
- AI Insight card (Phase 22.1)
- News feed (lazy frame)
- Trending sidebar (lazy frame)
- F&G card + sub-indicators
- Market indices card + sparklines

### Market (`/market`)
- Market listings table with filters (sector, market cap, volatility, trend strength)
- TrendScore breakdown tooltip
- Pagination
- Asset detail page (`/market/:symbol`)
- 7 tabs for stocks: Summary, Income Statement, Balance Sheet, Cash Flow, Trends, Earnings, AI Health
- 2 tabs for crypto: Summary, Market Data
- TradingView Advanced Chart widget (lazy)

### Portfolio (`/portfolio`)
- Total Portfolio Value KPI (with domestic vs international breakdown — suspicious)
- Allocation donut chart (sector + asset type, tabs)
- Tabs: Open Positions / Closed Positions / Dividends
- Period returns pills (1D/1W/1M/3M/6M/1Y/YTD/ALL)
- SVG performance chart with benchmark overlay (S&P/NASDAQ/Dow)
- Risk Metrics section (Volatility, Sharpe, Max Drawdown)
- Concentration risk badge
- Inline trade entry form
- Trade edit (with 30-day guard) and soft delete

### Alerts (`/alerts`)
- Active rules table
- Create rule form (conditions: price_above, price_below, percent_change, rsi_overbought, rsi_oversold, volume_spike, sentiment_above, sentiment_below, concentration_risk)
- Live feed sidebar
- Delivery preferences

### Earnings (`/earnings`)
- Calendar grid (month view)
- Watchlist priority sidebar
- Earnings detail page (`/earnings/:id`) with EPS chart, beat/miss icons

### News (`/news`)
- Article feed with sentiment badges (LLM)
- Filters: All / Stocks / Crypto / Economy
- Watchlist filter

### Profile (`/profile`)
- Personal info form
- Account settings (toggles)
- Watchlist table

### Admin (`/admin/*`)
- Assets CRUD, search ticker, manual sync
- Logs viewer with filters, auto-refresh, CSV export
- Users management (suspend, reactivate, delete)
- Integrations cards with rate limit bars, API Key Pool
- System Health (Solid Queue, Solid Cache, Circuit Breakers)
- Settings (SiteConfig)

### Public
- `/` landing with fake stats + fake testimonials + fake institutions
- `/trends` public Trend Explorer
- `/open-source` page
- `/privacy`, `/terms`, `/risk-disclosure` legal
- `/login`, `/register`, `/forgot-password`

---

## View components inventory

`app/views/components/`:
- `_stat_card.html.erb` — KPI with change badge (dashboard)
- `_admin_kpi_card.html.erb` — KPI with color_map (admin) — **duplicated** with `_stat_card`
- `_empty_state.html.erb` — ✅ well designed, 4 variants
- `_skeleton.html.erb` — ✅ 4 variants (text/card/stat_card/table_row), underused
- `_status_badge.html.erb`
- `_data_table.html.erb`

`app/views/shared/`:
- `_flash.html.erb` (loop)
- `_flash_message.html.erb` (item) — uses hardcoded `bg-green-50/bg-red-50` instead of tokens
- `_navbar.html.erb`
- `_breadcrumb.html.erb`
- `_asset_badge.html.erb` — ✅ consistent
- `_sparkline.html.erb` — ✅ consistent
- `_donut_chart.html.erb` — ✅ consistent

---

## Designs folder — abandoned

The `designs/wip/PROCESSING.md` workflow requires `screen.png + code.html + SPEC.md`. Current state:

| Folder | Files | SPEC.md | Implemented | Recommendation |
|---|---|---|---|---|
| `aapl_statements_tab_-_stockerly/` | screen.png, code.html | ❌ | Yes → `market/_statements_tab.html.erb` | Close/archive |
| `detalle_de_asset_-_aapl/` | screen.png, code.html | ❌ | Partial → `market/show.html.erb` | Close/archive (diverged) |
| `stockerly_-_adaptive_metrics/` | screen.png, code.html | ❌ | Not found in views | Decide: resume or eliminate |
| `stockerly_-_tooltip_component_detail/` | screen.png, code.html | ❌ | No (only trend-breakdown inline) | Resume — reusable tooltip useful |

---

## Raw counts (UI/CSS)

| Metric | Count | Interpretation |
|---|---|---|
| `text-slate-*` in views | **884** | Slate saturation; ignores `secondary: #1E293B` from the brand |
| Inline hardcoded hex in views | **46** | Mostly in SVG charts (acceptable) + F&G gradients (re-tokenizable) |
| `text-emerald/rose/amber/violet` | **189** | Parallel non-tokenized semantic system |
| `bg-success/error/warning/info` (semantic tokens) | **0** | **Zero use of the semantic design system** defined in `@theme` |
| `font-display`, `font-body` classes | **0** (`font-mono` 10x) | Plus Jakarta Sans loaded but never applied via class |

---

## LLM Phase 22 — system prompts audited

| File | ADR-001 status |
|---|---|
| `insight_generator.rb:8-14` | ✅ "Never recommend buying, selling, or any specific action" |
| `fundamental_health_check.rb:8-13` | ✅ same guardrail |
| `earnings_narrative_generator.rb:10-15` | ✅ same guardrail |
| `news_sentiment_analyzer.rb:10-14` | ⚠️ uses "bullish/bearish/neutral" — view `_news_card.html.erb` also accepts "positive/negative" — vocabulary drift |

**Missing:** LLM output validation against verb blacklist. The prompt guardrail is hope, not guarantee.

---

## Asset types present

By schema convention and current code:
- `equity` (NYSE/NASDAQ stocks)
- `etf`
- `crypto`
- `cetes` (Mexican instrument)
- `index` (S&P, NASDAQ, Dow, IPC, VIX, FTSE — not tradable)
- `forex` (FX rates as assets — suspicious)

**Asset.currency does not exist** — the currency is implicit by symbol convention (`CETES_*D` → MXN, anything else → assumed USD).
