# Code Audit — Inventario Crudo

> **Fecha:** 2026-05-14
> **Fuente:** sub-agent Hiroto (architecture) + grep manual.

---

## Bounded Contexts — inventory por BC

| BC | Use Cases | Events | Handlers | Contracts | Domain Services | Gateways | Models AR |
|---|---|---|---|---|---|---|---|
| **Identity** | 13 | 10 | 8 | 8 | 0 | — | `User`, `RememberToken`, `AuditLog` |
| **Trading** | 8 | 8 | 5 | 2 | 8 | — | `Portfolio`, `Position`, `Trade`, `PortfolioSnapshot`, `WatchlistItem`, `StockSplit` |
| **Alerts** | 9 | 2 | 4 | 1 | 1 | — | `AlertRule`, `AlertEvent`, `AlertPreference` |
| **MarketData** | 11 | 13 | 16 | 5 | 12 | 14 | `Asset`, `AssetPriceHistory`, `AssetFundamental`, `Dividend`, `EarningsEvent`, `NewsArticle`, `FearGreedReading`, `MarketIndex`, `FinancialStatement`, `FxRate`, `TrendScore`, `PortfolioInsight` |
| **Administration** | 23 | 8 | 10 | 6 | 1 | — | `Integration`, `ApiKeyPool`, `SystemLog`, `SiteConfig` |
| **Notifications** | 3 | 1 | 1 | 0 | 0 | — | `Notification` |
| **Totals** | **67** | **42** | **44** | **22** | **22** | **14** | **23** |

### Observaciones del inventario

- **Identity tiene 0 domain services** — lógica vive en `User` model y use cases. Inconsistente con los otros BCs (anti-pattern de "modelo gordo" o de "use case gordo").
- **Administration tiene 23 use cases** — más que cualquier otro BC. Sospechoso: ¿es un BC con dominio propio o un layer admin transversal sobre los otros? Ver diagnosis.md.
- **MarketData es el BC más rico** — 11 UC, 13 events, 16 handlers, 12 domain services, 14 gateways. Es el corazón del producto.
- **Notifications es minimalista** — 3 UC, 1 event, 1 handler, 0 contracts. ¿BC real o librería? Ver diagnosis.md.

---

## Event subscriptions — health check

**Estado:** 42 events declarados, 37 subscriptions cableadas en `config/initializers/event_subscriptions.rb`.

### Events zombie (publicados sin subscriber) — 7

1. `Identity::Events::ProfileUpdated` (publicado en `update_info.rb:8`)
2. `Identity::Events::EmailVerified` (publicado en `verify_email.rb:8`)
3. `MarketData::Events::AssetDeleted` (publicado en `delete_asset.rb:12`)
4. `MarketData::Events::FxRatesRefreshed` (publicado en `refresh_fx_rates_job.rb:15`)
5. `Administration::Events::AssetUpdated` (publicado, nadie escucha)
6. `Administration::Events::CsvExported` (publicado, ignorado)
7. `Alerts::Events::AlertRuleCreated` (ni publicado ni suscrito — clase fantasma)

### Events fantasma (clase declarada pero nunca publicada ni suscrita) — 4

1. `Trading::Events::WatchlistItemAdded`
2. `Trading::Events::PositionOpened`
3. `Trading::Events::PositionClosed`
4. `Trading::Events::PortfolioSnapshotTaken`

### Hot events (≥4 subscribers) — 2

- `MarketData::Events::AssetPriceUpdated` → 4 handlers (EvaluateAlerts, Broadcast, RecordPriceHistory, RecalculateTrendScore). Cualquier handler lento bloquea o multiplica latencia; verificar `async?` por handler.
- `Identity::Events::UserRegistered` → 4 handlers. Orden importa (Portfolio antes que AlertPreferences) y no está garantizado.

**Total a limpiar:** **11 events** (7 zombie + 4 fantasma).

---

## Use cases triviales (anti-pattern #3) — top 10

Todos: andamio `ApplicationUseCase` + `Success/Failure` para 2-5 líneas reales.

| # | Path | Líneas | Operación real |
|---|---|---|---|
| 1 | `identity/use_cases/load_asset_catalog.rb` | 13 | `Asset.where(...).order.limit` — 1 query |
| 2 | `identity/use_cases/load_progress.rb` | 13 | `user.watchlist_items.count` |
| 3 | `identity/use_cases/load_profile.rb` | 15 | `user.watchlist_items.includes(...).order` |
| 4 | `notifications/use_cases/list_recent.rb` | 15 | 2 scopes |
| 5 | `trading/use_cases/load_asset_trend.rb` | 15 | 1 `find_by` + 2 reads |
| 6 | `alerts/use_cases/update_preferences.rb` | 14 | `pref.update!(params.slice(...))` |
| 7 | `alerts/use_cases/toggle_rule.rb` | 19 | flip enum + `update!` |
| 8 | `alerts/use_cases/destroy_rule.rb` | 19 | `find_by` + `destroy!` |
| 9 | `trading/use_cases/remove_from_watchlist.rb` | 19 | `find_by` + `destroy!` |
| 10 | `administration/use_cases/assets/toggle_status.rb` | 17 | flip enum + `update!` |

Bonus: `notifications/use_cases/mark_as_read.rb` (18L), `administration/use_cases/integrations/refresh_sync.rb:10` (enqueue 1 job), `identity/use_cases/global_search.rb` (3 ILIKE queries).

---

## Features visibles agrupadas por surface

### Dashboard (`/dashboard`)
- Patrimonio Total KPI, Buying Power, Day Gain/Loss, Market Sentiment
- Watchlist Performance table
- Próximos eventos (CETES + earnings)
- Weekly Insight card
- AI Insight card (Phase 22.1)
- News feed (lazy frame)
- Trending sidebar (lazy frame)
- F&G card + sub-indicators
- Market indices card + sparklines

### Market (`/market`)
- Market listings table con filters (sector, market cap, volatility, trend strength)
- TrendScore breakdown tooltip
- Pagination
- Asset detail page (`/market/:symbol`)
- 7 tabs para stocks: Summary, Income Statement, Balance Sheet, Cash Flow, Trends, Earnings, AI Health
- 2 tabs para crypto: Summary, Market Data
- TradingView Advanced Chart widget (lazy)

### Portfolio (`/portfolio`)
- Total Portfolio Value KPI (con domestic vs international breakdown — sospechoso)
- Donut chart de allocation (sector + asset type, tabs)
- Tabs: Open Positions / Closed Positions / Dividends
- Period returns pills (1D/1W/1M/3M/6M/1Y/YTD/ALL)
- SVG performance chart con benchmark overlay (S&P/NASDAQ/Dow)
- Risk Metrics section (Volatility, Sharpe, Max Drawdown)
- Concentration risk badge
- Trade entry form inline
- Trade edit (con 30-day guard) y soft delete

### Alerts (`/alerts`)
- Active rules table
- Create rule form (conditions: price_above, price_below, percent_change, rsi_overbought, rsi_oversold, volume_spike, sentiment_above, sentiment_below, concentration_risk)
- Live feed sidebar
- Delivery preferences

### Earnings (`/earnings`)
- Calendar grid (month view)
- Watchlist priority sidebar
- Earnings detail page (`/earnings/:id`) con EPS chart, beat/miss icons

### News (`/news`)
- Article feed con sentiment badges (LLM)
- Filtros: All / Stocks / Crypto / Economy
- Watchlist filter

### Profile (`/profile`)
- Personal info form
- Account settings (toggles)
- Watchlist table

### Admin (`/admin/*`)
- Assets CRUD, search ticker, manual sync
- Logs viewer con filters, auto-refresh, CSV export
- Users management (suspend, reactivate, delete)
- Integrations cards con rate limit bars, API Key Pool
- System Health (Solid Queue, Solid Cache, Circuit Breakers)
- Settings (SiteConfig)

### Public
- `/` landing con fake stats + fake testimonials + fake institutions
- `/trends` Trend Explorer público
- `/open-source` página
- `/privacy`, `/terms`, `/risk-disclosure` legal
- `/login`, `/register`, `/forgot-password`

---

## View components inventory

`app/views/components/`:
- `_stat_card.html.erb` — KPI con change badge (dashboard)
- `_admin_kpi_card.html.erb` — KPI con color_map (admin) — **duplicado** con `_stat_card`
- `_empty_state.html.erb` — ✅ bien diseñado, 4 variants
- `_skeleton.html.erb` — ✅ 4 variants (text/card/stat_card/table_row), subutilizado
- `_status_badge.html.erb`
- `_data_table.html.erb`

`app/views/shared/`:
- `_flash.html.erb` (loop)
- `_flash_message.html.erb` (item) — usa `bg-green-50/bg-red-50` hardcoded en vez de tokens
- `_navbar.html.erb`
- `_breadcrumb.html.erb`
- `_asset_badge.html.erb` — ✅ consistente
- `_sparkline.html.erb` — ✅ consistente
- `_donut_chart.html.erb` — ✅ consistente

---

## Designs folder — abandonados

Workflow `designs/wip/PROCESSING.md` exige `screen.png + code.html + SPEC.md`. Estado:

| Folder | Archivos | SPEC.md | Implementado | Recomendación |
|---|---|---|---|---|
| `aapl_statements_tab_-_stockerly/` | screen.png, code.html | ❌ | Sí → `market/_statements_tab.html.erb` | Cerrar/archivar |
| `detalle_de_asset_-_aapl/` | screen.png, code.html | ❌ | Sí parcial → `market/show.html.erb` | Cerrar/archivar (divergió) |
| `stockerly_-_adaptive_metrics/` | screen.png, code.html | ❌ | No encontrado en views | Decidir: retomar o eliminar |
| `stockerly_-_tooltip_component_detail/` | screen.png, code.html | ❌ | No (solo trend-breakdown inline) | Retomar — tooltip reutilizable útil |

---

## Counts crudos (UI/CSS)

| Métrica | Count | Interpretación |
|---|---|---|
| `text-slate-*` en views | **884** | Saturación de slate; ignora `secondary: #1E293B` del brand |
| Hex hardcoded inline en views | **46** | Mayoría en charts SVG (acceptable) + F&G gradients (re-tokenizable) |
| `text-emerald/rose/amber/violet` | **189** | Sistema semántico paralelo no-tokenizado |
| `bg-success/error/warning/info` (tokens semánticos) | **0** | **Cero uso del design system semántico** definido en `@theme` |
| `font-display`, `font-body` clases | **0** (`font-mono` 10x) | Plus Jakarta Sans cargado pero nunca aplicado via clase |

---

## LLM Phase 22 — system prompts auditados

| File | Status ADR-001 |
|---|---|
| `insight_generator.rb:8-14` | ✅ "Never recommend buying, selling, or any specific action" |
| `fundamental_health_check.rb:8-13` | ✅ mismo guardrail |
| `earnings_narrative_generator.rb:10-15` | ✅ mismo guardrail |
| `news_sentiment_analyzer.rb:10-14` | ⚠️ usa "bullish/bearish/neutral" — view `_news_card.html.erb` acepta también "positive/negative" — drift de vocabulario |

**Falta:** validación de output del LLM contra blacklist de verbos. El guardrail del prompt es esperanza, no garantía.

---

## Asset types presentes

Por convención del schema y código actual:
- `equity` (stocks NYSE/NASDAQ)
- `etf`
- `crypto`
- `cetes` (instrumento mexicano)
- `index` (S&P, NASDAQ, Dow, IPC, VIX, FTSE — no transables)
- `forex` (FX rates como assets — sospechoso)

**Asset.currency no existe** — la moneda es implícita por convención de símbolo (`CETES_*D` → MXN, todo lo demás → USD asumido).
