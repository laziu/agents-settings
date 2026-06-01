---
name: project-context-bootstrap
description: Install shared AI context for a repository
---

# Project Context Bootstrap

Install or refresh the repo-local AI context layer. Keep personal workflow
choices, model assignments, and token strategy out of the target repo.

## Outputs
- Repo `AGENTS.md`, `CLAUDE.md`, or both, based on `assets/project-context-template.md`
- Optional `.agents/sourcemap/INDEX.md` and detail files when source navigation context is requested or useful

## Steps
1. Inspect existing repo context
   - Read existing `AGENTS.md`, `CLAUDE.md`, `.agents/sourcemap/INDEX.md`, and project docs when present
   - Preserve unrelated project rules; merge into existing content without duplicating it
   - Default target context file: `AGENTS.md`; add `CLAUDE.md` only when requested or already used by the repo

2. Choose shared context
   - Keep repo-local facts: structure, commands, verification, generated boundaries, durable conventions
   - Include sourcemap rules only when `.agents/sourcemap/` is created or already used

3. Generate or refresh sourcemap when included
   - Map source roots, package boundaries, feature areas, generated-code boundaries, or important flows
   - Keep entries short; do not force one file per directory, package, or component
   - Read enough source to summarize responsibilities and entry points; do not transcribe implementation

4. Write context
   - Use `assets/project-context-template.md` as the source text
   - Omit irrelevant sections and examples
   - Merge without deleting unrelated project rules

5. Verify
   - Confirm generated sourcemap files are linked from `INDEX.md` when present
   - Confirm existing context was merged without deleting unrelated rules

## Maintenance
- Re-running this skill refreshes existing shared context without duplicating sections
- Do not install scripts or hooks by default
