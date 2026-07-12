---
name: planning
description: Durable technical design plans from stable requirements
---

# Planning

Use when stable requirements need a durable technical design. Stay read-only and stop before task generation or implementation unless asked to continue.

## Artifact

- Path: `docs/plans/<title>.md`; do not add a date or `PLAN-` prefix
- Frontmatter: `status`, `type`, optional `specs`, optional `decisions`
- Status: `Draft`, `Active`, `Completed`, `Superseded`, `Abandoned`
- Type: `define`, `feature`, `change`, `refactor`
- Body: goal, context, technical approach, structure, data or contracts, decisions, risks, verification strategy, and handoff
- Keep implementation tasks out until `task-breakdown`

## Verification

- Link relevant specs when they exist
- Keep unresolved design assumptions visible
- Record hard-to-reverse choices with `architecture-decision`
