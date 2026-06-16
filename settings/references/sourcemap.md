# Source Index Policy

Use when a task reads or changes source code and the repo has `.agents/index/` or legacy `.agents/sourcemap/`.

## Reading
- Read `.agents/index/README.md` to find relevant source areas
- If the new index is missing, read legacy `.agents/sourcemap/INDEX.md` when present
- Read relevant map entries before opening source files
- Treat the source index as navigation aid; use actual source as authority for Plans, implementation, and reviews
- If no source index exists, proceed from raw source and mention the gap only when it affects the task

## Maintenance
- New or refreshed entries live under `.agents/index/`
- When code changes make an existing index entry stale, update that entry in the same change
- Adding a major source area requires a new or updated entry and a `README.md` link
- Removing a mapped source area requires removing or updating its entry and `README.md` link
- Treat `.agents/sourcemap/INDEX.md` as legacy; migrate touched entries to `.agents/index/` when practical
- Keep map updates concise: covers, owns, paths, surface, notes

## Review
- Use the source index to target source reads during review
- Stale source index entries caused by touched code are review findings
