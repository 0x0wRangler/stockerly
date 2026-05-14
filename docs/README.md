# Stockerly — docs/

> Documentación viva del proyecto. **Cada archivo aquí refleja la realidad actual.** Lo aspiracional/histórico vive en `docs/archive/`.
>
> Estructura establecida en Sprint 1 (2026-05-14).

---

## Cómo navegar

| Si buscas... | Vete a |
|---|---|
| Por qué existe Stockerly, para quién | [`vision/`](./vision/) |
| Decisiones de arquitectura inmutables | [`architecture/adr/`](./architecture/adr/) |
| Cómo están organizados los bounded contexts | [`architecture/README.md`](./architecture/README.md) |
| Sistema de diseño, design tokens | [`design/`](./design/) (placeholder hasta Sprint 2) |
| Notas de investigación, code audits, panel de expertos | [`research/`](./research/) |
| Deploy, security, runbooks | [`ops/`](./ops/) |
| Protocolo de sprint, retros | [`sprints/`](./sprints/) (placeholder hasta Paso 8 del Sprint 1) |
| Branding (logos, paleta, tipografía) | [`branding/`](./branding/) |
| Screenshots para README/showcase | [`screenshots/`](./screenshots/) |
| Documentos archivados (NO son fuente de verdad) | [`archive/`](./archive/) |

---

## Reglas duras

1. **Una fuente de verdad por tipo.** Vision en `vision/`, decisiones en `architecture/adr/`, backlog en GitHub Issues, sprints en GitHub Projects. Nunca duplicar.
2. **Si está en `archive/`, no es verdad actual.** Mapear a su equivalente vivo arriba.
3. **Doc > 200 líneas: auditar.** ¿Es referencia o ficción? La docs útil cabe en una pantalla.
4. **Edits a `vision/` o `architecture/adr/`** requieren commit message con razón.

---

## Documentos del root del repo (referenciados desde aquí)

| Doc | Propósito |
|---|---|
| [`/IDENTITY.md`](../IDENTITY.md) | Rol y compromisos del asistente AI |
| [`/CLAUDE.md`](../CLAUDE.md) | Contexto técnico que el asistente AI lee automáticamente |
| [`/README.md`](../README.md) | Presentación pública del proyecto |
| [`/CONTRIBUTING.md`](../CONTRIBUTING.md) | (Reservado — beta cerrada, no aceptamos PRs hasta v1.0) |
| [`/RELEASING.md`](../RELEASING.md) | Proceso de release |
| [`/CHANGELOG.md`](../CHANGELOG.md) | Historial de cambios significativos |
| [`/SECURITY.md`](../SECURITY.md) | Cómo reportar vulnerabilidades |

---

## Memoria persistente del asistente AI

Vive en [`../.claude/memory/`](../.claude/memory/). Es trackeada en git y carga automática del asistente. Contiene perfil del usuario, vision, decisiones, anti-patterns y mandato de honestidad brutal.
