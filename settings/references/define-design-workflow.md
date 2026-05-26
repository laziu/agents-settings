# Spec, Plan, Task Workflow

Separate current truth, technical design, task history, and decision history.

## Artifacts
- Specs: current truth in `docs/specs/README.md` and `docs/specs/<subsystem>.md`; cover users, goals, non-goals, constraints, terms, requirements, acceptance, assumptions, and interface-impacting contracts
- ADRs: why history in `docs/decisions/ADR-0001-title.md`; required for hard-to-reverse architecture, dependency, or contract decisions
- Plans: technical design in `docs/plans/PLAN-0001-type-title.md`; record approach, structure, data, contracts, risks, ADR links, and verification strategy
- Tasks: execution history inside the active numbered Plan by default; record task order, dependencies, progress, verification, and outcome

Use plural `docs/specs`, `docs/decisions`, `docs/plans`. Prefer `docs/decisions` over `docs/adrs`.
Specs are stable and unnumbered. ADRs and Plans use one increasing number sequence per repo or project.

## Rules
- Update specs to the intended current state
- Prefer current specs over old Plans
- Do not rewrite completed Plans for new scope
- Supersede ADRs with new ADRs; keep history
- Fix spec mismatches and implementation errors inside the current task
- Create or update a numbered Plan before significant implementation work
- Run `task-breakdown` before implementation when work needs ordered tasks, dependencies, parallelism, or checkpoints
- Give every task acceptance criteria or independent verification

## Flow
1. Specify when direction, value, scope, MVP, Not Doing, requirements, boundaries, or acceptance need durable form
2. Plan when technical approach, repository structure, data, contracts, risk, or verification strategy needs durable form
3. Design Interface when public API, schema, command, event, or file format changes
4. Decide with ADR when a choice is hard to reverse or costly to revisit
5. Break down tasks when execution order, dependencies, parallelism, likely files, or checkpoints are needed
6. Implement from the task list or clear plan

## Plan Metadata
- Filename: `PLAN-0001-type-title.md`
- Type: `define`, `feature`, `change`, `refactor`
- Status: `Draft` not started; `Active` in progress; `Completed` verified; `Superseded` owned by newer Plan; `Abandoned` not executed

## Task Categories
The agent assigns categories by intent. Users do not invoke category names.

| Type | Use When | Required Inputs | Required Actions |
| --- | --- | --- | --- |
| Define | Initial system design or major direction reset | Raw goal, constraints, candidate approaches, affected subsystems | Specify problem, scope, MVP, Not Doing, and acceptance; update Spec Index and Subsystem Specs; add interface sections/specs; decide ADR need; create `PLAN-####-define-<title>.md` when technical design starts |
| Feature | Additive capability or user-visible behavior within current design | Goal, subsystem spec, affected interface, acceptance target, constraints | Confirm additive fit; use `interface-design` for contract changes; decide ADR need; create `PLAN-####-feature-<title>.md` before task breakdown |
| Change | Intentional behavior or design change after a completed result | Current and desired behavior/design, affected spec/interface, migration or compatibility concern | Update spec and interface sections; create ADR for breaking or hard-to-reverse decisions; create `PLAN-####-change-<title>.md` before task breakdown |
| Refactor | Structure cleanup preserving external behavior and interfaces | Target area, preserved behavior, risk, verification | Check public contract impact; reclassify as Change if behavior or external interfaces change; create `PLAN-####-refactor-<title>.md` when sequencing or risk control is needed |

## Verification
- Relevant spec exists and has goals, non-goals, acceptance criteria, and interface-impacting changes
- Hard-to-reverse decisions have ADRs
- Significant execution work has a numbered Plan
- Ordered work has task breakdown with dependencies, checkpoints, and verification
