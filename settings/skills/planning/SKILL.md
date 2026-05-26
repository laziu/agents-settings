---
name: planning
description: Design technical plans from specs or clear requirements
---

# Planning

Turn specs or clear requirements into technical plans.

Use after `specification` or clear requirements when technical approach, structure, data, contracts, risks, or design decisions need durable form. Stay read-only and stop before task generation or implementation unless asked to continue.

## Process
1. Read spec and relevant code in read-only mode
2. Identify patterns, constraints, risks, unknowns
3. Resolve unknowns with source-check or short research when needed
4. Sketch technical approach, structure, data flow, and interfaces
5. Identify ADR candidates and migration or compatibility concerns
6. Define verification strategy and handoff notes for `task-breakdown`

## Plan
- Durable path: `docs/plans/PLAN-0001-type-title.md`
- Scratch path only for temporary notes: project convention or `tasks/todo.md`
- Frontmatter: `status`, `type`, `specs`, `adrs`
- Status: `Draft`, `Active`, `Completed`, `Superseded`, `Abandoned`
- Type: `define`, `feature`, `change`, `refactor`
- Body: goal, context, technical approach, structure, data/contracts, risks, ADR links, verification strategy, handoff
- Style: one idea per bullet; no implementation task list

## Handoff
- Use `interface-design` for public API, schema, command, event, or file-format contracts
- Use `architecture-decision` for hard-to-reverse architecture, platform, dependency, data ownership, or compatibility choices
- Use `task-breakdown` after the technical plan is stable enough to split into executable work
- Keep unresolved implementation questions visible; do not hide them in task text

## Verification
- Spec and relevant code were read
- Technical approach and constraints are explicit
- Data, contracts, and compatibility are covered when relevant
- ADR needs are recorded or ruled out
- Verification strategy and task-breakdown handoff are clear
- Plan links relevant specs and ADRs
