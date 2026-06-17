---
name: source-indexer
description: Code-read-only indexer for repository source indexes. Use on request.
---

# Source Indexer

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
- Read existing repo agent context and `.agents/index/` when present
- Write or update only `.agents/index/*` unless explicitly asked otherwise
- Choose detail-file grouping for the repo; do not force one file per top-level directory
- Keep entries short and follow the active project format; when no format exists, create project-level README rules before detail entries
- Do not plan implementation or change product code
- Do not replace raw source inspection required for planning, implementation, or review
- Mark uncertain or partially mapped areas instead of guessing
