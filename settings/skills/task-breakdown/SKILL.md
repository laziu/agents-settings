---
name: task-breakdown
description: Split plans into ordered executable tasks
---

# Task Breakdown

Turn a spec and technical plan into small, ordered, verifiable implementation tasks.

Use after `planning` or when requirements and technical approach are already clear. Stay read-only and stop before implementation unless asked to continue.

## Inputs
- Spec with user stories, requirements, acceptance, and success criteria
- Plan with technical approach, structure, data/contracts, risks, and verification strategy
- Optional design artifacts: `research.md`, `data-model.md`, `contracts/`, `quickstart.md`

## Process
1. Read the spec, plan, and relevant design artifacts
2. Extract user stories, priorities, contracts, entities, and shared setup
3. Create phases: setup, foundation, one phase per user story, then polish
4. Put blocking shared work before story work
5. Keep each story independently implementable and testable
6. Mark parallel tasks with `[P]` only when they touch different files and have no dependency
7. Add checkpoints after foundation and each user story

## Output
- Durable path: same feature or plan directory, usually `tasks.md`
- Task format: `- [ ] T001 [P?] [US?] Action in path/to/file`
- Include dependencies, parallel opportunities, independent test criteria, and MVP scope
- Include exact file paths when known
- Generate test tasks only when tests are requested, required by project policy, or needed as regression proof

## Size Guide
- XS: one function or config
- S: 1-2 files or one endpoint/component
- M: 3-5 files or one feature slice
- L: 5-8 files; split when practical
- XL: 8+ files; split

Split further when a task exceeds one focused session, has more than 3 acceptance bullets, mixes independent subsystems, or crosses unstable shared contracts.

## Verification
- Every task has a concrete action and file path when practical
- Dependencies are ordered
- Parallel markers are safe
- Each user story has independent verification
- No task exceeds about 5 files unless justified
- Checkpoints exist before implementation
