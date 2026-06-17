## Repository
- Structure:
- Commands:
- Verification:
- Boundaries:

## Workflow
- Plan first unless implementation is explicit: create/update `docs/plans/<title>.md` before edits
- Plan frontmatter: `status`, `type`, `specs`, optional `decisions`
- Status: `Draft`, `Active`, `Completed`, `Superseded`, `Abandoned`; type: `define`, `feature`, `change`, `refactor`
- Body: goal, context, approach, structure, data/contracts, decisions, risks, verification, handoff; keep open questions visible
- Keep implementation simple and scoped; avoid excessive, verbose, speculative, or over-engineered code
- Preserve behavior unless requested: inputs, outputs, side effects, order, errors
- Dead code needs confirmation

## Source Index
- Location: `.agents/index/`
- Source, contracts, specs, tests, and build files outrank index entries
- The index root owns the project source index format and reading rules
- Update stale entries when paths, entry points, ownership, guardrails, or verification flow change
- Group by roots, packages, features, or flows; keep entries short
