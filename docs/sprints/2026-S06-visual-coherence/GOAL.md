# Sprint Goal

> A single sentence. Non-negotiable during the sprint.
> If the goal needs to be revised mid-sprint, close this sprint early with retro and open a new one.

**Goal:** Cerrar la migración a brand v2 — reescribir el copy prescriptivo (`Parabolic/Strong`, `Upside/Downside`) per ADR-001, reducir ≥60 hits de color hardcoded (141 → ≤80) aplicando tokens semánticos + brand fonts vía clase, y trimear `components.md` (821 → ≤200 líneas) — sin agregar features.

**Sprint period:** 2026-05-15 → ~2026-05-17 (estimated ~22 session-hours, 1.2× factor por refactor con ADRs existentes — calibración S05)

**Sprint number / milestone:** S06 — `2026-S06-visual-coherence`

---

## Why this goal and not another

S05 cerró el último leak arquitectónico (ADR-002 implementado, eventos zombi/ghost limpios, `SimpleUseCase` ADR-006 frontloaded + 9 migraciones). Los 6 JTBDs ya tienen superficie verificable; la arquitectura ya no fuga writes ni reads cruzados. Lo que queda antes de invitar a los primeros amigos beta-cerrada (B+, ≤20) son tres deudas visibles cuando alguien abre la app por primera vez:

- **Copy prescriptivo (#36):** las vistas siguen diciendo "Strong / Parabolic / Upside / Downside" — vocabulario de research broker que ADR-001 prohíbe. Para un primer beta de inversionistas mexicanos, este copy comunica el producto equivocado (señales de compra) y mina la diferenciación que la landing promete (descriptivo, no prescriptivo). Axis #2 (75%) es exactamente esto.

- **Color hardcoded (#37 slice final):** 141 hits restantes de `text-emerald/rose/amber/violet` que no pasan por los tokens semánticos. La migración lleva 4 sprints (S03–S05) y este es el último slice. Target delta ≥60 hits (per S05 retro: "deltas, no absolutos"). Adicionalmente, `font-display` y `font-body` están cargadas en `application.html.erb` pero nunca aplicadas por clase — la app renderiza con la pila default, no con el brand. Cerrar este slice deja el visual coherente extremo a extremo.

- **`components.md` trim (#68):** doc de 821 líneas creada en S02 como spec previa a la implementación. Hoy la mayoría está implementada en `app/views/shared/` y los tokens viven en `tokens.md`. La doc está activamente linkeada desde `brand.md` y `tokens.md` (no es archivable), pero la mayor parte es derivable del código. Carry-over flageado en S02, S03, S04, S05 retros — cuatro veces aplazado.

Además, dos carry-overs operacionales pequeños de S05 retro entran como tareas (no como issues):
- **Refinar `script/audit-entropy.sh`** — el regex de cross-context leaks cuenta `Queries::*.call` sancionados por ADR-002 como violaciones. La métrica reporta UP cuando la regla se cumple. Single commit de opening.
- **Audit `text-X-fg/N` opacity (WCAG AA)** — pattern propagado desde S04 #63 a S05 #67 y rechazado por Gemini. Caso conocido: `admin/dashboard/show.html.erb`. Sub-tarea dentro del slice #37.

Referencias: [S05 retro](../2026-S05-architectural/retro.md), [ADR-001](../../architecture/adr/0001-descriptive-not-prescriptive-language.md), [tokens.md §3-§4](../../design/tokens.md), [vision/audience](../../vision/audience.md).

---

## What's NOT in this sprint (anti-scope)

- **No new features.** Cero adición de superficies de usuario.
- **No tocar TrendScore algoritmo.** #36 solo presentación (copy en views); el cálculo se queda.
- **No ADR-005 (Administration BC publishing foreign events).** Research aparte, fuera de S06.
- **No screenshots regeneration.** Diferido a S07 beta-prep (decisión registrada en S04 retro).
- **No reescritura de copy fuera del scope de #36.** Si Renata flagea labels adicionales durante el sprint, van a issue separada para S07.
- **No `font-mono` adicional.** JetBrains Mono solo en datos financieros tabulares; ya está aplicada donde corresponde.
- **No re-tocar `_kpi_card` ni `_status_badge`** (ya migrados S03/S04).
- **No CETES sells / fixed-income beyond reinvest.** Out-of-scope hasta demanda real.
- **No expandir `components.md`.** #68 es trim-only — si una sección falta en código, queda con `Status: planned`.
- **No abrir S07 antes de retro de S06.** Hard rule del protocolo.
