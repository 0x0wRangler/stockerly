# QA Pass — Sprint <N>

> Checklist obligatorio ANTES de escribir `retro.md` y cerrar el sprint.
> Si un item no se cumple → o se documenta por qué en `retro.md`, o el sprint NO se cierra.

---

## Goal & scope

- [ ] **Goal del sprint cumplido** (o documentar gap en retro)
- [ ] **Todos los issues `main`** del scope están cerrados o documentados
- [ ] **Parallel issues** cerrados o explícitamente diferidos
- [ ] **Issues no cerrados**: decidido caso por caso (pasar a backlog o re-asignar a próximo sprint)

## Code health

- [ ] `bundle exec rspec` verde
- [ ] `bin/rubocop` sin offenses
- [ ] `bin/brakeman` sin warnings nuevos (vs baseline anterior)
- [ ] `bin/bundler-audit` sin vulnerabilities
- [ ] CI en GitHub Actions verde
- [ ] Working tree limpio, no commits olvidados

## Vision compliance

- [ ] **Audit manual de copy nuevo** en views — no viola ADR-001 (lenguaje descriptivo, no prescriptivo)
- [ ] **Audit manual de scope** — no features nuevas violan non-goals (fiscal, audiencia pública, recomendaciones)
- [ ] **JTBD mapping** — cada feature/refactor terminado mapea a un JTBD canónico (o tiene ADR justificando)
- [ ] **Discovery card de cada issue** se cumplió: DoD checklist completo

## Documentation

- [ ] **ADR nuevo** escrito si hubo decisión arquitectural significativa
- [ ] **Vision update** si la audiencia/scope cambió (raro, requiere conversación)
- [ ] **Design docs** actualizados si aplica (brand, tokens, components)
- [ ] **Screenshots regenerados** en `docs/screenshots/` si hubo cambios visuales
- [ ] **CLAUDE.md / IDENTITY.md / memory** actualizados si cambió la forma de trabajo

## GitHub hygiene

- [ ] **Issues cerrados** tienen status `Done` en Project board
- [ ] **Milestone listo para cerrar** (todos los issues en estado terminal)
- [ ] **No issues huérfanos** del sprint sin status

## Métrica de uso (verificación post-cierre)

Para cada JTBD que tocó este sprint, documentar:

| JTBD | Métrica esperada | Estado |
|---|---|---|
| #N — ... | "Adrian usa X ≥ N veces/semana" | ✅ verificada / ⚠️ pendiente / ❌ no aplica aún |

---

## Notas adicionales

<!-- Anything that doesn't fit above. -->
