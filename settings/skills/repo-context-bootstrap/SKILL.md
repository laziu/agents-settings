---
name: repo-context-bootstrap
description: Initialize or refresh a repo's Agent context, including AGENTS or CLAUDE files, a source index, and JetBrains IDE instruction links
---

# Repo Context Bootstrap

Install or refresh repo-local AI context. Keep personal workflow choices,
model assignments, and token strategy out of the target repo.

## Outputs
- Repo `AGENTS.md`, `CLAUDE.md`, or both, based on `assets/project-context-template.md`
- Optional `.agents/index/` when requested or already present

## Rules
- Read existing `AGENTS.md`, `CLAUDE.md`, `.agents/index/`, and project docs when present
- Default target: `AGENTS.md`; add `CLAUDE.md` only when requested or already used
- Merge without deleting unrelated rules or duplicating sections
- Keep repo-local facts: structure, commands, verification, boundaries, conventions
- Use `assets/project-context-template.md`; omit irrelevant sections and examples
- Generated repo context must not name profile-local Skills or paths; copy only target-repo rules that are actually required
- Create a source index only when requested; otherwise refresh it only when `.agents/index/` already exists
- Source index: follow existing project format first; read skill-local `references/source-index.md` before creating or redesigning one

## JetBrains IDE Links
JetBrains AI tools read no profile-level instructions. Only when the user uses them in the repo, link each path to the installed profile `AGENTS.md` (e.g., `~/.claude/AGENTS.md`):
- GitHub Copilot plugin: `.github/copilot-instructions.md`
- Junie: `.junie/guidelines.md`
- JetBrains AI Chat: `.ai/rules/harness.md`

These links are local-only: add them to `.git/info/exclude`, and report instead of replacing a path that already exists as a regular file.

## Verification
- Project Agent context points to `.agents/index/` when an index exists
- Existing context was merged without deleting unrelated rules

## Maintenance
- Re-running this skill refreshes existing shared context without duplicating sections
- Do not install scripts or hooks by default
