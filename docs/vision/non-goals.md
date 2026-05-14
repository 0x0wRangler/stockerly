# Non-Goals de Stockerly

> Lo que Stockerly explícitamente **NO** es. Tan importante como lo que sí somos.
> Cada non-goal aquí es una decisión consciente con razón. Si quieres cambiar uno, requiere ADR.
> Última actualización: **2026-05-14** (Sprint 1).

---

## Non-users (audiencia que NO atendemos)

| No es para | Por qué |
|---|---|
| **Day traders / scalpers** | Producto modelado en cadencia diaria-EOD. No hay time-resolution sub-diaria, no hay WebSocket tick-level. |
| **Inversores institucionales / advisors** | No hay multi-tenant, no hay accounts, no hay role-separation entre advisor y cliente. |
| **Público general que llega por Google** | No hay landing comercial, no hay SEO, no hay funnel de conversión. El repo es portfolio público, no producto pull. |
| **Inversores fuera de México** | La lógica está modelada en torno a MXN+USD vía broker MX. CETES, IPC, Banxico FX. |
| **Contadores fiscales profesionales** | No reemplazamos contador. Ver "Funcionalidad fuera de scope" abajo. |
| **Comunidad de devs que forkean** | Repo público como portfolio, pero PRs **no** se aceptan hasta v1.0. |
| **Menores de edad / usuarios sin capacidad de inversión** | Producto asume usuario adulto con cuenta de broker real. |

---

## Funcionalidad fuera de scope

### Fiscal

| No hacemos | Por qué |
|---|---|
| Reportes para declaración ISR | Decisión 2026-05-14: fiscal fuera de scope. Producto se enfoca en tracking de patrimonio, no en preparación fiscal. |
| Integraciones SAT | Misma razón. |
| Cálculo de retención de dividendos USA (W-8BEN) | Misma razón. |
| Ganancia/pérdida cambiaria para declaración | Misma razón. |
| Tax lot tracking FIFO/LIFO | Requiere modelo fiscal completo. Fuera de scope. |
| Wash sale detection | Regla fiscal USA, no aplica a contexto MX. |

### Lenguaje del producto (ADR-001)

| No hacemos | Por qué |
|---|---|
| Recomendaciones prescriptivas: "compra X", "vende Y" | Liability moral con beta de amigos; evidencia empírica de que TA retail rara vez genera alpha; mensaje incorrecto sobre la naturaleza del producto. |
| Predicciones probabilísticas: "73% chance de subir" | Lo mismo. Más detalle: ver ADR-001. |
| Confidence-weighted forecasts de acción | Lo mismo. |
| Secciones llamadas "Sugerencias", "Recomendaciones", "Acciones a tomar" | El sustantivo prescriptivo se vuelve loophole para feature creep. Usar "Observaciones", "Análisis técnico", "Contexto". |

### Producto

| No hacemos | Por qué |
|---|---|
| SLA formal (uptime, response time) | Mientras sea beta personal/amigos. Revisar solo si Stockerly se monetiza. |
| App móvil nativa (iOS/Android) | PWA ya cubre instalación e iconos. No vale costo de mantener dos plataformas. |
| Multi-tenancy / cuentas compartidas / portafolios de equipo | Requiere authorization overhaul. Cero demanda. |
| Internacionalización i18n | es-MX único idioma. Si llegara un beta no-MX, sería sintoma de drift de audiencia. |
| Social features: compartir público, comentarios, foros, leaderboards | No es producto social. No es producto de comunidad. |
| Profile sharing / privacy mode con perfil público | Subset del anterior. |
| Notificaciones push reales (browser/SMS) | Optional bonus, no core. Email + in-app es suficiente. |

### Mercado y asset classes

| No hacemos | Por qué |
|---|---|
| Mercados fuera de USA + México | Audiencia es inversor MX. Otros mercados son scope creep. |
| Options / warrants / derivados | Productos con Greeks, expiry, chains — clase de activos completamente distinta. Sería otro producto. |
| Forex (FX trading puro) | El FX está modelado solo como TC para conversión, no como activo tradeable. |
| Futures / commodities | Lo mismo. |
| Bonos corporativos (más allá de CETES) | Si surge necesidad personal de Adrian, se evalúa por ADR. Por ahora, no. |
| Real estate / activos no líquidos | Fuera de scope. |
| Tokenized assets / NFTs | Fuera de scope. |
| Crypto trading activo (más allá de holdings basicos) | El modelo crypto actual es de tracking, no de trading activo con order types. |

### Real-time y data engineering

| No hacemos | Por qué |
|---|---|
| WebSocket para precios live tick-level | Polygon WebSocket es tier de paga; polling diario es suficiente para cadencia semanal. |
| Historical data deep (>5 años) | Polygon free tier limita; suficiente para los JTBDs actuales. Si Adrian necesita más profundidad, evaluamos. |
| Backtesting de estrategias | Producto de TA backtesting es otra cosa. Stockerly observa el presente, no simula pasado. |

### Performance

| No hacemos | Por qué |
|---|---|
| Optimizar para >10K usuarios simultáneos | Beta cerrada ≤20. La arquitectura actual ya es excesiva para esa escala. |
| Read replicas, sharding, caching avanzado | Solid Cache + fragment caching ya están. Más es over-engineering. |

---

## Cómo se agrega un nuevo non-goal

1. Surge una propuesta de feature o expansión.
2. Si entra en una de las categorías de arriba → automáticamente fuera, no se discute en sprint planning.
3. Si es ambigua → discusión + decisión consciente → si se decide "fuera", se añade aquí con razón.
4. Cambiar un non-goal (sacarlo de la lista) requiere ADR.

---

## Cómo se quita un non-goal

Solo bajo una de estas condiciones:
- Cambio en audiencia (ej. Stockerly se monetiza → SLA puede entrar)
- Cambio en realidad personal de Adrian (ej. empieza a operar mercados europeos)
- Necesidad fuerte y repetida de la beta (ej. 5+ amigos piden lo mismo y tiene sentido)

En cualquier caso: ADR documenta el cambio y la razón.
