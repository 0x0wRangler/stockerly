# Audiencia de Stockerly

> Para que algo sea feature, alguien de esta lista tiene que necesitarlo realmente.
> Si nadie aquí lo necesita, no se construye. Punto.

## Usuario primario — Adrian (fundador, dogfood)

- Inversor personal con patrimonio dividido en **MXN (CETES, posiblemente Cetesdirecto)** y **USD (acciones NYSE/NASDAQ vía broker que opera USD para residentes MX)**.
- Mismas acciones cotizadas en USD; flujo común: convertir MXN→USD para invertir, eventualmente convertir USD→MXN.
- Revisa portafolio **semanalmente**, no diariamente. No es day trader.
- Conoce código, valora arquitectura limpia, pero ya está harto de over-engineering propio.

**Jobs to be Done (JTBD) del primario:**
1. *Cuando reviso mi portafolio el fin de semana, quiero ver mi patrimonio total consolidado en MXN, para saber si subí o bajé desde la última vez.*
2. *Cuando mi posición baja X% desde costo promedio (en MXN), quiero saberlo, para decidir promediar o salir.*
3. *Cuando un CETE está por vencer, quiero saberlo con 7 días de anticipación, para decidir reinvertir.*
4. *Cuando entra earnings de algo que tengo, quiero saberlo con 2 días de anticipación, para no enterarme después.*
5. *Cuando agrego un trade nuevo, quiero capturarlo en menos de 30 segundos, para no abandonar el registro por flojera.*

**Lo que explícitamente NO está en scope (decidido 2026-05-14):**
- ❌ Reportes fiscales (ISR, declaración, retención de dividendos, ganancia cambiaria fiscal)
- ❌ Integraciones con SAT
- ❌ Cálculos para preparar declaración anual

## Usuarios secundarios — Beta cerrada con cupo (≤ 20 amigos)

- Inversores mexicanos con perfil **similar** a Adrian: portafolio mixto MXN+USD, frecuencia semanal/mensual.
- Acceso **solo por invitación explícita de Adrian** (no auto-registro público).
- **No** son PMs, no son traders activos, no son menores de edad.

**Lo que Adrian les promete:**
- Aviso de privacidad LFPDPPP-compliant
- Derecho a exportar todos sus datos y eliminar cuenta cuando quieran
- Honestidad sobre el estado: es un proyecto personal, no producto comercial — *use at your own risk*

**Lo que Adrian NO les promete:**
- Disponibilidad garantizada (puede estar caído fines de semana, en mantenimiento, etc.)
- Aviso anticipado de cambios breaking — *eres beta tester, no cliente*
- Soporte fuera del "se rompió, dime y vemos"

**Hipótesis a validar con la beta (no asunciones):**
- H1: Los amigos comparten al menos 3 de los 5 JTBD del primario.
- H2: La interfaz en es-MX (no traducida del inglés) reduce fricción de entendimiento.
- H3: Algo concreto los retiene más allá de la novedad inicial — *qué exactamente queda por descubrir*.

Si H1 o H3 se invalidan en los primeros 5 amigos invitados → revisar audiencia, no insistir.

## Non-users (lo que explícitamente NO somos)

- ❌ **Day traders / scalpers** — la app no soporta time-resolution sub-diaria.
- ❌ **Inversores institucionales / advisors** — no hay multi-tenant, no hay accounts.
- ❌ **Público general que llega por Google** — no hay landing comercial, no hay SEO, no hay funnel.
- ❌ **Inversores fuera de México** — la lógica está modelada en torno a MXN+USD vía broker MX.
- ❌ **Comunidad de devs que forkean** — el repo está público como portfolio, pero no aceptamos PRs hasta v1.0.

## Tamaño del cupo (beta cerrada)

- **Tope inicial:** 20 usuarios totales (Adrian + 19 invitados).
- **Razón:** soporte personal sostenible, feedback gestionable, datos personales acotados.
- **Mecanismo:** códigos de invitación de un solo uso generados por Adrian desde admin.
- **Expansión del cupo:** revisar solo después de que (a) multi-currency MXN/USD esté completo, (b) gain/loss consolidado en MXN funcione, (c) Adrian haya pasado un trimestre sin pedir ayuda para usar la app él mismo.

## Cuándo cambiarán las reglas de "use at your own risk"

- **Solo si:** Stockerly se convierte en producto de paga / monetizado.
- **En ese momento:** se introducen SLAs, soporte estructurado, aviso de breaking changes, etc.
- **Mientras tanto:** producto personal abierto a amigos invitados. Nada más.

## Implicaciones inmediatas (lo que cambia de inmediato)

1. **No se invita a nadie hasta resolver `currency: "USD"` hardcoded.** Sin esto, el JTBD #1 (patrimonio consolidado en MXN) miente.
2. **Aviso de privacidad LFPDPPP** antes del primer invitado. Sprint 3 lo incluye.
3. **Sistema de invitación por código de un solo uso** = feature mínima para arrancar (no auto-registro).
4. **Onboarding deja de ser vanity** — primeros 5 minutos de un amigo definen si vuelve.
5. **Sin SLA formal** mientras sea beta personal. Lenguaje en aviso de privacidad debe reflejarlo.
