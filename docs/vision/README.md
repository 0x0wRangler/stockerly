# Stockerly — Vision

> Last updated: **2026-05-14** (Sprint 1 — Reset)
> This folder is the **single source of truth** for why Stockerly exists, who it's for, what it does, and what it doesn't do.

---

## North star

> **Stockerly is Adrian's personal tool for understanding and operating his investment patrimony split between MXN and USD (same stocks quoted in USD, MXN positions like CETES), with correct multi-currency tracking (historical FX at trade execution). The open-source repo is a public portfolio. The "PO lens" is discipline on the builder — not a separate audience.**

This north supersedes the original PRD (v1.1, 2026-03-04) which described 3 personas, 50K traders, and a public acquisition funnel. The original PRD was archived under `docs/archive/spec-2026-Q1/` during Sprint 1.

---

## Audience

See [`audience.md`](./audience.md). In summary:

- **Primary:** Adrian (dogfood) — MX investor with mixed MXN+USD portfolio, weekly cadence.
- **Secondary:** ≤20 invited friends (closed beta, no self-registration).
- **Non-users:** day traders, advisors, gringo investors, accountants, OSS contributors (closed to PRs until v1.0).

---

## Jobs to be Done

See [`jobs-to-be-done.md`](./jobs-to-be-done.md). 6 JTBDs defined as of 2026-05-14:

1. Consolidated patrimony in MXN
2. Position drawdown from average cost in MXN
3. CETE about to mature
4. Earnings on held assets
5. Trade capture in under 30 seconds
6. Position in notable technical zone (descriptive, not prescriptive)

---

## What we are NOT

See [`non-goals.md`](./non-goals.md). Consolidated list of audience, functionality, language, product and market boundaries that are explicitly out of scope.

---

## Three hard rules (non-negotiable)

1. **Multi-currency MXN/USD is a first-class citizen**, not an "international feature". Without this, the JTBDs lie.
2. **When Adrian-as-user and Adrian-as-PO clash, the user wins.** The PO observes and learns; never imposes features that don't serve the real user.
3. **Every new feature passes the 4-filter:** documented personal trigger + JTBD + usage metric + Definition of Done. Without all 4, it doesn't get built.

---

## Product language

Stockerly speaks in **descriptive language, never prescriptively**. Interpreted technical indicators (*"AAPL appears oversold per RSI(14)"*) are allowed. Action verbs directed at the user (*"buy AAPL"*) are forbidden.

Full decision, examples, gray zone, and implementation plan: [`../architecture/adr/0001-descriptive-not-prescriptive-language.md`](../architecture/adr/0001-descriptive-not-prescriptive-language.md).

---

## How this north changes

- Edits to `README.md`, `audience.md`, `non-goals.md`, `jobs-to-be-done.md` require a commit message with reason.
- Structural changes (audience, scope, product language) require a **new ADR** referencing the change.
- **Quarterly audit:** one of the sprint retro questions every quarter is *"Is the north still true?"*. If not, write an ADR.
- While Stockerly remains personal/friends beta: the north stays firm. If it transitions to monetized/commercial: revisit everything.

---

## Sibling documents

| Doc | Purpose |
|---|---|
| [`audience.md`](./audience.md) | Primary user, beta secondaries, non-users, cap size |
| [`non-goals.md`](./non-goals.md) | What we explicitly are NOT (audience, scope, market) |
| [`jobs-to-be-done.md`](./jobs-to-be-done.md) | The 6 JTBDs expanded with data, surfaces, triggers, metrics |
| [`../architecture/adr/`](../architecture/adr/) | Immutable architecture decisions (ADR-001 is the first) |
