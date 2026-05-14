---
name: Stockerly vision & audience
description: Stockerly is Adrian's personal tool for MXN+USD patrimonio tracking with correct multi-currency math. Beta cerrada (≤20 invited friends), public repo = portfolio. "PO" is discipline lens, not audience. Fiscal scope explicitly out (decided 2026-05-14).
type: project
---

**North star (decided 2026-05-14):**

> Stockerly es la herramienta personal de Adrian para entender y operar su patrimonio invertido entre MXN y USD (mismas acciones cotizadas en USD, posiciones en MXN como CETES), con tracking multi-divisa correcto (TC histórico al momento del trade). Lo open source es portfolio público. La "lente PO" es disciplina sobre el constructor — no una audiencia.

**Why:** Earlier PRD described "50,000+ traders, social proof, admin panel" for users that didn't exist. 22 phases produced engineering theater (LLM gateway, PWA, API key pool, risk metrics) targeting non-users. 2026-05-14 reset realigns audience to one real user + closed beta.

**Explicitly OUT of scope (2026-05-14):**
- Fiscal reports (ISR, SAT integrations, dividend retention calc, currency-gain fiscal calc)
- Anything that prepares the user for annual declaration
- Building toward "we replace your accountant" positioning

**Audience:**
- **Primary:** Adrian (dogfood) — MX investor, weekly cadence, fiscal-aware
- **Secondary (beta cerrada, cap ≤20):** invited MX friends with similar profile. Invitation only — no auto-registration.
- **Non-audience:** day traders, advisors, gringo investors, accounting professionals, OSS community contributors (closed to PRs until v1.0), general public via SEO

**Three hard rules:**
1. **Multi-currency MXN/USD is first-class**, not "international feature"
2. **When Adrian-user and Adrian-PO clash → user wins.** PO observes/learns, doesn't impose.
3. **Every new feature passes 4-filter:** trigger personal documented + JTBD + usage metric + DoD. Without all 4, not built.

**How to apply:**
- Reject features targeting non-audience
- Flag work building on broken foundations (e.g., the multi-currency bug)
- Enforce 4-filter before sprint planning; block discovery-incomplete items
- When Adrian says "let's also add X", check filter before agreeing
