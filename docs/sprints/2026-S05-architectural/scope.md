# Scope — Sprint S05 (architectural)

> Issues assigned to this sprint. State-ful work lives in GitHub (Milestone + Project); here just the initial snapshot + brief reason per issue.

---

## Main work

| # | Title | JTBD / ADR | Discovery card OK? |
|---|---|---|---|
| **#33** | [P1] Resolve Trading↔MarketData dashboard leak | ADR-002 implementation | ✅ |
| **#35** | [chore] Clean up 11 zombie + 4 ghost events | No JTBD (cleanup) | ✅ |
| **#38** | [refactor] Refactor 10 trivial use cases to SimpleUseCase | ADR-006 (frontload as first commit of #38's PR) | ✅ (currently `blocked`; first commit writes ADR-006 and removes the label) |

## Parallel work (max 30% effort)

| # | Title | Parallel axis | Discovery card OK? |
|---|---|---|---|
| **#37** | [refactor] Adopt semantic color tokens from @theme — S05 slice | Design system (brand migration parallel S3-S6) | ✅ |

S05 slice of #37: migrate **2 components + 1 view**. Audit-entropy at S04 close: 160 hardcoded color hits. Target ≤140 at S05 close. Candidate components TBD at work-start audit; candidate view: likely `dashboard/_fear_greed_card.html.erb` (7 hits, deferred from S04 due to heatmap question — to be resolved per S04 retro action item) OR an admin sub-view if heatmap question stays unresolved.

---

## Execution order (decided at opening — see log.md 2026-05-15)

1. **#33 first** (P1, ~10h). Implements the architectural decision that's already documented (ADR-002). Touches AssembleDashboard, FxRateResolver, MarketData public API (new `Queries::` namespace), and CLAUDE.md. The heaviest piece structurally; doing it first means downstream work (#35, #38) lands on the corrected boundary.
2. **#35** (P2, ~4h). Independent of #33 and #38. Pure deletion plus per-zombie decision. Can be interrupted by Gemini review cycles on #33 if needed.
3. **#38** (P2, ~10h). Starts with ADR-006 as its first commit (frontload pattern from S04 #59→#33). Then `SimpleUseCase` base + 10 migrations. The migration is mechanical once the base + ADR exist.
4. **#37 S05 slice** (~3h). Runs alongside as context-switch breathers. Will resolve the heatmap-exception audit per S04 retro carry-over (if ≥2 true heatmaps exist, define `color-scale-*` tokens; otherwise document the F&G exception).

---

## Estimated effort

> Per S04 retro calibration (memorialized in `project_working_method.md` memory): 1.3× factor for new-feature / refactor sprints with a nearby existing pattern. S05 is structural-refactor with documented patterns (ADR-002 already drafted, SimpleUseCase has clear precedent in NotifyApproachingEarnings, ghost events are pure delete) → 1.3×.

| # | Estimate (raw session-hours) | × 1.3 | Notes |
|---|---|---|---|
| #33 — ADR-002 implementation | 8 h | 10.4 h | 4 `MarketData::Queries::*` extractions + AssembleDashboard refactor + FxRateResolver wrapper + CLAUDE.md amendment + boundary audit-script metric + tests |
| #35 — zombie + ghost events cleanup | 3 h | 3.9 h | Delete 5 ghosts + per-zombie decision (6 zombies, mix of delete and trivial handler add) + event_subscriptions.rb consistency + tests |
| #38 — ADR-006 + SimpleUseCase + 10 migrations | 8 h | 10.4 h | ADR-006 (~2h) + SimpleUseCase base (~1h) + 10 use-case migrations × ~0.5h each = ~5h + specs update + docs/architecture/conventions.md |
| #37 (S05 slice) | 2 h | 2.6 h | 2 components + 1 view + heatmap-exception audit |
| **Total** | **21 h raw** | **~27.3 h** | Below the 30h band; doable in a single high-intensity session-cluster |

Parallel effort (#37) = 2.6h / 27.3h ≈ **9.5% ≤ 30%** ✅ (the lightest parallel slice yet — main scope dominates this sprint, which matches the "architectural" theme).

---

## Rules verified at opening

- [x] Each issue has a complete discovery card — #33, #35, #38, #37 all verified `ready` or with `blocked` resolution path documented (#38's `blocked` is removed by ADR-006 in commit 1)
- [x] Total `In Progress` issues ≤ 7 — will open ≤ 2 at a time
- [x] Parallel ≤ 30% of total estimated effort — 9.5%, well within
- [x] `GOAL.md` goal is covered by selected issues
- [x] `blocked` issues have their dependency identified — #38 blocked on ADR-006; resolution path: ADR-006 is commit 1 of #38's PR
- [x] Code-state audit completed at opening (S2 retro change-list discipline) — see log.md 2026-05-15 for #33, #35, #38 findings
