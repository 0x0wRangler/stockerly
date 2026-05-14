# Historical archive — Stockerly

> ⚠️ **What's here is NOT the current source of truth.**
> Preserved for historical value and as reference for how Stockerly evolved. If a current decision contradicts something here, **the current decision wins** (in `docs/vision/` or `docs/architecture/adr/`).

---

## Why we archive instead of delete

1. **Product history.** The 22 phases completed between Phase 0 and Phase 22 have value as evidence of learning and as audit trail.
2. **Technical reference.** Some details (DB modeling, old commands) may be useful during code audits or when understanding why something is the way it is.
3. **Public portfolio.** Showing the journey (including corrections) is more valuable than showing only the final state.

---

## Contents

### `spec-2026-Q1/`

Aspirational project specifications at Q1 2026 close (just before the 2026-05-14 reset):

| File | Why it was archived |
|---|---|
| `PRD.md` | Described 3 personas (active trader, casual investor, admin) when the real user is one. Replaced by `docs/vision/audience.md` and `docs/vision/jobs-to-be-done.md`. |
| `TECHNICAL_SPEC.md` | 684-line tech spec detailing routes/layouts/partials/Stimulus controllers — mixed architecture with implementation detail. Live architectural content is in `docs/architecture/`. Implementation detail belongs in the code. |
| `COMMANDS.md` | 2163-line aspirational catalog of use cases, events, gateways. It was out of sync with real code (60 use cases cataloged vs 68 actual). Replaced by per-bounded-context READMEs (to be created in future sprints) and by the code itself as source. |
| `DATABASE_SCHEMA.md` | 1345-line DB modeling. The real source of truth is `db/schema.rb`. Maintaining a parallel doc was doc bloat. |
| `EXPERTS-v1.md` | Flat list of 10 experts. Replaced by `docs/research/experts.md` (8 Core + 8 Situational with triggers and operating rules). |

### `roadmap-phases-1-22.md`

Previously lived at the root as `ROADMAP.md`. It's the chronological record of the 22 phases completed through 2026-05-14. **It is not a future roadmap** — it's a history log. The current roadmap lives in GitHub (project milestones).

---

## How to translate something from the archive to current reality

| If you find in archive... | Its current equivalent is... |
|---|---|
| PRD "F-001: Landing Page" | Decision 2026-05-14: no commercial landing. See `docs/vision/non-goals.md`. |
| PRD "F-013: My Profile with editable avatar" | Live in code; audit pending Sprint 1 Step 6 |
| COMMANDS.md "Identity::Register" | Real code in `app/contexts/identity/use_cases/register.rb` |
| COMMANDS.md event catalogs | `config/initializers/event_subscriptions.rb` is the real source |
| TECHNICAL_SPEC "Bounded Contexts" | `docs/architecture/README.md` (updated map) |
| EXPERTS-v1 "QA Engineer" | EXPERTS-v2 (`docs/research/experts.md`) S8 Mehmet Karadeniz |
| ROADMAP "Phase 23 — TBD" | Doesn't exist. Sprint 1 replaces the "phases" model with sprints anchored to discovery cards. |

---

## How to add something to the archive

When a document in `docs/` stops reflecting reality and is replaced by another:

1. Move it to `docs/archive/<category>-<period>/`
2. Add a note at the end of this archive README explaining why
3. Search for references to the old doc and update them (grep)
4. Commit with explicit reason

---

## How to delete something from the archive

When a historical document stops having reference value:

- After 1+ year without consultation (quarterly audit)
- If its content was fully migrated to live docs
- If it compromises the public portfolio (e.g., mentions real credentials)

→ delete in an explicit commit with the reason. Git history preserves it anyway.
