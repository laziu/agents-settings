## Repository
- Structure:
- Commands:
- Verification:
- Boundaries:

## Sourcemap
- Location: `.agents/sourcemap/`
- Use `INDEX.md` and linked entries to find relevant source
- Actual source is authority for Plans, implementation, and reviews
- Update stale entries when code changes affect mapped responsibility, paths, public surface, or notes
- Add/remove `INDEX.md` links when mapped areas are added or removed
- Keep entries short; choose grouping by source roots, packages, features, or flows

```markdown
# <Area>

Covers: <paths, packages, features, flows, or boundaries>

## Responsibility
<brief ownership summary>

## Key paths
- `path`: <why it matters>

## Public surface
<APIs, routes, commands, events, or types>

## Notes
<gotchas, invariants, cross-area dependencies>
```
