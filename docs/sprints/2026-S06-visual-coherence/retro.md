# Retro — Sprint S06 (visual-coherence)

> Honest post-mortem. Without retro, the sprint does NOT close (hard rule of the protocol).
>
> **Close date:** 2026-05-15
> **Actual duration:** ~8 Claude session-hours, 1 calendar day (compressed, same-day as S05 close)
> **Estimated duration:** ~21.2 session-hours (per scope.md, 1.2× factor on 18h raw)
> **Goal:** *"Cerrar la migración a brand v2 — reescribir el copy prescriptivo (Parabolic/Strong, Upside/Downside) per ADR-001, reducir ≥60 hits de color hardcoded (141 → ≤80) aplicando tokens semánticos + brand fonts vía clase, y trimear components.md (821 → ≤200 líneas) — sin agregar features."*

---

## What worked?

- **The atomic-commit + per-PR shape held cleanly across 3 PRs.** PR #69 (#36, 3 commits), PR #71 (#37 final slice, 7 commits including the Gemini fix), PR #72 (#68, 2 commits). Each PR matched the work shape; no monolithic dumps. The S04 pattern is now muscle memory — the discipline of "1 commit = 1 logical change" reduced cognitive load in review and made the Gemini-comment triage easier (replies could reference the exact commit that addressed the concern).
- **Three opening-style audit-entropy refinements landed without scope-creeping into feature PRs.** Per S05 retro carry-over (A), the cross-context-leaks regex was refined first thing (`a896f92`, 13 → 5). Then mid-stream as I worked, I caught two more false positives (legal/ disclaimers for ADR-001 in `bd7aef7`; border-direction widths for color-hits in `10f7e9c`). Each landed as a focused chore commit on master, distinct from feature work. The pattern: *when the rule changes, refresh the metric in a separate commit*. Three uses of the pattern in one sprint built the habit.
- **The font-display global CSS rule was the highest-leverage commit of the sprint.** One CSS selector (`h1, h2, h3, h4, h5, h6 { font-family: var(--font-family-display); }`) applied Plus Jakarta Sans to every heading across ~200 view files without touching any view file. Solved a S2-era milestone item ("brand fonts applied via class") in 9 lines of CSS instead of a 200-file PR. Worth remembering: when a rule is universal, a global rule beats per-instance application.
- **Mixed accept/reject pattern in PR reviews is now the workflow norm.** #69 (2 rejects, both architectural out-of-scope), #71 (2 accepts, both inconsistent applications of own pattern), #72 (2 partial + 1 accept, mixed-validity). Net 5/7 accept (71%). The S05-rewritten review workflow is producing exactly the right shape — defended rejects when scope is wrong, honest accepts when drift is real. The rubber-stamp regression from pre-S05 hasn't returned.
- **`components.md` trim revealed a strategic insight invisible while writing.** The 821-line catalog described what the spec *intended* (Lumen palette tokens like `bg-bg-surface`, `bg-bg-muted`); the implementation uses *what the @theme actually defines* (`bg-white`, `bg-slate-200`). Gemini caught this on PR #72 as "doc/code drift", but the deeper observation is that **`tokens.md` documents a target palette while `@theme` implements a subset**. Surfaced as a S07+ work item; would have stayed invisible without the trim forcing each token name to be verified against reality.
- **Estimate calibration is now usefully tight, not slack.** Raw estimate was 18h; 1.2× gave 21.2h projected. Actual ~8h. The 1.2× factor (calibrated in S05) is still too pessimistic for *mechanical refactor sprints with AI-accelerated editing*. Three sprints of data now: S03 (~12h vs 25h projected = 0.5×), S05 (~22h vs 27h = 0.8×), S06 (~8h vs 21h = 0.4×). Pattern: pure-refactor sprints with existing ADRs run faster than feature sprints. New rule-of-thumb: 1.0× for refactor sprints, 1.3× for feature sprints. Will track in working method memory.

## What didn't work?

- **The 24h-pause hard rule was violated knowingly.** S05 retro committed 16:12 UTC; S06 opened 16:32 UTC same day. I flagged it at opening, asked Adrian explicitly, and proceeded with the violation documented in `log.md`. Honest evaluation in retro: **the pause would not have changed anything material this sprint.** Context-warmth was real (S05 carry-overs were front-of-mind, audit script behavior was fresh), and the scope was pre-baked (3 issues with complete discovery cards). However, this is data-of-one — the 24h rule was designed to prevent anti-pattern #1 ("next phase = next thing to build") in cases where the next sprint isn't obvious. S06's next sprint *was* obvious (the S05 retro carry-overs literally named #36, #37, #68). So the pause guards against a different failure mode than what S06 faced. **Conclusion: keep the rule; it's a guard against rushed scoping, not against work-after-retro per se. The override needs to remain explicit and rare.**
- **The PR #72 review surfaced two layers of doc/code drift I didn't catch myself.** I wrote the trimmed `components.md` describing `bg-bg-surface` and `bg-bg-muted` tokens because they're in the Lumen spec (`tokens.md` §1). I didn't cross-check against the actual `@theme` block in `application.css`. Gemini's first comment pointed at the implementation; that's when I realized the doc was prescribing tokens that don't exist. **Carry-forward:** when claiming "implementation is source of truth", VERIFY the implementation token names actually exist before writing them in the doc. Cheap habit; expensive omission.
- **The sparkline migration slipped past #37's regex sweep.** `_sparkline.html.erb` builds class strings dynamically (`bg-<%= color %>-<%= ... %>`). The audit-entropy regex matches *literal* tokens in the source, not class names resolved at render time. The migration sweep was clean per the audit but missed this real instance. Gemini caught it via the doc-vs-code comparison in PR #72. **Carry-forward:** consider a stricter audit pass (grep for the *base* color words `emerald|rose|amber|indigo|teal` in views regardless of context) as a complement to the existing regex. Or treat dynamic-class patterns as a discovery card explicit-check item for any future migration sprint.
- **The "border-l-4 false positive" took 3 commits to fully address.** First fix (`a896f92`) only covered cross-context leaks. Mid-sprint I noticed the ADR-001 legal-disclaimer false positive — second fix (`bd7aef7`). Then near the end I noticed border-direction-width was being counted as color — third fix (`10f7e9c`). The three fixes are individually correct, but I should have audited the entire regex set during the opening commit instead of finding each one incrementally. **Carry-forward:** when refining one metric for honesty, do a once-over of all metrics in the script in the same sitting.

## What to change for the next sprint?

- [ ] **Update calibration in `project_working_method.md`:** 1.0× for pure-refactor sprints with existing ADRs; 1.3× for feature sprints. Three data points (S03, S05, S06) all came in well under projected with the 1.3×/1.2× factors. Save 1.3× for genuine feature sprints.
- [ ] **When writing docs that claim "code is source of truth", verify all token names against the actual `@theme` block before publishing.** Cheap pre-flight check; would have avoided the #72 round 1 comments.
- [ ] **Open follow-up issue: Lumen palette full adoption** (`bg-bg-surface`, `fg-default`, `border-default`, `fg-subtle` and the rest of the Lumen family from `tokens.md` §1). The `@theme` currently exposes only the semantic role tokens + their `-fg` variants + `background-light/dark`. Adopting the full Lumen palette would touch every view consistently. Not blocking beta; warrants its own ADR + sprint.
- [ ] **For migration sprints, add explicit discovery-check for dynamic class strings.** The sparkline slip taught: any future "migrate hardcoded X to semantic Y" sprint should explicitly grep for *base color words* + check for any view that builds class strings via ERB interpolation. The current audit catches the static case but not the dynamic.
- [ ] **At sprint opening, do a once-over of `script/audit-entropy.sh` regex set.** If any rule has changed in the last sprint, refresh all related metrics in one focused commit — don't discover false positives reactively during work.

---

## Vision alignment — state of the 6 axes

| # | Axis | Before (S05 close) | After (S06 close) | Notes |
|---|---|---|---|---|
| 1 | Every feature maps to a JTBD | 95% | 95% | No change — S06 shipped zero features. |
| 2 | Zero prescriptive copy in code | 75% | **90%** | **The headline jump.** #36 cleared Parabolic/Strong/Upside/Downside; audit-entropy ADR-001 grep shows 0 (regulatory disclaimers excluded). The remaining 10% is residue I'd find in another sweep (e.g., admin-internal labels not yet audited). |
| 3 | Zero aspirational fake copy | 90% | 90% | Holding. |
| 4 | Dashboard arithmetic truthful for MXN+USD | 95% | 95% | Holding. |
| 5 | Architecture without cross-context leaks | 70% | 70% | Holding. The 5 remaining "leaks" are Administration publishing foreign events (`Identity::Events::*`, `MarketData::Events::*`) — the ADR-005 future. S06 was scope-explicit about not touching this. |
| 6 | Docs reflect current code | 95% | **97%** | Small bump. `components.md` trim closed a four-sprint carry-over. The remaining 3% is residue: `experts.md` (430 lines, S1 flag), `tokens.md` (257 lines, Lumen-vs-@theme drift surfaced this sprint). Both are S07 candidates. |

**Synthesis:** S06 closed the visual-coherence theme. Axis #2 absorbed the biggest jump (75% → 90%). Axis #6 ticked further up (95% → 97%) with the `components.md` trim. The remaining drag on the 6 axes is now concentrated in ADR-005 (axis #5) and Lumen-palette adoption (axis #6 indirectly via tokens.md/@theme divergence). Beta-cerrada B+ is closer than it's ever been.

---

## Anti-patterns I committed (if any)

Reviewed against `feedback_anti_patterns` in persistent memory.

- **#1 (Next phase = next thing to build) — TECHNICALLY violated via the 24h-pause override, NOT in spirit.** S06 was scoped from S05 retro carry-overs, all 3 issues had complete discovery cards, and there was no "what's next?" anxiety driving the open. The hard-rule violation is on the books but the underlying anti-pattern (rushed scoping driven by anxiety to ship) was not present. Documented honestly in log.md and qa.md.
- **#2 (PRD as gospel) — NOT violated.** No PRD reference.
- **#3 (Patterns over pragmatism) — NOT violated *for what I built*.** The two known cases (orange/lime taxonomic pills in `_asset_header`, slate-on-skeleton placeholder) were *not* coerced into semantic tokens to satisfy the audit. Both were documented as intentional exceptions with reasoning. This is the right call: forcing semantic tokens onto taxonomic colors injects opinion the data doesn't carry.
- **#4 (Doc bloat) — NOT violated; ACTIVELY REDUCED.** `components.md` 821 → 155 (-666 lines). Bloated-docs count dropped 12 → 11.
- **#5 (Skipping foundational checks) — NOT violated.** Opened with audit-entropy regex audit + re-baseline. Code-state audit per file before each migration cluster.
- **#6 (Fragmenting redesigns without closing) — NOT violated.** #37 tracking issue closed for real this sprint (S3-S6 finalized). #68 carry-over from S02 finally closed. The fragmentation that was happening over four sprints stopped here.
- **#7 (No retros / no audits) — ACTIVELY RESPECTED.** This file. Audit-entropy ran at open + mid-sprint + close. PR review workflow continued from S05.
- **#8 (Rubber-stamping reviewer comments) — ACTIVELY RESPECTED.** Mixed 5-accept/2-reject ratio across 3 PRs; each decision argued in-thread.

**Score: 0 of 8 anti-patterns committed in this sprint *in spirit*.** One technical hard-rule violation (24h pause) documented and evaluated honestly.

---

## Real vs estimated time

| Phase | Estimated (×1.2) | Real | Reason for deviation |
|---|---|---|---|
| Sprint opening + 2 audit fixes | 0.5 h | ~0.5 h | OK |
| #36 — rewrite prescriptive labels | 4.8 h | ~1.5 h | Smaller scope than estimated — only 2 view files + 1 spec needed touching. News-sentiment vocab work disappeared (LLM was deprecated in Phase 4, the partial that had drift no longer exists). |
| #37 — semantic token migration final slice | 12 h | ~3 h | Biggest under-estimate. Mechanical migration on a clear pattern, file-by-file in 4 focused commits. AI-accelerated editing turns 8h of regex-replace-test loops into 30-minute clusters. The Gemini round (1 commit, 4 line changes) was 15 min. |
| #68 — components.md trim | 2.4 h | ~2 h | OK — closer to estimate. Most of the work was *thinking* about what to keep vs delete, which is the same speed regardless of edit tooling. Gemini round + doc revisions took ~30 min. |
| S06 close (QA + retro + memory updates) | 1.5 h | ~1 h | OK |
| **Total** | **21.2 h** | **~8 h** | **0.4× of projected.** Three data points now: S03 (~0.5×), S05 (~0.8×), S06 (~0.4×). |

The pattern: **pure-refactor sprints with existing ADRs and complete discovery cards run at 0.4–0.8× of the legacy estimate**, not 1.2× or 1.3×. The previous calibration band was sized for feature sprints where unknowns appear during implementation. Refactors don't have unknowns — the design is decided. AI-accelerated editing collapses the mechanical phase further.

**Calibration update for S07+:** track separately by sprint type. **Feature sprints:** 1.3× (S02, S04 data). **Refactor sprints with existing ADRs:** 1.0×. **Pure-mechanical migration sprints (like S06 #37):** 0.5×.

---

## Registered decisions

- **`script/audit-entropy.sh` refined three times** for metric honesty: cross-context-leaks excludes ADR-002 sanctioned reads + `MarketData::Domain::MarketSentiment` (grandfathered); ADR-001 excludes legal/ disclaimers; hardcoded-color excludes `border-{l,r,t,b,x,y}-N` width utilities.
- **`font-display` applied globally via CSS rule** instead of per-heading class, established as the pattern for any universal typography rule.
- **`components.md` rewrite philosophy:** the ERB partial is source of truth; the doc lists purpose / variants / tokens used and links to the file. When they disagree, the code wins, and the doc gets a PR.
- **Taxonomic colors are not state colors.** The asset-type pills (crypto orange, fixed-income lime/teal, etf indigo) are documented exceptions that should not be coerced into success/error/warning/info. Same precedent as F&G heatmap.
- **`tokens.md` describes Lumen target; `@theme` implements a subset.** Surfaced by #72 review. Documented gap; flagged for S07+ Lumen-adoption work.
- **Calibration: 0.5–1.0× factors for refactor sprints**, not 1.2–1.3×. Updated in working method memory.

---

## Issues open at close

- **#70 — TrendScore enum rename.** Created during #69 review; no milestone. Internal nomenclature drift; not user-visible; not blocking. Backlog candidate for S07 if a coherent slot opens.
- **(Implicit) Lumen palette adoption.** Not yet an issue. Surfaced by #72 review. Worth converting into a tracked issue with discovery card before S07 opens.
- **(Implicit) Sparkline-class-dynamic audit gap.** Not yet an issue. Could be a small tooling commit or a hardening note in `audit-entropy.sh`.

No issues from S06 scope deferred to backlog — all 3 main issues (#36, #37, #68) closed.

---

## Brutal quote of the sprint

> *"The catalog described what the spec intended. The code implemented what the @theme actually defined. The mismatch lived for four sprints because no one read the catalog with the @theme open beside it. Trimming the doc made it visible — not because the trim itself fixed anything, but because every claim had to be re-justified against reality before it survived the cut. Documentation is a forcing function for verification, not a record of intentions."*
