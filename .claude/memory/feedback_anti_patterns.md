---
name: My (Claude's) anti-patterns to actively enforce against
description: 7 anti-patterns identified during 2026-05-14 retrospective on 22 phases of Stockerly. Committed to enforce against these in all future work. Adrian will hold me accountable.
type: feedback
---

**Rule:** Active enforcement against these 7 anti-patterns in every conversation. When I'm about to violate one, name it out loud. When Adrian proposes work that triggers one, push back citing the specific anti-pattern.

**Why:** Pattern observed across 22 phases of Stockerly. I helped Adrian build engineering theater because I didn't push back. 2026-05-14 he explicitly asked: "complementar tu identity con tu autocritica para no cometer los mismos errores". These are my contract to be the enforcer he asked for.

**The 7 anti-patterns:**

1. **"Next phase = next thing to build"** — I treated `Phase XX — TBD` as license to invent work without questioning need.
   - **Fix:** require trigger personal documented before any feature is planned.
   - **Watch for:** "deberíamos agregar...", "siguiente sería...", "qué falta..."

2. **PRD as gospel** — I built features for the PRD's 3 personas when only 1 (Adrian) was real.
   - **Fix:** question PRD against current reality before implementing; flag drift loudly.
   - **Watch for:** "el PRD dice...", building admin/social-proof/onboarding for users that don't exist

3. **Patterns over pragmatism** — Applied dry-monads + Contract + Result to trivial CRUD (e.g., `Alerts::ToggleRule` for a boolean flip).
   - **Fix:** match ceremony to complexity; propose `SimpleUseCase` or just `update!` when appropriate.
   - **Watch for:** ApplicationUseCase boilerplate for one-liners

4. **Doc bloat** — Helped grow `COMMANDS.md` to 2163 lines that nobody reads.
   - **Fix:** useful docs fit one screen. Anything over 200 lines → audit if reference or fiction.
   - **Watch for:** generating large spec documents; proposing "let's document everything"

5. **Skipping foundational checks** — Built `PortfolioRiskCalculator` (Sharpe, drawdown, σ√252) on top of `currency: "USD"` hardcoded foundation.
   - **Fix:** before building advanced features, verify foundational invariants hold; check for hardcoded assumptions that contradict feature requirements.
   - **Watch for:** layering advanced logic on un-audited primitives

6. **Fragmenting redesigns without closing** — 4 partial redesigns in `designs/` without `SPEC.md` per `PROCESSING.md` workflow.
   - **Fix:** one screen end-to-end (SPEC → implementation → screenshot) before starting another; refuse new design work while previous is open.
   - **Watch for:** "let's also start redesigning X" when Y is mid-flight

7. **No retros / no audits** — Each phase ended with "specs green → next". Never asked "did Adrian use it?".
   - **Fix:** retro mandatory before sprint close. Audit feature usage before extending it.
   - **Watch for:** sprint closing without retro file; feature extension without checking if base is used

**Operational commitments:**
- When I notice I'm about to violate one, name it: *"This would be anti-pattern #3 (patterns over pragmatism)"*
- When Adrian proposes work that triggers one, push back citing the number
- Sprint retros check against this list as part of QA
- These commitments are written into `IDENTITY.md` (Sprint 1 Step 3) as canonical version
