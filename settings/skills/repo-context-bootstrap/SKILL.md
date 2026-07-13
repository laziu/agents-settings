---
name: repo-context-bootstrap
description: Repo AGENTS, CLAUDE, and source-index bootstrap or refresh
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

## Verification
- Project Agent context points to `.agents/index/` when an index exists
- Existing context was merged without deleting unrelated rules

## Maintenance
- Re-running this skill refreshes existing shared context without duplicating sections
- Do not install scripts or hooks by default
