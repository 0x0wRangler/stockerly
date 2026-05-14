# Jobs to be Done — Stockerly

> Los 6 JTBDs que justifican la existencia de Stockerly al 2026-05-14.
> Cada JTBD aquí es la **expansión** de las líneas que aparecen en [`audience.md`](./audience.md).
> Una feature nueva en backlog tiene que mapearse a uno de estos (o proponer un nuevo JTBD vía edit a este archivo).

---

## Estructura de cada JTBD

```
**Statement** — la frase canónica "Cuando X, quiero Y, para Z"
**Datos necesarios** — qué tiene que existir en BD/gateways
**Surface en la app** — dónde lo ve el usuario
**Triggers** — qué dispara el surfacing proactivo (si aplica)
**Métrica de uso** — cómo sabremos si el JTBD se cumple
**Bloqueado por** — deuda actual que impide cumplirlo
**Status actual** — qué tan cerca está hoy de cumplirse
```

---

## JTBD #1 — Patrimonio consolidado en MXN

**Statement:** *Cuando reviso mi portafolio el fin de semana, quiero ver mi patrimonio total consolidado en MXN, para saber si subí o bajé desde la última vez.*

**Datos necesarios:**
- Posiciones actuales (`positions` table)
- Precios actuales (gateways: Polygon equities, CoinGecko crypto, Banxico CETES)
- TC USD→MXN actual (FxRatesGateway o Banxico)
- TC USD→MXN al momento de cada compra (**bloqueador**: no existe hoy)
- Snapshots históricos (`portfolio_snapshots`) para comparación cronológica

**Surface en la app:**
- Dashboard principal — KPI "Patrimonio Total" en MXN (con conversión visible USD→MXN)
- Portfolio page — totales consolidados arriba

**Triggers:** ninguno. Es dato siempre visible al abrir la app.

**Métrica de uso:** Adrian abre el dashboard ≥1 vez por semana en fin de semana. Si baja a <1/mes, el JTBD no se está cumpliendo.

**Bloqueado por:** `currency: "USD"` hardcoded en `app/contexts/trading/use_cases/execute_trade.rb:39,60`. Hasta que esto se resuelva, el patrimonio consolidado en MXN es ficción. **P0 absoluto.**

**Status actual:** Implementado UI; matemática rota por el bug P0. No se puede invitar amigos beta hasta que se arregle.

---

## JTBD #2 — Drawdown de posición desde costo promedio MXN

**Statement:** *Cuando mi posición baja X% desde costo promedio (en MXN), quiero saberlo, para decidir promediar o salir.*

**Datos necesarios:**
- `position.avg_cost` en moneda nativa de adquisición
- `position.cost_basis_mxn` calculado con TC histórico (**bloqueador**: no existe)
- Precio actual (USD para acciones, MXN para CETES)
- TC actual
- Umbral X (configurable por usuario; default sugerido: -10% para warn, -15% para alert)

**Surface en la app:**
- Portfolio page — badge en cada posición que cruzó el umbral
- Dashboard — sección "Observaciones notables" si hay posiciones bajo umbral
- Alerts — notificación in-app cuando una posición cruza el umbral por primera vez (cooldown obligatorio)

**Triggers:** EOD job revisa todas las posiciones, dispara alert cuando una cruza el umbral hacia abajo (no spam si ya está debajo).

**Métrica de uso:** Adrian abre la alert/badge dentro de las 24h de generarse (proxy: click event). Si las ignora consistentemente, el JTBD no funciona.

**Bloqueado por:** Mismo P0 del JTBD #1. Sin cost basis en MXN correcto, el porcentaje calculado miente.

**Status actual:** AlertRule existe con `price_below_pct` cerca; falta variante de "X% desde cost basis MXN" y necesita el fix de currency.

---

## JTBD #3 — CETE por vencer

**Statement:** *Cuando un CETE está por vencer, quiero saberlo con 7 días de anticipación, para decidir reinvertir.*

**Datos necesarios:**
- `asset.maturity_date` para asset_type CETE
- Posiciones activas en assets tipo CETE
- Calendario (días laborales Banxico para precisión)

**Surface en la app:**
- Dashboard sidebar — "Próximos eventos" listando CETES próximos a vencer
- Asset detail de cada CETE — countdown visible
- Alerts — notificación a 7d, 3d, 1d antes

**Triggers:** Daily cron job; check posiciones contra maturity_date.

**Métrica de uso:** Adrian reinvierte (o decide no hacerlo) dentro de las 48h después del vencimiento. Proxy: nueva trade o explicit dismiss del alert.

**Bloqueado por:** nada bloquea. CETES están modelados desde Phase 13.1 con `YieldCalculator` mexicano.

**Status actual:** Listing de CETES existe, alerts de vencimiento parcialmente implementadas. Verificar en code audit (Paso 6) qué falta.

---

## JTBD #4 — Earnings de holdings

**Statement:** *Cuando entra earnings de algo que tengo, quiero saberlo con 2 días de anticipación, para no enterarme después.*

**Datos necesarios:**
- Earnings calendar (Polygon gateway, existe)
- Holdings actuales del usuario (positions activas)
- Match entre tickers de holdings y tickers en earnings calendar

**Surface en la app:**
- Dashboard "Próximos eventos" — earnings de holdings con BMO/AMC + EPS estimate
- Earnings page filtrada por mis holdings
- Notification — 2d, 1d antes (con detalles)

**Triggers:** `NotifyEarningsJob` daily, 7am. Match holdings vs upcoming earnings, deduplicado con `last_triggered_at` por evento.

**Métrica de uso:** Adrian abre el asset detail del ticker que tiene earnings antes del evento. Proxy: page view del asset entre alert y earning.

**Bloqueado por:** nada bloquea. Implementado desde Phase 14.4 (`Earnings::NotifyApproaching`).

**Status actual:** Funcional. Validar en code audit que el copy del notification no caiga en prescriptivo.

---

## JTBD #5 — Trade capture rápido

**Statement:** *Cuando agrego un trade nuevo, quiero capturarlo en menos de 30 segundos, para no abandonar el registro por flojera.*

**Datos necesarios para el form:**
- Ticker (con autocomplete contra `assets`)
- Shares
- Price (en moneda nativa)
- **Currency (auto-detectar del asset)** — hoy hardcoded a USD ❌
- Date (default: hoy; max: hoy; min: ¿1 año atrás?)
- TC al momento del trade (**falta**: capturar automático desde Banxico si currency = USD)
- Notes opcional, labels opcional

**Surface en la app:**
- Portfolio page — botón "+ Add Trade" abre form inline (Turbo Frame)
- Dashboard — quick action "Add Trade"

**Friction points (a medir y reducir):**
1. Búsqueda de ticker — debería ser <300ms con debounce
2. Captura de TC — debería ser automática, no manual
3. Decisión de currency — debería ser auto desde el asset
4. Validación de precio razonable — feedback inmediato si es muy distinto al actual

**Métrica de uso:** tiempo desde "abrir form" hasta "submitted". Target: P50 < 30s, P95 < 60s.

**Bloqueado por:** El currency hardcoded del P0 incluye este JTBD también. Mientras no exista FX-at-execution, el form omite ese campo crítico.

**Status actual:** Form existe, funcional, pero captura currency hardcoded y no captura FX rate. Necesita rework como parte del fix P0.

---

## JTBD #6 — Posición en zona técnica notable

**Statement:** *Cuando una de mis posiciones (o un activo de mi watchlist) entra en zona técnica notable (oversold/overbought según RSI, ruptura de Bollinger Bands, cruce de medias móviles), quiero verlo descrito en contexto, para incluirlo en mi reflexión semanal de portafolio.*

**Datos necesarios:**
- Historical prices daily ≥200 días (existe via `price_histories`)
- Indicadores computados por asset (RSI(14), MACD, BB, MA50, MA200, EMA9/21)
- TrendScore 5-factor (ya existe)
- User holdings + watchlist

**Surface en la app:**
- Asset detail — sección "Análisis técnico" con indicadores actuales + interpretación lingüística descriptiva
- Dashboard — sección "Observaciones notables" cuando ≥1 asset relevante entra a zona
- Market listings — hover/click revela TrendScore breakdown (ya existe desde Phase 21.1)

**Triggers:**
- Daily EOD job: recompute indicadores, detectar transiciones (asset entró a oversold hoy / cruzó MA50 hoy)
- Generate "observación" cuando hay transición, asociada a holding/watchlist del usuario
- Dedup: una observación por asset/zona por semana (cooldown)

**Lenguaje requerido (ADR-001):**
- ✅ *"AAPL aparece oversold según RSI(14) = 28"*
- ✅ *"NVDA cruzó por debajo de su MA200"*
- ❌ *"Considera comprar AAPL"*

**Métrica de uso:** Adrian abre ≥1 asset detail por semana desde una observación notable surface. Si las ignora, el JTBD no funciona o las observaciones son demasiado ruidosas.

**Bloqueado por:** nada directamente (los indicadores ya se calculan). Falta el copy descriptivo, el surfacing como "observaciones notables", y el tuning del threshold para evitar ruido.

**Status actual:** Indicadores calculados (Phase 21.1). Falta surface descriptivo + dedup + UI dedicada.

---

## Cómo se agrega un nuevo JTBD

1. Trigger personal documentado: *"El [fecha] me pasó [situación específica], y no tuve [información/acción] disponible en Stockerly"*.
2. Statement en formato canónico: *"Cuando X, quiero Y, para Z"*.
3. Datos, surface, triggers, métrica, bloqueadores — completar las 6 secciones.
4. Editar `audience.md` y `README.md` de vision para reflejar el nuevo número de JTBDs.
5. Commit con mensaje *"docs(vision): add JTBD #N — [statement breve]"*.

## Cómo se retira un JTBD

Si después de 90 días de implementado:
- La métrica de uso no se cumple (Adrian no lo usa con la frecuencia esperada)
- O Adrian admite explícitamente que no le sirve

→ retro lo marca para retiro. Issue en backlog: *"Retirar JTBD #N: razón"*. Las features asociadas se evalúan caso por caso (algunas pueden seguir como infra observable, otras se desimplementan).
