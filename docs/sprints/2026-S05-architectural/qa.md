# QA Pass — Sprint S05

> Mandatory checklist BEFORE writing `retro.md` and closing the sprint.
> If an item isn't met → either document why in `retro.md`, or the sprint does NOT close.

---

## Goal & scope

- [x] **Sprint goal achieved** — Trading↔MarketData leak resolved (ADR-002 implemented), 11 events cleaned (5 ghosts deleted + 5 audit handlers + 1 FxRatesRefreshed dropped), SimpleUseCase + ADR-006 frontloaded and 9 use cases migrated.
- [x] **All `main` scope issues** closed — #33 (PR #64), #35 (PR #65), #38 (PR #66).
- [x] **Parallel issues** closed — #37 S05 slice (PR #67) + memorialized tokens.md §4.1/§4.2.
- [x] **No unclosed issues** at sprint boundary. #37 remains open by design (tracking issue spans S3-S6; S05 slice merged).

## Code health

- [x] `bundle exec rspec` — **2198 examples, 0 failures**
- [x] `bin/rubocop` — 803 files, 0 offenses
- [x] `bin/brakeman` — 0 errors, 0 security warnings
- [x] `bin/bundler-audit` — no vulnerabilities
- [x] CI on GitHub Actions green (PRs #64, #65, #66, #67 all merged with green checks)
- [x] Working tree clean

## Vision compliance

- [x] **Manual audit of new copy** — no ADR-001 violations. The only user-facing surface touched was the dashboard's news/trending Turbo frames (which kept their pre-existing copy) and the integrations admin page (admin-only, status badges).
- [x] **Manual scope audit** — no non-goals violated. S05 was purely architectural: zero features, zero JTBDs added.
- [x] **JTBD mapping** — S05 didn't ship any feature. ADR-002, ADR-006, and the cleanup are architectural enablers; no JTBD required (matches the sprint's "architectural" theme).
- [x] **Each issue's discovery card** fulfilled. DoD deviation logged: #38's discovery card listed 10 use cases but `Trading::UseCases::LoadAssetTrend` was already deleted in S03's Phase 22 cleanup. Migration scope adjusted to 9, documented in ADR-006 "Implementation" section.

## Documentation

- [x] **2 new ADRs** written — [ADR-002](../../architecture/adr/0002-trading-marketdata-boundary.md) implementation reference (already drafted in S04 #59) + [ADR-006](../../architecture/adr/0006-simple-use-case-criterion.md) (new this sprint).
- [x] **CLAUDE.md amendments** — "Cross-Context Communication" section rewritten for ADR-002; "Use Case Base Classes" section rewritten for ADR-006.
- [x] **Design docs** updated — `tokens.md` gained §4.1 (`-fg` foreground pattern, WCAG AA rationale, hex table) and §4.2 (Fear & Greed heatmap exception with re-evaluation trigger).
- [x] **`docs/architecture/conventions.md`** created — first iteration of the conventions guide referenced by ADR-006.
- [ ] **Screenshots regenerated** — deferred to S07 beta-prep per S04 retro decision; no visual delta this sprint anyway (admin views only).
- [x] **Memory updated** — `feedback_pr_review_workflow.md` rewritten mid-sprint with critical-evaluation triage table after Adrian flagged 0/22 rejection rate. `project_working_method.md` already had the 1.2× / 1.3× / 1.5× multiplier from S04 retro.

## GitHub hygiene

- [x] **Closed issues** all show terminal state on GitHub (#33, #35, #38 CLOSED).
- [x] **Milestone ready to close** — all main + parallel work in terminal state.
- [x] **No orphan issues** in the sprint without a status.

## Usage metric (post-close verification)

S05 shipped zero user-facing features. The metrics that apply are architectural:

| Architectural axis | Expected | State |
|---|---|---|
| ADR-002 implementation: no direct AR access from Trading | grep -rn 'NewsArticle\|MarketIndex\|FearGreedReading' app/contexts/trading/ → 0 hits | ✅ verified (only `MarketSentiment.for_user` remains, grandfathered with `@api public` marker) |
| ADR-006: SimpleUseCase adoption | 9 use cases migrated; controllers use `rescue ActiveRecord::RecordNotFound` / `RecordInvalid` | ✅ verified — 6 `case/in Success` blocks removed from controllers |
| Zombie/ghost events: 0 in repo | grep on event files vs subscriptions → 0 mismatch | ✅ verified — 5 ghosts deleted, 5 audit handlers added, 1 publish removed |
| #37 S05 slice metric | audit-entropy hardcoded color hits | 160 → 141 (-19; target was ≤140, off by 1; honest-tailed in PR #67) |

## Audit-entropy delta

| Metric | S04 close | S05 close | Direction | Notes |
|---|---|---|---|---|
| Cross-context leaks (regex) | 9 | **13** | ⚠️ UP | **Metric definition gap** — see Additional notes |
| Hardcoded USD literals | 8 | 8 | Flat | S05 didn't touch this axis |
| ADR-001 violations | 1 | 1 | Flat | S06 territory (#36) |
| Bloated docs (>200 lines) | 12 | 12 | Flat | `components.md` (821 lines) still unreferenced, watchlist for S06 retro |
| TODO/FIXME markers | 2 | 2 | Flat |
| Hardcoded color classes | 160 | **141** | ✅ -19 | S05 slice target was ≤140 (off by 1, scope creep avoided) |

---

## Additional notes

### Honest finding: cross-context "leaks" metric went 9 → 13

This is **not a regression** — it's a metric definition problem. The audit-entropy regex counts any `OtherContext::*` reference, but doesn't distinguish between:

- **Real ADR-002 violations** (direct AR model access, gateway instantiation across contexts)
- **Sanctioned supplier-API calls** (`MarketData::Queries::*`, `MarketData::UseCases::*`, explicitly-marked `Domain::*` reads)
- **Foreign event publishing** (Administration publishing `Identity::Events::*` and `MarketData::Events::*`) — a separate concern documented in code-audit-2026-05 as ADR-005 candidate

After #33 landed, AssembleDashboard now has 5 explicit calls to `MarketData::Queries::*` (which are sanctioned), plus 1 grandfathered `MarketSentiment.for_user`. The metric counted the named call sites as "leaks" — but they're exactly the customer/supplier pattern ADR-002 prescribed.

**Verdict:** real ADR-002 leak count went from 5+ (AR model access in AssembleDashboard + FxRateResolver gateway) to **0**. The metric counted increased because the new explicit reads are now visible as named call sites.

**Carry to S06:** refine the audit-entropy regex to respect ADR-002 — exclude `Queries::*`, `UseCases::*.call`, and the marked `Domain::*` read APIs from the leak count. The metric currently triggers a false alarm and undermines its own value.

### Working method update mid-sprint

After PR #65 Adrian flagged the 0/22 Gemini-comment rejection rate across S04-S05 as rubber-stamping. `feedback_pr_review_workflow.md` was rewritten with:
- Triage table by value-added (bug / perf / consistency → apply; defensive coding / ceremony / in-flight-conflict / style → reject)
- "Hypocritical reply" anti-pattern (noting tension and applying anyway is worse than disagreement)
- Rejection-rate sanity check (sustained 0% over 3-4 PRs → next ambiguous comment defaults to reject)
- Reply templates for both applied and rejected outcomes

Applied to PRs #66 (1 rejection / 4 comments) and #67 (1 rejection / 3 comments) — first defended rejections in the sprint. Workflow change memorialized in commit `d31cade`.
