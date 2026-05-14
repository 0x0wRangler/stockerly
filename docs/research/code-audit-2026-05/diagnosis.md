# Code Audit — Diagnóstico Categorizado

> **Fecha:** 2026-05-14
> **Fuente:** Síntesis de 4 sub-agents (Hiroto/Lucía/Renata/Esther) más cross-check con paths y líneas.
> **Companion:** [`inventory.md`](./inventory.md) tiene los números crudos. Este archivo categoriza los hallazgos por gravedad.

---

## 🔴 P0 — Beta-blockers

Bloquean honestamente invitar al primer amigo.

### P0.1 — Multi-currency estructural (no son 2 líneas)

El P0 conocido (`currency: "USD"` hardcoded en `execute_trade.rb:39,60`) es solo la punta del iceberg. **Todo el núcleo aritmético del portafolio asume single-currency USD.**

**Sitios afectados:**

- `app/contexts/trading/use_cases/execute_trade.rb:39,60` — hardcode `currency: "USD"` en dos `create!`.
- `app/contexts/trading/contracts/execute_trade_contract.rb:1-26` — el contract **no acepta `currency` ni `fx_rate_at_execution`** como input. Adrian literalmente no puede registrar un trade en MXN aunque quisiera.
- `app/models/position.rb:11-12` — `scope :domestic, -> { where(currency: "USD") }` y `:international` para `!= USD`. **Mentalidad USA-centric hardcoded en el modelo** (Adrian está en México: doméstico para él = MXN).
- `db/schema.rb` — defaults `"USD"` en `positions.currency`, `trades.currency`, `dividends.currency`, `financial_statements.currency`, `users.preferred_currency`. El default arrastra USD a todos los nuevos registros.
- **`Asset` NO tiene columna `currency`** — la moneda nativa del instrumento es implícita (sin source of truth). CETES es MXN por convención del símbolo `CETES_*D`; AAPL es USD por suposición.
- **No existe `Trade.fx_rate_at_execution`, `Position.cost_basis_mxn`, ni `Position.cost_basis_usd`**. Cuando Adrian compra AAPL via broker MX en MXN, no hay forma de capturar el TC del día.
- `db/schema.rb` `portfolio_snapshots.total_value` e `invested_value` son `decimal` sin columna `currency` — si mañana se cambia el reporte a MXN, los snapshots históricos quedan ambiguos.

**Infra ociosa:** existe `app/models/fx_rate.rb` con `FxRate.convert` y `FxRatesGateway`, pero `FxRate.convert` **jamás se invoca desde código de dominio**. Hay datos y no hay wiring.

**Mapping a JTBDs:** bloquea #1 (Patrimonio consolidado MXN) y #2 (Drawdown desde costo MXN), debilita #5 (Trade capture — no se puede capturar correctamente).

---

### P0.2 — Calculadores currency-naive

8 calculadores **mienten matemáticamente** para portafolio mixto MXN+USD:

| Archivo | Pecado | Consecuencia |
|---|---|---|
| `app/models/portfolio.rb:17-19` | `total_value` suma `shares * current_price` sin conversión | Suma pesos mexicanos de CETES con dólares de NYSE como si fueran la misma moneda. **El número del dashboard es matemáticamente sin sentido.** |
| `app/models/portfolio.rb:21-23` | `total_unrealized_gain` misma raíz | P&L global es ficción aritmética |
| `app/models/portfolio.rb:25-37` | `allocation_by_sector`, `allocation_by_asset_type` agrupan SQL `SUM(shares * current_price)` sin FX | Pies de allocation mienten cuando hay mezcla |
| `app/contexts/trading/domain/concentration_analyzer.rb:9-14` | HHI calculado sobre `value = shares * current_price` sin normalizar | Reporta concentración inexistente: 1M MXN en CETES (~50K USD) vs 50K USD en AAPL — HHI dice 99% en CETES porque los pesos del número son ~17x más grandes |
| `app/contexts/trading/domain/portfolio_risk_calculator.rb:40-65` | Volatilidad, Sharpe, drawdown sobre `total_value.to_f` de snapshots | Si snapshots mezclan monedas, la volatilidad incluye **ruido del tipo de cambio**, no volatilidad del portafolio. Sharpe falsamente alto/bajo |
| `app/contexts/trading/domain/time_weighted_return.rb:46-56` | TWR sobre `total_value` mezclado | Mismo problema. Cash flows también ignoran moneda |
| `app/contexts/trading/domain/period_returns_calculator.rb:18,56-58` | Returns 1D/1M/YTD sobre `total_value` mezclado | Comparas pesos manzanas con manzanas-más-naranjas |
| `app/contexts/trading/domain/upcoming_dividends_presenter.rb:31` | `expected_total = shares * amount_per_share` sin currency | Dividendo USD se muestra como número plano; si user asume MXN, error ~17x |
| `app/contexts/trading/domain/weekly_insight_calculator.rb:33-39` | `weekly_change` sobre snapshots mezclados | "Tu portafolio subió 8%" puede ser puro movimiento cambiario |

---

### P0.3 — CETES: maturity_date sobreescrita + JTBD #3 no implementado

**Estado actual de CETES (lo que SÍ funciona):**
- `app/contexts/market_data/domain/yield_calculator.rb` math correcto para convención mexicana 360-day
- `BanxicoGateway` lee las 4 series (28/91/182/364) con IDs Banxico correctos
- `SyncCetes` upsertea asset `CETES_{term}D` con `face_value: 10.0` y `yield_rate`

**Lo roto:**
- `app/contexts/market_data/use_cases/sync_cetes.rb:40` — `maturity_date: Date.current + days.days` **se sobreescribe en cada sync**. Es un CETES "rolling" sintético, no un instrumento real con vencimiento fijo. Si Adrian compra hoy CETES 28D, su posición debería tener su propio `maturity_date` congelado, no el del asset.
- **`Position` no tiene columna `maturity_date`** — para CETES esto es estructuralmente necesario.
- **No existen alertas de vencimiento de CETES** (`grep` en `app/contexts/alerts` por `maturity\|cetes\|fixed_income` → 0 resultados). **JTBD #3 del PRD no está implementado.**
- `ExecuteTradeContract` no captura `maturity_date`, plazo, ni descuento al que se compró.

---

## 🟠 P1 — Fugas arquitecturales y BC mal delineados

### Fugas cross-context confirmadas

1. **`trading/use_cases/assemble_dashboard.rb:24`** → llama `MarketData::Domain::MarketSentiment.for_user(user)` (cross-context directo a domain). Además líneas 13, 15, 22, 27, 30, 44 acceden a **modelos** de MarketData (`NewsArticle`, `Asset`, `MarketIndex`, `FearGreedReading`, `PortfolioInsight`) — fuga de modelo, no solo de domain.
2. **`market_data/use_cases/generate_portfolio_insight.rb:12`** → `Trading::Domain::ConcentrationAnalyzer.analyze`. Además línea 8 itera `portfolio.open_positions` (modelo de Trading) y línea 20 escribe `PortfolioInsight` (que el dashboard de Trading lee — bidireccional).
3. **`alerts/handlers/create_notification_on_alert.rb:14`** → invoca `Notifications::UseCases::CreateNotification` directamente (no por event). Esto convierte a Notifications en **librería**, no en BC.

### Fugas nuevas detectadas

4. **`administration/use_cases/assets/search_ticker.rb:32`** → instancia `MarketData::Gateways::AlphaVantageGateway` directamente. Administration acoplada a la implementación HTTP de MarketData.
5. **`administration/use_cases/users/suspend_user.rb:13`** (idem reactivate, delete) → Administration publica events del namespace `Identity::Events::User*`. Un BC ajeno publicando events del otro BC.
6. **`administration/use_cases/assets/create_asset.rb:18`** (idem delete) → Administration publica `MarketData::Events::AssetCreated/AssetDeleted`. Mismo patrón.

### Veredicto arquitectural

- **Trading↔MarketData boundary es ficción.** Cruza en ambas direcciones. Agregar un widget al dashboard implica tocar Trading, MarketData, y a veces Alerts.
- **Administration no es un BC real.** Publica events de Identity y MarketData, instancia gateways de MarketData. Es un *frontend admin* sobre los otros BCs. Reasignar sus use cases a los BCs dueños eliminaría ~10 fugas y un nivel de namespace.
- **Notifications es una librería, no un BC.** Es invocada directamente. Considerar formalmente como librería compartida en `app/shared/`.

---

## 🟡 P2 — Features sin JTBD canónico

De las 22 fases anteriores, ~25-28% del código no mapea a ningún JTBD canónico. Lista priorizada:

### Top candidatos a deprecación inmediata

| Feature | Fase | Por qué fuera |
|---|---|---|
| **Capa LLM completa (Phase 22)** | 22.0-22.4 | InsightGenerator, NewsSentimentAnalyzer, FundamentalHealthCheck, EarningsNarrativeGenerator, LlmGateway, anonymizer, 4 views, contracts, ai_insights table+model. **134 specs, 12 commits.** Ningún JTBD canónico la pide. |
| **Landing pública con "50K traders"** | PRD F-001 | Audiencia es 20 invitados. Copy es fake social proof (ver Renata) |
| **`/trends` Trend Explorer público** | PRD F-003 | Explicitly non-user en `docs/vision/non-goals.md` |
| **Risk Metrics + TWR benchmarking** | Phase 17, 18 | Feature de PM; weekly investor no la usa. Y TWR vs S&P miente con currency bug P0 |
| **Concentration alerts + HHI analyzer** | Phase 21.0 | Adrian con 5-15 holdings no necesita HHI. Sin JTBD canónico. |
| **F&G historical chart + 7 sub-indicators CNN** | Phase 9.1, 18 | F&G score básico ya está en JTBD #6 tangencial; el chart y los 7 componentes son ruido visual |
| **Sentiment-based alerts** | Phase 13.0 | Alertear "el mercado está greedy" no encaja en JTBDs #1-6 |
| **Onboarding wizard 3 pasos** | PRD F-017 | Los 19 amigos llegan por invitación directa, no por wizard |

### Features para "mantener pero reescribir copy" (ADR-001)

| Feature | Razón |
|---|---|
| `WeeklyInsightCalculator` + dashboard insight | Si sobrevive, validar tono estrictamente observacional |
| TrendScore tooltip / labels "Strongest/Strong/Moderate" | Cambiar a buckets numéricos descriptivos |
| F&G card básica | Quitar lenguaje accionable, mantener score como observable |

---

## 🟡 P2 — ADR-001 violations en frontend

Renata identificó que el **backend Phase 22 sí cumple ADR-001 (system prompts con guardrails)** pero el **frontend marketing copy lo viola**.

### Top violations en views

| # | path:line | Texto | Clasificación |
|---|---|---|---|
| 1 | `pages/landing.html.erb:19` | "Leverage advanced algorithms and proprietary AI indicators to **identify emerging opportunities before the crowd**" | Prescriptivo claro |
| 2 | `pages/landing.html.erb:116` | "**Identify high-probability setups** with our proprietary AI indicators" | Prescriptivo + predicción probabilística (doblemente prohibido) |
| 3 | `pages/landing.html.erb:161` | "**Gain a competitive edge**" | Prescriptivo |
| 4 | `registrations/new.html.erb:12` | "Join thousands of traders using data-driven insights to **make smarter investment decisions**" | Prescriptivo |
| 5 | `sessions/new.html.erb:24` | Fake testimonial "...Highly recommended" | Prescriptivo + fake |
| 6 | `pages/landing.html.erb:83-100` | "Trusted by GlobalBank/DataCore/FinStream/PrimeInvest" | **Fraude soft** — clientes inventados |
| 7 | `pages/landing.html.erb:134-148` | "$4.2B Assets Tracked", "50K+ Active Traders", "99.9% Uptime" | **Fraude soft** — claims sin respaldo (beta ≤20) |
| 8 | `market/_listings_table.html.erb:14, 25-30` | Label "**Trend Strength: Parabolic / Strong / Weak**" | Zona gris → prescriptivo (funciona como señal de compra implícita) |
| 9 | `market/_analyst_target.html.erb:33` | "**Upside / Downside +X%**" | Zona gris (vocabulario direccional) |
| 10 | `news_sentiment_analyzer.rb:13` + `_news_card.html.erb:10-11` | Drift vocabulario: prompt emite "bullish/bearish/neutral", view acepta "bullish/bearish/positive/negative" | Inconsistencia tipos + ADR-001 zona gris |

**Hallazgo positivo:** no se encontró ningún "compra/vende/recomendamos" literal en views. El daño está en el marketing copy del landing y en labels prescriptivos sutiles.

### LLM output validation faltante

ADR-001 implementación dice "Añadir validación de output contra lista negra de verbos de acción". Solo se valida estructura JSON. **El guardrail del system prompt es esperanza, no garantía.**

Si la capa LLM sobrevive al cleanup (acción P1.4), agregar validator. Si la capa LLM se deprecia, este item desaparece.

---

## 🟡 P2 — Design system drift

- **Design system existe en `tailwind/application.css` pero las views lo ignoran.** 0 uso de `bg-success/error/warning/info`. 189 instancias hardcoded de `text-emerald/rose/amber/violet`. 884 instancias de `text-slate-*` (saturación monocromática).
- **Plus Jakarta Sans cargado en `application.html.erb:34` pero nunca aplicado via clase** — la app se renderiza con CSS default font-stack, no con el branding.
- **Componentes duplicados:** `_stat_card.html.erb` vs `_admin_kpi_card.html.erb` — lógica casi idéntica, deberían unificarse con variant prop.
- **`_flash_message.html.erb`** usa `bg-green-50/bg-red-50` directos en vez de tokens `success/error` del `@theme`.
- **`_trade_row.html.erb`** vs **`_edit_row.html.erb`** repiten estructura; `_edit_row` sin dark mode classes (inconsistente).
- **F&G cards** repiten hex hardcoded de buckets de color 2 veces (`#ef4444/#f97316/#f59e0b/#84cc16/#22c55e`) en lugar de tokens.

---

## 🟡 P2 — Anti-patterns en código

### Use cases triviales sobre andamiaje (10+)

Lista completa en [`inventory.md`](./inventory.md#use-cases-triviales-anti-pattern-3--top-10). Todos: 13-19 líneas de `ApplicationUseCase` + `Success/Failure` para `update!` o `destroy!`. Podrían ser scope/método de modelo o llamada directa desde controller con 80% menos código.

**Propuesta:** introducir `SimpleUseCase` (sin dry-monads) para CRUD trivial. O eliminar UC y llamar desde controller.

### 11 events zombie + 4 fantasma

Ver [`inventory.md`](./inventory.md#event-subscriptions--health-check). Limpieza: borrar los 4 fantasma (Trading::Events::WatchlistItemAdded/PositionOpened/PositionClosed/PortfolioSnapshotTaken + Alerts::Events::AlertRuleCreated); decidir si los publicados-sin-subscriber son audit-only o muertos.

### Designs abandonados sin SPEC.md

4 carpetas en `designs/` que no siguieron el workflow `PROCESSING.md`:
- `aapl_statements_tab_-_stockerly/` — implementado, cerrar
- `detalle_de_asset_-_aapl/` — implementado parcial, cerrar (divergió)
- `stockerly_-_adaptive_metrics/` — no implementado, decidir
- `stockerly_-_tooltip_component_detail/` — no implementado, candidato a retomar

---

## 🟢 Lo que está bien (no tocar)

- **Arquitectura DDD core** — 6 BCs declarados; fugas son puntuales y atacables, no caos sistémico
- **LLM system prompts** (si sobreviven el cleanup) — los 4 generators de Phase 22 tienen guardrail explícito **"Never recommend buying, selling, or any specific action"**. Mejor que el promedio de la industria.
- **CETES yield math** — `YieldCalculator` correcto para convención mexicana 360-day
- **Empty states + skeleton components** — bien diseñados, buena cobertura en listings
- **Components shared** — `_asset_badge`, `_sparkline`, `_donut_chart`, `_empty_state`, `_skeleton` bien factorizados con headers `<%# Usage: ... %>`
- **Auth con `has_secure_password` + sessions** — Rails native, sin Devise
- **CI pipeline limpio** — brakeman, bundler-audit, importmap audit
- **Disclaimer regulatorio** — `market/_disclaimer.html.erb`, `legal/risk_disclosure.html.erb` cumplen función
- **AuthenticatedController + Admin::BaseController hierarchy** — clara

---

## ADRs candidatos a escribir

De los hallazgos arquitecturales, ADRs pendientes (no urgentes, escribir cuando se resuelva el problema correspondiente):

1. **ADR-002** — Trading + MarketData boundary (cómo resolver la fuga en `assemble_dashboard`)
2. **ADR-003** — Sync vs async event handler criterion
3. **ADR-004** — Notifications: ¿BC propio o librería compartida?
4. **ADR-005** — Ownership de events cross-BC (¿quién publica `Identity::Events::UserSuspended`?)
5. **ADR-006** — Cuándo NO usar ApplicationUseCase (criterio para SimpleUseCase o controller-direct)
6. **ADR-007** — Administration: ¿BC propio o admin layer transversal?
