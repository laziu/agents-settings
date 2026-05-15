---
name: planning
description: Split broad requirements into small tasks
---

# Planning and Task Breakdown

Turn requirements into small tasks with acceptance criteria, dependency order, and verification.

Use after `specification` or clear requirements. Stay read-only and stop before implementation unless asked to continue.

## Process
1. Read spec and relevant code in read-only mode
2. Identify patterns, constraints, risks, unknowns
3. Map dependency graph
4. Sketch technical design before tasks
5. Slice vertically where possible
6. Write tasks with acceptance criteria and verification
7. Add checkpoints every 2-3 tasks or phase boundary
8. Put high-risk tasks early

## Technical Plan Shape
Borrow TRD/ERD shape where useful:
- Technical design: architecture, components, interfaces/contracts, data flow, dependencies, risks
- Data design: entities, relationships, ownership, migrations when persistent/domain data changes
- Tasks: ordered slices with acceptance criteria and verification
- Omit formal sections that add no implementation value

Style: follow `AGENTS.md` Output Style; one idea per task, acceptance item, and verification step.

Save task docs only when requested or already tracked in-repo; default to `tasks/plan.md` or `tasks/todo.md`.

## Task Template
```markdown
## Task N: [title]
Description: [one paragraph]
Acceptance:
- [testable condition]
Verification:
- [command/manual check]
Dependencies: [task numbers or none]
Files likely touched:
- path
Scope: XS|S|M|L|XL
```

## Size Guide
- XS: one function/config
- S: 1-2 files, one endpoint/component
- M: 3-5 files, one feature slice
- L: 5-8 files, split when possible
- XL: 8+ files, split

Split further if a task exceeds one focused session, has >3 acceptance bullets, contains "and", or mixes independent subsystems. Parallelize independent slices after shared contracts are stable; keep migrations/shared state sequential.

## Verification
- Every task has acceptance and verification
- Dependencies ordered
- No task exceeds ~5 files unless justified
- Checkpoints exist
- Human reviewed plan before implementation when required
