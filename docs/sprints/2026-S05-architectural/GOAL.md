# Sprint Goal

> A single sentence. Non-negotiable during the sprint.
> If the goal needs to be revised mid-sprint, close this sprint early with retro and open a new one.

**Goal:** Eliminar el último leak unidireccional Trading→MarketData implementando ADR-002, limpiar 11 zombies + 4 ghost events, y reducir ~30% del scaffolding ceremonial mediante SimpleUseCase (con ADR-006 frontloaded) — sprint puramente arquitectónico, sin nuevos features.

**Sprint period:** 2026-05-15 → ~2026-05-18 (estimated ~27 session-hours, 1.3× factor por refactor con patrones cercanos)

**Sprint number / milestone:** S05 — `2026-S05-architectural`

---

## Why this goal and not another

S04 cerró los 6 JTBDs canónicos con superficies en producto (axis #1: 80% → 95%). El cuello de botella restante es interno: la arquitectura tiene ceremonia desproporcionada (ApplicationUseCase + dry-monads + Contract para 13 líneas que solo hacen `update!`), eventos zombi que confunden ("¿esto se ejecuta?"), y un leak Trading↔MarketData que ya tiene ADR escrita pero no implementada.

S05 es un sprint donde **no se agrega ninguna feature visible al usuario**. Es deliberadamente operacional. La razón: si abrimos beta con esta deuda, cada nuevo amigo que mira el código (o yo mismo en 6 meses) aprende el patrón equivocado por inercia. Lo correcto es resolver antes de invitar más colaboradores.

Tres piezas se entrelazan:
- **#33 (P1)**: implementa la decisión de [ADR-002](../../architecture/adr/0002-trading-marketdata-boundary.md) — extrae 4 read queries de MarketData, refactoriza AssembleDashboard, envuelve FxRateResolver, y enmienda CLAUDE.md.
- **#35 (P2)**: borra 5 eventos ghost (clases declaradas que nadie publica ni escucha) y decide caso por caso 6 eventos zombie (publicados sin suscriptor — algunos pueden valer la pena con audit log, otros se eliminan).
- **#38 (P2, blocked)**: frontload ADR-006 como primer commit del PR, crear `SimpleUseCase` base, migrar 10 use cases triviales (Identity, Notifications, Trading, Alerts, Administration). Patrón mecánico una vez que la base existe.

El paralelo es modesto: **#37 slice S05** (2 componentes + 1 vista a tokens semánticos, continuando S3-S6).

Referencias: [Diagnosis 2026-05](../../research/code-audit-2026-05/diagnosis.md), [Inventory 2026-05](../../research/code-audit-2026-05/inventory.md), [S04 retro](../2026-S04-jtbd-gap-fill/retro.md).

---

## What's NOT in this sprint (anti-scope)

- **No new features.** Cero adición de superficies de usuario. Si aparece una idea de feature, va a backlog con discovery card vacía (`discovery-needed`).
- **No ADR-007 (Administration BC question).** Es un research significativo que merece su propio sprint o slot dedicado. Si el orden natural lo demanda, lo abrimos como issue suelto pero no entra a S05 scope.
- **No implementación de las decisiones zombi.** Si un evento zombi requiere un audit log handler completo, abrimos un issue separado para S06+. S05 solo decide "borrar vs mantener con handler simple".
- **No reescritura de copy prescriptivo.** S06 (#36).
- **No expansion del brand migration.** Solo el slice S05 de #37 (2 componentes + 1 vista). El resto a S06.
- **No tocar el unified `_kpi_card` o `_status_badge`** (ya migrados en S03/S04 — no doble-tocar).
- **No screenshots regeneration.** Diferido a S07 beta-prep por decisión registrada en S04 retro.
- **No CETES sells o fixed-income beyond reinvest.** El comentario en `find_or_create_position` del PR #61 documentó el caso edge; permanece out-of-scope hasta que aparezca demanda real.
- **No ADR-003 (sync vs async handler criterion).** Mencionado en S04 retro's references list, pero out-of-scope salvo que aparezca un caso concreto durante #35.
