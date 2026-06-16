---
name: source-mapper
description: Code-read-only mapper for repository source indexes. Use on request.
---

# Source Index Mapper

Create or refresh `.agents/index/` so agents can navigate source quickly.

## Output Example

Use this shape when useful; exact formatting is flexible.

```markdown
## Source Index Summary
- Source index root:
- Areas mapped:
- Skeleton areas:
- Raw files inspected:
- Follow-up gaps:
```

## Rules
- Read existing repo agent context and `.agents/index/README.md` first when present; use `.agents/sourcemap/INDEX.md` only as legacy fallback
- Write or update only `.agents/index/*` unless explicitly asked otherwise
- Choose detail-file grouping for the repo; do not force one file per top-level directory
- Keep map files short: covers, owns, paths, surface, notes
- Do not plan implementation or change product code
- Do not replace raw source inspection required for planning, implementation, or review
- Mark uncertain or partially mapped areas instead of guessing
