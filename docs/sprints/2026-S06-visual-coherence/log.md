# Log — Sprint S06 (visual-coherence)

> NON-trivial notes during execution. **Not a daily journal.** Only what you'd want to remember when reviewing this sprint in 6 months.

---

## 2026-05-15 — Opening: 24h-pause hard rule violated (knowingly)

Sprint S05 retro committed at 16:12 UTC. Sprint S06 opening commit at ~16:30 UTC. The protocol (`docs/sprints/README.md` hard rule #5, formal close step 5) requires a 24h pause between sprints to mitigate anti-pattern #1 ("next phase = next thing to build").

Adrian was given three options and explicitly chose "Abrir S06 ya, anotando la violación" with full visibility on the protocol rule. The decision is documented here for the retro to evaluate honestly: did the lack of pause cause scope creep, missed risks, or rushed discovery? Or was the context-warmth (S05 just-fresh) actually a net positive?

Mitigations applied:
- All three issues (#36, #37, #68) had their discovery cards complete BEFORE this session — no rushed discovery
- Multiplier calibration (1.2×) is locked per S05 retro, not invented mid-conversation
- Targets framed as deltas (per S05 retro action item), not round-number absolutes
- Scope and execution order discussed and signed off via AskUserQuestion before any file writes

If retro of S06 shows this was a real anti-pattern hit, the protocol stands and the 24h becomes non-negotiable in the future.

---

## 2026-05-15 — Issue #68 created at opening (components.md trim)

S05 retro flagged "components.md (821 lines, flagged S03/S04) still unreferenced — carry to S06 trim". Created at opening to keep the carry-over from rotting into a fifth sprint without action. Discovery card framing:

- The doc is NOT dead — it's actively linked from `brand.md` and `tokens.md`
- Most sections are now derivable from `app/views/shared/` (since S03-S05 implemented the catalog)
- Trim target: ≤200 lines OR split into 2-3 focused files
- Anti-scope explicitly forbids deleting the file or removing planned-but-unbuilt components

---

## 2026-05-15 — #37 moved from S04 milestone to S06 milestone; `parallel` label removed

#37 is a tracking issue spanning S03-S06 (per its discovery card). It stayed assigned to S04 milestone for historical reasons after that sprint closed. Moved to S06 since this is the final slice — convention is the tracking issue lives in the milestone where it closes.

Removed `parallel` label: in S06, #37 is one of three main pieces (not a side axis kept alive while a different main goal runs). The parallel label encodes "different theme from sprint main goal"; here the theme matches.

---

## 2026-05-15 — Opening commit will re-baseline cross-context-leaks metric

Per S05 retro carry-over (A), `script/audit-entropy.sh` cross-context-leaks regex catches sanctioned `MarketData::Queries::*.call` from Trading as if they were violations. Pre-fix baseline: 13. Post-fix expected: ~0-2 (real ADR-002 violations only, if any remain).

The fix is part of opening, not a separate issue, because:
- Single ~20-line commit on a script
- No app-code touched
- Without the fix, the S06 retro cannot honestly compare cross-context leaks before/after — the metric is currently lying
- S05 retro explicitly authorized "can land at S06 opening"

The actual fix-commit count and new baseline will be captured here once the commit lands.
