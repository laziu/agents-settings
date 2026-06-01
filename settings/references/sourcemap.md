# Sourcemap Policy

Use when a task reads or changes source code and the repo has `.agents/sourcemap/`.

## Reading
- Read `.agents/sourcemap/INDEX.md` to find relevant source areas
- Read relevant map entries before opening source files
- Treat the sourcemap as navigation aid; use actual source as authority for Plans, implementation, and reviews
- If no sourcemap exists, proceed from raw source and mention the gap only when it affects the task

## Maintenance
- When code changes make an existing map entry stale, update that entry in the same change
- Adding a major source area requires a new or updated map entry and an `INDEX.md` link
- Removing a mapped source area requires removing or updating its map entry and `INDEX.md` link
- Keep map updates concise: covers, owns, paths, surface, notes

## Review
- Use the sourcemap to target source reads during review
- Stale sourcemap entries caused by touched code are review findings
