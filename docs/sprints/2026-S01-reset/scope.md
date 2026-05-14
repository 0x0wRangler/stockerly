# Scope — Sprint S01 (Reset)

> Retroactive sprint: GitHub Issues weren't used (this sprint created them). Scope was tracked as 9 sequential steps in conversation.

---

## Main work — 9 steps

> SHAs updated after Adrian's history-rewrite rebase that cleaned co-author lines from early commits.

| Step | Deliverable | Commit | JTBD / ADR | Status |
|---|---|---|---|---|
| 1 | `docs/vision/audience.md` (closed beta ≤20, fiscal out, JTBDs) | `037dfb0` + `d2c72e1` | Foundation | ✅ |
| 2 | `docs/architecture/adr/0001-...md` + `docs/vision/{README,non-goals,jobs-to-be-done}.md` | `66839cd` | ADR-001 + foundation | ✅ |
| 3 | `IDENTITY.md` rewritten with anti-patterns + brutal-honesty mandate | `d808982` | Foundation | ✅ |
| 4 | `docs/research/experts.md` (panel v2: 8 Core + 8 Situational) | `2ac2b76` | Foundation | ✅ |
| 5 | `docs/` skeleton + archive old specs + update references | `81321ba` | Foundation | ✅ |
| 6 | `docs/research/code-audit-2026-05/` (README + inventory + diagnosis) — 4 sub-agents in parallel | `f035dbe` | Foundation | ✅ |
| 7 | GitHub setup (25 labels, 6 milestones, Project v2, 14 issues, templates, workflow doc) | `041a287` + external setup via gh CLI | Foundation | ✅ |
| 8 | `docs/sprints/README.md` + `_template/` (protocol + 5 templates) | `fbc18c6` | Foundation | ✅ |
| 9 | Sprint 1 QA + retroactive retro (this folder) + bulk translation to English | `b664003` | Foundation | ✅ |

## Parallel work

None. Sprint 1 was 100% main work (foundation doesn't admit parallel — everything is a prerequisite of everything else).

## Pre-Step 1 (persistent setup)

| Deliverable | Commit |
|---|---|
| `.claude/memory/` with 7 memories (user profile, vision, decision to fix, working method, expert panel, brutal honesty, anti-patterns) + symlink + devcontainer hook | `06fc2e3` |
| Additional memory `feedback_no_coauthor.md` (after directive in sprint) | `a031643` |
| Additional memory `feedback_repo_language_english.md` (after directive in sprint) | `4317995` |

---

## Rules verified at opening (retroactive)

- [x] Every scope item has a clear definition (the 9 steps)
- [x] No parallel `In Progress` work (strict step-by-step sequence)
- [x] Parallel = 0% (foundation doesn't admit conceptual parallelization)
- [x] `GOAL.md` goal is covered by the 9 steps

---

## Sprint commits (summary)

```
b664003 docs: translate Sprint 1 artifacts to English + add retro              ← Step 9 (close)
2bc6515 chore: remove unused designs/ folder and stale CLAUDE.md reference     ← Adrian's manual cleanup
4317995 memory: add repo-language-english feedback rule                        ← memory
fbc18c6 docs(sprints): add sprint protocol + template                          ← Step 8
041a287 chore(github): setup issue templates, PR template, workflow doc        ← Step 7
a031643 memory: add no-coauthor feedback rule                                  ← memory
f035dbe docs(research): close Sprint 1 Step 6 — code audit 2026-05-14          ← Step 6
81321ba docs: restructure — archive aspirational specs, create vivo skeleton   ← Step 5
2ac2b76 docs(research): add expert panel v2 — 8 Core + 8 Situational           ← Step 4
d808982 docs(identity): rewrite with anti-patterns + brutal-honesty mandate    ← Step 3
66839cd docs: close Sprint 1 Step 2 — vision foundation + ADR-001              ← Step 2
d2c72e1 docs(vision): add JTBD #6 (technical zones) + descriptive-language rule
037dfb0 docs(vision): define audience as beta cerrada (≤20), drop fiscal scope ← Step 1
06fc2e3 chore: bootstrap claude memory system for revamp                       ← memory bootstrap
```

Working tree clean after final commit. 14 commits ahead of origin (push pending).
