# Arquitectura — Stockerly

> Mapa de los bounded contexts y referencia a decisiones inmutables. Esta es la **vista de una pantalla** de la arquitectura; el detalle vive en el código.

---

## Stack

- **Backend:** Rails 8.1.2, Ruby 3.3.6
- **BD:** PostgreSQL 16 (primary + Solid Cache + Solid Queue + Solid Cable)
- **Frontend:** Hotwire (Turbo + Stimulus) + Tailwind CSS 4 + Propshaft + Import Maps
- **Domain stack:** dry-monads, dry-validation, dry-types, dry-struct, dry-initializer
- **Testing:** RSpec + FactoryBot + Capybara
- **Deploy:** Kamal 2 + Cloudflare Tunnel + GitHub Actions
- **Observabilidad:** Sentry + lograge structured logs

---

## Bounded Contexts

Stockerly tiene **6 bounded contexts** en `app/contexts/`. Cada uno owns sus contracts, domain logic, events, handlers y use cases.

| Context | Path | Responsabilidad |
|---|---|---|
| **Identity** | `app/contexts/identity/` | Registro, autenticación, perfil, password reset, email verification, audit logging |
| **Trading** | `app/contexts/trading/` | Trades, posiciones, portafolios, watchlists, splits, snapshots, dashboard |
| **Alerts** | `app/contexts/alerts/` | Reglas de alerta, evaluación, triggering (precio, sentiment, volume, concentration) |
| **MarketData** | `app/contexts/market_data/` | Gateways externos, sync de precios/fundamentals/news/earnings, indices, F&G, fundamentals |
| **Administration** | `app/contexts/administration/` | CRUD de assets, gestión de integraciones, API key pools, system logs, health |
| **Notifications** | `app/contexts/notifications/` | Creación y entrega de notificaciones in-app |

> **Nota histórica:** la documentación original (`docs/archive/spec-2026-Q1/TECHNICAL_SPEC.md`) decía "5 bounded contexts". `Notifications` apareció en código después y la doc nunca se actualizó. La verdad es 6, no 5.

---

## Estructura interna de cada bounded context

```
app/contexts/{context_name}/
├── contracts/     # dry-validation: input validation en la frontera
├── domain/        # Lógica pura (calculators, evaluators, presenters, value objects)
├── events/        # dry-struct: eventos inmutables del dominio
├── gateways/      # Faraday HTTP adapters (solo MarketData)
├── handlers/      # Reacción a eventos (sync o async)
└── use_cases/     # Orquestación con dry-monads (Success/Failure)
```

---

## Shared infrastructure

En `app/shared/` (autoload por Zeitwerk sin namespace prefix):

| Path | Contiene |
|---|---|
| `shared/base/` | `ApplicationUseCase`, `ApplicationContract` |
| `shared/domain/` | `CircuitBreaker`, `RateLimiter`, `GatewayChain`, `KeyRotation`, `DataSourceRegistry`, `MarketHours`, `GainLoss`, `RiskMetrics`, `HealthMetrics` |
| `shared/events/` | `BaseEvent`, `EventBus` |
| `shared/types/` | `Types` (dry-types) |

---

## Flujo típico

```
HTTP Request
    ↓
Controller (delgado, solo HTTP ↔ Use Case)
    ↓
UseCase.call(params)
    ↓
    ├── validate(Contract, params) → Success(attrs) | Failure([:validation, errors])
    ├── domain logic / queries
    └── publish(event)
        ↓
    EventBus.publish
        ├── sync handlers (immediate)
        └── async handlers via ProcessEventJob (Solid Queue)
    ↓
Controller pattern-matches Result
    ↓
Turbo Stream / HTML response
```

---

## Cross-context communication

**Regla:** los contextos se comunican **solo via Domain Events**. No hay imports directos cross-context.

```ruby
# Ejemplo: MarketData publica → Alerts subscribe
EventBus.subscribe(
  MarketData::Events::AssetPriceUpdated,
  Alerts::Handlers::EvaluateAlertsOnPriceUpdate
)
```

Las suscripciones están cableadas en `config/initializers/event_subscriptions.rb`.

> **Fugas actuales conocidas** (a documentar en code audit del Sprint 1 Paso 6):
> 1. `Trading::UseCases::AssembleDashboard` llama directo a modelos de MarketData (no via evento). Anti-pattern de "god-dashboard use case".
> 2. `MarketData::UseCases::GeneratePortfolioInsight` llama `Trading::Domain::ConcentrationAnalyzer` directo.
> 3. `Alerts::Handlers::CreateNotificationOnAlert` llama un use case de Notifications directo (defendible pero rompe la regla).
>
> Estas fugas se evaluarán para resolución en sprints siguientes (no son P0).

---

## Decisiones de arquitectura

Las decisiones inmutables viven en [`adr/`](./adr/) como ADRs (Architecture Decision Records).

| ADR | Título | Estado |
|---|---|---|
| [0001](./adr/0001-descriptive-not-prescriptive-language.md) | Lenguaje descriptivo, nunca prescriptivo | Accepted (2026-05-14) |

> ADRs futuras a considerar (no escritas aún):
> - ADR sobre dry-monads: cuándo usarlas, cuándo NO (CRUD trivial)
> - ADR sobre EventBus sync vs async
> - ADR sobre ActiveRecord como driven adapter (no Repository pattern)
> - ADR sobre cuándo crear nuevo bounded context vs subcarpeta
> - ADR sobre cross-context: regla de "solo eventos" + excepciones documentadas

---

## Autoloading (Zeitwerk)

Configurado en `config/application.rb`. Reglas:

- `app/contexts/{ctx}/domain/foo.rb` → `Ctx::Domain::Foo`
- `app/contexts/{ctx}/gateways/foo_gateway.rb` → `Ctx::Gateways::FooGateway`
- `app/contexts/{ctx}/events/foo_happened.rb` → `Ctx::Events::FooHappened`
- `app/shared/domain/foo.rb` → `Foo` (sin prefix por collapse)

Si se crea un nuevo bounded context, hay que registrar su namespace en `application.rb`.

---

## Para extender Stockerly con un nuevo bounded context

Steps (manual hoy; generator pendiente como mejora futura):

1. Crear `app/contexts/{name}/` con las 5-6 subcarpetas estándar
2. Registrar autoload en `config/application.rb`
3. Crear primer use case + contract + tests
4. Cablear suscripciones a eventos en `config/initializers/event_subscriptions.rb`
5. Actualizar la tabla de "Bounded Contexts" en este README
6. Considerar si la decisión amerita un ADR (probablemente sí — nuevo BC es decisión grande)
