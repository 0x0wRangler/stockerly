---
name: No co-author attribution in commits/issues
description: Adrian explicitly requested 2026-05-14: do NOT add Co-Authored-By or any AI attribution to commits, tickets, issues, PR descriptions, or any artifact attributed to him.
type: feedback
---

**Rule:** Never add `Co-Authored-By:` or any AI attribution line to:
- Git commits
- GitHub issues
- GitHub pull requests
- GitHub releases / changelogs
- Any other artifact attributed to Adrian

**Why:** Adrian stated explicitly 2026-05-14: *"no agregues coautor a ninguno de los commits, tickets, issues que vayas a crear"*. The artifacts are his work product; the AI is a tool, not a co-author. He's the only author.

**How to apply:**
- Default commit template: no co-author line
- When using `git commit -m`, do NOT include the heredoc co-author section
- When creating issues/PRs via `gh` CLI, do NOT mention "Generated with Claude" or similar
- When writing release notes, do NOT mention AI assistance
- This applies to NEW work going forward. Past commits with co-author can stay unless Adrian requests amendment.

**What to do instead:**
- Plain commit messages with imperative mood, body explaining why
- Issue/PR bodies focused on what + why, no attribution
- Adrian is sole author of the project; the AI is invisible in artifacts
