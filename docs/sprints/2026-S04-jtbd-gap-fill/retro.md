# Retro — Sprint S04 (jtbd-gap-fill)

> Honest post-mortem. Without retro, the sprint does NOT close (hard rule of the protocol).
>
> **Close date:** 2026-05-15
> **Actual duration:** ~18 Claude session-hours, 1 calendar day (single-day high-intensity)
> **Estimated duration:** ~28.5 session-hours (per scope.md, 1.5× factor on 19h raw)
> **Goal:** *"Cerrar los 2 JTBDs sin superficie verificable (#3 CETES maturity, #6 Notable Observations) y dejar ADR-002 escrito para desbloquear el sprint arquitectónico — todos los 6 JTBDs canónicos quedan con feature observable en producto."*

---

## What worked?

- **All 6 canonical JTBDs now have product surfaces.** The headline outcome: pre-S04, axis #1 was 80% with JTBD #3 and #6 documented but invisible. Post-S04, both ship with daily detectors, dashboard cards, and asset detail blocks. Beta-prep (S07) can now reference a concrete demo path for every JTBD.
- **ADR-002 frontloaded the architectural decision.** Writing ADR-002 as the first PR (#60) of the sprint locked the customer/supplier pattern decision early. The new code in #29 (Trading::UseCases::NotifyApproachingMaturities) and #40 (dashboard controller reading TechnicalObservation via public scopes) was already ADR-002-shaped by the time it was written. Saved a refactor pass.
- **Code-state audit at open caught both DoD-vs-reality deviations.** Per S03 retro action item. Two findings logged in `log.md` 2026-05-15 *before* commit: (a) `asset_type :fixed_income` enum value vs DoD's `'cetes'`, (b) handler home in `Trading::UseCases` vs DoD's `Alerts::Handlers`. Both deviations resolved with logged reasons. Zero mid-sprint surprises across both main-scope features.
- **Gemini reviews caught the right things, and disagreement was productive.** Three rounds across the four PRs. Notable saves:
  - **PR #61 HIGH** (CETES lot-merge): my spec was *pinning the bug* (`keeps existing maturity_date when adding to an open CETES position`). Replaced with a lot-separation spec that proves the corrected behavior.
  - **PR #62 HIGH** (memory bottleneck): unbounded `pluck(:close)` was O(history_size) per asset. Capped to a 210-row trailing window.
  - **PR #63 medium x3** (a11y collapse): collapsing `text-X-700 dark:text-X-400` into a single `text-X` token failed WCAG AA. Resolved by adding `-fg` tokens to @theme — a design-system precedent for S5/S6 slices.
- **The atomic-commit PR shape held.** Each PR: 5-8 granular commits, `Fixes #N`, full local CI, Gemini pass, follow-up fix commit, inline replies. Same skeleton as S03 — patterned, predictable. Per-PR commit budgets: #60 (2), #61 (8), #62 (7), #63 (5). Sizes match work shape (ADR is small + 2 fixes; features are bigger).
- **The `-fg` token pattern landed as a system, not a patch.** Round 1 of PR #63 was wrong about the trade-off (collapsed text variants). The fix wasn't a partial revert — it was a proper system addition: 4 new semantic tokens with documented contrast targets, propagated across all 3 migrated files, becomes a precedent for future slices. Renata (C5) would mark this as a real brand-system maturity moment.
- **ADR-002 unblocked #33 immediately.** Issue #33 was `blocked` waiting for ADR-002. The moment PR #60 merged, removed `blocked` and added `ready`. S05 has its main-scope item already queued. The "frontload the unblocker" pattern works.
- **All 4 PRs merged with green CI on the first push attempt.** No CI flakes, no broken master, no rollback. Discipline of local rspec + rubocop before push held perfectly.

## What didn't work?

- **Estimate was 1.6× too high.** scope.md projected 28.5h; actual was ~18h. Where did the savings come from? Mostly: (a) #29 and #40 closely mirrored existing patterns (`NotifyApproachingEarnings` for #29; `TrendScoreCalculator` for #40), so the "new feature" cognitive cost was lower than budgeted; (b) discovery cards were honest about the additive nature, so no surface-area surprises; (c) the new -fg token system in #63 round 2 was a one-pass design decision, not a slow back-and-forth. **Calibration:** even for new-feature sprints, 1.5× over raw hours appears pessimistic when discovery + existing-pattern proximity are high. Two consecutive data points (S03: 25.5h est → 12h real with 1.5×; S04: 28.5h est → 18h real with 1.5×) suggest the multiplier should drop to **1.3× for new-feature sprints with a nearby existing pattern**, keeping 1.5× only for greenfield work (no existing pattern to copy). Update memory.
- **The cool-off rule does not exist.** S03 retro recommended "respect 24h cool-off at S3→S4 default". S04 opened the same day → 1st override. S04→S5 hasn't happened yet, but the rule was never codified into `project_working_method.md` memory (verified during this retro). 2-of-2 evaluated transitions overrode it. The rule lives only in retro action items; it's theater. **Carry-over:** strip the rule from the S03 retro's action-item list retroactively, and explicitly declare in `project_working_method.md` that sprint cadence is user-paced, not date-paced. Don't write a rule we're going to ignore.
- **Screenshot regen deferred 2/2 sprints.** Same pattern as cool-off: the S03 retro carry-over said "establish baseline at S4 opening (light commit)". S04 opening: deferred to close. S04 close: deferred to S07 beta-prep. The rule isn't being followed because there's no automation (Capybara screenshot infrastructure doesn't exist), and manual capture has high friction relative to value pre-beta. **Carry-over:** S07 beta-prep takes ownership; if it gets deferred a third time, the carry-over should be deleted entirely.
- **The `_fear_greed_card.html.erb` exclusion was a judgment call worth flagging.** S04 slice deliberately skipped this partial (7 hits) because the colors form a heatmap (red→orange→amber→lime→emerald) not a semantic set. Two failure modes if this judgment is wrong: (a) the audit metric never reaches 0 because heatmap views block it; (b) the system never gets `color-fear-*` tokens, so heatmap UIs stay hardcoded forever. Compromise: at S5 close, audit how many "true heatmap" views vs "false heatmaps that ARE semantic" exist. If the count is ≥2, define heatmap-bucket tokens (`color-scale-low/mid/high`); if it's still just F&G, leave hardcoded with documented exception.
- **No N+1 regression test for NotifyApproachingMaturities.** PR #61 Gemini round 1 caught the N+1 in `already_notified_today?` and fixed it. The fix was correct but I didn't write a counter-based spec (`expect { use_case.call }.to make_database_queries(count: N)`). If a future refactor reintroduces an N+1, only Gemini's next pass would catch it. **Carry-over:** add a `db-query-counter` spec idiom to the patterns directory for hot loops; retrofit for NotifyApproachingMaturities and DetectTechnicalObservations when one is touched next.

## What to change for the next sprint?

- [ ] **Drop the cool-off rule explicitly.** Action: in `project_working_method.md`, add a note that sprint cadence is user-paced (no 24h cool-off default). Retroactively comment in the S03 retro action item that the rule was evaluated 2× and dropped.
- [ ] **Recalibrate the multiplier.** Update `project_working_method.md`: use **1.3×** for new-feature sprints when an existing pattern is nearby; keep 1.5× for greenfield. Both S03 (deletion, 1.2×) and S04 (new-feature with pattern, 1.3×) come in well under the previous 1.5× default.
- [ ] **Add a `db-query-counter` spec idiom** to the project's spec patterns. Use it on at least one hot loop in S05 (e.g., the `Trading::UseCases` that the ADR-002 implementation touches).
- [ ] **At S5 close, audit the heatmap exception.** Count views with a "scale" color set vs views that misclassify their semantic colors as a scale. If ≥2 true heatmaps exist, define `color-scale-*` tokens before continuing the migration.
- [ ] **Memorialize the -fg token pattern.** Update `docs/design/tokens.md` (or the brand kit equivalent) with the `text-X-fg dark:text-X` rule and its WCAG rationale, so S5/S6 slices don't re-discover this.

---

## Vision alignment — state of the 6 axes

| # | Axis | Before (S03 close) | After (S04 close) | Notes |
|---|---|---|---|---|
| 1 | Every feature maps to a JTBD | 80% | **95%** | All 6 canonical JTBDs have product surfaces now. The 5% gap: admin-only views (SearchTickers, IntegrationUI) which are operational not user-facing, intentionally without a JTBD. |
| 2 | Zero prescriptive copy in code | 75% | 75% | No change — S04 didn't touch prescriptive copy. Carried by S06 (#36). |
| 3 | Zero aspirational fake copy | 90% | 90% | No change — S2 closed major surfaces; "Open Source Market Intelligence Platform" footer tagline remains the 10% gap. |
| 4 | Dashboard arithmetic truthful for MXN+USD | 95% | 95% | No change — S3 closed this loop. Historical FX storage still deferred. |
| 5 | Architecture without cross-context leaks | 35% | **40%** | Small bump. ADR-002 written but not implemented (that's S05). The new code from #29 and #40 was already ADR-002-shaped: NotifyApproachingMaturities is Trading-owned, dashboard's notable_observations controller reads MarketData via `TechnicalObservation` public scopes (not direct model joins). Pattern-leading rather than pattern-resolving. |
| 6 | Docs reflect current code | 90% | 90% | Holding. ADR-002 added; CLAUDE.md amendment for ADR-002 still pending (deferred to #33 implementation in S05). Bloated-docs count still 12 — `components.md` (821 lines) wasn't referenced once across S03 or S04. Cut candidate for S5 retro. |

**Synthesis:** Axis #1 made the headline jump (80% → 95%) by adding code instead of deleting code — the inverse of S03's lever. Axis #5 ticked up by precedent: even without implementing ADR-002, both new features in S04 already follow its pattern. The visual/copy axes (#2, #3) stayed put intentionally — those are S06.

---

## Anti-patterns I committed (if any)

Reviewed against [`.claude/memory/feedback_anti_patterns.md`](../../../.claude/memory/feedback_anti_patterns.md).

- **#1 (Next phase = next thing to build) — NOT violated.** Every PR driven by an explicit issue with a discovery card. No "while we're here" additions.
- **#2 (PRD as gospel) — NOT violated.** No PRD reference appeared anywhere in S04.
- **#3 (Patterns over pragmatism) — NOT violated.** The `-fg` token addition could have ballooned into a full design-token taxonomy; instead it's 4 new variables with a clear naming convention. The N+1 fix in PR #61 was a single Set-based pre-fetch, not an introduction of a query-pattern abstraction.
- **#4 (Doc bloat) — NOT violated.** ADR-002 is 132 lines and tightly scoped. The `log.md` and `retro.md` files grew, which is by-design.
- **#5 (Skipping foundational checks) — NOT violated.** Code-state audit at open caught both DoD deviations before commit. Per-PR local CI was green before every push.
- **#6 (Fragmenting redesigns without closing) — NOT violated.** S04 slice of #37 closes cleanly with -34 hits, leaves the tracker open by design (S5-S6 continue).
- **#7 (No retros / no audits) — ACTIVELY RESPECTED.** This file is the retro. Audit-entropy ran at open and close. The PR review workflow itself is a mini-retro per merge.

**Score: 0 of 7 anti-patterns violated.** Tied with S03 for the cleanest anti-pattern record since the protocol started.

---

## Real vs estimated time

| Issue / Step | Estimated (×1.5) | Real | Reason for deviation |
|---|---|---|---|
| Sprint opening (cool-off override #2, code-state audit, log) | 0.5 h | ~0.5 h | OK |
| #59 — ADR-002 draft (research → write → PR → Gemini × 1) | 3 h | ~2 h | Decision space narrowed by the inverse-leak deletion in S03; only 3 options (a/b/c) to weigh; the customer/supplier framing fell out cleanly. |
| #29 — CETES (6 commits + 1 Gemini round, 1 HIGH) | 12 h | ~6 h | NotifyApproachingEarnings was a perfect template; the HIGH bug (lot-merge) was caught and fixed in a single commit pass. |
| #40 — Notable Observations (6 commits + 1 Gemini round, 1 HIGH) | 10.5 h | ~5 h | TrendScoreCalculator pre-existed (similar shape); ADR-002 framing was already done so the user-state filter went into the Trading-side controller naturally. The HIGH bug (unbounded fetch) was a one-line cap. |
| #37 S04 slice — semantic tokens (3 files + Gemini round with a11y discovery) | 3 h | ~3 h | The migration itself was mechanical; the -fg token system was the only "thinking" portion. Round 2 took as long as round 1 (a11y is design work). |
| S04 close (QA + retro + memory) | 1 h | ~1 h | OK |
| **Total** | **28.5 h** | **~17.5 h** | New-feature multiplier of 1.5× was too pessimistic by ~35%; 1.3× is closer for pattern-adjacent work. |

---

## Registered decisions

- **ADR-002** — Trading↔MarketData boundary: customer/supplier pattern, formalized read API, no new BC, no merge. Includes the `-fg` foreground-token design decision from PR #63 round 2 (a11y) as a corollary in the brand system, not the ADR itself.
- **Informal decision: `_fear_greed_card` migration deferred.** The heatmap-color set doesn't map to semantic tokens. Either it gets `color-scale-*` tokens at S5 close (if ≥2 true heatmaps exist) or it stays as the documented exception.
- **Informal decision: drop the 24h cool-off rule.** 2/2 sprint transitions overrode it. Sprint cadence is user-paced.
- **Informal decision: screenshots regen pushed to S07.** No infrastructure today; manual capture is high-friction relative to pre-beta value.

---

## Issues open at close

- #37 — stays in milestone as a tracking-issue artifact. S04 slice closed (PR #63). S5 and S6 slices remain queued.

No issues from S04 scope deferred or moved to backlog. All main + parallel work landed.

---

## Brutal quote of the sprint

> *"The audit metric was right but the trade-off was wrong. Counting hardcoded color classes incentivized me to ship a contrast-failing collapse; the metric had to learn what a 'semantic token' actually means before the migration could continue. Audit scripts don't replace design review — they surface, they don't decide."*
