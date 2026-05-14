# Archivo histórico — Stockerly

> ⚠️ **Lo que está aquí NO es fuente de verdad del proyecto actual.**
> Se conserva por valor histórico y como referencia de cómo evolucionó Stockerly. Si una decisión actual contradice algo aquí, **manda la decisión actual** (en `docs/vision/` o `docs/architecture/adr/`).

---

## Por qué archivamos en lugar de borrar

1. **Historia del producto.** Las 22 fases completadas entre Phase 0 y Phase 22 tienen valor como evidencia de aprendizaje y como audit trail.
2. **Referencia técnica.** Algunos detalles (modelado de BD, comandos antiguos) pueden ser útiles al hacer code audit o entender por qué algo es como es.
3. **Portfolio público.** Mostrar el journey (incluyendo correcciones) es más valioso que mostrar solo el estado final.

---

## Contenido

### `spec-2026-Q1/`

Especificaciones aspiracionales del proyecto al cierre de Q1 2026 (justo antes del reset del 2026-05-14):

| Archivo | Por qué se archivó |
|---|---|
| `PRD.md` | Describía 3 personas (trader activo, inversionista casual, admin) cuando el usuario real es uno. Reemplazado por `docs/vision/audience.md` y `docs/vision/jobs-to-be-done.md`. |
| `TECHNICAL_SPEC.md` | Spec técnica de 684 líneas con detalle de routes/layouts/partials/Stimulus controllers — mezclaba arquitectura con detalle de implementación. Lo arquitectural vivo está en `docs/architecture/`. Lo de implementación está en el código. |
| `COMMANDS.md` | Catálogo aspiracional de 2163 líneas con use cases, events, gateways. Estaba desincronizado con el código real (60 use cases catalogados vs 68 reales). Reemplazado por READMEs por bounded context (a crear en sprints siguientes) y por el código mismo como fuente. |
| `DATABASE_SCHEMA.md` | Modelado de BD de 1345 líneas. La fuente de verdad real es `db/schema.rb`. Mantener un doc paralelo era doc bloat. |
| `EXPERTS-v1.md` | Panel de expertos en lista plana de 10. Reemplazado por `docs/research/experts.md` (8 Core + 8 Situational con triggers y operating rules). |

### `roadmap-phases-1-22.md`

Antes vivía en la raíz como `ROADMAP.md`. Es el registro cronológico de las 22 fases completadas hasta el 2026-05-14. **No es roadmap futuro** — es history log. El roadmap actual vive en GitHub (milestones del proyecto).

---

## Cómo se traduce algo del archivo a la realidad actual

| Si encuentras en archivo... | Su equivalente actual es... |
|---|---|
| PRD "F-001: Landing Page" | Decisión 2026-05-14: no hay landing comercial. Ver `docs/vision/non-goals.md`. |
| PRD "F-013: Mi Perfil con avatar editable" | Vivo en código, audit pendiente Sprint 1 Paso 6 |
| COMMANDS.md "Identity::Register" | Código real en `app/contexts/identity/use_cases/register.rb` |
| COMMANDS.md catálogos de eventos | `config/initializers/event_subscriptions.rb` es la fuente real |
| TECHNICAL_SPEC "Bounded Contexts" | `docs/architecture/README.md` (mapa actualizado) |
| EXPERTS-v1 "QA Engineer" | EXPERTS-v2 (`docs/research/experts.md`) S8 Mehmet Karadeniz |
| ROADMAP "Phase 23 — TBD" | No existe. Sprint 1 reemplaza el modelo de "fases" por sprints con discovery cards. |

---

## Cómo se agrega algo al archivo

Cuando un documento de `docs/` deja de reflejar la realidad y se reemplaza por otro:

1. Mover a `docs/archive/<categoria>-<periodo>/`
2. Agregar nota al final del README de archive explicando por qué
3. Buscar referencias al doc viejo y actualizarlas (grep)
4. Commit con razón explícita

---

## Cómo se elimina algo del archivo

Cuando un documento histórico deja de tener valor de referencia:

- Después de 1+ año sin consulta (audit trimestral)
- Si su contenido fue migrado completamente a docs vivos
- Si compromete portfolio público (ej. menciona credenciales reales)

→ borrar en commit explícito con razón. Git history lo preserva igual.
