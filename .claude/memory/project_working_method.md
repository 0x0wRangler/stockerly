---
name: stockerly-working-method
description: "Source-of-truth split (GitHub for state-ful work, docs/ for evergreen). Sprint protocol with mandatory QA + retro. Discovery card required for every feature."
metadata: 
  node_type: memory
  type: project
  originSessionId: 9f04b1ac-0e2c-4edc-ba38-a17f9bcf8927
---

**Source of truth split (UNA fuente por tipo, nunca duplicar):**

| Type | Lives in |
|---|---|
| Vision, audience, JTBD, non-goals | `docs/vision/` |
| ADRs (architecture decisions) | `docs/architecture/adr/` |
| Design tokens, components catalog | `docs/design/` |
| Research notes, code audits | `docs/research/` |
| Expert panel | `docs/research/experts.md` |
| Sprint protocol (rules) | `docs/sprints/README.md` |
| Sprint retros (post-mortem) | `docs/sprints/<n>/retro.md` |
| **Backlog items (discovery cards)** | **GitHub Issues** |
| **Sprint board** | **GitHub Projects v2** ("Stockerly v2 Roadmap") |
| **Sprint goal** | **GitHub Milestone description** |
| **Bugs from beta** | **GitHub Issues** |

**Sprint protocol:**
- **Effort metric:** Claude session-hours (not calendar days). S1 ~10-12h, S2 ~20h, S3 ~12h (deletion-heavy), S4 ~18h (new-feature with pattern proximity). Calendar target is orientativo. Close trigger is QA + retro, not the date. Decided 2026-05-14 — Adrian works evenings/weekends with intense paired sessions, so calendar duration varies wildly while session-hours are comparable across sprints.
- **Estimation multiplier on raw hours** (updated post-S04 with 2 data points):
  - **1.2×** for deletion-heavy sprints (S03 came in at 12h vs 25h projected with 1.5×)
  - **1.3×** for new-feature sprints with a nearby existing pattern (S04 came in at 18h vs 28h projected with 1.5×)
  - **1.5×** reserved for greenfield work with no pattern to copy
- Goal: single sentence in milestone description, also in `docs/sprints/<n>/GOAL.md` (referenced from milestone, not duplicated)
- QA pass MANDATORY before close (manual smoke test, audit script, CI green, design audit)
- Retro post-close required (`docs/sprints/<n>/retro.md` — what worked / what didn't / what to change)
- No new sprint while previous sprint open (hard rule)
- **Sprint cadence is user-paced, not date-paced.** S03 retro suggested a 24h cool-off between sprints as default. Evaluated 2/2 transitions (S2→S3 and S3→S4): both overrode the rule. Pattern: Adrian decides when to open the next sprint. Do not write or follow a "default cool-off" rule.
- Max 7 issues "In Progress" simultaneously; if exceeded, stop opening new and close existing

**Discovery card (mandatory for every feature, via GH issue template):**
1. Trigger personal documentado (when did this need appear; what event)
2. JTBD ("When X, I want Y, so that Z")
3. Métrica de uso (how I'll know it works / gets used)
4. Definition of Done (concrete checklist)

Without all 4 → not built. No "Phase XX — TBD" entries permitted.

**Labels (in repo):**
- Type: `feat`, `bug`, `chore`, `docs`, `refactor`, `research`
- Context: `ctx:trading`, `ctx:market-data`, `ctx:alerts`, `ctx:identity`, `ctx:notifications`, `ctx:admin`
- Priority: `P0`, `P1`, `P2`
- State: `triage`, `ready`, `blocked`
- Special: `discovery-needed`, `beta-blocker`

**Project board columns:**
`Triage` → `Ready` → `In Sprint` → `In Progress` → `In Review` → `Done`

**Memory location:**
- Repo: `.claude/memory/` (tracked in git)
- Symlinked to Claude's expected path via `bin/setup-claude-memory`
- Runs automatically on devcontainer rebuild via `.devcontainer/post-create.sh`
- On host: user runs `bin/setup-claude-memory` once

**How to apply:**
- Route every work item to its single source of truth; refuse to duplicate
- Remind Adrian of protocol violations (open second sprint, skip QA, no retro, discovery-incomplete)
- When Adrian asks to "track this somewhere", route to the right place by type
