# ADR-001 — Stockerly habla en lenguaje descriptivo, nunca prescriptivo

- **Estado:** Accepted
- **Fecha:** 2026-05-14
- **Autor:** Adrian Castillo (con review del panel de expertos)
- **Supersede:** —
- **Relacionado:** [`docs/vision/audience.md`](../../vision/audience.md)

---

## Contexto

Durante 22 fases de desarrollo, Stockerly acumuló features con tono prescriptivo: TrendScore 5-factor presentado como "señal" de compra/venta, Fear & Greed alerts vinculados a "momento de tomar ganancias", Phase 22 LLM Insights generando recomendaciones de portfolio rebalancing, weekly insights con framing de "deberías considerar...". Ninguna de esas features partió de un trigger personal documentado y, según la propia auditoría retrospectiva de 2026-05-14, fueron el principal vector de drift del producto.

Al mismo tiempo, el usuario primario (Adrian) confirma que **sí quiere** que Stockerly informe decisiones de inversión usando indicadores técnicos (RSI, Bollinger Bands, medias móviles, scores compuestos) e interpretaciones de estado de mercado ("oversold", "overbought", "concentrado").

La tensión inicialmente se planteó como "observa vs. prescribe", pero ese era el eje equivocado. El eje correcto es **lenguaje descriptivo vs. lenguaje prescriptivo**. Un indicador técnico interpretado en lenguaje natural ("AAPL aparece oversold según RSI(14)") es perfectamente válido como observación; lo que no es válido es el verbo de acción dirigido al usuario ("compra AAPL").

### Factores adicionales considerados

1. **Liability moral.** La audiencia secundaria es beta cerrada con amigos (≤20). Si actúan sobre una recomendación y pierden dinero, se siente como responsabilidad de Adrian aunque tenga disclaimers. El daño a relaciones personales no se mitiga con un footer legal.
2. **Liability regulatoria.** En México, ofrecer "consejo financiero" sin licencia CNBV está regulado. Lenguaje observacional sobre datos públicos no califica; lenguaje prescriptivo personalizado sí podría.
3. **Evidencia empírica.** Indicadores técnicos en timeframes diarios para retail con cadencia semanal raramente generan alpha. La utilidad es de **contexto para reflexión**, no de **edge sobre el mercado**. Hacer que el sistema "te diga qué hacer" cuando los datos no soportan esa precisión es engineering theater dressed as product.
4. **El antipattern del híbrido.** Una opción intermedia ("default observacional + una sección prescriptiva bounded con disclaimer fuerte") fue considerada y rechazada: en un proyecto solo, el bounded se vuelve loophole. Cualquier feature nueva se rationalize como "va en esa sección con disclaimer".

---

## Decisión

**Stockerly comunica al usuario en lenguaje descriptivo. El verbo de acción siempre pertenece al usuario, no al sistema.**

### Reglas operativas

#### ✅ Permitido

- **Eventos:** "X pasó", "X cambió", "X aparece" — descripción de hechos observables.
- **Estado de posición:** "Tu posición en NVDA bajó 18% desde tu costo promedio en MXN".
- **Indicadores técnicos crudos:** "AAPL: RSI(14) = 28".
- **Interpretación lingüística de indicadores:** "AAPL aparece oversold según RSI(14)", "NVDA cruzó por debajo de su MA200", "BMV en ruptura de Bollinger Band superior".
- **Indicadores compuestos observables:** TrendScore (5-factor), Fear & Greed, Concentration HHI, Sharpe ratio, volatilidad anualizada. Presentados como **lecturas**, no como **señales**.
- **Contexto histórico objetivo:** "AAPL no había tocado este nivel de RSI desde marzo de 2024".

#### ❌ Prohibido

- **Verbos de acción dirigidos al usuario:** "compra", "vende", "rebalancea", "sal", "entra", "considera vender", "es momento de...".
- **Predicciones probabilísticas:** "73% de probabilidad de subir esta semana", "alta probabilidad de rebote".
- **Recomendaciones de timing implícitas:** "ahora es buen momento para...", "vale considerar...", "podrías aprovechar...".
- **Confidence-weighted forecasts:** outputs de modelos que sugieren acción ponderada por confianza.
- **Nombres de sección prescriptivos:** "Sugerencias", "Recomendaciones", "Acciones sugeridas". Usar en su lugar: "Observaciones", "Indicadores notables hoy", "Análisis técnico", "Contexto del portafolio".

#### ⚠️ Zona gris (requiere review caso por caso)

- **Patrones históricos comparativos:** "Cuando AAPL ha estado en este nivel de RSI antes, en 60% de los casos rebotó en 2 semanas". Permitido como dato histórico si se presenta como **describir el pasado**, prohibido si insinúa **predecir el futuro**.
- **Ratios y métricas con interpretación cualitativa:** "P/E = 35, considerado alto frente a promedio histórico del sector". Permitido si la interpretación es descriptiva de comparación, no de acción.

### Regla cuando hay duda

> *Si el copy se puede leer como "el sistema te dice qué hacer", reescribir. Si se lee como "el sistema te muestra qué está pasando", está bien.*

Si la duda persiste tras el rewrite, escalación al panel (C5 Renata para copy, C6 Esther para scope, C1 Lucía para validación de dominio).

---

## Consecuencias

### Positivas

- **Scope claro y defensible.** Cualquier propuesta de feature pasa por el filtro de lenguaje. Reduce ambigüedad sobre qué construir.
- **Reducción de liability moral con beta cerrada.** Amigos invitados saben que el sistema describe; las decisiones siguen siendo suyas. Las relaciones personales no se ven afectadas por pérdidas atribuidas al sistema.
- **Alineamiento con realidad estadística.** El sistema no promete más de lo que la evidencia soporta sobre TA en retail semanal.
- **Cierre del vector principal de drift.** Las 22 fases anteriores acumularon features prescriptivas. ADR-001 corta esa vía.

### Negativas

- **Pérdida del "wow factor" superficial.** Un sistema que te dice "compra X" se siente más activo que uno que describe estado. Algunos amigos beta pueden inicialmente percibir Stockerly como "menos inteligente".
- **Rewrite de copy existente.** Phase 22 LLM Insights, TrendScore widgets, weekly insight, sentiment alerts — todos requieren auditoría y posible rewrite de strings y system prompts.
- **Discipline cost.** Cada feature nueva requiere atención al copy. No es ingeniería de mucho costo, pero es overhead constante.

### Mitigaciones

- **La información sigue ahí, solo cambia el tono.** Adrian (y los amigos beta) infieren acciones de las observaciones. El sistema no pierde funcionalidad, pierde imperativo.
- **El "wow" se reconstruye con calidad de las observaciones**, no con presunción de oráculo. Una observación rica y oportuna ("3 de tus posiciones tech entraron a oversold simultáneamente esta semana") es más valiosa que un "compra/vende" sin contexto.

---

## Implementación

### En código existente

| Feature | Acción |
|---|---|
| TrendScore 5-factor | Conservar lógica. Reescribir UI labels: de "Señal" a "Indicador compuesto". Quitar copy tipo "bullish/bearish signal" si existe. |
| Fear & Greed | Conservar. Quitar copy tipo "momento de tomar ganancias". Presentar como lectura de sentimiento. |
| Weekly Insight | Auditar el `WeeklyInsightCalculator`. Reescribir cualquier output prescriptivo. Ya existía nota interna "observational only" — formalizar via ADR. |
| Phase 22 LLM Insights (Portfolio, News, Health, Earnings) | Reescribir system prompts para forzar tono descriptivo. Añadir validación de output contra lista negra de verbos de acción. |
| Concentration alerts | Conservar. Verificar que el copy diga "HHI = X, considerado concentrado" no "deberías diversificar". |
| Sentiment alerts | Auditar copy de notificación. |
| News sentiment badges | OK como están (badges descriptivos: positive/neutral/negative). |

Esta auditoría se ejecuta en el **code audit del Sprint 1 (Paso 6)** y los rewrites concretos se vuelven issues en el backlog para sprints siguientes.

### En código nuevo

- Cualquier PR que toque copy de UI o output de LLM/system messages debe pasar por self-review contra esta ADR.
- En zonas grises, el reviewer pregunta: *"¿quién es el sujeto del verbo de acción aquí?"*. Si es Stockerly, reescribir.

### En procesos

- **Code review checklist:** un bullet específico para ADR-001.
- **Sprint QA:** una de las preguntas pre-close del sprint es *"¿algún copy nuevo viola ADR-001?"*.
- **Beta onboarding:** comunicar a amigos invitados explícitamente que Stockerly describe, no recomienda; el sistema no es un asesor de inversiones.

---

## Notas

- Esta ADR puede revisarse si Stockerly transiciona de beta personal/amigos a producto monetizado con licencia CNBV o equivalente. Hasta entonces, es regla dura.
- La distinción descriptivo/prescriptivo es **del lenguaje del producto**, no de la inteligencia interna del sistema. El sistema puede internamente computar señales agresivas (ej. "modelo dice 87% probabilidad de subir"); lo que cambia es **cómo se le comunica al usuario**.
