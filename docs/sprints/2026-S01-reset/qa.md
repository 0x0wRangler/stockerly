# QA Pass — Sprint S01 (Reset)

> 100% docs/foundation sprint. Some template items don't apply (audit of new copy in views, etc.) — marked N/A with reason.

---

## Goal & scope

- [x] **Sprint goal achieved** — the 9 steps are all closed; foundation is in place
- [x] **All `main` scope issues** are closed — N/A for Sprint 1 (didn't use GitHub Issues; tracked as 9 sequential steps)
- [x] **Parallel issues** closed or explicitly deferred — N/A (parallel = 0% in this sprint)
- [x] **Unclosed issues**: N/A

## Code health

- [ ] `bundle exec rspec` green — **NOT executed in this sprint**. Reason: zero product code touched. Specs didn't change.
- [ ] `bin/rubocop` no offenses — **NOT executed**. Same reason.
- [ ] `bin/brakeman` no new warnings — **NOT executed**. Same reason.
- [ ] `bin/bundler-audit` no vulnerabilities — **NOT executed**. Same reason.
- [x] CI on GitHub Actions — last merge was `0cc005a` (pre-sprint), CI was green
- [x] Working tree clean, no forgotten commits

> **Decision:** this sprint didn't touch product code. CI/lint/security checks will run at the start of Sprint 2 before any code change.

## Vision compliance

- [x] **Manual audit of new copy** — N/A (no code changed). But **existing violations were identified** in `docs/research/code-audit-2026-05/diagnosis.md` for cleanup in S2/S6.
- [x] **Manual scope audit** — the 9 steps don't introduce product features; only foundation. Compatible with non-goals.
- [x] **JTBD mapping** — all steps map to "Foundation" (enabler, not direct JTBD). Justification in GOAL.md.
- [x] **Discovery card per item** — N/A (Sprint 1 didn't use issues with discovery cards; ESTABLISHES the format for subsequent sprints).

## Documentation

- [x] **ADR-001** written and formalized
- [x] **Vision created from scratch** (`docs/vision/{README,audience,non-goals,jobs-to-be-done}.md`)
- [x] **IDENTITY.md updated** with anti-patterns and brutal-honesty mandate
- [x] **Expert panel v2** published (`docs/research/experts.md`)
- [x] **Old specs archived** in `docs/archive/spec-2026-Q1/`
- [x] **CLAUDE.md updated** with new paths
- [x] **CONTRIBUTING.md, README.md, RELEASING.md, designs/wip/PROCESSING.md** updated with new references
- [x] **Persistent memory** established at `.claude/memory/` (9 files at close)
- [x] **Sprint protocol** published at `docs/sprints/README.md`
- [x] **GitHub workflow** published at `docs/ops/github-workflow.md`
- [x] **All Sprint 1 docs translated to English** (per language directive received mid-sprint)

## GitHub hygiene

- [x] **Labels** created (25 total with taxonomy)
- [x] **Milestones** created (S2-S7, empty for S7 until we get there) — descriptions in English
- [x] **Project v2** created and populated with 14 issues
- [x] **Initial issues** created with complete discovery cards (#27-#40), titles and bodies in English
- [x] **No orphan issues**

## Usage metric

Sprint 1 doesn't implement customer-facing JTBDs, so there's no feature usage metric. But there are work-system metrics:

| Metric | Expected | State |
|---|---|---|
| Sprint 2 can start without basic pending questions | ≥90% of S2 work unblocked | ✅ Verified — the 14 issues have everything needed |
| Adrian can ask me for something and I apply JTBD/ADR-001/anti-pattern filters | Visible application in next conversations | 🔄 Verify in S2 |
| Persistent memory survives devcontainer rebuild | Symlink recreated via post-create hook | ✅ Verified — `bin/setup-claude-memory` idempotent tested |

---

## Additional notes

- 4 expert sub-agents consulted (Hiroto, Lucía, Renata, Esther) in Step 6. Their reports are synthesized in `docs/research/code-audit-2026-05/diagnosis.md`. Decision: do NOT create separate ADRs ADR-002..ADR-007 yet — they'll be written on-demand when their corresponding blocked issues get addressed (#33 needs ADR-002, #38 needs ADR-006, etc.)

- `docs/research/experts.md` ended up at ~485 lines (post-translation). Anti-pattern #4 (doc bloat) marginally violated. Decision 2026-05-14: keep for Sprint 1, re-evaluate in Sprint 2 retro based on actual use.

- Mid-sprint Adrian issued the directive: "repo artifacts in English, conversation in Spanish". Forced a translation pass on all Sprint 1 docs + 14 issues + 6 milestones. Now reflected in `.claude/memory/feedback_repo_language_english.md` and the language section of IDENTITY.md.

- Working tree: ahead of origin. Adrian handles pushes himself (his rule).
