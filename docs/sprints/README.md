# Sprints — Stockerly

> Protocolo de sprint operativo. Esta carpeta contiene **una subcarpeta por sprint** con GOAL, scope, log, QA y retro. Plantilla en [`_template/`](./_template/).
>
> Establecido en Sprint 1 (2026-05-14).

---

## Estructura

```
docs/sprints/
├── README.md                  ← Este archivo (protocolo)
├── _template/                 ← Plantilla a copiar al inicio de cada sprint
│   ├── GOAL.md
│   ├── scope.md
│   ├── log.md
│   ├── qa.md
│   └── retro.md
├── 2026-S01-reset/            ← Sprint 1 (creado retroactivamente)
│   └── retro.md
├── 2026-S02-truth-foundation/ ← Sprint 2 (a crear al inicio)
│   └── ...
└── ...
```

Cada sprint corresponde a un **GitHub Milestone** del mismo nombre. El sprint vive en dos lugares:
- **GitHub:** Milestone (goal en descripción), issues asignados, Project board
- **docs/sprints/<n>/:** GOAL.md, scope.md, log.md, qa.md, retro.md (long-form, persistente)

Regla dura: **una fuente por tipo, nunca duplicar.** Lo state-ful vive en GitHub; lo long-form (retro, post-mortem, decisiones tomadas durante el sprint) vive en `docs/sprints/<n>/`.

---

## Protocolo

### 1. Apertura (1 sesión, ≤30 min)

1. **Cierra el sprint anterior primero.** Regla dura: no se abre nuevo sprint con anterior abierto (sin retro escrito).
2. **Copia `_template/`** a `docs/sprints/<sprint-name>/` (formato `YYYY-S<n>-<theme-kebab>`).
3. **Escribe el goal del sprint** en `GOAL.md` (una sola frase, no negociable).
4. **Sincronízalo a GitHub Milestone description** (no duplicar — referenciar).
5. **Selecciona issues con label `ready`** que mapean al goal. Asigna al milestone via `gh issue edit N --milestone "..."`.
6. **Llena `scope.md`** listando issues seleccionados + razón breve.
7. **Verifica restricciones:**
   - Max 7 issues en `In Progress` simultáneamente
   - Si hay issues con `parallel` label, deben ser ≤30% del esfuerzo total estimado
   - Cada issue tiene discovery card completa (sin `discovery-needed`)
8. **Mueve issues a "In Progress" en Project board** conforme empieces a trabajarlos (no todos a la vez).

### 2. Ejecución

- **Cada commit referencia el issue:** `feat(trading): capture FX at execution [#27]`
- **Notas no-triviales durante la ejecución** → `log.md` (decisiones, problemas, expertos consultados). NO es un journal diario; es para "lo que me costó descubrir y querría recordar".
- **PR linkea issue con `Fixes #N`** para auto-cerrar al merge
- **Si descubres trabajo nuevo** → abrir issue separado (no inflar el sprint actual). Decidir si entra a este sprint o pasa al siguiente.
- **Si un issue se bloquea** → label `blocked`, comentario explicando, considerar moverlo de milestone.

### 3. Cierre (1 sesión, 60-90 min)

#### QA pass (obligatorio antes de cerrar)

Llenar `qa.md` (copia del template) y verificar:

- [ ] **Goal del milestone se cumplió** (o documentar por qué no en retro)
- [ ] **CI verde local:** `bundle exec rspec`, `bin/rubocop`, `bin/brakeman`, `bin/bundler-audit`
- [ ] **No copy nuevo viola ADR-001** (audit manual de diffs de views)
- [ ] **No features nuevas violan non-goals** (audit manual de scope)
- [ ] **Discovery card de cada issue se cumplió** (DoD checklist)
- [ ] **Métrica de uso** de cada JTBD afectado: verificada o documentada como pendiente de medir
- [ ] **Screenshots regenerados** en `docs/screenshots/` si hubo cambios visuales
- [ ] **Issues cerrados** tienen status `Done` en Project board
- [ ] **Documentación actualizada** si aplica (ADR nuevo, vision update, design.md, etc.)
- [ ] **Working tree limpio**, sin commits pendientes

#### Retro

Escribir `retro.md` siguiendo el template. Mínimo:
- **¿Qué funcionó?** (replicar)
- **¿Qué no funcionó?** (corregir)
- **¿Qué cambiar para el próximo sprint?** (acción concreta)
- **¿Cuáles de los 6 ejes de alineación subieron?** Indica % aproximado o estado por eje:
  1. Cada feature mapea a JTBD
  2. Cero copy prescriptivo
  3. Cero copy aspiracional falso
  4. Aritmética del dashboard veraz para MXN+USD
  5. Arquitectura sin fugas cross-context
  6. Docs reflejan código
- **Tiempo real vs estimado** (calibración para futuros sprints)
- **Antipatrón violado, si hubo** (referencia a `.claude/memory/feedback_anti_patterns.md`)

#### Cierre formal

1. **Cerrar el milestone** en GitHub (`gh api repos/.../milestones/N -X PATCH -f state=closed`)
2. **Issues no cerrados** → decidir caso por caso (pasar a backlog sin milestone o re-asignar al próximo sprint)
3. **Commit del retro** con mensaje `retro(<sprint>): close — <one-line takeaway>`
4. **Push a origin**
5. **Anti-pattern guard:** no abrir siguiente sprint en la misma sesión. Tomar al menos 24h de pausa para procesar.

---

## Naming conventions

### Sprint folders

`YYYY-S<n>-<theme-kebab>` — ejemplos: `2026-S01-reset`, `2026-S02-truth-foundation`, `2026-S03-jtbd-alignment`

El número del sprint es **secuencial al proyecto**, no del año. Si el proyecto dura años, el contador no se resetea.

### Sprint themes

Cada sprint tiene un theme corto (1-3 palabras) que describe el foco principal. Visible en el folder name y en el milestone title.

### Commit prefixes

- `feat(<ctx>):` — nueva funcionalidad
- `refactor(<ctx>):` — cambio interno
- `chore:` — mantenimiento, cleanup
- `docs:` — solo documentación
- `fix:` — bug fix
- `test:` — solo tests
- `retro(<sprint>):` — sprint retro commit

Sin `Co-Authored-By` (regla del proyecto).

---

## Reglas duras (no negociables)

1. **No nuevo sprint con anterior abierto.** El anterior está cerrado solo cuando `retro.md` existe y el milestone está closed.
2. **No issue sin discovery card.** Issues con `discovery-needed` no son elegibles para entrar a un sprint.
3. **No más de 7 issues `In Progress` simultáneamente.** Si se llega al límite, no se abren nuevos; se cierran existentes.
4. **No skipping QA antes de cerrar.** El QA pass no es opcional aunque "se vea fácil cerrar". 
5. **Retro escrito o sprint no cerrado.** Sin retro, no se avanza.
6. **Parallel work máximo 30% del esfuerzo.** Si un sprint tiene más esfuerzo parallel que main, está mal scoped.

---

## Referencias

- [Vision README](../vision/README.md) — el norte
- [JTBDs](../vision/jobs-to-be-done.md) — los 6 canónicos
- [Working method memory](../../.claude/memory/project_working_method.md) — versión del asistente AI
- [GitHub workflow](../ops/github-workflow.md) — manual de cómo usamos GitHub
- [Anti-patterns](../../.claude/memory/feedback_anti_patterns.md) — qué evitar
