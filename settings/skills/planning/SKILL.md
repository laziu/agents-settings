---
name: planning
description: Durable technical plans from ideas or requirements
---

# Planning

Turn specs or clear requirements into technical plans.

Use after `specification` or clear requirements when technical approach, structure, data, contracts, risks, or design decisions need durable form. Stay read-only and stop before task generation or implementation unless asked to continue.

## Plan
- Durable path: `docs/plans/PLAN-<YYMMDD>-<Title>.md`
- Scratch path only for temporary notes: project convention or `tasks/todo.md`
- Frontmatter: `status`, `type`, `specs`, optional `decisions`
- Status: `Draft`, `Active`, `Completed`, `Superseded`, `Abandoned`
- Type: `define`, `feature`, `change`, `refactor`
- Body: goal, context, technical approach, structure, data/contracts, decisions, risks, verification strategy, handoff
- Style: one idea per bullet; no implementation task list before `task-breakdown`

## Rules
- Resolve version-sensitive unknowns with `source-check`
- Record technical approach, data flow, contracts, risks, and verification strategy
- Use `interface-design` for public API, schema, command, event, or file-format contracts
- Use `task-breakdown` after the technical plan is stable enough to split into executable work
- Keep unresolved implementation questions visible; do not hide them in task text

## Verification
- Plan links relevant specs
