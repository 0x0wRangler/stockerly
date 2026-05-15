# QA Pass — Sprint S06 (visual-coherence)

> Mandatory checklist BEFORE writing `retro.md` and closing the sprint.
>
> **Close date:** 2026-05-15

---

## Goal & scope

- [x] **Sprint goal achieved** — close brand v2 migration end-to-end. Copy rewritten per ADR-001 (#36, PR #69), 141 → 62 hardcoded color hits (#37 slice final, PR #71), brand fonts globally applied via CSS rule, `components.md` trimmed 821 → 155 (#68, PR #72). All three main issues closed.
- [x] **All `main` scope issues** are closed — #36, #37, #68 all CLOSED
- [x] **Parallel issues** — none in S06 (sprint was theme-coherent)
- [x] **Unclosed issues** — #70 created during #69 review as follow-up for TrendScore enum rename; no milestone assigned (backlog candidate for S07)

## Code health

- [x] `bundle exec rspec` green — **2198 examples, 0 failures** (94.64% line coverage, 76.76% branch)
- [x] `bin/rubocop` no offenses — 803 files inspected, clean
- [x] `bin/brakeman` no new warnings — 32 models, 130 templates, 0 errors, 0 security warnings
- [x] `bin/bundler-audit` no vulnerabilities — 1122 advisories database (last updated 2026-05-14), no hits
- [x] CI on GitHub Actions green — confirmed at #69, #71, #72 merge time
- [x] Working tree clean — verified at QA start

## Vision compliance

- [x] **Manual audit of new copy** — `grep -rEn 'Parabolic|Upside|Downside|Strongest|"Strong"|"Weakening"|"Weak"' app/views/` returns 0 hits. ADR-001 grep in `audit-entropy.sh` returns 0 violations (after legal/ exclusion landed at opening).
- [x] **Manual scope audit** — no new features added. Sprint was deliberately refactor-only.
- [x] **JTBD mapping** — no new features ⇒ no new JTBD claims. The migrations preserved feature behavior; only presentation changed.
- [x] **Each issue's discovery card** was fulfilled:
  - **#36 DoD:** ✅ Parabolic/Strong/Moderate/Weakening/Weak buckets replaced with High score/Moderate/Low-moderate/Low score · Upside/Downside → Target Δ% · News sentiment vocabulary N/A (LLM was deprecated in Phase 4, sentiment surface gone) · TrendScore tooltip clean of action labels · Tests pass on new labels · Screenshots deferred per S04 retro.
  - **#37 S06 slice DoD:** ✅ Final brand migration · `font-display` applied via global CSS rule · WCAG `text-X-fg/N` opacity (carry-over B) cleared · Target delta ≥60 (achieved 79: 141 → 62) · Audit-entropy shows decrease.
  - **#68 DoD:** ✅ `components.md` 821 → 155 lines (≤200 target) · Every catalog entry links to ERB file or marks "planned" · Markup sketches removed · Cross-links from brand.md / tokens.md verified · Bloated-docs count 12 → 11.

## Documentation

- [x] **No new ADR** — none warranted (no new architectural decisions; S05 ADR-002 and ADR-006 still standing as the recent ones)
- [x] **Vision update** — no audience/scope changes; beta-cerrada B+ framing intact
- [x] **Design docs updated** — `components.md` rewritten · `brand.md` anchor updated to match new structure · `tokens.md` unchanged (already documented the `-fg` WCAG pattern this sprint enforced)
- [⚠️] **Screenshots NOT regenerated** — per S04 retro decision, deferred to S07 beta-prep. Visual changes did happen (font swap, color migrations) but the screenshots/ folder waits for the beta-invite milestone.
- [x] **CLAUDE.md / IDENTITY.md / memory** — no working-method changes this sprint; existing rules held. Memory updates queued for after retro (see `Update memory` todo).

## GitHub hygiene

- [x] **Closed issues** — #36, #37, #68 all CLOSED via PR merges (#69, #71, #72)
- [x] **Milestone ready to close** — 0 open issues in milestone
- [x] **No orphan issues** — only #70 left ungrouped (no milestone), explicitly tracked as follow-up backlog candidate

## Usage metric (post-close verification)

S06 was a non-feature sprint. No new JTBD surfaces were added; all 6 canonical JTBDs continue to have surfaces with the same usage profile as S05 close. The "metric" of this sprint is the entropy audit (above) rather than user-facing usage counts.

| JTBD | Expected metric | State |
|---|---|---|
| All 6 canonical | Same surfaces as S05 close, descriptive copy + token coherence improved | ✅ no regression (specs + manual review + CI all green) |

---

## Additional notes

### Entropy audit — sprint deltas

| Metric | S05 close | S06 close | Delta | Sprint target | Status |
|---|---|---|---|---|---|
| Cross-context leaks (post-regex-fix) | 5 | 5 | 0 | ≤5 flat | ✅ holds at ADR-005 future scope |
| Hardcoded "USD" literals in app/ | 8 | 8 | 0 | — | ✅ holds |
| ADR-001 violations in views | 1* | 0 | -1 | 0 | ✅ (legal/ exclusion at opening, #36 finishes the product copy) |
| Bloated docs (>200 lines) | 12 | 11 | -1 | ≤11 | ✅ (`components.md` no longer counts) |
| TODO/FIXME/XXX markers | 2 | 2 | 0 | — | ✅ holds |
| Hardcoded color classes in views | 141 | 62 | **-79** | ≥-60 delta (≤80 absolute) | ✅ exceeded |

\* S05 close ADR-001 count was 1, mis-counted as a "violation" — the only hit was the legal/risk_disclosure.html.erb CFTC-style "you should consider..." which is regulatory boilerplate. Opening commit `bd7aef7` excluded app/views/legal/ from the regex; S06 close reads 0 honestly.

### Tooling refinements landed this sprint

Three opening-or-follow-up commits refined the audit-entropy script for metric honesty:
- `a896f92` — exclude ADR-002 sanctioned reads (Queries::, UseCases::, MarketData::Domain::MarketSentiment grandfathered) from cross-context-leaks count. Re-baseline 13 → 5.
- `bd7aef7` — exclude app/views/legal/ from ADR-001 count. Re-baseline 1 → 0.
- `10f7e9c` — exclude `border-{l,r,t,b,x,y}-N` width utilities from hardcoded-color-classes count. Re-baseline 64 → 62.

All three are the same pattern: when the rule changes, the metric must be refreshed to measure what the rule actually says.

### PR review workflow — first sprint with mixed accept/reject pattern

S06 saw the first PR cycle where Gemini comments produced both honest rejects and honest accepts, refining the workflow established mid-S05:

- #69 (2 comments): 2 rejects — both architectural out-of-scope (i18n adoption, TrendScore enum rename). #70 issue opened for the second as a real follow-up.
- #71 (2 comments): 2 accepts — both inconsistent applications of the PR's own pattern (missing `-fg dark:` halves on 2 lines).
- #72 (3 comments): 2 partial-accepts + 1 accept — drift was real (font-mono, sparkline tokens) but suggestions were partly based on tokens that don't exist in `@theme` (Lumen palette not yet adopted).

Net accept rate: 5/7 (71%). Pattern: real drifts accepted, scope creep + nonexistent-token suggestions rejected with reasoning. This is what the S05 retro called for after the "0/22 rubber-stamp" wake-up.

### Surfaced for S07+ (in-flight follow-ups)

- **#70 — TrendScore enum rename.** Backlog candidate; user-invisible drift.
- **Lumen palette full adoption.** Surfaced by #72 review: `tokens.md` describes the Lumen target (`bg.surface`, `fg.default`, `border.default`, `fg.subtle` etc.); current `@theme` exposes only the semantic role tokens (`success/error/warning/info` + `-fg` variants) + `background-light/dark`. Adopting the full Lumen palette would touch every view consistently. Not blocking beta; worth an ADR + dedicated sprint slot.
- **i18n adoption.** Surfaced by #69 review: `app/` has 0 `t()` calls. If/when locale demand validates (post-beta), a project-wide ADR and sprint would migrate every hardcoded string at once. Not blocking beta.
- **24h-pause violation.** Documented in S06 log.md at opening (S05 closed 16:12 UTC, S06 opened ~16:30 UTC the same day). Evaluate in retro whether this caused real cost or whether the context-warmth was net-positive.

---

**Ready for retro.**
