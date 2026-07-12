---
name: task-breakdown
description: Ordered implementation tasks from a stable technical plan
---

# Task Breakdown

Use when a stable spec and technical plan need ordered implementation work. Stay read-only and stop before implementation unless asked to continue.

## Artifact

- Append `## Tasks`, `## Progress`, `## Verification`, and `## Outcome` to the active `docs/plans/<title>.md`
- Use a separate `tasks.md` only when project convention requires it or the Plan becomes impractical
- Step heading: `### T01 <semantic step name> [ ]`
- Keep file actions nested under the semantic step
- Record dependencies, required manual work, and step-specific verification

## Verification

- Blocking work precedes dependents
- Each step is independently understandable and verifiable
- Manual work is explicit
