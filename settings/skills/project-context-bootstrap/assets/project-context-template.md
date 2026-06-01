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
- Dead code needs confirmation

## Sourcemap
- Location: `.agents/sourcemap/`; read `INDEX.md` first
- Source wins over maps; update stale entries and add/remove `INDEX.md` links with related code changes
- Group by roots, packages, features, or flows; keep entries short

```markdown
# <Area>
- Covers: <paths, packages, features, flows, or boundaries>
- Owns: <brief responsibility>
- Paths:
  - `path`: <why it matters>
- Surface: <APIs, routes, commands, events, or types>
- Notes: <gotchas, invariants, cross-area dependencies>
```
