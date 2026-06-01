# Spec Plan Task Workflow

Use when specs, numbered Plans, tasks, or promoted decisions are created or updated.

## Artifact Map

- Spec: current truth in `docs/specs/README.md` and `docs/specs/<subsystem>.md`
- Plan: technical design in `docs/plans/PLAN-0001-type-title.md`
- Task history: `## Tasks`, `## Progress`, `## Verification`, `## Outcome` inside the active Plan
- Decision: active Plan `## Decisions` by default; promote cross-Plan decisions to `docs/decisions/ADR-0001-title.md`
- Naming: plural `docs/specs`, `docs/plans`, `docs/decisions`; prefer `docs/decisions` over `docs/adrs`

## Planning Flow
- Use the sourcemap (see `settings/references/sourcemap.md`) to locate relevant source when `.agents/sourcemap/` exists
- Read actual source before making Plan claims about files, contracts, data flow, risks, or verification
- Keep unresolved source gaps or assumptions visible in the Plan

## Rules
- Update specs to the intended current state
- Prefer current specs over old Plans
- Do not rewrite completed Plans for new scope
- Record hard-to-reverse decisions in the active Plan; promote only decisions that outlive the Plan
- Create or update a numbered Plan before significant implementation work

## Plan Type
| Type | Use when |
| --- | --- |
| `define` | Initial system design or major direction reset |
| `feature` | Additive capability within current design |
| `change` | Intentional behavior/design change after a completed result |
| `refactor` | Structure cleanup preserving external behavior and interfaces |

Status: `Draft`, `Active`, `Completed`, `Superseded`, `Abandoned`

## Verification
- Relevant spec has goals, non-goals, acceptance criteria, and interface-impacting changes
- Significant execution work has a numbered Plan
- Ordered work has task breakdown with dependencies, checkpoints, and verification
- Hard-to-reverse decisions are recorded in the Plan or promoted with rationale
