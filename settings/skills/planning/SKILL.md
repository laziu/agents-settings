---
name: planning
description: Write numbered Plans with ordered tasks and verification
---

# Planning

Turn specs or clear requirements into numbered Plans.

Use after `specification` or clear requirements when work needs sequencing, dependencies, risk control, or a durable execution record. Stay read-only and stop before implementation unless asked to continue.

## Process
1. Read spec and relevant code in read-only mode
2. Identify patterns, constraints, risks, unknowns
3. Map dependency graph
4. Sketch technical/data design only where useful
5. Slice vertically; put high-risk tasks early
6. Write tasks with acceptance, verification, dependencies, likely files, and size
7. Add checkpoints every 2-3 tasks or phase boundary

## Plan
- Durable path: `docs/plans/PLAN-0001-type-title.md`
- Scratch path only for temporary notes: project convention or `tasks/todo.md`
- Frontmatter: `status`, `type`, `specs`, `adrs`
- Status: `Draft`, `Active`, `Completed`, `Superseded`, `Abandoned`
- Type: `define`, `feature`, `change`, `refactor`
- Body: goal, context, useful technical/data design, ordered tasks, progress, verification, outcome
- Task fields: goal, acceptance, verification, dependencies, likely files, scope
- Style: one idea per task, acceptance item, and verification step

## Size Guide
- XS: one function/config
- S: 1-2 files, one endpoint/component
- M: 3-5 files, one feature slice
- L: 5-8 files, split when possible
- XL: 8+ files, split

Split further if a task exceeds one focused session, has >3 acceptance bullets, contains "and", or mixes independent subsystems.
Parallelize independent slices after shared contracts are stable.
Keep migrations and shared state sequential.

## Verification
- Every task has acceptance and verification
- Dependencies ordered
- No task exceeds ~5 files unless justified
- Checkpoints exist
- Plan links relevant specs and ADRs
