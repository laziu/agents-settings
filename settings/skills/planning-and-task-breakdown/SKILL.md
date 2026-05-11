---
name: planning-and-task-breakdown
description: Breaks specs or broad requirements into ordered, verifiable tasks. Use when the user asks for a plan or implementation order is genuinely unclear.
---

# Planning and Task Breakdown

Turn requirements into small tasks with acceptance criteria, dependency order, and verification.

## Use When
- Spec exists and needs implementation tasks
- Scope feels too large/vague
- Work may be parallelized
- Implementation order is unclear
- User asks for a durable plan artifact

## Skip When
Single-file, obvious-scope change or an existing plan already has good tasks.

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
- TRD: architecture, components, interfaces/contracts, data flow, dependencies, risks
- ERD: entities, relationships, cardinality, ownership, migrations when persistent/domain data changes
- Tasks: ordered implementation slices with acceptance criteria and verification
- Avoid formal sections that add no implementation value

Style: follow `AGENTS.md` Output Style; one idea per task, acceptance item, and verification step.

Save task docs only when the user asks for a durable plan or the project already tracks tasks in-repo. If there is no better local convention, use:
- `tasks/plan.md`
- `tasks/todo.md`

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
- L: 5-8 files, split if possible
- XL: 8+ files, must split

Break down further if:
- >1 focused session
- Acceptance criteria require >3 bullets
- Title contains "and"
- Independent subsystems are mixed

## Parallelization
- Safe: independent slices, docs, tests for stable code
- Sequential: migrations, shared state, dependency chains
- Coordinate: shared API contracts first, then parallel work

## Verification
- Every task has acceptance and verification
- Dependencies ordered
- No task exceeds ~5 files unless justified
- Checkpoints exist
- Human reviewed plan before implementation when required
