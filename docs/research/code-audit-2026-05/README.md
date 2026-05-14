# Code Audit — Stockerly 2026-05-14

> **Fecha:** 2026-05-14 (Sprint 1 — Paso 6)
> **Método:** 4 sub-agents en paralelo (Hiroto/Architecture, Lucía/Financial, Renata/UI-Copy, Esther/Scope-JTBD), síntesis manual.
> **Output:** insumo para crear issues en GitHub durante Paso 7.

---

## TL;DR brutal

**El código está mejor de lo que se sentía, y peor de lo que se decía.** La arquitectura DDD es sólida; los LLM prompts cumplen ADR-001; CI verde; ~94% coverage. Pero hay **3 categorías de daño real** que bloquean invitar al primer amigo beta:

1. **El P0 multi-currency es estructural, no 2 líneas.** Todo el modelo aritmético del portafolio asume single-currency USD. Ocho calculadores (Portfolio aggregates, HHI, Sharpe, TWR, period returns, dividends presenter, weekly insight, concentration) **mienten matemáticamente** para portafolio mixto MXN+USD. `Asset` no tiene `currency`, `Trade` no tiene `fx_rate_at_execution`. **El dashboard de Adrian, hoy, es aritmética sin sentido.**

2. **~25-28% del código no sirve a ningún JTBD canónico.** Toda la capa LLM (Phase 22), risk metrics avanzados, TWR vs benchmarks, HHI/concentration alerts, landing público con "50K traders" fake, /trends público, onboarding wizard de 3 pasos. ~500+ specs sostienen features sin trigger personal documentado.

3. **El landing page miente a los amigos beta.** "Trusted by GlobalBank/DataCore/FinStream", "50K+ Active Traders", "$4.2B Assets Tracked" — clientes y números inventados. Fake testimonials. Para una beta de ≤20 amigos, esto es **daño directo a credibilidad personal de Adrian**.

Lo bueno: arquitectura DDD respetable (con 3-5 fugas localizables), LLM prompts ya tienen guardrails ADR-001 ("Never recommend buying, selling..."), components shared bien factorizados, CETES yield math correcto, empty states bien implementados, brakeman limpio.

---

## Acción items priorizados (insumo para Paso 7)

Estas se vuelven issues en GitHub. Etiquetas tentativas entre paréntesis.

### 🔴 P0 — Bloquea invitar al primer beta

| # | Acción | Etiquetas |
|---|---|---|
| 1 | **Multi-currency estructural fase 1:** `Asset.currency`, `Trade.fx_rate_at_execution`, eliminar hardcode USD en `execute_trade.rb`, agregar `currency` al contract | `P0`, `beta-blocker`, `ctx:trading`, `feat` |
| 2 | **Multi-currency estructural fase 2:** refactorizar calculadores currency-aware (Portfolio aggregates, HHI, Sharpe, TWR, period returns, dividends presenter, weekly insight) | `P0`, `beta-blocker`, `ctx:trading`, `refactor` |
| 3 | **CETES: maturity por posición + alertas de vencimiento** (JTBD #3 hoy no implementado) | `P0`, `ctx:trading`, `ctx:alerts`, `feat` |

### 🟠 P1 — Cleanup grueso antes de cualquier feature nueva

| # | Acción | Etiquetas |
|---|---|---|
| 4 | **Deprecar capa LLM Phase 22 completa** — InsightGenerator, NewsSentimentAnalyzer, FundamentalHealthCheck, EarningsNarrativeGenerator, LlmGateway, anonymizer, 4 views, contracts, ai_insights table+model. ~134 specs, 12 commits. | `P1`, `chore`, `refactor` |
| 5 | **Eliminar superficies para audiencia pública** — landing con fake stats/clientes, `/trends` público, /open-source page (downgrade), onboarding wizard 3 pasos. Root redirige a `/login`. | `P1`, `chore`, `ctx:identity` |
| 6 | **Archivar analytics avanzadas no-JTBD** — Risk Metrics (Sharpe/Vol/MaxDD), TWR + benchmark vs índices, HHI Concentration analyzer + alerts, sentiment-based alerts. | `P1`, `chore`, `ctx:trading`, `ctx:alerts` |
| 7 | **Resolver fuga Trading↔MarketData en dashboard** — `assemble_dashboard` cruza directo. Opciones: (a) BC `Dashboard`/`Composition` que orqueste reads, (b) fusionar Trading+MarketData, (c) read model dedicado. Requiere ADR-002. | `P1`, `refactor`, `ctx:trading`, `ctx:market-data` |

### 🟡 P2 — Calidad de código y disciplina ADR-001

| # | Acción | Etiquetas |
|---|---|---|
| 8 | **Limpieza de events:** borrar 11 events zombie + 4 fantasma | `P2`, `chore` |
| 9 | **Reescribir landing copy** — sin fake social proof, tono observacional honesto sobre estado beta. Aplica también a `sessions/new` (fake testimonial) y `registrations/new`. | `P2`, `docs`, `ctx:identity` |
| 10 | **Reescribir labels prescriptivos sutiles** — "Strong/Parabolic/Weak" → "High/Moderate/Low score"; "Upside/Downside" → "Target Δ%" | `P2`, `docs`, `ctx:market-data` |
| 11 | **Adoptar semantic color tokens del `@theme`** — hoy 0 uso de `bg-success/error/warning`, 189 instancias hardcoded de emerald/rose/amber/violet | `P2`, `refactor` |
| 12 | **Output validation contra blacklist de verbos en LLM** — el guardrail del prompt es esperanza, no garantía. Solo si la capa LLM sobrevive a la decisión de #4. | `P2` (depende de #4), `feat` |
| 13 | **Refactorizar use cases triviales** — 10-15 `update!`/`destroy!` con todo el aparato `ApplicationUseCase` + Contract + Result. Propuesta: `SimpleUseCase` o eliminar UC y llamar desde controller. | `P2`, `refactor` |
| 14 | **Cerrar/archivar designs abandonados** — 4 carpetas en `designs/` sin SPEC.md (workflow PROCESSING.md ignorado). Decidir uno por uno. | `P2`, `docs` |

### 🟢 Lo que NO se toca (validado por audit)

- Arquitectura DDD core (6 BCs declarados; fuga puntuales atacables)
- LLM system prompts (si sobreviven a #4): ya tienen guardrail explícito ADR-001
- CETES yield math (`YieldCalculator` correcto para convención mexicana)
- Empty states + skeleton components
- Components shared (`_asset_badge`, `_sparkline`, `_donut_chart`)
- Auth con `has_secure_password` + sessions
- CI pipeline, brakeman, bundler-audit

---

## ADRs candidatos a escribir (de los hallazgos)

- **ADR-002** — Trading + MarketData boundary (depende de decisión de acción #7)
- **ADR-003** — Sync vs async event handler criterion
- **ADR-004** — Notifications: BC vs librería compartida
- **ADR-005** — Ownership de events cross-BC (¿quién publica `Identity::Events::UserSuspended`?)
- **ADR-006** — Cuándo NO usar ApplicationUseCase (criterio para SimpleUseCase o controller-direct)
- **ADR-007** — Administration ¿es BC propio o admin layer transversal?

---

## Sprint 2 candidato (propuesta)

**Goal sugerido:** *"Multi-currency MXN/USD funcional end-to-end: capturar trade con FX al momento, consolidar gain/loss correcto en MXN."*

**Scope tentativo:** acción items #1 + #2 (los dos P0 multi-currency). Probablemente 2 semanas.

**No incluido en Sprint 2:** deprecaciones (#4-#6) — son posteriores, **no se invita a nadie hasta que P0 esté cerrado**.

---

## Estructura del audit

| Archivo | Contenido |
|---|---|
| `README.md` (este) | Executive summary + acción items |
| [`inventory.md`](./inventory.md) | Inventario crudo por BC, conteos, listados |
| [`diagnosis.md`](./diagnosis.md) | Hallazgos categorizados con paths y líneas |

---

## Cierre brutal (síntesis de los 4 expertos)

- **Hiroto:** *"No es un proyecto roto. Es un proyecto sobre-arquitecturado para 20 usuarios, con boundaries declarados que no se respetan en el código real. La deuda no es técnica, es de honestidad: el código y el README cuentan historias distintas."*
- **Lucía:** *"El núcleo aritmético del portafolio asume USD y eso hace que el producto, hoy, no sirva para su propio owner. Es paradójico que el proyecto se llame Stockerly y el owner tenga CETES como anclaje, y que CETES no sea citizen-class."*
- **Esther:** *"La pregunta no es 'qué más construimos'. La pregunta es: '¿qué retiramos antes de invitar al primer amigo?'."*
- **Renata:** *"El backend Phase 22 sí refleja el ADR. El frontend marketing copy parece haber sido escrito antes del ADR-001 y nunca auditado. Sincronizar."*

**Mi síntesis:** dos sprints concentrados (fix P0 + cleanup grueso) y Stockerly puede honestamente abrir su primer cupo de beta. Sin esos dos sprints, invitar al primer amigo es invitarlo a un dashboard que miente.
