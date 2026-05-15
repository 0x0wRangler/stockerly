# Scope — Sprint S06 (visual-coherence)

> Issues assigned to this sprint. State-ful work lives in GitHub (Milestone + Project); here just the initial snapshot + brief reason per issue.

---

## Main work

| # | Title | JTBD / ADR | Discovery card OK? |
|---|---|---|---|
| **#36** | [docs] Rewrite prescriptive labels (Strong/Parabolic, Upside/Downside) | ADR-001 (axis #2: 75% → ~90%) | ✅ |
| **#37** | [refactor] Adopt semantic color tokens — **slice S06 (final)** | Brand v2 / tracking issue S03-S06 | ✅ |
| **#68** | [docs] Trim `components.md` (821 → ≤200 líneas) | Anti-pattern #4 doc bloat (axis #6) | ✅ |

No parallel work in S06. The sprint is theme-coherent: all three issues serve "visual coherence" (copy + color + canonical catalog).

## Parallel work (max 30% effort)

| # | Title | Parallel axis | Discovery card OK? |
|---|---|---|---|
| — | (none) | — | — |

---

## Execution order (decided at opening — see log.md 2026-05-15)

1. **Opening commit: refine `script/audit-entropy.sh` regex** (~0.5h). Per S05 retro carry-over (A). Exclude `Queries::*.call`, `UseCases::*.call`, and explicitly-marked `Domain::*` read API patterns. Re-baseline cross-context-leaks count and capture in log.md before any other work starts. Lands first so the rest of the sprint can trust the metric.
2. **#36 first** (~4h raw, ~4.8h ×1.2). Copy rewrites are isolated to views — no model/controller churn. Touches `market/_listings_table`, `market/_analyst_target`, and the news-sentiment vocabulary cross-check. Smallest blast radius, validates ADR-001 grep stays at 0. Builds confidence early.
3. **#37 S06 slice** (~10h raw, ~12h ×1.2). The mechanical migration of remaining color hits + WCAG-AA `text-X-fg/N` audit + apply `font-display`/`font-body` per class. Target delta ≥60 (141 → ≤80). Run in 2-3 commit chunks to keep PR shape per S04 retro (5-8 commits / PR).
4. **#68 last** (~2h raw, ~2.4h ×1.2). Doc trim. Done after code is settled so the catalog can be re-evaluated against what actually exists in `app/views/shared/`. Lowest risk of re-work.

---

## Estimated effort

> Per S05 retro calibration: **1.2× multiplier** for refactor sprints with existing ADRs. S06 has ADR-001 (already written, just enforce) + S05-completed brand pattern (tokens defined, `-fg/N` rule documented) + S02 catalog (just trim). All three pieces have decided design.

| # | Estimate (raw session-hours) | × 1.2 | Notes |
|---|---|---|---|
| Opening: audit-entropy regex fix | 0.5 h | 0.5 h | Single commit, no ×1.2 needed (well-bounded) |
| #36 — Rewrite prescriptive labels | 4 h | 4.8 h | 3 view files + news-sentiment vocabulary unify + grep verification + tests don't break on label strings |
| #37 S06 slice — semantic tokens + WCAG + fonts | 10 h | 12 h | ~141 → ≤80 color hits delta + `text-X-fg/N` opacity audit (carry-over B) + `font-display`/`font-body` per class in layouts + tests still green |
| #68 — components.md trim | 2 h | 2.4 h | Audit each section vs `app/views/shared/`, trim to ≤200 lines or split |
| S06 close (QA + retro + audit-entropy diff + memory) | 1.5 h | 1.5 h | Mandatory per protocol |
| **Total** | **18 h raw** | **~21.2 h** | Single-day intensive cluster or 2 medium sessions |

Parallel effort = 0% (no parallel issues). All effort is main scope. ✅

---

## Targets at close (deltas, not absolutes — per S05 retro)

- **Hardcoded color classes in views:** 141 → **≤80** (delta ≥61)
- **ADR-001 violations in views:** 1 → **0**
- **Bloated docs (>200 lines):** 12 → **11** (components.md trimmed)
- **Cross-context leaks (post-regex-fix):** to be re-baselined at opening commit; expectation: drops from 13 → ~0-2 (real ADR-002 violations only)

---

## Rules verified at opening

- [x] Each issue has a complete discovery card — #36, #37, #68 all `ready`
- [x] Total `In Progress` issues ≤ 7 — will open ≤ 1 at a time given the sequential execution order
- [x] Parallel ≤ 30% of total estimated effort — 0% (no parallel)
- [x] `GOAL.md` goal is covered by the selected issues
- [x] `blocked` issues have their dependency identified — none blocked
- [x] Code-state audit at opening (S2 retro discipline) — pending first commit (audit-entropy re-baseline). See log.md 2026-05-15.
- [⚠️] **24h post-S05-close pause** — VIOLATED. S05 retro committed 2026-05-15 16:12 UTC; S06 opening commit ~10 minutes later. Decision documented in log.md with explicit owner sign-off. Risk: anti-pattern #1 ("next phase = next thing to build"). Mitigation: this is the only protocol violation accepted; the discovery cards, multiplier calibration, and target framing are all intact.
