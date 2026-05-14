# Code Audit — Stockerly 2026-05-14

> **Date:** 2026-05-14 (Sprint 1 — Step 6)
> **Method:** 4 sub-agents in parallel (Hiroto/Architecture, Lucía/Financial, Renata/UI-Copy, Esther/Scope-JTBD), manual synthesis.
> **Output:** input for creating issues in GitHub during Step 7.

---

## Brutal TL;DR

**The code is better than it felt, and worse than it claimed.** The DDD architecture is solid; the LLM prompts comply with ADR-001; CI is green; ~94% coverage. But there are **3 real categories of damage** that block inviting the first beta friend:

1. **The P0 multi-currency is structural, not 2 lines.** The entire arithmetic core of the portfolio assumes single-currency USD. Eight calculators (Portfolio aggregates, HHI, Sharpe, TWR, period returns, dividends presenter, weekly insight, concentration) **lie mathematically** for a mixed MXN+USD portfolio. `Asset` has no `currency` column; `Trade` has no `fx_rate_at_execution`. **Adrian's dashboard, today, is meaningless arithmetic.**

2. **~25-28% of the code serves no canonical JTBD.** The entire LLM layer (Phase 22), advanced risk metrics, TWR vs benchmarks, HHI/concentration alerts, public landing with "50K traders" fake stats, public `/trends`, 3-step onboarding wizard. ~500+ specs maintain features without any documented personal trigger.

3. **The landing page lies to beta friends.** "Trusted by GlobalBank/DataCore/FinStream", "50K+ Active Traders", "$4.2B Assets Tracked" — invented clients and numbers. Fake testimonials. For a closed beta with ≤20 friends, this is **direct damage to Adrian's personal credibility**.

What's good: respectable DDD architecture (with 3-5 localizable leaks), LLM prompts already carry ADR-001 guardrails ("Never recommend buying, selling..."), shared components well factored, correct CETES yield math, empty states well implemented, clean brakeman.

---

## Prioritized action items (input for Step 7)

These become GitHub issues. Tentative labels in parentheses.

### 🔴 P0 — Blocks the first beta invite

| # | Action | Labels |
|---|---|---|
| 1 | **Multi-currency structural phase 1:** `Asset.currency`, `Trade.fx_rate_at_execution`, eliminate USD hardcode in `execute_trade.rb`, add `currency` to the contract | `P0`, `beta-blocker`, `ctx:trading`, `feat` |
| 2 | **Multi-currency structural phase 2:** refactor calculators currency-aware (Portfolio aggregates, HHI, Sharpe, TWR, period returns, dividends presenter, weekly insight) | `P0`, `beta-blocker`, `ctx:trading`, `refactor` |
| 3 | **CETES: maturity per position + expiry alerts** (JTBD #3 not implemented today) | `P0`, `ctx:trading`, `ctx:alerts`, `feat` |

### 🟠 P1 — Heavy cleanup before any new features

| # | Action | Labels |
|---|---|---|
| 4 | **Deprecate Phase 22 LLM layer entirely** — InsightGenerator, NewsSentimentAnalyzer, FundamentalHealthCheck, EarningsNarrativeGenerator, LlmGateway, anonymizer, 4 views, contracts, ai_insights table+model. ~134 specs, 12 commits. | `P1`, `chore`, `refactor` |
| 5 | **Remove public-audience surfaces** — landing with fake stats/clients, public `/trends`, /open-source page (downgrade), 3-step onboarding wizard. Root redirects to `/login`. | `P1`, `chore`, `ctx:identity` |
| 6 | **Archive non-JTBD advanced analytics** — Risk Metrics (Sharpe/Vol/MaxDD), TWR + benchmark vs indices, HHI Concentration analyzer + alerts, sentiment-based alerts. | `P1`, `chore`, `ctx:trading`, `ctx:alerts` |
| 7 | **Resolve Trading↔MarketData dashboard leak** — `assemble_dashboard` crosses directly. Options: (a) new `Dashboard`/`Composition` BC that orchestrates reads, (b) merge Trading+MarketData, (c) dedicated read model. Requires ADR-002. | `P1`, `refactor`, `ctx:trading`, `ctx:market-data` |

### 🟡 P2 — Code quality and ADR-001 discipline

| # | Action | Labels |
|---|---|---|
| 8 | **Event cleanup:** delete 11 zombie + 4 ghost events | `P2`, `chore` |
| 9 | **Rewrite landing copy** — no fake social proof, observational/honest tone about beta state. Applies to `sessions/new` (fake testimonial) and `registrations/new`. | `P2`, `docs`, `ctx:identity` |
| 10 | **Rewrite subtle prescriptive labels** — "Strong/Parabolic/Weak" → "High/Moderate/Low score"; "Upside/Downside" → "Target Δ%" | `P2`, `docs`, `ctx:market-data` |
| 11 | **Adopt semantic color tokens from `@theme`** — today 0 use of `bg-success/error/warning`, 189 hardcoded emerald/rose/amber/violet | `P2`, `refactor` |
| 12 | **Output validation against verb blacklist in LLM** — the prompt guardrail is hope, not guarantee. Only if the LLM layer survives action #4. | `P2` (depends on #4), `feat` |
| 13 | **Refactor trivial use cases** — 10-15 `update!`/`destroy!` wrapped in full `ApplicationUseCase` + Contract + Result. Proposal: `SimpleUseCase` or eliminate UC and call from controller. | `P2`, `refactor` |
| 14 | **Close/archive abandoned designs** — 4 folders in `designs/` without SPEC.md (PROCESSING.md workflow was ignored). Decide one by one. | `P2`, `docs` |

### 🟢 What we do NOT touch (validated by audit)

- DDD core architecture (6 BCs declared; localized leaks are tractable, not systemic chaos)
- LLM system prompts (if they survive #4): they already have explicit ADR-001 guardrails
- CETES yield math (`YieldCalculator` correct for the Mexican convention)
- Empty states + skeleton components
- Shared components (`_asset_badge`, `_sparkline`, `_donut_chart`)
- Auth with `has_secure_password` + sessions
- CI pipeline, brakeman, bundler-audit

---

## ADRs to write (from the findings)

- **ADR-002** — Trading + MarketData boundary (depends on action #7 decision)
- **ADR-003** — Sync vs async event handler criterion
- **ADR-004** — Notifications: BC vs shared library
- **ADR-005** — Cross-BC event ownership (who publishes `Identity::Events::UserSuspended`?)
- **ADR-006** — When NOT to use ApplicationUseCase (criterion for SimpleUseCase or controller-direct)
- **ADR-007** — Administration: own BC or cross-cutting admin layer?

---

## Sprint 2 candidate (proposal)

**Suggested goal:** *"Multi-currency MXN/USD working end-to-end: capture trade with FX at execution moment, consolidate correct gain/loss in MXN."*

**Tentative scope:** action items #1 + #2 (the two P0 multi-currency items). Probably 2 weeks.

**Not included in Sprint 2:** deprecations (#4-#6) — they come after; **nobody is invited until P0 is closed**.

---

## Audit structure

| File | Contents |
|---|---|
| `README.md` (this) | Executive summary + action items |
| [`inventory.md`](./inventory.md) | Raw inventory by BC, counts, listings |
| [`diagnosis.md`](./diagnosis.md) | Findings categorized with paths and lines |

---

## Brutal closing (synthesis from the 4 experts)

- **Hiroto:** *"It's not a broken project. It's a project over-architected for 20 users, with declared boundaries that aren't respected in the real code. The debt isn't technical, it's honesty: the code and the README tell different stories."*
- **Lucía:** *"The arithmetic core of the portfolio assumes USD and that makes the product, today, useless for its own owner. It's paradoxical that the project is called Stockerly and the owner has CETES as anchor, and CETES is not citizen-class."*
- **Esther:** *"The question isn't 'what else do we build'. The question is: 'what do we remove before inviting the first friend?'."*
- **Renata:** *"The Phase 22 backend does reflect the ADR. The frontend marketing copy seems to have been written before ADR-001 and never audited. Sync up."*

**My synthesis:** two focused sprints (fix P0 + heavy cleanup) and Stockerly can honestly open its first beta slot. Without those two sprints, inviting the first friend is inviting them to a dashboard that lies.
