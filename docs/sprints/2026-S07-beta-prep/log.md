# Log — Sprint S07 (beta-prep)

> NON-trivial notes during execution. **Not a daily journal.** Only what you'd want to remember when reviewing this sprint in 6 months.

---

## 2026-05-15 — Sprint opening: 24h-pause hard rule violated (segunda vez consecutiva)

**Decisión consciente, no por inercia.** S06 cerró hoy 2026-05-15 con commit `f85898f`. La hard rule del protocolo (`docs/sprints/README.md` §3 close paso 5) dice: *"don't open the next sprint in the same session. Take at least 24h pause to process."* La regla se diseñó como guard contra anti-pattern #1 ("Next phase = next thing to build" — rushed scoping driven by anxiety to ship).

**Esta es la segunda violación consecutiva** (la primera fue S05→S06, documentada en S06 retro). El retro de S06 concluyó honestamente: *"keep the rule; the override needs to remain explicit and rare"*. Y aquí estoy, otra vez, overrideándola.

**Justificación honesta:**

- El scope de S07 estaba **pre-baked en la descripción del milestone desde el opening de S06** (literalmente la planeación previa identificó LFPDPPP + invite-by-code + onboarding + runbook como bloqueadores de beta). No hay "qué hacer después" en pánico — está decidido hace más de un sprint.
- A diferencia de S06 (cuyo scope eran 3 carry-overs explícitos del retro de S05), S07 tiene un **goal operacional con bloqueador real**: sin LFPDPPP, invitar a un mexicano a la plataforma es exposición legal. Esto es presión externa concreta, no urgencia auto-impuesta.
- El anti-pattern #1 que la regla guarda contra **no está presente**: no hay anxiety de "qué construyo después", el scope estaba listo, los items son operacionales (no features nuevas en busca de validación).

**Lo que sí preocupa:** dos violaciones consecutivas debilitan la regla. Si vuelve a pasar (S07→S08 también override), la regla deja de ser regla en la práctica. **Compromiso explícito para S08:** la regla de 24h se respeta sin override, salvo bloqueador externo igualmente claro (legal/incidente). Si en el retro de S07 no hay justificación de la misma fuerza, no se overridea.

**No es** una excepción para el resto del proyecto — es una excepción de hoy, registrada, evaluable en retro.

---

## 2026-05-16 — Override del anti-scope "1 vista nueva" para #77 (onboarding)

Durante el discovery card de minimal onboarding, Adrian eligió scope completo:

- Página dedicada `/welcome` post-registro
- Contenido amplio: beta warning + cómo reportar bugs + contacto email + **guía de inicio**
- Bug report **vía formulario in-app** (no email plain)
- Persistencia: **one-shot + página `/help` accesible siempre**
- Guía de inicio: **estática** (confirmado tras señalar el conflicto)

Esto requiere **3 vistas nuevas** (`/welcome`, `/help`, `/report-bug`) + mailer + redirect logic, lo cual contradice el anti-scope que el propio `GOAL.md` aprobó hace 1 día: *"Si requiere más de 1 vista nueva → fuera de scope"*.

**Le señalé el conflicto explícitamente** y le ofrecí 3 alternativas: (a) honrar anti-scope (1 vista, email channel), (b) split a backlog, (c) override consciente. Eligió **override consciente**.

**Justificación de aceptar el override:**
- Las 3 vistas son funcionalmente cohesivas — el mismo contenido en `/welcome` y `/help` no duplica trabajo significativo (es 1 partial reutilizado en 2 routes). El `/report-bug` es la única vista realmente independiente.
- Sin bug-report form, los reports caen a chat personal de Adrian — el goal del sprint (*"sin DM'ing Adrian for basics"*) no se cumple.
- Effort sube de ~2-4h a ~6-10h, pero el item sigue siendo razonable dentro del sprint.

**Costos del override que asumimos:**
- GOAL.md anti-scope actualizado: ya no se sostiene la cláusula "1 vista nueva"; queda sustituida por una más específica (*"no flow interactivo con Stimulus"*).
- Carga del sprint aumenta. Adrian eligió también mantener #70 (TrendScore enum) en el milestone, asumiendo ~3-4h extra encima del onboarding expandido. Sprint más grande, más riesgo de no cerrar — evaluable en retro.

**Lección recurrente:** el anti-scope se debilita en cada conversación de discovery cuando las preferencias del usuario expanden el item naturalmente. La hard-rule no es "respetar anti-scope a ciegas"; es "documentar explícitamente cuándo se reescribe". Eso es lo que esta entry hace.

---

## 2026-05-15 — Inclusión de #70 (TrendScore enum rename) en el scope

Decisión consciente de Adrian al opening: **#70 entra a S7** a pesar de ser P2 internal cleanup, no beta-blocker. Cambia el `GOAL.md` anti-scope y `scope.md` correspondientemente.

**Justificación:**
- El retro de S06 lo había marcado explícitamente como *"candidate slot: S07 beta-prep (if there's coherence with other cleanups) or backlog"*. La inclusión no es ad-hoc; estaba contemplada.
- Cierra el axis #2 (zero prescriptive copy) más cerca del 100% al alinear model-layer con ADR-001. Coherencia interna con el descriptive philosophy.
- Effort estimado en el issue: 3-4h. Es small relative al sprint operacional.

**Guardrail crítico:** #70 sigue con label `discovery-needed` porque falta decidir el set canónico de enum keys (`low_score / low_moderate / moderate / high_score / peak / sideways` u otra alternativa). Por hard rule #2 del protocolo de sprints, NO se mueve a `In Progress` hasta que esa decisión se tome y el label se retire. Si la decisión amerita ADR, se escribe antes de implementar.

**Si entra en conflicto de tiempo** con los 4 items operacionales del beta-prep durante la ejecución, se difiere a backlog sin penalidad en retro. El éxito del sprint NO se mide por #70.

---

## 2026-05-15 — Discovery cards pendientes al opening

El milestone S07 abrió sin issues asignados — los 4 entregables del goal viven como bullets en la descripción del milestone, no como GitHub issues con discovery card completo. **Esto viola la hard rule #2 del protocolo** (*"No issue sin discovery card. Issues con `discovery-needed` no son elegibles para entrar al sprint."*) tomada literal, porque ni siquiera existen las issues.

**Plan:** crear las 4 issues con discovery card completo ANTES de mover cualquiera a `In Progress`. El sprint se abre formalmente con el milestone + GOAL.md, pero no hay trabajo en curso hasta que las 4 issues estén `ready`. Esto convierte el opening en dos fases:

1. **Fase setup (hoy):** crear los 4 discovery cards, asignar al milestone, llenar `scope.md`.
2. **Fase ejecución (siguiente sesión):** trabajar los issues uno por uno.

Si durante la fase setup detecto que un item del goal **no tiene una discovery card honesta** (trigger personal documentado + JTBD claro + métrica + DoD), se saca del goal y se replantea. Mejor un sprint de 3 items con cards reales que de 4 con uno fabricado.
