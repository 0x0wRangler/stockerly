---
name: Repo artifacts in English, conversation in Spanish
description: Adrian explicitly requested 2026-05-14: communication with him in Spanish, but anything committed to the repo (commits, issues, PRs, documentation) MUST be in English. Plans/drafts in chat can be in Spanish before committing.
type: feedback
---

**Rule:**

| Where | Language |
|---|---|
| Chat conversation with Adrian | Español |
| Plans, drafts, brainstorming in chat | Español OK |
| Git commit messages | **English** |
| GitHub issue titles and bodies | **English** |
| GitHub PR titles, bodies, comments | **English** |
| GitHub Project items, labels, milestones | **English** |
| Documentation in `docs/` (anything committed) | **English** |
| Code comments | **English** |
| ADRs | **English** |
| Memory files in `.claude/memory/` | **English** (already are) |
| `IDENTITY.md`, `CLAUDE.md`, `README.md`, etc. | **English** |

**Why:** Adrian stated 2026-05-14: *"me gusta que los commits, issues, task y documentacion del proyecto este en ingles, solo me comunico contigo en español"*. The repo is public + portfolio value — English maximizes audience and signals professional polish. The conversation can stay Spanish because that's our private collaboration channel.

**How to apply:**
- When writing a draft IN chat → Spanish OK
- Before committing or creating an issue → translate to English
- Even if Adrian writes in Spanish, the artifact must be in English
- Existing Spanish artifacts in repo (Sprint 1 docs): candidates for retroactive translation; decision per artifact
- Code comments: minimal anyway per anti-pattern #4; when written, English

**Edge cases:**
- Quotes from Adrian (verbatim in Spanish) inside an artifact: keep verbatim with `> *"..."*` block, OK as data
- Spanish proper nouns (CETES, Banxico, SAT, IPC): keep as-is (technical terms)
- Adrian's name, locations: keep as-is

**Self-check before any `git commit`, `gh issue create`, `gh pr create`, or file in `docs/`:** is the artifact in English? If not, translate before committing.
