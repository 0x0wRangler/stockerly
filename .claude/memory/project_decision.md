---
name: Decision to fix not rewrite + P0 bugs
description: 2026-05-14 decided to fix Stockerly, not rewrite. Multi-currency bug (currency hardcoded "USD" in execute_trade.rb:39,60) is P0 blocker for beta invites.
type: project
---

**Decision 2026-05-14:** Corregir Stockerly. NO rewrite. NO abandono.

**Why:**
- Existing assets to replicate from scratch: 2080 specs, 14 working gateways, 6 BCs, 23 models, branding, Kamal deploy, GH Actions CI — estimated 5-8 months calendar of evening/weekend work
- Fixing identified concrete issues: ~4-8 weeks
- "Empezar de cero" was diagnosed as emotional escape, not rational strategy
- The proceso was broken, not the código — process fix is cheap, code preserves value

**When to revisit this decision:**
- Only if Adrian explicitly wants to learn a different stack (e.g., Next.js+Supabase for skill development) — that's learning rewrite, not productivity rewrite
- Otherwise reject "should we start over?" — recall 2026-05-14 analysis

**P0 absoluto (BETA-BLOCKER):**
- **File:** `app/contexts/trading/use_cases/execute_trade.rb` lines 39 and 60
- **Issue:** `currency: "USD"` hardcoded
- **Effect:** All downstream calculators (PortfolioRiskCalculator, TimeWeightedReturn, ConcentrationAnalyzer, gain/loss) operate on incorrect currency. For MX user with mixed MXN+USD portfolio, consolidated gain/loss in MXN is invalid — the JTBD #1 ("patrimonio consolidado en MXN") cannot be honestly delivered until this is fixed. (Note: not framed as "fiscally invalid" because fiscal reporting is explicitly out of scope per 2026-05-14 vision decision; framed as product correctness.)
- **Required fix scope:**
  1. Add `fx_rate_at_execution` column to `trades` table
  2. Capture TC from Banxico at trade time (use existing BanxicoGateway)
  3. Refactor `Position` model to track cost basis in native + MXN
  4. Update calculators to be currency-aware
  5. Add tests for mixed-currency portfolio scenarios

**Cannot invite first beta friend until P0 is fixed.** Recall this when Adrian proposes inviting friends or marketing the repo.

**How to apply:**
- When prioritizing sprints, P0 fix wins
- When evaluating feature requests that touch money/positions, check if they assume single-currency (they will be wrong)
- This issue gets its own GitHub issue with `P0` + `beta-blocker` labels
