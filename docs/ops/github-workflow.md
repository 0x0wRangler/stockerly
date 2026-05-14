# GitHub Workflow — Stockerly

> Manual operativo de cómo usamos GitHub Issues + Projects + Milestones + Labels.
> Establecido en Sprint 1 (2026-05-14). Referencia obligada antes de abrir un issue o un PR.

---

## Estructura

| Elemento | Dónde |
|---|---|
| **Backlog items + bugs + research** | GitHub Issues |
| **Sprint board (visual)** | GitHub Project v2 "Stockerly v2 Roadmap" |
| **Sprint name + goal** | GitHub Milestone (uno por sprint) |
| **Taxonomía de issues** | Labels (tipo, contexto, prioridad, estado, especiales) |
| **Templates para crear issues** | `.github/ISSUE_TEMPLATE/*.yml` |
| **Template para PRs** | `.github/PULL_REQUEST_TEMPLATE.md` |
| **Long-form docs** | `docs/` (NO duplicar en issues) |

---

## Setup actual (2026-05-14)

### Repo

- **URL:** [github.com/rodacato/stockerly](https://github.com/rodacato/stockerly)
- **Visibilidad:** público
- **Audiencia:** beta cerrada con ≤20 amigos (no aceptamos PRs externos hasta v1.0)
- **CI:** GitHub Actions (test, security, deploy)

### Project v2

- **Nombre:** `Stockerly v2 Roadmap`
- **Number:** 6
- **Owner:** rodacato (user-scoped, no org)
- **Status field (default):** `Todo` → `In Progress` → `Done` (simple, no se customizó)
- **Items:** issues se agregan via `gh project item-add 6 --owner rodacato --url <issue-url>`

> **Nota:** No se customizó el Status field con columnas adicionales (Triage/Ready/In Sprint/In Review). En su lugar, el estado del workflow se lee combinando **labels** (`triage`, `ready`, `blocked`) y **Status del project** (`Todo`, `In Progress`, `Done`). Más simple. Si en el futuro se necesita board más rico, se customiza vía UI.

### Milestones (sprints)

| # | Milestone | Sprint goal (resumen) |
|---|---|---|
| 1 | `2026-S02-truth-foundation` | P0 multi-currency fase 1 + kill landing fake + Brand Discovery parallel |
| 2 | `2026-S03-jtbd-alignment` | Calculadores currency-aware + deprecar LLM + cleanup analytics no-JTBD |
| 3 | `2026-S04-jtbd-gap-fill` | CETES maturity + JTBD #6 "Observaciones notables" |
| 4 | `2026-S05-architectural` | ADR-002 + cleanup eventos + SimpleUseCase |
| 5 | `2026-S06-visual-coherence` | Landing/login con brand v2 + migración tokens final |
| 6 | `2026-S07-beta-prep` | LFPDPPP + invite codes + onboarding mínimo |

Goal completo de cada milestone está en su descripción en GitHub (visible al abrir el milestone).

### Labels (taxonomía)

**Type** (tipo de trabajo):
- `feat` — nueva funcionalidad mapeada a un JTBD
- `bug` — defecto en funcionalidad existente
- `chore` — mantenimiento, cleanup, deprecación
- `docs` — cambios solo en documentación
- `refactor` — cambio interno sin afectar comportamiento
- `research` — pregunta abierta a investigar antes de scope

**Context** (bounded context tocado):
- `ctx:trading`, `ctx:market-data`, `ctx:alerts`, `ctx:identity`, `ctx:notifications`, `ctx:admin`

**Priority**:
- `P0` — beta-blocker o rompe JTBD core
- `P1` — cleanup/refactor antes de features nuevos
- `P2` — quality / polish

**State**:
- `triage` — nuevo, sin revisar (default en templates)
- `ready` — discovery complete, listo para sprint
- `blocked` — esperando dependencia o decisión

**Special**:
- `discovery-needed` — falta uno o más campos de discovery card
- `beta-blocker` — no se invita amigos hasta resolver
- `design` — diseño / visual / UX
- `parallel` — eje parallel en sprint con goal principal distinto

---

## Cómo abrir un issue

### Feature / Refactor / Chore / Docs

1. Ve a [New Issue](https://github.com/rodacato/stockerly/issues/new/choose)
2. Selecciona "Feature / Refactor / Chore"
3. Llena los 4 campos de Discovery Card:
   1. **Trigger personal documentado** (fecha + situación específica)
   2. **JTBD** ("Cuando X, quiero Y, para Z" — debe mapear a uno de los 6 canónicos o justificar nuevo)
   3. **Métrica de uso**
   4. **Definition of Done** (checklist concreto)
4. Si no puedes llenar los 4 → el issue queda con `discovery-needed` y `triage`
5. Aplica labels de tipo, contexto, prioridad
6. Asigna milestone si ya sabes a qué sprint pertenece

### Bug

1. Selecciona "Bug" template
2. Indica qué pasó, qué esperabas, pasos para reproducir
3. **NO incluyas datos financieros reales** (montos, posiciones, account IDs) — usa ejemplos sintéticos
4. Aplica label `bug` + `ctx:*` + severity

### Research

1. Selecciona "Research" template
2. Indica pregunta abierta, por qué importa, hipótesis, criterio de cierre
3. Lista expertos del panel a consultar (en `docs/research/experts.md`)
4. Output esperado: ADR + posible feature issue subsecuente

---

## Cómo abrir un PR

1. Fixea un issue: en commit o PR body usa `Fixes #N` (auto-cierra al merge)
2. Llena el PR template (`.github/PULL_REQUEST_TEMPLATE.md`):
   - Qué hace el PR (1-3 frases, why before what)
   - Linked issue
   - Checklist obligatorio:
     - Tests pasan
     - Rubocop limpio
     - ADR-001: no prescriptive language
     - Vision: no fiscal additions
     - No co-author en commits
     - Discovery card completa (si es feat)
     - ADR existe (si es refactor arquitectural)
3. Commits sin `Co-Authored-By` ni mención de AI

---

## Sprint protocol

### Planning

1. Lee los issues con label `ready` que no tienen milestone asignado
2. Lee el goal del próximo milestone (`gh api repos/rodacato/stockerly/milestones`)
3. Mueve issues al milestone — máximo 7 simultáneamente en `In Progress` (regla dura)
4. Define **1 frase de goal** en la descripción del milestone (si no está)
5. Si un issue tiene `parallel` label, está OK que el milestone tenga goal distinto — los parallel cumplen al menos 30% del esfuerzo del sprint

### Execution

1. Cada commit referencia el sprint (ej. `feat(trading): capture FX at execution [#27]`)
2. Mueve issue de `Todo` → `In Progress` en Project board al empezar
3. PR linkea issue con `Fixes #N`
4. Mueve a `Done` al merge

### Close

**Antes de marcar sprint como cerrado:**

- [ ] Goal del milestone se cumplió o se documentó por qué no
- [ ] CI verde (`bundle exec rspec`, `bin/rubocop`, `bin/brakeman`, `bin/bundler-audit`)
- [ ] No copy nuevo viola ADR-001 (audit manual)
- [ ] No features nuevas violan non-goals (audit manual)
- [ ] Sprint retro escrito en `docs/sprints/<sprint-name>/retro.md`
- [ ] Retro responde: ¿qué funcionó / qué no / qué cambiar / cuáles de los 6 ejes de alineación subieron?
- [ ] Issues cerradas tienen status `Done` en el project

**Regla dura:** no se abre siguiente sprint con anterior abierto. Si hay issues sin cerrar al final, deciden:
- Pasar a backlog (sin milestone) si ya no son urgentes
- Re-asignar a próximo milestone si siguen vivos

---

## Comandos útiles (`gh` CLI)

```bash
# Listar issues abiertos por milestone
gh issue list --milestone "2026-S02-truth-foundation"

# Listar issues con label
gh issue list --label "P0"

# Ver un issue completo
gh issue view 27

# Listar milestones
gh api repos/rodacato/stockerly/milestones --jq '.[] | "[\(.number)] \(.title)"'

# Listar items del project
gh project item-list 6 --owner rodacato

# Agregar issue al project
gh project item-add 6 --owner rodacato --url https://github.com/rodacato/stockerly/issues/N
```

---

## Errores comunes a evitar

1. **Crear issue sin discovery card completa** → queda en `triage` con `discovery-needed`. No avanza a `ready` hasta que se complete. No se trabaja en él.
2. **Duplicar info entre issue y `docs/`** → docs son para evergreen (vision, ADR, design system, research notes); issues son para state-ful work. Si el issue describe arquitectura, link al ADR, no la copies.
3. **Issues con info sensible** → repo es público. NO incluir montos, account numbers, screenshots de datos personales reales. Usar ejemplos sintéticos.
4. **Co-author en commits** → prohibido por convención del proyecto (memoria `feedback_no_coauthor.md`).
5. **Abrir nuevo sprint con anterior abierto** → no se hace.
6. **Saltarse QA antes de cerrar sprint** → no se hace. La trampa más común es "los tests pasan, ship it" sin validar ADR-001 / non-goals manualmente.

---

## Cómo refrescar `gh` auth (si Project v2 no funciona)

```bash
gh auth refresh -s project,read:project
```

Los scopes actuales requeridos: `repo`, `workflow`, `read:org`, `gist`, `project`, `read:project`.

---

## Referencias

- [Vision](../vision/README.md) — norte y 3 reglas duras
- [JTBDs](../vision/jobs-to-be-done.md) — los 6 canónicos
- [Non-goals](../vision/non-goals.md) — lo que NO somos
- [ADR-001](../architecture/adr/0001-descriptive-not-prescriptive-language.md) — lenguaje del producto
- [Code Audit 2026-05](../research/code-audit-2026-05/README.md) — insumo del backlog inicial
- [Expert Panel](../research/experts.md) — consultas estructuradas
- [Working method memory](../../.claude/memory/project_working_method.md) — versión persistente del asistente AI
