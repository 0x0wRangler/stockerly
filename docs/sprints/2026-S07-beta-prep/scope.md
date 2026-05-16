# Scope — Sprint S07 (beta-prep)

> Issues assigned to this sprint. State-ful work lives in GitHub (Milestone + Project); here just the initial snapshot + brief reason per issue.

---

## Main work

> **Pending: issues to be created** — at sprint opening (2026-05-15) the 4 deliverables exist as bullets in the milestone description, not yet as GitHub issues with discovery card. See `log.md` entry 2026-05-15 "Discovery cards pendientes" for plan.

Planned deliverables (to be converted into GitHub issues with full discovery card before moving to `In Progress`):

| Planned # | Title | JTBD / ADR | Discovery card OK? |
|---|---|---|---|
| #73 | Rewrite `/privacy` as LFPDPPP-compliant notice (removes aspirational fake copy) | Compliance + axis #3 | ✅ |
| #74 | Invite-by-code system (single-use, admin UI) | Beta cerrada infrastructure — JTBD-N/A | ✅ |
| #77 | Minimal onboarding: /welcome + /help + /report-bug + bug-report mailer | UX entrada + bug-channel | ✅ (scope expandido, override anti-scope) |
| #78 | Beta support runbook (bug reports + incidents) | Operacional — JTBD-N/A | ✅ |
| #70 | Rename `TrendScore.label` enum to descriptive vocabulary | ADR-001 model-layer coherence | ✅ (enum keys decididos, `discovery-needed` removido) |

## Parallel work (max 30% effort)

| # | Title | Parallel axis | Discovery card OK? |
|---|---|---|---|
| (none) | — | — | — |

S07 es sprint operacional con goal acotado; ningún `parallel`-labeled item se incluye al opening.

---

## Rules verified at opening

- [x] Each issue has a complete discovery card (no `discovery-needed` label) — **5/5 issues created with complete discovery cards (2026-05-15/16)**
- [x] Total `In Progress` issues ≤ 7 (hard rule) — actualmente 0
- [x] Parallel ≤ 30% of total estimated effort — 0% parallel work
- [x] `GOAL.md` goal is covered by the selected items — sí, los 4 items cubren las 4 cláusulas del goal
- [x] `blocked` issues have their dependency identified — N/A, no hay blocked

---

## Carry-overs from S06 — explicitly NOT in S07

Per `GOAL.md` anti-scope and S06 retro:

- **Lumen palette adoption** (no issue yet): requiere ADR + sprint propio, S08+.
- **Sparkline dynamic-class audit gap** (no issue yet): chore tooling, backlog.

Carry-over **incluido** en S07: **#70** (TrendScore enum rename) — único cleanup interno que entra. Justificación: el retro S06 lo marcó como candidato a slot S07 si hay coherencia, y el alineamiento model-layer con ADR-001 cierra el axis #2 más cerca del 100%. Decisión documentada en `log.md` 2026-05-15.

Mantener los otros dos fuera evita el anti-pattern #4 (doc bloat) y el #1 (next-phase syndrome).

---

## Critical guardrails for #70 inclusion

- ~~#70 sigue con label `discovery-needed`.~~ **Resuelto 2026-05-16:** set canónico decidido (`low_score / low_moderate / neutral / moderate / high_score / peak`), `discovery-needed` removido. Ready to work.
- **#70 es P2;** si entra en conflicto de tiempo con los 4 items P0/P1 del beta-prep, se difiere a backlog sin retro penalty — no es el item que define el éxito del sprint.
