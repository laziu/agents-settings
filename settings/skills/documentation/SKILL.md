---
name: documentation
description: README, API docs, changelogs, comments, and gotchas
---

# Documentation

Document useful context, not the obvious what.

## Boundaries
- Use `context-engineering` for agent instructions, skills, profiles, routing, or `settings/**/*.md`
- Avoid comments that restate code, stale TODOs, commented-out code, and throwaway prototype docs

## Content
- Comments: non-obvious intent, constraints, invariants, gotchas
- API docs: inputs, outputs, errors, examples; keep OpenAPI/Swagger current
- README: purpose, quick start, commands, architecture, process, links
- Changelog: Added/Changed/Fixed plus issue/PR references
- Project context: specs, Plan decision logs, promoted ADR links, gotchas

## Verification
- README can boot the project
- Public APIs are documented
- Known gotchas are near relevant docs or code
- No stale TODO/commented-out examples in touched docs
- Docs match current conventions
