## Repository
- Structure:
- Commands:
- Verification:
- Boundaries:

## Workflow
- Plan first unless implementation is explicit: create/update `docs/plans/PLAN-<YYMMDD>-<Title>.md` before edits
- Plan frontmatter: `status`, `type`, `specs`, optional `decisions`
- Status: `Draft`, `Active`, `Completed`, `Superseded`, `Abandoned`; type: `define`, `feature`, `change`, `refactor`
- Body: goal, context, approach, structure, data/contracts, decisions, risks, verification, handoff; keep open questions visible
- Keep implementation simple and scoped; avoid excessive, verbose, speculative, or over-engineered code
- Preserve behavior unless requested: inputs, outputs, side effects, order, errors
- Prefer guard clauses, clear names, simple conditionals, small responsibility splits, and real duplication removal
- Comments explain why; dead code needs confirmation

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
