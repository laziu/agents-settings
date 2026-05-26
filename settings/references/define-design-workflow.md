# Spec Plan Task Workflow

Separate current truth, technical design, task history, and promoted decision history.

## Artifacts
- Specs: current truth in `docs/specs/README.md` and `docs/specs/<subsystem>.md`; cover users, goals, non-goals, constraints, terms, requirements, acceptance, assumptions, and interface-impacting contracts
- Decisions: active Plan `## Decisions` by default; promote only long-lived cross-Plan decisions to `docs/decisions/ADR-0001-title.md`
- Plans: technical design in `docs/plans/PLAN-0001-type-title.md`; record approach, structure, data, contracts, decisions, risks, and verification strategy
- Tasks: execution history inside the active numbered Plan by default; record task order, dependencies, progress, verification, and outcome

Use plural `docs/specs`, `docs/decisions`, `docs/plans`. Prefer `docs/decisions` over `docs/adrs`.
Specs are stable and unnumbered. Plans use one increasing number sequence per repo or project. ADRs use their own sequence only when promoted.

## Rules
- Update specs to the intended current state
- Prefer current specs over old Plans
- Do not rewrite completed Plans for new scope
- Record hard-to-reverse decisions in the active Plan; promote only decisions that outlive the Plan
- Supersede ADRs with new ADRs; keep history
- Create or update a numbered Plan before significant implementation work
- Run `task-breakdown` before implementation when work needs ordered tasks, dependencies, parallelism, or checkpoints
- Give every task acceptance criteria or independent verification

## Flow
1. Specify when direction, value, scope, MVP, Not Doing, requirements, boundaries, or acceptance need durable form
2. Plan when technical approach, repository structure, data, contracts, risk, or verification strategy needs durable form
3. Design Interface when public API, schema, command, event, or file format changes
4. Record Decisions in the Plan when a choice is hard to reverse or costly to revisit
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
| Define | Initial system design or major direction reset | Raw goal, constraints, candidate approaches, affected subsystems | Specify problem, scope, MVP, Not Doing, and acceptance; update Spec Index and Subsystem Specs; add interface sections/specs; record decision needs; create `PLAN-####-define-<title>.md` when technical design starts |
| Feature | Additive capability or user-visible behavior within current design | Goal, subsystem spec, affected interface, acceptance target, constraints | Confirm additive fit; use `interface-design` for contract changes; record decision needs; create `PLAN-####-feature-<title>.md` before task breakdown |
| Change | Intentional behavior or design change after a completed result | Current and desired behavior/design, affected spec/interface, migration or compatibility concern | Update spec and interface sections; record breaking or hard-to-reverse decisions; create `PLAN-####-change-<title>.md` before task breakdown |
| Refactor | Structure cleanup preserving external behavior and interfaces | Target area, preserved behavior, risk, verification | Check public contract impact; reclassify as Change if behavior or external interfaces change; create `PLAN-####-refactor-<title>.md` when sequencing or risk control is needed |

## Verification
- Relevant spec exists and has goals, non-goals, acceptance criteria, and interface-impacting changes
- Hard-to-reverse decisions are recorded in the Plan or promoted to ADR with rationale
- Significant execution work has a numbered Plan
- Ordered work has task breakdown with dependencies, checkpoints, and verification
