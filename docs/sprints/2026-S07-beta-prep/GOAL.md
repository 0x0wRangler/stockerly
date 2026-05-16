# Sprint Goal

> A single sentence. Non-negotiable during the sprint.
> If the goal needs to be revised mid-sprint, close this sprint early with retro and open a new one.

**Goal:** Dejar el sistema listo para invitar al primer amigo a beta cerrada — LFPDPPP cumplida, invite-by-code single-use funcional, onboarding mínimo sin wizard, y runbook de soporte documentado.

**Sprint period:** 2026-05-15 → TBD (cerrar por QA + retro, no por fecha)

**Sprint number / milestone:** S07 — 2026-S07-beta-prep

---

## Why this goal and not another

Cerramos S06 con axis #2 en 90% (copy prescriptivo) y axis #6 en 97% (docs/code drift). La vision foundation está sólida. El siguiente bloqueador para la **beta cerrada B+** (≤20 amigos invitados, decidida 2026-05-14) no es técnico ni de diseño — es **operacional + legal**:

1. **Sin aviso de privacidad LFPDPPP**, invitar a un mexicano a usar la plataforma con sus datos personales es un riesgo legal real (la ley federal exige notice antes de tratamiento de datos).
2. **Sin invite-by-code single-use**, no hay control de acceso para "≤20 invitados" — cualquiera con la URL puede registrarse.
3. **Sin onboarding mínimo**, el primer amigo verá `/register` y luego un dashboard vacío sin contexto. Hay que decirle al menos "esto es beta, así se reporta un bug, así me contactas".
4. **Sin runbook**, cuando el primer amigo me reporte algo no tengo un proceso — improviso, y eso es lo que el método de trabajo (ver `project_working_method.md`) intenta evitar.

El JTBD que se desbloquea es indirecto: ninguno de los 6 JTBDs canonical es "tener un sistema de invitaciones", pero **sin esto los 6 JTBDs no se pueden validar con usuarios reales**. Es infrastructure de producto, no feature de producto.

---

## What's NOT in this sprint (anti-scope)

- **No onboarding wizard de 3 pasos.** El milestone dice "minimal onboarding (no 3-step wizard)" explícitamente. Sin modales encadenados, progress bars de "paso 1 de 3", ni tutoriales interactivos con tooltips/highlights. ~~Si requiere más de 1 vista nueva → fuera de scope.~~ **Anti-scope original revisado 2026-05-16:** el item de onboarding (#77) crece a 3 vistas (`/welcome`, `/help`, `/report-bug`) + mailer por override consciente — guía estática + bug-report form son ambos necesarios para el primer invite. Decisión documentada en `log.md`. Lo que sigue fuera de scope: cualquier flow interactivo con Stimulus controllers para tooltips/highlights.
- **No public-signup en paralelo.** Beta cerrada significa invite-only. No hay flag de "abrir registro público" en este sprint; viene cuando se valide la beta.
- **No otros carry-overs del S06 retro:** Lumen palette adoption queda para S08+ con su propio ADR. Sparkline dynamic-class audit gap queda como chore de backlog. (Excepción: **#70 TrendScore enum rename** SÍ entra al sprint — ver `scope.md`. Es el único cleanup interno que se admite porque cierra coherencia ADR-001 model-layer y el retro de S06 ya lo había marcado como candidato a slot S07.)
- **No expansión de feature surface.** Cualquier "ya que estamos, agreguemos X" que aparezca durante el sprint se rechaza por default. Beta-prep es operacional, no es ventana para features.
- **No analytics ni telemetry.** Métricas de uso de la beta (cuántos amigos activos, cuáles features usan) son útiles pero no bloquean el primer invite. Backlog.
