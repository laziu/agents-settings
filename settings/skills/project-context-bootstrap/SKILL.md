---
name: project-context-bootstrap
description: Install shared AI context for a repository
---

# Project Context Bootstrap

Install or refresh repo-local AI context. Keep personal workflow choices,
model assignments, and token strategy out of the target repo.

## Outputs
- Repo `AGENTS.md`, `CLAUDE.md`, or both, based on `assets/project-context-template.md`
- Optional `.agents/sourcemap/INDEX.md` and detail files when source navigation context is requested or useful

## Rules
- Read existing `AGENTS.md`, `CLAUDE.md`, `.agents/sourcemap/INDEX.md`, and project docs when present
- Default target: `AGENTS.md`; add `CLAUDE.md` only when requested or already used
- Merge without deleting unrelated rules or duplicating sections
- Keep repo-local facts: structure, commands, verification, boundaries, conventions
- Use `assets/project-context-template.md`; omit irrelevant sections and examples
- Inline borrowed skill guidance fully; generated repo context must not name local user skills or paths
- Include sourcemap only when `.agents/sourcemap/` exists or is created
- Sourcemap: group by roots/packages/features/flows; fields: covers, owns, paths, surface, notes

## Verification
- Sourcemap files are linked from `INDEX.md` when present
- Existing context was merged without deleting unrelated rules

## Maintenance
- Re-running this skill refreshes existing shared context without duplicating sections
- Do not install scripts or hooks by default
