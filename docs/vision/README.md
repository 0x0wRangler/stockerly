# Stockerly — Vision

> Última actualización: **2026-05-14** (Sprint 1 — Reset)
> Esta carpeta es la **única fuente de verdad** sobre por qué Stockerly existe, para quién, qué hace y qué no hace.

---

## El norte

> **Stockerly es la herramienta personal de Adrian para entender y operar su patrimonio invertido entre MXN y USD (mismas acciones cotizadas en USD, posiciones en MXN como CETES), con tracking multi-divisa correcto (TC histórico al momento del trade). Lo open source es portfolio público. La "lente PO" es disciplina sobre el constructor — no una audiencia.**

Este norte sustituye al PRD original (1.1, 2026-03-04) que describía 3 personas, 50K traders y un funnel de adquisición pública. El PRD original fue archivado en `docs/archive/spec-2026-Q1/` durante el Sprint 1.

---

## Audiencia

Ver [`audience.md`](./audience.md). En resumen:

- **Primary:** Adrian (dogfood) — inversor MX con portafolio mixto MXN+USD, cadencia semanal.
- **Secondary:** ≤20 amigos invitados (beta cerrada, sin auto-registro).
- **Non-users:** day traders, advisors, gringo investors, contadores, OSS contribuidores (cerrado a PRs hasta v1.0).

---

## Jobs to be Done

Ver [`jobs-to-be-done.md`](./jobs-to-be-done.md). 6 JTBDs definidos al 2026-05-14:

1. Patrimonio consolidado en MXN
2. Drawdown de posición desde costo promedio en MXN
3. CETE por vencer
4. Earnings de holdings
5. Trade capture en menos de 30 segundos
6. Posición en zona técnica notable (descriptivo, no prescriptivo)

---

## Lo que NO somos

Ver [`non-goals.md`](./non-goals.md). Lista consolidada de audiencia, funcionalidad, lenguaje, producto y mercado fuera de scope.

---

## Tres reglas duras (no negociables)

1. **Multi-currency MXN/USD es ciudadano de primera clase**, no "feature internacional". Sin esto, los JTBDs mienten.
2. **Cuando Adrian-usuario y Adrian-PO chocan, gana usuario.** El PO observa y aprende; no impone features que no le sirven al usuario real.
3. **Toda feature nueva pasa el filtro de 4:** trigger personal documentado + JTBD + métrica de uso + Definition of Done. Sin los 4, no se construye.

---

## Lenguaje del producto

Stockerly habla en **lenguaje descriptivo, nunca prescriptivo**. Indicadores técnicos interpretados ("AAPL aparece oversold según RSI(14)") están permitidos. Verbos de acción dirigidos al usuario ("compra AAPL") están prohibidos.

Decisión completa, ejemplos, zona gris y plan de implementación: ver [`../architecture/adr/0001-descriptive-not-prescriptive-language.md`](../architecture/adr/0001-descriptive-not-prescriptive-language.md).

---

## Cómo cambia este norte

- Edits a `README.md`, `audience.md`, `non-goals.md`, `jobs-to-be-done.md` requieren commit con razón en el mensaje.
- Cambios estructurales (audiencia, scope, lenguaje del producto) requieren **nueva ADR** referenciando el cambio.
- **Audit trimestral:** una de las preguntas de retro de sprint trimestral es *"¿el norte sigue siendo verdad?"*. Si no, escribir ADR.
- Mientras Stockerly siga siendo beta personal/amigos: el norte se mantiene firme. Si transiciona a monetizado/comercial: revisar todo.

---

## Documentos hermanos

| Doc | Propósito |
|---|---|
| [`audience.md`](./audience.md) | Quién es el usuario primario, secundarios beta, non-users, cupo |
| [`non-goals.md`](./non-goals.md) | Lo que explícitamente NO somos (audiencia, scope, mercado) |
| [`jobs-to-be-done.md`](./jobs-to-be-done.md) | Los 6 JTBDs expandidos con datos, vistas, triggers, métricas |
| [`../architecture/adr/`](../architecture/adr/) | Decisiones de arquitectura inmutables (ADR-001 es el primero) |
