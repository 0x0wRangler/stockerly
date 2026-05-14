# Retro — Sprint S01 (Reset)

**Close date:** 2026-05-14
**Actual duration:** 1 continuous high-intensity session (~8-12h estimated Claude usage)
**Initial estimated duration:** 1-2 weeks calendar (evenings + weekends)
**Goal:** Reset the project foundation: honest vision, reorganized docs, expert panel, AI assistant self-critique as contract, code audit, GitHub setup, sprint protocol. Zero product code touched.

---

## What worked?

- **Pausing before building more.** The natural instinct was "let's fix multi-currency and keep going". Adrian made the opposite call: stop, define the north, archive the old, set up the method. This prevents redoing the 22 phases of drift with a drift v2.
- **Mutual brutal honesty.** Adrian explicitly asked for "no complacencies". That enabled hard critiques (to Adrian: rewrite is emotional escape; to me: violated anti-pattern #4 writing experts.md). Without that contract, this sprint would have been pretty-doc theater.
- **Expert sub-agents in parallel (Step 6).** Launching 4 simultaneous sub-agents (Hiroto, Lucía, Renata, Esther) took ~3 minutes calendar and produced 4 rich reports that a single agent (me) would have done with less rigor. Pattern to replicate.
- **2026-05-14 decision to fix, not rewrite.** Brutal analysis showed rewrite was emotional fantasy (5-8 months calendar vs 4-8 weeks for fix). Documenting the decision in memory prevents re-litigating it when temptation returns.
- **Step-by-step with explicit confirmation.** Each step requires "ok, go" or "make adjustments". Prevents auto-pilot. Adrian redirected several times (audience B+, no-coauthor, file-based memory in repo, English in repo) — the check-in discipline enabled it.
- **Persistent memory with symlink-survivor.** `.claude/memory/` in repo + symlink to Claude path + post-create hook = works on devcontainer rebuilds and on host. Verified idempotent.
- **English directive received mid-sprint, applied immediately + retroactively.** Language consistency in the public repo will pay off.

## What didn't work?

- **Doc bloat in `experts.md`.** Wrote 495 lines right after encoding anti-pattern #4 ("useful docs fit on one screen"). Mea culpa documented in chat + in commit. Kept for now but candidate for trim in S2 retro if not used.
- **Underestimated the scope of P0 multi-currency.** My initial proposal was "2 hardcoded lines in execute_trade.rb". Lucía's audit revealed it's structural: 8 calculators, `Asset` without currency, `Position#scope :domestic` USA-centric. **Calibration:** problems affecting arithmetic core are always larger than surface inspection suggests.
- **Sprint 1 has NO Milestone in GitHub.** Decided not to create `2026-S01-reset` as a milestone because GitHub setup was born in Step 7, retroactively. The retro lives only in `docs/`. From Sprint 2 onward, milestone exists before sprint starts.
- **Conversation too long in context.** This session has many accumulated messages and context is approaching limits. **Calibration:** Sprint 2 should be openable in a NEW session, with memory + docs loading everything needed. If not possible, undocumented drift exists.
- **Skipped `log.md`.** Decided not to create retroactive log because "no point reconstructing it". But the log IS the source for identifying mid-sprint decisions you took and forgot. Sprint 2 SHOULD fill log as it goes, not at the end.
- **Language directive landed mid-sprint, forcing bulk translation.** Should have asked about language preference earlier. Cost: ~1h of translation work. Future: surface preferences at sprint 1 opening.

## What to change for the next sprint?

- [ ] **Fill `log.md` during Sprint 2**, not at close. Note mid-sprint decisions as they happen.
- [ ] **Open Sprint 2 in a new session.** Trust the memory + docs system. If context is lost, that signals the system failed — correct before proceeding.
- [ ] **For P0 multi-currency: split into MORE sub-issues than the current 2 (#27 + #28).** With 8 calculators + schema changes + tests, there could be 4-6 better-scoped sub-issues. Decide at S2 start.
- [ ] **Audit re-read of `experts.md` after S2 retro.** If unused (neither mentally nor for spawning agents), trim to 100 lines or eliminate.
- [ ] **Audit script `script/audit-entropy.sh`** mentioned in original plan but not created. Create at S2 start as parallel work to have a measurable baseline.
- [ ] **Push to origin after retro.** Adrian handles it, but remember to mention it.
- [ ] **At each sprint opening, capture language/format/style preferences upfront** to avoid late retroactive changes.

---

## Vision alignment — state of the 6 axes

| # | Axis | Before (2026-05-14 8am) | After (2026-05-14 close) | Notes |
|---|---|---|---|---|
| 1 | Every feature maps to a JTBD | 0% (no documented JTBDs) | 30% (6 canonical JTBDs defined, mapping audit complete, ~25-28% of code identified as non-JTBD but NOT removed yet) | Rises strongly when S3 closes |
| 2 | Zero prescriptive copy in code | 0% (ADR-001 didn't exist) | 15% (ADR-001 written, violations identified, code NOT touched) | Rises when S6 closes |
| 3 | Zero aspirational fake copy | 0% (landing with fake stats, testimonials, institutions) | 10% (identified in audit; code intact) | Rises when #31 closes in S2 |
| 4 | Dashboard arithmetic truthful for MXN+USD | 0% (currency hardcoded USD, 8 calculators lying) | 5% (problem confirmed and sized; code intact) | Rises when #27 + #28 close in S2-S3 |
| 5 | Architecture without cross-context leaks | 20% (well-structured DDD existed but with 6 concrete leaks) | 25% (leaks identified with paths, candidate ADRs listed) | Rises when S5 closes |
| 6 | Docs reflect current code | 5% (PRD/COMMANDS/TECHNICAL_SPEC all out of sync) | 80% (old specs archived, live docs in `docs/vision`, `docs/architecture`, `docs/research`, `docs/ops`, `docs/sprints`) | Natural drop in future sprints if not maintained; raise audit to 95% at each sprint close |

**Synthesis:** axis #6 rises strongly (the foundation of the reset). Axes #1-#5 rise from 0-20% to 5-30% — all identified, none resolved in code. **Sprint 1 is an enabler, not a closer.**

---

## Anti-patterns I committed (if any)

> Reviewed against `.claude/memory/feedback_anti_patterns.md`.

- **#4 (Doc bloat) — VIOLATED**. Wrote 495 lines of `experts.md` right after codifying the rule "useful docs fit on one screen". Noted in chat at the moment, provisionally kept to evaluate in S2 retro.
- **#1 (Next phase = next thing to build) — NOT violated**. Each Sprint 1 step had an explicit trigger (Adrian asked X) and purpose mapped to foundation.
- **#2 (PRD as gospel) — NOT violated**. The old PRD was archived, not obeyed.
- **#3 (Patterns over pragmatism) — NOT violated**. Sprint 1 wrote no code.
- **#5 (Skipping foundational checks) — NOT violated**. Before proposing features, financial audit verified the base (P0 multi-currency).
- **#6 (Fragmenting redesigns without closing) — NOT violated**. Sprint 1 opens 0 redesigns; the visual redesign is scheduled for S2 Brand Discovery → S3-S6 incremental migration.
- **#7 (No retros / no audits) — ACTIVELY RESPECTED**. This file IS the retro. Sprint 2 inherits the discipline.

**Score:** 1 of 7 anti-patterns violated (marginal doc bloat). Acceptable for inaugural sprint; calibrate.

---

## Real vs estimated time

| Task / Step | Estimated | Real | Reason for deviation |
|---|---|---|---|
| Step 1 (audience.md) | 30 min | ~45 min | Iteration with Adrian over fiscal-out-of-scope changed the draft several times |
| Step 2 (vision + ADR-001) | 1h | ~1.5h | Defining ADR-001 required pushback against the "prescriptive hybrid" Adrian originally chose |
| Step 3 (IDENTITY.md) | 30 min | ~30 min | OK |
| Step 4 (experts.md) | 30 min | ~1h | Doc bloat — wrote more than necessary |
| Step 5 (skeleton + archive) | 1h | ~1h | OK |
| Step 6 (code audit with 4 sub-agents) | 1h | ~1h | Parallel sub-agents efficient |
| Step 7 (GitHub setup) | 1h | ~1.5h | gh CLI for 14 issues slower than expected |
| Step 8 (sprint protocol) | 30 min | ~30 min | OK |
| Step 9 (retro + bulk EN translation) | 30 min | ~1.5h | Bulk translation of 20 docs + 14 issues + 6 milestones, was unforeseen |
| **Total estimated** | ~7h | ~10-11h | ~50% over, with doc bloat + retroactive translation as main overhead |

**Calibration for S2:** I initially estimated P0 multi-currency at 1-2 weeks; with well-scoped sub-issues + confirmed structural scope, I calibrate to **2 firm weeks**.

---

## Registered decisions

ADRs written in this sprint:
- **ADR-001** — Stockerly speaks descriptively, never prescriptively ([`docs/architecture/adr/0001-...md`](../../architecture/adr/0001-descriptive-not-prescriptive-language.md))

Informal decisions (no ADR but registered):
- **Persistent memory lives at `.claude/memory/` in repo, tracked in git** — not at the Claude default system path. Survives devcontainer rebuilds.
- **No co-author in commits/issues/PRs** — Adrian's directive, applied from commit `a031643`.
- **Audience B+ (closed beta ≤20 invited friends)** — stronger than just "Adrian personal use".
- **Fiscal out of scope** — 2026-05-14 decision, removed fiscal emphasis from original vision.
- **GitHub Issues + Project v2 as source of truth** — backlog NOT in `docs/backlog/*.md` files (decision reversed from original plan after Adrian's input).
- **Roadmap of 6 sprints (S2-S7)** — each sprint closes 1 main alignment axis.
- **Complete visual redesign added to roadmap** — phase A discovery in S2, phase B incremental migration S3-S6, phase C coherent launch S6/S7.
- **Repo language: English everywhere committed; Spanish only in chat** — Adrian's directive, applied from commit `4317995` + retroactive translation.

Candidate ADRs identified but NOT written (will be written on-demand in subsequent sprints):
- ADR-002 — Trading + MarketData boundary (blocks #33)
- ADR-003 — Sync vs async event handlers
- ADR-004 — Notifications: BC vs library
- ADR-005 — Cross-BC event ownership
- ADR-006 — When NOT to use ApplicationUseCase (blocks #38)
- ADR-007 — Administration BC or admin layer

---

## Issues open at close

All initial project issues were created in this Sprint (`#27`-`#40`) and NONE were worked on in S1 (they all live in S2-S6 milestones). No orphan issues.

---

## Brutal quote of the sprint

> *"The code is better than it felt, and worse than it claimed. Sprint 1 built nothing new — it unblocked building well. A project's truth is in what the code does, not what the README promises. Sprint 1 reconciled the code with the truth."*
